unit SLAPI;

interface

uses
  Windows, Messages, SysUtils, Graphics, SetPads, Pad, Main, SetPlug,
  ShlObj, SetBtn, ActiveX, OleBtn, SetArrg, About, SetIcons, pidl;


const
  // PadX.ini �� DragBar �̒l
  DS_NONE = 0; // �\�����Ȃ�
  DS_LEFT = 1; // ��
  DS_TOP = 2; // ��
  DS_RIGHT = 3; // �E
  DS_BOTTOM = 4; // ��

  // PadX.ini �� DropAction �v���p�e�B�̒l
  DA_ADDHERE = 0; // �h���b�v�����ꏊ�ɒǉ�
  DA_ADDLAST = 1; // �Ō�ɒǉ�
  DA_OPENHERE = 2; // �h���b�v��̃{�^���ŊJ��
  DA_COPYNAME = 3; // �t�@�C�������R�s�[

  // PadX.ini �� BtnCaption �v���p�e�B�̒l
  CA_COMLINE = 0; // �w�肵�Ď��s���J��
  CA_BTNEDIT = 1; // �{�^���̕ҏW���J��
  CA_GRPCHANGE = 2; // �{�^���O���[�v�ύX���j���[���J��
  CA_NEXTGROUP = 3; // ���̃{�^���O���[�v�ֈړ�����
  CA_PADPRO = 4; // �p�b�h�̐ݒ���J��
  CA_OPTION = 5; // �S�̂̐ݒ���J��
  CA_HIDE = 6; // �p�b�h���B��

  // PadX.ini �� BtnCaption �v���p�e�B�̒l
  CP_NONE = 0; // �{�^������\�����Ȃ�
  CP_BOTTOM = 1; // �A�C�R���̉�
  CP_RIGHT = 2; // �A�C�R���̉E

type
  // �{�^���O���[�v�̏��
  PSLAGroup = ^TSLAGroup;
  TSLAGroup = packed record
    PadID: Integer; // ��������p�b�h��ID�i�ǂݎ��̂݁j
    GroupIndex: Integer; // �O���[�v�̃C���f�b�N�X�i�ǂݎ��̂݁j

    Name: array[0..1023] of Char; // �{�^���O���[�v��
    ButtonCount: Integer; // �{�^���̐��i�ǂݎ��̂݁j
  end;

const
  // TSLAButton �� Kind �̒l
  BK_SPACE = 0;
  BK_RETURN = 1;
  BK_NORMAL = 2;
  BK_PLUGIN = 3;

  // TSLAButton �� WindowSize �̒l
  BW_NORMAL = 0;
  BW_MINIMIZED = 1;
  BW_MAXMIZED = 2;

type
  // �{�^���̏��
  PSLAButton = ^TSLAButton;
  TSLAButton = packed record
    PadID: Integer; // ��������p�b�h��ID�i�ǂݎ��̂݁j
    GroupIndex: Integer; // �O���[�v�̃C���f�b�N�X�i�ǂݎ��̂݁j
    ButtonIndex: Integer; // �{�^���̃C���f�b�N�X�i�ǂݎ��̂݁j

    ScreenRect: TRect; // ��ʏ�ł̍��W�i�ǂݎ��̂݁j

    Name: array[0..1023] of Char; // �{�^����
    ClickCount: Integer; // �N���b�N��
    Kind: Integer; // �{�^���̎��

    FileName: array[0..1023] of Char; // �����N��̃t�@�C����
    ItemIDList: PItemIDList; // �����N���PIDL
    Option: array[0..1023] of Char; // ���s������
    Folder: array[0..1023] of Char; // ��Ɨp�t�H���_
    WindowSize: Integer; // ���s���̑傫��
    IconFile: array[0..1023] of Char; // �A�C�R���t�@�C��
    IconIndex: Integer; // �A�C�R���̃C���f�b�N�X

    PluginName: array[0..1023] of Char; // �v���O�C���̖��O
    PluginNo: Integer; // �v���O�C���{�^���̔ԍ�
  end;

const
  // SLAGetIcon �� FileType �̒l
  FT_ICONPATH = 0; // �A�C�R�����܂܂��t�@�C���ւ̃p�X
  FT_FILEPATH = 1; // �ʏ�̃t�@�C���ւ̃p�X
  FT_PIDL = 2; // PIDL

