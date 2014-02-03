unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI, Pad, PadTab, SetPads, SetBtn, SetInit, ExtCtrls, Menus,
  ImgList, SetIcons, Buttons, SetPlug, PadPro, BtnPro, BtnEdit, OleBtn, ActiveX,
  HTMLHelps, About, XPMan, VerCheck, Registry;

const
  UWM_TASKTRAYEVENT = WM_USER + 0;

type
  TfrmMain = class(TForm)
    popTaskTray: TPopupMenu;
    popExit: TMenuItem;
    tmMousePos: TTimer;
    N1: TMenuItem;
    popOption: TMenuItem;
    N2: TMenuItem;
    popComLine: TMenuItem;
    popSearchTopic: TMenuItem;
    popAbout: TMenuItem;
    N3: TMenuItem;
    XPManifest1: TXPManifest;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure popExitClick(Sender: TObject);
    procedure tmMousePosTimer(Sender: TObject);
    procedure popOptionClick(Sender: TObject);
    procedure popTaskTrayPopup(Sender: TObject);
    procedure popComLineClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure popSearchTopicClick(Sender: TObject);
    procedure popAboutClick(Sender: TObject);
  private
    HHPopup: THH_Popup;
    procedure AppActivate(Sender: TObject);
    function AppHelp(Command: Word; Data: Longint; var CallHelp: Boolean): Boolean;
    procedure tmAppStartTimer(Sender: TObject);
  public
    function ChangeOptions: Boolean;
    procedure SetTaskTray(Visible: Boolean);
    procedure WMTaskTrayEvent(var Msg: TMessage); message UWM_TASKTRAYEVENT;
    procedure WMDisplayChange(var Msg: TWMDisplayChange); message WM_DISPLAYCHANGE;
  end;

var
  frmMain: TfrmMain;

implementation

uses Option, ComLine;


{$R *.DFM}

// �t�H�[���쐬
procedure TfrmMain.FormCreate(Sender: TObject);
var
  tmAppStart: TTimer;
begin
  // HTML Help �̏���
  Application.HelpFile := ChangeFileExt(ParamStr(0),'.chm');
  Application.OnHelp := AppHelp;
  FillChar(HHPopup, SizeOf(THH_Popup), 0);
  HHPopup.cbStruct := SizeOf(THH_Popup);
  HHPopup.pt := Point(-1, -1);
  HHPopup.clrForeground := -1;
  HHPopup.clrBackground := -1;
  HHPopup.rcMargins := Rect(-1, -1, -1, -1);

  tmAppStart := TTimer.Create(Self);
  tmAppStart.OnTimer := tmAppStartTimer;
  tmAppStart.Interval := 100;
  tmAppStart.Enabled := True;
end;

// �A�v���P�[�V�����̏����^�C�}�[
procedure TfrmMain.tmAppStartTimer(Sender: TObject);
var
  Msg: string;
  NextVerCheck: string;
  NowVerCheck: string;
begin
  TTimer(Sender).Free;

  Tag := -1;
  if not LoadAppInit then
  begin
    Close;
    Exit;
  end;

  Pads := TPads.Create;
  IconCache := TIconCache.Create;
  Plugins := TPlugins.Create;

  Application.OnActivate := AppActivate;
  if not ChangeOptions then
  begin
    Close;
    Exit;
  end;

  Tag := 0;
  try
    IconCache.Load(UserFolder + FileNameIco);
  except
    IconCache.Clear;
  end;

  try
    Pads.Load;
  except
    on E: Exception do
    begin
      Msg := '�p�b�h�̓ǂݍ��݂Ɏ��s���܂����B' + E.Message;
      Application.MessageBox(PChar(Msg), '�G���[', MB_ICONERROR);
      Close;
      Exit;
    end;
  end;
  Plugins.BeginPlugins;
  Pads.BeginPads;

  // �X�V�`�F�b�N
  if UserIniFile.ReadBool(IS_OPTIONS, 'VerCheck', True) then
  begin
    NextVerCheck := UserIniFile.ReadString(IS_OPTIONS, 'NextVerCheck', '');
    DateTimeToString(NowVerCheck, 'yyyymmdd', Now);
    if NowVerCheck >= NextVerCheck then
    begin
      if dlgVerCheck = nil then
        dlgVerCheck := TdlgVerCheck.Create(nil);
    end;
    

  end;
  
end;

// �t�H�[���j��
procedure TfrmMain.FormDestroy(Sender: TObject);
var
  Msg: string;
