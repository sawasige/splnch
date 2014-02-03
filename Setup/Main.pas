unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, Menus, StdCtrls, SetBtn, ImgList, Registry, FileCtrl,
  IniFiles, SetFuncs, ShellAPI, XPMan;

type
  TfrmMain = class(TForm)
    PageControl: TPageControl;
    tabSL3Groups: TTabSheet;
    lblSL3Groups: TLabel;
    lvSL3Groups: TListView;
    btnPrev: TButton;
    btnNext: TButton;
    btnCancel: TButton;
    tabSL4UserFolder: TTabSheet;
    lblSL4UserFolder: TLabel;
    edtSL4UserFolder: TEdit;
    Label4: TLabel;
    btnSL4UserFolder: TButton;
    tabInfo: TTabSheet;
    lblInfo: TLabel;
    memInfo: TMemo;
    btnRun: TButton;
    lvSL3GroupsAllYes: TButton;
    lvSL3GroupsAllNo: TButton;
    Image1: TImage;
    tabStart: TTabSheet;
    imgIcon: TImage;
    lblTitle: TLabel;
    tabTargetFolder: TTabSheet;
    lblTargetFolder: TLabel;
    Label8: TLabel;
    edtTargetFolder: TEdit;
    btnTargetFolder: TButton;
    rdoInstall: TRadioButton;
    rdoConvert: TRadioButton;
    rdoUninstall: TRadioButton;
    lblSL4UserFolderInfo: TLabel;
    tabInstallOptions: TTabSheet;
    lblInstallOptions: TLabel;
    chkProgramMenu: TCheckBox;
    chkStartup: TCheckBox;
    chkRegistry: TCheckBox;
    chkDesktop: TCheckBox;
    memDescription: TMemo;
    Label1: TLabel;
    tabUninstallOptions: TTabSheet;
    lblUninstallOptions: TLabel;
    chkDeleteData: TCheckBox;
    chkDeletePlugins: TCheckBox;
    XPManifest1: TXPManifest;
    chkSettingForAllUser: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnSL4UserFolderClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure tabInfoShow(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure lvSL3GroupsAllYesClick(Sender: TObject);
    procedure lvSL3GroupsAllNoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnTargetFolderClick(Sender: TObject);
    procedure edtSL4UserFolderChange(Sender: TObject);
    procedure chkSettingForAllUserClick(Sender: TObject);
  private
    FUserName: string;
    FUpdateInstall: Boolean;

    FSL4PadName: string;
    FSL4PadCount: Integer;
    FUserFolder: string;
    FAllFolder: string;
    function GetTargetFolder: string;
    function GetSL4UserFolder: string;
    function VisiblePage(Page: TTabSheet): Boolean;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.DFM}

// �C���X�g�[����t�H���_
function TfrmMain.GetTargetFolder: string;
var
  Folder: string;
begin
  Folder := Trim(edtTargetFolder.Text);
  Folder := ExpandUNCFileName(Folder);
  if not IsPathDelimiter(Folder, Length(Folder)) then
    Folder := Folder + '\';
  Result := Folder;
end;

// �f�[�^�t�H���_
function TfrmMain.GetSL4UserFolder: string;
var
  Folder: string;
begin
  Folder := Trim(edtSL4UserFolder.Text);
  if DirectoryExists(GetTargetFolder) then
  begin
    ChDir(GetTargetFolder);
    Folder := ExpandUNCFileName(Folder);
  end;
  if not IsPathDelimiter(Folder, Length(Folder)) then
    Folder := Folder + '\';
  Result := Folder;
end;


procedure TfrmMain.FormCreate(Sender: TObject);
var
//  NonClientMetrics: TNonClientMetrics;

  UserSize: Cardinal;

  Buf: array[0..2024] of Char;

  RegIniFile: TRegIniFile;
  i: Integer;
  Title,
  BtnFile: string;
  Item: TListItem;

  Ini: TIniFile;
begin
  // �t�H���g
//  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
//  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0);
//  Font.Handle := CreateFontIndirect(NonClientMetrics.lfMessageFont);

  imgIcon.Picture.Icon := Application.Icon;
  lblTitle.Caption := Application.Title;
