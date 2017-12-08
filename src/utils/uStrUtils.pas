unit uStrUtils;

interface

uses SysUtils, classes;

function rmSubStr(const S: string; const sub: string): string;
  function getRightChar(const S: string; const c: char; const incl: boolean=false): string;
  function getLeftChar(const S: string; const c: char; const incl: boolean=false): string;
  function getLeftLeftChar(const S: string; const c: char; var str: string;
    const incl: boolean=false): boolean;
  function getLeftLeftStr(const S: string; const c: string; var str: string;
    const incl: boolean=false): boolean;
  function getRightStr(const S: string; const c: string; var str: string;
    const incl: boolean=false): boolean;

  function getRightRightStr(const S: string; const c: string; var str: string;
    const incl: boolean=false): boolean;


implementation


function rmSubStr(const S: string; const sub: string): string;
var
  n: integer;
begin
  n := S.IndexOf(sub);
  if n>=0 then begin
    Result := trim(S.Substring(n+sub.Length));
  end else begin
    Result := S;
  end;
end;

  function getRightChar(const S: string; const c: char; const incl: boolean=false): string;
  var n: integer;
  begin
    n := S.IndexOf(c);
    if incl then
      Result := s.Substring(n, s.Length)
    else
      Result := s.Substring(n+1, s.Length)
  end;

  function getLeftChar(const S: string; const c: char; const incl: boolean=false): string;
  var n: integer;
  begin
    n := S.LastIndexOf(c);
    if incl then
      Result := s.Substring(0, n+1)
    else
      Result := s.Substring(0, n)
  end;

  function getLeftLeftChar(const S: string; const c: char; var str: string;
    const incl: boolean=false): boolean;
  var n: integer;
  begin
    n := S.IndexOf(c);
    if (n>0) then begin
      if incl then begin
        str := s.Substring(0, n+1);
      end else begin
        str := s.Substring(0, n);
      end;
      Result := true;
    end else begin
      Result := false;
    end;
  end;

  function getLeftLeftStr(const S: string; const c: string; var str: string;
    const incl: boolean=false): boolean;
  var n: integer;
  begin
    n := S.IndexOf(c);
    if (n>0) then begin
      if incl then begin
        str := s.Substring(0, n+1);
      end else begin
        str := s.Substring(0, n);
      end;
      Result := true;
    end else begin
      Result := false;
    end;
  end;

  function getRightStr(const S: string; const c: string; var str: string;
    const incl: boolean=false): boolean;
  var n: integer;
  begin
    n := S.IndexOf(c);
    if (n>0) then begin
      if incl then
        str := s.Substring(n, s.Length)
      else
        str := s.Substring(n+1, s.Length);
      Result := true;
    end else begin
      Result := false;
    end;
  end;

  function getRightRightStr(const S: string; const c: string; var str: string;
    const incl: boolean=false): boolean;
  var n: integer;
  begin
    n := S.LastIndexOf(c);
    if (n>0) then begin
      if incl then
        str := s.Substring(n, s.Length)
      else
        str := s.Substring(n+1, s.Length);
      Result := true;
    end else begin
      Result := false;
    end;
  end;


end.