// �p�b�h�̐����擾����
function SLAGetPadCount: Integer; stdcall;
// hWnd ���� PadID ���擾����
function SLAGetPadID(hWnd: HWND): Integer; stdcall;
// PadID ���玟�� PadID ���擾����
function SLAGetNextPadID(ID: Integer): Integer; stdcall;
// PadID ����p�b�h�̃E�B���h�E�n���h�����擾����
function SLAGetPadWnd(ID: Integer): HWND; stdcall;
// PadID ����p�b�h�̉B��Ă��鎞�̃E�B���h�E�n���h�����擾����
function SLAGetPadTabWnd(ID: Integer): HWND; stdcall;
// �p�b�h�̃v���p�e�B�� 1 �擾
function SLAGetPadInit(ID: Integer; Key: PChar; Buf: PChar; BufSize: Integer): BOOL; stdcall;
// �p�b�h�̃v���p�e�B�� 1 �Z�b�g
function SLASetPadInit(ID: Integer; Key: PChar; Item: PChar): BOOL; stdcall;

// �v���O�C���{�^�����擾���Ȃ���
function SLAChangePluginButtons(Name: PChar): BOOL; stdcall;
// �v���O�C�����j���[���擾���Ȃ���
function SLAChangePluginMenus(Name: PChar): BOOL; stdcall;
// �v���O�C���{�^�����ĕ`�悷��
function SLARedrawPluginButtons(Name: PChar; No: Integer): BOOL; stdcall;

// �{�^���O���[�v�̐����擾����
function SLAGetGroupCount(ID: Integer): Integer; stdcall;
// �{�^���O���[�v�̏����擾����
function SLAGetGroup(ID, GroupIndex: Integer; Group: PSLAGroup): BOOL; stdcall;
// �{�^���O���[�v��}������
function SLAInsertGroup(ID, GroupIndex: Integer; Name: PChar): BOOL; stdcall;
// �{�^���O���[�v�̖��O��ύX����
function SLARenameGroup(ID, GroupIndex: Integer; Name: PChar): BOOL; stdcall;
// �{�^���O���[�v�𕡐�����
function SLACopyGroup(ID, GroupIndex, NewIndex: Integer): BOOL; stdcall;
// �{�^���O���[�v���폜����
function SLADeleteGroup(ID, GroupIndex: Integer): BOOL; stdcall;

// �{�^���̏����擾����
function SLAGetButton(ID, GroupIndex, ButtonIndex: Integer; Button: PSLAButton): BOOL; stdcall;
// �{�^����}������
function SLAInsertButton(ID, GroupIndex, ButtonIndex: Integer; Button: PSLAButton): BOOL; stdcall;
// �{�^����ύX����
function SLAChangeButton(ID, GroupIndex, ButtonIndex: Integer; Button: PSLAButton): BOOL; stdcall;
// �{�^�����폜����
function SLADeleteButton(ID, GroupIndex, ButtonIndex: Integer): BOOL; stdcall;
// �{�^�����N���b�v�{�[�h�ɃR�s�[����
function SLACopyButton(ID, GroupIndex, ButtonIndex: Integer): BOOL; stdcall;
// �{�^�����N���b�v�{�[�h����\��t����
function SLAPasteButton(ID, GroupIndex, ButtonIndex: Integer): BOOL; stdcall;
// �N���b�v�{�[�h�Ƀ{�^���œ\��t������f�[�^�����邩��Ԃ�
function SLAButtonInClipbord: BOOL; stdcall;
// �{�^���f�[�^�����s����
function SLARunButton(ID: Integer; Button: PSLAButton): BOOL; stdcall;
// �A�C�R�����擾����
function SLAGetIcon(FilePoint: Pointer; FileType, IconIndex: Integer; SmallIcon, UseCache: BOOL): HIcon; stdcall;


implementation

uses
  BtnPro;

// �p�b�h�̐����擾����
function SLAGetPadCount: Integer;
begin
  Result := Pads.Count;
end;

// hWnd ���� PadID ���擾����
function SLAGetPadID(hWnd: HWND): Integer;
var
  i: Integer;
begin
  i := 0;
  Result := -1;
  while i < Pads.Count do
  begin
    if Pads[i].Handle = hWnd then
    begin
      Result := Pads[i].ID;
      Break;
    end
    else if Pads[i].frmPadTab.Handle = hWnd then
    begin
      Result := Pads[i].ID;
      Break;
    end;
    Inc(i);
  end;
end;

// PadID ���玟�� PadID ���擾����
function SLAGetNextPadID(ID: Integer): Integer;
var
  Index: Integer;
begin
  Index := Pads.IndexOfPadID(ID);
  if Index < 0 then
  begin
    if Pads.Count = 0 then
      Result := -1
    else
      Result := Pads[0].ID;
  end
  else
  begin
    Inc(Index);
    if Index >= Pads.Count then
      Index := 0;
    Result := Pads[Index].ID;
  end;

end;


// PadID ����p�b�h�̃E�B���h�E�n���h�����擾����
function SLAGetPadWnd(ID: Integer): HWND;
var
  Pad: TfrmPad;
begin
  Result := 0;
  Pad := Pads.PadOfID(ID);

  if Pad = nil then
    Exit;

  Result := Pad.Handle;
