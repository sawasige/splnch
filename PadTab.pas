unit PadTab;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, SLBtns, SetInit, MMSystem, Menus, ComCtrls, OleBtn, ActiveX;

type
  TfrmPadTab = class(TForm)
    pbDragBar: TPaintBox;
    PopupMenu1: TPopupMenu;
    popPadShowEsc: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pbDragBarPaint(Sender: TObject);
    procedure popPadShowClick(Sender: TObject);
    procedure pbDragBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
  private
    FHid: Boolean;
    FDropTarget: TDropTarget;
    FDropEntered: Boolean;
    procedure MoveFrame(var m: Integer; const n, f, Frame: Integer);
    function GetDropEnabled: Boolean;
    procedure SetDropEnabled(Value: Boolean);
    procedure OleDragEnter(var DataObject: IDataObject; KeyState: Longint;
      Point: TPoint; var dwEffect: Longint);
    procedure OleDragOver(var DataObject: IDataObject; KeyState: Integer;
      Point: TPoint; var dwEffect: Integer);
    procedure OleDragLeave;
  public
    frmPad: TForm;
    HidLeft: Integer;
    HidTop: Integer;
    HidWidth: Integer;
    HidHeight: Integer;
    property Hid: Boolean read FHid;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMSettingChange(var Msg: TWMSettingChange); message WM_SETTINGCHANGE;
    procedure WMActivate(var Msg: TWMActivate); message WM_ACTIVATE;
    procedure WMEnable(var Msg: TWMEnable); message WM_ENABLE;

    property DropEnabled: Boolean read GetDropEnabled write SetDropEnabled;
    property DropEntered: Boolean read FDropEntered;

    procedure SetHideSize;
    procedure MoveShow;
    procedure MoveHide;
  end;

implementation

uses
  Pad, Main;

{$R *.DFM}

// CreateParams
procedure TfrmPadTab.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.ExStyle := Params.ExStyle or WS_EX_TOOLWINDOW;
  Params.WndParent := GetDesktopWindow;
end;

// �t�H�[���n��
procedure TfrmPadTab.FormCreate(Sender: TObject);
var
  NonClientMetrics: TNonClientMetrics;
begin
  SetClassLong(Handle, GCL_HICON, Application.Icon.Handle);
  FHid := False;

  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0);
  pbDragBar.Font.Handle := CreateFontIndirect(NonClientMetrics.lfCaptionFont);

  DropEnabled := True;
end;

// �t�H�[���I���
procedure TfrmPadTab.FormDestroy(Sender: TObject);
begin
  DropEnabled := False;
end;

// �t�H�[��������
procedure TfrmPadTab.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
end;

// �R���g���[���p�l���̕ύX
procedure TfrmPadTab.WMSettingChange(var Msg: TWMSettingChange);
var
  NonClientMetrics: TNonClientMetrics;
begin
  inherited;

  // �^�C�g���o�[�̃t�H���g
  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0);
  pbDragBar.Font.Handle := CreateFontIndirect(NonClientMetrics.lfCaptionFont);
  SetHideSize;
  SetBounds(HidLeft, HidTop, HidWidth, HidHeight);
end;

// �A�N�e�B�u���ς��
procedure TfrmPadTab.WMActivate(var Msg: TWMActivate);
begin
  inherited;
  TfrmPad(frmPad).Foreground := Msg.Active <> WA_INACTIVE;
//  if Msg.Active <> WA_INACTIVE then
//    MoveShow;
end;

// Enable���ς��
procedure TfrmPadTab.WMEnable(var Msg: TWMEnable);
begin
  inherited;

  Enabled := Msg.Enabled;
  DropEnabled := Msg.Enabled;
end;

// �B�ꂽ�Ƃ��̈ʒu�A�T�C�Y���w��
procedure TfrmPadTab.SetHideSize;
var
  TabSize: Integer;
  StickPosition: TStickPosition;
  LogFont: TLogFont;
  NewFont, OldFont: HFont;
