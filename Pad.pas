unit Pad;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus, PadTab, PadPro, SetInit, SetBtn, Buttons, SLBtns,
  SetArrg, SetIcons, ImgList, SetPlug, BtnPro, OleBtn, ActiveX, ShlObj, Clipbrd,
  MMSystem, IniFiles, ComCtrls, VerCheck, ShellAPI;

type
  TStickPosition = (spLeft, spTop, spRight, spBottom);
  TStickPositions = set of TStickPosition;
  TNextDirection = (ndUp, ndDown, ndLeft, ndRight, ndPageUp, ndPageDown,
                    ndHome, ndEnd, ndCHome, ndCEnd);


  TfrmPad = class(TForm)
    popMain: TPopupMenu;
    popPluginEnd: TMenuItem;
    popPadDelete: TMenuItem;
    popExit: TMenuItem;
    popOption: TMenuItem;
    N2: TMenuItem;
    popPadCopy: TMenuItem;
    tmHideScreen: TTimer;
    popPadProperty: TMenuItem;
    popGroup: TMenuItem;
    popButtonEdit: TMenuItem;
    popHelp: TMenuItem;
    popAbout: TMenuItem;
    popSearchTopic: TMenuItem;
    pnlMain: TPanel;
    popTopMost: TMenuItem;
    pnlScrollBar: TPanel;
    pnlWorkSpace: TPanel;
    pnlButtons: TPanel;
    pnlDragBar: TPanel;
    pbDragBar: TPaintBox;
    popButtonAdd: TMenuItem;
    popButton: TMenuItem;
    popPad: TMenuItem;
    popPadNew: TMenuItem;
    popPluginBegin: TMenuItem;
    popButtonModify: TMenuItem;
    popButtonCopy: TMenuItem;
    popButtonCut: TMenuItem;
    popButtonPaste: TMenuItem;
    popButtonDelete: TMenuItem;
    N6: TMenuItem;
    popButtonSpace: TMenuItem;
    popButtonReturn: TMenuItem;
    N1: TMenuItem;
    N7: TMenuItem;
    popButtonBackSpace: TMenuItem;
    popButtonNextDelete: TMenuItem;
    popHideAuto: TMenuItem;
    pbWallPaper1: TPaintBox;
    pbWallPaper2: TPaintBox;
    popRightDrop: TPopupMenu;
    popDropAddHere: TMenuItem;
    popDropOpenHere: TMenuItem;
    popDropCopyName: TMenuItem;
    popDropAddLast: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N5: TMenuItem;
    N10: TMenuItem;
    popComLine: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    popDblClick: TPopupMenu;
    popPadDeleteSep: TMenuItem;
    popPadHide: TMenuItem;
    popButtonFolder: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    popVerCheck: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure pnlDragBarMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure popPadDeleteClick(Sender: TObject);
    procedure popExitClick(Sender: TObject);
    procedure popPadCopyClick(Sender: TObject);
    procedure popOptionClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure tmHideScreenTimer(Sender: TObject);
    procedure popPadPropertyClick(Sender: TObject);
    procedure popGroupItemClick(Sender: TObject);
    procedure popButtonEditClick(Sender: TObject);
    procedure popAboutClick(Sender: TObject);
    procedure pbDragBarPaint(Sender: TObject);
    procedure popTopMostClick(Sender: TObject);
    procedure pnlScrollBarResize(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure popMainPopup(Sender: TObject);
    procedure popPadNewClick(Sender: TObject);
    procedure popButtonAddClick(Sender: TObject);
    procedure popButtonModifyClick(Sender: TObject);
    procedure popButtonCutClick(Sender: TObject);
    procedure popButtonCopyClick(Sender: TObject);
    procedure popButtonPasteClick(Sender: TObject);
    procedure popButtonSpaceClick(Sender: TObject);
    procedure popButtonReturnClick(Sender: TObject);
    procedure popButtonDeleteClick(Sender: TObject);
    procedure popButtonBackSpaceClick(Sender: TObject);
    procedure popButtonNextDeleteClick(Sender: TObject);
    procedure popHideAutoClick(Sender: TObject);
    procedure pbWallPaper1Paint(Sender: TObject);
    procedure popRightDropAction(Sender: TObject);
    procedure popComLineClick(Sender: TObject);
    procedure pnlDragBarDblClick(Sender: TObject);
    procedure popPadHideClick(Sender: TObject);
    procedure FormContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure pnlDragBarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure popButtonFolderClick(Sender: TObject);
    procedure popSearchTopicClick(Sender: TObject);
    procedure popRightDropPopup(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure popVerCheckClick(Sender: TObject);
  private
    FUpdateCount: Integer;
    ArrangeScrollsWaited: Boolean;
    ArrangeButtonsWaited: Boolean;

    btnScrolls: array[0..3] of TSLScrollButton;
    FCurrentColBack: Integer; // ���̈ʒu���o���Ă���
    FCurrentViewRow: Integer; // �J�����g�̏c�̈ʒu���o���Ă���
    FDblClicked: Boolean;
    FUserResize: Boolean;
    FISearch: string;
    FISearchTimer: TTimer;
    FWallPaperBitmap: TBitmap;
    FDropTarget: TDropTarget;
    FDropTargetTimer: TTimer;
    FDropTargetControl: TControl;
    FDropRButton: Boolean;
    FDropButtons: TButtonGroup;
    FDropIndex: Integer;

    FfrmPadTab: TfrmPadTab;
    FDialogBox: TForm;

    FButtonGroups: TButtonGroups;
    FButtonGroup: TButtonGroup;
    FButtonArrangement: TButtonArrangement;

    FID: Integer;
    FBtnFileName: String;
    
    FCols: Integer;
    FRows: Integer;
    FScrollBar: Integer;
    FScrollSize: Integer;
    FScrollBtn: Boolean;
    FGroupBtn: Boolean;
    FBtnVertical: Boolean;
    FBtnFocusColor: TColor;
    FBtnTransparent: Boolean;
    FBtnSelTransparent: Boolean;
    FBtnSmallIcon: Boolean;
    FBtnSquare: Boolean;
    FBtnWidth: Integer;
    FBtnHeight: Integer;
    FBtnCaption: Integer;
    FBtnColor: TColor;

    FTopLineIndex: Integer;

//    FPropertyPageNo: Integer;
    FTopMost: Boolean;
    FSmoothScroll: Boolean;
    FHotkey: Word;
    FDropAction: Integer;
    FDblClickAction: Integer;
    FWallPaper: string;
    FDragBar: Integer;
    FGroupName: Boolean;
    FDragBarSize: Integer;
    FHideAuto: Boolean;
    FHideSmooth: Boolean;
    FHideMouseCheck: Boolean;
    FHideVertical: Boolean;
    FHideGroupName: Boolean;
    FHideSize: Integer;
    FShowDelay: Integer;
    FHideDelay: Integer;
    FHideColor: TColor;
    FSkinPlugin: TPlugin;

    FForeground: Boolean;
    FMouseEntered: Boolean;
    FStickPositions: TStickPositions;
    FLeftPercentage: Single;
    FTopPercentage: Single;

    function GetButtonsAreaWidth: Integer;
    function GetButtonsAreaHeight: Integer;
    procedure ButtonArranged(Sender: TObject);
    procedure btnScrollsClick(Sender: TObject); // �X�N���[���o�[��OnClick
    procedure btnScrollsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnScrollsMouseEnter(Sender: TObject); // �X�N���[���o�[��OnMouseEnter
    procedure btnScrollsMouseLeave(Sender: TObject); // �X�N���[���o�[��OnMouseLeave
    procedure btnSLButtonClick(Sender: TObject); // �{�^����OnClick
    procedure btnSLButtonMouseEnter(Sender: TObject); // �{�^����OnMouseEnter
    procedure btnSLButtonMouseLeave(Sender: TObject); // �{�^����OnMouseLeave
    procedure btnSLButtonStartDrag(Sender: TObject); // �{�^����OnStartDrag
    function btnSLButtonSkinDrawFace(Sender: TObject; Rect: TRect): Boolean; // �{�^���̃X�L���`��
    function btnSLButtonSkinDrawFrame(Sender: TObject; Rect: TRect): Boolean; // �{�^���̃X�L���`��
    function btnSLButtonSkinDrawIcon(Sender: TObject; Rect: TRect): Boolean; // �{�^���̃X�L���`��
    function btnSLButtonSkinDrawCaption(Sender: TObject; Rect: TRect): Boolean; // �{�^���̃X�L���`��
    function btnSLButtonSkinDrawMask(Sender: TObject; Rect: TRect): Boolean; // �{�^���̃X�L���`��
    procedure btnPluginButtonDestroy(Sender: TObject); // �v���O�C���{�^����OnDestroy
    procedure btnPluginButtonDrawButton(Sender: TObject; Rect: TRect;
      State: TButtonState); // �v���O�C���{�^����OnDrawButton
    procedure popPluginMenuClick(Sender: TObject); // �v���O�C�����j���[��OnClick

    procedure DialogBoxClosed(Sender: TObject); // �e�_�C�A���O�{�b�N�X��OnClosed
    procedure DialogBoxWindowActivate(Sender: TObject); // �e�_�C�A���O�{�b�N�X��OnWindowActivate
    procedure DialogBoxWindowDeactivate(Sender: TObject); // �e�_�C�A���O�{�b�N�X��OnWindowActivate
    procedure dlgButtonEditApply(Sender: TObject); // dlgButtonEdit��OnApply
    procedure dlgPadPropertyApply(Sender: TObject); // dlgPadProperty��OnApply
    procedure dlgBtnPropertyApply(Sender: TObject); // dlgBtnProperty��OnApply

    procedure ISearchTimerTimer(Sender: TObject); // �C���N�������^���T�[�`�̃f�B���C

    procedure ScrollButtons(Smooth: Boolean);
    procedure MoveCurrent(NextDirection: TNextDirection);
    procedure CurrentMakeVisible;
    procedure CurrentTitle;
    procedure AddSingleButtonData(ButtonData: TButtonData; Index: Integer);
    procedure AddMultiButtonData(AButtonGroup: TButtonGroup; Index: Integer);
    procedure ModifyButtonData(ButtonData: TButtonData);
    function QuestDeleteButton(Index: Integer; Copy: Boolean): Boolean;
    procedure DeleteButtonData(Index: Integer);
    procedure CopyButtonData(Index: Integer);
    procedure DragButtonData(Index: Integer);
    procedure OleDragEnter(var DataObject: IDataObject; KeyState: Longint;
      Point: TPoint; var dwEffect: Longint);
    procedure OleDragOver(var DataObject: IDataObject; KeyState: Longint;
      Point: TPoint; var dwEffect: Longint);
    procedure DropTargetTimerTimer(Sender: TObject);
    procedure OleDragLeave;
    procedure OleDragDrop(var DataObject: IDataObject; KeyState: Longint;
      Point: TPoint; var dwEffect: Longint);
    procedure DoDropAction(Action: Integer);
    procedure DropPluginFile(PluginFileList: TStringList);
  protected
    procedure SetDialogBox(Value: TForm);
    procedure SetButtonGroup(Value: TButtonGroup);
    function GetBtnFileName: String;
    procedure SetCols(Value: Integer);
    procedure SetRows(Value: Integer);
    function GetGroupIndex: Integer;
    procedure SetGroupIndex(Value: Integer);
    procedure SetScrollBar(Value: Integer);
    procedure SetScrollSize(Value: Integer);
    procedure SetScrollBtn(Value: Boolean);
    procedure SetGroupBtn(Value: Boolean);
    procedure SetBtnVertical(Value: Boolean);
    procedure SetBtnFocusColor(Value: TColor);
    procedure SetBtnTransparent(Value: Boolean);
    procedure SetBtnSelTransparent(Value: Boolean);
    procedure SetBtnSmallIcon(Value: Boolean);
    procedure SetBtnSquare(Value: Boolean);
    procedure SetBtnWidth(Value: Integer);
    procedure SetBtnHeight(Value: Integer);
    function GetBtnFrameWidth: Integer;
    function GetBtnFrameHeight: Integer;
    procedure SetBtnCaption(Value: Integer);
    procedure SetBtnColor(Value: TColor);

    procedure SetTopLineIndex(Value: Integer);
    function GetButtonIndex: Integer;
    procedure SetButtonIndex(Value: Integer);

    procedure SetTopMost(Value: Boolean);
    procedure SetHotkey(Value: Word);
    function GetBackColor: Integer;
    procedure SetBackColor(Value: Integer);
    procedure SetWallPaper(Value: String);
    procedure SetDragBar(Value: Integer);
    procedure SetGroupName(Value: Boolean);
    procedure SetDragBarSize(Value: Integer);
    procedure SetSkinPlugin(Value: TPlugin);
    procedure SetForeground(Value: Boolean);
    procedure SetMouseEntered(Value: Boolean);
    function GetDropEnabled: Boolean;
    procedure SetDropEnabled(Value: Boolean);
  public
    property frmPadTab: TfrmPadTab read FfrmPadTab;
    property DialogBox: TForm read FDialogBox write SetDialogBox;

    property ButtonGroups: TButtonGroups read FButtonGroups;
    property ButtonGroup: TButtonGroup read FButtonGroup write SetButtonGroup;
    property ButtonArrangement: TButtonArrangement read FButtonArrangement;

    property ID: Integer read FID write FID;
    property BtnFileName: String read GetBtnFileName;

    property Cols: Integer read FCols write SetCols;
    property Rows: Integer read FRows write SetRows;
    property GroupIndex: Integer read GetGroupIndex write SetGroupIndex;
    property ScrollBar: Integer read FScrollBar write SetScrollBar;
    property ScrollSize: Integer read FScrollSize write SetScrollSize;
    property ScrollBtn: Boolean read FScrollBtn write SetScrollBtn;
    property GroupBtn: Boolean read FGroupBtn write SetGroupBtn;
    property BtnVertical: Boolean read FBtnVertical write SetBtnVertical;
    property BtnFocusColor: TColor read FBtnFocusColor write SetBtnFocusColor;
    property BtnTransparent: Boolean read FBtnTransparent write SetBtnTransparent;
    property BtnSelTransparent: Boolean read FBtnSelTransparent write SetBtnSelTransparent;
    property BtnSmallIcon: Boolean read FBtnSmallIcon write SetBtnSmallIcon;
    property BtnSquare: Boolean read FBtnSquare write SetBtnSquare;
    property BtnWidth: Integer read FBtnWidth write SetBtnWidth;
    property BtnHeight: Integer read FBtnHeight write SetBtnHeight;
    property BtnFrameWidth: Integer read GetBtnFrameWidth;
    property BtnFrameHeight: Integer read GetBtnFrameHeight;
    property BtnCaption: Integer read FBtnCaption write SetBtnCaption;
    property BtnColor: TColor read FBtnColor write SetBtnColor;

    property TopLineIndex: Integer read FTopLineIndex write SetTopLineIndex;
    property ButtonIndex: Integer read GetButtonIndex write SetButtonIndex;

//    property PropertyPageNo: Integer read FPropertyPageNo write FPropertyPageNo;
    property TopMost: Boolean read FTopMost write SetTopMost;
    property SmoothScroll: Boolean read FSmoothScroll write FSmoothScroll;
    property Hotkey: Word read FHotkey write SetHotkey;
    property DropAction: Integer read FDropAction write FDropAction;
    property DblClickAction: Integer read FDblClickAction write FDblClickAction;
    property BackColor: Integer read GetBackColor write SetBackColor;
    property WallPaper: String read FWallPaper write SetWallPaper;
    property DragBar: Integer read FDragBar write SetDragBar;
    property GroupName: Boolean read FGroupName write SetGroupName;
    property DragBarSize: Integer read FDragBarSize write SetDragBarSize;
    property HideAuto: Boolean read FHideAuto write FHideAuto;
    property HideSmooth: Boolean read FHideSmooth write FHideSmooth;
    property HideMouseCheck: Boolean read FHideMouseCheck write FHideMouseCheck;
    property HideVertical: Boolean read FHideVertical write FHideVertical;
    property HideGroupName: Boolean read FHideGroupName write FHideGroupName;
    property HideSize: Integer read FHideSize write FHideSize;
    property ShowDelay: Integer read FShowDelay write FShowDelay;
    property HideDelay: Integer read FHideDelay write FHideDelay;
    property HideColor: TColor read FHideColor write FHideColor;
    property SkinPlugin: TPlugin read FSkinPlugin write SetSkinPlugin;
    property Foreground: Boolean read FForeground write SetForeground;
    property MouseEntered: Boolean read FMouseEntered write SetMouseEntered;
    property StickPositions: TStickPositions read FStickPositions;

    property DropEnabled: Boolean read GetDropEnabled write SetDropEnabled;

    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMWindowPosChanging(var Msg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure WMSizing(var Msg: TMessage); message WM_SIZING;
    procedure WMMoving(var Msg: TMessage); message WM_MOVING;
    procedure WMDisplayChange(var Msg: TWMDisplayChange); message WM_DISPLAYCHANGE;
    procedure WMSettingChange(var Msg: TWMSettingChange); message WM_SETTINGCHANGE;
    procedure WMContextMenu(var Msg: TWMContextMenu); message WM_CONTEXTMENU;

    procedure WMActivate(var Msg: TWMActivate); message WM_ACTIVATE;
    procedure WMEnable(var Msg: TWMEnable); message WM_ENABLE;

    procedure Assign(Source: TPersistent); override;
    procedure LoadBtn(FileName: TFileName);
    procedure LoadIni(FileName: TFileName);
    procedure SaveBtn;
    procedure SaveIni;

    procedure ArrangeButtons;
    procedure ArrangeScrolls;
    procedure ArrangeGroupMenu;
    procedure ArrangePluginMenu;
    procedure BeginUpdate;
    procedure EndUpdate;

    procedure ResizeDragBar;
    procedure UserMoved;
    procedure SizeCheck;
    procedure EnabledCheckScrolls;
    procedure CurBtnClick;

    function GetLockBtnEdit(ShowWarning: Boolean): Boolean;
    function GetLockBtnFolder(ShowWarning: Boolean): Boolean;
    function GetLockPadProperty(ShowWarning: Boolean): Boolean;
  end;

implementation

uses
  Main, SetPads, Option, BtnEdit, About, BtnTitle, ComLine;

{$R *.DFM}


var
  DragButtonGroup: TButtonGroup;
  DragButtons: TButtonGroup;

// CreateParams
procedure TfrmPad.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style:=Params.Style or WS_THICKFRAME;
  Params.ExStyle := Params.ExStyle or WS_EX_TOOLWINDOW;
  Params.WndParent := GetDesktopWindow;
end;

// �t�H�[���͂���
procedure TfrmPad.FormCreate(Sender: TObject);
var
  i: Integer;
  NonClientMetrics: TNonClientMetrics;
begin
  SetClassLong(Handle, GCL_HICON, LoadIcon(hInstance, 'MAINICON'));

  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0);
  pbDragBar.Font.Handle := CreateFontIndirect(NonClientMetrics.lfCaptionFont);

  FButtonGroups := TButtonGroups.Create;
  FButtonArrangement := TButtonArrangement.Create;
  FButtonArrangement.Owner := Self;
  FButtonArrangement.OnArranged := ButtonArranged;

  FfrmPadTab := TfrmPadTab.Create(nil);
  FfrmPadTab.frmPad := Self;

  pnlDragBar.DoubleBuffered := True;
//  pnlButtons.DoubleBuffered := True;
  pnlButtons.Left := 0;
  pnlButtons.Top := 0;

  BeginUpdate;

  // �X�N���[���{�^���̔z�u
  for i := 0 to 3 do
  begin
    btnScrolls[i] := TSLScrollButton.Create(Self);
    btnScrolls[i].Parent := pnlScrollBar;
    btnScrolls[i].Vertical := True;
    btnScrolls[i].OnClick := btnScrollsClick;
    btnScrolls[i].OnMouseDown := btnScrollsMouseDown;
    btnScrolls[i].OnMouseEnter := btnScrollsMouseEnter;
    btnScrolls[i].OnMouseLeave := btnScrollsMouseLeave;
    btnScrolls[i].Tag := i;
    btnScrolls[i].Visible := True;
  end;
  btnScrolls[0].Kind := skGUp;
  btnScrolls[1].Kind := skUp;
  btnScrolls[1].Repeating := True;
  btnScrolls[1].RepeatDelay := 400;
  btnScrolls[1].RepeatInterval := 50;
  btnScrolls[2].Kind := skDown;
  btnScrolls[2].Repeating := True;
  btnScrolls[2].RepeatDelay := 400;
  btnScrolls[2].RepeatInterval := 50;
  btnScrolls[3].Kind := skGDown;

  Left := 0;
  Top := 0;

  ID := 0;
  Cols := 4;
  Rows := 3;
  ButtonGroup := nil;
  GroupIndex := -1;
  ScrollBar := 3;
  ScrollSize := 17;
  ScrollBtn := True;
  GroupBtn := True;
  BtnVertical := False;
  BtnFocusColor := clHighlight;
  BtnTransparent := False;
  BtnSelTransparent := False;
  BtnSmallIcon := False;
  BtnSquare := True;
  BtnWidth := 32;
  BtnHeight := 32;
  BtnCaption := 0;
  BtnColor := clBtnFace;

  ButtonIndex := 0;
  TopLineIndex := 0;

//  PropertyPageNo := 0;
  TopMost := True;
  SmoothScroll := True;
  Hotkey := 0;
  DropAction := DA_ADDHERE;
  DblClickAction := CA_GRPCHANGE;
  BackColor := clAppWorkSpace;
  WallPaper := '';
  DragBar := 1;
  GroupName := True;
  DragBarSize := 17;
  HideAuto := True;
  HideSmooth := True;
  HideMouseCheck := True;
  HideVertical := False;
  HideGroupName := True;
  HideSize := 2;
  ShowDelay := 100;
  HideDelay := 400;
  HideColor := clInactiveCaption;
  SkinPlugin := nil;

  Foreground := False;
  MouseEntered := False;
  FStickPositions := [];

  UserMoved;

  DropEnabled := True;

  ArrangePluginMenu;
end;

// �t�H�[���I���
procedure TfrmPad.FormDestroy(Sender: TObject);
begin
  FButtonArrangement.Clear;
  DropEnabled := False;
  FButtonGroups.Free;
  FButtonArrangement.Free;
  FfrmPadTab.Release;
end;

// ������
procedure TfrmPad.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
  FCurrentColBack := FButtonArrangement.CurrentCol;
  SizeCheck;
  UserMoved;
end;

// ����
procedure TfrmPad.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  if (Pads = nil) or Pads.Destroying then
  begin
    Exit;
  end
  else if Pads.Count > 1 then
  begin
    Action := caNone;
  end
  else if Pads.Count = 1 then
  begin
    Action := caNone;
    frmMain.Close;
  end;

end;

procedure TfrmPad.Assign(Source: TPersistent);
var
  SourcePad: TfrmPad;
begin
  if Source is TfrmPad then
    SourcePad := Source as TfrmPad
  else
    Exit;

  FButtonGroups.Assign(SourcePad.FButtonGroups);

  Cols := SourcePad.Cols;
  Rows := SourcePad.Rows;
  GroupIndex := SourcePad.GroupIndex;
  ScrollBar := SourcePad.ScrollBar;
  ScrollSize := SourcePad.ScrollSize;
  ScrollBtn := SourcePad.ScrollBtn;
  GroupBtn := SourcePad.GroupBtn;
  BtnVertical := SourcePad.BtnVertical;
  BtnFocusColor := SourcePad.BtnFocusColor;
  BtnTransparent := SourcePad.BtnTransparent;
  BtnSelTransparent := SourcePad.BtnSelTransparent;
  BtnSmallIcon := SourcePad.BtnSmallIcon;
  BtnSquare := SourcePad.BtnSquare;
  BtnWidth := SourcePad.BtnWidth;
  BtnHeight := SourcePad.BtnHeight;
  BtnCaption := SourcePad.BtnCaption;
  BtnColor := SourcePad.BtnColor;

  ButtonIndex := SourcePad.ButtonIndex;
  TopLineIndex := SourcePad.TopLineIndex;

//  PropertyPageNo := SourcePad.PropertyPageNo;
  TopMost := SourcePad.TopMost;
  SmoothScroll := SourcePad.SmoothScroll;
  Hotkey := SourcePad.Hotkey;
  DropAction := SourcePad.DropAction;
  DblClickAction := SourcePad.DblClickAction;
  BackColor := SourcePad.BackColor;
  WallPaper := SourcePad.WallPaper;
  DragBar := SourcePad.DragBar;
  GroupName := SourcePad.GroupName;
  DragBarSize := SourcePad.DragBarSize;
  HideAuto := SourcePad.HideAuto;
  HideSmooth := SourcePad.HideSmooth;
  HideMouseCheck := SourcePad.HideMouseCheck;
  HideVertical := SourcePad.HideVertical;
  HideGroupName := SourcePad.HideGroupName;
  HideSize := SourcePad.HideSize;
  ShowDelay := SourcePad.ShowDelay;
  HideDelay := SourcePad.HideDelay;
  HideColor := SourcePad.HideColor;
  SkinPlugin := SourcePad.SkinPlugin;
  Left := SourcePad.Left + 20;
  Top := SourcePad.Top + 20;

  UserMoved;
end;

// �{�^���t�@�C���ǂݍ���
procedure TfrmPad.LoadBtn(FileName: TFileName);
begin
  FButtonGroups.Load(FileName);
  FBtnFileName := FileName;
end;

// �ݒ�t�@�C���ǂݍ���
procedure TfrmPad.LoadIni(FileName: TFileName);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FileName);
  try
    ID := Ini.ReadInteger(IS_GENERAL, 'ID', 0);
    Cols := Ini.ReadInteger(IS_PADOPTIONS, 'Cols', Cols);
    Rows := Ini.ReadInteger(IS_PADOPTIONS, 'Rows', Rows);
    GroupIndex := Ini.ReadInteger(IS_PADOPTIONS, 'GroupIndex', GroupIndex);
    ScrollBar := Ini.ReadInteger(IS_PADOPTIONS, 'ScrollBar', ScrollBar);
    ScrollSize := Ini.ReadInteger(IS_PADOPTIONS, 'ScrollSize', ScrollSize);
    ScrollBtn := Ini.ReadBool(IS_PADOPTIONS, 'ScrollBtn', ScrollBtn);
    GroupBtn := Ini.ReadBool(IS_PADOPTIONS, 'GroupBtn', GroupBtn);
    BtnVertical := Ini.ReadBool(IS_PADOPTIONS, 'BtnVertical', BtnVertical);
    BtnFocusColor := Ini.ReadInteger(IS_PADOPTIONS, 'BtnFocusColor', BtnFocusColor);
    BtnTransparent := Ini.ReadBool(IS_PADOPTIONS, 'BtnTransparent', BtnTransparent);
    BtnSelTransparent := Ini.ReadBool(IS_PADOPTIONS, 'BtnSelTransparent', BtnSelTransparent);
    BtnSmallIcon := Ini.ReadBool(IS_PADOPTIONS, 'BtnSmallIcon', BtnSmallIcon);
    BtnSquare := Ini.ReadBool(IS_PADOPTIONS, 'BtnSquare', BtnSquare);
    BtnWidth := Ini.ReadInteger(IS_PADOPTIONS, 'BtnWidth', BtnWidth);
    BtnHeight := Ini.ReadInteger(IS_PADOPTIONS, 'BtnHeight', BtnHeight);
    BtnCaption := Ini.ReadInteger(IS_PADOPTIONS, 'BtnCaption', BtnCaption);
    BtnColor := Ini.ReadInteger(IS_PADOPTIONS, 'BtnColor', BtnColor);

    ButtonIndex := Ini.ReadInteger(IS_PADOPTIONS, 'ButtonIndex', ButtonIndex);
    TopLineIndex := Ini.ReadInteger(IS_PADOPTIONS, 'TopLineIndex', TopLineIndex);

//    PropertyPageNo := Ini.ReadInteger(IS_PADOPTIONS, 'PropertyPageNo', PropertyPageNo);
    TopMost := Ini.ReadBool(IS_PADOPTIONS, 'TopMost', TopMost);
    SmoothScroll := Ini.ReadBool(IS_PADOPTIONS, 'SmoothScroll', SmoothScroll);
    Hotkey := Ini.ReadInteger(IS_PADOPTIONS, 'Hotkey', Hotkey);
    DropAction := Ini.ReadInteger(IS_PADOPTIONS, 'DropAction', DropAction);
    DblClickAction := Ini.ReadInteger(IS_PADOPTIONS, 'DblClickAction', DblClickAction);
    BackColor := Ini.ReadInteger(IS_PADOPTIONS, 'BackColor', BackColor);
    WallPaper := Ini.ReadString(IS_PADOPTIONS, 'WallPaper', WallPaper);
    DragBar := Ini.ReadInteger(IS_PADOPTIONS, 'DragBar', DragBar);
    GroupName := Ini.ReadBool(IS_PADOPTIONS, 'GroupName', GroupName);
    DragBarSize := Ini.ReadInteger(IS_PADOPTIONS, 'DragBarSize', DragBarSize);
    HideAuto := Ini.ReadBool(IS_PADOPTIONS, 'HideAuto', HideAuto);
    HideSmooth := Ini.ReadBool(IS_PADOPTIONS, 'HideSmooth', HideSmooth);
    HideMouseCheck := Ini.ReadBool(IS_PADOPTIONS, 'HideMouseCheck', HideMouseCheck);
    HideVertical := Ini.ReadBool(IS_PADOPTIONS, 'HideVertical', HideVertical);
    HideGroupName := Ini.ReadBool(IS_PADOPTIONS, 'HideGroupName', HideGroupName);
    HideSize := Ini.ReadInteger(IS_PADOPTIONS, 'HideSize', HideSize);
    ShowDelay := Ini.ReadInteger(IS_PADOPTIONS, 'ShowDelay', ShowDelay);
    HideDelay := Ini.ReadInteger(IS_PADOPTIONS, 'HideDelay', HideDelay);
    HideColor := Ini.ReadInteger(IS_PADOPTIONS, 'HideColor', HideColor);
    SkinPlugin := Plugins.FindPlugin(Ini.ReadString(IS_PADOPTIONS, 'SkinName', ''));

    // ���j�^�[�ԍ�������Ȃ��悤�ɍŏ��l
    Width := 1;
    Height := 1;

    Left := Ini.ReadInteger(IS_PADOPTIONS, 'Left', Left);
    Top := Ini.ReadInteger(IS_PADOPTIONS, 'Top', Top);

    SizeCheck;
    UserMoved;

  finally
    Ini.Free;
  end;
end;

// �{�^���t�@�C����������
procedure TfrmPad.SaveBtn;
begin
  FButtonGroups.Save(BtnFileName);
end;

// �ݒ�t�@�C����������
procedure TfrmPad.SaveIni;
var
  Ini: TIniFile;
begin
  if not UserIniReadOnly then
  begin
    Ini := TIniFile.Create(ChangeFileExt(BtnFileName, '.ini'));
    try
      Ini.WriteInteger(IS_GENERAL, 'ID', ID);

      Ini.WriteInteger(IS_PADOPTIONS, 'Left', Left);
      Ini.WriteInteger(IS_PADOPTIONS, 'Top', Top);
      Ini.WriteInteger(IS_PADOPTIONS, 'Cols', Cols);
      Ini.WriteInteger(IS_PADOPTIONS, 'Rows', Rows);
      Ini.WriteInteger(IS_PADOPTIONS, 'GroupIndex', GroupIndex);
      Ini.WriteInteger(IS_PADOPTIONS, 'ScrollBar', ScrollBar);
      Ini.WriteBool(IS_PADOPTIONS, 'ScrollBtn', ScrollBtn);
      Ini.WriteBool(IS_PADOPTIONS, 'GroupBtn', GroupBtn);
      Ini.WriteInteger(IS_PADOPTIONS, 'ScrollSize', ScrollSize);
      Ini.WriteBool(IS_PADOPTIONS, 'BtnVertical', BtnVertical);
      Ini.WriteInteger(IS_PADOPTIONS, 'BtnFocusColor', BtnFocusColor);
      Ini.WriteBool(IS_PADOPTIONS, 'BtnTransparent', BtnTransparent);
      Ini.WriteBool(IS_PADOPTIONS, 'BtnSelTransparent', BtnSelTransparent);
      Ini.WriteBool(IS_PADOPTIONS, 'BtnSmallIcon', BtnSmallIcon);
      Ini.WriteBool(IS_PADOPTIONS, 'BtnSquare', BtnSquare);
      Ini.WriteInteger(IS_PADOPTIONS, 'BtnWidth', BtnWidth);
      Ini.WriteInteger(IS_PADOPTIONS, 'BtnHeight', BtnHeight);
      Ini.WriteInteger(IS_PADOPTIONS, 'BtnCaption', BtnCaption);
      Ini.WriteInteger(IS_PADOPTIONS, 'BtnColor', BtnColor);

      Ini.WriteInteger(IS_PADOPTIONS, 'TopLineIndex', TopLineIndex);
      Ini.WriteInteger(IS_PADOPTIONS, 'ButtonIndex', ButtonIndex);

  //    Ini.WriteInteger(IS_PADOPTIONS, 'PropertyPageNo', PropertyPageNo);
      Ini.WriteBool(IS_PADOPTIONS, 'TopMost', TopMost);
      Ini.WriteBool(IS_PADOPTIONS, 'SmoothScroll', SmoothScroll);
      Ini.WriteInteger(IS_PADOPTIONS, 'Hotkey', Hotkey);
      Ini.WriteInteger(IS_PADOPTIONS, 'DropAction', DropAction);
      Ini.WriteInteger(IS_PADOPTIONS, 'DblClickAction', DblClickAction);
      Ini.WriteInteger(IS_PADOPTIONS, 'BackColor', BackColor);
      Ini.WriteString(IS_PADOPTIONS, 'WallPaper', WallPaper);
      Ini.WriteInteger(IS_PADOPTIONS, 'DragBar', DragBar);
      Ini.WriteBool(IS_PADOPTIONS, 'GroupName', GroupName);
      Ini.WriteInteger(IS_PADOPTIONS, 'DragBarSize', DragBarSize);
      Ini.WriteBool(IS_PADOPTIONS, 'HideAuto', HideAuto);
      Ini.WriteBool(IS_PADOPTIONS, 'HideSmooth', HideSmooth);
      Ini.WriteBool(IS_PADOPTIONS, 'HideMouseCheck', HideMouseCheck);
      Ini.WriteBool(IS_PADOPTIONS, 'HideVertical', HideVertical);
      Ini.WriteBool(IS_PADOPTIONS, 'HideGroupName', HideGroupName);
      Ini.WriteInteger(IS_PADOPTIONS, 'HideSize', HideSize);
      Ini.WriteInteger(IS_PADOPTIONS, 'ShowDelay', ShowDelay);
      Ini.WriteInteger(IS_PADOPTIONS, 'HideDelay', HideDelay);
      Ini.WriteInteger(IS_PADOPTIONS, 'HideColor', HideColor);
      if SkinPlugin = nil then
        Ini.WriteString(IS_PADOPTIONS, 'SkinName', '')
      else
        Ini.WriteString(IS_PADOPTIONS, 'SkinName', SkinPlugin.Name);
      Ini.UpdateFile;
    finally
      Ini.Free;
    end;
  end;
end;

// ����Z�b�g
procedure TfrmPad.SetCols(Value: Integer);
var
  Top: Integer;
  CurrentViewRowBack: Integer;
begin
  if Value < 1 then
    Value := 1;
  if Value = FCols then
    Exit;
  FCols := Value;

  // �c�ɕ���
  if BtnVertical then
  begin
    Top := TopLineIndex;
    if FButtonArrangement.CurrentRow >= Top + Cols then
      Top := FButtonArrangement.CurrentRow - Cols + 1;
    if Top > FButtonArrangement.Rows - Cols then
      Top := FButtonArrangement.Rows - Cols;
    BeginUpdate;
    try
      TopLineIndex := Top;
      ArrangeButtons;
    finally
      EndUpdate;
    end;
  end
  else
  begin
    CurrentViewRowBack := FCurrentViewRow;
    BeginUpdate;
    try
      FButtonArrangement.Cols := Cols;
      TopLineIndex := FButtonArrangement.CurrentRow - CurrentViewRowBack;
      ArrangeButtons;
    finally
      EndUpdate;
    end;
  end;
end;

// �s�����Z�b�g
procedure TfrmPad.SetRows(Value: Integer);
var
  Top: Integer;
  CurrentViewRowBack: Integer;
begin
  if Value < 1 then
    Value := 1;
  if Value = FRows then
    Exit;
  FRows := Value;

  if BtnVertical then
  begin
    CurrentViewRowBack := FCurrentViewRow;
    BeginUpdate;
    try
      FButtonArrangement.Cols := Rows;
      TopLineIndex := FButtonArrangement.CurrentRow - CurrentViewRowBack;
      ArrangeButtons;
    finally
      EndUpdate;
    end;
  end
  else
  begin
    Top := TopLineIndex;
    if FButtonArrangement.CurrentRow >= Top + Rows then
      Top := FButtonArrangement.CurrentRow - Rows + 1;
    if Top > FButtonArrangement.Rows - Rows then
       Top := FButtonArrangement.Rows - Rows;
    BeginUpdate;
    try
      TopLineIndex := Top;
      ArrangeButtons;
    finally
      EndUpdate;
    end;
  end;
end;

// �ŏ��̍s���Z�b�g
procedure TfrmPad.SetTopLineIndex(Value: Integer);
begin
  if FBtnVertical then
  begin
    if Value > FButtonArrangement.Rows - Cols then
      Value := FButtonArrangement.Rows - Cols
  end
  else
  begin
    if Value > FButtonArrangement.Rows - Rows then
      Value := FButtonArrangement.Rows - Rows;
  end;

  if Value < 0 then
    Value := 0;

  FTopLineIndex := Value;

  ScrollButtons(SmoothScroll);

  EnabledCheckScrolls;
end;

// �J�����g�{�^���̃C���f�b�N�X�擾
function TfrmPad.GetButtonIndex: Integer;
begin
  Result := FButtonArrangement.CurrentIndex;
end;

// �J�����g�{�^���̃C���f�b�N�X�w��
procedure TfrmPad.SetButtonIndex(Value: Integer);
begin
  FButtonArrangement.CurrentIndex := Value;
  FCurrentViewRow := FButtonArrangement.CurrentRow - FTopLineIndex;
  CurrentMakeVisible;
end;

// ��Ɏ�O�ɕ\��
procedure TfrmPad.SetTopMost(Value: Boolean);
begin
  FTopMost := Value;

  if Value and (FDialogBox = nil) then
  begin
    SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or
      SWP_NOSIZE or SWP_NOACTIVATE);
    SetWindowPos(frmPadTab.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or
      SWP_NOSIZE or SWP_NOACTIVATE);
  end
  else
  begin
    SetWindowPos(Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or
      SWP_NOSIZE or SWP_NOACTIVATE);
    SetWindowPos(frmPadTab.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE or
      SWP_NOSIZE or SWP_NOACTIVATE);
  end;