end;

// PadID ����p�b�h�̉B��Ă��鎞�̃E�B���h�E�n���h�����擾����
function SLAGetPadTabWnd(ID: Integer): HWND;
var
  Pad: TfrmPad;
begin
  Result := 0;
  Pad := Pads.PadOfID(ID);

  if Pad = nil then
    Exit;

  Result := Pad.frmPadTab.Handle;
end;

// �p�b�h�̃v���p�e�B�� 1 �擾
function SLAGetPadInit(ID: Integer; Key: PChar; Buf: PChar; BufSize: Integer): BOOL;
var
  s: String;
  Pad: TfrmPad;
const
  BooleanValues: array[Boolean] of string = ('0', '1');
begin
  Result := False;

  Pad := Pads.PadOfID(ID);
  if Pad = nil then
    Exit;

  s := '';
  if Key = 'ID' then s := IntToStr(Pad.ID)

  else if Key = 'Left' then s := IntToStr(Pad.Left)
  else if Key = 'Top' then s := IntToStr(Pad.Top)
  else if Key = 'Cols' then s := IntToStr(Pad.Cols)
  else if Key = 'Rows' then s := IntToStr(Pad.Rows)
  else if Key = 'GroupIndex' then s := IntToStr(Pad.GroupIndex)
  else if Key = 'ScrollBar' then s := IntToStr(Pad.ScrollBar)
  else if Key = 'ScrollBtn' then s := BooleanValues[Pad.ScrollBtn]
  else if Key = 'GroupBtn' then s := BooleanValues[Pad.GroupBtn]
  else if Key = 'ScrollSize' then s := IntToStr(Pad.ScrollSize)
  else if Key = 'BtnVertical' then s := BooleanValues[Pad.BtnVertical]
  else if Key = 'BtnFocusColor' then s := IntToStr(Pad.BtnFocusColor)
  else if Key = 'BtnTransparent' then s := BooleanValues[Pad.BtnTransparent]
  else if Key = 'BtnSelTransparent' then s := BooleanValues[Pad.BtnSelTransparent]
  else if Key = 'BtnSmallIcon' then s := BooleanValues[Pad.BtnSmallIcon]
  else if Key = 'BtnSquare' then s := BooleanValues[Pad.BtnSquare]
  else if Key = 'BtnWidth' then s := IntToStr(Pad.BtnWidth)
  else if Key = 'BtnHeight' then s := IntToStr(Pad.BtnHeight)
  else if Key = 'BtnCaption' then s := IntToStr(Pad.BtnCaption)
  else if Key = 'BtnColor' then s := IntToStr(Pad.BtnColor)

  else if Key = 'TopLineIndex' then s := IntToStr(Pad.TopLineIndex)
  else if Key = 'ButtonIndex' then s := IntToStr(Pad.ButtonIndex)

//  else if Key = 'PropertyPageNo' then s := IntToStr(Pad.PropertyPageNo)
  else if Key = 'TopMost' then s := BooleanValues[Pad.TopMost]
  else if Key = 'SmoothScroll' then s := BooleanValues[Pad.SmoothScroll]
  else if Key = 'Hotkey' then s := IntToStr(Pad.Hotkey)
  else if Key = 'DropAction' then s := IntToStr(Pad.DropAction)
  else if Key = 'DblClickAction' then s := IntToStr(Pad.DblClickAction)
  else if Key = 'BackColor' then s := IntToStr(Pad.BackColor)
  else if Key = 'WallPaper' then s := Pad.WallPaper
  else if Key = 'DragBar' then s := IntToStr(Pad.DragBar)
  else if Key = 'GroupName' then s := BooleanValues[Pad.GroupName]
  else if Key = 'DragBarSize' then s := IntToStr(Pad.DragBarSize)
  else if Key = 'HideAuto' then s := BooleanValues[Pad.HideAuto]
  else if Key = 'HideSmooth' then s := BooleanValues[Pad.HideSmooth]
  else if Key = 'HideMouseCheck' then s := BooleanValues[Pad.HideMouseCheck]
  else if Key = 'HideVertical' then s := BooleanValues[Pad.HideVertical]
  else if Key = 'HideGroupName' then s := BooleanValues[Pad.HideGroupName]
  else if Key = 'HideSize' then s := IntToStr(Pad.HideSize)
  else if Key = 'ShowDelay' then s := IntToStr(Pad.ShowDelay)
  else if Key = 'HideDelay' then s := IntToStr(Pad.HideDelay)
  else if Key = 'HideColor' then s := IntToStr(Pad.HideColor)
  else
    Exit;

  if Length(s) < BufSize then
  begin
    Result := True;
    StrPCopy(Buf, s);
  end;
end;