begin
  Application.OnHelp := nil;

  try
    Msg := '�p�b�h�̊J��';
    Pads.Free;
    Pads := nil;
    Msg := '�v���O�C���̊J��';
    Plugins.Free;
    Plugins := nil;
    Msg := '�ݒ�t�@�C���̊J��';
    UserIniFile.Free;
    UserIniFile := nil;
    Msg := '�A�C�R���L���b�V���̊J��';
    IconCache.Free;
    IconCache := nil;
  except
    on E: Exception do
    begin
      Msg := Msg + '�ɃG���[���������܂����B' + E.Message;
      Application.MessageBox(PChar(Msg), '�G���[', MB_ICONERROR);
    end;
  end;

end;

// ����
procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Msg: string;
begin
  // OnClose����Windows�I�����ɌĂ΂�Ȃ��̂ł����ɏ���
  if Tag = 0 then
  begin
    try
      Msg := '�p�b�h�̏I��';
      Pads.EndPads;
      Msg := '�v���O�C���̏I��';
      Plugins.EndPlugins;
      Msg := '�p�b�h�̐ݒ�̕ۑ�';
      Pads.SaveIni;
      Msg := '�A�C�R���L���b�V���̕ۑ�';
      IconCache.Save(UserFolder + FileNameIco);
    except
      on E: Exception do
      begin
        Msg := Msg + '�ɃG���[���������܂����B' + E.Message;
        Application.MessageBox(PChar(Msg), '�G���[', MB_ICONERROR);
      end;
    end;
  end;

  SetTaskTray(False);
end;

// �A�v���P�[�V�����A�N�e�B�u
procedure TfrmMain.AppActivate(Sender: TObject);
begin
  ChangeOptions;
end;


// �w���v�\��
function TfrmMain.AppHelp(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
var
  Wnd: HWnd;
  FileName: String;
begin
  Result := False;
  CallHelp := False;
  FileName := Application.HelpFile;
  if not FileExists(FileName) then
    Exit;

    Wnd := Application.Handle;

  case Command of
    HELP_CONTENTS:
      HTMLHelp(Wnd, PChar(FileName), HH_DISPLAY_TOPIC, 0);
    HELP_FINDER:
      HTMLHelp(Wnd, PChar(FileName), HH_DISPLAY_TOPIC, Data);
    HELP_QUIT:
      HTMLHelp(Wnd, PChar(FileName), HH_CLOSE_ALL, Data);
    HELP_CONTEXT:
      HTMLHelp(Wnd, PChar(FileName), HH_HELP_CONTEXT, Data);
    HELP_CONTEXTPOPUP:
    begin
      HHPopup.idString := Data;
      HTMLHelp(Wnd, PChar(FileName), HH_DISPLAY_TEXT_POPUP, DWORD(@HHPopup));
    end;
    HELP_SETPOPUP_POS:
      HHPopup.pt := Point(LoWord(Data), HiWord(Data));
  end;
  Result := True;
end;



// ��ʂ̃T�C�Y�ƐF���̕ύX
procedure TfrmMain.WMDisplayChange(var Msg: TWMDisplayChange);
begin
  inherited;
  IconCache.ColorBits := Msg.BitsPerPixel;
end;


// �I�v�V�����̐ݒ�
function TfrmMain.ChangeOptions: Boolean;
begin
  Result := True;
  // �^�X�N�g���C�̃Z�b�g
  SetTaskTray(UserIniFile.ReadBool(IS_OPTIONS, 'TaskTray', True));
  // �A�C�R���L���b�V���̍ő�g�p��
  IconCache.CacheMax := UserIniFile.ReadInteger(IS_OPTIONS, 'IconCache', 1000);
end;

// �^�X�N�g���C�̃Z�b�g
procedure TfrmMain.SetTaskTray(Visible: Boolean);
var
  Icon: hIcon;
  icn: NOTIFYICONDATA;
begin
  if Visible then
  begin
    Icon := IconCache.GetIcon(PChar(ParamStr(0)), ftIconPath, 0, True, True);
    try
      icn.cbSize := sizeof(NOTIFYICONDATA);
      icn.Wnd := Handle;
      icn.uID := 100;
      icn.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
      icn.uCallbackMessage := UWM_TASKTRAYEVENT;
      icn.hIcon := Icon;
      lstrcpy(icn.szTip, 'Special Launch');
      Shell_NotifyIcon(NIM_ADD, @icn);
    finally
      DestroyIcon(Icon);
    end;
  end
  else
  begin
    icn.cbSize := sizeof(NOTIFYICONDATA);
    icn.Wnd := Handle;
    icn.uID := 100;
    icn.uFlags := 0;
    Shell_NotifyIcon(NIM_DELETE, @icn);
  end;
end;


// �^�X�N�g���C�̃C�x���g
procedure TfrmMain.WMTaskTrayEvent(var Msg: TMessage);
var
  P: TPoint;
begin
  if Pads = nil then
    Exit;

  // ����s�\
  if Pads.Count > 0 then
  begin
    if (Pads[0].frmPadTab.Hid and not IsWindowEnabled(Pads[0].frmPadTab.Handle)) or
      (not Pads[0].frmPadTab.Hid and not IsWindowEnabled(Pads[0].Handle)) then
      Exit;
  end;


  if Msg.LParam = WM_LBUTTONDOWN then
  begin
    if Pads.Count > 0 then
      SetForegroundWindow(Pads[0].Handle);
  end
  else if Msg.LParam = WM_RBUTTONDOWN then
  begin
    if Pads.Count > 0 then
      SetForegroundWindow(Pads[0].Handle);

    GetCursorPos(P);
    popTaskTray.Popup(P.X, P.Y);
  end;
end;

// �^�X�N�g���C�̃|�b�v�A�b�v���j���[
procedure TfrmMain.popTaskTrayPopup(Sender: TObject);
begin
  popComLine.Enabled := dlgComLine = nil;
  popOption.Enabled := dlgOption = nil;
  popSearchTopic.Enabled := FileExists(Application.HelpFile);
end;

// �^�X�N�g���C�̏I�����j���[
procedure TfrmMain.popExitClick(Sender: TObject);
begin
  Close;
end;

// �}�E�X�|�C���^�ʒu�Ď��^�C�}�[
procedure TfrmMain.tmMousePosTimer(Sender: TObject);
var
  Form: TForm;
  FormRect: TRect;
  P: TPoint;

  i: Integer;
begin
  if Pads = nil then
    Exit;

  tmMousePos.Enabled := False;
  try
    GetCursorPos(P);
    for i := 0 to Pads.Count - 1 do
    begin
      if Pads[i].frmPadTab.Hid then
        Form := Pads[i].frmPadTab
      else
        Form := Pads[i];
      FormRect := Rect(Form.Left, Form.Top, Form.Left + Form.Width, Form.Top + Form.Height);
      InflateRect(FormRect, 1, 1);
      Pads[i].MouseEntered := PtInRect(FormRect, P);
    end;
  finally
    tmMousePos.Enabled := True;
  end;
end;

// �w�肵�Ď��s
procedure TfrmMain.popComLineClick(Sender: TObject);
begin
  if dlgComLine = nil then
    dlgComLine := TdlgComLine.Create(nil);
  dlgComLine.Show;
end;

// �ݒ�
procedure TfrmMain.popOptionClick(Sender: TObject);
begin
  if dlgOption = nil then
    dlgOption := TdlgOption.Create(nil);
  dlgOption.Show;
end;


// �w���v
procedure TfrmMain.popSearchTopicClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER, 0);
end;

