object dlgPassword: TdlgPassword
  Left = 503
  Top = 378
  BorderStyle = bsDialog
  Caption = '�p�X���[�h����'
  ClientHeight = 103
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = '�l�r �o�S�V�b�N'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 12
  object lblMessage: TLabel
    Left = 16
    Top = 12
    Width = 52
    Height = 12
    Caption = '���b�Z�[�W'
  end
  object Label1: TLabel
    Left = 66
    Top = 40
    Width = 71
    Height = 12
    Caption = '�p�X���[�h(&P):'
    FocusControl = edtPassword
  end
  object btnOk: TButton
    Left = 159
    Top = 66
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 239
    Top = 66
    Width = 75
    Height = 25
    Cancel = True
    Caption = '�L�����Z��'
    ModalResult = 2
    TabOrder = 2
  end
  object edtPassword: TEdit
    Left = 146
    Top = 36
    Width = 117
    Height = 20
    PasswordChar = '*'
    TabOrder = 0
    OnChange = edtPasswordChange
  end
end