// �p�b�h�̃v���p�e�B�� 1 �Z�b�g
function SLASetPadInit(ID: Integer; Key: PChar; Item: PChar): BOOL; 
var
  Pad: TfrmPad;
const
  BooleanValues: array[Boolean] of string = ('0', '1');
begin
  Result := False;

  Pad := Pads.PadOfID(ID);
  if Pad = nil then
    Exit;
  if Pad.DialogBox <> nil then
    Exit;
  if Pad.GetLockPadProperty(True) then
    Exit;


  Result := True;
  try
    if Key = 'Left' then Pad.Left := StrToInt(Item)
    else if Key = 'Top' then Pad.Top := StrToInt(Item)
    else if Key = 'Cols' then Pad.Cols := StrToInt(Item)
    else if Key = 'Rows' then Pad.Rows := StrToInt(Item)
    else if Key = 'GroupIndex' then Pad.GroupIndex := StrToInt(Item)
    else if Key = 'ScrollBar' then Pad.ScrollBar := StrToInt(Item)
    else if Key = 'ScrollBtn' then Pad.ScrollBtn := Item <> '0'
    else if Key = 'GroupBtn' then Pad.GroupBtn := Item <> '0'
    else if Key = 'ScrollSize' then Pad.ScrollSize := StrToInt(Item)
    else if Key = 'BtnVertical' then Pad.BtnVertical := Item <> '0'
    else if Key = 'BtnFocusColor' then Pad.BtnFocusColor := StrToInt(Item)
    else if Key = 'BtnTransparent' then Pad.BtnTransparent := Item <> '0'
    else if Key = 'BtnSelTransparent' then Pad.BtnSelTransparent := Item <> '0'
    else if Key = 'BtnSmallIcon' then Pad.BtnSmallIcon := Item <> '0'
    else if Key = 'BtnSquare' then Pad.BtnSquare := Item <> '0'
    else if Key = 'BtnWidth' then Pad.BtnWidth := StrToInt(Item)
    else if Key = 'BtnHeight' then Pad.BtnHeight := StrToInt(Item)
    else if Key = 'BtnCaption' then Pad.BtnCaption := StrToInt(Item)
    else if Key = 'BtnColor' then Pad.BtnColor := StrToInt(Item)

    else if Key = 'TopLineIndex' then Pad.TopLineIndex := StrToInt(Item)
    else if Key = 'ButtonIndex' then Pad.ButtonIndex := StrToInt(Item)

//    else if Key = 'PropertyPageNo' then Pad.PropertyPageNo := StrToInt(Item)
    else if Key = 'TopMost' then Pad.TopMost := Item <> '0'
    else if Key = 'SmoothScroll' then Pad.SmoothScroll := Item <> '0'
    else if Key = 'Hotkey' then Pad.Hotkey := StrToInt(Item)
    else if Key = 'DropAction' then Pad.DropAction := StrToInt(Item)
    else if Key = 'DblClickAction' then Pad.DblClickAction := StrToInt(Item)
    else if Key = 'BackColor' then Pad.BackColor := StrToInt(Item)
    else if Key = 'WallPaper' then Pad.WallPaper := Item
    else if Key = 'DragBar' then Pad.DragBar := StrToInt(Item)
    else if Key = 'GroupName' then Pad.GroupName := Item <> '0'
    else if Key = 'DragBarSize' then Pad.DragBarSize := StrToInt(Item)
    else if Key = 'HideAuto' then Pad.HideAuto := Item <> '0'
    else if Key = 'HideSmooth' then Pad.HideSmooth := Item <> '0'
    else if Key = 'HideMouseCheck' then Pad.HideMouseCheck := Item <> '0'
    else if Key = 'HideVertical' then Pad.HideVertical := Item <> '0'
    else if Key = 'HideGroupName' then Pad.HideGroupName := Item <> '0'
    else if Key = 'HideSize' then Pad.HideSize := StrToInt(Item)
    else if Key = 'ShowDelay' then Pad.ShowDelay := StrToInt(Item)
    else if Key = 'HideDelay' then Pad.HideDelay := StrToInt(Item)
    else if Key = 'HideColor' then Pad.HideColor := StrToInt(Item)
    else
      Result := False;

    if Result then
      Pad.SizeCheck;
  except
    Result := False;
  end;

end;

// �v���O�C���{�^�����擾���Ȃ���
function SLAChangePluginButtons(Name: PChar): BOOL;
var
  Plugin: TPlugin;
  i: Integer;
begin
  Result := False;
  Plugin := Plugins.FindPlugin(Name);
  if Plugin = nil then
    Exit;

  Result := True;
  Plugin.GetButtonInfo;
  for i := 0 to Pads.Count - 1 do
    Pads[i].ArrangeButtons;
  for i := 0 to BtnPropertyList.Count - 1 do
    TdlgBtnProperty(BtnPropertyList[i]).SetPluginList;
end;

