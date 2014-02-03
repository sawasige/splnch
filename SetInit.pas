unit SetInit;

interface

uses
  Windows, SysUtils, Forms, IniFiles, About;

var
  UserName: string;
  UserFolder: string;
  UserIniFile: TIniFile = nil;
  UserIniReadOnly: Boolean = False;

function LoadAppInit: Boolean;

const
  // �A�v���P�[�V�������[�g�̐ݒ�
  IS_USERS = 'Users';
  IS_APPGENERAL = 'General';

  // ���[�U�[�ʂ̐ݒ�
  IS_USER = 'User';
  IS_PADS = 'Pads';
  IS_SOUNDS = 'Sounds';
  IS_RESTRICTIONS = 'Restrictions';
  IS_COMMANDLINE = 'CommandLine';
  IS_ENABLEPLUGINS = 'EnablePlugins';
  IS_DISABLEPLUGINS = 'DisablePlugins';
  IS_PADSZORDER = 'PadsZOrder';
  IS_WINDOWS = 'Windows';
  IS_OPTIONS = 'Options';

  // �p�b�h�̐ݒ�
  IS_GENERAL = 'General';
  IS_PADOPTIONS = 'PadOptions';

var
  FileNameIni: String;
  FileNameIco: String = 'Icons.dat';


implementation

uses
  InitFld;

function LoadAppInit: Boolean;
var
  SettingForAllUser: Boolean;
  cWork: array[0..255] of Char;
  UserSize: DWORD;
  Ini: TIniFile;
  UserInit: string;
  FindHandle: THandle;
  Win32FindData: TWin32FindData;
  UnknownFileExist: Boolean;
  NewUserFolder: string;
