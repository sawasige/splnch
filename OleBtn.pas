unit OleBtn;

interface

uses
  Windows, ActiveX, Classes, ShellAPI, ShlObj, SysUtils, OleData, SetBtn,
  pidl, BtnPro, Dialogs;

type
  //-------------------------------------------------------------------
  // IDropSource �̎���
  //-------------------------------------------------------------------
  TDropSource = class (TInterfacedObject, IDropSource)
    function QueryContinueDrag(fEscapePressed: BOOL;
      grfKeyState: Longint): HResult; stdcall;
    function GiveFeedback(dwEffect: Longint): HResult; stdcall;
  end;

  //-------------------------------------------------------------------
  // IDropTarget �̎���
  //-------------------------------------------------------------------
  TDropTargetEvent = procedure(var DataObject: IDataObject; KeyState: Longint;
    Point: TPoint; var dwEffect: Longint) of object;
  TDropTargetLeaveEvent = procedure of object;
  TDropTarget = class(TInterfacedObject, IDropTarget)
  private
    FFormatList:  PFormatList;
    FFormatCount: Integer;

    // �h���b�O���ꂽ�f�[�^�ւ� IDataObject �C���^�t�F�[�X�|�C���^�B
    FDataObject:  IDataObject;

    FOnDragEnter: TDropTargetEvent;
    FOnDragOver:  TDropTargetEvent;
    FOnDragLeave: TDropTargetLeaveEvent;
    FOnDragDrop:  TDropTargetEvent;

    // �L�[�{�[�h�̏�Ԃ���f�B�t�H���g�̓�������肷��B
    function GetEffect(grfKeyState: Longint): Longint;

    // IDropTarget �Œ�`����Ă��郁�\�b�h
    function DragEnter(const dataObj: IDataObject;
      grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; virtual; stdcall;
    function DragOver(grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; virtual; stdcall;
    function DragLeave: HResult; virtual; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint): HResult; virtual; stdcall;
  public
    // �󂯎�邱�Ƃ��ł���N���b�v�{�[�h�`����ݒ肷��B
    constructor Create(AFormatList: PFormatList;
      AFormatCount: Integer);
    destructor Destroy; override;

    // IDropTarget �C���^�[�t�F�[�X�̃��\�b�h���Ă΂ꂽ�Ƃ��ɌĂ΂��
    // �C�x���g�n���h���B
    property OnDragEnter: TDropTargetEvent read FOnDragEnter write FOnDragEnter;
    property OnDragOver: TDropTargetEvent read FOnDragOver write FOnDragOver;
    property OnDragLeave: TDropTargetLeaveEvent read FOnDragLeave write FOnDragLeave;
    property OnDragDrop: TDropTargetEvent read FOnDragDrop write FOnDragDrop;
  end;

  //-------------------------------------------------------------------
  // �{�^���O���[�v��IDataObject
  //-------------------------------------------------------------------
  TButtonGroupDataObject = class(TDataObject)
  private
    FStream: TMemoryStream;
  protected
    function GetMedium(const FormatEtc: TFormatEtc; var Medium: TStgMedium;
      CreateMedium: Boolean): HResult; override;
  public
    constructor Create(AButtonGroup: TButtonGroup);
    destructor Destroy; override;
  end;

procedure DataObjectToButtonGroup(DataObject: IDataObject; ButtonGroup: TButtonGroup);
function ButtonGroupInClipbord: Boolean;
function DataObjectIsButtonGroup(DataObject: IDataObject): Boolean;
function DataObjectIsFileName(DataObject: IDataObject; FindFile: Boolean): Boolean;
function DataObjectIsUrl(DataObject: IDataObject): Boolean;


var
  CF_SLBUTTONS: UINT;

  CF_IDLIST: UINT;
//  CF_FILENAMEMAP, CF_FILENAMEMAPW: UINT;
  CF_FILEGROUPDESCRIPTORA: UINT;
  CF_SHELLURL: UINT;

  CF_NETSCAPEBOOKMARK: UINT;



implementation

//--------------------------------------------------------------------
// IDropSource �̎���
//--------------------------------------------------------------------
// �h���b�O������p�����邩�ǂ��������肷��
function TDropSource.QueryContinueDrag(
  fEscapePressed: BOOL;             // ���[�U�[��[ESC]�L�[����������  
  grfKeyState: Longint              // �L�[�{�[�h�����L�[�̌��݂̏�� 
  ): HResult; stdcall;
begin
  // �}�E�X�̍��{�^����������Ă��Ȃ��C���Ȃ킿�}�E�X�̍��{�^���������ꂽ��
  if (grfKeyState and MK_LBUTTON) = 0 then
    Result := DRAGDROP_S_DROP       // �h���b�v����𔭐������܂�
  // �}�E�X�̉E�{�^���������ꂽ��
  else if (grfKeyState and MK_RBUTTON) <> 0 then
    Result := DRAGDROP_S_CANCEL     // �h���b�O������������܂�
  // �h���b�O���삪�L�����Z�����ꂽ��
  else if fEscapePressed then
    Result := DRAGDROP_S_CANCEL     // �h���b�O������������܂�
  else
    Result := S_OK;                 // �h���b�O������p�����܂�
end;


// �h���b�O���̓K�؂Ȏ��o�I���ʂ�^����B               �@�@�@�@�@�@�@
function TDropSource.GiveFeedback(
  dwEffect: Longint                 // IDropTarget ����̖߂�l       
  ): HResult; stdcall;
begin
  // �}�E�X�|�C���^�̓f�B�t�H���g�̂��̂��g�p���C����ȊO��
  // ���o�I����i�A�C�R�����ړ�����Ȃǁj�͍s��Ȃ��B                 
  Result := DRAGDROP_S_USEDEFAULTCURSORS;
end;

//--------------------------------------------------------------------
// IDropTarget �̎���
//--------------------------------------------------------------------
constructor TDropTarget.Create(AFormatList: PFormatList;
  AFormatCount: Integer);
begin
  inherited Create;
  FFormatCount := AFormatCount;

  // TFormatEtc �\���̂̃��X�g�̃R�s�[���I�u�W�F�N�g�����Ɋm�ۂ���B
  GetMem(FFormatList, SizeOf(TFormatList)*FFormatCount);
  CopyMemory(FFormatList, AFormatList,
    SizeOf(TFormatList)*FFormatCount);
end;

destructor TDropTarget.Destroy;
begin
  // �I�u�W�F�N�g�����Ɋm�ۂ��� TFormatEtc �\���̂̃��X�g���������B
  FreeMem(FFormatList);
  inherited Destroy;
end;

// �L�[�{�[�h�̏�Ԃɂ��s���ׂ���������肷��
function TDropTarget.GetEffect(grfKeyState: Longint): Longint;
begin
  if (grfKeyState and MK_CONTROL) <> 0 then
  begin
    if (grfKeyState and MK_SHIFT) <> 0 then
    // [CTRL]+[SHIFT] ��������Ă��鎞
      Result := DROPEFFECT_LINK
    else
    // [CTRL] ��������Ă��鎞
      Result := DROPEFFECT_COPY;
  end
  else
    // ����ȊO�̏ꍇ
    Result := DROPEFFECT_MOVE;
end;

function TDropTarget.DragEnter(
  const dataObj: IDataObject;       // �h���b�v���悤�Ƃ��Ă���f�[�^
  grfKeyState: Longint;             // �L�[�{�[�h�����L�[�̌��݂̏��
  pt: TPoint;                       // �}�E�X�|�C���^�̏ꏊ
  var dwEffect: Longint             // �h���b�v�����ꍇ�̓���
  ): HResult; stdcall;
var
  i: Integer;
begin
  FDataObject := nil;

  // �ȉ��̃��[�v�̒��Ŏw�肵���`�����g���Ȃ��ꍇ�́A�h���b�v�����
  // �󂯕t���Ȃ��B
  dwEffect := DROPEFFECT_NONE;
  for i := 0 to FFormatCount - 1 do
  begin
    // �v�������f�[�^�`�����g�p�ł��邩�𔻒f����
    if S_OK = dataObj.QueryGetData(FFormatList^[i]) then
    begin
      // �f�[�^�I�u�W�F�N�g������Ɋm�ۂ���B
      FDataObject := dataObj;
      Break;
    end;
  end;

  if FDataObject = nil then
    dwEffect := DROPEFFECT_NONE
  else
  begin
    dwEffect := GetEffect(grfKeyState);
    // �C�x���g�n���h�����ݒ肳��Ă���ꍇ�ɂ́A������Ăяo���B
    if Assigned(FOnDragEnter) then
      FOnDragEnter(FDataObject, grfKeyState, pt, dwEffect);
  end;

  Result := S_OK;                   // �֐��͐���ɏI�����܂���
end;


function TDropTarget.DragOver(
  grfKeyState: Longint;             // �L�[�{�[�h�����L�[�̌��݂̏��
  pt: TPoint;                       // �}�E�X�|�C���^�̏ꏊ
  var dwEffect: Longint             // �h���b�v�����ꍇ�̓���
  ): HResult; stdcall;
begin
  // �h���b�v�\�ȃf�[�^�`�����܂܂��ꍇ�́A���̓�������肷��
  if FDataObject = nil then
    dwEffect := DROPEFFECT_NONE
  else
  begin
    dwEffect := GetEffect(grfKeyState);
    // �C�x���g�n���h�����ݒ肳��Ă���ꍇ�ɂ́A������Ăяo���B
    if Assigned(FOnDragOver) then
      FOnDragOver(FDataObject, grfKeyState, pt, dwEffect);
  end;

  Result := S_OK;                   // �֐��͐���ɏI�����܂���
end;


function TDropTarget.DragLeave: HResult; stdcall;
begin
  // �I�u�W�F�N�g�����Ɋm�ۂ��� DataObject �ւ̎Q�Ƃ��I������B
  FDataObject := nil;
  if Assigned(FOnDragLeave) then
    FOnDragLeave;
  Result := S_OK;                   // �֐��͐���ɏI�����܂���
end;

// IDataObject.Drop �́CdataObj �ɂ���Ď����ꂽ�\�[�X�f�[�^���C����
// �^�[�Q�b�g�A�v���P�[�V�����Ƀh���b�v����B
function TDropTarget.Drop(
  const dataObj: IDataObject;       // �h���b�v���悤�Ƃ��Ă���f�[�^
  grfKeyState: Longint;             // �L�[�{�[�h�����L�[�̌��݂̏��
  pt: TPoint;                       // �}�E�X�|�C���^�̏ꏊ
  var dwEffect: Longint             // �h���b�v�����ꍇ�̓���
  ): HResult; stdcall;
begin
  if FDataObject = nil then
    dwEffect := DROPEFFECT_NONE
  else
  begin
    dwEffect := GetEffect(grfKeyState);
    // �C�x���g�n���h�����ݒ肳��Ă���ꍇ�ɂ́A������Ăяo���B
    if Assigned(FOnDragDrop) then
      FOnDragDrop(FDataObject, grfKeyState, pt, dwEffect);
  end;

  // �I�u�W�F�N�g�����Ɋm�ۂ��� DataObject �ւ̎Q�Ƃ��I������B
  FDataObject := nil;
  Result := S_OK;                   // �֐��͐���ɏI�����܂���
end;


//-------------------------------------------------------------------
// �{�^���O���[�v��IDataObject
//-------------------------------------------------------------------
constructor TButtonGroupDataObject.Create(AButtonGroup: TButtonGroup);
var
  FormatEtc: TFormatEtc;
begin
  // �e�L�X�g�f�[�^�]���̏ꍇ�̌`�����w�肷��B
  with FormatEtc do
  begin
    cfFormat := CF_SLBUTTONS;
    dwAspect := DVASPECT_CONTENT;
    ptd := nil;
    tymed := TYMED_HGLOBAL;
    lindex := -1;
  end;

  inherited Create(@FormatEtc, 1);
  // �e�L�X�g�f�[�^���I�u�W�F�N�g�����Ɋi�[����B
  FStream := TMemoryStream.Create;
  AButtonGroup.SaveToStream(FStream);
end;

destructor TButtonGroupDataObject.Destroy;
begin
  FStream.Free;
  inherited;
end;

function TButtonGroupDataObject.GetMedium(const FormatEtc: TFormatEtc;
      var Medium: TStgMedium; CreateMedium: Boolean): HResult;
var
  hMem: HGLOBAL;
  pszDst: PChar;
  Size: Longint;
begin
  // ���̃T���v���ł́AGetDataHere �ɂ͑Ή����Ȃ�
  if not CreateMedium then
  begin
    Result := E_NOTIMPL;
    Exit;
  end;

  // �{�^���o�b�t�@������
  FStream.Position := 0;
  Size := FStream.Size;

  // �]�����f�B�A���쐬����B
  hMem := GlobalAlloc(GHND, SizeOf(Size) + Size);
  if hMem <> 0 then
  begin
    pszDst := GlobalLock(hMem);

    PLongint(pszDst)^ := Size;
    Inc(pszDst, SizeOf(Size));
    FStream.Read(pszDst^, FStream.Size);
    GlobalUnlock(hMem);

    // �쐬�����]�����f�B�A���^�[�Q�b�g�ɓn���B
    Medium.hGlobal := hMem;
    Medium.tymed   := FormatEtc.tymed;
    Result := S_OK
  end
  else
    // �]�����f�B�A���m�ۂł��Ȃ������ꍇ�B
    Result := STG_E_MEDIUMFULL;

end;









// ButtonGroup�f�[�^�I�u�W�F�N�g����{�^���O���[�v�ɒǉ�����
function ButtonGroupDataObjectToButtonGroup(DataObject: IDataObject; ButtonGroup: TButtonGroup): Boolean;
var
  Medium: TStgMedium;
  FormatEtc: TFormatEtc;
  P: PChar;
  Size: Longint;
  MemStream: TMemoryStream;
begin
  Result := False;
  with FormatEtc do
  begin
    cfFormat := CF_SLBUTTONS;
    dwAspect := DVASPECT_CONTENT;
    ptd := nil;
    tymed := TYMED_HGLOBAL;
    lindex := -1;
  end;
  if DataObject.GetData(FormatEtc, Medium) = S_OK then
  begin
    try
      MemStream := TMemoryStream.Create;
      P := GlobalLock(Medium.hGlobal);
      try
        Size := PLongint(P)^;
        Inc(P, SizeOf(Size));
        MemStream.Write(P^, Size);
        MemStream.Position := 0;
        ButtonGroup.LoadFromStream(MemStream);
        Result := True;
      finally
        GlobalUnlock(Medium.hGlobal);
        MemStream.Free;
      end;
    finally
      ReleaseStgMedium(Medium);
    end;
  end;
end;

// Url�f�[�^�I�u�W�F�N�g����{�^���O���[�v�ɒǉ�����
function UrlDataObjectToButtonGroup(DataObject: IDataObject; ButtonGroup: TButtonGroup): Boolean;
var
  Medium: TStgMedium;
  FormatEtc: TFormatEtc;
  Url, UrlName: String;
  pUrl: PChar;
  NormalButton: TNormalButton;
  FileGroupDescriptor: PFileGroupDescriptor;
begin
  Result := False;

  Url := '';
  UrlName := '';

  with FormatEtc do
  begin
    cfFormat := CF_SHELLURL;
    dwAspect := DVASPECT_CONTENT;
    ptd := nil;
    tymed := TYMED_HGLOBAL;
    lindex := -1;
  end;
  if DataObject.GetData(FormatEtc, Medium) = S_OK then
  begin
    try
      pUrl := PChar(GlobalLock(Medium.hGlobal));
      try
        Url := pUrl;
      finally
        GlobalUnlock(Medium.hGlobal);
      end;
    finally
      ReleaseStgMedium(Medium);
    end;
  end;

  if Url = '' then
  begin
    // Netscape��Url
    with FormatEtc do
    begin
      cfFormat := CF_NETSCAPEBOOKMARK;
      dwAspect := DVASPECT_CONTENT;
      ptd := nil;
      tymed := TYMED_HGLOBAL;
      lindex := -1;
    end;
    if DataObject.GetData(FormatEtc, Medium) = S_OK then
    begin
      try
        pUrl := PChar(GlobalLock(Medium.hGlobal));
        try
          Url := pUrl;
        finally
          GlobalUnlock(Medium.hGlobal);
        end;
      finally
        ReleaseStgMedium(Medium);
      end;
    end;
  end;

  if Url <> '' then
  begin
    Result := True;
    // �����N��
    with FormatEtc do
    begin
      cfFormat := CF_FILEGROUPDESCRIPTORA;
      dwAspect := DVASPECT_CONTENT;
      ptd := nil;
      tymed := TYMED_HGLOBAL;
      lindex := -1;
    end;
    if DataObject.GetData(FormatEtc, Medium) = S_OK then
    begin
      try
        FileGroupDescriptor := PFileGroupDescriptor(GlobalLock(Medium.hGlobal));
        try
          if FileGroupDescriptor^.cItems >= 1 then
            UrlName := FileGroupDescriptor^.fgd[0].cFileName;
        finally
          if Medium.hGlobal <> 0 then
            GlobalUnlock(Medium.hGlobal);
        end;
      finally
        ReleaseStgMedium(Medium);
      end;
    end;

    NormalButton := TNormalButton.Create;
    if UrlName <> '' then
    begin
      NormalButton.Name := ExtractFileNameWithoutExt(UrlName);
      NormalButton.IconFile := UrlName;
    end
    else
    begin
      NormalButton.Name := Url;
      NormalButton.IconFile := 'dammy.url';
    end;
    NormalButton.FileName := Url;

    ButtonGroup.Add(NormalButton);
  end;

end;


// �t�@�C���f�[�^�I�u�W�F�N�g����{�^���O���[�v�ɒǉ�����
procedure FileDataObjectToButtonGroup(DataObject: IDataObject; ButtonGroup: TButtonGroup);
var
  Medium: TStgMedium;
  FormatEtc: TFormatEtc;
  FileList: TStringList;
  DropFiles: PDropFiles;
  pFileName: PChar;
  FileName: String;

  DesktopFolder: IShellFolder;
  CIDAList, PIDLList: TList;
  pInt: ^UINT;
  pCIDA: PIDA;
  i, Index: Integer;
  ButtonData: TButtonData;
  cPath: array[0..MAX_PATH] of Char;
begin
  FileList := TStringList.Create;
  try

    with FormatEtc do
    begin
      cfFormat := CF_HDROP;
      dwAspect := DVASPECT_CONTENT;
      ptd := nil;
      tymed := TYMED_HGLOBAL;
      lindex := -1;
    end;
    if DataObject.GetData(FormatEtc, Medium) = S_OK then
    begin
      try
        DropFiles := PDropFiles(GlobalLock(Medium.hGlobal));
        try
          pFileName := PChar(DropFiles) + DropFiles^.pFiles;
          while (pFileName^ <> #0) do
          begin
            if (DropFiles^.fWide) then // -> NT4 & Asian compatibility
            begin
              FileName := PWideChar(pFileName);
              Inc(pFileName, (Length(PWideChar(pFileName)) + 1) * 2);
            end
            else
            begin
              FileName := pFileName;
              Inc(pFileName, Length(pFileName) + 1);
            end;
            FileName := AnsiUpperCase(GetDosName(FileName));
            FileList.Add(FileName);
          end;
        finally
          GlobalUnlock(Medium.hGlobal);
        end;
      finally
        ReleaseStgMedium(Medium);
      end;
    end;


    with FormatEtc do
    begin
      cfFormat := CF_IDLIST;
      dwAspect := DVASPECT_CONTENT;
      ptd := nil;
      tymed := TYMED_HGLOBAL;
      lindex := -1;
    end;
    if DataObject.GetData(FormatEtc, Medium) = S_OK then
    begin
      try

        SHGetDesktopFolder(DesktopFolder);
        CIDAList := TList.Create;
        PIDLList := TList.Create;

        pCIDA := PIDA(GlobalLock(Medium.hGlobal));
        try
          pInt := @(pCIDA^.aoffset[0]);
          for i := 0 to pCIDA^.cidl do
          begin
            CIDAList.Add(Pointer(UINT(pCIDA)+ pInt^));
            Inc(pInt);
          end;

          // �P�߂Ƃ���ȊO���Ȃ���
          for i := 1 to CIDAList.Count - 1 do
          begin
            PIDLList.Add(ConcatItemID(CIDAList[0], CIDAList[i]));
          end;

          for i := 0 to PIDLList.Count - 1 do
          begin
            ButtonData := TNormalButton.Create;
            try
              if SHGetPathFromIDList(PIDLList[i], cPath) then
              begin
                FileNameToNormalButton(cPath, TNormalButton(ButtonData));
                FileName := AnsiUpperCase(GetDosName(cPath));
                Index := FileList.IndexOf(FileName);
                if Index >= 0 then
                  FileList.Delete(Index);
              end
              else
              begin
                with TNormalButton(ButtonData) do
                begin
                  ClickCount := 0;
                  Name := GetItemIDName(DesktopFolder, PIDLList[i], SHGDN_NORMAL);
                  FileName := '';
                  ItemIDList := PIDLList[i];
                  Option := '';
                  Folder := '';
                  WindowSize := 0;
                  IconFile := '';
                  IconIndex := 0;
                end;
              end;
              ButtonGroup.Add(ButtonData);
            except
              ButtonData.Free;
            end;
          end;

        finally
          GlobalUnlock(Medium.hGlobal);
          CIDAList.Free;
          PIDLList.Free;
          DesktopFolder := nil;
        end;


      finally
        ReleaseStgMedium(Medium);
      end;
    end;

    // �t�@�C���ꗗ�͂��邪PIDL�ɂȂ��t�@�C����ǉ�
    for i := 0 to FileList.Count - 1 do
    begin
      ButtonData := TNormalButton.Create;
      try
        FileNameToNormalButton(FileList[i], TNormalButton(ButtonData));
        ButtonGroup.Add(ButtonData);
      except
        ButtonData.Free;
      end;
    end;

  finally
    FileList.Free;
  end;
end;

// �f�[�^�I�u�W�F�N�g����{�^�����{�^���O���[�v�ɒǉ�����
procedure DataObjectToButtonGroup(DataObject: IDataObject; ButtonGroup: TButtonGroup);
begin
  // ButtonGroup
  if ButtonGroupDataObjectToButtonGroup(DataObject, ButtonGroup) then
    Exit;

  // Url
  if UrlDataObjectToButtonGroup(DataObject, ButtonGroup) then
    Exit;

  // �t�@�C��
  FileDataObjectToButtonGroup(DataObject, ButtonGroup);
end;

function ButtonGroupInClipbord: Boolean;
var
  DataObject: IDataObject;
  i: Integer;
  FormatEtc: array[0..4] of TFormatEtc;
begin
  Result := False;
  if OleGetClipboard(DataObject) = S_OK then
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

    for i := 0 to 4 do
    begin
      Result := DataObject.QueryGetData(FormatEtc[i]) = S_OK;
      if Result then
        Break;
    end;
  end;
end;

function DataObjectIsButtonGroup(DataObject: IDataObject): Boolean;
var
  FormatEtc:  TFormatEtc;
  Ret: Integer;
begin
  with FormatEtc do
  begin
    cfFormat := CF_SLBUTTONS;
    dwAspect := DVASPECT_CONTENT;
    ptd := nil;
    tymed := TYMED_HGLOBAL;
    lindex := -1;
  end;
  Ret := DataObject.QueryGetData(FormatEtc);
  Result := Ret = S_OK;

  if Result then
  begin
    // �Ȃ��� Outlook �� CF_SLBUTTONS ���܂܂��̂Ńt�@�C���̏ꍇ�� False �ɂ���
    with FormatEtc do
    begin
      cfFormat := CF_HDROP;
      dwAspect := DVASPECT_CONTENT;
      ptd := nil;
      tymed := TYMED_HGLOBAL;
      lindex := -1;
    end;
    Ret := DataObject.QueryGetData(FormatEtc);
    Result := Ret <> S_OK;
  end;

end;

function DataObjectIsFileName(DataObject: IDataObject; FindFile: Boolean): Boolean;
var
  FormatEtc:  TFormatEtc;

  Medium: TStgMedium;
  FileList: TStringList;
  DropFiles: PDropFiles;
  pFileName: PChar;
  FileName: String;

  i: Integer;
  FindData: TWIN32FindData;
  FindHandle: THandle;

begin
  with FormatEtc do
  begin
    cfFormat := CF_HDROP;
    dwAspect := DVASPECT_CONTENT;
    ptd := nil;
    tymed := TYMED_HGLOBAL;
    lindex := -1;
  end;
  Result := DataObject.QueryGetData(FormatEtc) = S_OK;

  if FindFile and Result then
  begin
    if DataObject.GetData(FormatEtc, Medium) = S_OK then
    begin
      FileList := TStringList.Create;
      try
        DropFiles := PDropFiles(GlobalLock(Medium.hGlobal));
        try
          pFileName := PChar(DropFiles) + DropFiles^.pFiles;
          while (pFileName^ <> #0) do
          begin
            if (DropFiles^.fWide) then // -> NT4 & Asian compatibility
            begin
              FileName := PWideChar(pFileName);
              Inc(pFileName, (Length(PWideChar(pFileName)) + 1) * 2);
            end
            else
            begin
              FileName := pFileName;
              Inc(pFileName, Length(pFileName) + 1);
            end;
            FileName := AnsiUpperCase(GetDosName(FileName));
            if FileName <> '' then
              FileList.Add(FileName);
          end;
        finally
          GlobalUnlock(Medium.hGlobal);
        end;

        if FileList.Count = 0 then
          Result := False;

        for i := 0 to FileList.Count - 1 do
        begin
          if FileList[i] <> '' then
          begin
            FindHandle := FindFirstFile(PChar(FileList[i]), FindData);
            if FindHandle = INVALID_HANDLE_VALUE then
            begin
              Result := False;
              Break;
            end;
            Windows.FindClose(FindHandle);
          end;
        end;

      finally
        FileList.Free;
        ReleaseStgMedium(Medium);
      end;
    end;


  end;
end;

function DataObjectIsUrl(DataObject: IDataObject): Boolean;
var
  FormatEtc:  TFormatEtc;
begin
  with FormatEtc do
  begin
    cfFormat := CF_SHELLURL;
    dwAspect := DVASPECT_CONTENT;
    ptd := nil;
    tymed := TYMED_HGLOBAL;
    lindex := -1;
  end;
  Result := DataObject.QueryGetData(FormatEtc) = S_OK;
  if not Result then
  begin
    with FormatEtc do
    begin
      cfFormat := CF_NETSCAPEBOOKMARK;
      dwAspect := DVASPECT_CONTENT;
      ptd := nil;
      tymed := TYMED_HGLOBAL;
      lindex := -1;
    end;
    Result := DataObject.QueryGetData(FormatEtc) = S_OK;
  end;
end;

initialization
  // Special Launch�I���W�i��
  CF_SLBUTTONS := RegisterClipboardFormat('Special Launch Buttons');
  // NewShell�p
  CF_IDLIST := RegisterClipboardFormat(CFSTR_SHELLIDLIST);
//  CF_FILENAMEMAP := RegisterClipboardFormat(CFSTR_FILENAMEMAPA);
//  CF_FILENAMEMAPW := RegisterClipboardFormat(CFSTR_FILENAMEMAPW);
  CF_FILEGROUPDESCRIPTORA := RegisterClipboardFormat(CFSTR_FILEDESCRIPTORA);
  CF_SHELLURL := RegisterClipboardFormat(CFSTR_SHELLUrl);
  // Netscape�p
  CF_NETSCAPEBOOKMARK := RegisterClipboardFormat('Netscape Bookmark');
end.
