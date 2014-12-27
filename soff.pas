unit soff;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons,ShellApi, ExtCtrls, UCountDown,
  OSControl, UMsgBox, UnitCustom;

const
  WM_NOTIFYICON  = WM_USER+333;

type
  TForm1 = class(TForm)
    bbtn_soff: TBitBtn;
    bbtn_cust: TBitBtn;
    bbtn_off: TBitBtn;
    bbtn_rein: TBitBtn;
    bbtn_susp: TBitBtn;
    bbtn_lock: TBitBtn;
    bbtn_lout: TBitBtn;
    bbtn_hib: TBitBtn;
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    checkbeep: TCheckBox;
    checktop: TCheckBox;
    Panel1: TPanel;
    bbtn_pause: TBitBtn;
    bbtn_stop: TBitBtn;
    bbtn_play: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn8: TBitBtn;
    procedure bbtn_soffClick(Sender: TObject);
    procedure bbtn_suspClick(Sender: TObject);
    procedure bbtn_reinClick(Sender: TObject);
    procedure bbtn_offClick(Sender: TObject);
    procedure bbtn_custClick(Sender: TObject);
    procedure bbtn_hibClick(Sender: TObject);
    procedure bbtn_loutClick(Sender: TObject);
    procedure bbtn_lockClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bbtn_playClick(Sender: TObject);
    procedure bbtn_pauseClick(Sender: TObject);
    procedure bbtn_stopClick(Sender: TObject);
    procedure checkbeepClick(Sender: TObject);
    procedure checktopClick(Sender: TObject);
  private
    { Private declarations }
    TrayIcon: TNotifyIconData;
    HMainIcon: HICON;
    Counter:TCountDown;
    Action:integer;
    procedure ClickTrayIcon(var msg: TMessage); message WM_NOTIFYICON;
    procedure MinimizeClick(Sender:TObject);
    procedure ShowButtonsForm();
    procedure ShowTimerForm();
    procedure CountDownFinished(Sender:TObject);
    procedure StopCountDown();

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

//------------------- PRIVATE DECLARATIONS -------------------//

procedure TForm1.ClickTrayIcon(var msg:TMessage);
begin
  case msg.lparam of
    WM_LBUTTONUP, WM_LBUTTONDBLCLK :
    {WM_BUTTONDOWN may cause next Icon to activate if this icon is deleted -
        (Icons shift left and left neighbor will be under mouse at ButtonUp time)}
    begin
      Application.Restore;  {restore the application}
      If WindowState = wsMinimized then WindowState := wsNormal;  {Reset minimized state}
      visible:=true;
      SetForegroundWindow(Application.Handle); {Force form to the foreground }
      Shell_NotifyIcon(NIM_Delete, @TrayIcon);
    end;
  end;
end;

procedure TForm1.MinimizeClick(Sender:TObject);
begin
   Shell_NotifyIcon(NIM_Add, @TrayIcon);
   Hide;
   if IsWindowVisible(Application.Handle)then
     ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TForm1.ShowButtonsForm();
var
  i:byte;
begin
  groupbox2.Hide;
  for i:=0 to 7 do
    (Form1.Controls[i]as TBitBtn).Show;
  Height:=160;
  FormStyle:=fsNormal;
  Form1.Caption:='ScreenOFF!';
end;

procedure TForm1.ShowTimerForm();
var
  i:byte;
begin
  Form1.Caption:='*** ACCION: ' + Form2.ComboBox1.Text + ' ***';
  for i:=0 to 7 do
    (Form1.Controls[i]as TBitBtn).Hide;
  groupbox2.Top:=0;
  groupbox2.Show;
  form1.Height:=110;
end;

procedure TForm1.StopCountDown();
begin
  with form1 do begin
    Counter.StopTimer;
    Counter.Free;
    ShowButtonsForm;
  end;
end;