// IE �̃o�[�W�����擾
function GetIEVersion: string;
var
    R: TRegistry;
begin
    R := TRegistry.Create;
    try
        R.RootKey := HKEY_LOCAL_MACHINE;
        R.OpenKey('Software\Microsoft\Internet Explorer', False);
        try
            Result := R.ReadString('version');
        except
            Result := '';
        end;
        R.CloseKey;
    finally
        R.Free;
    end;
end;

// �o�[�W�������
procedure TfrmMain.popAboutClick(Sender: TObject);
var
  lstReadme: TStringList;
  s: String;
  i: Integer;
  Plugin: TPlugin;
begin
  lstReadme := TStringList.Create;
  try
    // �{��
    lstReadme.Add('Special Launch ');
    lstReadme.Add(GetFileVersionString(ParamStr(0), True));
    lstReadme.Add('Copyright (C)');
    lstReadme.Add('Special Launch Open Source Project.');


    // Windows
    lstReadme.Add('--------------------------------------');
    s := 'Windows';
    case OSVersionInfo.dwPlatformId of
      VER_PLATFORM_WIN32s:
        s := 'Win32s on Windows3.1';
      VER_PLATFORM_WIN32_WINDOWS:
        s := 'Windows';
      VER_PLATFORM_WIN32_NT:
        s := 'Windows NT';
    end;
    with OSVersionInfo do
      s := Format('%s %d.%d.%d %s', [s, dwMajorVersion, dwMinorVersion, dwBuildNumber, szCSDVersion]);
    lstReadme.Add(s);
    s := 'Internet Explorer ' + GetIEVersion;
    lstReadme.Add(s);


    // �v���O�C��
    lstReadme.Add('--------------------------------------');
    for i := 0 to Plugins.Count - 1 do
    begin
      Plugin := TPlugin(Plugins.Objects[i]);
      if Plugin.Enabled then
        lstReadme.Add(Plugin.Name)
      else
        lstReadme.Add(Plugin.Name + '[Disabled]');
      s := Format(' %-15s %s', [ExtractFileName(Plugin.FileName), GetFileVersionString(Plugin.FileName, True)]);
      lstReadme.Add(s);
    end;


    ShowAbout('Special Launch', ParamStr(0), lstReadme.Text);
  finally
    lstReadme.Free;
  end;
end;


end.

