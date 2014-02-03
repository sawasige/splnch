unit SetPlug;

interface

uses
  Windows, Messages, SysUtils, Classes, Forms, Dialogs, SetInit,
  SLBtns, ExtCtrls;

const
  BS_ENABLED = 1;
  BS_SELECTED = 2;
  BS_MOUSEENTERED = 4;
  BS_PADACTIVE = 8;
  BS_ISDRAWPLUGIN = 16;

type
  PSLXButtonInfo = ^TSLXButtonInfo;
  TSLXButtonInfo = packed record
    Name: array[0..63] of Char; // �{�^����
    IconIndex: Integer;         // �`��@�\���Ȃ��ꍇ�̃A�C�R���C���f�b�N�X
    OwnerDraw: BOOL;            // �`��@�\������=True
    UpdateInterval: Integer;    // �f�[�^�̍X�V�܂ł̊Ԋu(�~0.1�b)
    OwnerChip: BOOL;            // �Ǝ��`�b�v�@�\������=True
  end;

  PSLXMenuInfo = ^TSLXMenuInfo;
  TSLXMenuInfo = packed record
    Name: array[0..63] of Char; // ���j���[��
    SCut: array[0..63] of Char; // �V���[�g�J�b�g�L�[
  end;

  TButtonInfo = class(TObject)
  private
    FUpdateTimer: TTimer;
    procedure TimerCheck;
    procedure UpdateTimerTimer(Sender: TObject);
  public
    Owner: TObject;
    UpdateButtons: TList;

    Name: string;
    IconIndex: Integer;
    OwnerDraw: Boolean;
    UpdateInterval: Integer;
    OwnerChip: Boolean;

    constructor Create;
    destructor Destroy; override;
    procedure SetInfo(const Info: TSLXButtonInfo);
    procedure SetUpdateButton(SLPluginButton: TSLPluginButton);
    procedure OutUpdateButton(SLPluginButton: TSLPluginButton);
    procedure UpdateButtonsUpdate;
  end;

  TMenuInfo = class(TObject)
    Owner: TObject;

    Name: string;
    SCut: string;

    procedure SetInfo(const Info: TSLXMenuInfo);
  end;


  EIlleagalPluginFile  = class(Exception);

  TPlugin = class(TObject)
  private
    FFileName: string;
    FHandle: THandle;
    FEnabled: Boolean;

    FName: string;
    FButtons: TList;
    FMenus: TList;
    procedure SetFileName(Value: string);
    procedure SetEnabled(Value: Boolean);
    function GetIsSkin: Boolean;
  public
    // �S�ʂ̊֐�
    SLXGetName: function(Name: PChar; Size: Word): BOOL; stdcall;
    SLXGetExplanation: function(Explanation: PChar; Size: Word): BOOL; stdcall;
    SLXSetInitFile: function(InitFile: PChar): BOOL; stdcall;

    SLXBeginPlugin: function: BOOL; stdcall;
    SLXEndPlugin: function: BOOL; stdcall;
    SLXChangeOptions: function(hWnd: HWND): BOOL; stdcall;

    // ��Ԍ��m�p�֐�
    SLXChangePadForeground: function(Wnd: HWND; Foreground: BOOL): BOOL; stdcall;
    SLXChangePadMouseEntered: function(Wnd: HWND; Entered: BOOL): BOOL; stdcall;

    // �{�^���p�֐�
    SLXGetButton: function(No: Integer; ButtonInfo: PSLXButtonInfo): BOOL; stdcall;
    SLXButtonCreate: function(No: Integer; hWnd: HWND; ButtonIndex: Integer): BOOL; stdcall;
    SLXButtonDestroy: function(No: Integer; hWnd: HWND; ButtonIndex: Integer): BOOL; stdcall;
    SLXButtonClick: function(No: Integer; hWnd: HWND): BOOL; stdcall;
    SLXButtonDropFiles: function(No: Integer; hWnd: HWND; Files: PChar): BOOL; stdcall;
    SLXButtonDraw: function(No: Integer; DC: HDC; ARect: PRect): BOOL; stdcall;
    SLXButtonDrawEx: function(No: Integer; hWnd: HWND; GroupIndex, ButtonIndex: Integer; DC: HDC; ARect: PRect): BOOL; stdcall;
    SLXButtonUpdate: function(No: Integer): BOOL; stdcall;
    SLXButtonChip: function(No: Integer; Value: PChar; Size: Word): BOOL; stdcall;
    SLXButtonOptions: function(No: Integer; hWnd: HWND): BOOL; stdcall;

    // ���j���[�p�֐�
    SLXGetMenu: function(No: Integer; MenuInfo: PSLXMenuInfo): BOOL; stdcall;
    SLXMenuClick: function(No: Integer; hWnd: HWND): BOOL; stdcall;
    SLXMenuCheck: function(No: Integer): BOOL; stdcall;

    // �X�L���p�֐�
    SLXBeginSkin: function(hWnd: HWND): BOOL; stdcall;
    SLXDrawDragBar: function(hWnd: HWND; DC: HDC; ARect: PRect; Foreground: BOOL; Position: Integer; Caption: PChar): BOOL; stdcall;
    SLXDrawWorkspace: function(hWnd: HWND; DC: HDC; ARect: PRect; Foreground: BOOL; IsScrollBar: BOOL): BOOL; stdcall;
    SLXDrawButtonFace: function(hWnd: HWND; DC: HDC; ARect: PRect; State: Integer): BOOL; stdcall;
    SLXDrawButtonFrame: function(hWnd: HWND; DC: HDC; ARect: PRect; State: Integer): BOOL; stdcall;
    SLXDrawButtonIcon: function(hWnd: HWND; DC: HDC; ARect: PRect; NormalIcon: HICON; SmallIcon: HICON; State: Integer): BOOL; stdcall;
    SLXDrawButtonCaption: function(hWnd: HWND; DC: HDC; ARect: PRect; Caption: PChar; State: Integer): BOOL; stdcall;
    SLXDrawButtonMask: function(hWnd: HWND; DC: HDC; ARect: PRect; State: Integer): BOOL; stdcall;


    property FileName: string read FFileName write SetFileName;
    property Handle: THandle read FHandle;
    property Enabled: Boolean read FEnabled write SetEnabled;

    property Name: string read FName;
    property Buttons: TList read FButtons;
    property Menus: TList read FMenus;
    property IsSkin: Boolean read GetIsSkin;

    constructor Create;
    destructor Destroy; override;
    procedure UpdateButton(ButtonInfo: TButtonInfo);
    procedure GetButtonInfo;
    procedure GetMenuInfo;
  end;

  TPlugins = class(TStringList)
  private
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;
    procedure BeginPlugins;
    procedure EndPlugins;
    procedure SaveEnabled;
    function FindPlugin(Name: string): TPlugin;
    function FindButtonInfo(Name: string; No: Integer): TButtonInfo;
    function FindMenuInfo(Name: string; No: Integer): TMenuInfo;
    procedure DeletePlugin(Name: string);
  end;