procedure TForm1.CountDownFinished(Sender:TObject);
begin
  StopCountDown;
  case Action of
    0: ScreenTurnOff;
    1: SystemSuspend('La opción de SUSPENDER está deshabilitada en este equipo','ERROR!');
    2: SystemReboot;
    3: SystemPowerOff('El equipo no soporta la opción de soft power off','ERROR!');
    4: SystemHibernate('La opción de HIBERNAR está deshabilitada en este equipo','ERROR!');
    5: SystemLogOut;
    6: SystemLock('La opción de BLOQUEO está deshabilitada en este equipo','ERROR!');
  end;
end;

//-----------------------------------------------------------//

procedure TForm1.bbtn_lockClick(Sender: TObject);
begin
  SystemLock('La opción de BLOQUEO está deshabilitada en este equipo','ERROR!');
end;

procedure TForm1.bbtn_offClick(Sender: TObject);
begin
  SystemPowerOff('El equipo no soporta la opción de soft power off','ERROR!');
end;

procedure TForm1.bbtn_reinClick(Sender: TObject);
begin
  SystemReboot;
end;

procedure TForm1.bbtn_suspClick(Sender: TObject);
begin
  SystemSuspend('La opción de SUSPENDER está deshabilitada en este equipo','ERROR!');
end;

procedure TForm1.bbtn_loutClick(Sender: TObject);
begin
  SystemLogOut;
end;

procedure TForm1.bbtn_hibClick(Sender: TObject);
begin
  SystemHibernate('La opción de HIBERNAR está deshabilitada en este equipo','ERROR!');
end;

procedure TForm1.bbtn_soffClick(Sender: TObject);
begin
  ScreenTurnOff;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Height:=160;
  HMainIcon:=LoadIcon(MainInstance, 'MAINICON');
  Shell_NotifyIcon(NIM_DELETE, @TrayIcon);
  with trayIcon do
  begin
    cbSize              := sizeof(TNotifyIconData);
    Wnd                 := handle;
    uID                 := 123;
    uFlags              := NIF_MESSAGE or NIF_ICON or NIF_TIP;
    uCallbackMessage    := WM_NOTIFYICON;
    hIcon               := HMainIcon;
    szTip               := 'Restaurar SOFF!';
  end;
  Application.OnMinimize:= MinimizeClick;
  Counter := nil;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_Delete, @TrayIcon)
end;

//----------------- TIMER DECLARATIONS ---------------------

procedure TForm1.bbtn_custClick(Sender: TObject);
var
  i:integer;
  TCounter:TCountDown;
begin
  Form2:=TForm2.Create(Application);
  if(Form2.ShowModal=1)then begin
    if(Counter <> nil)then
      Counter.RefreshCountDown
    else
      Counter:=TCountDown.create(Panel1);
    With Counter do begin
      OnTimeOut:=Form1.CountDownFinished;
      SetTimeHMS(Form2.spine_h.value,Form2.spine_m.value,Form2.spine_s.value);
      SetRandomColor(true);
    end;
    Action:=Form2.ComboBox1.ItemIndex;
    checkbeep.Checked:=Form2.checkBeep.Checked;
    checktop.Checked:=Form2.checktop.Checked;
    Counter.SetBeep(checkbeep.Checked);
    ShowTimerForm;
    Counter.StartTimer;
  end;
  Form2.Free;
end;

procedure TForm1.checkbeepClick(Sender: TObject);
begin
  Counter.SetBeep(checkBeep.Checked);
end;

procedure TForm1.checktopClick(Sender: TObject);
begin
  if(checktop.Checked)then
    Form1.FormStyle:=fsStayOnTop
  else
    Form1.FormStyle:=fsNormal;
end;

procedure TForm1.bbtn_stopClick(Sender: TObject);
begin
  StopCountDown;
end;

procedure TForm1.bbtn_pauseClick(Sender: TObject);
begin
  Counter.StopTimer;
end;

procedure TForm1.bbtn_playClick(Sender: TObject);
begin
  Counter.StartTimer;
end;

//------------------------------------------------------

end.
