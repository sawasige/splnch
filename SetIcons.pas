unit SetIcons;

interface

uses
  Windows, Classes, Graphics, ShellAPI, SysUtils, ShlObj, pidl, SetInit;

type
  EIconFileError = class(Exception);

  TFileType = (ftIconPath, ftFilePath, ftPIDL);

  TIconData = class(TObject)
    FilePoint: Pointer;
    FileType: TFileType;
    IconIndex: Integer;
    LIcon: HIcon;
    SIcon: HIcon;
    destructor Destroy; override;
  end;

  TIconList = class(TObject)
  private
    FDesktopFolder: IShellFolder;
    FIcons: TList;
    FMaxCount: Integer;
    function Get(Index: Integer): TIconData;
    procedure SetMaxCount(Value: Integer);
    function GetCount: Integer;
  public
    property Icons[Index: Integer]: TIconData read Get; default;
    property MaxCount: Integer read FMaxCount write SetMaxCount;
    property Count: Integer read GetCount;
    constructor Create;
    destructor Destroy; override;
    procedure AddIcon(IconData: TIconData);
    procedure Clear;
    procedure Delete(Index: Integer);
    function IndexOf(FilePoint: Pointer; FileType: TFileType; IconIndex: Integer): Integer;
    procedure Move(CurIndex, NewIndex: Integer);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
  end;

  TIconCache = class(TObject)
  private
    FIconList: TIconList;
    FColorBitsChenged: Boolean;
    FColorBits: Integer;
    function GetCacheCount: Integer;
    procedure SetCacheMax(Value: Integer);
    function GetCacheMax: Integer;
    procedure SetColorBits(Value: Integer);
  public
    property CacheCount: Integer read GetCacheCount;
    property CacheMax: Integer read GetCacheMax write SetCacheMax;
    property ColorBits: Integer read FColorBits write SetColorBits;
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    function GetIcon(FilePoint: Pointer; FileType: TFileType;
      IconIndex: Integer; SmallIcon: Boolean; UseCache: Boolean): HIcon;
    procedure Load(FileName: String);
    procedure Save(FileName: String);
  end;

function GetIconHandle(FilePoint: Pointer; FileType: TFileType; IconIndex: Integer; var LIcon, SIcon: HIcon): Boolean;

var
  IconCache: TIconCache;

implementation

const
  HEADMSG = 'Special Launch 4.0 Icon Cache';

function GetIconHandle(FilePoint: Pointer; FileType: TFileType; IconIndex: Integer; var LIcon, SIcon: HIcon): Boolean;
var
  FilePointEx: Pointer;
  Flags: Integer;
  FileInfo: TSHFileInfo;
  IconCount: Integer;
begin
  Result := False;

  if FilePoint = nil then
    Exit;
  if (FileType <> ftPidl) and (StrPas(FilePoint) = '') then
    Exit;

  // �p�X�Ȃ���ϐ���W�J����
  if FileType = ftPidl then
    FilePointEx := FilePoint
  else
  begin
    FilePointEx := StrAlloc(2048);
    ExpandEnvironmentStrings(FilePoint, FilePointEx, 2047);
  end;

  try
    if FileType = ftIconPath then
    begin
      // �A�C�R���擾
      IconCount := ExtractIcon(HInstance, PChar(FilePointEx), Cardinal(-1));
      if IconIndex < IconCount then
      begin
        ExtractIconEx(PChar(FilePointEx), IconIndex, LIcon, SIcon, 1);
        Result := True;
      end;
    end;

    if (not Result) and (IconIndex = 0) then
    begin
      Result := True;
      Flags := SHGFI_SYSICONINDEX or SHGFI_ICON;
      if FileType = ftPIDL then
        Flags := Flags or SHGFI_PIDL;

      // �傫���A�C�R��
      SHGetFileInfo(FilePointEx, 0, FileInfo, SizeOf(TSHFileInfo), Flags or SHGFI_LARGEICON);
      LIcon := FileInfo.hIcon;
      if LIcon <> 0 then
      begin
        // �������A�C�R��
        SHGetFileInfo(FilePointEx, 0, FileInfo, SizeOf(TSHFileInfo), Flags or SHGFI_SMALLICON);
        SIcon := FileInfo.hIcon;
      end
      // ���݂��Ȃ��t�@�C���̎�
      else
      begin
        Flags := Flags or SHGFI_USEFILEATTRIBUTES;
        // �傫���A�C�R��
        SHGetFileInfo(FilePointEx, 0, FileInfo, SizeOf(TSHFileInfo), Flags or SHGFI_LARGEICON);
        LIcon := FileInfo.hIcon;
        // �������A�C�R��
        SHGetFileInfo(FilePointEx, 0, FileInfo, SizeOf(TSHFileInfo), Flags or SHGFI_SMALLICON);
        SIcon := FileInfo.hIcon;
      end;
    end;


  finally
    if FileType <> ftPidl then
      StrDispose(FilePointEx);
  end;