end;

// �z�b�g�L�[
procedure TfrmPad.SetHotkey(Value: Word);
begin
  FHotkey := Value;

  if FDialogBox = nil then
  begin
    if frmPadTab.Hid then
      SendMessage(frmPadTab.Handle, WM_SETHOTKEY, FHotkey, 0)
    else
      SendMessage(Handle, WM_SETHOTKEY, FHotkey, 0);
  end
  else
  begin
    SendMessage(frmPadTab.Handle, WM_SETHOTKEY, 0, 0);
    SendMessage(Handle, WM_SETHOTKEY, 0, 0);
  end;
end;

// �w�i�F���擾
function TfrmPad.GetBackColor: Integer;
begin
  Result := Color;
end;

// �w�i�F���Z�b�g
procedure TfrmPad.SetBackColor(Value: Integer);
begin
  Color := Value;
end;

// �ǎ��̕ύX
procedure TfrmPad.SetWallPaper(Value: string);
begin
  FWallPaper := Value;

  FWallPaperBitmap.Free;
  FWallPaperBitmap := nil;

  if FileExists(FWallPaper) then
  begin
    FWallPaperBitmap := TBitmap.Create;
    try
      FWallPaperBitmap.LoadFromFile(FWallPaper);
    except
      FWallPaper := '';
      FWallPaperBitmap.Free;
      FWallPaperBitmap := nil;
    end;
  end;
  pbWallPaper1.Visible := (FWallPaperBitmap <> nil) or (FSkinPlugin <> nil);
  pbWallPaper2.Visible := pbWallPaper1.Visible;
  pbWallPaper1.Refresh;
  pbWallPaper2.Refresh;
end;

// �X�L���v���O�C��
procedure TfrmPad.SetSkinPlugin(Value: TPlugin);
begin
  FSkinPlugin := Value;
  if (FSkinPlugin <> nil) and (@FSkinPlugin.SLXBeginSkin <> nil) then
    FSkinPlugin.SLXBeginSkin(Handle);
  pbWallPaper1.Visible := (FWallPaperBitmap <> nil) or (FSkinPlugin <> nil);
  pbWallPaper2.Visible := pbWallPaper1.Visible;
  pbWallPaper1.Refresh;
  pbWallPaper2.Refresh;

  ArrangeScrolls;
  ArrangeButtons;
end;


// �h���b�O�o�[�̃T�C�Y�ύX
procedure TfrmPad.ResizeDragBar;
var
  LogFont: TLogFont;
  NewFont, OldFont: HFont;
  NewSize: Integer;
begin
  if FGroupName then
  begin
    GetObject(Canvas.Font.Handle, SizeOf(LogFont), @LogFont);
    if pnlDragBar.Align = alLeft then
      LogFont.lfEscapement := 900
    else if pnlDragBar.Align = alRight then
      LogFont.lfEscapement := 2700
    else
      LogFont.lfEscapement := 0;

    NewFont := CreateFontIndirect(LogFont);
    try
      OldFont := SelectObject(pbDragBar.Canvas.Handle, NewFont);
      NewSize := Abs(pbDragBar.Font.Height) + 2;
      NewFont := SelectObject(pbDragBar.Canvas.Handle, OldFont);
    finally
      DeleteObject(NewFont);
    end;
  end
  else
    NewSize := FDragBarSize;

  if pnlDragBar.Align in [alLeft, alRight] then
    pnlDragBar.Width := NewSize
  else
    pnlDragBar.Height := NewSize;
