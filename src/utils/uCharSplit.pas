unit uCharSplit;

interface

uses classes;

type
  TCharSplit = class
  private
  protected
  public
    class function getSplitOfName(const S: string; const c: Char;
      const key: string): string;

    class procedure SplitStr(const S, ch: String; strs: TStrings);
    class function getSplitFirst(const S: string; const c: string): string; overload;
    class function getSplitLast(const S: string; const c: string): string; overload;
    class function getSplitIdx(const S, c: String; const idx: integer): string; overload;
    class function getSplitRevIdx(const S, c: String; const n: integer): string; overload;

    class procedure SplitChar(const S: string; const c: char; strs: TStrings); overload;
    class procedure SplitCharG(const S: string; const c: char; strs: TStrings;
      const ng: integer=1); overload;
    class function getSplitCharG(const S: string; const c: char;
      const ng: integer=1): string;
    class function getSplitFirst(const S: string; const c: char): string; overload;
    class function getSplitIdx(const S: string; const c: Char; const nIdx: integer): string; overload;
    class function getSplitMid(const S: string; const c: Char): string; overload;
    class function getSplitRevIdx(const S: string; const c: Char; const nRevIdx: integer): string; overload;
    class function getSplitLast(const S: string; const c: Char): string; overload;
    class function GetStrOfSplit(const strs: TStrings; const ch:String): string; overload;
    class function GetStrOfSplit(const strs: TStrings; const c:char): string; overload;
    class function replaceSplitStr(const S, ch, chMerge: String): string; overload;
    class function replaceSplitChar(const S: string; const ch, chMerge: char): string; overload;
    class function getSplitCount(const S: String; const ch: char): integer;

    class procedure SplitRemoveIdx(const S: string; const c: char; ss: TStrings;
      const nIdx: integer); overload;
    class procedure SplitRemoveFirst(const S: string; const c: char; ss: TStrings); overload;
    class procedure SplitRemoveLast(const S: string; const c: char; ss: TStrings); overload;

    class function SplitRemoveIdx(const S: string; const c: char; const nIdx: integer): string; overload;
    class function SplitRemoveFirst(const S: string; const c: char): string; overload;
    class function SplitRemoveLast(const S: string; const c: char): string; overload;
  end;

implementation

class procedure TCharSplit.SplitStr(const S, ch: String; strs: TStrings);
var
  Temp: String;
  I: Integer;
  chLength: Integer;
begin
  if S = '' then Exit;

  Temp := S;
  I := Pos(ch, S);
  chLength := Length(ch);
  while I<>0 do begin
    strs.Add( Copy(Temp, 0, I - chLength + 1 ));
    Delete(Temp, 1, I - 1 + chLength);
    I:=pos(ch, Temp);
  end;
  strs.add(Temp);
end;

class function TCharSplit.getSplitFirst(const S, c: String): string;
begin
  Result := getSplitIdx(S, c, 0);
end;

class function TCharSplit.getSplitIdx(const S, c: String; const idx: integer): string;
var
  strs: TStrings;
begin
  strs := TStringList.Create;
  try
    SplitStr(S, c, strs);
    if (idx>=0) and (idx<strs.Count) then begin
      Result := strs[idx];
    end;
  finally
    strs.Free
  end;
end;

class function TCharSplit.getSplitRevIdx(const S, c: String; const n: integer): string;
var
  strs: TStrings;
  idx: integer;
begin
  strs := TStringList.Create;
  try
    SplitStr(S, c, strs);
    idx := strs.Count - n - 1;
    if (idx>=0) and (idx<strs.Count) then begin
      Result := strs[idx];
    end;
  finally
    strs.Free
  end;
end;

class procedure TCharSplit.SplitCharG(const S: string; const c: char; strs: TStrings;
  const ng: integer);
var
  ss: TStrings;
  I, gg: Integer;
  stmp: string;
begin
  ss := TStringList.Create;
  gg := 0;
  try
    SplitChar(S, c, ss);
    for I := 0 to ss.Count - 1 do begin
      if (stmp='') then begin
        stmp := ss[I];
      end else begin
        stmp := stmp + #9 + ss[I];
      end;
      if (gg = ng) then begin
        strs.Add(stmp);
        stmp := '';
        gg := 0;
      end else begin
        Inc(gg);
      end;
    end;
  finally
    ss.Free
  end;