var
  Plugins: TPlugins = nil;

implementation

{ TButtonInfo }

procedure TButtonInfo.TimerCheck;
begin
  if (UpdateButtons.Count = 0) or (UpdateInterval = 0) then
  begin
    FUpdateTimer.Free;
    FUpdateTimer := nil;
  end
  else
  begin
    if FUpdateTimer = nil then
    begin
      FUpdateTimer := TTimer.Create(nil);
      FUpdateTimer.Interval := UpdateInterval * 100;
      FUpdateTimer.OnTimer := UpdateTimerTimer;
      FUpdateTimer.Enabled := True;
    end;
  end;
end;


procedure TButtonInfo.UpdateTimerTimer(Sender: TObject);
begin
  TPlugin(Owner).UpdateButton(Self);
end;

constructor TButtonInfo.Create;
begin
  inherited;
  UpdateButtons := TList.Create;
end;

destructor TButtonInfo.Destroy;
begin
  UpdateButtons.Free;
  FUpdateTimer.Free;
  FUpdateTimer := nil;
  inherited;
end;

procedure TButtonInfo.SetInfo(const Info: TSLXButtonInfo);
begin
  Name := Info.Name;
  IconIndex := Info.IconIndex;
  OwnerDraw := Info.OwnerDraw;
  UpdateInterval := Info.UpdateInterval;
  OwnerChip := Info.OwnerChip;