begin
  Result := True;

  // Ini�t�@�C���̖��O
  FileNameIni := ExtractFileName(ChangeFileExt(ParamStr(0), '.ini'));


  Ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
  try
    SettingForAllUser := Ini.ReadBool(IS_APPGENERAL, 'SettingForAllUser', False);

    UserName := 'Default';
    if not SettingForAllUser then
    begin
      // ���݂̃��[�U�[�����擾
      UserSize := 255;
      if GetUserName(cWork, UserSize) then
        UserName := StrPas(cWork)
    end;

    // ���[�U�[�t�H���_���擾
    UserFolder := Ini.ReadString(IS_USERS, UserName, '');
  finally
    Ini.Free;
  end;

  // �J�����g�f�B���N�g���ړ�
  ChDir(ExtractFilePath(ParamStr(0)));

  // ���[�U�[�ݒ�t�@�C��
  if UserFolder = '' then
    UserInit := ''
  else
  begin
    // ��΃p�X�擾
    UserFolder := ExpandUNCFileName(UserFolder);
    if not IsPathDelimiter(UserFolder, Length(UserFolder)) then
      UserFolder := UserFolder + '\';
    UserInit := UserFolder + FileNameIni;
  end;

  // ���[�U�[�ݒ�t�@�C�����Ȃ�
  if not FileExists(UserInit) then
  begin
    if not FileExists(ExtractFilePath(ParamStr(0)) + 'Setup.ini') then
      Application.MessageBox(
        PChar('Special Launch �������p���������A���ɂ��肪�Ƃ��������܂��B' + #13#10 +
       #13#10 +
       'Special Launch �̐ݒ�́A���̂��Ǝw�肷��f�[�^�t�H���_�ɂ��ׂĕۑ�����܂��B' +
       'Special Launch �̐ݒ���o�b�N�A�b�v�������ꍇ�́A���̃f�[�^�t�H���_����' +
       '�t�@�C�������ׂăo�b�N�A�b�v���Ă��������B'),
       'Special Launch', MB_ICONINFORMATION);


    dlgInitFolder := TdlgInitFolder.Create(nil);
    try
      if (OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT) and
        (OSVersionInfo.dwMajorVersion >= 6) then
        UserFolder := GetEnvironmentVariable('appdata') + '\Special Launch\'
      else
        UserFolder := ExtractFilePath(ParamStr(0)) + UserName + '\';

      dlgInitFolder.edtInitFolder.Text := UserFolder;
      while True do
      begin
        // �_�C�A���O�̕\��
        if dlgInitFolder.ShowModal = idOk then
        begin
          UserFolder := dlgInitFolder.edtInitFolder.Text;

          // �J�����g�f�B���N�g���ړ�
          ChDir(ExtractFilePath(ParamStr(0)));

          if not IsPathDelimiter(UserFolder, Length(UserFolder)) then
            UserFolder := UserFolder + '\';
          UserInit := UserFolder + FileNameIni;

          // �w��̃t�H���_�Ƀ��[�U�[�ݒ�t�@�C��������
          if FileExists(UserInit) then
          begin
            if Application.MessageBox(PChar('�w��̃t�H���_ "' + UserFolder +
                                            '" �ɂ͂��łɐݒ肪����܂��B���̐ݒ�𗘗p���܂����H'),
                                      '�m�F', MB_ICONQUESTION or MB_YESNO) = idYes then
              Break;
          end
          else if DirectoryExists(UserFolder) then
          begin
            UnknownFileExist := False;
            FindHandle := FindFirstFile(PChar(UserFolder + '*.*'), Win32FindData);
            if FindHandle <> INVALID_HANDLE_VALUE then
            begin
              while True do
              begin
                if (Win32FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
                begin
                  UnknownFileExist := True;
                  Break;
                end;

                if not FindNextFile(FindHandle, Win32FindData) then
                  Break;
              end;
              Windows.FindClose(FindHandle)
            end;

            if UnknownFileExist then
            begin
              if Application.MessageBox(PChar('�w��̃t�H���_ "' + UserFolder +
                                            '" �ɂ͂��łɐݒ�ȊO�̃t�@�C�������݂��Ă��܂��B' +
                                            '���̂܂ܑ��s���Ă�낵���ł���?'),
                                        '�m�F', MB_ICONQUESTION or MB_YESNO) = idYes then
                Break;
            end
            else
            begin
              if Application.MessageBox(PChar('�w��̃t�H���_ "' + UserFolder + '" �ɐݒ��ۑ����܂��B'),
                                        '�m�F', MB_ICONINFORMATION or MB_OKCANCEL) = idOK then
                Break;
            end;
          end
          else
          begin
            try
              ForceDirectories(UserFolder);
              if DirectoryExists(UserFolder) then
                Break
              else
                Application.MessageBox(PChar('�w��̃t�H���_ "' + UserFolder +
                                             '" �͍쐬�ł��܂���ł����B�������t�H���_�����w�肵�Ă��������B'),
                                    '�G���[', MB_ICONSTOP);
            except
              Application.MessageBox(PChar('�w��̃t�H���_ "' + UserFolder +
                                           '" �͍쐬�ł��܂���ł����B�������t�H���_�����w�肵�Ă��������B'),
                                    '�G���[', MB_ICONSTOP);
            end;
          end;

        end
        else
        begin
          Result := False;
          Break;
        end;

      end;

    finally
      dlgInitFolder.Release;
    end;

    if Result then
    begin
      // �J�����g�f�B���N�g���ɂ���ꍇ�͑��΃p�X�ɒu������
      NewUserFolder := UserFolder;
      if Pos(ExtractFilePath(ParamStr(0)), UserFolder) = 1 then
        NewUserFolder := ExtractRelativePath(ExtractFilePath(ParamStr(0)), UserFolder);

      // ���[�U�[�t�H���_��ۑ�
      Ini := TIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'));
      try
        try
          Ini.WriteString(IS_USERS, UserName, NewUserFolder);
        except
          Result := False;
          Application.MessageBox(PChar('�ݒ�t�@�C�� "' + Ini.FileName + '" �ɏ������߂܂���B'),
                                 '�G���[', MB_ICONSTOP);
        end;
      finally
        Ini.Free;
      end;
    end;

  end;

  if not Result then
    Exit;




  // ���[�U�[�ݒ�t�@�C�����쐬
  UserIniFile := TIniFile.Create(UserInit);
  if UserIniFile.ReadString(IS_USER, 'Name', '') = '' then
  begin
    UserIniReadOnly := False;
    try
      UserIniFile.WriteString(IS_USER, 'Name', UserName);
      UserIniFile.UpdateFile;
    except
      Result := False;
      UserIniFile.Free;
      UserIniFile := nil;
      Application.MessageBox(PChar('�ݒ�t�@�C�� "' + UserInit +
                                   '" �ɏ������߂܂���B'),
                             '�G���[', MB_ICONSTOP);
    end;
  end
  else
  begin
    UserIniReadOnly := False;
    FindHandle := FindFirstFile(PChar(UserInit), Win32FindData);
    if FindHandle <> INVALID_HANDLE_VALUE then
    begin
      // �ǂݎ���p�����iCD-R���j
      if (Win32FindData.dwFileAttributes and FILE_ATTRIBUTE_READONLY) <> 0 then
      begin
        UserIniReadOnly := True;
      end;
      Windows.FindClose(FindHandle)
    end;
    if not UserIniReadOnly then
    begin
      try
        UserIniFile.WriteString(IS_USER, 'Name', UserName);
        UserIniFile.UpdateFile;
      except
        // �������ݎ��G���[
        UserIniReadOnly := True;
      end;
    end;
  end;


end;

end.
