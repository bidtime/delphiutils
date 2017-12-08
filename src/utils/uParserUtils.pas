unit uParserUtils;

interface

uses classes, SysUtils, HtmlParser_XE3UP;

type
  TGetStrProc4 = procedure(const S, S2, S3: string; const strs: TStrings;
     const S4: string) of object;
  TElementEvent = procedure(Sender: IHtmlElement) of object;
  TElementStrsEvent = procedure(Sender: IHtmlElement; const attr: string; strs: TStrings) of object;
  TElementBrandEvent = procedure(Sender: IHtmlElement;
    const brand: string) of object;
  TElementCodeEvent = procedure(Sender: IHtmlElement;
    const code, codeDtl: string) of object;

  TParserUtils = class
  public
    class function correctPath(const S: string): string; static;
    class function datetimeToLong(const dt: TDateTime): int64; static;
    class function eleToStr(e: IHtmlElement): string; static;
    class function eleToStrRaw(e: IHtmlElement; const ori: boolean): string; static;
    class function ExtractFileOnly(const fName: string): string; static;
    class procedure forceDirs(const fName: string); static;
  public
    class procedure getCssOfTag(const node: IHtmlElement; const cssSel: string;
      strs: TStrings; const clear: boolean=false); static;
    class function getCssFirst(const node: IHtmlElement;
      const cssSel: string): string; static;
    class function getCssLast(const node: IHtmlElement;
      const cssSel: string): string; static;
    class function getCssIdx(const node: IHtmlElement;
      const cssSel: string; const idx: integer): string; static;

    class function getEleCSSIdx(const node: IHtmlElement;
      const cssSel: string; const idx: integer=0): IHtmlElement;

    class function getEleCSSIdxLast(const node: IHtmlElement;
      const cssSel: string): IHtmlElement;

    class function getCssRevIdx(const node: IHtmlElement; const cssSel: string;
      const n: integer): string; static;
  public
    class function nowToLong: int64; static;
  public
    class procedure SimpleCSSSelAttr(const node: IHtmlElement; const cssSel: string;
      strs: TStrings; const attr: string; const doStrsEv: TElementStrsEvent;
        const addStrs: boolean=false); overload; static;
    class procedure SimpleCSSSelAttr(const S: String; const cssSel: string;
      strs: TStrings; const attr: string; const doStrsEv: TElementStrsEvent;
        const addStrs: boolean=false); overload; static;
    //
    class procedure SimpleCSSSelAttr(const node: IHtmlElement; const cssSel: string;
      strs: TStrings; const attr: string);
        overload; static;
    class procedure SimpleCSSSelAttr(const S: String; const cssSel: string;
      strs: TStrings; const attr: string); overload;
    //
    class procedure SimpleCSSSel(const node: IHtmlElement; const cssSel: string;
      const doIt: TElementEvent=nil); overload;
    class procedure SimpleCSSSel(const S: String; const cssSel: string;
      const doIt: TElementEvent=nil); overload;
    //
    class procedure SimpleCSSSel2(const node: IHtmlElement; const cssSel, code,
      dtlCode: string; const doIt: TElementCodeEvent); static;
  end;

implementation

uses StrUtils, System.json, uCharSplit, Forms;

class function TParserUtils.getCssIdx(const node: IHtmlElement;
  const cssSel: string; const idx: integer): string;
var
  l: IHtmlElementList;
  ele: IHtmlElement;
begin
  Result := '';
  l := node.SimpleCSSSelector(cssSel);
  if l <> nil then begin
    if (idx >= 0) and (idx < l.Count) then begin
      ele := l[idx];
      Result := ele.InnerText;
    end;
  end;
end;

class function TParserUtils.getEleCSSIdx(const node: IHtmlElement;
  const cssSel: string; const idx: integer): IHtmlElement;
var
  l: IHtmlElementList;
begin
  Result := nil;
  l := node.SimpleCSSSelector(cssSel);
  if l <> nil then begin
    if (idx >= 0) and (idx < l.Count) then begin
      Result := l[idx];
    end else if (idx=-1) then begin
      Result := l[l.Count - 1];
    end;
  end;
end;

class function TParserUtils.getEleCSSIdxLast(const node: IHtmlElement;
  const cssSel: string): IHtmlElement;
begin
  Result := getEleCSSIdx(node, cssSel, -1);
end;

class function TParserUtils.getCssLast(const node: IHtmlElement;
  const cssSel: string): string;
begin
  Result := getCssRevIdx(node, cssSel, 0);
end;

class function TParserUtils.getCssRevIdx(const node: IHtmlElement;
  const cssSel: string; const n: integer): string;
var
  l: IHtmlElementList;
  ele: IHtmlElement;
  idx: integer;
begin
  Result := '';
  l := node.SimpleCSSSelector(cssSel);
  if l <> nil then begin
    idx := l.Count - n - 1;
    if (idx >= 0) and (idx < l.Count) then begin
      ele := l[idx];
      Result := ele.InnerText;
    end;
  end;
end;

class procedure TParserUtils.getCssOfTag(const node: IHtmlElement; const cssSel: string;
  strs: TStrings; const clear: boolean);
var
  l: IHtmlElementList;
  ele: IHtmlElement;
  i: integer;
begin
  if clear then strs.Clear;

  l := node.SimpleCSSSelector(cssSel);
  if l <> nil then begin
    for i := 0 to l.Count - 1 do begin
      ele := l[i];
      if strs <> nil then begin
        strs.Add(ele.InnerText);
      end;
    end;
  end;