//  lblTitle.Font.Name := Font.Name;
//  lblTargetFolder.Font.Name := Font.Name;
//  lblInstallOptions.Font.Name := Font.Name;
//  lblSL4UserFolder.Font.Name := Font.Name;
//  lblSL3Groups.Font.Name := Font.Name;
//  lblUninstallOptions.Font.Name := Font.Name;
//  lblInfo.Font.Name := Font.Name;


  for i := 0 to PageControl.PageCount - 1 do
    PageControl.Pages[i].TabVisible := False;

  PageControl.ActivePage := PageControl.Pages[0];

  // ���݂̃��[�U�[��
  UserSize := SizeOf(Buf);
  if not GetUserName(Buf, UserSize) then
    Buf := '';
  if Buf = '' then
    Buf := 'Default';
  FUserName := StrPas(Buf);


  // SL3 �{�^���t�@�C��
  RegIniFile := TRegIniFile.Create('Software\SS Soft\Special Launch');
  try
    with RegIniFile do
    begin
      i := 0;
      while True do
      begin
        Title := ReadString('Groups', 'Name'+IntToStr(i), '�O���[�v' + IntToStr(i));
        BtnFile := ReadString('Groups', 'File'+IntToStr(i), '');
        if BtnFile = '' then
          Break;

        if FileExists(BtnFile) then
        begin
          Item := lvSL3Groups.Items.Add;
          Item.Caption := Title;
          Item.SubItems.Add(BtnFile);
          Item.Checked := False;
        end;
        inc(i);
      end;
      if lvSL3Groups.Items.Count > 0 then
        lvSL3Groups.Items[0].Focused := True;
    end;
  finally
    RegIniFile.Free;
  end;

  Ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Setup.ini');
  try
    // �C���X�g�[���ς�
    if Ini.ReadBool('Install', 'Installed', False) then
    begin
      Title := '���̃v���O������ Special Launch 3 �̃{�^���t�@�C���� Special Launch 4 �̌`���ɃR���o�[�g������A Special Launch ���R���s���[�^����폜���܂��B' + #13#10
        + #13#10
        + '�����I�����ām���ցn���N���b�N���Ă��������B' + #13#10;
      memDescription.Text := Title;
      rdoInstall.Visible := False;
      rdoConvert.Enabled := lvSL3Groups.Items.Count > 0;
      if rdoConvert.Enabled then
        rdoConvert.Checked := True
      else
        rdoUninstall.Checked := True;
    end
    // �C���X�g�[���O
    else
    begin
      Title := '���̃v���O������ Special Launch ���R���s���[�^�ɃC���X�g�[�����܂��B' + #13#10
        + #13#10
        + #13#10
        + '�������ł��܂�����m���ցn���N���b�N���Ă��������B' + #13#10;
      memDescription.Text := Title;
      rdoInstall.Checked := True;
      rdoInstall.Visible := False;
      rdoConvert.Visible := False;
      rdoUninstall.Visible := False;
    end;
  finally
    Ini.Free;
  end;

  chkDeleteData.Checked := True;
  chkDeletePlugins.Checked := True;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  lvSL3Groups.Items.BeginUpdate;
  try
    for i := 0 to lvSL3Groups.Items.Count - 1 do
      TButtonGroup(lvSL3Groups.Items[i].Data).Free;
    lvSL3Groups.Items.Clear;
  finally
    lvSL3Groups.Items.EndUpdate;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  PageControlChange(PageControl);
end;

// �y�[�W�ύX
procedure TfrmMain.PageControlChange(Sender: TObject);
begin
  btnPrev.Enabled := PageControl.ActivePage.PageIndex > 0;
  btnNext.Enabled := PageControl.ActivePage.PageIndex < PageControl.PageCount - 1;
  btnRun.Enabled := PageControl.ActivePage.PageIndex = PageControl.PageCount - 1;
  btnPrev.Cancel := btnPrev.Enabled;
  btnCancel.Cancel := not btnPrev.Enabled;
  btnNext.Default := btnNext.Enabled;
  btnRun.Default := btnRun.Enabled;

  if PageControl.ActivePage = tabStart then
  begin
    Caption := Application.Title;
    if rdoInstall.Checked and rdoInstall.Visible then
      rdoInstall.SetFocus
    else if rdoConvert.Checked and rdoConvert.Visible then
      rdoConvert.SetFocus
    else if rdoUninstall.Checked and rdoUninstall.Visible then
      rdoUninstall.SetFocus
    else
      btnNext.SetFocus;
  end
  else
  begin
    if PageControl.ActivePage = tabTargetFolder then
    begin
      edtTargetFolder.SetFocus;
      FUpdateInstall := False;
    end
    else if PageControl.ActivePage = tabInstallOptions then
      chkProgramMenu.SetFocus
    else if PageControl.ActivePage = tabSL4UserFolder then
      chkSettingForAllUser.SetFocus
    else if PageControl.ActivePage = tabSL3Groups then
      lvSL3Groups.SetFocus
    else if PageControl.ActivePage = tabUninstallOptions then
      chkDeleteData.SetFocus
    else if PageControl.ActivePage = tabInfo then
      memInfo.SetFocus;

    if rdoInstall.Checked then
    begin
      if FUpdateInstall then
        Caption := 'Special Launch �㏑���C���X�g�[��'
      else
        Caption := 'Special Launch �C���X�g�[��';
    end
    else if rdoConvert.Checked then
      Caption := 'Special Launch 3 �� 4 �R���o�[�g'
    else if rdoUninstall.Checked then
      Caption := 'Special Launch �A���C���X�g�[��'
  end;