end;

procedure TButtonInfo.SetUpdateButton(SLPluginButton: TSLPluginButton);
begin
  UpdateButtons.Add(SLPluginButton);
  TimerCheck;
end;

procedure TButtonInfo.OutUpdateButton(SLPluginButton: TSLPluginButton);
var
  Index: Integer;
begin
  Index := UpdateButtons.IndexOf(SLPluginButton);
  while Index >= 0 do
  begin
    UpdateButtons.Delete(Index);
    Index := UpdateButtons.IndexOf(SLPluginButton);
  end;
  TimerCheck;
end;

procedure TButtonInfo.UpdateButtonsUpdate;
var
  i: Integer;
begin
  for i := 0 to UpdateButtons.Count - 1 do
    TSLPluginButton(UpdateButtons[i]).Refresh;
end;

{ TMenuInfo }

procedure TMenuInfo.SetInfo(const Info: TSLXMenuInfo);
begin
  Name := Info.Name;
  SCut := Info.SCut;
end;

{ TPlugin }

constructor TPlugin.Create;
begin
  inherited;
  FButtons := TList.Create;
  FMenus := TList.Create;
end;

destructor TPlugin.Destroy;
begin
  Enabled := False;
  Buttons.Free;
  Menus.Free;
  inherited;
end;

procedure TPlugin.SetFileName(Value: string);
var
  cWork: array[0..255] of Char;
begin
  FFileName := Value;

  FHandle := LoadLibrary(PChar(FFileName));
  if Handle = 0 then
    raise EIlleagalPluginFile.Create('�v���O�C�� "' + FFileName +
                                 '" �͗L����DLL�ł͂���܂���B' +
                                 '�v���O�C���̐������ɖ₢���킹�Ă��������B');

  @SLXGetName := GetProcAddress(Handle, 'SLXGetName');
  if @SLXGetName = nil then
    raise EIlleagalPluginFile.Create('�v���O�C�� "' + FFileName +
                                 '" �ɂ͕K�v�Ȋ֐��G���g��������܂���B' +
                                 '�v���O�C���̐������ɖ₢���킹�Ă��������B');
  SLXGetName(cWork, 256);
  FName := cWork;

  Enabled := False;
end;

procedure TPlugin.SetEnabled(Value: Boolean);
var
  sWork: string;
  i: Integer;