end;

// �h���b�O�o�[�̕ύX
procedure TfrmPad.SetDragBar(Value: Integer);
begin
  if Value < 0 then
    Value := 0
  else if Value > 4 then
    Value := 4;

  if FDragBar = Value then
    Exit;

  FDragBar := Value;

  case Value of
    DS_NONE: pnlDragBar.Visible := False;
    DS_LEFT: pnlDragBar.Align := alLeft;
    DS_TOP: pnlDragBar.Align := alTop;
    DS_RIGHT: pnlDragBar.Align := alRight;
    DS_BOTTOM: pnlDragBar.Align := alBottom;
  end;

  if Value > 0 then
  begin
    ResizeDragBar;
    pnlDragBar.Visible := True;
  end;
  pnlDragBar.Refresh;

  SizeCheck;
end;

// �{�^���O���[�v����\��
procedure TfrmPad.SetGroupName(Value: Boolean);
begin
  if FGroupName = Value then
    Exit;

  FGroupName := Value;

  ResizeDragBar;
  pbDragBar.Refresh;

  SizeCheck;
end;

// �h���b�O�o�[�̃T�C�Y
procedure TfrmPad.SetDragBarSize(Value: Integer);
begin
  if FDragBarSize = Value then
    Exit;

  FDragBarSize := Value;

  ResizeDragBar;
  SizeCheck;
end;

// �X�N���[���{�^���̕ύX
procedure TfrmPad.SetScrollBar(Value: Integer);
begin
  if Value < 0 then
    Value := 0
  else if Value > 4 then
    Value := 4;

  if FScrollBar = Value then
    Exit;

  FScrollBar := Value;

  case Value of
    DS_NONE: pnlScrollBar.Visible := False;
    DS_LEFT: pnlScrollBar.Align := alLeft;
    DS_TOP: pnlScrollBar.Align := alTop;
    DS_RIGHT: pnlScrollBar.Align := alRight;
    DS_BOTTOM: pnlScrollBar.Align := alBottom;
  end;
  if Value > 0 then
    pnlScrollBar.Visible := True;

  SizeCheck;
end;

// �X�N���[���{�^���̕\��
procedure TfrmPad.SetScrollBtn(Value: Boolean);
begin
  if FScrollBtn = Value then
    Exit;

  FScrollBtn := Value;
  pnlScrollBar.Enabled := FScrollBtn or FGroupBtn;
  ArrangeScrolls;
end;

// �{�^���O���[�v�؂�ւ��{�^���̕\��
procedure TfrmPad.SetGroupBtn(Value: Boolean);
begin
  if FGroupBtn = Value then
    Exit;

  FGroupBtn := Value;
  pnlScrollBar.Enabled := FScrollBtn or FGroupBtn;
  ArrangeScrolls;
end;

// �X�N���[���{�^���̃T�C�Y
procedure TfrmPad.SetScrollSize(Value: Integer);
begin
  if FScrollSize = Value then
    Exit;

  FScrollSize := Value;

  if pnlScrollBar.Align in [alRight, alLeft] then
    pnlScrollBar.Width := FScrollSize
  else
    pnlScrollBar.Height := FScrollSize;

  SizeCheck;
end;

// �{�^���͏c�����ɔz�u����
procedure TfrmPad.SetBtnVertical(Value: Boolean);
begin
  if FBtnVertical = Value then
    Exit;

  FBtnVertical := Value;

  if BtnVertical then
    FButtonArrangement.Cols := Rows
  else
    FButtonArrangement.Cols := Cols;

  if Rows = Cols then
    FButtonArrangement.Arrange;

  ArrangeScrolls;
  ArrangeButtons;
  EnabledCheckScrolls;
end;

// �J�����g�{�^���̐F
procedure TfrmPad.SetBtnFocusColor(Value: TColor);
begin
  if FBtnFocusColor = Value then
    Exit;

  FBtnFocusColor := Value;

  ArrangeScrolls;
  ArrangeButtons;
end;

// �{�^���𓧖��ɂ���
procedure TfrmPad.SetBtnTransparent(Value: Boolean);
begin
  if FBtnTransparent = Value then
    Exit;

  FBtnTransparent := Value;

  ArrangeScrolls;
  ArrangeButtons;
end;

// �J�����g�{�^���𔼓����ɂ���
procedure TfrmPad.SetBtnSelTransparent(Value: Boolean);
begin
  if FBtnSelTransparent = Value then
    Exit;

  FBtnSelTransparent := Value;

  ArrangeScrolls;
  ArrangeButtons;
end;

// �������A�C�R�����g��
procedure TfrmPad.SetBtnSmallIcon(Value: Boolean);
begin
  if FBtnSmallIcon = Value then
    Exit;

  FBtnSmallIcon := Value;

  ArrangeButtons;
end;

// �{�^���̕��ƍ����𓝈�
procedure TfrmPad.SetBtnSquare(Value: Boolean);
begin
  FBtnSquare := Value;
  if FBtnSquare then
    BtnHeight := BtnWidth;
end;


// �{�^���T�C�Y�̕ύX
procedure TfrmPad.SetBtnWidth(Value: Integer);
begin
  if Value < 8 then
    Value := 8
  else if Value > 128 then
    Value := 128;

  if FBtnWidth = Value then
    Exit;

  FBtnWidth := Value;
  if FBtnSquare then
    BtnHeight := FBtnWidth;
    
  SizeCheck;
  ArrangeButtons;
end;

// �{�^���T�C�Y�̕ύX
procedure TfrmPad.SetBtnHeight(Value: Integer);
begin
  if Value < 8 then
    Value := 8
  else if Value > 128 then
    Value := 128;

  if FBtnHeight = Value then
    Exit;

  if FBtnSquare then
    FBtnHeight := BtnWidth
  else
    FBtnHeight := Value;

  SizeCheck;
  ArrangeButtons;
end;

// �{�^���̘g�̃T�C�Y
function TfrmPad.GetBtnFrameWidth: Integer;
begin
  Result := FBtnWidth + BUTTON_MARGIN;
end;

function TfrmPad.GetBtnFrameHeight: Integer;
begin
  Result := FBtnHeight + BUTTON_MARGIN;
end;

// �{�^���̃L���v�V�����\��
procedure TfrmPad.SetBtnCaption(Value: Integer);
begin
  if FBtnCaption = Value then
    Exit;
  FBtnCaption := Value;

  ArrangeButtons;
end;

// �{�^���̐F
procedure TfrmPad.SetBtnColor(Value: TColor);
begin
  if FBtnColor = Value then
    Exit;
  FBtnColor := Value;

  ArrangeScrolls;
  ArrangeButtons;
end;

// �R���e�L�X�g���j���[�̕\��
procedure TfrmPad.FormContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  Handled := True;
  if GetKeyState(VK_LBUTTON) >= 0 then
  begin
    MousePos := ClientToScreen(MousePos);
    popMain.Popup(MousePos.x, MousePos.y);
  end;
end;


// �L�[�_�E��
procedure TfrmPad.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i: Integer;
begin
  if not Enabled then
    Exit;

  HideTitle;
  Update;
  if Shift = [] then
  begin
    // ��
    if (not FBtnVertical and (Key=VK_UP)) or
           (FBtnVertical and (Key=VK_LEFT)) then
      MoveCurrent(ndUp)

    // ��
    else if (not FBtnVertical and (Key=VK_DOWN)) or
                (FBtnVertical and (Key=VK_RIGHT)) then
      MoveCurrent(ndDown)

    // ��
    else if (not FBtnVertical and (Key=VK_LEFT)) or
                (FBtnVertical and (Key=VK_UP)) then
      MoveCurrent(ndLeft)

    // �E
    else if (not FBtnVertical and (Key=VK_RIGHT)) or
                (FBtnVertical and (Key=VK_DOWN)) then
      MoveCurrent(ndRight)

    // PageUp
    else if Key = VK_PRIOR then
      MoveCurrent(ndPageUp)

    // PageDown
    else if Key = VK_NEXT then
      MoveCurrent(ndPageDown)

    // Home
    else if Key = VK_HOME then
      MoveCurrent(ndHome)

    // End
    else if Key = VK_END then
      MoveCurrent(ndEnd);

  end
  else if Shift = [ssCtrl] then
  begin
    // Ctrl + Home
    if Key = VK_HOME then
      MoveCurrent(ndCHome)

    // Ctrl + End
    else if Key = VK_END then
      MoveCurrent(ndCEnd)

    // Ctrl + PageUp
    else if (Key = VK_PRIOR) and (GroupIndex > 0) then
      GroupIndex := GroupIndex - 1

    // Ctrl + PageDown
    else if (Key = VK_NEXT) and (GroupIndex < FButtonGroups.Count - 1) then
      GroupIndex := GroupIndex + 1

    // Ctrl + Tab
    else if Key = VK_TAB then
    begin
      Pads.CtrlTabActivate := True;
      try
        i := Pads.IndexOf(Self);
        while True do
        begin
          Inc(i);
          if i >= Pads.Count then
            i := 0;
          if Pads[i].Enabled then
          begin
            Pads[i].Show;
            if Pads[i].frmPadTab.Hid then
              Pads[i].frmPadTab.MoveShow;
            Break;
          end;
          if Pads[i] = Self then
            Break;
        end;

      finally
        Pads.CtrlTabActivate := False;
      end;
    end;
  end
  else if Shift = [ssCtrl, ssShift] then
  begin
    // Ctrl + Shift + Tab
    if Key = VK_TAB then
    begin
      Pads.CtrlTabActivate := True;
      try
        i := Pads.IndexOf(Self);
        while True do
        begin
          Dec(i);
          if i < 0 then
            i := Pads.Count - 1;
          if Pads[i].Enabled then
          begin
            Pads[i].Show;
            if Pads[i].frmPadTab.Hid then
              Pads[i].frmPadTab.MoveShow;
            Break;
          end;
          if Pads[i] = Self then
            Break;
        end;
      finally
        Pads.CtrlTabActivate := False;
      end;
    end;

  end;
end;


// �L�[�v���X
procedure TfrmPad.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not Enabled then
    Exit;


  if Key = #13 then
  begin
    CurBtnClick;
  end

  else if GetKeyState(VK_CONTROL) >= 0 then
  begin

    if (Key <> ' ') or (FISearch <> '') then
    begin
      FISearch := FISearch + Key;

      if FISearchTimer <> nil then
        FISearchTimer.Enabled := False
      else
      begin
        FISearchTimer := TTimer.Create(Self);
        FISearchTimer.OnTimer := ISearchTimerTimer;
      end;
      FISearchTimer.Interval := 1;
      FISearchTimer.Enabled := True;
    end;

  end;
end;

// �L�[�A�b�v
procedure TfrmPad.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Item: TButtonItem;
  Pos: TPoint;
begin
  if not Enabled then
    Exit;

  if Shift = [] then
  begin
    case Key of
      VK_SPACE:
      begin
        if FISearch = '' then
        begin
          Pos := ClientToScreen(Point(0, 0));
          Item := FButtonArrangement.CurrentItem;
          if Item <> nil then
            if Item.SLButton <> nil then
            begin
              Pos.x := Item.SLButton.Width div 2;
              Pos.y := Item.SLButton.Height div 2;
              Pos := Item.SLButton.ClientToScreen(Pos);
            end;

          if PtInRect(ClientRect, ScreenToClient(Pos)) then
            popMain.Popup(Pos.x, Pos.y);
        end;
      end;
    else
      CurrentTitle;
    end;
  end;

  if Key = VK_CONTROL then
  begin
    Pads.Remove(Self);
    Pads.Insert(0, Self);
  end;
end;

// �C���N�������^���T�[�`�̃f�B���C
procedure TfrmPad.ISearchTimerTimer(Sender: TObject);
var
  SearchStr, BtnName: string;
  Item: TButtonItem;
  i: Integer;
begin
  if (FISearchTimer.Interval = 1) and (FButtonGroup <> nil) then
  begin
    SearchStr := AnsiUpperCase(FISearch);
    if (Length(SearchStr) > 0) and (FButtonGroup.Count > 0) and (ButtonIndex >= 0) then
    begin
      // ��������������
      i := 2;
      while i <= Length(SearchStr) do
      begin
        if SearchStr[i - 1] <> SearchStr[i] then
          Break;
        Inc(i);
      end;
      if i > Length(SearchStr) then
      begin
        SearchStr := SearchStr[1];
        i := ButtonIndex + 1;
        if i >= FButtonGroup.Count then
          i := 0;
      end
      else
        i := ButtonIndex;

      while True do
      begin
        BtnName := AnsiUpperCase(FButtonGroup[i].Name);
        if SearchStr = Copy(BtnName, 1, Length(SearchStr)) then
        begin
          ButtonIndex := i;
          FCurrentColBack := FButtonArrangement.CurrentCol;
          Item := FButtonArrangement.CurrentItem;
          if Item <> nil then
            if Item.SLButton <> nil then
              Item.SLButton.MouseEntered := True;
          Break;
        end;

        Inc(i);
        if i >= FButtonGroup.Count then
          i := 0;

        // ������Ȃ�
        if i = ButtonIndex then
        begin
          Beep;
          Break;
        end;
      end;

    end;
    FISearchTimer.Interval := 1000;
  end
  else
  begin
    FISearchTimer.Free;
    FISearchTimer := nil;
    FISearch := '';
  end;
end;


// �J�����g�{�^���̈ړ�
procedure TfrmPad.MoveCurrent(NextDirection: TNextDirection);
var
  Col, Row: Integer;
  PageUpDownCount: Integer;
  i: Integer;
  Item, SelItem: TButtonItem;
  ColBackUpdate: Boolean;
begin
  if ButtonIndex = -1 then
    Exit;
  SelItem := nil;
  ColBackUpdate := False;

  case NextDirection of
    ndUp:
    begin
      Col := FCurrentColBack;
      Row := FButtonArrangement.CurrentRow - 1;
      while (Row >= 0) and (SelItem = nil) do
      begin
        i := 0;
        while i < FButtonArrangement.Cols do
        begin
          if (i > Col) and (SelItem <> nil) then
            Break;

          Item := FButtonArrangement[i, Row];
          if Item <> nil then
            if Item.SLButton <> nil then
              SelItem := Item;

          Inc(i);
        end;
        Dec(Row);
      end;
    end;

    ndDown:
    begin
      Col := FCurrentColBack;
      Row := FButtonArrangement.CurrentRow + 1;
      while (Row < FButtonArrangement.Rows) and (SelItem = nil) do
      begin
        i := 0;
        while i < FButtonArrangement.Cols do
        begin
          if (i > Col) and (SelItem <> nil) then
            Break;

          Item := FButtonArrangement[i, Row];
          if Item <> nil then
            if Item.SLButton <> nil then
              SelItem := Item;

          Inc(i);
        end;
        Inc(Row);
      end;
    end;

    ndLeft:
    begin
      Col := FButtonArrangement.CurrentCol;
      Row := FButtonArrangement.CurrentRow;
      while (Row >= 0) and (SelItem = nil) do
      begin
        SelItem := nil;
        while Col > 0 do
        begin
          Dec(Col);
          Item := FButtonArrangement[Col, Row];
          if Item <> nil then
            if Item.SLButton <> nil then
            begin
              SelItem := Item;
              Break;
            end;
        end;
        Col := FButtonArrangement.Cols;
        Dec(Row);
      end;
      ColBackUpdate := True;
    end;

    ndRight:
    begin
      Col := FButtonArrangement.CurrentCol;
      Row := FButtonArrangement.CurrentRow;
      while (Row < FButtonArrangement.Rows) and (SelItem = nil) do
      begin
        while Col < FButtonArrangement.Cols - 1 do
        begin
          Inc(Col);
          Item := FButtonArrangement[Col, Row];
          if Item <> nil then
            if Item.SLButton <> nil then
            begin
              SelItem := Item;
              Break;
            end;
        end;
        Col := -1;
        Inc(Row);
      end;
      ColBackUpdate := True;
    end;

    ndPageUp:
    begin
      Col := FCurrentColBack;
      Row := FButtonArrangement.CurrentRow - 1;
      if FBtnVertical then
        PageUpDownCount := FCols
      else
        PageUpDownCount := FRows;

      while ((Row >= 0) and (SelItem = nil)) or (PageUpDownCount > 0) do
      begin
        i := 0;
        while i < FButtonArrangement.Cols do
        begin
          if (i > Col) and (SelItem <> nil) then
            Break;

          Item := FButtonArrangement[i, Row];
          if Item <> nil then
            if Item.SLButton <> nil then
              SelItem := Item;

          Inc(i);
        end;
        Dec(Row);
        Dec(PageUpDownCount);
      end;
    end;

    ndPageDown:
    begin
      Col := FCurrentColBack;
      Row := FButtonArrangement.CurrentRow + 1;
      if FBtnVertical then
        PageUpDownCount := FCols
      else
        PageUpDownCount := FRows;

      while (Row < FButtonArrangement.Rows) and (SelItem = nil) or (PageUpDownCount > 0) do
      begin
        i := 0;
        while i < FButtonArrangement.Cols do
        begin
          if (i > Col) and (SelItem <> nil) then
            Break;

          Item := FButtonArrangement[i, Row];
          if Item <> nil then
            if Item.SLButton <> nil then
              SelItem := Item;

          Inc(i);
        end;
        Inc(Row);
        Dec(PageUpDownCount);
      end;
    end;

    ndHome:
    begin
      Col := 0;
      Row := FButtonArrangement.CurrentRow;
      SelItem := nil;
      while Col < FButtonArrangement.Cols do
      begin
        Item := FButtonArrangement[Col, Row];
        if Item <> nil then
          if Item.SLButton <> nil then
          begin
            SelItem := Item;
            Break;
          end;
        Inc(Col);
      end;
      ColBackUpdate := True;
    end;

    ndEnd:
    begin
      Col := FButtonArrangement.Cols - 1;
      Row := FButtonArrangement.CurrentRow;
      SelItem := nil;
      while Col >= 0  do
      begin
        Item := FButtonArrangement[Col, Row];
        if Item <> nil then
          if Item.SLButton <> nil then
          begin
            SelItem := Item;
            Break;
          end;
        Dec(Col);
      end;
      ColBackUpdate := True;
    end;

    ndCHome:
    begin
      Row := 0;
      SelItem := nil;
      while (Row < FButtonArrangement.Rows) and (SelItem = nil) do
      begin
        Col := 0;
        while Col < FButtonArrangement.Cols do
        begin
          Item := FButtonArrangement[Col, Row];
          if Item <> nil then
            if Item.SLButton <> nil then
            begin
              SelItem := Item;
              Break;
            end;
          Inc(Col);
        end;
        Inc(Row);
      end;
      ColBackUpdate := True;
    end;

    ndCEnd:
    begin
      Row := FButtonArrangement.Rows - 1;
      SelItem := nil;
      while (Row >= 0) and (SelItem = nil) do
      begin
        Col := FButtonArrangement.Cols - 1;
        while Col >= 0 do
        begin
          Item := FButtonArrangement[Col, Row];
          if Item <> nil then
            if Item.SLButton <> nil then
            begin
              SelItem := Item;
              Break;
            end;
          Dec(Col);
        end;
        Dec(Row);
      end;
      ColBackUpdate := True;
    end;

  end;

  if SelItem <> nil then
  begin
    if SelItem.SLButton <> nil then
      SelItem.SLButton.MouseEntered := True;
    ButtonIndex := FButtonArrangement.IndexOfItem(SelItem);
  end;

  if ColBackUpdate then
    FCurrentColBack := FButtonArrangement.CurrentCol;


end;



// �}�E�X�z�C�[��
procedure TfrmPad.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if not Enabled then
    Exit;

  // ��փz�C�[��
  if WheelDelta > 0 then
  begin
    if (ssMiddle in Shift) or (ssCtrl in Shift) then
    begin
      if GroupIndex > 0 then
        GroupIndex := GroupIndex - 1;
    end
    else
      TopLineIndex := TopLineIndex - 1;
  end
  // ���փz�C�[��
  else
  begin
    if (ssMiddle in Shift) or (ssCtrl in Shift) then
    begin
      if GroupIndex < FButtonGroups.Count - 1 then
        GroupIndex := GroupIndex + 1
    end
    else
      TopLineIndex := TopLineIndex + 1;
  end;
  Update;
end;

// �|�b�v�A�b�v���j���[
procedure TfrmPad.popMainPopup(Sender: TObject);
var
  LockBtnEdit: Boolean;
  LockBtnFolder: Boolean;
  LockPadProperty: Boolean;

  i, j: Integer;
  MenuItem: TMenuItem;
  Plugin: TPlugin;