end;


// �A�C�R�����X�g���[���ɕۑ�
procedure IconToStream(const Icon: HIcon; Stream: TStream);
var
  IconInfo: TIconInfo;
  ColorInfo, MaskInfo: PBitmapInfo;
  ColorInfoSize, MaskInfoSize: Cardinal;
  ColorImage, MaskImage: Pointer;
  ColorImageSize, MaskImageSize: DWORD;
begin
  if not GetIconInfo(Icon, IconInfo) then
    raise EIconFileError.Create('IconInfo �̎擾�Ɏ��s���܂����B');

  try
    GetDIBSizes(IconInfo.hbmColor, ColorInfoSize, ColorImageSize);
    GetDIBSizes(IconInfo.hbmMask, MaskInfoSize, MaskImageSize);
    ColorInfo := AllocMem(ColorInfoSize);
    ColorImage := Allocmem(ColorImageSize);
    MaskInfo := AllocMem(MaskInfoSize);
    MaskImage := Allocmem(MaskImageSize);
    try
      GetDIB(IconInfo.hbmColor, 0, ColorInfo^, ColorImage^);
      GetDIB(IconInfo.hbmMask, 0, MaskInfo^, MaskImage^);
      Stream.Write(ColorInfoSize, SizeOf(ColorInfoSize));
      Stream.Write(ColorInfo^, ColorInfoSize);
      Stream.Write(ColorImageSize, SizeOf(ColorImageSize));
      Stream.Write(ColorImage^, ColorImageSize);
      Stream.Write(MaskInfoSize, SizeOf(MaskInfoSize));
      Stream.Write(MaskInfo^, MaskInfoSize);
      Stream.Write(MaskImageSize, SizeOf(MaskImageSize));
      Stream.Write(MaskImage^, MaskImageSize);
    finally
      FreeMem(ColorInfo);
      FreeMem(ColorImage);
      FreeMem(MaskInfo);
      FreeMem(MaskImage);
    end;
  finally
    DeleteObject(IconInfo.hbmColor);
    DeleteObject(IconInfo.hbmMask);
  end;
end;


// �X�g���[������A�C�R�����擾
procedure StreamToIcon(var Icon: HIcon; Stream: TStream);
var
  DC: HDC;
  ColorInfo, MaskInfo: PBitmapInfo;
  ColorInfoSize, MaskInfoSize: Cardinal;
  ColorImage, MaskImage: Pointer;
  ColorImageSize, MaskImageSize: DWORD;
  IconInfo: TIconInfo;

  bmp: TBitmap; //�}�X�N�摜�̃��m�N�����Ɏg�p