// �v���O�C�����j���[���擾���Ȃ���
function SLAChangePluginMenus(Name: PChar): BOOL;
var
  Plugin: TPlugin;
  i: Integer;
begin
  Result := False;
  Plugin := Plugins.FindPlugin(Name);
  if Plugin = nil then
    Exit;

  Result := True;
  Plugin.GetMenuInfo;
  for i := 0 to Pads.Count - 1 do
    Pads[i].ArrangePluginMenu;
end;

// �v���O�C���{�^�����ĕ`�悷��
function SLARedrawPluginButtons(Name: PChar; No: Integer): BOOL; 
var
  ButtonInfo: TButtonInfo;
begin
  Result := False;

  ButtonInfo := Plugins.FindButtonInfo(Name, No);
  if ButtonInfo = nil then
    Exit;
  if not ButtonInfo.OwnerDraw then
    Exit;

  if ButtonInfo.UpdateButtons.Count <= 0 then
    Exit;

  Result := True;
  ButtonInfo.UpdateButtonsUpdate;
end;

// �{�^���O���[�v�̐����擾����
function SLAGetGroupCount(ID: Integer): Integer; 
var
  Pad: TfrmPad;
begin
  Result := -1;
  Pad := Pads.PadOfID(ID);
  if Pad = nil then
    Exit;

  Result := Pad.ButtonGroups.Count;
end;

// �{�^���O���[�v�̏����擾����
function SLAGetGroup(ID, GroupIndex: Integer; Group: PSLAGroup): BOOL;
var
  Pad: TfrmPad;
begin
  Result := False;
  Pad := Pads.PadOfID(ID);

  if Pad = nil then
    Exit;

  if GroupIndex < 0 then
    Exit;
  if GroupIndex >= Pad.ButtonGroups.Count then
    Exit;

  FillChar(Group^, SizeOf(TSLAGroup), 0);
  Group^.PadID := ID;
  Group^.GroupIndex := GroupIndex;
  StrPCopy(Group^.Name, Copy(Pad.ButtonGroups[GroupIndex].Name, 1, 1023));
  Group^.ButtonCount := Pad.ButtonGroups[GroupIndex].Count;
end;

// �{�^���O���[�v��}������
function SLAInsertGroup(ID, GroupIndex: Integer; Name: PChar): BOOL;
var
  Pad: TfrmPad;
  ButtonGroup: TButtonGroup;
begin
  Result := False;
  Pad := Pads.PadOfID(ID);

  if Pad = nil then
    Exit;
  if Pad.DialogBox <> nil then
    Exit;
  if Pad.GetLockBtnEdit(True) then
    Exit;

  if (GroupIndex < 0) or (GroupIndex > Pad.ButtonGroups.Count) then
    Exit;

  Result := True;
  ButtonGroup := TButtonGroup.Create;
  try
    ButtonGroup.Name := Name;
    Pad.ButtonGroups.Insert(GroupIndex, ButtonGroup);
  except
    ButtonGroup.Free;
  end;

  Pad.ArrangeGroupMenu;
  Pad.EnabledCheckScrolls;
  Pad.SaveBtn;
end;

// �{�^���O���[�v�̖��O��ύX����
function SLARenameGroup(ID, GroupIndex: Integer; Name: PChar): BOOL;
var
  Pad: TfrmPad;
begin
  Result := False;
  Pad := Pads.PadOfID(ID);

  if Pad = nil then
    Exit;
  if Pad.DialogBox <> nil then
    Exit;
  if Pad.GetLockBtnEdit(True) then
    Exit;

  if (GroupIndex < 0) or (GroupIndex >= Pad.ButtonGroups.Count) then
    Exit;

  Result := True;
  Pad.ButtonGroups[GroupIndex].Name := Name;

  Pad.ArrangeButtons;
  Pad.ArrangeGroupMenu;
  Pad.SaveBtn;
end;

// �{�^���O���[�v�𕡐�����
function SLACopyGroup(ID, GroupIndex, NewIndex: Integer): BOOL;
var
  Pad: TfrmPad;
  ButtonGroup: TButtonGroup;
begin
  Result := False;
  Pad := Pads.PadOfID(ID);

  if Pad = nil then
    Exit;
  if Pad.DialogBox <> nil then
    Exit;
  if Pad.GetLockBtnEdit(True) then
    Exit;

  if (GroupIndex < 0) or (GroupIndex >= Pad.ButtonGroups.Count) then
    Exit;
  if (NewIndex < 0) or (NewIndex > Pad.ButtonGroups.Count) then
    Exit;


  Result := True;
  ButtonGroup := TButtonGroup.Create;
  try
    ButtonGroup.Assign(Pad.ButtonGroups[GroupIndex]);
    Pad.ButtonGroups.Insert(NewIndex, ButtonGroup);
  except
    ButtonGroup.Free;
  end;

  Pad.ArrangeGroupMenu;
  Pad.EnabledCheckScrolls;
  Pad.SaveBtn;