begin
  for i := 0 to popMain.Items.Count - 1 do
    popMain.Items[i].Enabled := Enabled;
  if not Enabled then
    Exit;

  LockBtnEdit := GetLockBtnEdit(False);
  LockBtnFolder := GetLockBtnFolder(False);
  LockPadProperty := GetLockPadProperty(False);

  popButton.Visible := not LockBtnEdit or not LockBtnFolder;
  popButtonAdd.Enabled := (FButtonGroup <> nil) and not LockBtnEdit;
  popButtonAdd.Visible := not LockBtnEdit;
  popButtonModify.Enabled := (ButtonIndex >= 0) and not LockBtnEdit;
  popButtonModify.Visible := not LockBtnEdit;
  popButtonFolder.Enabled := (ButtonIndex >= 0) and not LockBtnFolder;
  popButtonFolder.Visible := not LockBtnFolder;
  popButtonCut.Enabled := (ButtonIndex >= 0) and not LockBtnEdit;
  popButtonCut.Visible := not LockBtnEdit;
  popButtonCopy.Enabled := (ButtonIndex >= 0) and not LockBtnEdit;
  popButtonCopy.Visible := not LockBtnEdit;
  popButtonPaste.Enabled := (FButtonGroup <> nil) and ButtonGroupInClipbord and not LockBtnEdit;
  popButtonPaste.Visible := not LockBtnEdit;
  popButtonSpace.Enabled := (FButtonGroup <> nil) and not LockBtnEdit;
  popButtonSpace.Visible := not LockBtnEdit;
  popButtonReturn.Enabled := (FButtonGroup <> nil) and not LockBtnEdit;
  popButtonReturn.Visible := not LockBtnEdit;
  popButtonDelete.Enabled := (ButtonIndex >= 0) and not LockBtnEdit;
  popButtonDelete.Visible := not LockBtnEdit;
  popButtonBackSpace.Enabled := (ButtonIndex >= 1) and not LockBtnEdit;
  popButtonBackSpace.Visible := not LockBtnEdit;
  popButtonNextDelete.Enabled := (ButtonIndex < FButtonGroup.Count - 1) and not LockBtnEdit;
  popButtonNextDelete.Visible := not LockBtnEdit;
  popPadNew.Enabled := not LockBtnEdit;
  popPadNew.Visible := not LockBtnEdit;
  popPadCopy.Enabled := not LockBtnEdit;
  popPadCopy.Visible := not LockBtnEdit;
  popPadHide.Enabled := FStickPositions <> [];
  popPadDelete.Enabled := (Pads.Count > 1) and not LockBtnEdit;
  popPadDelete.Visible := not LockBtnEdit;

  popTopMost.Checked := TopMost;
  popTopMost.Enabled := (FDialogBox = nil) and not LockPadProperty;
  popTopMost.Visible := not LockPadProperty;
  popHideAuto.Checked := HideAuto;
  popHideAuto.Enabled := (FDialogBox = nil) and not LockPadProperty;
  popHideAuto.Visible := not LockPadProperty;

  popComLine.Enabled := dlgComLine = nil;
  popButtonEdit.Enabled := (FDialogBox = nil) and not LockBtnEdit;
  popButtonEdit.Visible := not LockBtnEdit;
  popPadProperty.Enabled := (FDialogBox = nil) and not LockPadProperty;
  popPadProperty.Visible := not LockPadProperty;
  popOption.Enabled := dlgOption = nil;
  popSearchTopic.Enabled := FileExists(Application.HelpFile);

  i := popPluginBegin.MenuIndex + 1;
  while True do
  begin
    MenuItem := popMain.Items[i];
    if MenuItem = popPluginEnd then
      Break;

    if (MenuItem.Tag >= 0) and (MenuItem.Tag < Plugins.Count) then
    begin
      Plugin := TPlugin(Plugins.Objects[MenuItem.Tag]);
      if @Plugin.SLXMenuCheck <> nil then
      begin
        MenuItem.Checked := Plugin.SLXMenuCheck(0);
        for j := 0 to MenuItem.Count - 1 do
          MenuItem[j].Checked := Plugin.SLXMenuCheck(MenuItem[j].Tag);
      end;
    end;

    Inc(i);
  end;

end;



// �p�b�h�̃v���p�e�B���j���[
procedure TfrmPad.popPadPropertyClick(Sender: TObject);
var
  dlgPadProperty: TdlgPadProperty;
  i: Integer;
begin
  if GetLockPadProperty(True) then
    Exit;



  if (FDialogBox = nil) then
  begin
    dlgPadProperty := TdlgPadProperty.Create(Self);
    DialogBox := dlgPadProperty;

    dlgPadProperty.OnApply := dlgPadPropertyApply;
    dlgPadProperty.OnClosed := DialogBoxClosed;
    dlgPadProperty.OnWindowActivate := DialogBoxWindowActivate;
    dlgPadProperty.OnWindowDeactivate := DialogBoxWindowDeactivate;

{
    if PropertyPageNo < dlgPadProperty.PageControl.PageCount then
      dlgPadProperty.PageControl.ActivePage := dlgPadProperty.PageControl.Pages[PropertyPageNo]
    else
      dlgPadProperty.PageControl.ActivePage := dlgPadProperty.PageControl.Pages[0];
}
    dlgPadProperty.PageControl.ActivePage := dlgPadProperty.PageControl.Pages[0];

    dlgPadProperty.chkTopMost.Checked := TopMost;
    dlgPadProperty.chkSmoothScroll.Checked := SmoothScroll;
    dlgPadProperty.hkActiveKey.HotKey := LoByte(Hotkey);
    dlgPadProperty.hkActiveKey.Modifiers := THKModifiers(HiByte(Hotkey));

    case DropAction of
      DA_ADDHERE:
        dlgPadProperty.cmbDropAction.ItemIndex := DA_I_ADDHERE;
      DA_ADDLAST:
        dlgPadProperty.cmbDropAction.ItemIndex := DA_I_ADDLAST;
      DA_OPENHERE:
        dlgPadProperty.cmbDropAction.ItemIndex := DA_I_OPENHERE;
      DA_COPYNAME:
        dlgPadProperty.cmbDropAction.ItemIndex := DA_I_COPYNAME;
      else
        dlgPadProperty.cmbDropAction.ItemIndex := DA_I_ADDHERE;
    end;

    case DblClickAction of
      CA_COMLINE:
        dlgPadProperty.cmbDblClickAction.ItemIndex := CA_I_COMLINE;
      CA_BTNEDIT:
        dlgPadProperty.cmbDblClickAction.ItemIndex := CA_I_BTNEDIT;
      CA_GRPCHANGE:
        dlgPadProperty.cmbDblClickAction.ItemIndex := CA_I_GRPCHANGE;
      CA_NEXTGROUP:
        dlgPadProperty.cmbDblClickAction.ItemIndex := CA_I_NEXTGROUP;
      CA_PADPRO:
        dlgPadProperty.cmbDblClickAction.ItemIndex := CA_I_PADPRO;
      CA_OPTION:
        dlgPadProperty.cmbDblClickAction.ItemIndex := CA_I_OPTION;
      CA_HIDE:
        dlgPadProperty.cmbDblClickAction.ItemIndex := CA_I_HIDE;
      else
        dlgPadProperty.cmbDblClickAction.ItemIndex := CA_I_GRPCHANGE;
    end;

    dlgPadProperty.shpBackColor.Brush.Color := BackColor;
    dlgPadProperty.edtWallPaper.Text := WallPaper;
    if BtnVertical then
      dlgPadProperty.cmbLayout.ItemIndex := 1
    else
      dlgPadProperty.cmbLayout.ItemIndex := 0;
    dlgPadProperty.cmbDragBar.ItemIndex := DragBar;
    dlgPadProperty.chkGroupName.Checked := GroupName;
    dlgPadProperty.udDragBarSize.Position := DragBarSize;
    dlgPadProperty.cmbScrollBar.ItemIndex := ScrollBar;
    dlgPadProperty.chkScrollBtn.Checked := ScrollBtn;
    dlgPadProperty.chkGroupBtn.Checked := GroupBtn;
    dlgPadProperty.udScrollSize.Position := ScrollSize;
    dlgPadProperty.shpBtnFocusColor.Brush.Color := BtnFocusColor;
    dlgPadProperty.chkBtnTransparent.Checked := BtnTransparent;
    dlgPadProperty.chkBtnSelTransparent.Checked := BtnSelTransparent;
    dlgPadProperty.chkBtnSmallIcon.Checked := BtnSmallIcon;
    dlgPadProperty.chkBtnSquare.Checked := BtnSquare;
    dlgPadProperty.udBtnWidth.Position := BtnWidth;
    dlgPadProperty.udBtnHeight.Position := BtnHeight;
    dlgPadProperty.cmbBtnCaption.ItemIndex := BtnCaption;
    dlgPadProperty.shpBtnColor.Brush.Color := BtnColor;
    dlgPadProperty.chkHideAuto.Checked := HideAuto;
    dlgPadProperty.chkHideSmooth.Checked := HideSmooth;
    dlgPadProperty.chkHideMouseCheck.Checked := HideMouseCheck;
    dlgPadProperty.rdoHideVertical.Checked := HideVertical;
    dlgPadProperty.chkHideGroupName.Checked := HideGroupName;
    dlgPadProperty.udHideSize.Position := HideSize;
    dlgPadProperty.udShowDelay.Position := ShowDelay;
    dlgPadProperty.udHideDelay.Position := HideDelay;
    dlgPadProperty.shpHideColor.Brush.Color := HideColor;

    for i := 0 to dlgPadProperty.cmbSkins.Items.Count - 1 do
    begin
      if dlgPadProperty.cmbSkins.Items.Objects[i] = SkinPlugin then
      begin
        dlgPadProperty.cmbSkins.ItemIndex := i;
        Break;
      end;
    end;
    if dlgPadProperty.cmbSkins.ItemIndex = -1 then
      dlgPadProperty.cmbSkins.ItemIndex := 0;

    dlgPadProperty.Show;
    Enabled := False;
  end;
end;


// �p�b�h�̃v���p�e�B�K�p
procedure TfrmPad.dlgPadPropertyApply(Sender: TObject);
var
  dlgPadProperty: TdlgPadProperty;
begin
  dlgPadProperty := Sender as TdlgPadProperty;

  // �v���p�e�B�̕ύX
  BeginUpdate;
  try
    TopMost := dlgPadProperty.chkTopMost.Checked;
    SmoothScroll := dlgPadProperty.chkSmoothScroll.Checked;
    Hotkey := MakeWord(dlgPadProperty.hkActiveKey.HotKey, Byte(dlgPadProperty.hkActiveKey.Modifiers));

    case dlgPadProperty.cmbDropAction.ItemIndex of
      DA_I_ADDHERE:
        DropAction := DA_ADDHERE;
      DA_I_ADDLAST:
        DropAction := DA_ADDLAST;
      DA_I_OPENHERE:
        DropAction := DA_OPENHERE;
      DA_I_COPYNAME:
        DropAction := DA_COPYNAME;
      else
        DropAction := DA_ADDHERE;
    end;

    case dlgPadProperty.cmbDblClickAction.ItemIndex of
      CA_I_COMLINE:
        DblClickAction := CA_COMLINE;
      CA_I_BTNEDIT:
        DblClickAction := CA_BTNEDIT;
      CA_I_GRPCHANGE:
        DblClickAction := CA_GRPCHANGE;
      CA_I_NEXTGROUP:
        DblClickAction := CA_NEXTGROUP;
      CA_I_PADPRO:
        DblClickAction := CA_PADPRO;
      CA_I_OPTION:
        DblClickAction := CA_OPTION;
      CA_I_HIDE:
        DblClickAction := CA_HIDE;
      else
        DblClickAction := CA_GRPCHANGE;
    end;

    BackColor := dlgPadProperty.shpBackColor.Brush.Color;
    WallPaper := dlgPadProperty.edtWallPaper.Text;
    BtnVertical := dlgPadProperty.cmbLayout.ItemIndex = 1;
    DragBar := dlgPadProperty.cmbDragBar.ItemIndex;
    GroupName := dlgPadProperty.chkGroupName.Checked;
    DragBarSize := dlgPadProperty.udDragBarSize.Position;
    ScrollBar := dlgPadProperty.cmbScrollBar.ItemIndex;
    ScrollBtn := dlgPadProperty.chkScrollBtn.Checked;
    GroupBtn := dlgPadProperty.chkGroupBtn.Checked;
    ScrollSize := dlgPadProperty.udScrollSize.Position;
    BtnFocusColor := dlgPadProperty.shpBtnFocusColor.Brush.Color;
    BtnTransparent := dlgPadProperty.chkBtnTransparent.Checked;
    BtnSelTransparent := dlgPadProperty.chkBtnSelTransparent.Checked;
    BtnSmallIcon := dlgPadProperty.chkBtnSmallIcon.Checked;
    BtnSquare := dlgPadProperty.chkBtnSquare.Checked;
    BtnWidth := dlgPadProperty.udBtnWidth.Position;
    BtnHeight := dlgPadProperty.udBtnHeight.Position;
    BtnCaption := dlgPadProperty.cmbBtnCaption.ItemIndex;
    BtnColor := dlgPadProperty.shpBtnColor.Brush.Color;
    HideAuto := dlgPadProperty.chkHideAuto.Checked;
    HideSmooth := dlgPadProperty.chkHideSmooth.Checked;
    HideMouseCheck := dlgPadProperty.chkHideMouseCheck.Checked;
    HideVertical := dlgPadProperty.rdoHideVertical.Checked;
    HideGroupName := dlgPadProperty.chkHideGroupName.Checked;
    HideSize := dlgPadProperty.udHideSize.Position;
    ShowDelay := dlgPadProperty.udShowDelay.Position;
    HideDelay := dlgPadProperty.udHideDelay.Position;
    HideColor := dlgPadProperty.shpHideColor.Brush.Color;
    if dlgPadProperty.cmbSkins.ItemIndex >= 0 then
      SkinPlugin := TPlugin(dlgPadProperty.cmbSkins.Items.Objects[dlgPadProperty.cmbSkins.ItemIndex])
    else
      SkinPlugin := nil;
  finally
    EndUpdate;
  end;
  SaveIni;
//  Pads.Save;
  Show;
end;

// �p�b�h�̐V�K�쐬
procedure TfrmPad.popPadNewClick(Sender: TObject);
begin
  Pads.New(nil);
end;

// �p�b�h�̕����쐬
procedure TfrmPad.popPadCopyClick(Sender: TObject);
begin
  Pads.New(Self);
end;

// ��Ɏ�O�ɕ\������
procedure TfrmPad.popTopMostClick(Sender: TObject);
begin
  TopMost := not TopMost;
end;

// �\�t�g�E�F�A�̍X�V���m�F
procedure TfrmPad.popVerCheckClick(Sender: TObject);
begin
  if dlgVerCheck = nil then
    dlgVerCheck := TdlgVerCheck.Create(nil);
  dlgVerCheck.Show;
end;

// �����I�ɉB���
procedure TfrmPad.popHideAutoClick(Sender: TObject);
begin
  HideAuto := not HideAuto;
end;

// �B��
procedure TfrmPad.popPadHideClick(Sender: TObject);
begin
  if (StickPositions <> []) and (not FfrmPadTab.Hid) and Enabled then
  begin
    FfrmPadTab.MoveHide;
  end;
end;

// ���郁�j���[
procedure TfrmPad.popPadDeleteClick(Sender: TObject);
var
  Msg: String;
begin
  Msg := '���̃p�b�h���폜���܂��B�{�^�����̐ݒ�����ׂč폜����܂��B';
  if MessageBox(Handle, PChar(Msg), '�m�F', MB_ICONINFORMATION or MB_OKCANCEL) = idOk then
    Pads.Close(Self);
end;

// �w�肵�Ď��s
procedure TfrmPad.popComLineClick(Sender: TObject);
begin
  if dlgComLine = nil then
    dlgComLine := TdlgComLine.Create(nil);
  dlgComLine.Show;
end;

// �ݒ胁�j���[
procedure TfrmPad.popOptionClick(Sender: TObject);
begin
  if dlgOption = nil then
    dlgOption := TdlgOption.Create(nil);
  dlgOption.Show;
end;

// �I�����j���[
procedure TfrmPad.popExitClick(Sender: TObject);
begin
  frmMain.Close;
end;

// �X�N���[���{�^���T�C�Y�ύX
procedure TfrmPad.pnlScrollBarResize(Sender: TObject);
begin
  ArrangeScrolls;
end;

// �X�N���[���{�^���N���b�N
procedure TfrmPad.btnScrollsClick(Sender: TObject);
begin
  case TSLScrollButton(Sender).Tag of
    0:
      if GroupIndex > 0 then
        GroupIndex := GroupIndex - 1;
    1:
      TopLineIndex := TopLineIndex - 1;
    2:
      TopLineIndex := TopLineIndex + 1;
    3:
      if GroupIndex < FButtonGroups.Count - 1 then
        GroupIndex := GroupIndex + 1;
  end;
end;

procedure TfrmPad.btnScrollsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
var
  SoundFile: String;
begin
  case TSLScrollButton(Sender).Tag of
    1..2:
    if Button = mbLeft then
    begin
      SoundFile := UserIniFile.ReadString(IS_SOUNDS, 'ButtonClick', '');
      if SoundFile <> '' then
        PlaySound(PChar(SoundFile), 0, SND_ASYNC);
    end;
  end;
end;

// �X�N���[���o�[��OnMouseEnter
procedure TfrmPad.btnScrollsMouseEnter(Sender: TObject);
var
  TitleRect: TRect;
  Title: string;
  Index: Integer;
begin
  Index := -1;
  case TSLScrollButton(Sender).Tag of
    0: Index := GroupIndex - 1;
    3: Index := GroupIndex + 1;
  end;

  if (Index >= 0) and (Index < FButtonGroups.Count) then
  begin
    Title := '"' + FButtonGroups[Index].Name + '" ���J��';
    TitleRect := TSLScrollButton(Sender).ClientRect;
    TitleRect.TopLeft := TSLScrollButton(Sender).ClientToScreen(TitleRect.TopLeft);
    TitleRect.BottomRight := TSLScrollButton(Sender).ClientToScreen(TitleRect.BottomRight);
    ShowTitle(Self, Title, TitleRect);
  end;

end;

// �X�N���[���o�[��OnMouseLeave
procedure TfrmPad.btnScrollsMouseLeave(Sender: TObject);
begin
  HideTitle;
  Update;
end;

// �X�N���[���{�^���̕��ёւ�
procedure TfrmPad.ArrangeScrolls;
var
  i: Integer;
  W, Half, Long: Integer;
begin
  if FUpdateCount > 0 then
  begin
    ArrangeScrollsWaited := True;
    Exit;
  end;

  for i := 0 to 3 do
  begin
    btnScrolls[i].Color := BtnColor;
    btnScrolls[i].Vertical := not FBtnVertical;
    btnScrolls[i].FocusColor := FBtnFocusColor;
    btnScrolls[i].SelTransparent := FBtnSelTransparent;
    btnScrolls[i].Transparent := FBtnTransparent;
    btnScrolls[i].Visible := ((i in [1, 2]) and FScrollBtn) or ((i in [0, 3]) and FGroupBtn);
  end;

  if pnlScrollBar.Align in [alLeft, alRight] then
  begin
    W := pnlScrollBar.ClientWidth;
    Half := pnlScrollBar.ClientHeight div 2;
    if FScrollBtn and FGroupBtn then
    begin
      Long := Half - pnlScrollBar.ClientWidth;
      if Long < pnlScrollBar.ClientWidth then
        Long := pnlScrollBar.ClientHeight div 4;
      btnScrolls[0].SetBounds(0, 0,           W, Half - Long);
      btnScrolls[1].SetBounds(0, Half - Long, W, Long);
      btnScrolls[2].SetBounds(0, Half,        W, Long);
      btnScrolls[3].SetBounds(0, Half + Long, W, pnlScrollBar.ClientHeight - Long - Half);
    end
    else
    begin
      btnScrolls[0].SetBounds(0, 0,    W, Half);
      btnScrolls[1].SetBounds(0, 0,    W, Half);
      btnScrolls[2].SetBounds(0, Half, W, Half);
      btnScrolls[3].SetBounds(0, Half, W, Half);
    end;
  end
  else
  begin
    W := pnlScrollBar.ClientHeight;
    Half := pnlScrollBar.ClientWidth div 2;
    if FScrollBtn and FGroupBtn then
    begin
      Long := Half - pnlScrollBar.ClientHeight;
      if Long < pnlScrollBar.ClientHeight then
        Long := pnlScrollBar.ClientWidth div 4;
      btnScrolls[0].SetBounds(0,           0, Half - Long,                            W);
      btnScrolls[1].SetBounds(Half - Long, 0, Long,                                   W);
      btnScrolls[2].SetBounds(Half,        0, Long,                                   W);
      btnScrolls[3].SetBounds(Half + Long, 0, pnlScrollBar.ClientWidth - Long - Half, W);
    end
    else
    begin
      btnScrolls[0].SetBounds(0, 0,    Half, W);
      btnScrolls[1].SetBounds(0, 0,    Half, W);
      btnScrolls[2].SetBounds(Half, 0, Half, W);
      btnScrolls[3].SetBounds(Half, 0, Half, W);
    end;
  end;
end;

// �X�N���[���{�^����Enabled�̊m�F
procedure TfrmPad.EnabledCheckScrolls;
begin
  btnScrolls[0].Enabled := GroupIndex > 0;
  btnScrolls[1].Enabled := FTopLineIndex > 0;
  btnScrolls[2].Enabled := (FBtnVertical and (FTopLineIndex < FButtonArrangement.Rows - Cols))
                    or (not FBtnVertical and (FTopLineIndex < FButtonArrangement.Rows - Rows));
  btnScrolls[3].Enabled := GroupIndex < FButtonGroups.Count - 1;
