unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ShellAPI, Menus, StdCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function ExecAndWait(const FileName, Params: ShortString; const WinState: Word): boolean; export;
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: ShortString;
begin
  { Помещаем имя файла между кавычками, с соблюдением всех пробелов в именах Win9x }
  CmdLine := '"' + Filename + '" ' + Params;
  FillChar(StartInfo, SizeOf(StartInfo), #0);
  with StartInfo do
  begin
    cb := SizeOf(StartInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := WinState;
  end;
  Result := CreateProcess(nil, PChar( String( CmdLine ) ), nil, nil, false,
                          CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
                          PChar(ExtractFilePath(Filename)),StartInfo,ProcInfo);
  { Ожидаем завершения приложения }
  if Result then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    { Free the Handles }
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var t:TDateTime;
    myYear, myMonth, myDay, myHour, myMin, mySec, myMilli : Word;
    txtfile:string;
begin
ShowWindow(Application.Handle, sw_Hide);
t:=Now();
label1.Caption:=DateTimeToStr(t);
Form1.Height:=label1.Top+label1.Height+50;
Form1.Width:=label1.Left+label1.Width+50;
DecodeTime(t, myHour, myMin, mySec, myMilli);
DecodeDate(t, myYear, myMonth, myDay);
if myHour=1 then
 begin
  txtfile:='E:\Backup82\Fran\Fran_'+inttostr(myYear)+'{.}';
  if myMonth<10 then txtfile:=txtfile+'0'+inttostr(myMonth)+'{.}'
   else txtfile:=txtfile+inttostr(myMonth)+'{.}';
  if myDay<10 then txtfile:=txtfile+'0'+inttostr(myDay)+'.zip'
   else txtfile:=txtfile+inttostr(myDay)+'.zip';
  if NOT FileExists(txtfile) then
   ExecAndWait( 'D:\backupFran.bat', '', SW_SHOWNORMAL);
  txtfile:='E:\Backup82\Work\Work_'+inttostr(myYear)+'{.}';
  if myMonth<10 then txtfile:=txtfile+'0'+inttostr(myMonth)+'{.}'
   else txtfile:=txtfile+inttostr(myMonth)+'{.}';
  if myDay<10 then txtfile:=txtfile+'0'+inttostr(myDay)+'.zip'
   else txtfile:=txtfile+inttostr(myDay)+'.zip';
  if NOT FileExists(txtfile) then
   ExecAndWait( 'D:\backupWork.bat', '', SW_SHOWNORMAL);
 end;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if Form1.BorderStyle=bsNone then
 Form1.BorderStyle:=bsDialog
 else Form1.BorderStyle:=bsNone;
end;

end.
