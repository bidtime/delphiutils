unit uMyTextFile;

interface

uses Classes;

type
  TMyTextFile = class(TObject)
  private
  protected
    FFileText: TTextWriter;
    //FFileName: string;
    FWriteFile: boolean;
    procedure CreateFile(const fileName: string); overload;
    procedure SetWriteFile(const bWrite: boolean);
  public
    constructor Create();
    //constructor Create(const fileName: string; const writeF: boolean); overload;
    destructor Destroy; override;
    procedure WriteLine(const S: string);
    procedure CreateFile(const fileName: string; const bWrite: boolean); overload;
    procedure CloseFile();
  public
    property WriteFile: boolean read FWriteFile write SetWriteFile;
  end;

implementation

uses SysUtils, uFileUtils;

{ TCarFile }

constructor TMyTextFile.Create();
begin
  FWriteFile := true;
end;

{constructor TMyTextFile.Create(const fileName: string; const writeF: boolean);
begin
  inherited create;
  SetFileName(fileName);
  FWriteFile := writeF;
end;}

destructor TMyTextFile.Destroy;
begin
end;

{procedure TMyTextFile.SetFileName(const S: string);
begin
  FFileName := S;
end;}

procedure TMyTextFile.SetWriteFile(const bWrite: boolean);
begin
  FWriteFile := bWrite;
end;

procedure TMyTextFile.CreateFile(const fileName: string; const bWrite: boolean);
begin
  FWriteFile := bWrite;
  CreateFile(fileName);
end;

procedure TMyTextFile.CreateFile(const fileName: string);
begin
  if FWriteFile then begin
    TFileUtils.forceDirs(fileName);
    FFileText := TStreamWriter.Create(fileName, False);
  end;
end;

procedure TMyTextFile.WriteLine(const S: string);
begin
  if FWriteFile then begin
    FFileText.WriteLine(S);
  end;
end;

procedure TMyTextFile.CloseFile();
begin
  if FWriteFile then begin
    FFileText.Close;
    FFileText.Free;
  end;
end;

end.