end;

// �{�^���`��̈�̕�
function TfrmPad.GetButtonsAreaWidth: Integer;
begin
  Result := ClientWidth;
  if DragBar in [1, 3] then
    Result := Result - pnlDragBar.Width;
  if ScrollBar in [1, 3] then
    Result := Result - pnlScrollBar.Width;
end;

// �{�^���`��̈�̍���
function TfrmPad.GetButtonsAreaHeight: Integer;
begin
  Result := ClientHeight;
  if DragBar in [2, 4] then
    Result := Result - pnlDragBar.Height;
  if ScrollBar in [2, 4] then
    Result := Result - pnlScrollBar.Height;
end;


// �ړ��J�n
procedure TfrmPad.pnlDragBarMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ssLeft in Shift then
  begin
    ReleaseCapture;
    SendMessage (Handle, WM_SYSCOMMAND, SC_MOVE or 2, 0);
    if Sender is TControl then
    begin
      TControl(Sender).Perform(WM_LBUTTONUP, 0, MakeLParam(X,Y));
      UserMoved;
    end;
  end;
end;

// �ړ���
procedure TfrmPad.WMWindowPosChanging(var Msg: TWMWindowPosChanging);
var
  MinX, MinY, MaxX, MaxY: Integer;
  CursorMonitor: TMonitor;
begin
  inherited;

  with Msg.WindowPos^ do
  begin
    if (flags and SWP_NOMOVE) <> 0 then
      Exit;

    CursorMonitor := Screen.MonitorFromPoint(Mouse.CursorPos);
    MinX := CursorMonitor.Left;
    MinY := CursorMonitor.Top;
    MaxX := MinX + CursorMonitor.Width - cx;
    MaxY := MinY + CursorMonitor.Height - cy;

    if (x < MinX + 10) and (x > MinX -10) then
      x := MinX
    else if (x < (MaxX + 10)) and (x > (MaxX - 10)) then
      x := MaxX;

    if (y < MinY + 10) and (y > MinY -10) then
      y := MinY
    else if (y < (MaxY + 10)) and (y > (MaxY - 10)) then
      y := MaxY;

  end;
end;


// �ړ���
procedure TfrmPad.WMMoving(var Msg: TMessage);
var
  MinX, MinY, MaxX, MaxY: Integer;
  CursorMonitor: TMonitor;
begin
  inherited;

  CursorMonitor := Screen.MonitorFromPoint(Mouse.CursorPos);
  MinX := CursorMonitor.Left;
  MinY := CursorMonitor.Top;
  MaxX := MinX + CursorMonitor.Width;
  MaxY := MinY + CursorMonitor.Height;

  with PRect(Msg.LParam)^ do
  begin
    if Right > MaxX then
      Left := MaxX - Width;
    if Left < MinX then
      Left := MinX;

    if Bottom > MaxY then
      Top := MaxY - Height;
    if Top < MinY then
      Top := MinY;

    Right := Left + Width;
    Bottom := Top + Height;
  end;

end;

// ���[�U�[���ړ�����
procedure TfrmPad.UserMoved;
begin

  if Monitor.Width = Width then
    FLeftPercentage := 0
  else
    FLeftPercentage := (Left - Monitor.Left) * 100 / (Monitor.Width - Width);

  if Monitor.Height = Height then
    FTopPercentage := 0
  else
    FTopPercentage := (Top - Monitor.Top) * 100 / (Monitor.Height - Height);

  FStickPositions := [];
  if Left = Monitor.Left then
    FStickPositions := FStickPositions + [spLeft]
  else if Left = (Monitor.Left + Monitor.Width - Width) then
    FStickPositions := FStickPositions + [spRight];

  if Top = Monitor.Top then
    FStickPositions := FStickPositions + [spTop]
  else if Top = (Monitor.Top + Monitor.Height - Height) then
    FStickPositions := FStickPositions + [spBottom];

end;

// �ύX�J�n
procedure TfrmPad.BeginUpdate;
begin
  Inc(FUpdateCount);
  ArrangeScrollsWaited := False;
  ArrangeButtonsWaited := False;
end;

// �ύX�I��
procedure TfrmPad.EndUpdate;
begin
  if FUpdateCount > 0 then
    Dec(FUpdateCount);
  if FUpdateCount = 0 then
  begin
    if ArrangeScrollsWaited then
    begin
      ArrangeScrolls;
    end;
    if ArrangeButtonsWaited then
    begin
      ArrangeButtons;
    end;
  end;
end;


// �Ĕz�u
// �T�C�Y�ύX��
procedure TfrmPad.WMSizing(var Msg: TMessage);
var
  FWidth, FHeight: Integer;
  NWidth, NHeight: Integer;
begin
  inherited;

  FWidth := Width - GetButtonsAreaWidth; // �g�̕�
  FHeight := Height - GetButtonsAreaHeight; // �g�̍���

  with PRect(Msg.LParam)^ do
  begin
    NWidth := Right - Left - FWidth + BtnFrameWidth div 2;
    NHeight := Bottom - Top - FHeight + BtnFrameHeight div 2;

    NWidth := NWidth div BtnFrameWidth;
    if NWidth <= 0 then
      NWidth := 1;
    NWidth := NWidth * BtnFrameWidth + FWidth;

    NHeight := NHeight div BtnFrameHeight;
    if NHeight <= 0 then
      NHeight := 1;
    NHeight := NHeight * BtnFrameHeight + FHeight;

    if (Msg.WParam = WMSZ_LEFT) or (Msg.WParam = WMSZ_TOPLEFT) or (Msg.WParam = WMSZ_BOTTOMLEFT) then
      Left := Right - NWidth
    else if (Msg.WParam = WMSZ_RIGHT) or (Msg.WParam = WMSZ_TOPRIGHT) or (Msg.WParam = WMSZ_BOTTOMRIGHT) then
      Right := Left + NWidth;
    if (Msg.WParam = WMSZ_TOP) or (Msg.WParam = WMSZ_TOPLEFT) or (Msg.WParam = WMSZ_TOPRIGHT) then
      Top := Bottom - NHeight
    else if (Msg.WParam = WMSZ_BOTTOM) or (Msg.WParam = WMSZ_BOTTOMLEFT) or (Msg.WParam = WMSZ_BOTTOMRIGHT) then
      Bottom := Top + NHeight;

  end;

  FUserResize := True;
end;


procedure TfrmPad.FormResize(Sender: TObject);
begin
  if FUserResize then
  begin
    HideTitle;
    pnlScrollBar.Update;
    if BtnFrameHeight > 0 then
      Rows := GetButtonsAreaHeight div BtnFrameHeight;
    if BtnFrameWidth > 0 then
      Cols := GetButtonsAreaWidth div BtnFrameWidth;
    UserMoved;
  end;

  FUserResize := False;
end;



// �T�C�Y�ύX���N����
procedure TfrmPad.SizeCheck;
var
  BWidth, BHeight: Integer;
  NLeft, NTop, NWidth, NHeight: Integer;
begin
  if not Visible then
    Exit;
  if (Cols < 1) or (Rows < 1) then
    Exit;
  if (BtnFrameWidth < 1) or (BtnFrameHeight <= 1) then
    Exit;

  // �{�^���ȊO�̃T�C�Y
  BWidth := Width - GetButtonsAreaWidth;
  BHeight := Height - GetButtonsAreaHeight;

  NLeft := Left;
  NTop := Top;
  NWidth := BtnFrameWidth * Cols + BWidth;
  NHeight := BtnFrameHeight * Rows + BHeight;

  if (NLeft + NWidth) > Monitor.Left + Monitor.Width then
    NLeft := Monitor.Width - NWidth;
  if NLeft < Monitor.Left then
    NLeft := Monitor.Left;
  if (NTop + NHeight) > Monitor.Top + Monitor.Height then
    NTop := Monitor.Height - NHeight;
  if NTop < Monitor.Top then
    NTop := Monitor.Top;

  SetBounds(NLeft, NTop, NWidth, NHeight);
end;



// �f�B�X�v���C�̕ύX
procedure TfrmPad.WMDisplayChange(var Msg: TWMDisplayChange);
var
  NLeft, NTop: Integer;
  MaxLeft, MaxTop: Integer;
begin
  inherited;

  SizeCheck;

  MaxLeft := Monitor.Width - Width;
  MaxTop := Monitor.Height - Height;
  if MaxLeft < 0 then
    MaxLeft := 0;
  if MaxTop < 0 then
    MaxTop := 0;
  NLeft := Round(MaxLeft * FLeftPercentage / 100);
  NTop := Round(MaxTop * FTopPercentage / 100);

  if (spRight in StickPositions) or (NLeft > MaxLeft) then
    NLeft := MaxLeft;
  if (spLeft in StickPositions) or (NLeft < 0) then
    NLeft := 0;

  if (spBottom in StickPositions) or (NTop > MaxTop) then
    NTop := MaxTop;
  if (spTop in StickPositions) or (NTop < 0) then
    NTop := 0;

  Left := Monitor.Left + NLeft;
  Top := Monitor.Top + NTop;

  with FfrmPadTab do
  begin
    SetHideSize;
    SetBounds(HidLeft, HidTop, HidWidth, HidHeight);
  end;
end;

// �R���g���[���p�l���̕ύX
procedure TfrmPad.WMSettingChange(var Msg: TWMSettingChange);
var
  NonClientMetrics: TNonClientMetrics;
begin
  inherited;

  // �^�C�g���o�[�̃t�H���g
  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0);
  pbDragBar.Font.Handle := CreateFontIndirect(NonClientMetrics.lfCaptionFont);

  ResizeDragBar;
  SizeCheck;
end;

// �R���e�L�X�g���j���[�̕\��
procedure TfrmPad.WMContextMenu(var Msg: TWMContextMenu);
var
  Item: TButtonItem;
  Pos: TPoint;
begin
  if (Msg.Pos.y < 0) and (Msg.Pos.x < 0) then
  begin
    Item := FButtonArrangement.CurrentItem;
    if Item <> nil then
      if Item.SLButton <> nil then
      begin
        Pos.x := Item.SLButton.Width div 2;
        Pos.y := Item.SLButton.Height div 2;
        Msg.Pos := PointToSmallPoint(Item.SLButton.ClientToScreen(Pos));
      end;
  end;
  inherited;
end;

procedure TfrmPad.WMActivate(var Msg: TWMActivate);
begin
  inherited;
  Foreground := Msg.Active <> WA_INACTIVE;
  // TopMost�����蓖�ĂȂ����i�_�C�A���O�{�b�N�X������Ƃ��͍őO�ʂ���Ȃ��j
  TopMost := TopMost;
end;


// Enable���ς��
procedure TfrmPad.WMEnable(var Msg: TWMEnable);
begin
  inherited;

  Enabled := Msg.Enabled;
  DropEnabled := Msg.Enabled;
end;

// �t�H�[�J�X���Z�b�g
procedure TfrmPad.SetForeground(Value: Boolean);
var
  i: Integer;
  Plugin: TPlugin;
//  ms :Cardinal;
begin
  if (Pads = nil) or Pads.Destroying then
    Exit;

  if FForeground = Value then
    Exit;
  FForeground := Value;

//ms :=GetTickCount;

  FButtonArrangement.Active := Value;

  ArrangeGroupMenu;

  if not FForeground then
    HideTitle;

  pbDragBar.Refresh;
  if (SkinPlugin <> nil) and (@SkinPlugin.SLXDrawWorkspace <> nil) then
  begin
    // �X�L���Ή��̏ꍇ�̂ݕǎ����t���b�V��
    pbWallPaper1.Refresh;
    pbWallPaper2.Refresh;
  end;

  tmHideScreen.Enabled := False;
  if FForeground then
    tmHideScreen.Interval := FShowDelay
  else
    tmHideScreen.Interval := FHideDelay;
  tmHideScreen.Enabled := True;


  // �v���O�C���ɒʒm
  for i := 0 to Plugins.Count - 1 do
  begin
    Plugin := TPlugin(Plugins.Objects[i]);
    if @Plugin.SLXChangePadForeground <> nil then
    begin
      Plugin.SLXChangePadForeground(Handle, FForeground);
    end;
  end;
//OutputDebugString(PChar(IntToStr(GetTickCount - ms)));

end;




// �}�E�X�|�C���^������
procedure TfrmPad.SetMouseEntered(Value: Boolean);
var
  i: Integer;
  Plugin: TPlugin;
begin
  if FMouseEntered = Value then
    Exit;

  FMouseEntered := Value;

  tmHideScreen.Enabled := False;

  // �v���O�C���ɒʒm
  for i := 0 to Plugins.Count - 1 do
  begin
    Plugin := TPlugin(Plugins.Objects[i]);
    if @Plugin.SLXChangePadMouseEntered <> nil then
    begin
      Plugin.SLXChangePadMouseEntered(Handle, FMouseEntered);
    end;
  end;

  if FMouseEntered then
  begin
    tmHideScreen.Interval := FShowDelay;
  end
  else
  begin
    tmHideScreen.Interval := FHideDelay;
  end;
  tmHideScreen.Enabled := True;
end;

// �����^�B���̎���
procedure TfrmPad.tmHideScreenTimer(Sender: TObject);
var
  MouseEnteredCheck: Boolean;
begin
  tmHideScreen.Enabled := False;

  MouseEnteredCheck := FMouseEntered and (FHideMouseCheck or frmPadTab.DropEntered);
  // �����
  if (MouseEnteredCheck or FForeground) and FfrmPadTab.Hid and IsWindowEnabled(frmPadTab.Handle) then
    FfrmPadTab.MoveShow
  // �B���
  else if (not FForeground) and (not MouseEnteredCheck) and (StickPositions <> [])
    and HideAuto and (not FfrmPadTab.Hid) and IsWindowEnabled(Handle) then
    FfrmPadTab.MoveHide;
end;

// �{�^���t�@�C�����擾
function TfrmPad.GetBtnFileName: String;
begin
  if FBtnFileName = '' then
    FBtnFileName := UserFolder + 'Pads\Pad' + IntToStr(ID) + '.btn';

  Result := FBtnFileName;
end;


// �O���[�v�C���f�b�N�X�擾
function TfrmPad.GetGroupIndex: Integer;
begin
  Result := FButtonGroups.IndexOf(ButtonGroup);
end;

// �O���[�v�C���f�b�N�X�ύX
procedure TfrmPad.SetGroupIndex(Value: Integer);
var
  SoundFile: String;
begin
  if Value < -1 then
    Value := -1;
  if Value > FButtonGroups.Count - 1 then
    Value := FButtonGroups.Count - 1;
  if (Value >= 0) and (Value < FButtonGroups.Count) then
  begin
    SoundFile := UserIniFile.ReadString(IS_SOUNDS, 'GroupChange', '');
    if SoundFile <> '' then
      PlaySound(PChar(SoundFile), 0, SND_ASYNC);
    ButtonGroup := FButtonGroups[Value];
  end
  else
    ButtonGroup := nil;
end;

// �{�^���O���[�v�ύX
procedure TfrmPad.SetButtonGroup(Value: TButtonGroup);
begin
  if FButtonGroup = Value then
    Exit;


  FButtonArrangement.Clear;
  FButtonGroup := Value;

  FISearchTimer.Free;
  FISearchTimer := nil;
  FISearch := '';

  ArrangeGroupMenu;

  BeginUpdate;
  try
    FButtonArrangement.ButtonGroup := FButtonGroup;
    TopLineIndex := 0;
    CurrentMakeVisible;
  finally
    EndUpdate;
  end;

  FCurrentColBack := FButtonArrangement.CurrentCol;
end;

// �{�^���O���[�v�ؑ�
procedure TfrmPad.popGroupItemClick(Sender: TObject);
begin
  GroupIndex := TMenuItem(Sender).Tag;
end;

// �w���v
procedure TfrmPad.popSearchTopicClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER, 0);
end;


// �o�[�W�������
procedure TfrmPad.popAboutClick(Sender: TObject);
begin
  frmMain.popAbout.Click;
end;

// �h���b�O�o�[�̕`��
procedure TfrmPad.pbDragBarPaint(Sender: TObject);
var
  GrpName: string;
  IsGradat: BOOL;
  ARect: TRect;
  Direction: TDirection;
begin
  if ButtonGroup = nil then
    Exit;

  GrpName := ButtonGroup.Name;

  // �X�L���ɂ��`��
  if (FSkinPlugin <> nil) and (@FSkinPlugin.SLXDrawDragBar <> nil) then
  begin
    ARect := pbDragBar.ClientRect;
    if FSkinPlugin.SLXDrawDragBar(Handle, pbDragBar.Canvas.Handle, @ARect, FForeground, DragBar, PChar(GrpName)) then
      Exit;
  end;


  with pbDragBar do
  begin

    if not SystemParametersInfo(SPI_GETGRADIENTCAPTIONS, 0, @IsGradat, 0) then
      IsGradat := False;

    if pnlDragBar.Align = alLeft then
      Direction := drBottomUp
    else if pnlDragBar.Align = alRight then
      Direction := drTopDown
    else
      Direction := drLeftRight;

    if FForeground then
    begin
      Canvas.Brush.Color := clActiveCaption;
      if IsGradat then
        GradationRect(Canvas, ClientRect, Direction, clActiveCaption, TColor(clGradientActiveCaption))
      else
        Canvas.FillRect(ClientRect);
    end
    else
    begin
      Canvas.Brush.Color := clInactiveCaption;
      if IsGradat then
        GradationRect(Canvas, ClientRect, Direction, clInactiveCaption, TColor(clGradientInactiveCaption))
      else
        Canvas.FillRect(ClientRect);
    end;

    if FGroupName then
    begin
      Canvas.Brush.Style := bsClear;

      ARect := ClientRect;
//      InflateRect(ARect, -2, -2);
      if FForeground then
      begin
        OffsetRect(ARect, 1, 1);
        Canvas.Font.Color := GetShadowColor(clActiveCaption);
        RotateTextOut(Canvas, ARect, Direction, GrpName);
        OffsetRect(ARect, -1, -1);
        Canvas.Font.Color := clCaptionText;
        RotateTextOut(Canvas, ARect, Direction, GrpName);
      end
      else
      begin
        Canvas.Font.Color := clInactiveCaptionText;
        RotateTextOut(Canvas, ARect, Direction, GrpName);
      end;
    end;
  end;
end;

// �{�^���̕��ёւ�����
procedure TfrmPad.ButtonArranged(Sender: TObject);
begin
  ArrangeButtons;
end;

// �{�^���̕��ёւ�
procedure TfrmPad.ArrangeButtons;

  procedure SetNormalButton(NormalButton: TNormalButton; SLNormalButton: TSLNormalButton);
  begin
    if NormalButton.IconFile <> '' then
      SLNormalButton.IconHandle := IconCache.GetIcon(PChar(NormalButton.IconFile), ftIconPath, NormalButton.IconIndex, FBtnSmallIcon, True)
    else if NormalButton.ItemIDList <> nil then
      SLNormalButton.IconHandle := IconCache.GetIcon(NormalButton.ItemIDList, ftPIDL, NormalButton.IconIndex, FBtnSmallIcon, True)
    else
      SLNormalButton.IconHandle := IconCache.GetIcon(PChar(NormalButton.FileName), ftFilePath, NormalButton.IconIndex, FBtnSmallIcon, True);
  end;

  procedure SetPluginButton(PluginButton: TPluginButton; SLPluginButton: TSLPluginButton);
  var
    ButtonInfo: TButtonInfo;
    Plugin: TPlugin;
  begin

    ButtonInfo := Plugins.FindButtonInfo(PluginButton.PluginName, PluginButton.No);
    if ButtonInfo <> nil then
    begin

      Plugin := Plugins.FindPlugin(PluginButton.PluginName);

      if (ButtonInfo.UpdateInterval > 0) or (ButtonInfo.OwnerDraw) then
        ButtonInfo.SetUpdateButton(SLPluginButton)
      else
        ButtonInfo.OutUpdateButton(SLPluginButton);

      SLPluginButton.OnDestroy := btnPluginButtonDestroy;

      // �`�悠��
      if ButtonInfo.OwnerDraw then
      begin
        SLPluginButton.OwnerDraw := True;
        SLPluginButton.OnDrawButton := btnPluginButtonDrawButton;
        SLPluginButton.IconHandle := 0;
        SLPluginButton.Refresh;
      end
      // �`��Ȃ�
      else
      begin
        SLPluginButton.OwnerDraw := False;
        SLPluginButton.OnDrawButton := nil;
        SLPluginButton.IconHandle := IconCache.GetIcon(PChar(Plugin.FileName), ftIconPath, ButtonInfo.IconIndex, FBtnSmallIcon, True);
      end;
    end
    else
    begin
      SLPluginButton.OwnerDraw := False;
      SLPluginButton.OnDrawButton := nil;
      SLPluginButton.IconHandle := IconCache.GetIcon(PChar(ParamStr(0)), ftIconPath, ICO_PLUGIN, FBtnSmallIcon, True);
    end;
  end;

var
  Row, Col: Integer;
  W, H: Integer;
  Item: TButtonItem;
  SLButton: TSLNormalButton;
