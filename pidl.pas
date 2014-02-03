{-----------------------------------------------------------------------------}
{                                                                             }
{  �uDelphi �ɂ��V�F���v���O���~���O����v�T���v���v���O����                }
{                                                                             }
{  �u���ڎ��ʎq�ɑ΂��鏈���v�̎�����                                         }
{                                                                             }
{   Copyright 1998 Masahiro Arai                                              }
{                                                                             }
{-----------------------------------------------------------------------------}
unit pidl;

interface

uses
  Windows, SysUtils, ShellAPI, ShlObj, ActiveX, Classes;

// ���ڎ��ʎq�i���X�g�j���i�[���邽�߂̃��������m�ۂ���
function AllocItemID  (Size: integer): PItemIDList;

// ���ڎ��ʎq�i���X�g�j�̃T�C�Y�����߂�
function GetItemIDSize(ItemIDList: PItemIDList): integer;

// ���ڎ��ʎq�i���X�g�j�̃R�s�[���쐬����
function CopyItemID   (ItemIDList: PItemIDList): PItemIDList;

// ���ڎ��ʎq�i���X�g�j��A�����ĐV�������ڎ��ʎq���쐬����
function ConcatItemID (ItemIDList1, ItemIDList2: PItemIDList):
  PItemIDList;

// ���ڎ��ʎq���X�g���́u���̍��ڎ��ʎq�v��������
function GetNextItemID(ItemIDList: PItemIDList): PItemIDList;

// ���ڎ��ʎq�i���X�g�j��\����������擾����
function GetItemIDName(Folder: IShellFolder; ItemID: PItemIDList;
  Flags: integer): string;

// �t�@�C���V�X�e���p�X�����ڎ��ʎq�i���X�g�j�ɕϊ�����
function GetIDListFromPath(Path: string): PItemIDList;

// ���ڎ��ʎq�i���X�g�j��\���A�C�R���̃C���f�b�N�X���擾����
function GetItemIDIcon(ItemIDList: PItemIDList; Flags: integer):
  integer;

// �Q�̍��ڎ��ʎq���r����
function CompareItemID(ShellFolder: IShellFolder;
  ItemID1, ItemID2: PItemIDList): Integer;

// ���ڎ��ʎq���X�g�Ɋ܂܂�鍀�ڎ��ʎq�����X�g�A�b�v����
// �����X�g���̊e�v�f�́A�V�F���������[�A���P�[�^�[�ɂ���ĉ�����邱��
function DivItemIDList(ItemIDList: PItemIDList): TList;

var
  Malloc: IMalloc;

implementation

// ���ڎ��ʎq�i���X�g�j���i�[���邽�߂̃��������m�ۂ���
function AllocItemID(Size: integer): PItemIDList;
var
  ItemIDList: PItemIDList;
begin
  // ���ڎ��ʎq�i���X�g�j���i�[���邽�߂̃��������m��
  ItemIDList := Malloc.Alloc(Size);
  // �擾�����������̓��e��������
  if Assigned(ItemIDList) then
    FillChar(ItemIDList^, Size, 0);
  Result := ItemIDList;
end;

// ���ڎ��ʎq�i���X�g�j�̃T�C�Y�����߂�
function GetItemIDSize(ItemIDList: PItemIDList): integer;
var
  Total: integer;
begin
  Total := 0;
  if Assigned(ItemIDList) then
  begin
    // ���ڎ��ʎq�����ԂɌ�������
    while (ItemIDList^.mkid.cb > 0) do
    begin
      inc(Total, ItemIDList^.mkid.cb);
      ItemIDList := GetNextItemID(ItemIDList);
    end;
    // ���ڎ��ʎq���X�g�̍Ō�ɉ����^�[�~�l�[�^�[�̑傫�������Z
    Total := Total + SizeOf(ItemIDList^.mkid.cb);
  end;
  Result := Total;
end;

// ���ڎ��ʎq�i���X�g�j�̃R�s�[���쐬����
// ���󂯎�������ڎ��ʎq�i���X�g�j�� Malloc.Free(ItemID) ��p����
//   �j�����Ȃ���΂Ȃ�Ȃ�
function CopyItemID(ItemIDList: PItemIDList): PItemIDList;
var
  NewItemID: PItemIDList;
  CopySize: integer;
begin
  // �u��̍��ڎ��ʎq�v�̓R�s�[���Ȃ�
  Result := nil;
  if not Assigned(ItemIDList) then
    Exit;

  // ���ڎ��ʎq���X�g�̑傫�����擾
  CopySize := GetItemIDSize(ItemIDList);
  // ���������m��
  NewItemID := AllocItemID(CopySize);
  // ���ڎ��ʎq���X�g�̃R�s�[
  Move(ItemIDList^, NewItemID^, CopySize);
  Result := NewItemID;
end;

// ���ڎ��ʎq�i���X�g�j��A�����ĐV�������ڎ��ʎq���쐬����
// ���󂯎�������ڎ��ʎq�i���X�g�j�� Malloc.Free(ItemID) ��p����
//   �j�����Ȃ���΂Ȃ�Ȃ�
function ConcatItemID(ItemIDList1, ItemIDList2: PItemIDList):
  PItemIDList;
var
  NewItemIDlist: PChar;
  ItemSize1, ItemSize2: integer;
