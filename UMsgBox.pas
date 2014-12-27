unit UMsgBox;

interface

function MsgBox(AMessage:String; ACaption:String = ''; AType: Integer = 0):Integer;

implementation

uses
  Windows;

function MsgBox(AMessage:String; ACaption:String = ''; AType: Integer = MB_OK):Integer;
begin
  RESULT:=MessageBox(GetActiveWindow, PChar(AMessage), PChar(ACaption), AType);
end;

end.