begin
  if FUpdateCount > 0 then
  begin
    ArrangeButtonsWaited := True;
    Exit;
  end;

  for Row := 0 to FButtonArrangement.Rows - 1 do
  begin

    for Col := 0 to FButtonArrangement.Cols - 1 do
    begin
      Item := FButtonArrangement[Col, Row];
      if Item <> nil then
      begin
        SLButton := Item.SLButton;
        if SLButton <> nil then
        begin
          if FBtnVertical then
            SLButton.SetBounds(Row * BtnFrameWidth, Col * BtnFrameHeight,
              BtnFrameWidth, BtnFrameHeight)
          else
            SLButton.SetBounds(Col * BtnFrameWidth, Row * BtnFrameHeight,
              BtnFrameWidth, BtnFrameHeight);
          SLButton.Parent := pnlButtons;
//          SLButton.Canvas := pbWallPaper1.Canvas;
          SLButton.Color := BtnColor;
          SLButton.Active := FForeGround;
          SLButton.FocusColor := FBtnFocusColor;
          SLButton.SelTransparent := FBtnSelTransparent;
          SLButton.Transparent := FBtnTransparent;
          SLButton.DragSource := True;

          SLButton.Caption := Item.ButtonData.Name;
          case FBtnCaption of
            CP_NONE: SLButton.CaptionPosition := cpNone;
            CP_BOTTOM: SLButton.CaptionPosition := cpBottom;
            CP_RIGHT: SLButton.CaptionPosition := cpRight;
          end;
          SLButton.SmallIcon := FBtnSmallIcon;
          SLButton.OnClick := btnSLButtonClick;
          SLButton.OnMouseEnter := btnSLButtonMouseEnter;
          SLButton.OnMouseLeave := btnSLButtonMouseLeave;
          SLButton.OnStartDrag := btnSLButtonStartDrag;
          if FSkinPlugin <> nil then
          begin
            if @FSkinPlugin.SLXDrawButtonFace <> nil then
              SLButton.OnSkinDrawFace := btnSLButtonSkinDrawFace;
            if @FSkinPlugin.SLXDrawButtonFrame <> nil then
              SLButton.OnSkinDrawFrame := btnSLButtonSkinDrawFrame;
            if @FSkinPlugin.SLXDrawButtonIcon <> nil then
              SLButton.OnSkinDrawIcon := btnSLButtonSkinDrawIcon;
            if @FSkinPlugin.SLXDrawButtonCaption <> nil then
              SLButton.OnSkinDrawCaption := btnSLButtonSkinDrawCaption;
            if @FSkinPlugin.SLXDrawButtonMask <> nil then
              SLButton.OnSkinDrawMask := btnSLButtonSkinDrawMask;
          end;
          SLButton.Visible := True;
          if Item.ButtonData is TNormalButton then
            SetNormalButton(TNormalButton(Item.ButtonData), TSLNormalButton(SLButton))
          else if Item.ButtonData is TPluginButton then
            SetPluginButton(TPluginButton(Item.ButtonData), TSLPluginButton(SLButton));
        end;
      end;
    end;

  end;


  
  if FBtnVertical then
  begin
    w := FButtonArrangement.Rows * BtnFrameWidth;
    h := FButtonArrangement.Cols * BtnFrameHeight;
  end
  else
  begin
    w := FButtonArrangement.Cols * BtnFrameWidth;
    h := FButtonArrangement.Rows * BtnFrameHeight;
  end;
  if w < pnlWorkSpace.Width then
    w := pnlWorkSpace.Width;
  if h < pnlWorkSpace.Height then
    h := pnlWorkSpace.Height;
  pnlButtons.SetBounds(pnlButtons.Left, pnlButtons.Top, w, h);
  FCurrentColBack := FButtonArrangement.CurrentCol;

  if FGroupName then
  begin
    pbDragBar.Refresh;
    FfrmPadTab.pbDragBar.Refresh;
  end;

  ScrollButtons(False);
end;

// �X�N���[������
procedure TfrmPad.ScrollButtons(Smooth: Boolean);
var
  mx, my: Integer; // ������
  lx, ly: Integer; // �ڕW�l
  sx, sy: Integer; // �}
  MMX, MMY: Boolean;  // �����s�ړ����邩
begin
  HideTitle;
  Update;

  if FBtnVertical then
  begin
    lx := - FTopLineIndex * BtnFrameWidth;
    ly := 0;
  end
  else
  begin
    lx := 0;
    ly := - FTopLineIndex * BtnFrameHeight;
  end;

  if Smooth and (FUpdateCount = 0) and Visible then
  begin
    if lx = pnlButtons.Left then
      sx := 0
    else if lx > pnlButtons.Left then
      sx := +1
    else
      sx := -1;

    if ly = pnlButtons.Top then
      sy := 0
    else if ly > pnlButtons.Top then
      sy := +1
    else
      sy := -1;

    MMX := Abs(pnlButtons.Left - lx) > (BtnFrameWidth * Cols);
    MMY := Abs(pnlButtons.Top - ly) > (BtnFrameHeight * Rows);
    mx := sx * BtnFrameWidth div 6;
    my := sy * BtnFrameHeight div 6;

    while True do
    begin
      // �ړ��������߂��Ȃ�
      if Abs(pnlButtons.Left - lx) <= Abs(mx) then
      begin
        mx := 0;
        ScrollWindow(pnlWorkspace.Handle, lx - pnlButtons.Left, 0, nil, nil);
      end
      else
      begin
        if MMX then
        begin
          if Abs(pnlButtons.Left - lx) > BtnFrameWidth * 4 then
            mx := sx * BtnFrameWidth div 2
          else if Abs(pnlButtons.Left - lx) > BtnFrameWidth then
            mx := sx * BtnFrameWidth div 6
          else
            mx := sx * BtnFrameWidth div 16;
        end;
      end;

      // �ړ��������߂��Ȃ�
      if Abs(pnlButtons.Top - ly) <= Abs(my) then
      begin
        my := 0;
        ScrollWindow(pnlWorkspace.Handle, 0, ly - pnlButtons.Top, nil, nil);
      end
      else
      begin
        if MMY then
        begin
          if Abs(pnlButtons.Top - ly) > BtnFrameHeight * 4 then
            my := sy * BtnFrameHeight div 4
          else if Abs(pnlButtons.Top - ly) > BtnFrameHeight then
            my := sy * BtnFrameHeight div 8
          else
            my := sy * BtnFrameHeight div 16;
        end;
      end;


      if (mx = 0) and (my = 0) then
        Break;

      ScrollWindow(pnlWorkspace.Handle, mx, my, nil, nil);
      pnlWorkspace.Update;

      Sleep(10);
    end;

  end;

  if Visible then
  begin
    ScrollWindow(pnlWorkspace.Handle, lx - pnlButtons.Left, ly - pnlButtons.Top, nil, nil);
    pnlButtons.Update;
  end
  else
  begin
    pnlButtons.Left := lx;
    pnlButtons.Top := ly;
  end;

  FCurrentViewRow := FButtonArrangement.CurrentRow - FTopLineIndex;
end;

// �{�^���N���b�N
procedure TfrmPad.btnSLButtonClick(Sender: TObject);
begin
  with Sender as TSLNormalButton do
  begin
    ButtonIndex := Tag;
    FCurrentColBack := FButtonArrangement.CurrentCol;
  end;
  CurBtnClick;
end;

// �}�E�X�|�C���^���{�^���ɓ���
procedure TfrmPad.btnSLButtonMouseEnter(Sender: TObject);
begin
  with Sender as TSLNormalButton do
  begin
    ButtonIndex := Tag;
    FCurrentColBack := FButtonArrangement.CurrentCol;
  end;
  CurrentTitle;
end;

// �}�E�X�|�C���^���{�^������o��
procedure TfrmPad.btnSLButtonMouseLeave(Sender: TObject);
begin
  HideTitle;
  Update;
end;

// �h���b�O�J�n
procedure TfrmPad.btnSLButtonStartDrag(Sender: TObject);
begin
  if not DropEnabled then
    Exit;

  if UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockBtnDrag', False) then
    Exit;
  if GetLockBtnEdit(False) then
    Exit;

  DragButtonData(ButtonIndex);
end;

// �{�^���̕\�ʕ`��
function TfrmPad.btnSLButtonSkinDrawFace(Sender: TObject; Rect: TRect): Boolean;
var
  State: Integer;
begin
  State := 0;
  if (FSkinPlugin <> nil) and (@FSkinPlugin.SLXDrawButtonFace <> nil) then
  begin
    if TSLNormalButton(Sender).Enabled then
      State := State or BS_ENABLED;
    if TSLNormalButton(Sender).Selected then
      State := State or BS_SELECTED;
    if TSLNormalButton(Sender).MouseEntered then
      State := State or BS_MOUSEENTERED;
    if TSLNormalButton(Sender).Active then
      State := State or BS_PADACTIVE;
    if TSLNormalButton(Sender).OwnerDraw then
      State := State or BS_ISDRAWPLUGIN;
    Result := FSkinPlugin.SLXDrawButtonFace(Handle, TSLNormalButton(Sender).Canvas.Handle, @Rect, State)
  end
  else
    Result := False;
end;

// �{�^���̘g�`��
function TfrmPad.btnSLButtonSkinDrawFrame(Sender: TObject; Rect: TRect): Boolean;
var
  State: Integer;
begin
  State := 0;
  if (FSkinPlugin <> nil) and (@FSkinPlugin.SLXDrawButtonFrame <> nil) then
  begin
    if TSLNormalButton(Sender).Enabled then
      State := State or BS_ENABLED;
    if TSLNormalButton(Sender).Selected then
      State := State or BS_SELECTED;
    if TSLNormalButton(Sender).MouseEntered then
      State := State or BS_MOUSEENTERED;
    if TSLNormalButton(Sender).Active then
      State := State or BS_PADACTIVE;
    if TSLNormalButton(Sender).OwnerDraw then
      State := State or BS_ISDRAWPLUGIN;
    Result := FSkinPlugin.SLXDrawButtonFrame(Handle, TSLNormalButton(Sender).Canvas.Handle, @Rect, State)
  end
  else
    Result := False;
end;

// �{�^���̃A�C�R���`��
function TfrmPad.btnSLButtonSkinDrawIcon(Sender: TObject; Rect: TRect): Boolean;
var
  State: Integer;
begin
  State := 0;
  if (FSkinPlugin <> nil) and (@FSkinPlugin.SLXDrawButtonIcon <> nil) then
  begin
    if TSLNormalButton(Sender).Enabled then
      State := State or BS_ENABLED;
    if TSLNormalButton(Sender).Selected then
      State := State or BS_SELECTED;
    if TSLNormalButton(Sender).MouseEntered then
      State := State or BS_MOUSEENTERED;
    if TSLNormalButton(Sender).Active then
      State := State or BS_PADACTIVE;
    if TSLNormalButton(Sender).OwnerDraw then
      State := State or BS_ISDRAWPLUGIN;
    Result := FSkinPlugin.SLXDrawButtonIcon(Handle, TSLNormalButton(Sender).Canvas.Handle, @Rect, TSLNormalButton(Sender).IconHandle, TSLNormalButton(Sender).IconHandle, State);
  end
  else
    Result := False;
end;

// �{�^���̃L���v�V�����`��
function TfrmPad.btnSLButtonSkinDrawCaption(Sender: TObject; Rect: TRect): Boolean;
var
  State: Integer;
begin
  State := 0;
  if (FSkinPlugin <> nil) and (@FSkinPlugin.SLXDrawButtonCaption <> nil) then
  begin
    if TSLNormalButton(Sender).Enabled then
      State := State or BS_ENABLED;
    if TSLNormalButton(Sender).Selected then
      State := State or BS_SELECTED;
    if TSLNormalButton(Sender).MouseEntered then
      State := State or BS_MOUSEENTERED;
    if TSLNormalButton(Sender).Active then
      State := State or BS_PADACTIVE;
    if TSLNormalButton(Sender).OwnerDraw then
      State := State or BS_ISDRAWPLUGIN;
    Result := FSkinPlugin.SLXDrawButtonCaption(Handle, TSLNormalButton(Sender).Canvas.Handle, @Rect, PChar(TSLNormalButton(Sender).Caption), State);
  end
  else
    Result := False;
end;

// �{�^���̃}�X�N�`��
function TfrmPad.btnSLButtonSkinDrawMask(Sender: TObject; Rect: TRect): Boolean;
var
  State: Integer;
begin
  State := 0;
  if (FSkinPlugin <> nil) and (@FSkinPlugin.SLXDrawButtonMask <> nil) then
  begin
    if TSLNormalButton(Sender).Enabled then
      State := State or BS_ENABLED;
    if TSLNormalButton(Sender).Selected then
      State := State or BS_SELECTED;
    if TSLNormalButton(Sender).MouseEntered then
      State := State or BS_MOUSEENTERED;
    if TSLNormalButton(Sender).Active then
      State := State or BS_PADACTIVE;
    if TSLNormalButton(Sender).OwnerDraw then
      State := State or BS_ISDRAWPLUGIN;
    Result := FSkinPlugin.SLXDrawButtonMask(Handle, TSLNormalButton(Sender).Canvas.Handle, @Rect, State);
  end
  else
    Result := False;
end;

// �v���O�C���{�^����OnDestroy
procedure TfrmPad.btnPluginButtonDestroy(Sender: TObject);
var
  Item: TButtonItem;
  Button: TSLPluginButton;
  PluginButton: TPluginButton;
  ButtonInfo: TButtonInfo;
begin
  if Plugins = nil then
    Exit;

  Button := Sender as TSLPluginButton;
  Item := FButtonArrangement.Items[Button.Tag];
  if Item <> nil then
  begin
    PluginButton := TPluginButton(Item.ButtonData);
    ButtonInfo := Plugins.FindButtonInfo(PluginButton.PluginName, PluginButton.No);
    if ButtonInfo <> nil then
      ButtonInfo.OutUpdateButton(Button);
  end;
end;

// �v���O�C���{�^����OnDrawButton
procedure TfrmPad.btnPluginButtonDrawButton(Sender: TObject; Rect: TRect;
  State: TButtonState);
var
  ButtonIndex: Integer;
  Item: TButtonItem;
  Plugin: TPlugin;
begin
  ButtonIndex := (Sender as TSLButton).Tag;
  Item := FButtonArrangement.Items[ButtonIndex];
  if Item <> nil then
  begin
    Plugin := Plugins.FindPlugin(TPluginButton(Item.ButtonData).PluginName);
    if @Plugin.SLXButtonDraw <> nil then
      Plugin.SLXButtonDraw(TPluginButton(Item.ButtonData).No, TSLPluginButton(Sender).Canvas.Handle, @Rect);
    if @Plugin.SLXButtonDrawEx <> nil then
      Plugin.SLXButtonDrawEx(TPluginButton(Item.ButtonData).No, Handle, GroupIndex, ButtonIndex,TSLPluginButton(Sender).Canvas.Handle, @Rect);
  end;
end;

// �J�����g�{�^����\��
procedure TfrmPad.CurrentMakeVisible;
var
  CurrentRow: Integer;
begin
  CurrentRow := FButtonArrangement.CurrentRow;
  if CurrentRow < 0 then
    Exit;

  if CurrentRow < TopLineIndex then
    TopLineIndex := CurrentRow;

  if FBtnVertical then
  begin
    if FButtonArrangement.CurrentRow >= TopLineIndex + Cols then
      TopLineIndex := FButtonArrangement.CurrentRow - Cols + 1;
  end
  else
  begin
    if FButtonArrangement.CurrentRow >= TopLineIndex + Rows then
      TopLineIndex := FButtonArrangement.CurrentRow - Rows + 1;
  end;
  EnabledCheckScrolls;
end;


// �^�C�g����\��
procedure TfrmPad.CurrentTitle;
var
  Item: TButtonItem;
  TitleRect: TRect;
  Title: string;

  Plugin: TPlugin;
  ButtonInfo: TButtonInfo;
  OwnerChip: Boolean;
  cWork: array[0..255] of Char;
begin
  Item := FButtonArrangement.CurrentItem;

  if Item = nil then
    Exit;
  if Item.SLButton = nil then
    Exit;

  // ��ʂ̊O
  if FButtonArrangement.CurrentRow < TopLineIndex then
    Exit;
  if (FBtnVertical and (FButtonArrangement.CurrentRow >= TopLineIndex + Cols)) or
    (not FBtnVertical and (FButtonArrangement.CurrentRow >= TopLineIndex + Rows)) then
    Exit;

  TitleRect := Item.SLButton.ClientRect;
  TitleRect.TopLeft := Item.SLButton.ClientToScreen(TitleRect.TopLeft);
  TitleRect.BottomRight := Item.SLButton.ClientToScreen(TitleRect.BottomRight);

  OwnerChip := False;
  // �v���O�C��
  if Item.ButtonData is TPluginButton then
  begin
    with TPluginButton(Item.ButtonData) do
    begin
      Plugin := Plugins.FindPlugin(PluginName);
      ButtonInfo := Plugins.FindButtonInfo(PluginName, No);
      if (ButtonInfo <> nil) and ButtonInfo.OwnerChip then
      begin
        OwnerChip := True;
        cWork := '';
        if @Plugin.SLXButtonChip <> nil then
          Plugin.SLXButtonChip(No, cWork, 256);
        Title := cWork;
      end;
    end;
  end;

  if not OwnerChip then
    if (Item.SLButton.CaptionPosition = cpNone) or Item.SLButton.NarrowText then
      Title := Item.ButtonData.Name;

  if Title <> '' then
    ShowTitle(Self, Title, TitleRect);
end;


// �J�����g�{�^�����N���b�N
procedure TfrmPad.CurBtnClick;
var
  Item: TButtonItem;
  Plugin: TPlugin;
  PluginButton: TPluginButton;
  ButtonInfo: TButtonInfo;
  SoundFile: String;
begin
  if GetKeyState(VK_SHIFT) < 0 then
  begin
    popButtonFolder.Click;
    Exit;
  end;
  if GetKeyState(VK_MENU) < 0 then
  begin
    popButtonModify.Click;
    Exit;
  end;



  Item := FButtonArrangement.CurrentItem;

  if Item = nil then
    Exit;
  if Item.SLButton = nil then
    Exit;

  if Item.ButtonData <> nil then
    Item.ButtonData.ClickCount := Item.ButtonData.ClickCount + 1;

  SoundFile := UserIniFile.ReadString(IS_SOUNDS, 'ButtonClick', '');
  if SoundFile <> '' then
    PlaySound(PChar(SoundFile), 0, SND_ASYNC);

  // �m�[�}���{�^��
  if Item.ButtonData is TNormalButton then
  begin
    // NT�Ȃ�X���b�h�ɂ���
//    if OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
//      TOpenNormalButtonThread.Create(Handle, TNormalButton(Item.ButtonData))
//    else
      OpenNormalButton(Handle, TNormalButton(Item.ButtonData));
  end

  // �v���O�C���{�^��
  else if Item.ButtonData is TPluginButton then
  begin
    PluginButton := TPluginButton(Item.ButtonData);
    Plugin := Plugins.FindPlugin(PluginButton.PluginName);
    if Plugin <> nil then
    begin
      if @Plugin.SLXButtonClick <> nil then
        if Plugin.SLXButtonClick(PluginButton.No, Self.Handle) then
        begin
          ButtonInfo := Plugins.FindButtonInfo(PluginButton.PluginName, PluginButton.No);
          ButtonInfo.UpdateButtonsUpdate;
        end;
    end;
  end;

end;


// �{�^���O���[�v���j���[��z�u
procedure TfrmPad.ArrangeGroupMenu;
var
  i: Integer;
  MenuItem: TMenuItem;
begin
  // �{�^���O���[�v���j���[���폜
  while popGroup.Count > 0 do
    popGroup[0].Free;

  if FForeground then
  begin
    if (not Pads.CtrlTabActivate) then
    begin
      i := Pads.IndexOf(Self);
      if i >= 0 then
        Pads.Move(i, 0);
    end;

    // �{�^���O���[�v���j���[���쐬
    i := 0;
    while i < FButtonGroups.Count do
    begin
      MenuItem := TMenuItem.Create(Self);
      MenuItem.RadioItem := True;
      if FButtonGroup = FButtonGroups[i] then
        MenuItem.Checked := True;
      if i < 9 then
      begin
        MenuItem.Caption := '&' + IntToStr(i + 1) + ' ' + FButtonGroups[i].Name;
        MenuItem.ShortCut := Menus.ShortCut((i + 1) mod 10 + Ord('0'), [ssCtrl]);
      end
      else
        MenuItem.Caption := '- ' + FButtonGroups[i].Name;
      MenuItem.Tag := i;
      MenuItem.OnClick := popGroupItemClick;
      popGroup.Add(MenuItem);

      Inc(i);
    end;
  end;

  if FButtonGroup <> nil then
    Caption := FButtonGroup.Name + ' - Special Launch'
  else
    Caption := 'Special Launch';
  FfrmPadTab.Caption := Caption + '(Hid)';
  
end;

// �v���O�C�����j���[��z�u
procedure TfrmPad.ArrangePluginMenu;
var
  i, j, AddIndex: Integer;
  Plugin: TPlugin;
  MenuItem: TMenuItem;