end;

// �{�^���O���[�v���폜����
function SLADeleteGroup(ID, GroupIndex: Integer): BOOL;
var
  Pad: TfrmPad;
begin
  Result := False;
  Pad := Pads.PadOfID(ID);

  if Pad = nil then
    Exit;
  if Pad.DialogBox <> nil then
    Exit;
  if Pad.GetLockBtnEdit(True) then
    Exit;

  if (GroupIndex < 0) or (GroupIndex >= Pad.ButtonGroups.Count) then
    Exit;
  if Pad.ButtonGroups.Count <= 1 then
    Exit;

  Result := True;

  if Pad.GroupIndex = GroupIndex then
  begin
    if GroupIndex = Pad.ButtonGroups.Count - 1 then
      Pad.GroupIndex := GroupIndex - 1
    else
      pad.GroupIndex := GroupIndex + 1;
  end;
  Pad.ButtonGroups.Delete(GroupIndex);

  Pad.ArrangeGroupMenu;
  Pad.EnabledCheckScrolls;
  Pad.SaveBtn;
end;


// �{�^���̏����擾����
function SLAGetButton(ID, GroupIndex, ButtonIndex: Integer; Button: PSLAButton): BOOL;
var
  Pad: TfrmPad;
  ButtonItem: TButtonItem;
  ButtonData: TButtonData;
begin
  Result := False;
  Pad := Pads.PadOfID(ID);

  if Pad = nil then
    Exit;
  if (GroupIndex < 0) or (GroupIndex >= Pad.ButtonGroups.Count) then
    Exit;
  if (ButtonIndex < 0) or (ButtonIndex >= Pad.ButtonGroups[GroupIndex].Count) then
    Exit;

  Result := True;

  if Pad.GroupIndex = GroupIndex then
    ButtonItem := Pad.ButtonArrangement.Items[ButtonIndex]
  else
    ButtonItem := nil;

  ButtonData := Pad.ButtonGroups[GroupIndex][ButtonIndex];
  FillChar(Button^, SizeOf(TSLAButton), 0);

  Button^.PadID := ID;
  Button^.GroupIndex := GroupIndex;
  Button^.ButtonIndex := ButtonIndex;

  if ButtonItem <> nil then
  begin
    if ButtonItem.SLButton <> nil then
    begin
      Button^.ScreenRect := ButtonItem.SLButton.ClientRect;
      Button^.ScreenRect.TopLeft := ButtonItem.SLButton.ClientToScreen(Button^.ScreenRect.TopLeft);
      Button^.ScreenRect.BottomRight := ButtonItem.SLButton.ClientToScreen(Button^.ScreenRect.BottomRight);
    end;
  end;


  StrPCopy(Button^.Name, Copy(ButtonData.Name, 1, 1023));
  Button^.ClickCount := ButtonData.ClickCount;

  if ButtonData is TSpaceButton then
  begin
    Button^.Kind := BK_SPACE;
  end

  else if ButtonData is TReturnButton then
  begin
    Button^.Kind := BK_RETURN;
  end

  else if ButtonData is TNormalButton then
  begin
    Button^.Kind := BK_NORMAL;
    with TNormalButton(ButtonData) do
    begin
      StrPCopy(Button^.FileName, Copy(FileName, 1, 1023));
      Button^.ItemIDList := ItemIDList;
      StrPCopy(Button^.Option, Copy(Option, 1, 1023));
      StrPCopy(Button^.Folder, Copy(Folder, 1, 1023));
      Button^.WindowSize := WindowSize;
      StrPCopy(Button^.IconFile, Copy(IconFile, 1, 1023));
      Button^.IconIndex := IconIndex;
    end;
  end

  else if ButtonData is TPluginButton then
  begin
    Button^.Kind := BK_PLUGIN;
    with TPluginButton(ButtonData) do
    begin
      StrPCopy(Button^.PluginName, Copy(PluginName, 1, 1023));
      Button^.PluginNo := No;
    end;
  end;


end;

function CreateButtonDataFromSLAButton(SLAButton: TSLAButton): TButtonData;
begin
  Result := nil;
  case SLAButton.Kind of
    BK_SPACE:
      Result := TSpaceButton.Create;
    BK_RETURN:
      Result := TReturnButton.Create;
    BK_NORMAL:
      Result := TNormalButton.Create;
    BK_PLUGIN:
      Result := TPluginButton.Create;
  end;
  if Result = nil then
    Exit;

  Result.Name := SLAButton.Name;
  Result.ClickCount := SLAButton.ClickCount;

  if SLAButton.Kind = BK_NORMAL then
  begin
    with TNormalButton(Result) do
    begin
      if SLAButton.ItemIDList = nil then
        FileName := SLAButton.FileName
      else
        ItemIDList := SLAButton.ItemIDList;
      Option := SLAButton.Option;
      Folder := SLAButton.Folder;
      WindowSize := SLAButton.WindowSize;
      IconFile := SLAButton.IconFile;
      IconIndex := SLAButton.IconIndex;
    end;
  end
  else if SLAButton.Kind = BK_PLUGIN then
  begin
    with TPluginButton(Result) do
    begin
      PluginName := SLAButton.PluginName;
      No := SLAButton.PluginNo;
    end;
  end;