begin
  ColorInfo := nil;
  ColorImage := nil;
  MaskInfo := nil;
  MaskImage := nil;
  DC := GetDC(GetDesktopWindow);
  try
    Stream.Read(ColorInfoSize, SizeOf(ColorInfoSize));
    ColorInfo := AllocMem(ColorInfoSize);
    Stream.Read(ColorInfo^, ColorInfoSize);

    Stream.Read(ColorImageSize, SizeOf(ColorImageSize));
    ColorImage := Allocmem(ColorImageSize);
    Stream.Read(ColorImage^, ColorImageSize);

    Stream.Read(MaskInfoSize, SizeOf(MaskInfoSize));
    MaskInfo := AllocMem(MaskInfoSize);
    Stream.Read(MaskInfo^, MaskInfoSize);

    Stream.Read(MaskImageSize, SizeOf(MaskImageSize));
    MaskImage := Allocmem(MaskImageSize);
    Stream.Read(MaskImage^, MaskImageSize);


    IconInfo.fIcon := True;
    IconInfo.xHotspot := 0;
    IconInfo.yHotspot := 0;
    IconInfo.hbmColor := CreateDIBitmap(DC, ColorInfo.bmiHeader, CBM_INIT, ColorImage, ColorInfo^, DIB_RGB_COLORS);
    IconInfo.hbmMask := CreateDIBitmap(DC, MaskInfo.bmiHeader, CBM_INIT, MaskImage, MaskInfo^, DIB_RGB_COLORS);

    //�}�X�N�摜�����m�N����
    bmp := TBitmap.Create;
    bmp.Handle := IconInfo.hbmMask;
    bmp.Monochrome := True;
    IconInfo.hbmMask := bmp.Handle;
    bmp.ReleaseHandle;
    bmp.Free;

    Icon := CreateIconIndirect(IconInfo);

    DeleteObject(IconInfo.hbmColor);
    DeleteObject(IconInfo.hbmMask);
  finally
    DeleteDC(DC);
    FreeMem(ColorInfo);
    FreeMem(ColorImage);
    FreeMem(MaskInfo);
    FreeMem(MaskImage);
  end;
end;

//
// TIconData
/////////////////////////////////

// �f�X�g���N�^
destructor TIconData.Destroy;
begin
  if FileType = ftPidl then
    Malloc.Free(FilePoint)
  else
    StrDispose(FilePoint);
  DestroyIcon(LIcon);
  DestroyIcon(SIcon);
  inherited;
end;

//
// TIconList
/////////////////////////////////

function TIconList.Get(Index: Integer): TIconData;
begin
  Result := FIcons[Index];
end;

procedure TIconList.SetMaxCount(Value: Integer);
begin
  if Value < 0 then
    Value := 0;
  FMaxCount := Value;
  while Count > FMaxCount do
    Delete(Count - 1);
end;

function TIconList.GetCount: Integer;
begin
  Result := FIcons.Count;
end;

constructor TIconList.Create;
begin
  inherited;
  FIcons := TList.Create;
  SHGetDesktopFolder(FDesktopFolder);
end;

destructor TIconList.Destroy;
begin
  Clear;
  FIcons.Free;
  FDesktopFolder := nil;
  inherited;
end;

procedure TIconList.AddIcon(IconData: TIconData);
begin
  FIcons.Insert(0, IconData);
  SetMaxCount(FMaxCount);
end;

procedure TIconList.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Icons[i].Free;
  FIcons.Clear;
end;

procedure TIconList.Delete(Index: Integer);
begin
  Icons[Index].Free;
  FIcons.Delete(Index);
end;

function TIconList.IndexOf(FilePoint: Pointer; FileType: TFileType; IconIndex: Integer): Integer;
var
  FCount: Integer;
begin
  FCount := Count;
  Result := 0;
  while Result < FCount do
  begin
    if (Icons[Result].FileType = FileType) then
    begin
      if FileType = ftPidl then
      begin
        if CompareItemID(FDesktopFolder, Icons[Result].FilePoint, FilePoint) = 0 then
          Break;
      end
      else
      begin
        if (StrComp(Icons[Result].FilePoint, FilePoint) = 0) and
          (Icons[Result].IconIndex = IconIndex) then
          Break;
      end;
    end;
    Inc(Result);
  end;
  if Result = FCount then
    Result := -1;
