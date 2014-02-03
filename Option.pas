unit Option;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, SetInit, ImgList, SetPlug, About, SetIcons,
  SetPads, MMSystem, IniFiles, SetBtn;


type
  TdlgOption = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    PageControl: TPageControl;
    tabGeneral: TTabSheet;
    tabPlugins: TTabSheet;
    lblPlugins: TLabel;
    btnPluginOption: TButton;
    imlPlugins: TImageList;
    btnPluginInfo: TButton;
    lvPlugins: TListView;
    grpIconCache: TGroupBox;
    lblIconCache: TLabel;
    lblNowIconCache: TLabel;
    edtIconCache: TEdit;
    udIconCache: TUpDown;
    btnCacheClear: TButton;
    chkTaskTray: TCheckBox;
    dlgOpen: TOpenDialog;
    btnPluginEnable: TButton;
    btnPluginDisable: TButton;
    gbSound: TGroupBox;
    lblSounds: TLabel;
    cmbSounds: TComboBox;
    edtSoundName: TEdit;
    lblSoundName: TLabel;
    btnSoundTest: TButton;
    btnSoundClear: TButton;
    btnSoundBrowse: TButton;
    tabRestrictions: TTabSheet;
    Label1: TLabel;
    grpRestrictions: TGroupBox;
    chkLockBtnEdit: TCheckBox;
    chkLockPadProperty: TCheckBox;
    chkLockOption: TCheckBox;
    btnLockRestrictions: TButton;
    btnUnlockRestrictions: TButton;
    chkLockBtnDrag: TCheckBox;
    tabUserFolder: TTabSheet;
    Label2: TLabel;
    edtUserFolder: TEdit;
    btnUserFolderReset: TButton;
    btnUserFolderOpen: TButton;
    btnHelp: TButton;
    chkLockPlugin: TCheckBox;
    chkLockBtnFolder: TCheckBox;
    chkVerCheck: TCheckBox;
    chkSettingForAllUser: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPluginOptionClick(Sender: TObject);
    procedure btnPluginInfoClick(Sender: TObject);
    procedure lvPluginsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCacheClearClick(Sender: TObject);
    procedure cmbSoundsChange(Sender: TObject);
    procedure edtSoundNameChange(Sender: TObject);
    procedure btnSoundClearClick(Sender: TObject);
    procedure btnSoundBrowseClick(Sender: TObject);
    procedure btnSoundTestClick(Sender: TObject);
    procedure btnPluginEnableClick(Sender: TObject);
    procedure btnPluginDisableClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnLockRestrictionsClick(Sender: TObject);
    procedure btnUnlockRestrictionsClick(Sender: TObject);
    procedure chkTaskTrayClick(Sender: TObject);
    procedure chkLockBtnEditClick(Sender: TObject);
    procedure chkLockBtnFolderClick(Sender: TObject);
    procedure chkLockBtnDragClick(Sender: TObject);
    procedure chkLockPadPropertyClick(Sender: TObject);
    procedure chkLockOptionClick(Sender: TObject);
    procedure chkLockPluginClick(Sender: TObject);
    procedure edtIconCacheChange(Sender: TObject);
    procedure PageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure PageControlChange(Sender: TObject);
    procedure btnUserFolderResetClick(Sender: TObject);
    procedure btnUserFolderOpenClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure chkVerCheckClick(Sender: TObject);
  private
    FRestrictionsPassword: String;
    FEnabledApplyBk: Boolean;
    function SaveIni: Boolean;
    procedure EnabledCheck;
  public
    procedure CreateParams(var Params: TCreateParams); override;
  end;

  TSoundFile = class(TObject)
    FileName: String;
  end;

var
  dlgOption: TdlgOption;

implementation

uses Main, Password;

{$R *.DFM}

// CreateParams
procedure TdlgOption.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := GetDesktopWindow;
end;


// �t�H�[���͂���
procedure TdlgOption.FormCreate(Sender: TObject);
var
  Work: String;
  SoundAction: String;
  SoundFile: TSoundFile;
  i: Integer;
  Plugin: TPlugin;
  ListItem: TListItem;
  Icon:TIcon;
  Ini: TIniFile;