end;

// �{�^����}������
function SLAInsertButton(ID, GroupIndex, ButtonIndex: Integer; Button: PSLAButton): BOOL;
var
  Pad: TfrmPad;
  ButtonData: TButtonData;
begin
  Result := False;
  Pad := Pads.PadOfID(ID);

  if Pad = nil then
    Exit;
  if Pad.DialogBox <> nil then
    Exit;
  if Pad.GetLockBtnEdit(True) then
    Exit;

  if (GroupIndex < 0) or (GroupIndex >= Pad.ButtonGroups.Count) then
    Exit;
  if (ButtonIndex < 0) or (ButtonIndex > Pad.ButtonGroups[GroupIndex].Count) then
    Exit;

  Result := True;

  ButtonData := CreateButtonDataFromSLAButton(Button^);
  if ButtonData <> nil then
    Pad.ButtonGroups[GroupIndex].Insert(ButtonIndex, ButtonData);

  if Pad.GroupIndex = GroupIndex then
    Pad.ButtonArrangement.Arrange;
  Pad.EnabledCheckScrolls;
  Pad.SaveBtn;
end;

// �{�^����ύX����
function SLAChangeButton(ID, GroupIndex, ButtonIndex: Integer; Button: PSLAButton): BOOL;
var
  Pad: TfrmPad;
  ButtonData: TButtonData;
begin
  Result := False;
  Pad := Pads.PadOfID(ID);

  if Pad = nil then
    Exit;
  if Pad.DialogBox <> nil then
    Exit;
  if Pad.GetLockBtnEdit(True) then
    Exit;

  if (GroupIndex < 0) or (GroupIndex >= Pad.ButtonGroups.Count) then
    Exit;
  if (ButtonIndex < 0) or (ButtonIndex >= Pad.ButtonGroups[GroupIndex].Count) then
    Exit;

  Result := True;


  Pad.ButtonArrangement.Clear;

  // ItemIDList �������ꍇ�̓{�^���̍폜�ŃG���[���o�邽�߃R�s�[���Ă���
  if Pad.ButtonGroups[GroupIndex][ButtonIndex] is TNormalButton then
  begin
    if TNormalButton(Pad.ButtonGroups[GroupIndex][ButtonIndex]).ItemIDList = Button^.ItemIDList then
      Button^.ItemIDList := CopyItemID(Button^.ItemIDList);
  end;

  ButtonData := CreateButtonDataFromSLAButton(Button^);
  Pad.ButtonGroups[GroupIndex][ButtonIndex].Free;
  Pad.ButtonGroups[GroupIndex][ButtonIndex] := ButtonData;

  if Pad.GroupIndex = GroupIndex then
    Pad.ButtonArrangement.Arrange;
  Pad.EnabledCheckScrolls;
  Pad.SaveBtn;
end;

// �{�^�����폜����
function SLADeleteButton(ID, GroupIndex, ButtonIndex: Integer): BOOL;
var
  Pad: TfrmPad;
begin
  Result := False;
  Pad := Pads.PadOfID(ID);

  if Pad = nil then
    Exit;
  if Pad.DialogBox <> nil then
    Exit;
  if Pad.GetLockBtnEdit(True) then
    Exit;

  if (GroupIndex < 0) or (GroupIndex >= Pad.ButtonGroups.Count) then
    Exit;
  if (ButtonIndex < 0) or (ButtonIndex >= Pad.ButtonGroups[GroupIndex].Count) then
    Exit;

  Result := True;

  Pad.ButtonArrangement.Clear;
  Pad.ButtonGroups[GroupIndex][ButtonIndex].Free;
  Pad.ButtonGroups[GroupIndex].Delete(ButtonIndex);

  if Pad.GroupIndex = GroupIndex then
    Pad.ButtonArrangement.Arrange;
  Pad.EnabledCheckScrolls;
  Pad.SaveBtn;
end;

// �{�^�����N���b�v�{�[�h�ɃR�s�[����
function SLACopyButton(ID, GroupIndex, ButtonIndex: Integer): BOOL;
var
  Pad: TfrmPad;
  AButtonGroup: TButtonGroup;
  DataObject: IDataObject;