end;


// �y�[�W�̕\���`�F�b�N
function TfrmMain.VisiblePage(Page: TTabSheet): Boolean;
var
  IniFileName: string;
  UserFolder: string;
  Ini: TIniFile;
begin
  Result := False;

  // �C���X�g�[����t�H���_
  if Page = tabTargetFolder then
  begin
    Result := rdoInstall.Checked;
  end

  // �C���X�g�[���I�v�V����
  else if Page = tabInstallOptions then
  begin
    Result := rdoInstall.Checked and not FUpdateInstall;
  end

  // �f�[�^�t�H���_
  else if Page = tabSL4UserFolder then
  begin
    Result := (rdoInstall.Checked and not FUpdateInstall) or rdoConvert.Checked;
  end

  // SL3 �{�^���O���[�v
  else if Page = tabSL3Groups then
  begin
    Result := (lvSL3Groups.Items.Count > 0) and (rdoInstall.Checked or rdoConvert.Checked);
    if Result and rdoInstall.Checked then
    begin
      IniFileName := GetTargetFolder + 'SpLnch.ini';
      if FileExists(IniFileName) then
      begin
        Ini := TIniFile.Create(IniFileName);
        try
          UserFolder := Ini.ReadString('Users', FUserName, '');
        finally
          Ini.Free;
        end;
      end;

      if DirectoryExists(UserFolder) then
      begin
        edtSL4UserFolder.Text := UserFolder;
        Result := False;
      end;
    end;
  end

  // �A���C���X�g�[���I�v�V����
  else if Page = tabUninstallOptions then
  begin
    Result := rdoUninstall.Checked;
  end

end;



// �߂�{�^��
procedure TfrmMain.btnPrevClick(Sender: TObject);
var
  PrevPage: TTabSheet;
begin
  PrevPage := PageControl.FindNextPage(PageControl.ActivePage, False, False);
  while PrevPage.PageIndex > 0 do
  begin
    if VisiblePage(PrevPage) then
      Break;
    PrevPage := PageControl.FindNextPage(PrevPage, False, False);
  end;
  PageControl.ActivePage := PrevPage;
  PageControlChange(PageControl);
end;

// ���փ{�^��
procedure TfrmMain.btnNextClick(Sender: TObject);
var
  i: Integer;

  Buf: array[0..2024] of Char;
  TargetFolder: string;

  Folder, FileName: string;
  Ini: TIniFile;
  SettingForAllUser: Boolean;
  UserFolder: string;
  NextPage: TTabSheet;

  OSVersionInfo: TOSVersionInfo;