begin
  AddIndex := popPluginBegin.MenuIndex + 1;
  while popMain.Items[AddIndex] <> popPluginEnd do
    popMain.Items.Delete(AddIndex);

  for i := 0 to Plugins.Count - 1 do
  begin
    Plugin := TPlugin(Plugins.Objects[i]);

    if Plugin.Menus.Count > 0 then
    begin
      for j := 0 to Plugin.Menus.Count - 1 do
      begin
        MenuItem := TMenuItem.Create(Self);
        MenuItem.Caption := TMenuInfo(Plugin.Menus[j]).Name;
        MenuItem.ShortCut := TextToShortCut(TMenuInfo(Plugin.Menus[j]).SCut);
        MenuItem.OnClick := popPluginMenuClick;
        if j = 0 then
        begin
          MenuItem.Tag := i;
          popMain.Items.Insert(AddIndex, MenuItem);
          Inc(AddIndex);
        end
        else
        begin
          MenuItem.Tag := j;
          popMain.Items[AddIndex - 1].Add(MenuItem);
        end;
      end;
    end;
  end;
end;

// �v���O�C�����j���[��OnClick
procedure TfrmPad.popPluginMenuClick(Sender: TObject);
var
  MenuItem: TMenuItem;
  Plugin: TPlugin;
begin
  MenuItem := TMenuItem(Sender);
  // �e
  if MenuItem.Parent = popMain.Items then
  begin
    if (MenuItem.Tag >= 0) and (MenuItem.Tag < Plugins.Count) then
    begin
      Plugin := TPlugin(Plugins.Objects[MenuItem.Tag]);
      if @Plugin.SLXMenuClick <> nil then
        Plugin.SLXMenuClick(0, Handle);
    end;
  end
  // �q
  else
  begin
    if (MenuItem.Parent.Tag >= 0) and (MenuItem.Parent.Tag < Plugins.Count) then
    begin
      Plugin := TPlugin(Plugins.Objects[MenuItem.Parent.Tag]);
      if @Plugin.SLXMenuClick <> nil then
        Plugin.SLXMenuClick(MenuItem.Tag, Handle);
    end;
  end;
end;

// �{�^���̒ǉ�
procedure TfrmPad.AddSingleButtonData(ButtonData: TButtonData; Index: Integer);
begin
  if GetLockBtnEdit(True) then
  begin
    Exit;
  end;

  if FButtonGroup = nil then
  begin
    ButtonData.Free;
    Exit;
  end;

  if Index < 0 then
    Index := 0;
  if (FButtonGroup.Count = 0) or (Index >= FButtonGroup.Count) then
    Index := FButtonGroup.Add(ButtonData)
  else
    FButtonGroup.Insert(Index, ButtonData);
  ButtonArrangement.Arrange;
  ButtonIndex := Index;

  SaveBtn;
//  Pads.Save;
end;

// �����̃{�^���̒ǉ�
procedure TfrmPad.AddMultiButtonData(AButtonGroup: TButtonGroup; Index: Integer);
var
  i: Integer;
begin
  if GetLockBtnEdit(True) then
  begin
    Exit;
  end;


  if FButtonGroup = nil then
  begin
    AButtonGroup.Clear(True);
    Exit;
  end;

  if AButtonGroup.Count = 0 then
    Exit;

  if Index < 0 then
    Index := 0;
  for i := AButtonGroup.Count - 1 downto 0 do
  begin
    if (FButtonGroup.Count = 0) or (Index >= FButtonGroup.Count) then
      Index := FButtonGroup.Add(AButtonGroup[i])
    else
      FButtonGroup.Insert(Index, AButtonGroup[i]);
  end;
  AButtonGroup.Clear(False);
  ButtonArrangement.Arrange;
  ButtonIndex := Index;

  SaveBtn;
//  Pads.Save;
end;

// �{�^���̕ύX
procedure TfrmPad.ModifyButtonData(ButtonData: TButtonData);
var
  OldData: TButtonData;
begin
  if GetLockBtnEdit(True) then
  begin
    Exit;
  end;

  if FButtonGroup = nil then
    Exit;
  if ButtonIndex < 0 then
    Exit;

  // �n�߂�TSLButton�������Ă����Ȃ���TSLPluginButton��OnDestroy�ŃG���[���o��
  ButtonArrangement.Clear;
  OldData := FButtonGroup[ButtonIndex];
  FButtonGroup[ButtonIndex] := ButtonData;
  OldData.Free;
  ButtonArrangement.Arrange;

  SaveBtn;
//  Pads.Save;
end;

// �{�^���폜�̊m�F
function TfrmPad.QuestDeleteButton(Index: Integer; Copy: Boolean): Boolean;
var
  Name: String;
begin
  Result := False;
  if FButtonGroup = nil then
    Exit;

  if (Index >= 0) and (Index < FButtonGroup.Count) then
  begin
    if FButtonGroup[Index] is TSpaceButton then
      Name := '��'
    else if FButtonGroup[Index] is TReturnButton then
      Name := '���s'
    else
      Name := FButtonGroup[Index].Name;
    if Copy then
      Result := MessageBox(Handle, PChar('"' + Name + '" ���N���b�v�{�[�h�ɐ؂���܂��B'),
        '�m�F', MB_ICONINFORMATION or MB_OKCANCEL) = idOk
    else
      Result := MessageBox(Handle, PChar('"' + Name + '" ���폜���܂��B'),
        '�m�F', MB_ICONINFORMATION or MB_OKCANCEL) = idOk;
  end;
end;

// �{�^���̍폜
procedure TfrmPad.DeleteButtonData(Index: Integer);
begin

  if GetLockBtnEdit(True) then
  begin
    Exit;
  end;

  if FButtonGroup = nil then
    Exit;

  BeginUpdate;
  try
    // �n�߂�TSLButton�������Ă����Ȃ���TSLPluginButton��OnDestroy�ŃG���[���o��
    ButtonArrangement.Clear;
    if (Index >= 0) and (Index < FButtonGroup.Count) then
    begin
      FButtonGroup[Index].Free;
      FButtonGroup.Delete(Index);
    end;
    ButtonArrangement.Arrange;
    ButtonIndex := Index;
  finally
    EndUpdate;
  end;

  SaveBtn;
//  Pads.Save;
end;

// �{�^���̃R�s�[
procedure TfrmPad.CopyButtonData(Index: Integer);
var
  AButtonGroup: TButtonGroup;
  DataObject: IDataObject;
begin
  if FButtonGroup = nil then
    Exit;
  if (Index < 0) or (Index >= FButtonGroup.Count) then
    Exit;

  AButtonGroup := TButtonGroup.Create;
  try
    AButtonGroup.Add(FButtonGroup[Index]);
    DataObject := TButtonGroupDataObject.Create(AButtonGroup);
    OleSetClipBoard(DataObject);
  finally
    AButtonGroup.Clear(False);
    AButtonGroup.Free;
  end;
end;

// �_�C�A���O�{�b�N�X�J��
procedure TfrmPad.SetDialogBox(Value: TForm);
begin
  FDialogBox := Value;

  // TopMost�����蓖�ĂȂ����i�_�C�A���O�{�b�N�X������Ƃ��͍őO�ʂ���Ȃ��j
  TopMost := TopMost;
  // �z�b�g�L�[�����蓖�ĂȂ����i�_�C�A���O�{�b�N�X������Ƃ��̓z�b�g�L�[�͎g��Ȃ��j
  Hotkey := Hotkey;
end;

// �e�_�C�A���O�{�b�N�X��OnClosed
procedure TfrmPad.DialogBoxClosed(Sender: TObject);
begin
{
  if Sender is TdlgPadProperty then
  begin
    PropertyPageNo := TdlgPadProperty(Sender).PageControl.ActivePage.PageIndex;
  end;
}
  DialogBox := nil;
  Enabled := True;
  Show;
end;

// �e�_�C�A���O�{�b�N�X��OnWindowActivate
procedure TfrmPad.DialogBoxWindowActivate(Sender: TObject);
begin
  Foreground := True;
end;

// �e�_�C�A���O�{�b�N�X��OnWindowDeactivate
procedure TfrmPad.DialogBoxWindowDeactivate(Sender: TObject);
begin
  Foreground := False;
end;


// �{�^���ҏW�̓K�p
procedure TfrmPad.dlgButtonEditApply(Sender: TObject);
var
  i: Integer;
  dlgButtonEdit: TdlgButtonEdit;
  NewOldGroup: TNewOldGroup;
begin
  dlgButtonEdit := TdlgButtonEdit(Sender);
  i := 0;
  while i < dlgButtonEdit.lvGroups.Items.Count do
  begin
    NewOldGroup := TNewOldGroup(dlgButtonEdit.lvGroups.Items[i].Data);
    if ButtonGroup = NewOldGroup.Old then
    begin
      ButtonGroup := NewOldGroup.New;
      Break;
    end;

    Inc(i);
  end;
  if i >= dlgButtonEdit.lvGroups.Items.Count then
    ButtonGroup := TNewOldGroup(dlgButtonEdit.lvGroups.Items[0].Data).New;

  FButtonGroups.Clear(True);
  for i := 0 to dlgButtonEdit.lvGroups.Items.Count - 1 do
  begin
    NewOldGroup := TNewOldGroup(dlgButtonEdit.lvGroups.Items[i].Data);
    FButtonGroups.Add(NewOldGroup.New);
    NewOldGroup.Old := NewOldGroup.New;
    NewOldGroup.New := TButtonGroup.Create;
    NewOldGroup.New.Assign(NewOldGroup.Old);
  end;

  EnabledCheckScrolls;
  SaveBtn;
//  Pads.Save;
end;

// �{�^���ҏW���j���[
procedure TfrmPad.popButtonEditClick(Sender: TObject);
var
  i: Integer;
  NewOldGroup: TNewOldGroup;
  dlgButtonEdit: TdlgButtonEdit;
begin
  if GetLockBtnEdit(True) then
  begin
    Exit;
  end;


  if FDialogBox = nil then
  begin
    dlgButtonEdit := TdlgButtonEdit.Create(nil);
    DialogBox := dlgButtonEdit;

    dlgButtonEdit.OnApply := dlgButtonEditApply;
    dlgButtonEdit.OnClosed := DialogBoxClosed;
    dlgButtonEdit.OnWindowActivate := DialogBoxWindowActivate;
    dlgButtonEdit.OnWindowDeactivate := DialogBoxWindowDeactivate;
    dlgButtonEdit.SetOriginalGroups(FButtonGroups);

    for i := 0 to dlgButtonEdit.lvGroups.Items.Count - 1 do
    begin
      NewOldGroup := dlgButtonEdit.lvGroups.Items[i].Data;
      if FButtonGroup = NewOldGroup.Old then
      begin
        dlgButtonEdit.lvGroups.Items[i].Selected := True;
        dlgButtonEdit.lvGroups.Items[i].Focused := True;
      end;
    end;

    dlgButtonEdit.Show;
    Enabled := False;
  end;
end;

// �{�^���̃v���p�e�B�K�p
procedure TfrmPad.dlgBtnPropertyApply(Sender: TObject);
var
  NewData: TButtonData;
begin
  if FButtonGroup = nil then
    Exit;

  with (Sender as TdlgBtnProperty) do
  begin
    NewData := CreateResultButton;
    if NewData <> nil then
    begin
      if AddMode or (ButtonIndex < 0) then
        AddSingleButtonData(NewData, ButtonIndex)
      else
        ModifyButtonData(NewData);
    end;
  end;
end;

// �{�^���̒ǉ�
procedure TfrmPad.popButtonAddClick(Sender: TObject);
var
  dlgBtnProperty: TdlgBtnProperty;
begin
  if GetLockBtnEdit(True) then
  begin
    Exit;
  end;

  if FDialogBox = nil then
  begin
    Enabled := False;
    dlgBtnProperty := TdlgBtnProperty.Create(nil);
    DialogBox := dlgBtnProperty;

    dlgBtnProperty.OnApply := dlgBtnPropertyApply;
    dlgBtnProperty.OnClosed := DialogBoxClosed;
    dlgBtnProperty.OnWindowActivate := DialogBoxWindowActivate;
    dlgBtnProperty.OnWindowDeactivate := DialogBoxWindowDeactivate;
    dlgBtnProperty.SetOriginalButton(nil);
    dlgBtnProperty.Show;
  end;
end;

// �{�^���̕ύX
procedure TfrmPad.popButtonModifyClick(Sender: TObject);
var
  dlgBtnProperty: TdlgBtnProperty;
begin
  if GetLockBtnEdit(True) then
  begin
    Exit;
  end;

  if FButtonArrangement.CurrentItem = nil then
    Exit;

  if FDialogBox = nil then
  begin
    dlgBtnProperty := TdlgBtnProperty.Create(nil);
    DialogBox := dlgBtnProperty;

    dlgBtnProperty.OnApply := dlgBtnPropertyApply;
    dlgBtnProperty.OnClosed := DialogBoxClosed;
    dlgBtnProperty.OnWindowActivate := DialogBoxWindowActivate;
    dlgBtnProperty.OnWindowDeactivate := DialogBoxWindowDeactivate;
    dlgBtnProperty.SetOriginalButton(FButtonArrangement.CurrentItem.ButtonData);
    dlgBtnProperty.Show;
    Enabled := False;
  end;
end;

// �{�^���P��̃t�H���_���J��
procedure TfrmPad.popButtonFolderClick(Sender: TObject);
var
  Item: TButtonItem;
begin
  if GetLockBtnFolder(True) then
  begin
    Exit;
  end;

  Item := FButtonArrangement.CurrentItem;

  if Item = nil then
    Exit;
  if Item.SLButton = nil then
    Exit;

  // �m�[�}���{�^��
  if Item.ButtonData is TNormalButton then
  begin
    if not OpenNormalButtonFolder(Handle, TNormalButton(Item.ButtonData)) then
    begin
      MessageBox(Handle, '�P��̃t�H���_�͊J���܂���B', '�G���[', MB_ICONERROR);
    end;
  end
  else
    MessageBox(Handle, '�P��̃t�H���_�͊J���܂���B', '�G���[', MB_ICONERROR);
end;

// �{�^���؂���
procedure TfrmPad.popButtonCutClick(Sender: TObject);
begin
  if QuestDeleteButton(ButtonIndex, True) then
  begin
    CopyButtonData(ButtonIndex);
    DeleteButtonData(ButtonIndex);
  end;
end;

// �{�^���R�s�[
procedure TfrmPad.popButtonCopyClick(Sender: TObject);
begin
  CopyButtonData(ButtonIndex);
end;

// �{�^���\��t��
procedure TfrmPad.popButtonPasteClick(Sender: TObject);
var
  DataObject: IDataObject;
  PasteButtons: TButtonGroup;
begin
  if S_OK = OleGetClipboard(DataObject) then
  begin
    PasteButtons := TButtonGroup.Create;
    try
      DataObjectToButtonGroup(DataObject, PasteButtons);
      AddMultiButtonData(PasteButtons, ButtonIndex);
    finally
      PasteButtons.Free;
    end;
  end;
end;

// �{�^���󔒂̑}��
procedure TfrmPad.popButtonSpaceClick(Sender: TObject);
var
  ButtonData: TButtonData;
  IndexBk: Integer;
begin
  IndexBk := ButtonIndex;
  ButtonData := TSpaceButton.Create;
  BeginUpdate;
  try
    AddSingleButtonData(ButtonData, ButtonIndex);
    ButtonIndex := IndexBk + 1
  finally
    EndUpdate;
  end;
end;

// �{�^�����s�̑}��
procedure TfrmPad.popButtonReturnClick(Sender: TObject);
var
  ButtonData: TButtonData;
  IndexBk: Integer;
begin
  IndexBk := ButtonIndex;
  ButtonData := TReturnButton.Create;
  BeginUpdate;
  try
    AddSingleButtonData(ButtonData, ButtonIndex);
    ButtonIndex := IndexBk + 1
  finally
    EndUpdate;
  end;
end;

// �{�^���폜
procedure TfrmPad.popButtonDeleteClick(Sender: TObject);
begin
  if QuestDeleteButton(ButtonIndex, False) then
    DeleteButtonData(ButtonIndex);
end;

// �P�O���폜
procedure TfrmPad.popButtonBackSpaceClick(Sender: TObject);
begin
  if QuestDeleteButton(ButtonIndex - 1, False) then
    DeleteButtonData(ButtonIndex - 1);
end;

// �P����폜
procedure TfrmPad.popButtonNextDeleteClick(Sender: TObject);
var
  IndexBk: Integer;
begin
  if QuestDeleteButton(ButtonIndex + 1, False) then
  begin
    IndexBk := ButtonIndex;
    BeginUpdate;
    try
      DeleteButtonData(ButtonIndex + 1);
      ButtonIndex := IndexBk;
    finally
      EndUpdate;
    end;
  end;
end;

// �ǎ��`��
procedure TfrmPad.pbWallPaper1Paint(Sender: TObject);
var
  x, y, mx, my: Integer;
  ARect: TRect;
begin
  // �X�L���ɂ��`��
  if (SkinPlugin <> nil) and (@SkinPlugin.SLXDrawWorkspace <> nil) then
  begin
    ARect := (Sender as TPaintBox).ClientRect;
    if Sender = pbWallPaper1 then
    begin
      if SkinPlugin.SLXDrawWorkspace(Handle, (Sender as TPaintBox).Canvas.Handle, @ARect, FForeground, False) then
        Exit;
    end;
    if Sender = pbWallPaper2 then
    begin
      if SkinPlugin.SLXDrawWorkspace(Handle, (Sender as TPaintBox).Canvas.Handle, @ARect, FForeground, True) then
        Exit;
    end;
  end;

  if FWallPaperBitmap = nil then
    Exit;

  with (Sender as TPaintBox).Canvas do
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
end;

// �{�^���̃h���b�O
procedure TfrmPad.DragButtonData(Index: Integer);
var
  ButtonData: TButtonData;
  DropSource: IDropSource;
  DataObject: IDataObject;
  dwEffect: Longint;
begin
  if FButtonGroup = nil then
    Exit;
  if (Index < 0) or (Index >= FButtonGroup.Count) then
    Exit;

  DragButtonGroup := FButtonGroup;
  if DragButtons <> nil then
    DragButtons.Clear(False)
  else
    DragButtons := TButtonGroup.Create;
  DropSource := TDropSource.Create;
  try
    ButtonData := FButtonGroup[Index];
    DragButtons.Add(ButtonData);
    DataObject := TButtonGroupDataObject.Create(DragButtons);
    if DoDragDrop(DataObject, DropSource, DROPEFFECT_MOVE or DROPEFFECT_COPY,
      dwEffect) = DRAGDROP_S_DROP then
    begin
      if (dwEffect = DROPEFFECT_MOVE) and (DragButtons.Count > 0) then
      begin
        // �Ⴄ�p�b�h�Ńh���b�v����
        if FButtonGroup = DragButtonGroup then
          DeleteButtonData(FButtonGroup.IndexOf(ButtonData))
        else
        // �Ⴄ�{�^���O���[�v�Ƀh���b�v����
        begin
          DragButtonGroup.Remove(ButtonData);
          ButtonData.Free;
          SaveBtn;
//          Pads.Save;
        end;
      end;
    end;
  finally
    DragButtonGroup := nil;
    DragButtons.Clear(False);
    DragButtons.Free;
    DragButtons := nil;
  end;

end;

// �h���b�v��t
function Tfrmpad.GetDropEnabled: Boolean;
begin
  Result := FDropTarget <> nil;
end;

// �h���b�v��t
procedure TfrmPad.SetDropEnabled(Value: Boolean);
var
  FormatEtc: array[0..4] of TFormatEtc;
  i: Integer;
begin
  if DropEnabled = Value then
    Exit;

  if Value then
  begin
    for i := 0 to 4 do
    begin
      with FormatEtc[i] do
      begin
        dwAspect := DVASPECT_CONTENT;
        ptd := nil;
        tymed := TYMED_HGLOBAL;
        lindex := -1;
      end;
    end;
    FormatEtc[0].cfFormat := CF_SLBUTTONS;
    FormatEtc[1].cfFormat := CF_HDROP;
    FormatEtc[2].cfFormat := CF_IDLIST;
    FormatEtc[3].cfFormat := CF_SHELLURL;
    FormatEtc[4].cfFormat := CF_NETSCAPEBOOKMARK;

    FDropTarget := TDropTarget.Create(@FormatEtc, 5);
    FDropTarget.OnDragEnter := OleDragEnter;
    FDropTarget.OnDragOver := OleDragOver;
    FDropTarget.OnDragLeave := OleDragLeave;
    FDropTarget.OnDragDrop := OleDragDrop;

    CoLockObjectExternal(FDropTarget, True, False);
    RegisterDragDrop(Handle, FDropTarget);
  end
  else
  begin
    RevokeDragDrop(Handle);
    CoLockObjectExternal(FDropTarget, False, True);
    FDropTarget := nil;
  end;
end;

// �h���b�O����
procedure TfrmPad.OleDragEnter(var DataObject: IDataObject;
  KeyState: Integer; Point: TPoint; var dwEffect: Integer);
begin
  FDropRButton := (KeyState and MK_RBUTTON) <> 0;

  // �{�^���O���[�v���h���b�v
  if DataObjectIsButtonGroup(DataObject) then
  begin
    if dwEffect = DROPEFFECT_LINK then
      dwEffect := DROPEFFECT_COPY;
  end
  else
    dwEffect := DROPEFFECT_COPY or DROPEFFECT_LINK;