end;

procedure TIconList.Move(CurIndex, NewIndex: Integer);
begin
  FIcons.Move(CurIndex, NewIndex);
end;

procedure TIconList.LoadFromStream(Stream: TStream);
var
  IconData: TIconData;
  MemStream: TMemoryStream;
  Size: Integer;
begin
  MemStream := TMemoryStream.Create;
  try
    while Stream.Position < Stream.Size do
    begin
      MemStream.Clear;
      Stream.Read(Size, SizeOf(Size));
      MemStream.CopyFrom(Stream, Size);
      MemStream.Position := 0;
      IconData := TIconData.Create;
      try
        with IconData do
        begin
          MemStream.Read(FileType, SizeOf(FileType));
          MemStream.Read(Size, SizeOf(Size));
          if FileType = ftPidl then
            FilePoint := AllocItemID(Size)
          else
            FilePoint := StrAlloc(Size);
          MemStream.Read(FilePoint^, Size);
          MemStream.Read(IconIndex, SizeOf(IconIndex));
          StreamToIcon(LIcon, MemStream);
          StreamToIcon(SIcon, MemStream);
        end;
      except
        IconData.Free;
        raise;
      end;
      FIcons.Add(IconData);
    end;
    SetMaxCount(FMaxCount);
  finally
    MemStream.Free;
  end;
end;

procedure TIconList.SaveToStream(Stream: TStream);
var
  i: Integer;
  MemStream: TMemoryStream;
  Size: Integer;
begin
  MemStream := TMemoryStream.Create;
  try
    for i := 0 to FIcons.Count - 1 do
    begin
      MemStream.Clear;

      try

        with Icons[i] do
        begin
          MemStream.Write(FileType, SizeOf(FileType));
          if FileType = ftPidl then
            Size := GetItemIDSize(FilePoint)
          else
            Size := StrLen(FilePoint) + 1;
          MemStream.Write(Size, SizeOf(Size));
          MemStream.Write(FilePoint^, Size);
          MemStream.Write(IconIndex, SizeOf(IconIndex));
          IconToStream(LIcon, MemStream);
          IconToStream(SIcon, MemStream);
        end;

        // ��O���o�ĂȂ���Εۑ�����
        MemStream.Position := 0;
        Size := MemStream.Size;
        Stream.Write(Size, SizeOf(Size));
        Stream.CopyFrom(MemStream, MemStream.Size);
      except
      end;

    end;
  finally
    MemStream.Free;
  end;
end;


//
// TIconCache
/////////////////////////////////

// �L���b�V���̎g�p�ʂ��擾
function TIconCache.GetCacheCount: Integer;
begin
  Result := FIconList.Count;
end;

// �L���b�V���̍ő�o�^�����Z�b�g
procedure TIconCache.SetCacheMax(Value: Integer);
begin
  FIconList.MaxCount := Value;
end;

// �L���b�V���̍ő�o�^�����擾
function TIconCache.GetCacheMax: Integer;
begin
  Result := FIconList.MaxCount;
end;

// �F���̕ύX
procedure TIconCache.SetColorBits(Value: Integer);
begin
  if FColorBits = Value then
    Exit;
  FColorBits := Value;
  FColorBitsChenged := True;
end;

// �R���X�g�g���N�^
constructor TIconCache.Create;
var
  DC: HDC;
begin
  inherited;

  // ��ʂ̐F�����m�F
  DC := GetDC(GetDesktopWindow);
  try
    FColorBitsChenged := False;
    FColorBits := GetDeviceCaps(DC, BITSPIXEL);
  finally
    ReleaseDC(0, DC);
  end;

  FIconList := TIconList.Create;
  FIconList.MaxCount := 1000;
end;

// �f�X�g���N�^
destructor TIconCache.Destroy;
begin
  FIconList.Free;
  inherited;
end;