begin
  SetClassLong(Handle, GCL_HICON, Application.Icon.Handle);

  PageControl.ActivePage := PageControl.Pages[0];

  for i := 0 to lvPlugins.Columns.Count - 1 do
    lvPlugins.Columns[i].Width := UserIniFile.ReadInteger(IS_WINDOWS,
      Format('OptionPluginColumns%d', [i]), lvPlugins.Columns[i].Width);

  // �X�V�`�F�b�N
  chkVerCheck.Checked := UserIniFile.ReadBool(IS_OPTIONS, 'VerCheck', True);

  // �^�X�N�g���C
  chkTaskTray.Checked := UserIniFile.ReadBool(IS_OPTIONS, 'TaskTray', True);

  // �A�C�R���L���b�V��
  udIconCache.Position := UserIniFile.ReadInteger(IS_OPTIONS, 'IconCache', 1000);
  lblNowIconCache.Caption := Format('���݂̎g�p�� : %d', [IconCache.CacheCount]);

  // �T�E���h
  for i := 0 to cmbSounds.Items.Count - 1 do
  begin
    SoundFile := TSoundFile.Create;
    cmbSounds.Items.Objects[i] := SoundFile;
    case i of
      0: SoundAction := 'ButtonClick';
      1: SoundAction := 'GroupChange';
      2: SoundAction := 'MoveHide';
      3: SoundAction := 'MoveShow';
    else
      SoundAction := '';
    end;
    if SoundAction <> '' then
    begin
      Work := UserIniFile.ReadString(IS_SOUNDS, SoundAction, '');
      if Work <> '' then
      begin
        SoundFile.FileName := Work;
      end;
    end;
  end;
  cmbSounds.ItemIndex := 0;
  cmbSoundsChange(cmbSounds);

  // ����
  chkLockBtnDrag.Checked := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockBtnDrag', False);
  chkLockBtnEdit.Checked := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockBtnEdit', False);
  chkLockBtnFolder.Checked := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockBtnFolder', False);
  chkLockPadProperty.Checked := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockPadProperty', False);
  chkLockOption.Checked := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockOption', False);
  chkLockPlugin.Checked := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockPlugin', False);
  FRestrictionsPassword :=  UserIniFile.ReadString(IS_RESTRICTIONS, 'Password', '');

  // �f�[�^�t�H���_
  Ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    // �J�����g�f�B���N�g���ړ�
    ChDir(ExtractFilePath(ParamStr(0)));
    chkSettingForAllUser.Checked := Ini.ReadBool(IS_APPGENERAL, 'SettingForAllUser', False);
    edtUserFolder.Text := Ini.ReadString(IS_USERS, UserName, '');
    edtUserFolder.Text := ExpandUNCFileName(edtUserFolder.Text);

    if edtUserFolder.Text = '' then
      btnUserFolderReset.Click;
  finally
    Ini.Free;
  end;


  EnabledCheck;

  // �v���O�C��
  lvPlugins.Items.BeginUpdate;
  try
    for i := 0 to Plugins.Count - 1 do
    begin
      Plugin := TPlugin(Plugins.Objects[i]);
      ListItem := lvPlugins.Items.Add;
      ListItem.Caption := Plugin.Name;
      if Plugin.Enabled then
        ListItem.SubItems.Add('�N��')
      else
        ListItem.SubItems.Add('��~');

      ListItem.SubItems.Add(ExtractFileName(Plugin.FileName));
      ListItem.SubItems.Add(GetFileVersionString(Plugin.FileName, True));
      ListItem.Data := Plugin;
      Icon := TIcon.Create;
      try
        Icon.Handle := IconCache.GetIcon(PChar(Plugin.FileName), ftIconPath, 0, False, False);
        ListItem.ImageIndex := imlPlugins.AddIcon(Icon);
      finally
        Icon.Free;
      end;

      if i = 0 then
        ListItem.Focused := True;
    end;
  finally
    lvPlugins.Items.EndUpdate;
  end;
end;

// �ۑ�
function TdlgOption.SaveIni: Boolean;
var
  i: Integer;
  SoundAction: String;
  Ini: TIniFile;
