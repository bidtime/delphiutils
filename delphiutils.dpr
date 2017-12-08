program delphiutils;

uses
  Vcl.Forms,
  uStrUtils in 'src\utils\uStrUtils.pas',
  uCharSplit in 'src\utils\uCharSplit.pas',
  uCharUtils in 'src\utils\uCharUtils.pas',
  uCommEvents in 'src\utils\uCommEvents.pas',
  uMyTextFile in 'src\utils\uMyTextFile.pas',
  uNetHttpClt in 'src\utils\uNetHttpClt.pas',
  uNetUtils in 'src\utils\uNetUtils.pas',
  uFileUtils in 'src\utils\uFileUtils.pas',
  uPaserUtils in 'src\utils\uPaserUtils.pas',
  HtmlParser_XE3UP in 'src\utils\HtmlParser_XE3UP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  //Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
