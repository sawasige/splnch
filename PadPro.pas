unit PadPro;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, SetInit, ImgList, SLBtns, SetIcons, SetPlug;


type
  TdlgPadProperty = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    PageControl: TPageControl;
    dlgColor: TColorDialog;
    dlgOpen: TOpenDialog;
    imlLayout: TImageList;
    tabMove: TTabSheet;
    chkTopMost: TCheckBox;
    chkSmoothScroll: TCheckBox;
    lblActiveKey: TLabel;
    hkActiveKey: THotKey;
    lblDropAction: TLabel;
    cmbDropAction: TComboBox;
    lblDblClickAction: TLabel;
    cmbDblClickAction: TComboBox;
    btnHelp: TButton;
    tabDesign: TTabSheet;
    cmbParts: TComboBox;
    lblParts: TLabel;
    scrDesign: TScrollBox;
    pnlPad: TPanel;
    pnlDragBar: TPanel;
    pbDragBar: TPaintBox;
    pnlWorkspace: TPanel;
    pnlHide: TPanel;
    pbHide: TPaintBox;
    lblHideCorner: TLabel;
    lblHideDelay: TLabel;
    lblShowDelay: TLabel;
    Label1: TLabel;
    chkHideAuto: TCheckBox;
    rdoHideHorizontal: TRadioButton;
    rdoHideVertical: TRadioButton;
    chkHideSmooth: TCheckBox;
    edtHideDelay: TEdit;
    udHideDelay: TUpDown;
    edtShowDelay: TEdit;
    udShowDelay: TUpDown;
    chkHideMouseCheck: TCheckBox;
    pnlScrollBar: TPanel;
    pbScrollBar: TPaintBox;
    pnlButtons: TPanel;
    pbWorkspace: TPaintBox;
    chkVisiblePartLabels: TCheckBox;
    tabSkins: TTabSheet;
    lblPlugins: TLabel;
    btnPluginInfo: TButton;
    imlPlugins: TImageList;
    cmbSkins: TComboBox;
    btnPluginOption: TButton;
    pnlTabButton: TPanel;
    lblBtnCaption: TLabel;
    shpBtnColor: TShape;
    lblBtnColor: TLabel;
    lblBtnWidth: TLabel;
    lblBtnHeight: TLabel;
    Label2: TLabel;
    cmbBtnCaption: TComboBox;
    chkBtnSmallIcon: TCheckBox;
    btnBtnColor: TButton;
    chkBtnTransparent: TCheckBox;
    edtBtnWidth: TEdit;
    udBtnWidth: TUpDown;
    edtBtnHeight: TEdit;
    chkBtnSquare: TCheckBox;
    btnBtnColorDefault: TButton;
    udBtnHeight: TUpDown;
    pnlTabSelButton: TPanel;
    pnlTabDragBar: TPanel;
    pnlTabScrollBar: TPanel;
    pnlTabWorkspace: TPanel;
    pnlTabHide: TPanel;
    lblBtnFocusColor: TLabel;
    shpBtnFocusColor: TShape;
    btnBtnFocusColor: TButton;
    chkBtnSelTransparent: TCheckBox;
    btnBtnFocusColorDefault: TButton;
    lblDragBar: TLabel;
    lblDragBarSize: TLabel;
    cmbDragBar: TComboBox;
    chkGroupName: TCheckBox;
    edtDragBarSize: TEdit;
    udDragBarSize: TUpDown;
    lblScrollBar: TLabel;
    lblScrollSize: TLabel;
    cmbScrollBar: TComboBox;
    chkScrollBtn: TCheckBox;
    edtScrollSize: TEdit;
    udScrollSize: TUpDown;
    chkGroupBtn: TCheckBox;
    lblBackColor: TLabel;
    shpBackColor: TShape;
    lblWallPaper: TLabel;
    lblLayout: TLabel;
    btnBackColor: TButton;
    edtWallPaper: TEdit;
    btnWallPaperClear: TButton;
    btnWallPaper: TButton;
    cmbLayout: TComboBox;
    btnBackColorDefault: TButton;
    lblHideColor: TLabel;
    shpHideColor: TShape;
    lblHideSize: TLabel;
    btnHideColor: TButton;
    edtHideSize: TEdit;
    udHideSize: TUpDown;
    chkHideGroupName: TCheckBox;
    btnHideColorDefault: TButton;
    pnlButtonLabel: TPanel;
    pnlSelButtonLabel: TPanel;
    pnlDragBarLabel: TPanel;
    pnlScrollBarLabel: TPanel;
    pnlWorkSpaceLabel: TPanel;
    pnlHideLabel: TPanel;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnHideColorClick(Sender: TObject);
    procedure chkBtnSquareClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmbScrollBarChange(Sender: TObject);
    procedure btnBackColorClick(Sender: TObject);
    procedure LayoutComboBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnBtnColorClick(Sender: TObject);
    procedure cmbDragBarChange(Sender: TObject);
    procedure chkHideGroupNameClick(Sender: TObject);
    procedure btnBtnFocusColorClick(Sender: TObject);
    procedure btnDefaultColorClick(Sender: TObject);
    procedure btnWallPaperClick(Sender: TObject);
    procedure btnWallPaperClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chkGroupNameClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmbLayoutChange(Sender: TObject);
    procedure chkScrollBtnClick(Sender: TObject);
    procedure chkGroupBtnClick(Sender: TObject);
    procedure edtScrollSizeChange(Sender: TObject);
    procedure edtDragBarSizeChange(Sender: TObject);
    procedure chkBtnSmallIconClick(Sender: TObject);
    procedure cmbBtnCaptionChange(Sender: TObject);
    procedure PageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure PageControlChange(Sender: TObject);
    procedure chkBtnTransparentClick(Sender: TObject);
    procedure chkBtnSelTransparentClick(Sender: TObject);
    procedure edtWallPaperChange(Sender: TObject);
    procedure chkTopMostClick(Sender: TObject);
    procedure chkSmoothScrollClick(Sender: TObject);
    procedure hkActiveKeyEnter(Sender: TObject);
    procedure cmbDropActionChange(Sender: TObject);
    procedure cmbDblClickActionChange(Sender: TObject);
    procedure chkHideAutoClick(Sender: TObject);
    procedure chkHideSmoothClick(Sender: TObject);
    procedure chkHideMouseCheckClick(Sender: TObject);
    procedure edtHideSizeChange(Sender: TObject);
    procedure rdoHideHorizontalClick(Sender: TObject);
    procedure edtShowDelayChange(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure edtBtnWidthChange(Sender: TObject);
    procedure edtBtnHeightChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmbPartsChange(Sender: TObject);
    procedure pbDragBarPaint(Sender: TObject);
    procedure pbWorkspacePaint(Sender: TObject);
    procedure pbScrollBarPaint(Sender: TObject);
    procedure pbHidePaint(Sender: TObject);
    procedure scrDesignMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PartLabelClick(Sender: TObject);
    procedure chkVisiblePartLabelsClick(Sender: TObject);
    procedure cmbSkinsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cmbSkinsChange(Sender: TObject);
  private
    FOnWindowActivate: TNotifyEvent;
    FOnWindowDeactivate: TNotifyEvent;
    FOnApply: TNotifyEvent;
    FOnClosed: TNotifyEvent;

    FEnabledApplyBk: Boolean;

    FPartLabels: TList;
    FPartPanels: TList;
    FButtons: TList;
    FScrolls: TList;

    FHighlightColor, FShadowColor: TColor;
    procedure DesignRepaint;
  public
    property OnWindowActivate: TNotifyEvent read FOnWindowActivate write FOnWindowActivate;
    property OnWindowDeactivate: TNotifyEvent read FOnWindowDeactivate write FOnWindowDeactivate;
    property OnApply: TNotifyEvent read FOnApply write FOnApply;
    property OnClosed: TNotifyEvent read FOnClosed write FOnClosed;
    procedure WMActivate(var Msg: TWMActivate); message WM_ACTIVATE;
  end;

  TPartRect = class(TObject)
    Rect: TRect;
  end;

const
  DS_NONE = 0; // �\�����Ȃ�
  DS_LEFT = 1; // ��
  DS_TOP = 2; // ��
  DS_RIGHT = 3; // �E
  DS_BOTTOM = 4; // ��

  DA_ADDHERE = 0; // �h���b�v�����ꏊ�ɒǉ�
  DA_ADDLAST = 1; // �Ō�ɒǉ�
  DA_OPENHERE = 2; // �h���b�v��̃{�^���ŊJ��
  DA_COPYNAME = 3; // �t�@�C�������R�s�[
  DA_I_ADDHERE = 0;
  DA_I_ADDLAST = 1;
  DA_I_OPENHERE = 2;
  DA_I_COPYNAME = 3;

  CA_COMLINE = 0; // �w�肵�Ď��s���J��
  CA_BTNEDIT = 1; // �{�^���̕ҏW���J��
  CA_GRPCHANGE = 2; // �{�^���O���[�v�ύX���j���[���J��
  CA_NEXTGROUP = 3; // ���̃{�^���O���[�v�ֈړ�����
  CA_PADPRO = 4; // �p�b�h�̐ݒ���J��
  CA_OPTION = 5; // �S�̂̐ݒ���J��
  CA_HIDE = 6; // �p�b�h���B��
  CA_I_COMLINE = 0;
  CA_I_BTNEDIT = 1;
  CA_I_GRPCHANGE = 2;
  CA_I_NEXTGROUP = 3;
  CA_I_PADPRO = 4;
  CA_I_OPTION = 5;
  CA_I_HIDE = 6;

  CP_NONE = 0; // �{�^������\�����Ȃ�
  CP_BOTTOM = 1; // �A�C�R���̉�
  CP_RIGHT = 2; // �A�C�R���̉E
  
implementation

{$R *.DFM}

const
  iiNone = 0;
  iiLeft = 1;
  iiTop = 2;
  iiRight = 3;
  iiBottom = 4;
  iiVertical = 5;
  iiHorizontal = 6;

// �t�H�[���n��
procedure TdlgPadProperty.FormCreate(Sender: TObject);
var
  i: Integer;
  NonClientMetrics: TNonClientMetrics;
  SLNormalButton: TSLNormalButton;
  SLScrollButton: TSLScrollButton;
  Plugin: TPlugin;
begin
  tabSkins.TabVisible := False;

  // �摜�ǂݍ���
  imlLayout.ResInstLoad(hInstance, rtBitmap, 'LAYOUT', clFuchsia);

  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0);
  pbDragBar.Font.Handle := CreateFontIndirect(NonClientMetrics.lfCaptionFont);
  pbHide.Font.Handle := CreateFontIndirect(NonClientMetrics.lfCaptionFont);

  // ���x��
  FPartLabels := TList.Create;
  FPartLabels.Add(pnlButtonLabel);
  FPartLabels.Add(pnlSelButtonLabel);
  FPartLabels.Add(pnlDragBarLabel);
  FPartLabels.Add(pnlScrollBarLabel);
  FPartLabels.Add(pnlWorkspaceLabel);
  FPartLabels.Add(pnlHideLabel);
  chkVisiblePartLabels.Checked := UserIniFile.ReadBool(IS_WINDOWS, 'PadOptionVisiblePartLabels', False);
  chkVisiblePartLabelsClick(chkVisiblePartLabels);

  // �p�l��
  FPartPanels := TList.Create;
  FPartPanels.Add(pnlTabButton);
  FPartPanels.Add(pnlTabSelButton);
  FPartPanels.Add(pnlTabDragBar);
  FPartPanels.Add(pnlTabScrollBar);
  FPartPanels.Add(pnlTabWorkspace);
  FPartPanels.Add(pnlTabHide);
  for i := 0 to FPartPanels.Count - 1 do
  begin
    TPanel(FPartPanels[i]).Visible := False;
    TPanel(FPartPanels[i]).Left := 20;
    TPanel(FPartPanels[i]).Top := 192;
    TPanel(FPartPanels[i]).BevelOuter := bvNone;
  end;

  // �{�^���쐬
  FButtons := TList.Create;
  for i := 1 to 5 do
  begin
    SLNormalButton := TSLNormalButton.Create(Self);
    SLNormalButton.Parent := pnlButtons;
    if i < 5 then
      SLNormalButton.Caption := '�{�^��'
    else
      SLNormalButton.Caption := '�I�����ꂽ�{�^��';
    FButtons.Add(SLNormalButton);
  end;

  // �X�N���[���{�^���쐬
  FScrolls := TList.Create;
  for i := 0 to 3 do
  begin
    SLScrollButton := TSLScrollButton.Create(Self);
    SLScrollButton.Parent := pnlScrollBar;
    case i of
      0:
        SLScrollButton.Kind := skGUp;
      1:
        SLScrollButton.Kind := skUp;
      2:
        SLScrollButton.Kind := skDown;
      3:
        SLScrollButton.Kind := skGDown;
    end;
    FScrolls.Add(SLScrollButton)

  end;


  cmbParts.Items.Add('�{�^��');
  cmbParts.Items.Add('�I�����ꂽ�{�^��');
  cmbParts.Items.Add('�h���b�O�o�[');
  cmbParts.Items.Add('�X�N���[���o�[');
  cmbParts.Items.Add('���[�N�X�y�[�X');
  cmbParts.Items.Add('�B��Ă�����');


  cmbParts.ItemIndex := 0;
  cmbPartsChange(cmbParts);

  DesignRepaint;



  // �X�L���v���O�C��
  cmbSkins.Items.BeginUpdate;
  try
    cmbSkins.Items.AddObject('�Ȃ�', nil);
    for i := 0 to Plugins.Count - 1 do
    begin
      Plugin := TPlugin(Plugins.Objects[i]);
      if Plugin.IsSkin then
        cmbSkins.Items.AddObject(Plugin.Name, Plugin);
    end;
  finally
    cmbSkins.Items.EndUpdate;
  end;
  if cmbSkins.Items.Count = 1 then
  begin
    tabSkins.TabVisible := false;
  end;