begin
//  if Value = FEnabled then
//    Exit;

  FEnabled := Value;
  if FEnabled then
  begin

    // ������
    @SLXGetName := nil;
    @SLXGetExplanation := nil;
    @SLXSetInitFile := nil;
    @SLXBeginPlugin := nil;
    @SLXEndPlugin := nil;
    @SLXChangeOptions := nil;
    @SLXChangePadForeground := nil;
    @SLXChangePadMouseEntered := nil;
    @SLXGetButton := nil;
    @SLXButtonCreate := nil;
    @SLXButtonDestroy := nil;
    @SLXButtonClick := nil;
    @SLXButtonDropFiles := nil;
    @SLXButtonDraw := nil;
    @SLXButtonDrawEx := nil;
    @SLXButtonUpdate := nil;
    @SLXButtonChip := nil;
    @SLXButtonOptions := nil;
    @SLXGetMenu := nil;
    @SLXMenuClick := nil;
    @SLXMenuCheck := nil;
    @SLXBeginSkin := nil;
    @SLXDrawDragBar := nil;
    @SLXDrawWorkspace := nil;
    @SLXDrawButtonFace := nil;
    @SLXDrawButtonFrame := nil;
    @SLXDrawButtonIcon := nil;
    @SLXDrawButtonCaption := nil;
    @SLXDrawButtonMask := nil;
    for i := 0 to FButtons.Count - 1 do
      TButtonInfo(FButtons[i]).Free;
    FButtons.Clear;
    for i := 0 to FMenus.Count - 1 do
      TMenuInfo(FMenus[i]).Free;
    FMenus.Clear;

    if FHandle = 0 then
    begin
      FHandle := LoadLibrary(PChar(FFileName));
      if Handle = 0 then
        raise EIlleagalPluginFile.Create('�v���O�C�� "' + FFileName +
                                     '" �͗L����DLL�ł͂���܂���B' +
                                     '�v���O�C���̐������ɖ₢���킹�Ă��������B');
    end;

    @SLXGetName := GetProcAddress(Handle, 'SLXGetName');
    @SLXGetExplanation := GetProcAddress(Handle, 'SLXGetExplanation');
    @SLXSetInitFile := GetProcAddress(Handle, 'SLXSetInitFile');
    @SLXBeginPlugin := GetProcAddress(Handle, 'SLXBeginPlugin');
    @SLXEndPlugin := GetProcAddress(Handle, 'SLXEndPlugin');
    @SLXChangeOptions := GetProcAddress(Handle, 'SLXChangeOptions');
    @SLXChangePadForeground := GetProcAddress(Handle, 'SLXChangePadForeground');
    @SLXChangePadMouseEntered := GetProcAddress(Handle, 'SLXChangePadMouseEntered');
    @SLXBeginSkin := GetProcAddress(Handle, 'SLXBeginSkin');
    @SLXDrawDragBar := GetProcAddress(Handle, 'SLXDrawDragBar');
    @SLXDrawWorkspace := GetProcAddress(Handle, 'SLXDrawWorkspace');
    @SLXDrawButtonFace := GetProcAddress(Handle, 'SLXDrawButtonFace');
    @SLXDrawButtonFrame := GetProcAddress(Handle, 'SLXDrawButtonFrame');
    @SLXDrawButtonIcon := GetProcAddress(Handle, 'SLXDrawButtonIcon');
    @SLXDrawButtonCaption := GetProcAddress(Handle, 'SLXDrawButtonCaption');
    @SLXDrawButtonMask := GetProcAddress(Handle, 'SLXDrawButtonMask');

    // IniFile
    if @SLXSetInitFile <> nil then
    begin
      sWork := ExtractFileName(FFileName);
      sWork := Copy(sWork, 1, Length(sWork) - Length(ExtractFileExt(FFileName)));
      sWork := UserFolder + sWork + '.ini';
      SLXSetInitFile(PChar(sWork));
    end;

    GetButtonInfo;
    GetMenuInfo;

    // �v���O�C���J�n
    if @SLXBeginPlugin <> nil then
    begin
      if not SLXBeginPlugin then
        FEnabled := False;
    end;
  end;

  if not FEnabled then
  begin
    if @SLXEndPlugin <> nil then
    begin
      if not SLXEndPlugin then
        FEnabled := True;
    end;

    if not FEnabled then
    begin
      if FHandle <> 0 then
      begin
        // DLL ���J������O�Ɋe�C�x���g�����s���Ă���
        Application.ProcessMessages;
        FreeLibrary(FHandle);
        FHandle := 0;
      end;

      @SLXGetName := nil;
      @SLXGetExplanation := nil;
      @SLXSetInitFile := nil;
      @SLXBeginPlugin := nil;
      @SLXEndPlugin := nil;
      @SLXChangeOptions := nil;
      @SLXChangePadForeground := nil;
      @SLXChangePadMouseEntered := nil;
      @SLXGetButton := nil;
      @SLXButtonCreate := nil;
      @SLXButtonDestroy := nil;
      @SLXButtonClick := nil;
      @SLXButtonDropFiles := nil;
      @SLXButtonDraw := nil;
      @SLXButtonDrawEx := nil;
      @SLXButtonUpdate := nil;
      @SLXButtonChip := nil;
      @SLXButtonOptions := nil;
      @SLXGetMenu := nil;
      @SLXMenuClick := nil;
      @SLXMenuCheck := nil;
      @SLXBeginSkin := nil;
      @SLXDrawDragBar := nil;
      @SLXDrawWorkspace := nil;
      @SLXDrawButtonFace := nil;
      @SLXDrawButtonFrame := nil;
      @SLXDrawButtonIcon := nil;
      @SLXDrawButtonCaption := nil;
      @SLXDrawButtonMask := nil;

      for i := 0 to FButtons.Count - 1 do
        TButtonInfo(FButtons[i]).Free;
      FButtons.Clear;
      for i := 0 to FMenus.Count - 1 do
        TMenuInfo(FMenus[i]).Free;
      FMenus.Clear;
    end;

  end;