begin
  // �ŏ��̃y�[�W
  if PageControl.ActivePage = tabStart then
  begin

    // �C���X�g�[����t�H���_�̏�����
    TargetFolder := GetRegistry;
    if TargetFolder = '' then
    begin
      if GetWindowsDirectory(Buf, SizeOf(Buf)) > 0 then
      begin
        TargetFolder := Copy(Buf, 1, 3) + 'Program Files\Special Launch 4\';
      end;
    end;
    edtTargetFolder.Text := TargetFolder;

    // �C���X�g�[���I�v�V�����̏�����
    chkProgramMenu.Checked := True;
    chkStartup.Checked := True;
    chkDesktop.Checked := False;
    chkRegistry.Checked := True;


    // �f�[�^�t�H���_�̏�����
    if rdoInstall.Checked then
    begin
      lblSL4UserFolder.Caption := '�e��ݒ��ۑ�����f�[�^�t�H���_���w�肵�Ă��������B';
      lblSL4UserFolderInfo.Visible := True;
      edtSL4UserFolder.Text := '';
    end
    else
    begin
      lblSL4UserFolder.Caption := 'Special Launch 4 �Ŋe��ݒ��ۑ����Ă���f�[�^�t�H���_���w�肵�Ă��������B';
      lblSL4UserFolderInfo.Visible := False;

      FileName := ExtractFilePath(ParamStr(0)) + 'SpLnch.ini';
      if FileExists(FileName) then
      begin
        Ini := TIniFile.Create(FileName);
        try
          Folder := Ini.ReadString('Users', FUserName, '');
        finally
          Ini.Free;
        end;
      end;

      if DirectoryExists(Folder) then
        edtSL4UserFolder.Text := Folder;
    end;


    // SL3 �{�^���O���[�v
    for i := 0 to lvSL3Groups.Items.Count - 1 do
      lvSL3Groups.Items[i].Checked := False;
  end;


  // �C���X�g�[����t�H���_
  if PageControl.ActivePage = tabTargetFolder then
  begin
    FUpdateInstall := False;

    if Trim(edtTargetFolder.Text) = '' then
    begin
      Application.MessageBox('�C���X�g�[����t�H���_���w�肵�Ă��������B', '�m�F', MB_ICONWARNING);
      Exit;
    end;

    FileName := GetTargetFolder + 'SpLnch.ini';
    SettingForAllUser := False;
    UserFolder := '';
    if FileExists(FileName) then
    begin
      Ini := TIniFile.Create(FileName);
      try
        SettingForAllUser := Ini.ReadBool('General', 'SettingForAllUser', False);
        if SettingForAllUser then
          UserFolder := Ini.ReadString('Users', 'Default', '')
        else
          UserFolder := Ini.ReadString('Users', FUserName, '');
      finally
        Ini.Free;
      end;
    end;
    FUpdateInstall := UserFolder <> '';
    if FUpdateInstall then
    begin
      chkSettingForAllUser.Checked := SettingForAllUser;
      edtSL4UserFolder.Text := UserFolder;
    end
    else
    begin
      chkSettingForAllUser.Checked := False;
      OSVersionInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
      GetVersionEx(OSVersionInfo);
      if (OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT) and
        (OSVersionInfo.dwMajorVersion >= 6) then
        FUserFolder := GetEnvironmentVariable('appdata') + '\Special Launch\'
      else
        FUserFolder := GetTargetFolder + FUserName + '\';
      FAllFolder := GetTargetFolder + 'Default\';
      edtSL4UserFolder.Text := FUserFolder;



      if UnknownFileExists(GetTargetFolder) then
      begin
        if Application.MessageBox(PChar('�w��̃t�H���_ "' + GetTargetFolder
          + '" �ɂ͂��łɃt�@�C�������݂��Ă��܂��B'
          + '�����̃t�@�C���ɉe�����y�ڂ����ꂪ����܂����A'
          + '���̂܂ܑ��s���Ă�낵���ł���?'),
                                  '�m�F', MB_ICONWARNING or MB_YESNO) = idNo then
          Exit;
      end;
    end;

    Ini := TIniFile.Create(GetTargetFolder + 'Setup.ini');
    try
      chkProgramMenu.Checked := Ini.ReadBool('Options', 'ProgramMenu', True);
      chkStartup.Checked := Ini.ReadBool('Options', 'Startup', True);
      chkDesktop.Checked := Ini.ReadBool('Options', 'Desktop', False);
      chkRegistry.Checked := Ini.ReadBool('Options', 'Registry', True);
    finally
      Ini.Free;
    end;

  end

  // �f�[�^�t�H���_
  else if PageControl.ActivePage = tabSL4UserFolder then
  begin
    if Trim(edtSL4UserFolder.Text) = '' then
    begin
      Application.MessageBox('�f�[�^�t�H���_���w�肵�Ă��������B', '�m�F', MB_ICONWARNING);
      Exit;
    end;

    FileName := GetSL4UserFolder + 'SpLnch.ini';

    if rdoInstall.Checked then
    begin
      // �w��̃t�H���_�Ƀ��[�U�[�ݒ�t�@�C��������
      if FileExists(FileName) then
      begin
        if Application.MessageBox(PChar('�w��̃t�H���_ "' + GetSL4UserFolder +
                                        '" �ɂ͂��łɐݒ肪����܂��B���̐ݒ�𗘗p���܂���?'),
                                  '�m�F', MB_ICONQUESTION or MB_YESNO) = idNo then
          Exit;
      end
      else if DirectoryExists(GetSL4UserFolder) then
      begin
        if UnknownFileExists(GetSL4UserFolder) then
        begin
          if Application.MessageBox(PChar('�w��̃t�H���_ "' + GetSL4UserFolder +
                                        '" �ɂ͂��łɐݒ�ȊO�̃t�@�C�������݂��Ă��܂��B' +
                                        '���̂܂ܑ��s���Ă�낵���ł���?'),
                                    '�m�F', MB_ICONQUESTION or MB_YESNO) = idNo then
            Exit;
        end;
      end

    end
    else
    begin
      if not DirectoryExists(GetSL4UserFolder) then
      begin
        Application.MessageBox(PChar('�w��̃t�H���_ "' + GetSL4UserFolder + '" �͑��݂��܂���B'), '�m�F', MB_ICONWARNING);
        Exit;
      end;

      if not FileExists(FileName) then
      begin
        Application.MessageBox(PChar('�w��̃t�H���_ "' + GetSL4UserFolder + '" �ɂ� Special Launch �̃f�[�^�͂���܂���B'), '�m�F', MB_ICONWARNING);
        Exit;
      end;

      Ini := TIniFile.Create(FileName);
      try
        if not Ini.SectionExists('User') then
        begin
          Application.MessageBox(PChar('�w��̃t�H���_ "' + GetSL4UserFolder + '" �ɂ͗L���ȃ��[�U�[�ݒ肪����܂���B'), '�m�F', MB_ICONWARNING);
          Exit;
        end;
      finally
        Ini.Free;
      end;
    end;


  end

  // SL3 �{�^���O���[�v
  else if PageControl.ActivePage = tabSL3Groups then
  begin
    if rdoConvert.Checked then
    begin
      i := 0;
      while i < lvSL3Groups.Items.Count do
      begin
        if lvSL3Groups.Items[i].Checked then
          Break;
        Inc(i);
      end;
      if i >= lvSL3Groups.Items.Count then
      begin
        Application.MessageBox('�R���o�[�g����{�^���O���[�v���I������Ă��܂���B', '�m�F', MB_ICONWARNING);
        Exit;
      end;
    end;
  end;

  // ���̃y�[�W
  NextPage := PageControl.FindNextPage(PageControl.ActivePage, True, False);
  while NextPage.PageIndex < PageControl.PageCount - 1 do
  begin
    if VisiblePage(NextPage) then
      Break;
    NextPage := PageControl.FindNextPage(NextPage, True, False);
  end;
  PageControl.ActivePage := NextPage;
  PageControlChange(PageControl);
