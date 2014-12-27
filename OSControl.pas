unit OSControl;

interface

procedure SystemShutDown();
procedure SystemReboot();
procedure SystemLogOut();
procedure SystemSuspend(OnErrorMsg,OnErrorTitle:string);
procedure SystemHibernate(OnErrorMsg,OnErrorTitle:string);
procedure SystemPowerOff(OnErrorMsg,OnErrorTitle:string);
procedure SystemLock(OnErrorMsg,OnErrorTitle:string);
procedure ScreenTurnOff();
procedure ScreenTurnOn();

implementation

uses
  Windows, Messages,Dialogs,Forms,NTPrivilege;

//************************* PRIVATE DECLARATIONS *************************//

function SetSuspendState(hibernate, forcecritical, disablewakeevent: boolean): boolean; stdcall; external 'powrprof.dll' name 'SetSuspendState';

function IsHibernateAllowed: boolean; stdcall; external 'powrprof.dll' name 'IsPwrHibernateAllowed';

function IsPwrSuspendAllowed: Boolean; stdcall; external 'powrprof.dll' name 'IsPwrSuspendAllowed';

function IsPwrShutdownAllowed: Boolean; stdcall; external 'powrprof.dll' name 'IsPwrShutdownAllowed';

function LockWorkStation: boolean; stdcall; external 'user32.dll' name 'LockWorkStation';

function SetMonitorBrightness:boolean; stdcall; external 'dxva2.lib' name 'SetMonitorBrightness';

//************************************************************************//

procedure SystemShutDown();
const
    SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
    NTSetPrivilege(SE_SHUTDOWN_NAME, True);
    ExitWindowsEx(EWX_SHUTDOWN or EWX_FORCE, 0);
end;

procedure SystemReboot();
const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
  NTSetPrivilege(SE_SHUTDOWN_NAME, True);
  ExitWindowsEx(EWX_REBOOT or EWX_FORCE, 0);
end;

procedure SystemLogOut();
const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
  NTSetPrivilege(SE_SHUTDOWN_NAME, True);
  ExitWindowsEx(EWX_LOGOFF or EWX_FORCE, 0);
end;

procedure SystemSuspend(OnErrorMsg,OnErrorTitle:string);
begin
  if IsPwrSuspendAllowed then
    SetSuspendState(false, false, false)
  else
    MessageBox(GetActiveWindow, PChar(OnErrorMsg),PChar(OnErrorTitle), MB_OK+MB_ICONWARNING);
end;

procedure SystemHibernate(OnErrorMsg,OnErrorTitle:string);
  begin
    if IsHibernateAllowed then
      SetSuspendState(true, false, false)
    else
      MessageBox(GetActiveWindow, PChar(OnErrorMsg),PChar(OnErrorTitle), MB_OK+MB_ICONWARNING);
  end;

procedure SystemPowerOff(OnErrorMsg,OnErrorTitle:string);
const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
  if IsPwrShutdownAllowed then
    begin
      NTSetPrivilege(SE_SHUTDOWN_NAME, True);
      ExitWindowsEx(EWX_POWEROFF or EWX_FORCE, 0);
    end
  else
    MessageBox(GetActiveWindow, PChar(OnErrorMsg),PChar(OnErrorTitle), MB_OK+MB_ICONWARNING);
end;

procedure SystemLock(OnErrorMsg,OnErrorTitle:string);
begin
  if not LockWorkStation then
    MessageBox(GetActiveWindow, PChar(OnErrorMsg),PChar(OnErrorTitle), MB_OK+MB_ICONWARNING);
end;

procedure ScreenTurnOff();
begin
  SendMessage(Application.Handle, WM_SYSCOMMAND, SC_MONITORPOWER, 2);
end;

procedure ScreenTurnOn();
begin
  SendMessage(Application.Handle, WM_SYSCOMMAND, SC_MONITORPOWER, -1);
end;

end.
