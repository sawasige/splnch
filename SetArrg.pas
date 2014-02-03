unit SetArrg;

interface

uses
  Windows, Messages, Classes, SetBtn, SLBtns, SysUtils, SetPlug, Forms;

type
  // �{�^���R���g���[���ƃf�[�^
  TButtonItem = class(TObject)
    ButtonData: TButtonData;
    SLButton: TSLNormalButton;
    Line: TList;
    destructor Destroy; override;
  end;


  // �{�^���z�u
  TButtonArrangement = class(TObject)
  private
    FOwner: TForm;
    FLines: TList;
    FItems: TList;
    FButtonGroup: TButtonGroup;
    FCols: Integer;
    FActive: Boolean;
    FOnArranged: TNotifyEvent;
    FCurrentIndex: Integer;
    FCurrentSLButton: TSLNormalButton;
    function GetGrid(ACol, ARow: Integer): TButtonItem;
    function GetItem(Index: Integer): TButtonItem;
    procedure SetButtonGroup(Value: TButtonGroup);
    procedure SetCols(Value: Integer);
    function GetRows: Integer;
    procedure SetActive(Value: Boolean);
    procedure IndexRevision;
    procedure SetCurrentIndex(Value: Integer);
    function GetCurrentIndex: Integer;
    function GetCurrentItem: TButtonItem;
    function GetCurrentCol: Integer;
    function GetCurrentRow: Integer;
  public
    property Owner: TForm read FOwner write FOwner;
    property Grid[ACol, ARow: Integer]: TButtonItem read GetGrid; default;
    property Items[Index: Integer]: TButtonItem read GetItem;
    property ButtonGroup: TButtonGroup read FButtonGroup write SetButtonGroup;
    property Cols: Integer read FCols write SetCols;
    property Rows: Integer read GetRows;
    property Active: Boolean read FActive write SetActive;
    property CurrentIndex: Integer read GetCurrentIndex write SetCurrentIndex;
    property CurrentItem: TButtonItem read GetCurrentItem;
    property CurrentCol: Integer read GetCurrentCol;
    property CurrentRow: Integer read GetCurrentRow;
    property OnArranged: TNotifyEvent read FOnArranged write FOnArranged;

    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Arrange;
    function IndexOfItem(Item: TButtonItem): Integer;
  end;


implementation

//
// TButtonItem
/////////////////////////////////

// �f�X�g���N�^
destructor TButtonItem.Destroy;
begin
  SLButton.Free;
  inherited;
end;


//
// TButtonArrangement
/////////////////////////////////

// �R���X�g���N�^
constructor TButtonArrangement.Create;
begin
  inherited;
  FLines := TList.Create;
  FItems := TList.Create;
  FButtonGroup := nil;
  FCurrentIndex := -1;
  FCurrentSLButton := nil;
end;

// �f�X�g���N�^
destructor TButtonArrangement.Destroy;
begin
  Clear;
  FLines.Free;
  FItems.Free;
  inherited;
end;

// �{�^���O���[�v�Z�b�g
procedure TButtonArrangement.SetButtonGroup(Value: TButtonGroup);
begin
  if Value = FButtonGroup then
    Exit;

  FButtonGroup := Value;
  Arrange;
  CurrentIndex := 0;
end;

// ���Z�b�g
procedure TButtonArrangement.SetCols(Value: Integer);
begin
  if Value = FCols then
    Exit;
  if Value < 0 then
    Value := 0;

  FCols := Value;
  Arrange;
end;

// �s���Q�b�g
function TButtonArrangement.GetRows: Integer;
begin
  Result := FLines.Count;
end;


// �w����W��ButtonItem���擾
function TButtonArrangement.GetGrid(ACol, ARow: Integer): TButtonItem;
var
  Line: TList;
begin
  Result := nil;
  if (ARow >= 0) and (ARow < FLines.Count) then
  begin
    Line := FLines[ARow];
    if (ACol >= 0) and (ACol < Line.Count) then
      Result := Line[ACol];
  end;
end;

// �w��C���f�b�N�X��ButtonItem���擾
function TButtonArrangement.GetItem(Index: Integer): TButtonItem;
begin
  Result := nil;
  if (Index >= 0) and (Index < FItems.Count) then
    Result := FItems[Index];
end;

// �A�N�e�B�u�ɂȂ�
procedure TButtonArrangement.SetActive(Value: Boolean);
var
  i, j: Integer;
  Line: TList;
  Item: TButtonItem;
begin
  if FActive = Value then
    Exit;

  FActive := Value;

  for i := 0 to FLines.Count - 1 do
  begin
    Line := FLines[i];
    for j := 0 to Line.Count - 1 do
    begin
      Item := Line[j];
      if Item.SLButton <> nil then
        Item.SLButton.Active := Value;
    end;
  end;

end;

// �N���A
procedure TButtonArrangement.Clear;
var
  i: Integer;
  Plugin: TPlugin;