end;

// �t�H�[���I���
procedure TdlgPadProperty.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  FPartLabels.Free;
  FPartPanels.Free;
  for i := 0 to FButtons.Count - 1 do
    TSLButton(FButtons[i]).Free;
  FButtons.Free;
  for i := 0 to FScrolls.Count - 1 do
    TSLButton(FScrolls[i]).Free;
  FScrolls.Free;
end;

// �t�H�[������
procedure TdlgPadProperty.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  if Assigned(FOnClosed) then
    FOnClosed(Self);
end;


// �t�H�[��������
procedure TdlgPadProperty.FormShow(Sender: TObject);
begin
  chkGroupName.Enabled := cmbDragBar.ItemIndex > 0;
  chkScrollBtn.Enabled := cmbScrollBar.ItemIndex > 0;
  chkGroupBtn.Enabled := chkScrollBtn.Enabled;
  lblScrollSize.Enabled := chkScrollBtn.Enabled;
  edtScrollSize.Enabled := chkScrollBtn.Enabled;
  udScrollSize.Enabled := chkScrollBtn.Enabled;

  PageControl.ActivePage.SetFocus;

  btnHelp.Enabled := FileExists(Application.HelpFile);
  btnApply.Enabled := False;
end;

// �A�N�e�B�u�ɂȂ�
procedure TdlgPadProperty.WMActivate(var Msg: TWMActivate);
begin
  inherited;

  if Msg.Active = WA_INACTIVE then
  begin
    if Assigned(OnWindowDeactivate) then
      OnWindowDeactivate(Self);
  end
  else
  begin
    if Assigned(OnWindowActivate) then
      OnWindowActivate(Self);
  end;