end;

function TPlugin.GetIsSkin: Boolean;
begin
  Result := (@SLXBeginSkin <> nil) or
    (@SLXDrawDragBar <> nil) or
    (@SLXDrawWorkspace <> nil) or
    (@SLXDrawButtonFace <> nil) or
    (@SLXDrawButtonFrame <> nil) or 
    (@SLXDrawButtonIcon <> nil) or
    (@SLXDrawButtonCaption <> nil) or
    (@SLXDrawButtonMask <> nil);
end;


procedure TPlugin.UpdateButton(ButtonInfo: TButtonInfo);
var
  No: Integer;
begin
  No := FButtons.IndexOf(ButtonInfo);
  if No >= 0 then
    if @SLXButtonUpdate <> nil then
      if SLXButtonUpdate(No) and ButtonInfo.OwnerDraw then
        ButtonInfo.UpdateButtonsUpdate;
end;


procedure TPlugin.GetButtonInfo;
var
  i: Integer;
  SLXButtonInfo: PSLXButtonInfo;
  ButtonInfo: TButtonInfo;
begin
  for i := 0 to FButtons.Count - 1 do
    TButtonInfo(FButtons[i]).Free;
  FButtons.Clear;

  @SLXGetButton := GetProcAddress(Handle, 'SLXGetButton');
  if @SLXGetButton <> nil then
  begin
    New(SLXButtonInfo);
    try
      while SLXGetButton(FButtons.Count, SLXButtonInfo) do
      begin
        ButtonInfo := TButtonInfo.Create;
        ButtonInfo.SetInfo(SLXButtonInfo^);
        ButtonInfo.Owner := Self;
        FButtons.Add(ButtonInfo);
      end;
    finally
      Dispose(SLXButtonInfo);
    end;
  end;

  // �{�^���p�֐����Z�b�g
  if Buttons.Count > 0 then
  begin
    @SLXButtonCreate := GetProcAddress(FHandle, 'SLXButtonCreate');
    @SLXButtonDestroy := GetProcAddress(FHandle, 'SLXButtonDestroy');
    @SLXButtonClick := GetProcAddress(FHandle, 'SLXButtonClick');
    @SLXButtonDropFiles := GetProcAddress(FHandle, 'SLXButtonDropFiles');
    @SLXButtonDraw := GetProcAddress(FHandle, 'SLXButtonDraw');
    @SLXButtonDrawEx := GetProcAddress(FHandle, 'SLXButtonDrawEx');
    @SLXButtonUpdate := GetProcAddress(FHandle, 'SLXButtonUpdate');
    @SLXButtonChip := GetProcAddress(FHandle, 'SLXButtonChip');
    @SLXButtonOptions := GetProcAddress(FHandle, 'SLXButtonOptions');
  end
  else
  begin
    @SLXButtonCreate := nil;
    @SLXButtonDestroy := nil;
    @SLXButtonClick := nil;
    @SLXButtonDropFiles := nil;
    @SLXButtonDraw := nil;
    @SLXButtonDrawEx := nil;
    @SLXButtonUpdate := nil;
    @SLXButtonChip := nil;
    @SLXButtonOptions := nil;
  end;

