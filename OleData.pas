unit OleData;

interface

uses
  Windows, ActiveX, Classes, ShellAPI, ShlObj, SysUtils;

type
  PFormatList = ^TFormatList;
  TFormatList = array[0..0] of TFormatEtc;

  TEnumFormatEtc = class(TInterfacedObject, IEnumFormatEtc)
  private
    FFormatList: PFormatList;
    FFormatCount: Integer;
    FIndex: Integer;
  public
    constructor Create(FormatList: PFormatList;
      FormatCount, Index: Integer);
    { IEnumFormatEtc �Œ�`����Ă��郁�\�b�h                        }
    function Next(celt: Longint; out elt; pceltFetched: PLongint):
      HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out enum: IEnumFormatEtc): HResult; stdcall;
  end;

  TDataObject = class(TInterfacedObject, IDataObject)
  private
    FFormatList: PFormatList;
    FFormatCount: Integer;

    { IDataObject �Œ�`����Ă��郁�\�b�h                           }
    function GetData(const formatetcIn: TFormatEtc;
      out medium: TStgMedium): HResult; virtual; stdcall;
    function GetDataHere(const formatetc: TFormatEtc;
      out medium: TStgMedium): HResult; virtual; stdcall;
    function QueryGetData(const formatetc: TFormatEtc): HResult;
      virtual; stdcall;
    function GetCanonicalFormatEtc(const formatetc: TFormatEtc;
      out formatetcOut: TFormatEtc): HResult; virtual; stdcall;
    function SetData(const formatetc: TFormatEtc;
      var medium: TStgMedium; fRelease: BOOL): HResult; virtual;
      stdcall;
    function EnumFormatEtc(dwDirection: Longint; out enumFormatEtc:
      IEnumFormatEtc): HResult; virtual; stdcall;
    function DAdvise(const formatetc: TFormatEtc; advf: Longint;
      const advSink: IAdviseSink; out dwConnection: Longint): HResult;
      virtual; stdcall;
    function DUnadvise(dwConnection: Longint): HResult; virtual;
      stdcall;
    function EnumDAdvise(out enumAdvise: IEnumStatData): HResult;
      virtual; stdcall;
  protected
    function GetMedium(const FormatEtc: TFormatEtc; var Medium: TStgMedium;
      CreateMedium: Boolean): HResult; virtual; abstract;
  public
    constructor Create(AFormatList: PFormatList;
      AFormatCount: Integer);
    destructor Destroy; override;
  end;

implementation

// IEnumFormatEtc
constructor TEnumFormatEtc.Create(FormatList: PFormatList;
  FormatCount, Index: Integer);
begin
  inherited Create;
  FFormatList := FormatList;
  FFormatCount := FormatCount;
  FIndex := Index;
end;

// ���݂̃C���f�b�N�X����X�^�[�g���Ďw�肳�ꂽ���� FORMATETC �\���̂�Ԃ��܂�
function TEnumFormatEtc.Next(celt: Longint; out elt;
  pceltFetched: PLongint): HResult;
var
  I: Integer;
begin
  I := 0;
  // FORMATETC �\���̂� celt �񋓂���
  while (I < celt) and (FIndex < FFormatCount) do
  begin
    TFormatList(elt)[I] := FFormatList[FIndex];
    Inc(FIndex);
    Inc(I);
  end;
  // �񋓂�������Ԃ�
  if pceltFetched <> nil then
    pceltFetched^ := I;
  // �v�����ꂽ FORMATETC �\���̂̐��ƁA�񋓂������������Ȃ� S_OK
  if I = celt then
    Result := S_OK
  else
    Result := S_FALSE;
end;

// ���̃��\�b�h�́A�w�肳�ꂽ������FORMATETC �\���̂̃��X�g���X�L�b�v���܂��B
function TEnumFormatEtc.Skip(celt: Longint): HResult;
begin
  if celt <= FFormatCount - FIndex then
  begin
    FIndex := FIndex + celt;
    Result := S_OK;
  end else
  begin
    FIndex := FFormatCount;
    Result := S_FALSE;
  end;
end;

function TEnumFormatEtc.Reset: HResult;
begin
  FIndex := 0;
  Result := S_OK;
end;

function TEnumFormatEtc.Clone(out enum: IEnumFormatEtc): HResult;
begin
  enum := TEnumFormatEtc.Create(FFormatList, FFormatCount, FIndex);
  Result := S_OK;
end;

// IDataObject �̎�����                                               }
constructor TDataObject.Create(AFormatList: PFormatList;
  AFormatCount: Integer);
var
  CopySize: Integer;
begin
  inherited Create;
  { �I�u�W�F�N�g������ TFormatEtc �\���̂̃��X�g�̃R�s�[���m�ۂ���B }
  FFormatCount := AFormatCount;
  CopySize := SizeOf(TFormatList) * FFormatCount;
  GetMem(FFormatList, CopySize);
  CopyMemory(FFormatList, AFormatList, CopySize);
end;

destructor TDataObject.Destroy;
begin
  { �I�u�W�F�N�g�����Ɋm�ۂ��� TFormatEtc �\���̂̃��X�g���������B }
  FreeMem(FFormatList);
  inherited Destroy;
end;

{ �w��L�����f�B�A���g���Ďw��`���̃f�[�^��W�J����B               }
function TDataObject.GetData(
  const formatetcIn: TFormatEtc;    { �f�[�^��߂����߂Ɏg���`��     }
  out medium: TStgMedium            { �L�����f�B�A�ւ̃|�C���^       }
  ): HResult; stdcall;