end;

// �n�j�{�^��
procedure TdlgPadProperty.btnOkClick(Sender: TObject);
begin
  if Assigned(FOnApply) then
  begin
    FOnApply(Self);
    btnApply.Enabled := False;
  end;
  Close;
end;

// �L�����Z���{�^��
procedure TdlgPadProperty.btnCancelClick(Sender: TObject);
begin
  Close;
end;

// �K�p�{�^��
procedure TdlgPadProperty.btnApplyClick(Sender: TObject);
begin
  if Assigned(FOnApply) then
  begin
    FOnApply(Self);
    btnApply.Enabled := False;
  end;
  Show;
end;

// �^�u��؂�ւ���
procedure TdlgPadProperty.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  FEnabledApplyBk := btnApply.Enabled;
end;

// �^�u��؂�ւ���
procedure TdlgPadProperty.PageControlChange(Sender: TObject);
begin
  btnApply.Enabled := FEnabledApplyBk;
end;

// �{�^���̔z�u
procedure TdlgPadProperty.cmbLayoutChange(Sender: TObject);
begin
  btnApply.Enabled := True;
  DesignRepaint;
end;

// �h���b�O�o�[�̕\��
procedure TdlgPadProperty.cmbDragBarChange(Sender: TObject);
begin
  chkGroupName.Enabled := cmbDragBar.ItemIndex > 0;
  chkGroupNameClick(chkGroupName);
  btnApply.Enabled := True;
  DesignRepaint;
end;

// �h���b�O�o�[�Ƀ{�^���O���[�v����\������
procedure TdlgPadProperty.chkGroupNameClick(Sender: TObject);
begin
  lblDragBarSize.Enabled := (not chkGroupName.Checked) and (cmbDragBar.ItemIndex > 0);
  edtDragBarSize.Enabled := lblDragBarSize.Enabled;
  udDragBarSize.Enabled := lblDragBarSize.Enabled;
  btnApply.Enabled := True;
  DesignRepaint;
end;

// �h���b�O�o�[�̃T�C�Y
procedure TdlgPadProperty.edtDragBarSizeChange(Sender: TObject);
begin
  btnApply.Enabled := True;
  DesignRepaint;
end;



// �X�N���[���o�[�̕\��
procedure TdlgPadProperty.cmbScrollBarChange(Sender: TObject);
begin
  chkScrollBtn.Enabled := cmbScrollBar.ItemIndex > 0;
  chkGroupBtn.Enabled := chkScrollBtn.Enabled;
  lblScrollSize.Enabled := chkScrollBtn.Enabled;
  edtScrollSize.Enabled := chkScrollBtn.Enabled;
  udScrollSize.Enabled := chkScrollBtn.Enabled;
  btnApply.Enabled := True;
  DesignRepaint;
end;

// �X�N���[���{�^����\��
procedure TdlgPadProperty.chkScrollBtnClick(Sender: TObject);
begin
  btnApply.Enabled := True;
  DesignRepaint;
end;

// �{�^���O���[�v�؂�ւ��{�^����\��
procedure TdlgPadProperty.chkGroupBtnClick(Sender: TObject);
begin
  btnApply.Enabled := True;
  DesignRepaint;