end;

// �C���X�g�[����Q�ƃ{�^��
procedure TfrmMain.btnTargetFolderClick(Sender: TObject);
var
  Folder: string;
begin
  if SelectDirectory('Special Launch ���C���X�g�[������t�H���_���w�肵�Ă��������B', '', Folder) then
  begin
    if not IsPathDelimiter(Folder, Length(Folder)) then
      Folder := Folder + '\';
    edtTargetFolder.Text := Folder;
  end;
end;

procedure TfrmMain.chkSettingForAllUserClick(Sender: TObject);
begin
  if chkSettingForAllUser.Checked then
    edtSL4UserFolder.Text := FAllFolder
  else
    edtSL4UserFolder.Text := FUserFolder;
end;

procedure TfrmMain.edtSL4UserFolderChange(Sender: TObject);
begin
  if chkSettingForAllUser.Checked then
    FAllFolder := edtSL4UserFolder.Text
  else
    FUserFolder := edtSL4UserFolder.Text;
end;

// SL4�f�[�^�t�H���_�Q�ƃ{�^��
procedure TfrmMain.btnSL4UserFolderClick(Sender: TObject);
var
  Folder: string;
begin
  if SelectDirectory('Special Launch �̃f�[�^��ۑ�����t�H���_���w�肵�Ă��������B', '', Folder) then
  begin
    if not IsPathDelimiter(Folder, Length(Folder)) then
      Folder := Folder + '\';
    edtSL4UserFolder.Text := Folder;
  end;
end;