begin
  // �v���O�C���ɊJ����ʒm
  for i := 0 to FItems.Count - 1 do
  begin
    if Items[i].ButtonData is TPluginButton then
    begin
      Plugin := Plugins.FindPlugin(TPluginButton(Items[i].ButtonData).PluginName);
      if Plugin <> nil then
        if @Plugin.SLXButtonDestroy <> nil then
          Plugin.SLXButtonDestroy(TPluginButton(Items[i].ButtonData).No, Owner.Handle, i);
    end;
  end;

  FCurrentSLButton := nil;
  for i := 0 to FItems.Count - 1 do
    Items[i].Free;
  FItems.Clear;

  for i := 0 to FLines.Count - 1 do
    TList(FLines[i]).Free;
  FLines.Clear;
end;

// �Ĕz�u
procedure TButtonArrangement.Arrange;
  function ItemCreate(Index: Integer; ButtonData: TButtonData): TButtonItem;
  begin
    Result := TButtonItem.Create;
    Result.ButtonData := ButtonData;

    if ButtonData is TNormalButton then
    begin
      Result.SLButton := TSLNormalButton.Create(nil);
      Result.SLButton.Tag := Index;
    end
    else if ButtonData is TPluginButton then
    begin
      Result.SLButton := TSLPluginButton.Create(nil);
      Result.SLButton.Tag := Index;
    end
    else
      Result.SLButton := nil;
  end;
var
  i: Integer;
  ButtonData: TButtonData;
  Line: TList;
  Item: TButtonItem;
  Plugin: TPlugin;
begin

  Clear;

  if (FButtonGroup <> nil) and (FCols > 0) then
  begin
    Line := nil;
    for i := 0 to FButtonGroup.Count - 1 do
    begin
      ButtonData := FButtonGroup[i];
      Item := ItemCreate(i, ButtonData);
      FItems.Add(Item);

      if Line = nil then
      begin
        Line := TList.Create;
        FLines.Add(Line);
      end;

      if ButtonData is TReturnButton then
      begin
        Line.Add(Item);
        Item.Line := Line;
        Line := nil;
      end
      else
      begin
        if Line.Count >= FCols then
        begin
          Line := TList.Create;
          FLines.Add(Line);
        end;

        Line.Add(Item);
        Item.Line := Line;
      end;

    end;

    // �v���O�C���ɍ쐬��ʒm
    for i := 0 to FItems.Count - 1 do
    begin
      if Items[i].ButtonData is TPluginButton then
      begin
        Plugin := Plugins.FindPlugin(TPluginButton(Items[i].ButtonData).PluginName);
        if Plugin <> nil then
        begin
          if @Plugin.SLXButtonCreate <> nil then
            Plugin.SLXButtonCreate(TPluginButton(Items[i].ButtonData).No, Owner.Handle, i);
        end;
      end;
    end;

  end;



  CurrentIndex := CurrentIndex;
  if Assigned(FOnArranged) then
    FOnArranged(Self);
  
end;

// �C���f�b�N�X���C������
procedure TButtonArrangement.IndexRevision;
var
  i, NewIndex: Integer;
begin
  NewIndex := -1;

  if FButtonGroup = nil then
    Exit;

  // �O���֏C��
  i := FCurrentIndex;
  while (i >= 0) and (NewIndex = -1) do
  begin
    if i < FButtonGroup.Count then
      if (FButtonGroup[i] is TNormalButton) or (FButtonGroup[i] is TPluginButton) then
        NewIndex := i;
    Dec(i);
  end;

  // ����֏C��
  i := FCurrentIndex + 1;
  while (i < FButtonGroup.Count) and (NewIndex = -1) do
  begin
    if i >= 0 then
      if (FButtonGroup[i] is TNormalButton) or (FButtonGroup[i] is TPluginButton) then
        NewIndex := i;
    Inc(i);
  end;

  FCurrentIndex := NewIndex;
end;

// �J�����g�C���f�b�N�X�Z�b�g
procedure TButtonArrangement.SetCurrentIndex(Value: Integer);
var
  Item: TButtonItem;
begin
  FCurrentIndex := Value;
  IndexRevision;

  if FCurrentSLButton <> nil then
    FCurrentSLButton.Selected := False;
  FCurrentSLButton := nil;
  Item := CurrentItem;
  if Item <> nil then
    if Item.SLButton <> nil then
    begin
      FCurrentSLButton := Item.SLButton;
      FCurrentSLButton.Selected := True;
    end;
end;

// �J�����g�C���f�b�N�X�擾
function TButtonArrangement.GetCurrentIndex: Integer;
begin
  IndexRevision;
  Result := FCurrentIndex;
end;

// �J�����g�A�C�e���擾
function TButtonArrangement.GetCurrentItem: TButtonItem;
begin
  Result := Items[CurrentIndex];
end;

// �J�����g��擾
function TButtonArrangement.GetCurrentCol: Integer;
var
  Item: TButtonItem;
begin
  Item := CurrentItem;
  if Item = nil then
    Result := -1
  else
    Result := Item.Line.IndexOf(Item);
end;

// �J�����g�s�擾
function TButtonArrangement.GetCurrentRow: Integer;
var
  Item: TButtonItem;
begin
  Item := CurrentItem;
  if Item = nil then
    Result := -1
  else
    Result := FLines.IndexOf(Item.Line);
end;

// �w��̃A�C�e���̃C���f�b�N�X��Ԃ�
function TButtonArrangement.IndexOfItem(Item: TButtonItem): Integer;
begin
  Result := FItems.IndexOf(Item);
end;

end.