end;

procedure TPlugin.GetMenuInfo;
var
  i: Integer;
  SLXMenuInfo: PSLXMenuInfo;
  MenuInfo: TMenuInfo;
begin
  for i := 0 to FMenus.Count - 1 do
    TMenuInfo(FMenus[i]).Free;
  FMenus.Clear;

  @SLXGetMenu := GetProcAddress(Handle, 'SLXGetMenu');
  if @SLXGetMenu <> nil then
  begin
    New(SLXMenuInfo);
    try
      while SLXGetMenu(FMenus.Count, SLXMenuInfo) do
      begin
        MenuInfo := TMenuInfo.Create;
        MenuInfo.SetInfo(SLXMenuInfo^);
        MenuInfo.Owner := Self;
        FMenus.Add(MenuInfo);
      end;
    finally
      Dispose(SLXMenuInfo);
    end;
  end;

  if Menus.Count > 0 then
  begin
    @SLXMenuClick := GetProcAddress(FHandle, 'SLXMenuClick');
    @SLXMenuCheck := GetProcAddress(FHandle, 'SLXMenuCheck');
  end
  else
  begin
    @SLXMenuClick := nil;
    @SLXMenuCheck := nil;
  end;
end;

{ TPlugins }
constructor TPlugins.Create;
var
  PluginPath: string;
  FindHandle: THandle;
  Win32FindData: TWin32FindData;
  Plugin: TPlugin;
  i: Integer;
begin
  inherited;

  PluginPath := ExtractFilePath(ParamStr(0)) + 'Plugins\';
  if not DirectoryExists(PluginPath) then
    ForceDirectories(PluginPath);
//  PluginPath := ExtractFilePath(ParamStr(0));
  FindHandle := FindFirstFile(PChar(PluginPath + '*.slx'), Win32FindData);
  if FindHandle <> INVALID_HANDLE_VALUE then
  begin
    while True do
    begin
      Plugin := TPlugin.Create;
      try
        Plugin.FileName := PluginPath + Win32FindData.cFileName;
        i := IndexOf(Plugin.Name);
        if i >= 0 then
          raise EIlleagalPluginFile.Create('�v���O�C�� "' +
            Plugin.FileName + '" �͂��łɓ������O�̃v���O�C�� "' +
            TPlugin(Objects[i]).FileName +
            '" ���o�^����Ă��܂��B' +
            '�v���O�C���̐������ɖ₢���킹�Ă��������B');
        AddObject(Plugin.Name, Plugin);
      except
        on E: Exception do
        begin
          Application.MessageBox(PChar(E.Message), '�x��', MB_ICONWARNING);
          Plugin.Free;
        end;
        else
          Plugin.Free;
      end;

      if not FindNextFile(FindHandle, Win32FindData) then
        Break;
    end;
    Windows.FindClose(FindHandle)
  end;

end;

destructor TPlugins.Destroy;
begin
  Clear;
  inherited;
end;

procedure TPlugins.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    TPlugin(Objects[i]).Free;
  inherited;
end;

// �v���O�C���J�n
procedure TPlugins.BeginPlugins;
var
  i: Integer;
  Plugin: TPlugin;
  PluginName: string;
  EnablePlugins: TStringList;
  DisablePlugins: TStringList;
  Msg: String;
