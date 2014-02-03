program Setup;

{$R 'Resource.res' 'Resource.rc'}
{%TogetherDiagram 'ModelSupport_Setup\default.txaPackage'}

uses
  Forms,
  Windows,
  Messages,
  Main in 'Main.pas' {frmMain},
  SetBtn in 'SetBtn.pas',
  pidl in 'pidl.pas',
  SetFuncs in 'SetFuncs.pas';

{$R *.RES}

var
  hMutex: THandle;
  Msg: String;
  Wnd: hWnd;
begin
  if ParamStr(1) = '-deletefile' then
  begin
    SL4FileDelete;
  end
  else
  begin
    // Special Launch ���m�F
    hMutex := OpenMutex(MUTEX_ALL_ACCESS, False, MUTEX_NAME);
    if hMutex <> 0 then
    begin
      Wnd := FindWindow('TApplication', 'Special Launch');
      if Wnd <> 0 then
      begin
        Msg := 'Special Launch ���I�����ăZ�b�g�A�b�v�𑱍s���܂��B';
        if MessageBox(GetDesktopWindow, PChar(Msg), '�m�F', MB_ICONINFORMATION or MB_OKCANCEL) <> idOk then
        begin
          Exit;
        end;

        try
          ReleaseMutex(hMutex);
          CloseHandle(hMutex);
          SendMessage(Wnd, WM_CLOSE, 0, 0);
        except
          // ���������I����ĂȂ��Ɨ�O����
          Wnd := 0;
        end;
      end;

      if Wnd = 0 then
      begin
        Msg := 'Special Launch ���Z�b�g�A�b�v�����b�N���Ă��܂��B'
            + 'Special Launch���I�����čēx���s���Ă��������B';
        MessageBox(GetDesktopWindow, PChar(Msg),
          '�m�F', MB_ICONINFORMATION);
        Exit;
      end;
    end;

    // �Z�b�g�A�b�v���m�F
    hMutex := OpenMutex(MUTEX_ALL_ACCESS, False, SETUP_MUTEX_NAME);
    if hMutex <> 0 then
    begin
      Wnd := FindWindow('TApplication', 'Special Launch �Z�b�g�A�b�v');
      if Wnd <> 0 then
      begin
        try
          SetForegroundWindow(Wnd);
        except
          // ���������I����ĂȂ��Ɨ�O����
          Wnd := 0;
        end;
      end;
      if Wnd = 0 then
      begin
        Msg := 'Special Launch �Z�b�g�A�b�v�����b�N���Ă��܂��B'
            + '�v���O�������I�����čēx���s���Ă��������B';
        MessageBox(GetDesktopWindow, PChar(Msg),
          '�m�F', MB_ICONINFORMATION);
      end;

      Exit;
    end;

    hSetupMutex := CreateMutex(nil, False, SETUP_MUTEX_NAME);

    Application.Initialize;
    Application.Title := 'Special Launch �Z�b�g�A�b�v';
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;

    ReleaseMutex(hSetupMutex);
  end;
end.
