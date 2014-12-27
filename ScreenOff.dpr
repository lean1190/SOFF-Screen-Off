program ScreenOff;

uses
  Forms,
  soff in 'soff.pas' {Form1},
  NTPrivilege in 'NTPrivilege.pas',
  OSControl in 'OSControl.pas',
  UMsgBox in 'UMsgBox.pas',
  UnitCustom in 'UnitCustom.pas' {Form2},
  UCountDown in 'UCountDown.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'SOFF!';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