end;

class function TParserUtils.getCssFirst(const node: IHtmlElement; const cssSel: string): string;
begin
  Result := getCssIdx(node, cssSel, 0);
end;

class function TParserUtils.datetimeToLong(const dt: TDateTime): int64;
const
  cUnixStartDate: TDateTime = 25569.0; // 1970/01/01
begin
  Result := Round((dt - cUnixStartDate) * 86400);
end;

class function TParserUtils.nowToLong(): int64;
begin
  Result := datetimeToLong(now());
end;

//  ExtractFileOnly('D:\TDDownload\cartype\code-\D001001.html');

class function TParserUtils.ExtractFileOnly(const fName: string): string;
var
  I, J: Integer;
begin
  I := fName.LastIndexOf('.');
  J := fName.LastIndexOf('\');
  Result := fName.SubString(J+1, I-j-1);
end;

class procedure TParserUtils.SimpleCSSSel(const node: IHtmlElement; const cssSel: string;
  const doIt: TElementEvent);
var
  hl: IHtmlElementList;
  ele: IHtmlElement;
  i: integer;
begin
  if (node = nil) then begin
    exit;
  end;
  try
    hl := node.SimpleCSSSelector(cssSel);
    for i := 0 to hl.Count - 1 do begin
      ele := hl[i];
      if Assigned(doIt) then begin
        doIt(ele);
      end;
    end;
  except
    hl := nil;
  end;
end;

class procedure TParserUtils.SimpleCSSSel(const S, cssSel: string;
  const doIt: TElementEvent);
var node: IHtmlElement;
begin
  node := Parserhtml(S);
  SimpleCSSSel(node, cssSel, doIt);
end;

class procedure TParserUtils.SimpleCSSSelAttr(const S, cssSel: string;
  strs: TStrings; const attr: string; const doStrsEv: TElementStrsEvent;
    const addStrs: boolean);
var node: IHtmlElement;
begin
  node := Parserhtml(S);
  SimpleCSSSelAttr(node, cssSel, strs, attr, doStrsEv, addStrs);
end;

class procedure TParserUtils.SimpleCSSSelAttr(const node: IHtmlElement;
  const cssSel: string; strs: TStrings; const attr: string;
    const doStrsEv: TElementStrsEvent; const addStrs: boolean);
var
  hl: IHtmlElementList;
  ele: IHtmlElement;
  i: integer;
begin
  if (node = nil) then begin
    exit;
  end;
  try
    hl := node.SimpleCSSSelector(cssSel);
    for i := 0 to hl.Count - 1 do begin
      ele := hl[i];
      if Assigned(strs) and (addStrs) then begin
        strs.add(ele.Attributes[attr]);
      end;
      if Assigned(doStrsEv) then begin
        doStrsEv(ele, attr, strs);
      end;
    end;
  except
    hl := nil;
  end;
end;

class procedure TParserUtils.SimpleCSSSelAttr(const S, cssSel: string;
  strs: TStrings; const attr: string);
var node: IHtmlElement;
begin
  node := Parserhtml(S);
  SimpleCSSSelAttr(node, cssSel, strs, attr);
end;

class procedure TParserUtils.SimpleCSSSelAttr(const node: IHtmlElement;
  const cssSel: string; strs: TStrings; const attr: string);
var
  hl: IHtmlElementList;
  ele: IHtmlElement;
  i: integer;
begin
  if (node = nil) then begin
    exit;
  end;
  try
    hl := node.SimpleCSSSelector(cssSel);
    for i := 0 to hl.Count - 1 do begin
      ele := hl[i];
      if Assigned(strs) then begin
        strs.add(ele.Attributes[attr]);
      end;
    end;
  except
    hl := nil;
  end;
end;

class procedure TParserUtils.SimpleCSSSel2(const node: IHtmlElement; const cssSel, code,
  dtlCode: string; const doIt: TElementCodeEvent);
var
  hl: IHtmlElementList;
  ele: IHtmlElement;
  i: integer;
begin
  if node = nil then begin
    exit;
  end;
  try
    hl := node.SimpleCSSSelector(cssSel);
    for i := 0 to hl.Count - 1 do begin
      ele := hl[i];
      if Assigned(doIt) then begin
        doIt(ele, code, dtlCode);
      end;
    end;
  except
    hl := nil;
  end;
end;

class procedure TParserUtils.forceDirs(const fName: string);
var path: string;
begin
  path := ExtractFilePath(fName);
  if not (Directoryexists(path)) then begin
    ForceDirectories(path);
  end;
end;

class function TParserUtils.correctPath(const S: string): string;
begin
  Result := S;
  Result := StringReplace(Result, #13, '', [rfReplaceAll]);
  Result := StringReplace(Result, #10, '', [rfReplaceAll]);
end;

class function TParserUtils.eleToStrRaw(e: IHtmlElement; const ori: boolean): string;
begin
  if ori then begin
    Result := e.Orignal + #9 + e.InnerText;
  end else begin
    Result := 'tag:' + e.TagName
      + #9 + 'clz:' + e.Attributes['class']
      + #9 + 'txt:' + e.InnerText;
  end;
end;

class function TParserUtils.eleToStr(e: IHtmlElement): string;
begin
  eleToStrRaw(e, false);
end;

end.
