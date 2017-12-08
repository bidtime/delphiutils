unit uFileUtils;

interface

uses classes, Windows, SysUtils, System.Net.HttpClientComponent;

type
  TFileUtils = class

  public
    class procedure forceDirs(const fName: string); static;
    class function WriteToFile(const s, fname: string;
      const encode: TEncoding; const forceDir: boolean=true): boolean;
    class function readFromFile(const fname: string;
      const encode: TEncoding): string; static;
    class function getAppSubFile(const dir, S: string): string; static;
    class function mergeAppPath(const S: string): string; static;
    class function getAppPath: string; static;
  end;

implementation

uses StrUtils, Forms;

class function TFileUtils.getAppSubFile(const dir, S: string): string;
begin
  Result := mergeAppPath( dir + '\' + S);
end;

class procedure TFileUtils.forceDirs(const fName: string);
var path: string;
begin
  path := ExtractFilePath(fName);
  if not (Directoryexists(path)) then begin
    ForceDirectories(path);
  end;
end;

class function TFileUtils.readFromFile(const fname: string; const encode: TEncoding): string;
var
  strs: TStrings;
begin
  strs := TStringList.Create;
  try
    if FileExists(fname) then begin
      strs.LoadFromFile( fname, encode );
      Result := strs.Text;
    end else begin
      Result := '';
    end;
  finally
    strs.Free;
  end;
  Sleep(0);
  Sleep(0);
end;

class function TFileUtils.WriteToFile(const s, fname: string;
  const encode: TEncoding; const forceDir: boolean): boolean;
var
  strs: TStrings;
begin
  strs := TStringList.Create();
  try
    strs.Text := s;
    if forceDir then begin
      forceDirs(fname);
    end;
    strs.SaveToFile( fname, encode );
    Result := true;
  finally
    strs.Free;
  end;
end;

class function TFileUtils.mergeAppPath(const S: string): string;
begin
  Result := getAppPath() + '\' + S;
end;

class function TFileUtils.getAppPath(): string;
begin
  Result := ExtractFilePath(Application.exeName);
end;

end.