begin
  Result := True;

  if not UserIniReadOnly then
  begin
    try
      // �X�V�`�F�b�N
      UserIniFile.WriteBool(IS_OPTIONS, 'VerCheck', chkVerCheck.Checked);

      // �^�X�N�g���C
      UserIniFile.WriteBool(IS_OPTIONS, 'TaskTray', chkTaskTray.Checked);

      // �A�C�R���L���b�V��
      UserIniFile.WriteInteger(IS_OPTIONS, 'IconCache', udIconCache.Position);

      // �T�E���h
      for i := 0 to cmbSounds.Items.Count - 1 do
      begin
        case i of
          0: SoundAction := 'ButtonClick';
          1: SoundAction := 'GroupChange';
          2: SoundAction := 'MoveHide';
          3: SoundAction := 'MoveShow';
        else
          SoundAction := '';
        end;

        if SoundAction <> '' then
        begin
          UserIniFile.WriteString(IS_SOUNDS, SoundAction, TSoundFile(cmbSounds.Items.Objects[i]).FileName);
        end;
      end;

      // ����
      UserIniFile.WriteBool(IS_RESTRICTIONS, 'LockBtnDrag', chkLockBtnDrag.Checked);
      UserIniFile.WriteBool(IS_RESTRICTIONS, 'LockBtnEdit', chkLockBtnEdit.Checked);
      UserIniFile.WriteBool(IS_RESTRICTIONS, 'LockBtnFolder', chkLockBtnFolder.Checked);
      UserIniFile.WriteBool(IS_RESTRICTIONS, 'LockPadProperty', chkLockPadProperty.Checked);
      UserIniFile.WriteBool(IS_RESTRICTIONS, 'LockOption', chkLockOption.Checked);
      UserIniFile.WriteBool(IS_RESTRICTIONS, 'LockPlugin', chkLockPlugin.Checked);
      UserIniFile.WriteString(IS_RESTRICTIONS, 'Password', FRestrictionsPassword);

      UserIniFile.UpdateFile;

    except
      Result := False;
      MessageBox(Handle, PChar('�ݒ�t�@�C�� "' + UserIniFile.FileName +
                                   '" �ɏ������߂܂���B'),
                             '�G���[', MB_ICONSTOP);
    end;


    // ���[�U�[�t�H���_���폜
    if Result then
    begin
      if not btnUserFolderReset.Enabled then
      begin
        Ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
        try
          try
            Ini.WriteString(IS_USERS, UserName, '');
          except
            Result := False;
            Application.MessageBox(PChar('�ݒ�t�@�C�� "' + Ini.FileName + '" �ɏ������߂܂���B'),
                                   '�G���[', MB_ICONSTOP);
          end;
        finally
          Ini.Free;
        end;
      end;
    end;

    EnabledCheck;
    frmMain.ChangeOptions;

  end;
  
  if Result then
    btnApply.Enabled := False;
end;

// �t�H�[���I���
procedure TdlgOption.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to cmbSounds.Items.Count - 1 do
    TSoundFile(cmbSounds.Items.Objects[i]).Free;

  imlPlugins.Clear;
  if not UserIniReadOnly then
  begin
    for i := 0 to lvPlugins.Columns.Count - 1 do
      UserIniFile.WriteInteger(IS_WINDOWS, Format('OptionPluginColumns%d', [i]), lvPlugins.Columns[i].Width);
    UserIniFile.UpdateFile;
  end;

  dlgOption := nil;
end;

// ����
procedure TdlgOption.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

// ����O
procedure TdlgOption.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := Enabled;
end;

// �t�H�[��������
procedure TdlgOption.FormShow(Sender: TObject);
begin
  PageControl.ActivePage.SetFocus;

  btnHelp.Enabled := FileExists(Application.HelpFile);
  btnApply.Enabled := False;
end;

// �n�j�{�^��
procedure TdlgOption.btnOkClick(Sender: TObject);
begin
  if SaveIni then
    Close;
end;

// �L�����Z���{�^��
procedure TdlgOption.btnCancelClick(Sender: TObject);
begin
  Close;
end;

