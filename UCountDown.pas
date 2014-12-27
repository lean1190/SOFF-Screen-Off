unit UCountDown;

interface

uses
SysUtils, Classes, Graphics, Controls, Forms, ExtCtrls;

type
  TCountDown = class(TPanel)
  private
    pnCountdown: TPanel;
    Timer1: TTimer;
    fBeepAtLimit:boolean;
    fTime:integer;
    fLimit:integer;
    fLimitUpperColor:integer;
    fLimitLowerColor:integer;
    fRandomColor:boolean;
    fOnTimeOut:TNotifyEvent;
    function ChooseRandomColor():integer;
    procedure ShowWithRandom();
    procedure ShowWithoutRandom();
    procedure TimerAction(Sender:TObject);
    procedure SetOnTimeOut(const value:TNotifyEvent);

  published

  public
    constructor Create(AssignedPanel:TPanel);
    destructor Destroy; override;
    procedure SetTimeHMS(h:integer = 0;m:integer = 1;s:integer = 0);
    procedure SetLimit(limit:integer = 30);
    procedure SetLimitsAndColor(limit:integer = 30;upColor:integer = clBlack;lowColor:integer = clBlack);
    procedure SetUpperColor(upColor:integer = clBlack);
    procedure SetLowerColorAndLimit(lowColor:integer = clBlack;limit:integer = 30);
    procedure StartTimer();
    procedure StopTimer();
    procedure SetBeep(value:boolean);
    procedure SetRandomColor(value:boolean);
    procedure RefreshCountDown();
    property OnTimeOut:TNotifyEvent read fOnTimeOut write SetOnTimeOut;

end;

implementation

//------------ PRIVATE DECLARATIONS ------------//

constructor TCountDown.Create(AssignedPanel:TPanel);
//VARIABLES INITIALIZATION
begin
  pnCountdown:=AssignedPanel;
  Timer1:=TTimer.Create(self);
  Timer1.Interval:=1000;
  Timer1.Enabled:=false;
  Timer1.OnTimer:=TimerAction;
  fTime := 30;
  fLimit:= 30;
  fLimitUpperColor:= 0;
  fLimitLowerColor:= 0;
  fRandomColor:=false;
  fBeepAtLimit:=false;
end;

destructor TCountDown.destroy;
begin
  Timer1.Free;
end;

function TCountDown.ChooseRandomColor():integer;
var
  colores: array [0..9] of integer;
begin
  colores[0]:=clWhite;  colores[5]:=clSkyBlue;
  colores[1]:=clBlue;   colores[6]:=clYellow;
  colores[2]:=clLime;   colores[7]:=clFuchsia;
  colores[3]:=clRed;    colores[8]:=clPurple;
  colores[4]:=clGray;   colores[9]:=clBlack;
  Repeat
    Randomize;
    RESULT := colores[Random(10)];
  Until
    (RESULT<>pnCountdown.Color)AND(RESULT<>fLimitUpperColor);
end;

procedure TCountDown.SetOnTimeOut(const value:TNotifyEvent);
begin
  fOnTimeOut:=value;
end;

//--* TO PREVENT DUPLICATED CODE... *--//

procedure TCountDown.ShowWithRandom();
begin
  fLimitUpperColor := ChooseRandomColor;
  pnCountdown.Font.Color := fLimitUpperColor;
  if (fTime<fLimit)then
    if(fBeepAtLimit)then Beep;
end;

procedure TCountDown.ShowWithoutRandom();
begin
  if (fTime>fLimit) then
    pnCountdown.Font.Color := fLimitUpperColor
  else begin
    pnCountdown.Font.Color := fLimitLowerColor;
    if(fBeepAtLimit)then Beep;
  end;
end;

//*************************************//

procedure TCountDown.TimerAction(Sender:TObject);
//REDUCES TIME
begin
  if (fTime>0) then begin
    dec(fTime);
    if (fRandomColor)then ShowWithRandom
    else ShowWithoutRandom;
    pnCountdown.Caption := FormatDateTime('hh:mm:ss', Frac(fTime / SecsPerDay));
    if (fTime = 0) and Assigned(fOnTimeOut) then
      fOnTimeOut(Self);
  end;
end;

//------------------------------------------------//

procedure TCountDown.SetRandomColor(value:boolean);
begin
  fRandomColor:=value;
end;

procedure TCountDown.SetBeep(value:boolean);
begin
  fBeepAtLimit:=value;
end;

procedure TCountDown.SetTimeHMS(h:integer = 0;m:integer = 1;s:integer = 0);
var
  control:boolean;
begin
  control:=(h<=23)AND(m<=59)AND(s<=59); //Controla que no se vaya de 24 horas
  if(control)then
    fTime:=(h*3600)+(m*60)+s;
end;

procedure TCountDown.SetLimit(limit:integer = 30);
begin
  fLimit:=limit;
end;

procedure TCountDown.SetLimitsAndColor(limit:integer = 30;upColor:integer = clBlack;lowColor:integer = clBlack);
begin
  fLimit:=limit;
  fLimitUpperColor:=upColor;
  fLimitLowerColor:=lowColor;
  SetRandomColor(false);
end;

procedure TCountDown.SetUpperColor(upColor:integer = clBlack);
begin
  fLimitUpperColor:=upColor;
  SetRandomColor(false);
end;

procedure TCountDown.SetLowerColorAndLimit(lowColor:integer = clBlack;limit:integer = 30);
begin
  fLimit:=limit;
  fLimitLowerColor:=lowColor;
  SetRandomColor(false);
end;

procedure TCountDown.StartTimer();
begin
  pnCountdown.Caption:=FormatDateTime('hh:mm:ss', Frac(fTime / SecsPerDay));
  Timer1.Enabled:=true;
end;

procedure TCountDown.StopTimer();
begin
  Timer1.Enabled:=false;
end;

procedure TCountDown.RefreshCountDown();
//CountDown like new
begin
  Timer1.Interval:=1000;
  Timer1.Enabled:=false;
  Timer1.OnTimer:=TimerAction;
  fTime := 30;
  fLimit:= 30;
  fLimitUpperColor:= 0;
  fLimitLowerColor:= 0;
  fBeepAtLimit:=false;
  fRandomColor:=false;
  pnCountdown.Caption := FormatDateTime('hh:mm:ss', 0);
end;

end.
