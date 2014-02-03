unit VerCheck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, SHDocVw, About, mshtml, SetBtn, SetInit, SetPlug;

type
  TdlgVerCheck = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    memInfo: TMemo;
    wbVersion: TWebBrowser;
    lblMessage: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure wbVersionNavigateError(ASender: TObject; const pDisp: IDispatch;
      var URL, Frame, StatusCode: OleVariant; var Cancel: WordBool);
    procedure wbVersionNavigateComplete2(ASender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
  private
    RequestError: Boolean;
    SpVerup: Boolean;
    VerupList: TStringList;
  public
    procedure CreateParams(var Params: TCreateParams); override;
  end;

var
  dlgVerCheck: TdlgVerCheck;

implementation

{$R *.dfm}

type
  TNewPluginVersion = class(TObject)
    Name: string;
    CurrentVersion: string;
    Version: string;
    Date: string;
  end;


// �L�����Z���{�^��
procedure TdlgVerCheck.btnCancelClick(Sender: TObject);
begin
  Close;
end;

function URLEncode(src: String): String;
var
  i: Integer;
begin
  Result:='';
  for i:=1 to Length(src) do begin
    Result:=Result+'%'+IntToHex(Ord(src[i]),2);
  end;
end;

// OK �{�^��
procedure TdlgVerCheck.btnOkClick(Sender: TObject);
var
  NormalButton: TNormalButton;
  I: Integer;
  Param: string;
begin
  Param := '';
  if SpVerup then
    Param := 'splnch=1';


  for I := 0 to VerupList.Count - 1 do
  begin
    if Length(Param) > 0 then
      Param := Param + '&';
    Param := Param + 'plugin' + IntToStr(I) + '=' + URLEncode(verupList[i]);
  end;


  NormalButton := TNormalButton.Create;
  try
    if Length(Param) > 0 then
      NormalButton.FileName := 'http://splnch.sourceforge.jp/download.php?' + Param 
    else
      NormalButton.FileName := 'http://splnch.sourceforge.jp/download.php';


    OpenNormalButton(GetDesktopWindow, NormalButton);
  finally
    NormalButton.Free;
  end;
end;

// CreateParams
procedure TdlgVerCheck.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := GetDesktopWindow;
end;

// ����
procedure TdlgVerCheck.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

// ����O
procedure TdlgVerCheck.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := Enabled;
end;

// �t�H�[���͂���
procedure TdlgVerCheck.FormCreate(Sender: TObject);
begin
  SetClassLong(Handle, GCL_HICON, Application.Icon.Handle);

  VerupList := TStringList.Create;

  RequestError := False;
  wbVersion.Navigate('http://splnch.sourceforge.jp/download.php');
end;

// �t�H�[���I���
procedure TdlgVerCheck.FormDestroy(Sender: TObject);
begin
  dlgVerCheck := nil;
  VerupList.Free;
end;

// �ǂݍ��ݏI��
procedure TdlgVerCheck.wbVersionNavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
  Update: Boolean;
  I: Integer;
  All: IHtmlElementCollection;
  Item: IHtmlElement;
  SLCurrentVersion: string;
  TargetVersion: string;
  NewVersion: string;
  NewDate: string;
  Plugin: TPlugin;
  NewPluginVersion: TNewPluginVersion;
  NewPluginVersionList: TList;

  NextVerCheck: string;
begin
  Update := False;
  SLCurrentVersion := GetFileVersionString(ParamStr(0), True);

  if not RequestError then
  begin
    memInfo.Lines.BeginUpdate;
    NewPluginVersionList := TList.Create;
    try
      memInfo.Lines.Clear;
      NewVersion := '';
      NewPluginVersion := nil;
      All := (wbVersion.Document as IHTMLDocument2).all;
      for I := 0 to All.length - 1 do
      begin
        Item := All.item(I, 0) as IHtmlElement;
        if Item.className = 'slversion' then
        begin
          TargetVersion := item.innerText;
          if TargetVersion > SLCurrentVersion then
          begin
            NewVersion := TargetVersion;
          end;
        end
        else if (Item.className = 'sldate') then
        begin
          NewDate := item.innerText;
        end
        else if (Item.className = 'plugininnername') then
        begin
          NewPluginVersion := nil;
          Plugin := Plugins.FindPlugin(item.innerText);
          if Plugin <> nil then
          begin
            NewPluginVersion := TNewPluginVersion.Create;
            NewPluginVersion.Name := item.innerText;
            NewPluginVersion.CurrentVersion := GetFileVersionString(Plugin.FileName, True);
            NewPluginVersionList.Add(NewPluginVersion);
          end;
        end
        else if (Item.className = 'pluginversion') then
        begin
          if NewPluginVersion <> nil then
            NewPluginVersion.Version := item.innerText;
        end
        else if (Item.className = 'plugindate') then
        begin
          if NewPluginVersion <> nil then
            NewPluginVersion.Date := item.innerText;
        end;
      end;
      if NewPluginVersion <> nil then
        NewPluginVersionList.Add(NewPluginVersion);

      SpVerup := False;
      if NewVersion <> '' then
      begin
        SpVerup := True;
        Update := True;
        memInfo.Lines.Add('Special Launch �{�̂��o�[�W�����A�b�v���Ă��܂��B');
        if Length(NewDate) > 0 then
          memInfo.Lines.Add(SLCurrentVersion + '��' + NewVersion + '�i' + NewDate + '�j')
        else
          memInfo.Lines.Add(SLCurrentVersion + '��' + NewVersion);
      end;

      for I := 0 to NewPluginVersionList.Count - 1 do
      begin
        NewPluginVersion := NewPluginVersionList[i];
        if NewPluginVersion.Version > NewPluginVersion.CurrentVersion then
        begin
          Update := True;
          if memInfo.Lines.Count > 0 then
            memInfo.Lines.Add('');
          memInfo.Lines.Add('���̃v���O�C�����o�[�W�����A�b�v���Ă��܂��B');
          Break;
        end;
      end;
      VerupList.Clear;
      for I := 0 to NewPluginVersionList.Count - 1 do
      begin
        NewPluginVersion := NewPluginVersionList[i];
        if NewPluginVersion.Version > NewPluginVersion.CurrentVersion then
        begin
          VerupList.Add(NewPluginVersion.Name);
          memInfo.Lines.Add('�y' + NewPluginVersion.Name + '�z');
          if Length(NewPluginVersion.Date) > 0 then
            memInfo.Lines.Add(NewPluginVersion.CurrentVersion + '��' + NewPluginVersion.Version + '�i' + NewPluginVersion.Date + '�j')
          else
            memInfo.Lines.Add(NewPluginVersion.CurrentVersion + '��' + NewPluginVersion.Version);
        end;
      end;

//      if memInfo.Lines.Count > 0 then
//        memInfo.Lines.Add('');
//
//      if NewVersion = '' then
//      begin
//        if memInfo.Lines.Count > 0 then
//          memInfo.Lines.Add('');
//        memInfo.Lines.Add('Special Launch �{�͍̂ŐV�ł��B');
//        memInfo.Lines.Add(SLCurrentVersion);
//      end;
//
//      for I := 0 to NewPluginVersionList.Count - 1 do
//      begin
//        NewPluginVersion := NewPluginVersionList[i];
//        if NewPluginVersion.Version <= NewPluginVersion.CurrentVersion then
//        begin
//          if memInfo.Lines.Count > 0 then
//            memInfo.Lines.Add('');
//          memInfo.Lines.Add('���̃v���O�C���͍ŐV�ł��B');
//          Break;
//        end;
//      end;
//      for I := 0 to NewPluginVersionList.Count - 1 do
//      begin
//        NewPluginVersion := NewPluginVersionList[i];
//        if NewPluginVersion.Version <= NewPluginVersion.CurrentVersion then
//        begin
//          memInfo.Lines.Add('�y' + NewPluginVersion.Name + '�z');
//          memInfo.Lines.Add(NewPluginVersion.CurrentVersion);
//        end;
//      end;



      memInfo.SelStart := 0;
      memInfo.SelLength := 0;

      lblMessage.Font.Style := lblMessage.Font.Style + [fsBold];
      if Update then
      begin
        lblMessage.Caption := '�ŐV�ł̃\�t�g�E�F�A��������܂����B'+#13#10
          +'�_�E�����[�h�T�C�g����ŐV�ł��擾�ł��܂��B';
        btnOk.Default := True;
      end
      else
      begin
        lblMessage.Caption :='���g���� Special Launch �͍ŐV�o�[�W�����ł��B';
      end;
    finally
      memInfo.Lines.EndUpdate;
      NewPluginVersionList.Free;
    end;

    DateTimeToString(NextVerCheck, 'yyyymmdd', Now + 7);
    if not UserIniReadOnly then
    begin
      UserIniFile.WriteString(IS_OPTIONS, 'NextVerCheck', NextVerCheck);
      UserIniFile.UpdateFile;
    end;

  end;

  if Visible then
  begin
    if Update then
      btnOk.SetFocus
    else
      btnCancel.SetFocus
  end
  else
  begin
    if Update then
    begin
      Show;
      btnOk.SetFocus;
    end
    else
      Close;
  end;
end;

// �G���[
procedure TdlgVerCheck.wbVersionNavigateError(ASender: TObject;
  const pDisp: IDispatch; var URL, Frame, StatusCode: OleVariant;
  var Cancel: WordBool);
begin
  lblMessage.Font.Style := lblMessage.Font.Style + [fsBold];
  lblMessage.Caption := 'Special Launch �̍X�V���m�F�ł��܂���ł����B';
  RequestError := True;
end;

end.