begin
  // �R�s�[���s���T�C�Y���擾
  if Assigned(ItemIDList1) then
    // �^�[�~�l�[�^�[�̓R�s�[���Ȃ�
    ItemSize1 := GetItemIDSize(ItemIDList1)
      - SizeOf(ItemIDList1^.mkid.cb)
  else
    Itemsize1 := 0;
  ItemSize2 := GetItemIDSize(ItemIDList2);

  // �V�������ڎ��ʎq���X�g���i�[���郁�����̎擾
  NewItemIDList := PChar(AllocItemID(ItemSize1 + ItemSize2));

  // NewItemIDList �͈ȉ��̏����ŉ��H����̂ŁA�߂�l��\�ߐݒ肷��B
  Result := PItemIDList(NewItemIDList);

  // ���ڎ��ʎq�i���X�g�j�̃R�s�[
  if Assigned(NewItemIDList) then
  begin
    if Assigned(ItemIDList1) then
      Move(ItemIDList1^, NewItemIDList^, ItemSize1);
    // �|�C���^�̃I�t�Z�b�g���s��
    inc(NewItemIDList, ItemSize1);

    Move(ItemIDList2^, NewItemIDList^, ItemSize2);
  end;
end;

// ���ڎ��ʎq�i���X�g�j��\����������擾����
function GetItemIDName(Folder: IShellFolder; ItemID: PItemIDList;
  Flags: integer): string;
var
  StrRet:  TStrRet;
  Chars:   PChar;
begin
  Result := '';
  if (NOERROR = Folder.GetDisplayNameOf(ItemID, Flags, StrRet)) then
  begin
    case StrRet.uType of
      STRRET_WSTR:
      begin
        //PWideChar ���� string �ւ̃R�s�[
        Result := StrRet.pOleStr;
      end;

      STRRET_OFFSET:
      begin
        //�|�C���^�̃I�t�Z�b�g
        Chars := PChar(ItemID);
        inc(Chars, StrRet.uOffset);
        //PChar ���� string �ւ̃R�s�[
        Result := Chars;
      end;

      STRRET_CSTR:
        //PChar ���� string �ւ̃R�s�[
        Result := StrRet.cStr;
    end;
  end;
end;

// ���ڎ��ʎq���X�g���́u���̍��ڎ��ʎq�v��������
function GetNextItemID(ItemIDList: PItemIDList): PItemIDList;
var
  NextItemID: PChar;
begin
  // inc ��p���ăI�t�Z�b�g���s�����߂� PChar �^�ɃL���X�g����
  NextItemID := PChar(ItemIDList);

  // �|�C���^�̃I�t�Z�b�g���s���A���̗v�f���w��
  inc(NextItemID, ItemIDList^.mkid.cb);

  if ItemIDList^.mkid.cb = 0 then
    Result := nil
  else
    Result := PItemIDList(NextItemID);
end;

// �t�@�C���V�X�e���p�X�����ڎ��ʎq���X�g�ɕϊ�����
function GetIDListFromPath(Path: string): PItemIDList;
var
  DesktopFolder: IShellFolder;
  WidePath: WideString;
  Eaten, Attributes: Cardinal;
begin
  // �f�X�N�g�b�v�̃C���^�t�F�[�X���擾����
  SHGetDesktopFolder(DesktopFolder);
  // UNICODE ������ւ̕ϊ�
  WidePath := Path;
  // ���ڎ��ʎq���X�g���擾
  DesktopFolder.ParseDisplayName(0, nil, PWideChar(WidePath), Eaten, Result, Attributes);
end;

// ���ڎ��ʎq�i���X�g�j��\���A�C�R���̃C���f�b�N�X���擾����
function GetItemIDIcon(ItemIDList: PItemIDList; Flags: integer):
  integer;
var
  SHFileInfo: TSHFileInfo;
begin
  SHGetFileInfo(pchar(ItemIDList), 0, SHFileInfo, Sizeof(TSHFileInfo),
    SHGFI_PIDL or Flags);
  Result := SHFileInfo.iIcon;
end;

// ���ڎ��ʎq���r����
function CompareItemID(ShellFolder: IShellFolder;
  ItemID1, ItemID2: PItemIDList): Integer;
begin
  Result := SHORT($FFFF and ShellFolder.CompareIDs(0, ItemID1, ItemID2));
end;

// ���ڎ��ʎq���X�g�Ɋ܂܂�鍀�ڎ��ʎq�����X�g�A�b�v����
// �����X�g���̊e�v�f�́A�V�F���������[�A���P�[�^�[�ɂ���ĉ�����邱��
function DivItemIDList(ItemIDList: PItemIDList): TList;
var
  ItemSize: Integer;
  NewItemID: PItemIDList;
begin
  Result := TList.Create;
  while Assigned(ItemIDList) do
  begin
    // ���X�g���̊e�v�f�̃T�C�Y���擾����
    ItemSize := ItemIDList^.mkid.cb;
    // �v�f���k���^�[�~�l�[�^�[�ł���Ώ������I��
    if ItemSize = 0 then
      Exit;
    // ��K�w���̍��ڂ𒊏o����
    NewItemID := AllocItemID(ItemSize+SizeOf(ItemIDList^.mkid.cb));
    Move(ItemIDList^, NewItemID^, ItemSize);
    Result.Add(NewItemID);
    // ���̍��ڂ��w��
    ItemIDList := GetNextItemID(ItemIDList)
  end;
end;

initialization
  //�V�F���E�������E�A���P�[�^�[���m�ۂ���
  SHGetMalloc(Malloc);
finalization
  Malloc := nil;
end.

