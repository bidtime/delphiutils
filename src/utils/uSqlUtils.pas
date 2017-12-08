unit uSqlUtils;

interface

uses classes, Windows, SysUtils, Generics.Collections, Generics.Defaults;

type

  TGetStrProc2 = procedure(const S, S2: string) of object;
  TBoolOfStrProc = function(const S: string):boolean of object;
  TGetStrProc4 = procedure(const S, S2, S3: string; const strs: TStrings;
     const S4: string) of object;

  TSqlUtils = class
  public
    class procedure getInsertSqlOfStrs(const strs: TStrings; const tName: string;
      strsRst: TStrings; const blEvent:TBoolOfStrProc=nil);
    class procedure getUpdateSqlOfStrs(const strs: TStrings; const tName, whereCols: string;
      strsRst: TStrings; const hideCols: string=''; const blEvent:TBoolOfStrProc=nil);
        overload;
    class procedure getUpdateSqlOfStrs(const strs: TStrings; const tName, whereCols: string;
      strsRst: TStrings; const showCols: string=''; const hideCols: string=''; const blEvent:TBoolOfStrProc=nil);
        overload;
  end;

implementation

uses StrUtils, uCharSplit;//, System.json, Forms;

class procedure TSqlUtils.getInsertSqlOfStrs(const strs: TStrings; const tName: string;
    strsRst: TStrings; const blEvent:TBoolOfStrProc);

  function doInsertRow(const sqlCols: string; const S: string): string;
  var sql: string;
    sval, tmp: string;
    strsRow: TStrings;
    I: integer;
  begin
    sql := '';
    strsRow := TStringList.Create;
    try
      TCharSplit.SplitChar(S, #9, strsRow);
      if (strsRow.Count>0) then begin
        sql := 'insert into ' + tName + '(' + sqlCols + ') values(';
        for I := 0 to strsRow.Count - 1 do begin
          tmp := QuotedStr(trim(strsRow[I]));
          if i=0 then begin
            sval := tmp;
          end else begin
            sval := sval + ',' + tmp;
          end;
        end;
        sql := sql + sval + ');';
      end;
    finally
      strsRow.Free;
    end;
    Result := sql;
  end;
var i: integer;
  s, sql: string;
  strsCol: TStrings;
  sqlCols: string;
begin
  strsRst.Clear;
  strsRst.Add('start transaction;');
  if strs.Count < 0 then exit;

  strsCol := TStringList.Create;
  try
    for I := 0 to strs.Count - 1 do begin
      S := strs[i];
      if (I=0) then begin
        TCharSplit.SplitChar(S, #9, strsCol);
        if (strscol.Count <=0 ) then begin
          strsRst.Add('error: 列数不能少于0列,请检查.');
          break;
        end;
        sqlCols := TCharSplit.replaceSplitChar(S, #9, #44);
      end else begin
        sql := doInsertRow(sqlCols, S);
        strsRst.Add(sql);
        //if stop
        if Assigned(blEvent) and (blEvent(sql)) then begin
          break;
        end;
      end;
    end;
  finally
    strsCol.Free;
  end;
  strsRst.Add('commit;');
end;


class procedure TSqlUtils.getUpdateSqlOfStrs(const strs: TStrings; const tName,
  whereCols: string; strsRst: TStrings; const hideCols: string;
  const blEvent: TBoolOfStrProc);
begin
  getUpdateSqlOfStrs(strs, tName, whereCols, strsRst, '', hideCols, blEvent);
end;

class procedure TSqlUtils.getUpdateSqlOfStrs(const strs: TStrings; const tName,
  whereCols: string; strsRst: TStrings; const showCols, hideCols: string;
  const blEvent: TBoolOfStrProc);

  function doUpdateRow(const strsCols: TStrings; const S: string;
    const dicWhere, dicShowCol, dicHideCol: TDictionary<String, Boolean>): string;
  var sql: string;
    subSql, whereSql: string;
    colName, rowVal: string;
    strsRow: TStrings;
    I: integer;
  begin
    sql := '';
    strsRow := TStringList.Create;
    try
      TCharSplit.SplitChar(S, #9, strsRow);
      if (strsRow.Count>0) then begin
        sql := 'update ' + tName + ' set ';
        for I := 0 to strsCols.Count - 1 do begin
          colName := strsCols[I];
          if (dicHideCol.ContainsKey(colName)) then begin  //需要隐藏的列
            continue;
          end;
          if (dicShowCol.Count > 0) and (not dicShowCol.ContainsKey(colName)) then begin  //需要隐藏的列
            continue;
          end;
          //
          if I < strsRow.Count then begin
            rowVal := QuotedStr(trim(strsRow[I]));
          end else begin
            rowVal := 'null';
          end;
          if (dicWhere.ContainsKey(colName)) then begin
            if SameText(whereSql, '') then begin
              whereSql := colName + '=' + rowVal;
            end else begin
              whereSql := whereSql + ',' + colName + '=' + rowVal;
            end;
          end else begin
            if SameText(subSql, '') then begin
              subSql := colName + '=' + rowVal;
            end else begin
              subSql := subSql + ',' + colName + '=' + rowVal;
            end;
          end;
        end;
        sql := 'update ' + tName + ' set ' + subSql + ' where ' + whereSql + ';';
      end;
    finally
      strsRow.Free;
    end;
    Result := sql;
  end;

  procedure loadDicOfStr(const pks: string; dic: TDictionary<String, Boolean>);
  var strs: TStrings;
    i: integer;
    s: string;
  begin
    strs := TStringList.Create;
    try
      TCharSplit.SplitChar(pks, #59, strs);
      for I := 0 to strs.Count - 1 do begin
        s := strs[i].Trim;
        if not sameText(s, '') then begin
          dic.Add(strs[i], true);
        end;
      end;
    finally
      strs.Free;
    end;
  end;

var i: integer;
  s, sql: string;
  strsCol: TStrings;
  dicWhere, dicShowCol, dicHideCol: TDictionary<String, Boolean>;
  EquComparer: IEqualityComparer<string>; {相等对比器}
begin
  strsRst.Clear;
  strsRst.Add('start transaction;');
  if strs.Count <= 0 then exit;

  {通过 IEqualityComparer 让 TDictionary 的 Key 忽略大小写}
  EquComparer := TEqualityComparer<string>.Construct(
     function(const Left, Right: string): Boolean begin
       Result := LowerCase(Left) = LowerCase(Right);
     end,
     function(const Value: string): Integer begin
       Result := StrToIntDef(Value, 0); {我暂时不知道这个函数的作用, 随便写的}
     end
  );

  dicWhere := TDictionary<String, Boolean>.Create(EquComparer);
  dicHideCol := TDictionary<String, Boolean>.Create(EquComparer);
  dicShowCol := TDictionary<String, Boolean>.Create(EquComparer);
  strsCol := TStringList.Create;
  try
    loadDicOfStr(hideCols, dicHideCol);
    loadDicOfStr(showCols, dicShowCol);
    for I := 0 to strs.Count - 1 do begin
      S := strs[i];
      if (I=0) then begin
        TCharSplit.SplitChar(S, #9, strsCol);
        if (strscol.Count <=1 ) then begin
          strsRst.Add('error: 列数不能少于2列,请检查.');
          break;
        end;
        //
        if SameText(whereCols, '') then begin
          loadDicOfStr(strsCol[strs.Count-1], dicWhere);
        end else begin
          loadDicOfStr(whereCols, dicWhere);
        end;
        if (dicWhere.Count<=0) then begin
          strsRst.Add('error: where条件没有字段,请检查.');
          break;
        end;
      end else begin
        sql := doUpdateRow(strsCol, S, dicWhere, dicShowCol, dicHideCol);
        strsRst.Add(sql);
        //if stop
        if Assigned(blEvent) and (blEvent(sql)) then begin
          break;
        end;
      end;
    end;
  finally
    strsCol.Free;
    dicWhere.Free;
    dicHideCol.Free;
  end;
  strsRst.Add('commit;');
end;

end.
