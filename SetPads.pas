unit SetPads;

interface

uses
  Windows, SysUtils, Classes, Pad, SetInit, Forms, Graphics, SetBtn;

type
  TPads = class(TList)
  private
    FLastPadID: Integer;
    procedure SetPadID(frmPad: TfrmPad);
    function Get(Index: Integer): TfrmPad;
  public
    CtrlTabActivate: Boolean;
    Destroying: Boolean;
    property Items[Index: Integer]: TfrmPad read Get; default;
    constructor Create;
    destructor Destroy; override;
    procedure Clear; override;
    function New(BasePad: TfrmPad): TfrmPad;
    procedure Close(frmPad: TfrmPad);
    procedure AllArrange;
    procedure Load;
    procedure SaveIni;
    procedure BeginPads;
    procedure EndPads;
    function IndexOfPadID(PadID: Integer): Integer;
    function PadOfID(PadID: Integer): TfrmPad;
  end;

var
  Pads: TPads;

implementation

constructor TPads.Create;
begin
  Destroying := False;
end;

destructor TPads.Destroy;
begin
  Destroying := True;
  Clear;
  inherited;
end;

procedure TPads.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Release;
  inherited;
end;

// PadID ���Z�b�g����
procedure TPads.SetPadID(frmPad: TfrmPad);
  procedure IncID;
  begin
    Inc(FLastPadID);
    if FLastPadID <= 0 then
      FLastPadID := 1;
  end;
var
  i: Integer;
begin
  IncID;
  while True do
  begin
    i := 0;
    while i < Count do
    begin
      if Items[i].ID = FLastPadID then
        Break;
      Inc(i);
    end;
    if i = Count then
      Break;
    IncID;
  end;
  frmPad.ID := FLastPadID;
end;

// �擾
function TPads.Get(Index: Integer): TfrmPad;
begin
  Result := inherited Get(Index);
end;

// �V�K�p�b�h
function TPads.New(BasePad: TfrmPad): TfrmPad;
var
  frmPad: TfrmPad;
  ButtonGroup: TButtonGroup;
begin
  frmPad := TfrmPad.Create(nil);
  SetPadID(frmPad);
  Insert(0, frmPad);

  if BasePad = nil then
  begin
    ButtonGroup := TButtonGroup.Create;
    ButtonGroup.Name := '�V�K';
    frmPad.ButtonGroups.Add(ButtonGroup);
    frmPad.GroupIndex := 0;
  end
  else
  begin
    frmPad.Assign(BasePad);
  end;

  frmPad.Show;
  frmPad.EndUpdate;
  frmPad.SaveBtn;
  frmPad.SaveIni;
//  Save;

  Result := frmPad;
end;

// �p�b�h�����
procedure TPads.Close(frmPad: TfrmPad);
var
  IniFileName: string;
begin
  IniFileName := ChangeFileExt(frmPad.BtnFileName, '.ini');
  Remove(frmPad);
  if FileExists(IniFileName) then
    DeleteFile(IniFileName);
  if FileExists(frmPad.BtnFileName) then
    DeleteFile(frmPad.BtnFileName);
  frmPad.Release;
  
  if Count > 0 then
  begin
    // �t�H�A�O���E���h���ړ����Ă����Ȃ��� OnDestroy �̂��Ƃ� WM_KILLFOCUS ������
    frmPad.Foreground := False;
    Items[0].Show;
  end;
end;




// ���ׂẴp�b�h���Ĕz�u
procedure TPads.AllArrange;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Items[i].ButtonArrangement.Arrange;
//    Items[i].ArrangeButtons �ł̓v���O�C���{�^���̒ǉ��폜���T�m�ł��Ȃ�

    Items[i].ArrangeScrolls;
    Items[i].ArrangeGroupMenu;
    Items[i].ArrangePluginMenu;
  end;
end;

// �p�b�h�����ׂēǂݍ���
procedure TPads.Load;
var
  PadsFolder: string;
  FindHandle: THandle;
  Win32FindData: TWin32FindData;
  BtnFileName: string;
  IniFileName: string;
  frmPad: TfrmPad;
  ButtonGroup: TButtonGroup;
  i, ID, Index: Integer;