end;


// �X�N���[���o�[�̃T�C�Y
procedure TdlgPadProperty.edtScrollSizeChange(Sender: TObject);
begin
  btnApply.Enabled := True;
  DesignRepaint;
end;



// �{�^���̔z�u�ƃh���b�O�o�[�ƃX�N���[���{�^���̈ʒu�̕`��
procedure TdlgPadProperty.LayoutComboBoxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  y: Integer;
  ImageIndex: Integer;
begin
  with Control as TComboBox do
  begin
    Canvas.FillRect(Rect);

    if Control = cmbLayout then
      ImageIndex := Index + iiVertical
    else
      ImageIndex := Index;

    y := Rect.Top + ((Rect.Bottom - Rect.Top) - imlLayout.Height) div 2;
    imlLayout.Draw(Canvas, Rect.Left + 3, y, ImageIndex);

    y := Rect.Top + ((Rect.Bottom - Rect.Top) - Canvas.TextHeight(Items[Index])) div 2;
    Canvas.TextOut(Rect.Left + imlLayout.Width + 8, y, Items[Index]);

  end;
end;

// �������A�C�R�����g��
procedure TdlgPadProperty.chkBtnSmallIconClick(Sender: TObject);
begin
  btnApply.Enabled := True;
  DesignRepaint;
end;

// �{�^���̕��ƍ����̓���
procedure TdlgPadProperty.chkBtnSquareClick(Sender: TObject);
begin
  lblBtnHeight.Enabled := not chkBtnSquare.Checked;
  edtBtnHeight.Enabled := not chkBtnSquare.Checked;
  udBtnHeight.Enabled := not chkBtnSquare.Checked;

  if chkBtnSquare.Checked then
    udBtnHeight.Position := udBtnWidth.Position;
  btnApply.Enabled := True;
end;

// �{�^���̕�
procedure TdlgPadProperty.edtBtnWidthChange(Sender: TObject);
begin
  if chkBtnSquare.Checked then
    udBtnHeight.Position := udBtnWidth.Position;
  btnApply.Enabled := True;
  DesignRepaint;
end;

// �{�^���̍���
procedure TdlgPadProperty.edtBtnHeightChange(Sender: TObject);
begin
  btnApply.Enabled := True;
  DesignRepaint;
end;

// �{�^�����̕\��
procedure TdlgPadProperty.cmbBtnCaptionChange(Sender: TObject);
begin
  btnApply.Enabled := True;
  DesignRepaint;
end;

// �w�i�̐F
procedure TdlgPadProperty.btnBackColorClick(Sender: TObject);
begin
  dlgColor.Color := shpBackColor.Brush.Color;
  if dlgColor.Execute and (shpBackColor.Brush.Color <> dlgColor.Color) then
  begin
    shpBackColor.Brush.Color := dlgColor.Color;
    btnApply.Enabled := True;
    DesignRepaint;
  end;
end;

// �{�^���̐F
procedure TdlgPadProperty.btnBtnColorClick(Sender: TObject);
begin
  dlgColor.Color := shpBtnColor.Brush.Color;
  if dlgColor.Execute and (shpBtnColor.Brush.Color <> dlgColor.Color) then
  begin
    shpBtnColor.Brush.Color := dlgColor.Color;
    btnApply.Enabled := True;
    DesignRepaint;
  end;
end;

// �J�����g�{�^���̐F
procedure TdlgPadProperty.btnBtnFocusColorClick(Sender: TObject);
begin
  dlgColor.Color := shpBtnFocusColor.Brush.Color;
  if dlgColor.Execute and (shpBtnFocusColor.Brush.Color <> dlgColor.Color) then
  begin
    shpBtnFocusColor.Brush.Color := dlgColor.Color;
    btnApply.Enabled := True;
    DesignRepaint;
  end;
end;

// �B��Ă�Ƃ��̐F
procedure TdlgPadProperty.btnHideColorClick(Sender: TObject);
begin
  dlgColor.Color := shpHideColor.Brush.Color;
  if dlgColor.Execute and (shpHideColor.Brush.Color <> dlgColor.Color) then
  begin
    shpHideColor.Brush.Color := dlgColor.Color;
    btnApply.Enabled := True;
    DesignRepaint;
  end;
end;

// Windows�W���F
procedure TdlgPadProperty.btnDefaultColorClick(Sender: TObject);
begin
  if (Sender = btnBtnColorDefault) and (shpBtnColor.Brush.Color <> clBtnFace) then
    shpBtnColor.Brush.Color := clBtnFace
  else if (Sender = btnBackColorDefault) and (shpBackColor.Brush.Color <> clAppWorkSpace) then
    shpBackColor.Brush.Color := clAppWorkSpace
  else if (Sender = btnBtnFocusColorDefault) and (shpBtnFocusColor.Brush.Color <> clHighlight) then
    shpBtnFocusColor.Brush.Color := clHighlight
  else if  (Sender = btnHideColorDefault) and (shpHideColor.Brush.Color <> clInactiveCaption) then
    shpHideColor.Brush.Color := clInactiveCaption
  else
    Exit;

  btnApply.Enabled := True;
  DesignRepaint;
end;

// �{�^���𓧖�
procedure TdlgPadProperty.chkBtnTransparentClick(Sender: TObject);
begin
  btnApply.Enabled := True;
  DesignRepaint;
end;

// �J�����g�{�^�����w��̐F�ŕ���
procedure TdlgPadProperty.chkBtnSelTransparentClick(Sender: TObject);
begin
  btnApply.Enabled := True;
  DesignRepaint;
end;

// �ǎ�
procedure TdlgPadProperty.edtWallPaperChange(Sender: TObject);
begin
  btnApply.Enabled := True;
  DesignRepaint;
end;


// �ǎ��Q��
procedure TdlgPadProperty.btnWallPaperClick(Sender: TObject);
begin
  if FileExists(edtWallPaper.Text) then
    dlgOpen.FileName := edtWallPaper.Text
  else
    dlgOpen.FileName := '';

  dlgOpen.Filter := '�r�b�g�}�b�v(*.bmp)|*.bmp|���ׂẴt�@�C��(*.*)|*.*';
  dlgOpen.FilterIndex := 1;

  if dlgOpen.Execute then
    edtWallPaper.Text := dlgOpen.FileName;
end;