begin
  EnablePlugins := TStringList.Create;
  DisablePlugins := TStringList.Create;
  try
    i := 0;
    while True do
    begin
      PluginName := UserIniFile.ReadString(IS_ENABLEPLUGINS, IntToStr(i), '');
      if PluginName = '' then
        Break;
      EnablePlugins.Add(PluginName);
      Inc(i);
    end;
    i := 0;
    while True do
    begin
      PluginName := UserIniFile.ReadString(IS_DISABLEPLUGINS, IntToStr(i), '');
      if PluginName = '' then
        Break;
      DisablePlugins.Add(PluginName);
      Inc(i);
    end;

    for i := 0 to Count - 1 do
    begin
      Plugin := TPlugin(Objects[i]);
      if EnablePlugins.IndexOf(Plugin.Name) >= 0 then
      begin
        Plugin.Enabled := True;
      end
      else if DisablePlugins.IndexOf(Plugin.Name) >= 0 then
      begin
        Plugin.Enabled := False;
      end
      else if UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockPlugin', False) then
      begin
        Plugin.Enabled := False;
      end
      else
      begin
        Msg := '�V�����v���O�C�� "' + Plugin.Name + '" ��������܂����B' +
               '�����ɋN�����Ďg�p���܂����H';
        Plugin.Enabled := MessageBox(GetDesktopWindow, PChar(Msg), 'Special Launch', MB_ICONQUESTION or MB_YESNO) = idYes;
      end;
    end;

  finally
    EnablePlugins.Free;
    DisablePlugins.Free;
  end;

  SaveEnabled;
end;

procedure TPlugins.EndPlugins;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    TPlugin(Objects[i]).Enabled := False;
end;


procedure TPlugins.SaveEnabled;
var
  i, Ei, Di: Integer;
  Plugin: TPlugin;
begin
  if not UserIniReadOnly then
  begin
    UserIniFile.EraseSection(IS_ENABLEPLUGINS);
    UserIniFile.EraseSection(IS_DISABLEPLUGINS);
    UserIniFile.UpdateFile;
    Ei := 0;
    Di := 0;
    for i := 0 to Count - 1 do
    begin
      Plugin := TPlugin(Objects[i]);
      if Plugin.Enabled then
      begin
        UserIniFile.WriteString(IS_ENABLEPLUGINS, IntToStr(Ei), Plugin.Name);
        Inc(Ei);
      end
      else
      begin
        UserIniFile.WriteString(IS_DISABLEPLUGINS, IntToStr(Di), Plugin.Name);
        Inc(Di);
      end;
    end;
    UserIniFile.UpdateFile;
  end;
end;

function TPlugins.FindPlugin(Name: string): TPlugin;
var
  Index: Integer;
begin
  Index := IndexOf(Name);
  if Index >= 0 then
    Result := TPlugin(Objects[Index])
  else
    Result := nil;
end;


function TPlugins.FindButtonInfo(Name: string; No: Integer): TButtonInfo;
var
  Index: Integer;
  Plugin: TPlugin;
begin
  Result := nil;
  Index := IndexOf(Name);
  if Index < 0 then
    Exit;

  Plugin := TPlugin(Objects[Index]);
  if Plugin = nil then
    Exit;

  if (No >= 0) and (No < Plugin.Buttons.Count) then
    Result := Plugin.Buttons[No];
end;

function TPlugins.FindMenuInfo(Name: string; No: Integer): TMenuInfo;
var
  Index: Integer;
  Plugin: TPlugin;
begin
  Result := nil;
  Index := IndexOf(Name);
  if Index < 0 then
    Exit;

  Plugin := TPlugin(Objects[Index]);
  if Plugin = nil then
    Exit;

  if (No >= 0) and (No < Plugin.Menus.Count) then
    Result := Plugin.Menus[No];
end;

procedure TPlugins.DeletePlugin(Name: string);
var
  Index: integer;
begin
  Index := IndexOf(Name);
  if Index >= 0 then
  begin
    TPlugin(Objects[Index]).Free;
    Delete(Index);
  end;
end;

end.