// �K�p�{�^��
procedure TdlgOption.btnApplyClick(Sender: TObject);
begin
  SaveIni;
end;

// �^�u��؂�ւ���
procedure TdlgOption.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  FEnabledApplyBk := btnApply.Enabled;
end;

// �^�u��؂�ւ���
procedure TdlgOption.PageControlChange(Sender: TObject);
begin
  btnApply.Enabled := FEnabledApplyBk;
end;

// ����I�� Special Launch �̍X�V���m�F����
procedure TdlgOption.chkVerCheckClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// �^�X�N�g���C�ɃA�C�R����\������
procedure TdlgOption.chkTaskTrayClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// ����炷��ʂ̕ύX
procedure TdlgOption.cmbSoundsChange(Sender: TObject);
begin
  FEnabledApplyBk := btnApply.Enabled;
  if cmbSounds.ItemIndex >= 0 then
    edtSoundName.Text := TSoundFile(cmbSounds.Items.Objects[cmbSounds.ItemIndex]).FileName;
  btnApply.Enabled := FEnabledApplyBk;
end;

// �T�E���h���̕ύX
procedure TdlgOption.edtSoundNameChange(Sender: TObject);
begin
  if cmbSounds.ItemIndex >= 0 then
  begin
    TSoundFile(cmbSounds.Items.Objects[cmbSounds.ItemIndex]).FileName := edtSoundName.Text;
    btnApply.Enabled := True;
  end;
end;

// �T�E���h�̃e�X�g
procedure TdlgOption.btnSoundTestClick(Sender: TObject);
begin
  if edtSoundName.Text <> '' then
    PlaySound(PChar(edtSoundName.Text), 0, SND_ASYNC);
end;

// �T�E���h���̃N���A
procedure TdlgOption.btnSoundClearClick(Sender: TObject);
begin
  edtSoundName.Text := '';
end;

// �T�E���h���̎Q��
procedure TdlgOption.btnSoundBrowseClick(Sender: TObject);
begin
  if FileExists(edtSoundName.Text) then
    dlgOpen.FileName := edtSoundName.Text
  else
    dlgOpen.FileName := '';

  dlgOpen.Filter := '�T�E���h(*.wav)|*.wav|���ׂẴt�@�C��(*.*)|*.*';
  dlgOpen.FilterIndex := 1;

  if dlgOpen.Execute then
    edtSoundName.Text := dlgOpen.FileName;
end;

// �A�C�R���L���b�V��
procedure TdlgOption.edtIconCacheChange(Sender: TObject);
begin
  btnApply.Enabled := True;
end;


// �A�C�R���L���b�V���̃N���A
procedure TdlgOption.btnCacheClearClick(Sender: TObject);
begin
  IconCache.Clear;
  Pads.AllArrange;
  lblNowIconCache.Caption := Format('���݂̎g�p�� : %d', [IconCache.CacheCount]);
  EnabledCheck
end;



// �v���O�C���ꗗ�̕ύX
procedure TdlgOption.lvPluginsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if Change = ctState then
  begin
    EnabledCheck;
  end;
end;

// �v���O�C���̋N��
procedure TdlgOption.btnPluginEnableClick(Sender: TObject);
var
  i: Integer;
  Item: TListItem;
begin
  for i := 0 to Pads.Count - 1 do
    Pads[i].ButtonArrangement.Clear;

  Item := lvPlugins.Selected;
  while Item <> nil do
  begin
    TPlugin(Item.Data).Enabled := True;
    if TPlugin(Item.Data).Enabled then
    begin
      Item.SubItems[0] := '�N��'
    end
    else
    begin
      MessageBox(Handle, '�v���O�C�����N���ł��܂���ł����B', '�m�F', MB_ICONWARNING);
      Item.SubItems[0] := '��~';
    end;
    Item := lvPlugins.GetNextItem(Item, sdAll, [isSelected]);
  end;
  Plugins.SaveEnabled;
  Pads.AllArrange;
  EnabledCheck;
end;

// �v���O�C���̒�~
procedure TdlgOption.btnPluginDisableClick(Sender: TObject);
var
  i: Integer;
  Item: TListItem;