begin
  Result := False;
  Pad := Pads.PadOfID(ID);

  if Pad = nil then
    Exit;
  if (GroupIndex < 0) or (GroupIndex >= Pad.ButtonGroups.Count) then
    Exit;
  if (ButtonIndex < 0) or (ButtonIndex >= Pad.ButtonGroups[GroupIndex].Count) then
    Exit;

  Result := True;

  AButtonGroup := TButtonGroup.Create;
  try
    AButtonGroup.Add(Pad.ButtonGroups[GroupIndex][ButtonIndex]);
    DataObject := TButtonGroupDataObject.Create(AButtonGroup);
    OleSetClipBoard(DataObject);
  finally
    AButtonGroup.Clear(False);
    AButtonGroup.Free;
  end;
end;

// �{�^�����N���b�v�{�[�h����\��t����
function SLAPasteButton(ID, GroupIndex, ButtonIndex: Integer): BOOL;
var
  Pad: TfrmPad;
  DataObject: IDataObject;
  AButtonGroup: TButtonGroup;
  i: Integer;
begin
  Result := False;
  Pad := Pads.PadOfID(ID);

  if Pad = nil then
    Exit;
  if Pad.DialogBox <> nil then
    Exit;
  if Pad.GetLockBtnEdit(True) then
    Exit;

  if (GroupIndex < 0) or (GroupIndex >= Pad.ButtonGroups.Count) then
    Exit;
  if (ButtonIndex < 0) or (ButtonIndex > Pad.ButtonGroups[GroupIndex].Count) then
    Exit;

  if S_OK <> OleGetClipboard(DataObject) then
    Exit;

  Result := True;

  AButtonGroup := TButtonGroup.Create;
  try
    DataObjectToButtonGroup(DataObject, AButtonGroup);
    for i := AButtonGroup.Count - 1 downto 0 do
      Pad.ButtonGroups[GroupIndex].Insert(ButtonIndex, AButtonGroup[i]);
    AButtonGroup.Clear(False);
  finally
    AButtonGroup.Free;
  end;

  if Pad.GroupIndex = GroupIndex then
    Pad.ButtonArrangement.Arrange;
  Pad.EnabledCheckScrolls;
  Pad.SaveBtn;
end;

// �N���b�v�{�[�h�Ƀ{�^���œ\��t������f�[�^�����邩��Ԃ�
function SLAButtonInClipbord: BOOL;
begin
  Result := ButtonGroupInClipbord;
end;

// �{�^���f�[�^�����s����
function SLARunButton(ID: Integer; Button: PSLAButton): BOOL;
var
  NormalButton: TNormalButton;
  Pad: TfrmPad;
  Plugin: TPlugin;
  ButtonInfo: TButtonInfo;
begin
  Result := False;

  if Button = nil then
    Exit;
  Pad := Pads.PadOfID(ID);

  if Pad = nil then
    Exit;
  if Pad.DialogBox <> nil then
    Exit;


  if Button.Kind = BK_NORMAL then
  begin
    Result := True;
    NormalButton := TNormalButton.Create;
    try
      with NormalButton do
      begin
        if Button.ItemIDList = nil then
          FileName := Button.FileName
        else
          ItemIDList := CopyItemID(Button.ItemIDList);
        Option := Button.Option;
        Folder := Button.Folder;
        WindowSize := Button.WindowSize;
        IconFile := Button.IconFile;
        IconIndex := Button.IconIndex;
      end;

      // NT�Ȃ�X���b�h�ɂ���
//      if OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
//        TOpenNormalButtonThread.Create(Pad.Handle, NormalButton)
//      else
        OpenNormalButton(Pad.Handle, NormalButton);
    finally
      NormalButton.Free;
    end;
  end

  else if Button.Kind = BK_PLUGIN then
  begin
    Plugin := Plugins.FindPlugin(Button.PluginName);
    if Plugin <> nil then
    begin
      if @Plugin.SLXButtonClick <> nil then
        if Plugin.SLXButtonClick(Button.PluginNo, Pad.Handle) then
        begin
          Result := True;
          ButtonInfo := Plugins.FindButtonInfo(Button.PluginName, Button.PluginNo);
          ButtonInfo.UpdateButtonsUpdate;
        end;
    end;
  end;


end;


// �A�C�R�����擾����
function SLAGetIcon(FilePoint: Pointer; FileType, IconIndex: Integer; SmallIcon, UseCache: BOOL): HIcon;
var
  F: TFileType;
begin
  case FileType of
    FT_ICONPATH: F := ftIconPath;
    FT_FILEPATH: F := ftFilePath;
    FT_PIDL: F := ftPIDL;
  else
    F := ftIconPath;
  end;

  Result := IconCache.GetIcon(FilePoint, F, IconIndex, SmallIcon, UseCache);
end;

end.