begin
  { �����l�F�w�肳�ꂽ���f�B�A�̓T�|�[�g�ł��܂���                   }
  Result := DV_E_FORMATETC;

  { �\���̂̏�����                                                   }
  medium.tymed := 0;
  medium.hGlobal := 0;
  medium.UnkForRelease := nil;

  try
    { �T�|�[�g�\�Ȍ`���ł��邩���m�F����                           }
    if (S_OK = QueryGetData(formatetcIn)) then
      { �]�����f�B�A�� TDataObject ����h�������N���X���쐬����B    }
      Result := GetMedium(formatetcIn, medium, TRUE);
  except
    { �G���[�����������ꍇ�B                                         }
    Result := E_UNEXPECTED;
  end;
end;

{ �w�肳�ꂽ�m�ۍς݋L���}�̂Ƀf�[�^��W�J����                       }
function TDataObject.GetDataHere(const formatetc: TFormatEtc;
  out medium: TStgMedium): HResult; stdcall;
begin
  { �����l�F�w�肳�ꂽ���f�B�A�̓T�|�[�g�ł��܂���                   }
  Result := DV_E_FORMATETC;         { = DATA_E_FORMATETC (Win16)     }
  try
    { �T�|�[�g�\�Ȍ`���ł��邩���m�F����                           }
    if (S_OK = QueryGetData(formatetc)) then
      { �]�����f�B�A�� TDataObject ����h�������N���X���쐬����B    }
      Result := GetMedium(formatetc, medium, FALSE);
  except
    { �G���[�����������ꍇ�B                                         }
    Result := E_UNEXPECTED;
  end;
end;

{ formatetc �� GetData �ɓn�����ꍇ�A�������������邩�𔻒f����B�@�@}
function TDataObject.QueryGetData(
  const formatetc: TFormatEtc         { �f�[�^���󂯎�邽�߂̌`��   }
  ): HResult; stdcall;
var
  i: integer;
begin
  { �����l�F�w�肳�ꂽ���f�B�A�̓T�|�[�g�ł��Ȃ� }
  Result := DV_E_FORMATETC;

  { �I�u�W�F�N�g�����Ɋm�ۂ��� TFormatEtc �\���̂̃��X�g�Ɣ�r����B }
  for i := 0 to FFormatCount - 1 do
    if (formatetc.cfFormat = FFormatList^[i].cfFormat) and
       (formatetc.dwAspect = FFormatList^[i].dwAspect) and
       Bool(formatetc.tymed and FFormatList^[i].tymed) then
      begin
        Result := NOERROR;
        Break;
      end;
end;

{ �\���f�o�C�X�ɌŗL�ȓW�J�������s�Ȃ�Ȃ��ꍇ�̎�����               }
function TDataObject.GetCanonicalFormatEtc(
  const formatetc: TFormatEtc; out formatetcOut: TFormatEtc): HResult;
  stdcall;
begin
  formatetcOut := formatetc;
  formatetcOut.ptd := nil;
  Result := DATA_S_SAMEFORMATETC;
end;

{ ���̎�����ɂ����ẮA���̊֐��̓T�|�[�g���Ȃ�                     }
function TDataObject.SetData(
  const formatetc: TFormatEtc;
  var medium: TStgMedium;
  fRelease: BOOL): HResult; stdcall;
begin
  Result := E_NOTIMPL;
end;

{ GetData ���\�b�h�Ńf�[�^���擾���邽�߂ɗ��p�\�Ȍ`����񋓂���B }
function TDataObject.EnumFormatEtc(
  dwDirection: Longint;               { �f�[�^������肷�����     }
  out enumFormatEtc: IEnumFormatEtc   { �񋓃I�u�W�F�N�g�̲��̪��    }
  ): HResult; stdcall;
begin
  Result := E_NOTIMPL;
  enumFormatEtc := nil;

  if dwDirection = DATADIR_GET then
  begin
    { TFormatEtc �\���̂��� IEnumFormatEtc �C���^�t�F�[�X������      }
    { �I�u�W�F�N�g���쐬����                                         }
    enumFormatEtc :=
      TEnumFormatEtc.Create(FFormatList, FFormatCount, 0);
    if Assigned(enumFormatEtc) then
      Result := S_OK;
  end
end;

{ ���̊֐��̓T�|�[�g���Ȃ�                                           }
function TDataObject.DAdvise(const formatetc: TFormatEtc;
  advf: Longint; const advSink: IAdviseSink;
  out dwConnection: Longint): HResult; stdcall;
begin
  Result := OLE_E_ADVISENOTSUPPORTED;
end;

{ ���̊֐��̓T�|�[�g���Ȃ�                                           }
function TDataObject.DUnadvise(dwConnection: Longint): HResult;
  stdcall;
begin
  Result := OLE_E_ADVISENOTSUPPORTED;
end;

{ ���̊֐��̓T�|�[�g���Ȃ�                                           }
function TDataObject.EnumDAdvise(out enumAdvise: IEnumStatData):
  HResult; stdcall;
begin
  Result := OLE_E_ADVISENOTSUPPORTED;
end;

initialization
  OleInitialize(nil);               { OLE ���C�u�����̏��������s��   }
finalization
  OleFlushClipboard;
  OleUninitialize;                  { OLE ���C�u�����̏�����������   }
end.