end;

// �h���b�O�I�[�o�[
procedure TfrmPad.OleDragOver(var DataObject: IDataObject;
  KeyState: Integer; Point: TPoint; var dwEffect: Integer);
var
  Ctr: TControl;
begin
  Ctr := FindDragTarget(Point, False);
  if Ctr <> FDropTargetControl then
  begin
    FDropTargetControl := Ctr;
    FDropTargetTimer.Free;
    FDropTargetTimer := nil;

    if FDropTargetControl is TSLScrollButton then
    begin
      FDropTargetTimer := TTimer.Create(Self);
      FDropTargetTimer.Interval := 500;
      FDropTargetTimer.OnTimer := DropTargetTimerTimer;
      FDropTargetTimer.Enabled := True;
    end;

    if FDropTargetControl is TSLButton then
    begin
      TSLButton(FDropTargetControl).MouseEntered := True;
      if FDropTargetControl is TSLNormalButton then
      begin
        ButtonIndex := TSLNormalButton(FDropTargetControl).Tag;
        FCurrentColBack := FButtonArrangement.CurrentCol;
      end;
    end;
  end;

  // �{�^���O���[�v���h���b�v
  if DataObjectIsButtonGroup(DataObject) then
  begin
    if dwEffect = DROPEFFECT_LINK then
      dwEffect := DROPEFFECT_COPY;
  end
  else
    dwEffect := DROPEFFECT_COPY or DROPEFFECT_LINK;
end;

// �h���b�O���Ƀ}�E�X�|�C���^�ʒu�̃{�^���������^�C�}�[
procedure TfrmPad.DropTargetTimerTimer(Sender: TObject);
var
  TergetScrollButton: TSLScrollButton;
begin
  if not (FDropTargetControl is TSLScrollButton) then
  begin
    FDropTargetTimer.Free;
    FDropTargetTimer := nil;
    Exit;
  end;

  TergetScrollButton := FDropTargetControl as TSLScrollButton;

  if FDropTargetTimer.Interval = 500 then
  begin
    case TergetScrollButton.Tag of
      0, 4:
        FDropTargetTimer.Interval := 800;
      1..2:
        FDropTargetTimer.Interval := 400;
    end;
  end
  else
  begin
    case TergetScrollButton.Tag of
      0, 4:
        FDropTargetTimer.Interval := 600;
      1..2:
        FDropTargetTimer.Interval := 150;
    end;
  end;

  if FDropTargetControl is TSLScrollButton then
  begin
    TSLScrollButton(FDropTargetControl).Click;
  end;
end;

// �h���b�O�����
procedure TfrmPad.OleDragLeave;
begin
  FDropTargetTimer.Free;
  FDropTargetTimer := nil;
end;

// �h���b�O�h���b�v
procedure TfrmPad.OleDragDrop(var DataObject: IDataObject;
  KeyState: Integer; Point: TPoint; var dwEffect: Integer);
var
  PointByBtn: TPoint;
  Col, Row: Integer;
  Item: TButtonItem;

  I, J: Integer;
  RemoveIndex: Integer;
  SameLine: Boolean;
  IsButtonGroup: Boolean;
  TargetButtonData: TButtonData;
  PluginFileList: TStringList;
  PluginFile: string;
begin
  SetForegroundWindow(Handle);

  FDropTargetTimer.Free;
  FDropTargetTimer := nil;

  // �h���b�v�����ꏊ���m��
  PointByBtn := pnlButtons.ScreenToClient(Point);
  if PointByBtn.x < 0 then
    PointByBtn.x := PointByBtn.x - BtnFrameWidth;
  if PointByBtn.y < 0 then
    PointByBtn.y := PointByBtn.y - BtnFrameHeight;
  if FBtnVertical then
  begin
    Col := PointByBtn.y div BtnFrameHeight;
    Row := PointByBtn.x div BtnFrameWidth;
  end
  else
  begin
    Col := PointByBtn.x div BtnFrameWidth;
    Row := PointByBtn.y div BtnFrameHeight;
  end;

  Item := FButtonArrangement[Col, Row];
  if Item = nil then
  begin
    if Row < 0 then
      FDropIndex := -1
    else if Row >= FButtonArrangement.Rows then
      FDropIndex := FButtonGroup.Count
    else
    begin
      if Col <= 0 then
        Item := FButtonArrangement[0, Row]
      else
        Item := FButtonArrangement[0, Row + 1];
      if Item <> nil then
        FDropIndex := FButtonArrangement.IndexOfItem(Item)
      else
        FDropIndex := FButtonGroup.Count;
    end;
  end
  else
  begin
    FDropIndex := FButtonArrangement.IndexOfItem(Item);
  end;


  if FDropButtons = nil then
    FDropButtons := TButtonGroup.Create;

  try
    FDropButtons.Clear(True);
    DataObjectToButtonGroup(DataObject, FDropButtons);

    IsButtonGroup := DataObjectIsButtonGroup(DataObject);
    // ButtonGroup���ړ��i�����v���Z�X����̃h���b�O�̂݁j
    if (dwEffect = DROPEFFECT_MOVE) and IsButtonGroup and (DragButtonGroup <> nil) then
    begin
      if (FDropIndex >= 0) and (FDropIndex < FButtonGroup.Count) then
        TargetButtonData := FButtonGroup[FDropIndex]
      else
        TargetButtonData := nil;

      // �h���b�O���ƃh���b�v�悪�����Ȃ�h���b�v���Ȃ�
      if DragButtonGroup = FButtonGroup then
      begin
        for i := 0 to DragButtons.Count - 1 do
        begin
          if TargetButtonData = DragButtons[i] then
          begin
            dwEffect := DROPEFFECT_NONE;
            Break;
          end;
        end;
      end;

      if dwEffect <> DROPEFFECT_NONE then
      begin
        BeginUpdate;
        try
          if DragButtonGroup = FButtonGroup then
          begin
            // �����s�Ō��Ƀh���b�v�����m�F
            SameLine := False;
            if FDropIndex < FButtonGroup.Count then
            begin
              for i := 0 to DragButtons.Count - 1 do
              begin
                j := FButtonGroup.IndexOf(DragButtons[i]);
                if j <= FDropIndex then
                begin
                  while j <= FDropIndex do
                  begin
                    if FButtonGroup[j] is TReturnButton then
                      Break;
                    Inc(j);
                  end;
                  if j > FDropIndex then
                  begin
                    SameLine := True;
                    Break;
                  end;
                end;
              end;
            end;
            // �n�߂�TSLButton�������Ă����Ȃ���TSLPluginButton��OnDestroy�ŃG���[���o��
            ButtonArrangement.Clear;
            // �h���b�O�����{�^��������
            for i := 0 to DragButtons.Count - 1 do
            begin
              RemoveIndex := FButtonGroup.IndexOf(DragButtons[i]);
              if RemoveIndex >= 0 then
              begin
                FButtonGroup.Delete(RemoveIndex);
                DragButtons[i].Free;
              end;
            end;
            DragButtons.Clear(False);
            ButtonArrangement.Arrange;

            if TargetButtonData <> nil then
              FDropIndex := FButtonGroup.IndexOf(TargetButtonData);

            // �����s�Ō��Ƀh���b�v�Ȃ�P���炷
            if SameLine then
              Inc(FDropIndex);
          end;

        finally
          DoDropAction(DA_ADDHERE);
          EndUpdate;
        end;
      end;
    end
    // ButtonGroup���R�s�[
    else if (dwEffect = DROPEFFECT_COPY) and IsButtonGroup then
    begin
      DoDropAction(DA_ADDHERE);
    end
    else
    // �G�N�X�v���[������h���b�v
    begin
      dwEffect := DROPEFFECT_COPY or DROPEFFECT_LINK;

      // �v���O�C�����h���b�v���ꂽ�����`�F�b�N
      PluginFileList := TStringList.Create;
      try
        for I := 0 to FDropButtons.Count - 1 do
        begin
          if FDropButtons[i] is TNormalButton then
          begin
            PluginFile := TNormalButton(FDropButtons[i]).FileName;
            if LowerCase(ExtractFileExt(PluginFile)) = '.slx' then
            begin
              PluginFileList.Add(PluginFile);
            end;
          end;

        end;

        if PluginFileList.Count > 0 then
          DropPluginFile(PluginFileList)
        else if FDropRButton then
          popRightDrop.Popup(Point.x, Point.y)
        else
          DoDropAction(DropAction);

      finally
        PluginFileList.Free;
      end;
    end;
  except
    FDropButtons.Free;
    FDropButtons := nil;
  end;
end;

// �E�{�^���ł̃t�@�C���h���b�v�̃��j���[�|�b�v�A�b�v
procedure TfrmPad.popRightDropPopup(Sender: TObject);
var
  i: Integer;
  LockBtnEdit: Boolean;
begin
  LockBtnEdit := GetLockBtnEdit(False);
  popDropAddHere.Enabled := not LockBtnEdit;
  popDropAddHere.Visible := not LockBtnEdit;
  popDropAddLast.Enabled := not LockBtnEdit;
  popDropAddLast.Visible := not LockBtnEdit;

  for i := 0 to popRightDrop.Items.Count - 1 do
    popRightDrop.Items[i].Default := (popRightDrop.Items[i].Tag = DropAction) and
      (popRightDrop.Items[i].Caption <> '-');
end;

// �E�{�^���ł̃t�@�C���h���b�v�̃A�N�V����
procedure TfrmPad.popRightDropAction(Sender: TObject);
begin
  DoDropAction(TMenuItem(Sender).Tag);
end;

// �t�@�C���h���b�v�̃A�N�V����
procedure TfrmPad.DoDropAction(Action: Integer);
var
  i: Integer;
  FileName: string;
  Files: string;
  Option: string;
  DropButton: TButtonData;
  NormalButton: TNormalButton;
  PluginButton: TPluginButton;
  Plugin: TPlugin;
  ButtonInfo: TButtonInfo;
begin
  if FDropButtons = nil then
    Exit;

  case Action of
    // �����ɒǉ�
    DA_ADDHERE:
    begin
      AddMultiButtonData(FDropButtons, FDropIndex);
    end;

    // �Ō�ɒǉ�
    DA_ADDLAST:
    begin
      AddMultiButtonData(FDropButtons, FButtonGroup.Count);
    end;

    // �����ŊJ��
    DA_OPENHERE:
    begin
      if (FDropIndex >= 0) and (FDropIndex < FButtonGroup.Count) then
        DropButton := FButtonGroup[FDropIndex]
      else
        DropButton := nil;

      if DropButton <> nil then
      begin
        Files := '';
        if DropButton is TNormalButton then
        begin
          for i := 0 to FDropButtons.Count - 1 do
          begin
            if FDropButtons[i] is TNormalButton then
            begin
              FileName := TNormalButton(FDropButtons[i]).FileName;
              if FileName <> '' then
              begin
                FileName := GetDosName(FileName);
                if Files <> '' then
                  Files := Files + ' ';
                Files := Files + FileName;
              end;
            end;
          end;

          if Files <> '' then
          begin
            NormalButton := TNormalButton.Create;
            try
              NormalButton.Assign(DropButton);
              Option := NormalButton.Option;
              Option := Trim(Option);
              if Option <> '' then
                NormalButton.Option := Option + ' ' + Files
              else
                NormalButton.Option := Files;
              TOpenNormalButtonThread.Create(Handle, NormalButton);
            finally
              NormalButton.Free;
            end;
          end
          else
          begin
            MessageBox(Handle, '�h���b�v�����I�u�W�F�N�g�̓t�@�C���ł͂���܂���B',
              '�m�F', MB_ICONWARNING);
          end;
        end
        else if DropButton is TPluginButton then
        begin
          for i := 0 to FDropButtons.Count - 1 do
          begin
            if FDropButtons[i] is TNormalButton then
            begin
              FileName := TNormalButton(FDropButtons[i]).FileName;
              if FileName <> '' then
              begin
                if Files <> '' then
                  Files := Files + #13#10;
                Files := Files + FileName;
              end;
            end;
          end;

          if Files <> '' then
          begin
            PluginButton := TPluginButton(DropButton);
            Plugin := Plugins.FindPlugin(PluginButton.PluginName);
            if Plugin <> nil then
            begin
              if @Plugin.SLXButtonDropFiles <> nil then
                if Plugin.SLXButtonDropFiles(PluginButton.No, Self.Handle, PChar(Files)) then
                begin
                  ButtonInfo := Plugins.FindButtonInfo(PluginButton.PluginName, PluginButton.No);
                  ButtonInfo.UpdateButtonsUpdate;
                end;
            end;
          end
          else
          begin
            MessageBox(Handle, '�h���b�v�����I�u�W�F�N�g�̓t�@�C���ł͂���܂���B',
              '�m�F', MB_ICONWARNING);
          end;

        end
        else
        begin
          MessageBox(Handle, '�h���b�v�����ꏊ�ɂ̓t�@�C�����J����{�^��������܂���B',
            '�m�F', MB_ICONWARNING);
        end;
      end
      else
      begin
        MessageBox(Handle, '�h���b�v�����ꏊ�ɂ̓t�@�C�����J����{�^��������܂���B',
          '�m�F', MB_ICONWARNING);
      end;
    end;

    // �t�@�C�����̃R�s�[
    DA_COPYNAME:
    begin
      Files := '';
      for i := 0 to FDropButtons.Count - 1 do
      begin
        if FDropButtons[i] is TNormalButton then
        begin
          FileName := TNormalButton(FDropButtons[i]).FileName;
          if FileName <> '' then
          begin
            if Files <> '' then
              Files := Files + #13#10;
            Files := Files + FileName;
          end;
        end;
      end;
      ClipBoard.SetTextBuf(PChar(Files));
    end;
  end;

  FDropButtons.Free;
  FDropButtons := nil;
end;

// �v���O�C�����h���b�v
procedure TfrmPad.DropPluginFile(PluginFileList: TStringList);
var
  Msg: String;
  PluginList: TList;
  Plugin: TPlugin;
  Success: Boolean;
  PluginPath: string;
  CopyFiles: string;
  I: Integer;
  LpFileOp: TSHFILEOPSTRUCT;
begin
  PluginPath := ExtractFilePath(ParamStr(0)) + 'Plugins\';
  PluginList := TList.Create;
  try
    // DLL �`�F�b�N
    for I := 0 to PluginFileList.Count - 1 do
    begin
      Plugin := TPlugin.Create;
      try
        Plugin.FileName := PluginFileList[i];
        PluginList.Add(Plugin);
      except
        on E: Exception do
        begin
          Application.MessageBox(PChar(E.Message), '�x��', MB_ICONWARNING);
        end;
      end;
    end;

    Success := PluginList.Count > 0;

    if Success then
    begin
      // �m�F
      if PluginList.Count = 1 then
      begin
        Msg := '�v���O�C�� "' + TPlugin(PluginList[0]).Name + '" ���C���X�g�[�����܂��B';
      end
      else
      begin
        Msg := '���̃v���O�C�����C���X�g�[�����܂��B';
        for I := 0 to PluginList.Count - 1 do
          Msg := Msg + #13#10 + '�E ' + TPlugin(PluginList[I]).Name;
      end;
      Success := MessageBox(Handle, PChar(Msg), '�m�F', MB_ICONINFORMATION or MB_OKCANCEL) = idOk
    end;

    if Success then
    begin
      // �����̃v���O�C�����~
      for I := 0 to PluginList.Count - 1 do
      begin
        Plugin := Plugins.FindPlugin(TPlugin(PluginList[I]).Name);
        if Plugin <> nil then
        begin
          Plugin.Enabled := False;
          if Plugin.Enabled then
          begin
            Success := False;
            MessageBox(Handle, '�v���O�C������~�ł��܂���ł����B', '�m�F', MB_ICONWARNING);
            Break;
          end;
        end;
      end;
      Pads.AllArrange;
    end;

    if Success then
    begin
      // �R�s�[
      CopyFiles := '';
      for I := 0 to FDropButtons.Count - 1 do
      begin
        if FDropButtons[i] is TNormalButton then
        begin
          CopyFiles := CopyFiles + TNormalButton(FDropButtons[i]).FileName + #0;
        end;
      end;
      CopyFiles := CopyFiles + #0;

      with LpFileOp do
      begin
        Wnd := Application.Handle;
        wFunc := FO_COPY;
        pFrom := PChar(CopyFiles);
        pTo:= PChar(PluginPath);
        fFlags := FOF_NOCONFIRMATION;
        hNameMappings := nil;
        lpszProgressTitle := nil;
      end;
      Success := SHFileOperation(LpFileOp) = 0;
    end;

    if Success then
    begin
      // �����̃v���O�C�����폜���ĐV�����v���O�C�����C���T�[�g
      for I := 0 to PluginList.Count - 1 do
      begin
        Plugin := TPlugin.Create;
        Plugin.FileName := PluginPath + ExtractFileName(TPlugin(PluginList[I]).FileName);
        Plugins.DeletePlugin(TPlugin(PluginList[I]).Name);
        Plugins.AddObject(Plugin.Name, Plugin);
      end;
      Plugins.Sort;
    end;
    
    if Success then
    begin
      if PluginList.Count = 1 then
      begin
        Msg := '�v���O�C�� "' + TPlugin(PluginList[0]).Name + '" ���C���X�g�[�����܂����B' +
               '�����ɋN�����Ďg�p���܂����H';
      end
      else
      begin
        Msg := '���̃v���O�C�����C���X�g�[�����܂����B�����ɋN�����Ďg�p���܂����H';
        for I := 0 to PluginList.Count - 1 do
          Msg := Msg + #13#10 + '�E ' + TPlugin(PluginList[I]).Name;
      end;

      if MessageBox(Handle, PChar(Msg), '�m�F', MB_ICONQUESTION or MB_YESNO) = idYes then
      begin
        for I := 0 to PluginList.Count - 1 do
        begin
          Plugin := Plugins.FindPlugin(TPlugin(PluginList[I]).Name);
          if Plugin <> nil then
            Plugin.Enabled := True;
        end;
      end;
    end;

    Pads.AllArrange;
    Plugins.SaveEnabled;
  finally
    for I := 0 to PluginList.Count - 1 do
      TPlugin(PluginList[I]).Free;
    PluginList.Free;
  end;
end;

// �h���b�O�o�[�_�u���N���b�N
procedure TfrmPad.pnlDragBarDblClick(Sender: TObject);
begin
  FDblClicked := True;
end;

// �h���b�O�o�[�}�E�X�A�b�v
procedure TfrmPad.pnlDragBarMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i: Integer;
  CPos: TPoint;
  MenuItem: TMenuItem;
begin
  if Button = mbLeft then
  begin
    if FDblClicked then
    begin
      FDblClicked := False;

      popMainPopup(Sender);
      while popDblClick.Items.Count > 0 do
        popDblClick.Items[0].Free;

      case DblClickAction of
        CA_COMLINE:
          popComLine.Click;
        CA_BTNEDIT:
          popButtonEdit.Click;
        CA_GRPCHANGE:
        begin
          if GetCursorPos(CPos) then
          begin
            for i := 0 to popGroup.Count - 1 do
            begin
              MenuItem := TMenuItem.Create(Self);
              MenuItem.Caption := popGroup[i].Caption;
              MenuItem.Tag := popGroup[i].Tag;
              MenuItem.RadioItem := popGroup[i].RadioItem;
              MenuItem.Checked := popGroup[i].Checked;
              MenuItem.OnClick := popGroup[i].OnClick;
              popDblClick.Items.Add(MenuItem);
            end;
            popDblClick.Popup(CPos.x, CPos.y);
          end;
        end;
        CA_NEXTGROUP:
        begin
          if GroupIndex < FButtonGroups.Count - 1 then
            GroupIndex := GroupIndex + 1
          else
            GroupIndex := 0;
        end;
        CA_PADPRO:
          popPadProperty.Click;
        CA_OPTION:
          popOption.Click;
        CA_HIDE:
          popPadHide.Click;
      end;
    end;

  end;

end;

// �{�^���̕ҏW���֎~
function TfrmPad.GetLockBtnEdit(ShowWarning: Boolean): Boolean;
begin
  Result := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockBtnEdit', False);
  if Result and ShowWarning then
    MessageBox(Handle, '�{�^���̕ҏW�͋֎~����Ă��܂��B', '�m�F', MB_ICONWARNING);
end;

// 1 ��̃t�H���_���J�������֎~
function TfrmPad.GetLockBtnFolder(ShowWarning: Boolean): Boolean;
begin
  Result := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockBtnFolder', False);
  if Result and ShowWarning then
    MessageBox(Handle, '1 ��̃t�H���_���J�����͋֎~����Ă��܂��B', '�m�F', MB_ICONWARNING);
end;

// �p�b�h�̐ݒ肪�֎~
function TfrmPad.GetLockPadProperty(ShowWarning: Boolean): Boolean;
begin
  Result := UserIniFile.ReadBool(IS_RESTRICTIONS, 'LockPadProperty', False);
  if Result and ShowWarning then
    MessageBox(Handle, '�p�b�h�̐ݒ�͋֎~����Ă��܂��B', '�m�F', MB_ICONWARNING);
end;


end.