// SL3���ׂđI���{�^��
procedure TfrmMain.lvSL3GroupsAllYesClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvSL3Groups.Items.Count - 1 do
    lvSL3Groups.Items[i].Checked := True;
end;

// SL3���ׂĉ����{�^��
procedure TfrmMain.lvSL3GroupsAllNoClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvSL3Groups.Items.Count - 1 do
    lvSL3Groups.Items[i].Checked := False;
end;


// �L�����Z���{�^��
procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  Close;
end;

// ���\��
procedure TfrmMain.tabInfoShow(Sender: TObject);
  procedure SetBrankLine;
  begin
    if memInfo.Lines.Count > 0 then
      memInfo.Lines.Add('');
  end;
var
  i: Integer;
  ConvertCount: Integer;
begin
  lblInfo.Caption := '�ȉ��̐ݒ��';
  if rdoInstall.Checked then
    lblInfo.Caption := lblInfo.Caption + '�C���X�g�[��'
  else if rdoConvert.Checked then
    lblInfo.Caption := lblInfo.Caption + '�R���o�[�g'
  else if rdoUninstall.Checked then
    lblInfo.Caption := lblInfo.Caption + '�A���C���X�g�[��';
  lblInfo.Caption := lblInfo.Caption + '�����s���܂��B';


  memInfo.Clear;

  if VisiblePage(tabTargetFolder) then
  begin
    SetBrankLine;
    memInfo.Lines.Add('Special Launch ���C���X�g�[������t�H���_');
    memInfo.Lines.Add(Format('   %s', [GetTargetFolder]));
  end;

  if VisiblePage(tabInstallOptions) then
  begin
    SetBrankLine;
    memInfo.Lines.Add('�C���X�g�[���I�v�V����');
    if chkProgramMenu.Checked then
      memInfo.Lines.Add('   �v���O�������j���[�ɓo�^����');
    if chkStartup.Checked then
      memInfo.Lines.Add('   Windows �̋N������ Special Launch ���N������');
    if chkDesktop.Checked then
      memInfo.Lines.Add('   �f�X�N�g�b�v�ɃV���[�g�J�b�g���쐬����');
    if chkRegistry.Checked then
      memInfo.Lines.Add('   �R���g���[���p�l���́m�v���O�����̒ǉ��ƍ폜�n�ɓo�^����');
    if (not chkProgramMenu.Checked) and (not chkStartup.Checked) and
      (not chkDesktop.Checked) and (not chkRegistry.Checked) then
      memInfo.Lines.Add('   �Ȃ�');
  end;

  if VisiblePage(tabSL4UserFolder) then
  begin
    SetBrankLine;
    memInfo.Lines.Add('�e��ݒ��ۑ�����t�H���_');
    if chkSettingForAllUser.Checked then
      memInfo.Lines.Add('   ���ׂẴ��[�U�[�œ����ݒ���g��')
    else
      memInfo.Lines.Add('   �e���[�U�[���Ƃɐݒ��ۑ�����');
    memInfo.Lines.Add(Format('   %s', [GetSL4UserFolder]));
  end;

  if VisiblePage(tabSL3Groups) then
  begin
    SetBrankLine;
    memInfo.Lines.Add('Special Launch 3 ����R���o�[�g����{�^���O���[�v');
    ConvertCount := 0;
    for i := 0 to lvSL3Groups.Items.Count - 1 do
      if lvSL3Groups.Items[i].Checked then
      begin
        memInfo.Lines.Add(Format('   %s [%s]', [lvSL3Groups.Items[i].Caption, lvSL3Groups.Items[i].SubItems[0]]));
        Inc(ConvertCount);
      end;

    if ConvertCount = 0 then
    begin
      FSL4PadName := '';
      FSL4PadCount := 0;
      memInfo.Lines.Add('   �Ȃ�');
    end
    else
    begin
      i := 0;
      while True do
      begin
        FSL4PadName := GetSL4UserFolder + 'Pads\Pad' + IntToStr(i);
        if not FileExists(FSL4PadName + '.ini') then
          Break;
        Inc(i);
      end;
      FSL4PadCount := i + 1;
      SetBrankLine;
      memInfo.Lines.Add('Special Launch 4 �ŐV�����쐬����p�b�h�t�@�C��');
      memInfo.Lines.Add(Format('   %s.ini', [FSL4PadName]));
      memInfo.Lines.Add(Format('   %s.btn', [FSL4PadName]));
    end;
  end;

  if rdoUninstall.Checked then
  begin
    SetBrankLine;
    memInfo.Lines.Add('�A���C���X�g�[���I�v�V����');
    if chkDeleteData.Checked then
      memInfo.Lines.Add('   �e���[�U�[�̃f�[�^�t�H���_���폜����');
    if chkDeletePlugins.Checked then
      memInfo.Lines.Add('   �v���O�C���t�H���_���폜����');
    if (not chkDeleteData.Checked) and (not chkDeletePlugins.Checked) then
      memInfo.Lines.Add('   �Ȃ�');
  end;

  memInfo.SelStart := 0;
  memInfo.SelLength := 0;