begin
  for i := 0 to Pads.Count - 1 do
    Pads[i].ButtonArrangement.Clear;

  Item := lvPlugins.Selected;
  while Item <> nil do
  begin
    TPlugin(Item.Data).Enabled := False;
    if TPlugin(Item.Data).Enabled then
    begin
      MessageBox(Handle, '�v���O�C������~�ł��܂���ł����B', '�m�F', MB_ICONWARNING);
      Item.SubItems[0] := '�N��'
    end
    else
      Item.SubItems[0] := '��~';
    Item := lvPlugins.GetNextItem(Item, sdAll, [isSelected]);
  end;
  Plugins.SaveEnabled;
  Pads.AllArrange;
  EnabledCheck;
end;

// �v���O�C���̐ݒ�
procedure TdlgOption.btnPluginOptionClick(Sender: TObject);
var
  i: Integer;
  Plugin: TPlugin;
begin
  if lvPlugins.Selected <> nil then
  begin
    Plugin := lvPlugins.Selected.Data;

    if @Plugin.SLXChangeOptions <> nil then
    begin
      Enabled := False;
      try
        if Plugin.SLXChangeOptions(Handle) then
          for i := 0 to Plugin.Buttons.Count - 1 do
            Plugin.UpdateButton(TButtonInfo(Plugin.Buttons[i]));
      finally
        Enabled := True;
        Show;
      end;
    end;

  end;
end;

// �v���O�C���̏��
procedure TdlgOption.btnPluginInfoClick(Sender: TObject);
var
  Plugin: TPlugin;
  cWork: array[0..2047] of Char;
  Explanation: String;
begin
  if lvPlugins.Selected <> nil then
  begin

    Plugin := lvPlugins.Selected.Data;
    if Plugin.Enabled then
    begin
      cWork := '';
      if @Plugin.SLXGetExplanation <> nil then
      begin
        Plugin.SLXGetExplanation(cWork, 2048);
        Explanation := cWork;
      end
      else
      begin
        Explanation := '���̃v���O�C���ɂ͐���������܂���B';
      end;
    end
    else
    begin
      Explanation := '���̃v���O�C���͋N�����Ă��Ȃ����߁A�������擾�ł��܂���B';
    end;

    ShowAbout(Plugin.Name, Plugin.FileName, Explanation);
  end;
end;

// �{�^���̃h���b�O���֎~
procedure TdlgOption.chkLockBtnDragClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// �{�^���̕ҏW���֎~
procedure TdlgOption.chkLockBtnEditClick(Sender: TObject);
begin
  if chkLockBtnEdit.Checked then
  begin
    chkLockBtnDrag.Checked := True;
  end;

  EnabledCheck;
  btnApply.Enabled := True;
end;

// �p�b�h�̐ݒ���֎~
procedure TdlgOption.chkLockPadPropertyClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// �S�̂̐ݒ���֎~
procedure TdlgOption.chkLockOptionClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// �v���O�C���̐ݒ���֎~
procedure TdlgOption.chkLockPluginClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// 1 ��̃t�H���_���J�����֎~
procedure TdlgOption.chkLockBtnFolderClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;



// �����p�X���[�h���b�N
procedure TdlgOption.btnLockRestrictionsClick(Sender: TObject);
var
  sWork: String;
begin
  if FRestrictionsPassword <> '' then
    Exit;

  dlgPassword := TdlgPassword.Create(Self);
  try
    while True do
    begin
      dlgPassword.edtPassword.Text := '';
      dlgPassword.lblMessage.Caption := '���������b�N����p�X���[�h����͂��Ă��������B';
      if dlgPassword.ShowModal = idOk then
      begin
        sWork := dlgPassword.edtPassword.Text;
        dlgPassword.edtPassword.Text := '';
        dlgPassword.lblMessage.Caption := '�m�F�̂��ߍēx���͂��Ă��������B';
        if dlgPassword.ShowModal = idOk then
        begin
          if sWork = dlgPassword.edtPassword.Text then
          begin
            FRestrictionsPassword := dlgPassword.edtPassword.Text;
            btnApply.Enabled := True;
            Break;
          end
          else
            MessageBox(Handle, '�p�X���[�h����v���܂���B', '�m�F', MB_ICONWARNING);
        end
        else
          Break;
      end
      else
        Break;
    end;

  finally
    dlgPassword.Release;
  end;

  EnabledCheck;