// �ǎ��N���A
procedure TdlgPadProperty.btnWallPaperClearClick(Sender: TObject);
begin
  edtWallPaper.Text := '';
end;

// ��Ɏ�O�ɕ\��
procedure TdlgPadProperty.chkTopMostClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// �X�N���[�������炩�ɂ���
procedure TdlgPadProperty.chkSmoothScrollClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// �z�b�g�L�[
procedure TdlgPadProperty.hkActiveKeyEnter(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// �t�@�C�����h���b�v�����Ƃ��̓���
procedure TdlgPadProperty.cmbDropActionChange(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// ���[�N�X�y�[�X�̃_�u���N���b�N
procedure TdlgPadProperty.cmbDblClickActionChange(Sender: TObject);
begin
  btnApply.Enabled := True;
end;



// �����I�ɉB��
procedure TdlgPadProperty.chkHideAutoClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// ���炩�ɉB��
procedure TdlgPadProperty.chkHideSmoothClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// �}�E�X�̒ʉ߂Ō����
procedure TdlgPadProperty.chkHideMouseCheckClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// �B��Ă���Ƃ��{�^���O���[�v���̕\��
procedure TdlgPadProperty.chkHideGroupNameClick(Sender: TObject);
begin
  lblHideSize.Enabled := not chkHideGroupName.Checked;
  edtHideSize.Enabled := not chkHideGroupName.Checked;
  udHideSize.Enabled := not chkHideGroupName.Checked;
  btnApply.Enabled := True;
  DesignRepaint;
end;

// �B��Ă鎞�̃T�C�Y
procedure TdlgPadProperty.edtHideSizeChange(Sender: TObject);
begin
  btnApply.Enabled := True;
  DesignRepaint;
end;

// �㉺�D��A���E�D��
procedure TdlgPadProperty.rdoHideHorizontalClick(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// �����x�� �B���x��
procedure TdlgPadProperty.edtShowDelayChange(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

// �w���v
procedure TdlgPadProperty.btnHelpClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT, 3);
end;

// �����̕ύX
procedure TdlgPadProperty.cmbPartsChange(Sender: TObject);
var
  i: Integer;
begin
  FEnabledApplyBk := btnApply.Enabled;
  btnApply.Enabled := FEnabledApplyBk;

  for i := 0 to FPartPanels.Count - 1 do
  begin
    if cmbParts.ItemIndex = i then
    begin
      TLabel(FPartLabels[i]).Color := clHighlight;
      TLabel(FPartLabels[i]).Font.Color := clHighlightText;
    end
    else
    begin
      TLabel(FPartLabels[i]).Color := clInfoBk;
      TLabel(FPartLabels[i]).Font.Color := clInfoText;
    end;
  end;

  for i := 0 to FPartPanels.Count - 1 do
  begin
    if cmbParts.ItemIndex <> i then
      TPanel(FPartPanels[i]).Visible := False;
  end;
  TPanel(FPartPanels[cmbParts.ItemIndex]).Visible := True;

  btnApply.Enabled := FEnabledApplyBk;
end;

// �R���g���[���̏d�Ȃ�𒲂ׂ�
function ControlOnControl(ControlA, ControlB: TControl): Boolean;
begin
  Result := ((ControlA.BoundsRect.Right  >= ControlB.BoundsRect.Left) and (ControlA.BoundsRect.Right  <=  ControlB.BoundsRect.Right)
          or (ControlB.BoundsRect.Right  >= ControlA.BoundsRect.Left) and (ControlB.BoundsRect.Right  <=  ControlA.BoundsRect.Right))
        and ((ControlA.BoundsRect.Bottom >= ControlB.BoundsRect.Top)  and (ControlA.BoundsRect.Bottom <=  ControlB.BoundsRect.Bottom)
          or (ControlB.BoundsRect.Bottom >= ControlA.BoundsRect.Top)  and (ControlB.BoundsRect.Bottom <=  ControlA.BoundsRect.Bottom));
end;


// �f�U�C���̕`��
procedure TdlgPadProperty.DesignRepaint;
var
  MarginSize: Integer;
  LogFont: TLogFont;
  NewFont, OldFont: HFont;
  DragBarSize: Integer;
  PadWidth, PadHeight: Integer;
  i, j, x, y: Integer;
  Pos: TPoint;
  W, Half, Long: Integer;
  BtnFrameWidth, BtnFrameHeight: Integer;
  SLNormalButton: TSLNormalButton;
  C: LongInt;
  R, G, B: Word;
begin
  MarginSize := 2;

  // �h���b�O�o�[
  case cmbDragBar.ItemIndex of
    DS_LEFT: pnlDragBar.Align := alLeft;
    DS_TOP: pnlDragBar.Align := alTop;
    DS_RIGHT: pnlDragBar.Align := alRight;
    DS_BOTTOM: pnlDragBar.Align := alBottom;
  end;
  pnlDragBar.Visible := cmbDragBar.ItemIndex <> DS_NONE;

  // �X�N���[���o�[
  case cmbScrollBar.ItemIndex of
    DS_LEFT: pnlScrollBar.Align := alLeft;
    DS_TOP: pnlScrollBar.Align := alTop;
    DS_RIGHT: pnlScrollBar.Align := alRight;
    DS_BOTTOM: pnlScrollBar.Align := alBottom;
  end;
  pnlScrollBar.Visible := cmbScrollBar.ItemIndex <> DS_NONE;

  // �{�^���O���[�v���\��
  if chkGroupName.Checked then
  begin
    GetObject(pbDragBar.Canvas.Font.Handle, SizeOf(LogFont), @LogFont);
    if pnlDragBar.Align = alLeft then
      LogFont.lfEscapement := 900
    else if pnlDragBar.Align = alRight then
      LogFont.lfEscapement := 2700
    else
      LogFont.lfEscapement := 0;

    NewFont := CreateFontIndirect(LogFont);
    try
      OldFont := SelectObject(pbDragBar.Canvas.Handle, NewFont);
      DragBarSize := Abs(pbDragBar.Font.Height) + 2;
      NewFont := SelectObject(pbDragBar.Canvas.Handle, OldFont);
    finally
      DeleteObject(NewFont);
    end;
  end
  else
    DragBarSize := udDragBarSize.Position;


  BtnFrameWidth := udBtnWidth.Position + BUTTON_MARGIN;
  BtnFrameHeight := udBtnHeight.Position + BUTTON_MARGIN;

  // �p�b�h�̕��ƍ���
  PadWidth := BtnFrameWidth * 4;
  PadHeight := BtnFrameHeight * 3;
  if cmbDragBar.ItemIndex in [DS_LEFT, DS_RIGHT] then
  begin
    pnlDragBar.Width := DragBarSize;
    PadWidth := PadWidth + DragBarSize;
  end
  else if cmbDragBar.ItemIndex in [DS_TOP, DS_BOTTOM] then
  begin
    pnlDragBar.Height := DragBarSize;
    PadHeight := PadHeight + DragBarSize;
  end;

  if cmbScrollBar.ItemIndex in [DS_LEFT, DS_RIGHT] then
  begin
    pnlScrollBar.Width := udScrollSize.Position;
    PadWidth := PadWidth + udScrollSize.Position;
  end
  else if cmbScrollBar.ItemIndex in [DS_TOP, DS_BOTTOM] then
  begin
    pnlScrollBar.Height := udScrollSize.Position;
    PadHeight := PadHeight + udScrollSize.Position;
  end;
  pnlPad.SetBounds(pnlPad.Left, pnlPad.Top, PadWidth + MarginSize, PadHeight + MarginSize);

  if pnlDragBar.Visible then
  begin
    Pos := Point(pnlDragBar.Left + pnlDragBar.Width div 2, pnlDragBar.Top + pnlDragBar.Height div 2);
    Pos :=pnlPad.ClientToScreen(Pos);
    Pos := scrDesign.ScreenToClient(Pos);
    pnlDragBarLabel.SetBounds(Pos.X, Pos.Y, pnlDragBarLabel.Width, pnlDragBarLabel.Height);
  end
  else
  begin
    pnlDragBarLabel.SetBounds(pnlPad.Left, pnlPad.Top + pnlPad.Height, pnlDragBarLabel.Width, pnlDragBarLabel.Height);
  end;

  // �{�^��
  x := 0;
  y := 0;
  for i := 0 to FButtons.Count - 1 do
  begin
    SLNormalButton := FButtons[i];

    SLNormalButton.Left := x;
    SLNormalButton.Top := y;
    SLNormalButton.Width := BtnFrameWidth;
    SLNormalButton.Height := BtnFrameHeight;
    SLNormalButton.Active := True;
    if i = 4 then
      SLNormalButton.Selected := True;

    SLNormalButton.Color := shpBtnColor.Brush.Color;
    SLNormalButton.Transparent := chkBtnTransparent.Checked;
    case cmbBtnCaption.ItemIndex of
      CP_NONE: SLNormalButton.CaptionPosition := cpNone;
      CP_BOTTOM: SLNormalButton.CaptionPosition := cpBottom;
      CP_RIGHT: SLNormalButton.CaptionPosition := cpRight;
    end;
    SLNormalButton.SmallIcon := chkBtnSmallIcon.Checked;
    SLNormalButton.IconHandle := IconCache.GetIcon(PChar('Shell32.dll'), ftIconPath, i, chkBtnSmallIcon.Checked, True);
    SLNormalButton.FocusColor := shpBtnFocusColor.Brush.Color;
    SLNormalButton.SelTransparent := chkBtnSelTransparent.Checked;

    if i in [0, 4] then
    begin
      Pos := Point(SLNormalButton.Left + SLNormalButton.Width div 2, SLNormalButton.Top + SLNormalButton.Height div 2);
      Pos := pnlButtons.ClientToScreen(Pos);
      Pos := scrDesign.ScreenToClient(Pos);
      if i = 0 then
        pnlButtonLabel.SetBounds(Pos.X, Pos.Y, pnlButtonLabel.Width, pnlButtonLabel.Height)
      else
        pnlSelButtonLabel.SetBounds(Pos.X, Pos.Y, pnlSelButtonLabel.Width, pnlSelButtonLabel.Height)
    end;

    if cmbLayout.ItemIndex = 0 then
    begin
      Inc(x, BtnFrameWidth);
      if i = 3 then
      begin
        x := 0;
        Inc(y, BtnFrameHeight);
      end;
    end
    else
    begin
      Inc(y, BtnFrameHeight);
      if i = 2 then
      begin
        Inc(x, BtnFrameWidth);
        y := 0;
      end;
    end;
  end;


  // �X�N���[���{�^��
  for i := 0 to FScrolls.Count - 1 do
  begin
    TSLScrollButton(FScrolls[i]).Vertical := cmbLayout.ItemIndex = 0;
    TSLScrollButton(FScrolls[i]).Color := shpBtnColor.Brush.Color;
    TSLScrollButton(FScrolls[i]).Transparent := chkBtnTransparent.Checked;
    if i in [0, 3] then
      TSLScrollButton(FScrolls[i]).Visible := chkGroupBtn.Checked
    else
      TSLScrollButton(FScrolls[i]).Visible := chkScrollBtn.Checked;
  end;

  if pnlScrollBar.Align in [alLeft, alRight] then
  begin
    W := pnlScrollBar.ClientWidth;
    Half := pnlScrollBar.ClientHeight div 2;
    if chkScrollBtn.Checked and chkGroupBtn.Checked then
    begin
      Long := Half - pnlScrollBar.ClientWidth;
      if Long < pnlScrollBar.ClientWidth then
        Long := pnlScrollBar.ClientHeight div 4;
      TSLScrollButton(FScrolls[0]).SetBounds(0, 0,           W, Half - Long);
      TSLScrollButton(FScrolls[1]).SetBounds(0, Half - Long, W, Long);
      TSLScrollButton(FScrolls[2]).SetBounds(0, Half,        W, Long);
      TSLScrollButton(FScrolls[3]).SetBounds(0, Half + Long, W, Half - Long);
    end
    else
    begin
      TSLScrollButton(FScrolls[0]).SetBounds(0, 0,    W, Half);
      TSLScrollButton(FScrolls[1]).SetBounds(0, 0,    W, Half);
      TSLScrollButton(FScrolls[2]).SetBounds(0, Half, W, Half);
      TSLScrollButton(FScrolls[3]).SetBounds(0, Half, W, Half);
    end;
  end
  else
  begin
    W := pnlScrollBar.ClientHeight;
    Half := pnlScrollBar.ClientWidth div 2;
    if chkScrollBtn.Checked and chkGroupBtn.Checked then
    begin
      Long := Half - pnlScrollBar.ClientHeight;
      if Long < pnlScrollBar.ClientHeight then
        Long := pnlScrollBar.ClientWidth div 4;
      TSLScrollButton(FScrolls[0]).SetBounds(0,           0, Half - Long, W);
      TSLScrollButton(FScrolls[1]).SetBounds(Half - Long, 0, Long,        W);
      TSLScrollButton(FScrolls[2]).SetBounds(Half,        0, Long,        W);
      TSLScrollButton(FScrolls[3]).SetBounds(Half + Long, 0, Half - Long, W);
    end
    else
    begin
      TSLScrollButton(FScrolls[0]).SetBounds(0, 0,    Half, W);
      TSLScrollButton(FScrolls[1]).SetBounds(0, 0,    Half, W);
      TSLScrollButton(FScrolls[2]).SetBounds(Half, 0, Half, W);
      TSLScrollButton(FScrolls[3]).SetBounds(Half, 0, Half, W);
    end;
  end;


  if pnlScrollBar.Visible then
  begin
    Pos := Point(pnlScrollBar.Left + pnlScrollBar.Width div 2, pnlScrollBar.Top + pnlScrollBar.Height div 2);
    Pos := pnlWorkspace.ClientToScreen(Pos);
    Pos := scrDesign.ScreenToClient(Pos);
    pnlScrollBarLabel.SetBounds(Pos.X, Pos.Y, pnlScrollBarLabel.Width, pnlScrollBarLabel.Height);
  end
  else
    pnlScrollBarLabel.SetBounds(pnlPad.Left + PnlPad.Width, PnlPad.Top + PnlPad.Height, pnlScrollBarLabel.Width, pnlScrollBarLabel.Height);

  Pos := Point(pnlWorkspace.Left + pnlWorkspace.Width div 2, pnlWorkspace.Top + pnlWorkspace.Height div 2);
  Pos := scrDesign.ClientToScreen(Pos);
  Pos := scrDesign.ScreenToClient(Pos);
  pnlWorkspaceLabel.SetBounds(Pos.X, Pos.Y, pnlWorkspaceLabel.Width, pnlWorkspaceLabel.Height);


  // �B��Ă�Ƃ��̃T�C�Y
  if chkHideGroupName.Checked then
    pnlHide.Height := Abs(pbHide.Font.Height) + 2
  else
    pnlHide.Height := udHideSize.Position;

  Pos := Point(pnlHide.Left + pnlHide.Width div 2, pnlHide.Top + pnlHide.Height div 2);
  Pos := scrDesign.ClientToScreen(Pos);
  Pos := scrDesign.ScreenToClient(Pos);
  pnlHideLabel.SetBounds(Pos.X, Pos.Y, pnlHideLabel.Width, pnlHideLabel.Height);

  C := ColorToRGB(shpBtnColor.Brush.Color);
  R := GetRValue(C);
  G := GetGValue(C);
  B := GetBValue(C);

  if shpBtnColor.Brush.Color = clBtnFace then
  begin
    FHighlightColor := clBtnHighlight;
    FShadowColor := clBtnShadow;
  end
  else
  begin
    FHighlightColor := RGB((R + $FF) div 2, (G + $FF) div 2, (B + $FF) div 2);
    FShadowColor := RGB(R div 2, G div 2, B div 2);
  end;

  i := 0;
  while i < FPartLabels.Count do
  begin
    j := 0;
    while j < FPartLabels.Count do
    begin
      if (i <> j) and ControlOnControl(FPartLabels[i], FPartLabels[j]) then
      begin
        if TPanel(FPartLabels[i]).Top <= TPanel(FPartLabels[j]).Top then
        begin
          TPanel(FPartLabels[j]).Top := TPanel(FPartLabels[i]).Top + TPanel(FPartLabels[i]).Height + 1;
          i := j;
        end
        else
          TPanel(FPartLabels[i]).Top := TPanel(FPartLabels[j]).Top + TPanel(FPartLabels[j]).Height + 1;
        Break;
      end;
      Inc(j);
    end;
    // j �������d�Ȃ��ĂȂ����
    if j >= FPartLabels.Count then
      Inc(i);
  end;

  pbDragBar.Refresh;
  pbScrollBar.Refresh;
  pbWorkSpace.Refresh;
  pbHide.Refresh;
end;

// �h���b�O�o�[�`��
procedure TdlgPadProperty.pbDragBarPaint(Sender: TObject);
var
  GrpName: string;
  IsGradat: BOOL;
  ARect: TRect;
  Direction: TDirection;
begin
  GrpName := '�{�^���O���[�v��';

  if not SystemParametersInfo(SPI_GETGRADIENTCAPTIONS, 0, @IsGradat, 0) then
    IsGradat := False;

  with pbDragBar do
  begin
    if pnlDragBar.Align = alLeft then
      Direction := drBottomUp
    else if pnlDragBar.Align = alRight then
      Direction := drTopDown
    else
      Direction := drLeftRight;

    Canvas.Brush.Color := clActiveCaption;
    if IsGradat then
      GradationRect(Canvas, ClientRect, Direction, clActiveCaption, TColor(clGradientActiveCaption))
    else
      Canvas.FillRect(ClientRect);

    if chkGroupName.Checked then
    begin
      Canvas.Brush.Style := bsClear;

      ARect := ClientRect;
//      InflateRect(ARect, -2, -2);
//      Direction := drRightLeft;
      OffsetRect(ARect, 1, 1);
      Canvas.Font.Color := GetShadowColor(clActiveCaption);
      RotateTextOut(Canvas, ARect, Direction, GrpName);
      OffsetRect(ARect, -1, -1);
      Canvas.Font.Color := clCaptionText;
      RotateTextOut(Canvas, ARect, Direction, GrpName);
    end;
  end;
end;


procedure DrawWallPaper(PaintBox: TPaintBox; FileName: String; BGColor: TColor);
var
  x, y, mx, my: Integer;
  FWallPaperBitmap: TBitmap;
begin
  // �w�i
  if FileExists(FileName) then
  begin
    FWallPaperBitmap := TBitmap.Create;
    try
      try
        FWallPaperBitmap.LoadFromFile(FileName);
        with PaintBox.Canvas do
        begin
          mx := FWallPaperBitmap.Width;
          my := FWallPaperBitmap.Height;
          y := ClipRect.Top div my * my;
          while y < ClipRect.Bottom do
          begin
            x := ClipRect.Left div mx * mx;
            while x <= ClipRect.Right do
            begin
              Draw(x, y, FWallPaperBitmap);
              Inc(x, mx);
            end;
            Inc(y, my);
          end;
        end;
      except
        PaintBox.Canvas.Brush.Color := BGColor;
        PaintBox.Canvas.FillRect(PaintBox.ClientRect);
      end;
    finally
      FWallPaperBitmap.Free;
    end;
  end
  else
  begin
    PaintBox.Canvas.Brush.Color := BGColor;
    PaintBox.Canvas.FillRect(PaintBox.ClientRect);
  end;
end;



// ���[�N�X�y�[�X�`��
procedure TdlgPadProperty.pbWorkspacePaint(Sender: TObject);
begin
  DrawWallPaper(pbWorkspace, edtWallPaper.Text, shpBackColor.Brush.Color);
end;

// �X�N���[���o�[�`��
procedure TdlgPadProperty.pbScrollBarPaint(Sender: TObject);
begin
  DrawWallPaper(pbScrollBar, edtWallPaper.Text, shpBackColor.Brush.Color);
end;


// �B��Ă�Ƃ�
procedure TdlgPadProperty.pbHidePaint(Sender: TObject);
var
  IsGradat: BOOL;
begin
  if not SystemParametersInfo(SPI_GETGRADIENTCAPTIONS, 0, @IsGradat, 0) then
    IsGradat := False;

  with pbHide do
  begin
    Canvas.Brush.Color := shpHideColor.Brush.Color;
    Canvas.Font.Color := GetFontColorFromFaceColor(Canvas.Brush.Color);

    if IsGradat and (Canvas.Brush.Color = clInactiveCaption) then
      GradationRect(Canvas, ClientRect, drLeftRight, clInactiveCaption, TColor(clGradientInactiveCaption))
    else
      Canvas.FillRect(ClientRect);

    if chkHideGroupName.Checked then
    begin
      Canvas.Brush.Style := bsClear;

      RotateTextOut(Canvas, ClientRect, drLeftRight, '�{�^���O���[�v��');
    end;
  end;
end;


procedure TdlgPadProperty.scrDesignMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  ScrCurPos, CtrlCurPos: TPoint;
  SLButton: TSLButton;
  Rect: TRect;
begin
  ScrCurPos := scrDesign.ClientToScreen(Point(X, Y));

  // �h���b�O�o�[
  CtrlCurPos := pnlDragBar.ScreenToClient(ScrCurPos);
  if pnlDragBar.Visible and PtInRect(pnlDragBar.ClientRect, CtrlCurPos) then
    cmbParts.ItemIndex := cmbParts.Items.IndexOf('�h���b�O�o�[');

  // �X�N���[���o�[
  CtrlCurPos := pnlScrollBar.ScreenToClient(ScrCurPos);
  if pnlScrollBar.Visible and PtInRect(pnlScrollBar.ClientRect, CtrlCurPos) then
    cmbParts.ItemIndex := cmbParts.Items.IndexOf('�X�N���[���o�[');

  // ���[�N�X�y�[�X
  CtrlCurPos := pnlButtons.ScreenToClient(ScrCurPos);
  if PtInRect(pnlButtons.ClientRect, CtrlCurPos) then
    cmbParts.ItemIndex := cmbParts.Items.IndexOf('���[�N�X�y�[�X');

  // �{�^��
  for i := 0 to FButtons.Count - 1 do
  begin
    SLButton := TSLButton(FButtons[i]);
    CtrlCurPos := SLButton.ScreenToClient(ScrCurPos);
    if PtInRect(SLButton.ClientRect, CtrlCurPos) then
    begin
      if i < FButtons.Count - 1 then
        cmbParts.ItemIndex := cmbParts.Items.IndexOf('�{�^��')
      else
        cmbParts.ItemIndex := cmbParts.Items.IndexOf('�I�����ꂽ�{�^��');
    end;
  end;

  // �B��Ă�����
  Rect := pnlHide.ClientRect;
  InflateRect(Rect, 0, 3);
  CtrlCurPos := pnlHide.ScreenToClient(ScrCurPos);
  if pnlHide.Visible and PtInRect(Rect, CtrlCurPos) then
    cmbParts.ItemIndex := cmbParts.Items.IndexOf('�B��Ă�����');



  cmbPartsChange(cmbParts);

end;

// �������x��
procedure TdlgPadProperty.PartLabelClick(Sender: TObject);
begin
  cmbParts.ItemIndex := FPartLabels.IndexOf(Sender);
  cmbPartsChange(cmbParts);
end;

procedure TdlgPadProperty.chkVisiblePartLabelsClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to FPartLabels.Count - 1 do
  begin
    TPanel(FPartLabels[i]).Visible := chkVisiblePartLabels.Checked;
  end;
  if not UserIniReadOnly then
    UserIniFile.WriteBool(IS_WINDOWS, 'PadOptionVisiblePartLabels', chkVisiblePartLabels.Checked);
end;

// �X�L���`��
procedure TdlgPadProperty.cmbSkinsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  x, y: Integer;
  Plugin: TPlugin;
  Icon: TIcon;
begin
  with Control as TComboBox do
  begin
    Canvas.FillRect(Rect);

    x := 2;
    Plugin := TPlugin(Items.Objects[Index]);
    if Plugin <> nil then
    begin
      Icon := TIcon.Create;
      try
        Icon.Handle := IconCache.GetIcon(PChar(Plugin.FileName), ftIconPath, 0, False, False);
        DrawIconEx(Canvas.Handle, Rect.Left + x, Rect.Top + 2, Icon.Handle, 32, 32, 0, 0, DI_NORMAL);
        Inc(x, 32 + 4);
      finally
        Icon.Free;
      end;

    end;

    y := ((Rect.Bottom - Rect.Top) - Canvas.TextHeight(Items[Index])) div 2;
    Canvas.TextOut(Rect.Left + x, Rect.Top + y, Items[Index]);
  end;
end;

// �X�L���v���O�C��
procedure TdlgPadProperty.cmbSkinsChange(Sender: TObject);
begin
  btnApply.Enabled := True;
end;

end.