end;






// ���s�{�^��
procedure TfrmMain.btnRunClick(Sender: TObject);
var
  i: Integer;
  ButtonGroups: TButtonGroups;
  ButtonGroup: TButtonGroup;
  Ini: TIniFile;
  DoClose: Boolean;
  Msg: string;
  NewTargetFolder: string;
  NewUserFolder: string;
begin
  DoClose := True;

  NewTargetFolder := GetTargetFolder;
  if rdoInstall.Checked then
  begin
    // �t�H���_�̍쐬
    DoClose := ForceDirectories(NewTargetFolder);
    if not DoClose then
      Application.MessageBox('�C���X�g�[����t�H���_���쐬�ł��܂���ł����B', '�G���[', MB_ICONSTOP);

    // �t�@�C���R�s�[
    if DoClose then
      DoClose := SL4FileCopy(NewTargetFolder);

    // �K�v�ȃt�H���_�̍쐬
    if DoClose then
    begin
      DoClose := ForceDirectories(GetSL4UserFolder);
      if not DoClose then
        Application.MessageBox('�f�[�^�t�H���_���쐬�ł��܂���ł����B', '�G���[', MB_ICONSTOP);
    end;
    if DoClose then
    begin
      DoClose := ForceDirectories(GetSL4UserFolder + 'Pads');
      if not DoClose then
        Application.MessageBox('�p�b�h�t�H���_���쐬�ł��܂���ł����B', '�G���[', MB_ICONSTOP);
    end;
    if DoClose then
    begin
      DoClose := ForceDirectories(NewTargetFolder + 'Plugins');
      if not DoClose then
        Application.MessageBox('�v���O�C���t�H���_���쐬�ł��܂���ł����B', '�G���[', MB_ICONSTOP);
    end;

    if DoClose then
    begin
      // �J�����g�f�B���N�g���ɂ���ꍇ�͑��΃p�X�ɒu������
      NewUserFolder := GetSL4UserFolder;
      if Pos(NewTargetFolder, NewUserFolder) = 1 then
        NewUserFolder := ExtractRelativePath(NewTargetFolder, NewUserFolder);

      Ini := TIniFile.Create(NewTargetFolder + 'SpLnch.ini');
      try
        Ini.WriteBool('General', 'SettingForAllUser', chkSettingForAllUser.Checked);
        if chkSettingForAllUser.Checked then
          Ini.WriteString('Users', 'Default', NewUserFolder)
        else
          Ini.WriteString('Users', FUserName, NewUserFolder);
      finally
        Ini.Free;
      end;
    end;
    if DoClose then
    begin
      Ini := TIniFile.Create(GetSL4UserFolder + 'SpLnch.ini');
      try
        if chkSettingForAllUser.Checked then
          Ini.WriteString('User', 'Name', 'Default')
        else
          Ini.WriteString('User', 'Name', FUserName);
      finally
        Ini.Free;
      end;
    end;


    // �C���X�g�[���I�v�V����
    if VisiblePage(tabInstallOptions) then
    begin
      // �v���O�������j���[�o�^
      if DoClose and chkProgramMenu.Checked then
      begin
        chkProgramMenu.Checked := SetProgramMenu(NewTargetFolder);
        if not chkProgramMenu.Checked then
          Application.MessageBox('�v���O�������j���[�ɓo�^�ł��܂���ł����B', '�G���[', MB_ICONSTOP);
      end;

      // �X�^�[�g�A�b�v�o�^
      if DoClose and chkStartup.Checked then
      begin
        chkStartup.Checked := SetStartup(NewTargetFolder);
        if not chkStartup.Checked then
          Application.MessageBox('�X�^�[�g�A�b�v�ɓo�^�ł��܂���ł����B', '�G���[', MB_ICONSTOP);
      end;

      // �f�X�N�g�b�v�o�^
      if DoClose and chkDesktop.Checked then
      begin
        chkDesktop.Checked := SetDesktop(NewTargetFolder);
        if not chkDesktop.Checked then
          Application.MessageBox('�f�X�N�g�b�v�ɃV���[�g�J�b�g���쐬�ł��܂���ł����B', '�G���[', MB_ICONSTOP);
      end;

      // ���W�X�g���o�^
      if DoClose and chkRegistry.Checked then
      begin
        chkRegistry.Checked := SetRegistry(NewTargetFolder);
        if not chkRegistry.Checked then
          Application.MessageBox('���W�X�g���ɓo�^�ł��܂���ł����B', '�G���[', MB_ICONSTOP);
      end;


    end;

    // �Z�b�g�A�b�v�I�v�V������������
    if DoClose then
    begin
      Ini := TIniFile.Create(NewTargetFolder + 'Setup.ini');
      try
        Ini.WriteBool('Install', 'Installed', True);
        Ini.WriteBool('Options', 'ProgramMenu', chkProgramMenu.Checked);
        Ini.WriteBool('Options', 'Startup', chkStartup.Checked);
        Ini.WriteBool('Options', 'Desktop', chkDesktop.Checked);
        Ini.WriteBool('Options', 'Registry', chkRegistry.Checked);
      finally
        Ini.Free;
      end;
    end;
  end;


  if DoClose and (rdoInstall.Checked or rdoConvert.Checked) then
  begin

    ButtonGroups := TButtonGroups.Create;
    try
      DoClose := True;

      for i := 0 to lvSL3Groups.Items.Count - 1 do
        if lvSL3Groups.Items[i].Checked then
        begin
          ButtonGroup := TButtonGroup.Create;
          if SL3Load(lvSL3Groups.Items[i].Caption, lvSL3Groups.Items[i].SubItems[0], ButtonGroup) then
            ButtonGroups.Add(ButtonGroup)
          else
          begin
            Application.MessageBox('�{�^���t�@�C���̌`�����Ⴂ�܂��B', '�G���[', MB_ICONSTOP);
            ButtonGroup.Free;
            DoClose := False;
            Break;
          end;
        end;

      if DoClose and (ButtonGroups.Count > 0) then
      begin
        ButtonGroups.Save(FSL4PadName + '.btn');
        Ini := TIniFile.Create(FSL4PadName + '.ini');
        try
          Ini.WriteInteger('PadOptions', 'GroupIndex', 0);
        finally
          Ini.Free;
        end;

        Ini := TIniFile.Create(GetSL4UserFolder + 'SpLnch.ini');
        try
          Ini.WriteInteger('Pads', 'Count', FSL4PadCount);
        finally
          Ini.Free;
        end;
      end;

    finally
      ButtonGroups.Free;
    end;

  end;

  if rdoUninstall.Checked then
  begin
    DoClose := UninstallTemp(chkDeleteData.Checked, chkDeletePlugins.Checked);
  end;


  if rdoInstall.Checked then
    Msg := '�C���X�g�[��'
  else if rdoConvert.Checked then
    Msg := '�R���o�[�g'
  else if rdoUninstall.Checked then
    Msg := '�A���C���X�g�[��';

  if DoClose then
  begin
    if not rdoUninstall.Checked then
    begin
      if rdoInstall.Checked then
      begin
        SetupUnlock;
        if Application.MessageBox('Special Launch �������ɋN�����܂���?', '�m�F', MB_ICONQUESTION or MB_YESNO) = idYes then
          WinExec(PChar(NewTargetFolder + 'SpLnch.exe'), SW_SHOW);
        if not FUpdateInstall then
          if Application.MessageBox('Special Launch �̃w���v��\�����܂���?', '�m�F', MB_ICONQUESTION or MB_YESNO) = idYes then
            ShellExecute(Handle, nil, PChar(NewTargetFolder + 'SpLnch.chm'), nil, nil, SW_SHOW);
      end
      else
      begin
        Msg := Msg + '���������܂����B';
        Application.MessageBox(PChar(Msg), '�I��', MB_ICONINFORMATION);
      end;

    end;

    Close;
  end
  else
  begin
    Msg := Msg + '�ł��܂���ł����B';
    Application.MessageBox(PChar(Msg), '�m�F', MB_ICONSTOP);
  end;


end;

end.
