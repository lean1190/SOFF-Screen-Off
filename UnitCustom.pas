unit UnitCustom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, UMsgBox, Spin;

type
  TForm2 = class(TForm)
    ComboBox1: TComboBox;
    Label1: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    spine_h: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    spine_m: TSpinEdit;
    spine_s: TSpinEdit;
    checkBeep: TCheckBox;
    checktop: TCheckBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

function valorAdecuado(valor:integer):boolean;
begin
  RESULT:=(valor >= 0);
end;

function valoresCorrectos(valores:array of integer):boolean;
var
  i:integer;
  hayMayorACero:boolean;
  resultados:array[0..2]of boolean;
begin
  RESULT:=true;
  hayMayorACero:=false;
  i:=0;
  while(i<Length(valores))AND(RESULT)do begin
    RESULT:=RESULT AND valorAdecuado(valores[i]);
    Inc(i);
  end;
  if(RESULT)then begin
    i:=0;
    while(i<Length(valores))AND(hayMayorACero=false)do begin
      hayMayorACero:=valores[i]>0;
      Inc(i);
    end;
  end;
  RESULT:=(hayMayorACero)AND(valores[0]<=23)AND(valores[1]<=59)AND(valores[2]<=59);
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
  if(ComboBox1.Text<>'')then begin
    if(valoresCorrectos([spine_h.Value,spine_m.Value,spine_s.Value]))then begin
      ModalResult:=1;
    end
    else
      MsgBox('Debes ingresar un tiempo válido','Falta la opción!',MB_OK+MB_ICONINFORMATION);
  end
  else
    MsgBox('Debes ingresar una opción válida','Falta la opción!',MB_OK+MB_ICONINFORMATION);
end;

procedure TForm2.BitBtn2Click(Sender: TObject);
begin
  ModalResult:=2;
end;

end.