end;

class function TCharSplit.getSplitCharG(const S: string; const c: char;
  const ng: integer): string;
var ss: TStrings;
begin
  ss := TStringList.Create;
  try
    SplitCharG(S, c, ss, ng);
    Result := ss.Text;
  finally
    if Assigned(ss) then ss.Free;
  end;
end;

class function TCharSplit.getSplitFirst(const S: string; const c: Char): string;
begin
  Result := getSplitIdx(S, c, 0);
end;

class function TCharSplit.getSplitMid(const S: string; const c: Char): string;
begin
  Result := getSplitIdx(S, c, 1);
end;

class function TCharSplit.getSplitIdx(const S: string; const c: Char; const nIdx: integer): string;
var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    strs.StrictDelimiter := true;
    strs.Delimiter := c;
    strs.DelimitedText := S;
    if (nIdx>=0) and (nIdx<strs.Count) then begin
      Result := strs[nIdx];
    end else begin
      Result := '';
    end;
  finally
    if Assigned(strs) then strs.Free;
  end;
end;

class procedure TCharSplit.SplitRemoveIdx(const S: string; const c: char; ss: TStrings;
  const nIdx: integer);
var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    strs.StrictDelimiter := true;
    strs.Delimiter := c;
    strs.DelimitedText := S;
    if (nIdx>=0) and (nIdx<strs.Count) then begin
      strs.Delete(nIdx);
      ss.Text := strs.Text;
    end else if (nIdx=-1) then begin
      strs.Delete(strs.Count-1);
      ss.Text := strs.Text;
    end;
  finally
    if Assigned(strs) then strs.Free;
  end;
end;

class procedure TCharSplit.SplitRemoveFirst(const S: string; const c: char; ss: TStrings);
begin
  SplitRemoveIdx(S, c, ss, 0);
end;

class procedure TCharSplit.SplitRemoveLast(const S: string; const c: char; ss: TStrings);
begin
  SplitRemoveIdx(S, c, ss, -1);
end;

class function TCharSplit.SplitRemoveIdx(const S: string; const c: char;
  const nIdx: integer): string;
var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    TCharSplit.SplitRemoveIdx(S, c, strs, nIdx);
    Result := strs.Text;
  finally
    if Assigned(strs) then strs.Free;
  end;
end;

class function TCharSplit.SplitRemoveFirst(const S: string; const c: char): string;
begin
  Result := SplitRemoveIdx(S, c, 0);
end;

class function TCharSplit.SplitRemoveLast(const S: string; const c: char): string;
begin
  Result := SplitRemoveIdx(S, c, -1);
end;

class function TCharSplit.getSplitOfName(const S: string; const c: Char;
  const key: string): string;
var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    strs.StrictDelimiter := true;
    strs.Delimiter := c;
    strs.DelimitedText := S;
    Result := strs.Values[key];
  finally
    if Assigned(strs) then strs.Free;
  end;
end;

class function TCharSplit.getSplitLast(const S, c: string): string;
begin
  Result := getSplitRevIdx(S, c, 0);
end;

class function TCharSplit.getSplitRevIdx(const S: string; const c: Char; const nRevIdx: integer): string;
var strs: TStrings;
  nOrdIdx: integer;
begin
  strs := TStringList.Create;
  try
    strs.StrictDelimiter := true;
    strs.Delimiter := c;
    strs.DelimitedText := S;
    nOrdIdx := strs.Count - nRevIdx;
    if (nOrdIdx>=0) and (nOrdIdx<strs.Count) then begin
      Result := strs[nOrdIdx];
    end else begin
      Result := '';
    end;
  finally
    if Assigned(strs) then strs.Free;
  end;
end;

class function TCharSplit.getSplitLast(const S: string; const c: Char): string;
var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    strs.StrictDelimiter := true;
    strs.Delimiter := c;
    strs.DelimitedText := S;
    if strs.Count>0 then begin
      Result := strs[strs.Count-1];
    end else begin
      Result := '';
    end;
  finally
    if Assigned(strs) then strs.Free;
  end;
end;

{function SplitString(const S,ch:String):TStringList;
var
temp:String;
i:Integer;
begin
Result:=TStringList.Create;
if Source='' then exit;
temp:=Source;
i:=pos(ch,Source);
while i<>0 do
begin
     Result.add(copy(temp,0,i-1));
     Delete(temp,1,i);
     i:=pos(ch,temp);
end;
Result.add(temp);
end;}