begin
  HidLeft := frmPad.Left;
  HidTop := frmPad.Top;
  HidWidth := frmPad.Width;
  HidHeight := frmPad.Height;

  StickPosition := spLeft;
  if TfrmPad(frmPad).HideVertical then
  begin
    if spTop in TfrmPad(frmPad).StickPositions then
      StickPosition := spTop
    else if spBottom in TfrmPad(frmPad).StickPositions then
      StickPosition := spBottom
    else if spLeft in TfrmPad(frmPad).StickPositions then
      StickPosition := spLeft
    else if spRight in TfrmPad(frmPad).StickPositions then
      StickPosition := spRight
  end
  else
  begin
    if spLeft in TfrmPad(frmPad).StickPositions then
      StickPosition := spLeft
    else if spRight in TfrmPad(frmPad).StickPositions then
      StickPosition := spRight
    else if spTop in TfrmPad(frmPad).StickPositions then
      StickPosition := spTop
    else
      StickPosition := spBottom
  end;

  if TfrmPad(frmPad).HideGroupName then
  begin
    GetObject(Canvas.Font.Handle, SizeOf(LogFont), @LogFont);
    if StickPosition = spLeft then
      LogFont.lfEscapement := 900
    else if StickPosition = spRight then
      LogFont.lfEscapement := 2700
    else
      LogFont.lfEscapement := 0;

    NewFont := CreateFontIndirect(LogFont);
    try
      OldFont := SelectObject(pbDragBar.Canvas.Handle, NewFont);
      TabSize := Abs(pbDragBar.Font.Height) + 2;
      NewFont := SelectObject(pbDragBar.Canvas.Handle, OldFont);
    finally
      DeleteObject(NewFont);
    end;
  end
  else
    TabSize := TfrmPad(frmPad).HideSize;


  case StickPosition of
    spLeft:
    begin
      HidLeft := frmPad.Monitor.Left;
      HidWidth := TabSize;
      pbDragBar.Align := alRight;
      pbDragBar.Width := TabSize;
    end;
    spRight:
    begin
      HidLeft := frmPad.Monitor.Left + frmPad.Monitor.Width - TabSize;
      HidWidth := TabSize;
      pbDragBar.Align := alLeft;
      pbDragBar.Width := TabSize;
    end;
    spTop:
    begin
      HidTop := frmPad.Monitor.Top;
      HidHeight := TabSize;
      pbDragBar.Align := alBottom;
      pbDragBar.Height := TabSize;
    end;
    else
    begin
      HidTop := frmPad.Monitor.Top + frmPad.Monitor.Height - TabSize;
      HidHeight := TabSize;
      pbDragBar.Align := alTop;
      pbDragBar.Height := TabSize;
    end;
  end;

end;

// �A�j���[�V�����̂P�R�}
procedure TfrmPadTab.MoveFrame(var m: Integer; const n, f, Frame: Integer);
begin
  m := f - n;
  if m <> 0 then
  begin
    m := m div Frame;
    if m = 0 then
      if f > n then
        m := 1
      else
        m := -1;
  end;
end;

// �h���b�v��t
function TfrmPadTab.GetDropEnabled: Boolean;
begin
  Result := FDropTarget <> nil;
end;

// �h���b�v��t
procedure TfrmPadTab.SetDropEnabled(Value: Boolean);
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
procedure TfrmPadTab.OleDragEnter(var DataObject: IDataObject; KeyState: Longint;
      Point: TPoint; var dwEffect: Longint);
begin
  dwEffect := DROPEFFECT_NONE;
  FDropEntered := True;
end;

// �h���b�O�I�[�o�[
procedure TfrmPadTab.OleDragOver(var DataObject: IDataObject;
  KeyState: Integer; Point: TPoint; var dwEffect: Integer);
begin
  dwEffect := DROPEFFECT_NONE;
end;

// �h���b�O�����
procedure TfrmPadTab.OleDragLeave;
begin
  FDropEntered := False;
end;

// �����
procedure TfrmPadTab.MoveShow;
var
  SLeft, STop, SWidth, SHeight: Integer;
  Frame: Integer;
  SoundFile: String;
  bForeground: Boolean;
  WinHotkey: Word;
begin
  SoundFile := UserIniFile.ReadString(IS_SOUNDS, 'MoveShow', '');
  if SoundFile <> '' then
    PlaySound(PChar(SoundFile), 0, SND_ASYNC);

  if TfrmPad(frmPad).HideSmooth then
  begin
    pbDragBar.Visible := False;

    Color := frmPad.Color;

    Frame := 5;
    while True do
    begin
      MoveFrame(SLeft, Left, frmPad.Left, Frame);
      MoveFrame(STop, Top, frmPad.Top, Frame);
      MoveFrame(SWidth, Width, frmPad.Width, Frame);
      MoveFrame(SHeight, Height, frmPad.Height, Frame);

      if (SLeft = 0) and (STop = 0) and (SWidth = 0) and (SHeight = 0) then
        Break;

      SetBounds(Left+SLeft, Top+STop, Width+SWidth, Height+SHeight);
      Dec(Frame);
      Sleep(10);
    end;
  end;

  bForeground := TfrmPad(frmPad).Foreground;
  FHid := False;
  SetWindowPos(frmPad.Handle, Handle, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOMOVE or SWP_SHOWWINDOW);
  if bForeground then
    frmPad.SetFocus;
  ShowWindow(Handle, SW_HIDE);
  WinHotkey := SendMessage(Handle, WM_GETHOTKEY, 0, 0);
  SendMessage(Handle, WM_SETHOTKEY, 0, 0);
  SendMessage(frmPad.Handle, WM_SETHOTKEY, WinHotkey, 0);
  TfrmPad(frmPad).TopMost := TfrmPad(frmPad).TopMost;
