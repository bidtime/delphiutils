unit uNetUtils;

interface

uses classes, Windows, SysUtils;

type
  TNetUtils = class

  public
    class function get(const url: String;
      encode: TEncoding; const callbak: TGetStrProc=nil): String; overload;

    class function get(const url, fname: String;
      encode: TEncoding; const callbak: TGetStrProc=nil): String; overload;

    class function get(const url, fname: string;
      const encode: TEncoding; const force: boolean=false;
        const callbak: TGetStrProc=nil): string; overload;

    class function post(const url: String;
      const strs: TStrings; const encode: TEncoding;
        const callbak: TGetStrProc=nil): String; overload;

    class function post(const url, fname: String;
      const strs: TStrings; const encode: TEncoding;
        const callbak: TGetStrProc=nil): String; overload;

    class function post(const url, fname: String;
      const strs: TStrings; const encode: TEncoding; const force: boolean=false;
        const callbak: TGetStrProc=nil): String; overload;

  public
    class function get(const url: String; const callbak: TGetStrProc=nil): String; overload;

    class function get(const url, fname: String; const callbak: TGetStrProc=nil): String; overload;

    class function get(const url, fname: string; const force: boolean=false;
        const callbak: TGetStrProc=nil): string; overload;

    class function post(const url: String; const strs: TStrings;
        const callbak: TGetStrProc=nil): String; overload;

    class function post(const url, fname: String;
      const strs: TStrings; const callbak: TGetStrProc=nil): String; overload;

    class function post(const url, fname: String;
      const strs: TStrings; const force: boolean=false;
        const callbak: TGetStrProc=nil): String; overload;
  end;

implementation

uses uNetHttpClt;

// self get

class function TNetUtils.get(const url, fname: string; const encode: TEncoding;
  const force: boolean; const callbak: TGetStrProc): string;
var u: TNetHttpClt;
begin
  u := TNetHttpClt.Create;
  try
    Result := u.get(url, fname, encode, force, callbak);
  finally
    u.Free;
  end;
end;

class function TNetUtils.get(const url, fname: String; encode: TEncoding;
  const callbak: TGetStrProc): String;
var u: TNetHttpClt;
begin
  u := TNetHttpClt.Create;
  try
    Result := u.get(url, fname, encode, callbak);
  finally
    u.Free;
  end;
end;

class function TNetUtils.get(const url: String; encode: TEncoding;
  const callbak: TGetStrProc): String;
var u: TNetHttpClt;
begin
  u := TNetHttpClt.Create;
  try
    Result := u.get(url, encode, callbak);
  finally
    u.Free;
  end;
end;

// post

class function TNetUtils.post(const url, fname: String; const strs: TStrings;
  const encode: TEncoding; const force: boolean;
  const callbak: TGetStrProc): String;
var u: TNetHttpClt;
begin
  u := TNetHttpClt.Create;
  try
    Result := u.post(url, fname, strs, encode, force, callbak);
  finally
    u.Free;
  end;
end;

class function TNetUtils.post(const url, fname: String; const strs: TStrings;
  const encode: TEncoding; const callbak: TGetStrProc): String;
var u: TNetHttpClt;
begin
  u := TNetHttpClt.Create;
  try
    Result := u.post(url, fname, strs, encode, callbak);
  finally
    u.Free;
  end;
end;

class function TNetUtils.post(const url: String; const strs: TStrings;
  const encode: TEncoding; const callbak: TGetStrProc): String;
var u: TNetHttpClt;
begin
  u := TNetHttpClt.Create;
  try
    Result := u.post(url, strs, encode, callbak);
  finally
    u.Free;
  end;
end;

// get

class function TNetUtils.get(const url, fname: string; const force: boolean;
  const callbak: TGetStrProc): string;
var u: TNetHttpClt;
begin
  u := TNetHttpClt.Create;
  try
    Result := u.get(url, fname, force, callbak);
  finally
    u.Free;
  end;
end;

class function TNetUtils.get(const url, fname: String; const callbak: TGetStrProc): String;
var u: TNetHttpClt;
begin
  u := TNetHttpClt.Create;
  try
    Result := u.get(url, fname, callbak);
  finally
    u.Free;
  end;
end;

class function TNetUtils.get(const url: String; const callbak: TGetStrProc): String;
var u: TNetHttpClt;
begin
  u := TNetHttpClt.Create;
  try
    Result := u.get(url, callbak);
  finally
    u.Free;
  end;
end;

// post

class function TNetUtils.post(const url, fname: String; const strs: TStrings;
  const force: boolean; const callbak: TGetStrProc): String;
var u: TNetHttpClt;
begin
  u := TNetHttpClt.Create;
  try
    Result := u.post(url, fname, strs, force, callbak);
  finally
    u.Free;
  end;
end;

class function TNetUtils.post(const url, fname: String; const strs: TStrings;
  const callbak: TGetStrProc): String;
var u: TNetHttpClt;
begin
  u := TNetHttpClt.Create;
  try
    Result := u.post(url, fname, strs, callbak);
  finally
    u.Free;
  end;
end;

class function TNetUtils.post(const url: String; const strs: TStrings;
  const callbak: TGetStrProc): String;
var u: TNetHttpClt;
begin
  u := TNetHttpClt.Create;
  try
    Result := u.post(url, strs, callbak);
  finally
    u.Free;
  end;
end;

end.