// �N���A
procedure TIconCache.Clear;
begin
  FIconList.Clear;
end;

// �A�C�R���擾
function TIconCache.GetIcon(FilePoint: Pointer; FileType: TFileType;
  IconIndex: Integer; SmallIcon: Boolean; UseCache: Boolean): HIcon;
var
  CacheIndex: Integer;
  IconData: TIconData;
  LIcon, SIcon: HIcon;
  Success: Boolean;
begin
  if UseCache then
    CacheIndex := FIconList.IndexOf(FilePoint, FileType, IconIndex)
  else
    CacheIndex := -1;
  Result := 0;

  // �L���b�V������
  if CacheIndex >= 0 then
  begin
    IconData := FIconList[CacheIndex];
    FIconList.Move(CacheIndex, 0);
    if SmallIcon then
      Result := CopyIcon(IconData.SIcon)
    else
      Result := CopyIcon(IconData.LIcon);
  end
  // �L���b�V���Ȃ�
  else
  begin
    Success := GetIconHandle(FilePoint, FileType, IconIndex, LIcon, SIcon);
    if not Success then
    begin
      // �G���[���o�Ă������Ɏ擾����
      Success := GetIconHandle(FilePoint, FileType, 0, LIcon, SIcon);
    end;

    if Success then
    begin
      // �A�C�R���L���b�V�����g��
      if (CacheMax > 0) and UseCache then
      begin
        IconData := TIconData.Create;
        try
          if FileType = ftPidl then
            IconData.FilePoint := CopyItemID(FilePoint)
          else
          begin
            IconData.FilePoint := StrAlloc(StrLen(FilePoint) + 1);
            StrCopy(IconData.FilePoint, FilePoint);
          end;
          IconData.FileType := FileType;
          IconData.IconIndex := IconIndex;
          IconData.LIcon := CopyIcon(LIcon);
          IconData.SIcon := CopyIcon(SIcon);
          FIconList.AddIcon(IconData);
        except
          IconData.Free;
        end;
      end;

      if SmallIcon then
      begin
        Result := SIcon;
        DestroyIcon(LIcon);
      end
      else
      begin
        DestroyIcon(SIcon);
        Result := LIcon;
      end;
    end;
  end;
end;

// �ǂݍ���
procedure TIconCache.Load(FileName: String);
var
  Size: Integer;
  pWork: PChar;
  CanRead: Boolean;
  FileStream: TFileStream;
begin
  Clear;

  if not FileExists(FileName) then
    Exit;

  // �t�@�C�����J��
  try
    FileStream := TFileStream.Create(FileName, fmOpenRead or fmShareExclusive);
  except
    Exit;
  end;

  try
    CanRead := False;
    // �t�@�C����ʂ̓ǂݍ��݂Ɣ���
    Size := Length(HEADMSG) + 1;
    pWork := StrAlloc(Size);
    try
      FileStream.Read(pWork^, Size);
      if StrPas(pWork) = HEADMSG then
        CanRead := True;
    finally
      StrDispose(pWork);
    end;

    if CanRead then
      FIconList.LoadFromStream(FileStream);

  except
    Clear;
  end;
  FileStream.Free;
end;

// �ۑ�
procedure TIconCache.Save(FileName: String);
var
  Size: Integer;
  FileStream: TFileStream;
begin
  if UserIniReadOnly then
    Exit;


  // �t�@�C�����쐬���J��
  try
    FileStream := TFileStream.Create(FileName, fmCreate);
  except
    Exit;
  end;

  if (FIconList.Count = 0) or FColorBitsChenged then
  begin
    FileStream.Free;
    Exit;
  end;

  try
    // �t�@�C����ʂ�ۑ�
    Size := Length(HEADMSG) + 1;
    FileStream.Write(HEADMSG, Size);

    // �A�C�R�����X�g��ۑ�
    FIconList.SaveToStream(FileStream);
  finally
    FileStream.Free;
  end;
end;

end.