end;

// �B���
procedure TfrmPadTab.MoveHide;
var
  SLeft, STop, SWidth, SHeight: Integer;
  Frame: Integer;
  SoundFile: String;
  WinHotkey: Word;
begin
  SoundFile := UserIniFile.ReadString(IS_SOUNDS, 'MoveHide', '');
  if SoundFile <> '' then
    PlaySound(PChar(SoundFile), 0, SND_ASYNC);

  SetHideSize;

  FHid := True;

  Color := frmPad.Color;
  pbDragBar.Visible := False;
  ShowWindow(frmPad.Handle, SW_HIDE);
  SetWindowPos(Handle, frmPad.Handle, frmPad.Left, frmPad.Top, frmPad.Width, frmPad.Height, SWP_NOACTIVATE or SWP_SHOWWINDOW);

  WinHotkey := SendMessage(frmPad.Handle, WM_GETHOTKEY, 0, 0);
  SendMessage(frmPad.Handle, WM_SETHOTKEY, 0, 0);
  SendMessage(Handle, WM_SETHOTKEY, WinHotkey, 0);

  if TfrmPad(frmPad).HideSmooth then
  begin
    Frame := 5;
    while True do
    begin
      MoveFrame(SLeft, Left, HidLeft, Frame);
      MoveFrame(STop, Top, HidTop, Frame);
      MoveFrame(SWidth, Width, HidWidth, Frame);
      MoveFrame(SHeight, Height, HidHeight, Frame);

      if (SLeft = 0) and (STop = 0) and (SWidth = 0) and (SHeight = 0) then
        Break;

      SetBounds(Left+SLeft, Top+STop, Width+SWidth, Height+SHeight);
      Dec(Frame);
      Sleep(10);
    end;
  end;

  SetBounds(HidLeft, HidTop, HidWidth, HidHeight);
  Color := TfrmPad(frmPad).HideColor;
//  pbDragBar.Visible := TfrmPad(frmPad).HideGroupName;
  pbDragBar.Visible := True;
  TfrmPad(frmPad).Foreground := False;
end;

procedure TfrmPadTab.pbDragBarPaint(Sender: TObject);
var
  GrpName: string;
  IsGradat: BOOL;
  ARect: TRect;
  Direction: TDirection;
begin
  if TfrmPad(frmPad).ButtonGroup = nil then
    Exit;

  GrpName := TfrmPad(frmPad).ButtonGroup.Name;

  if not SystemParametersInfo(SPI_GETGRADIENTCAPTIONS, 0, @IsGradat, 0) then
    IsGradat := False;

  with pbDragBar do
  begin
    if Align = alLeft then
      Direction := drBottomUp
    else if Align = alRight then
      Direction := drTopDown
    else
      Direction := drLeftRight;

    Canvas.Brush.Color := TfrmPad(frmPad).HideColor;
    Canvas.Font.Color := GetFontColorFromFaceColor(Canvas.Brush.Color);
    if IsGradat and (Canvas.Brush.Color = clInactiveCaption) then
      GradationRect(Canvas, ClientRect, Direction, clInactiveCaption, TColor(clGradientInactiveCaption))
    else
      Canvas.FillRect(ClientRect);


    ARect := ClientRect;
//    InflateRect(ARect, -1, -1);

    if TfrmPad(frmPad).HideGroupName then
    begin
      Canvas.Brush.Style := bsClear;
      RotateTextOut(Canvas, ARect, Direction, GrpName)
    end;

  end;
end;

procedure TfrmPadTab.popPadShowClick(Sender: TObject);
begin
  if Enabled then
    MoveShow;
end;

procedure TfrmPadTab.pbDragBarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Enabled then
    MoveShow;
end;

end.