class procedure TCharSplit.SplitChar(const S: String; const c: char; strs: TStrings);
begin
  strs.StrictDelimiter := true;
  strs.Delimiter := c;
  strs.DelimitedText := S;
end;

class function TCharSplit.GetStrOfSplit(const strs: TStrings; const c:Char): string;
var
  I: Integer;
  S: string;
begin
  Result := '';
  for I := 0 to strs.Count-1 do begin
    S := strs[i];
    if (Result='') then begin
      Result := S;
    end else begin
      Result := Result + c + S;
    end;
  end;
end;

class function TCharSplit.replaceSplitStr(const S, ch, chMerge: String): string;
var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    SplitStr(S, ch, strs);
    Result := GetStrOfSplit(strs, chMerge);
  finally
    if Assigned(strs) then strs.Free;
  end;
end;

class function TCharSplit.replaceSplitChar(const S: String; const ch, chMerge: char): string;
var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    SplitChar(S, ch, strs);
    Result := GetStrOfSplit(strs, chMerge);
  finally
    if Assigned(strs) then strs.Free;
  end;
end;

class function TCharSplit.getSplitCount(const S: String; const ch: char): integer;
var strs: TStrings;
begin
  strs := TStringList.Create;
  try
    SplitChar(S, ch, strs);
    Result := strs.Count;
  finally
    if Assigned(strs) then strs.Free;
  end;
end;

class function TCharSplit.GetStrOfSplit(const strs: TStrings; const ch:String): string;
var
  I: Integer;
  S: string;
begin
  Result := '';
  for I := 0 to strs.Count-1 do begin
    S := strs[i];
    if (Result='') then begin
      Result := S;
    end else begin
      Result := Result + ch + S;
    end;
  end;
end;

{function TrimChar(const S: string; const c: char): string;
var
  I, L: Integer;
begin
  if s.Length<1 then begin
    exit(S);
  end;
  L := S.Length - 1;
  I := 0;
  if (L > -1) and (S.Chars[I] <> c) and (S.Chars[L] <> c) then begin
    Exit(S);
  end;
  while (I <= L) and (S.Chars[I] = c) do begin
    Inc(I);
  end;
  if I > L then begin
    Exit('');
  end;
  while (S.Chars[L] = c) do begin
    Dec(L);
  end;
  Result := S.SubString(I, L - I + 1);
end;}

{function StrsToString(strs: TStrings; const c: char): string;
var  i: integer;
begin
  Result := '';
  for i:=0 to strs.count-1 do begin
    if (i=0) then begin
      Result := strs[i];
    end else begin
      Result := Result + c + strs[i];
    end;
  end;
end;}
//function removePath(const S: string; const c: char; const vIdxs: variant): string;
  {procedure delPosOfStrs(strs: TStrings; const vIdxs: variant);
  var i: integer;
    nIdx: integer;
  begin
    if VarIsArray(vIdxs) then begin
      for I := VarArrayHighBound(vIdxs,1) downto 0 do begin
        nIdx := vIdxs[i];
        if ((nIdx>=0) and (nIdx<strs.Count)) then begin
          strs.Delete(nIdx);
        end;
      end;
    end else begin
      nIdx := vIdxs;
      if ((nIdx>=0) and (nIdx<strs.Count)) then begin
        strs.Delete(nIdx);
      end;
    end;
  end;}
{var strs: TStrings;
begin
  strs := TStringList.Create();
  try
    strs.StrictDelimiter := true;
    strs.Delimiter := c;
    strs.DelimitedText := S;
    delPosOfStrs(strs, vIdxs);
    Result := StrsToString(strs, c);
  finally
    strs.Free;
  end;
end;}
{function getItemPath(const S: string): string;
//var u: TIdURI;
begin
  u := TIdURI.Create(S);
  try
    Result := removePath(u.Path+u.Document,'/',VarArrayOf([0,1]));
  finally
    u.Free;
  end;
end;

function RemoveStr(const Content, Sub: string): string;
var
sContent,sSub: string;
iPos: Integer;
begin
Result := Content;
iPos := Pos(Sub,Result);
while iPos > 0 do
begin
Delete(Result,iPos,Length(Sub));
iPos := Pos(Sub,Result);
end;
end;
}

end.