end;

// �����p�X���[�h����
procedure TdlgOption.btnUnlockRestrictionsClick(Sender: TObject);
begin
  dlgPassword := TdlgPassword.Create(Self);
  try
    while True do
    begin
      dlgPassword.edtPassword.Text := '';
      dlgPassword.lblMessage.Caption := '�����̃��b�N����������p�X���[�h����͂��Ă��������B';
      if dlgPassword.ShowModal = idOk then
      begin
        if FRestrictionsPassword = dlgPassword.edtPassword.Text then
        begin
          FRestrictionsPassword := '';
          btnApply.Enabled := True;
          Break;
        end
        else
          MessageBox(Handle, '�p�X���[�h���Ⴂ�܂��B', '�m�F', MB_ICONWARNING);
      end
      else
        Break;
    end;

  finally
    dlgPassword.Release;
  end;

  EnabledCheck;
end;

procedure TdlgOption.EnabledCheck;
var
  bLockOption: Boolean;
  bLockPlugin: Boolean;
  OneEnabled, OneDisabled: Boolean;
  Item: TListItem;
begin
  bLockOption := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockOption', False);
  bLockPlugin := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockPlugin', False);

  tabGeneral.TabVisible := not bLockOption;
  tabUserFolder.TabVisible := not bLockOption;



  btnCacheClear.Enabled := IconCache.CacheCount > 0;

  grpRestrictions.Enabled := FRestrictionsPassword = '';
  chkLockBtnDrag.Enabled := (FRestrictionsPassword = '') and (not chkLockBtnEdit.Checked);
  chkLockBtnEdit.Enabled := FRestrictionsPassword = '';
  chkLockPadProperty.Enabled := FRestrictionsPassword = '';
  chkLockOption.Enabled := FRestrictionsPassword = '';
  chkLockPlugin.Enabled := FRestrictionsPassword = '';
  chkLockBtnFolder.Enabled := FRestrictionsPassword = '';
  btnLockRestrictions.Enabled := FRestrictionsPassword = '';
  btnUnlockRestrictions.Enabled := FRestrictionsPassword <> '';

  OneEnabled := False;
  OneDisabled := False;
  Item := lvPlugins.Selected;
  while Item <> nil do
  begin
    OneEnabled := OneEnabled or TPlugin(Item.Data).Enabled;
    OneDisabled := OneDisabled or (not TPlugin(Item.Data).Enabled);
    Item := lvPlugins.GetNextItem(Item, sdAll, [isSelected]);
    if OneEnabled and OneDisabled then
      Break;
  end;
  btnPluginEnable.Enabled := OneDisabled and not bLockPlugin;
  btnPluginDisable.Enabled := OneEnabled and not bLockPlugin;

  btnPluginOption.Enabled := (lvPlugins.SelCount = 1) and not OneDisabled;
  btnPluginInfo.Enabled := (lvPlugins.SelCount = 1) and not OneDisabled;

end;

// �f�[�^�t�H���_��ύX����
procedure TdlgOption.btnUserFolderResetClick(Sender: TObject);
begin
  btnUserFolderReset.Enabled := False;
  btnUserFolderOpen.Enabled := False;

  edtUserFolder.Enabled := False;
  edtUserFolder.Text := '�f�[�^�t�H���_�͎���N�����Ɏw�肵�܂��B';
  btnApply.Enabled := True;
end;

// �f�[�^�t�H���_���J��
procedure TdlgOption.btnUserFolderOpenClick(Sender: TObject);
var
  NormalButton: TNormalButton;
begin
  if not btnUserFolderOpen.Enabled then
    Exit;

  NormalButton := TNormalButton.Create;
  try
    NormalButton.FileName := edtUserFolder.Text;
    OpenNormalButton(Handle, NormalButton);
  finally
    NormalButton.Free;
  end;

end;

// �w���v
procedure TdlgOption.btnHelpClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT, 4);
end;

end.