begin
  FLastPadID := UserIniFile.ReadInteger(IS_PADS, 'LastPadID', 0);

  // �p�b�h�̃t�H���_
  PadsFolder := UserFolder + 'Pads\';
  if not DirectoryExists(PadsFolder) then
    ForceDirectories(PadsFolder);

  FindHandle := FindFirstFile(PChar(PadsFolder + 'Pad*.btn'), Win32FindData);
  if FindHandle <> INVALID_HANDLE_VALUE then
  begin
    while True do
    begin
      BtnFileName := PadsFolder + Win32FindData.cFileName;
      IniFileName := ChangeFileExt(BtnFileName, '.ini');

      frmPad := TfrmPad.Create(nil);
      frmPad.LoadBtn(BtnFileName);
      frmPad.LoadIni(IniFileName);
      frmPad.ButtonArrangement.Clear;
      if frmPad.ID = 0 then
        SetPadID(frmPad);
      Add(frmPad);

      if not FindNextFile(FindHandle, Win32FindData) then
        Break;
    end;
    Windows.FindClose(FindHandle)
  end;

  // �p�b�h�̏���
  i := 0;
  while True do
  begin
    ID := UserIniFile.ReadInteger(IS_PADSZORDER, IntToStr(i), 0);
    if ID = 0 then
      Break;
    Index := IndexOf(PadOfID(ID));
    if (Index >= 0) and (i < Count) then
      Move(Index, i);
    Inc(i);
  end;

  // �P���Ȃ���΍��
  if Count = 0 then
  begin
    frmPad := TfrmPad.Create(nil);
    SetPadID(frmPad);
    Add(frmPad);

    ButtonGroup := TButtonGroup.Create;
    ButtonGroup.Name := '�V�K';
    frmPad.ButtonGroups.Add(ButtonGroup);
    frmPad.GroupIndex := 0;
    frmPad.SaveBtn;
    frmPad.SaveIni;
  end;
end;

// �p�b�h�����ׂď�������
procedure TPads.SaveIni;
var
  i: Integer;
begin
  if not UserIniReadOnly then
  begin
    UserIniFile.WriteInteger(IS_PADS, 'LastPadID', FLastPadID);
    UserIniFile.EraseSection(IS_PADSZORDER);

    // ��������
    for i := 0 to Count - 1 do
    begin
      UserIniFile.WriteInteger(IS_PADSZORDER, IntToStr(i), Items[i].ID);
      try
        Items[i].SaveIni;
      except
        on E: Exception do
          Application.MessageBox(PChar(E.Message), '�G���[', MB_ICONERROR);
      end;
    end;

    UserIniFile.UpdateFile;
  end;
end;

// ���ׂẴp�b�h���J�n
procedure TPads.BeginPads;
var
  i: Integer;
  ShowList: TList;
begin
  AllArrange;

  ShowList := TList.Create;
  try
    for i := 0 to Pads.Count - 1 do
      ShowList.Add(Items[i]);
    for i := ShowList.Count - 1 downto 0 do
    begin
      TfrmPad(ShowList[i]).Show;
      TfrmPad(ShowList[i]).EndUpdate;
    end;
  finally
    ShowList.Free;
  end;

  if Items[0].Handle <> GetForegroundWindow then
    Items[0].Foreground := False;
end;

// ���ׂẴp�b�h���I��
procedure TPads.EndPads;
var
  i: Integer;
begin
  for i := 0 to Pads.Count - 1 do
    Items[i].ButtonArrangement.Clear;
end;

// PadID �̃p�b�h�̃C���f�b�N�X���擾
function TPads.IndexOfPadID(PadID: Integer): Integer;
var
  i: Integer;
begin
  i := 0;
  Result := -1;
  while i < Pads.Count do
  begin
    if Pads[i].ID = PadID then
    begin
      Result := i;
      Break;
    end;
    Inc(i);
  end;
end;

// PadID ����p�b�h���擾
function TPads.PadOfID(PadID: Integer): TfrmPad;
var
  Index: Integer;
begin
  Index := IndexOfPadID(PadID);
  if Index < 0 then
    Result := nil
  else
    Result := Items[Index];
end;

end.
