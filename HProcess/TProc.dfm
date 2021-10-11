object Form1: TForm1
  Left = 226
  Top = 125
  Width = 405
  Height = 232
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 72
    Top = 40
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object Label2: TLabel
    Left = 72
    Top = 80
    Width = 32
    Height = 13
    Caption = 'Label2'
  end
  object SpeedButton1: TSpeedButton
    Left = 160
    Top = 24
    Width = 23
    Height = 22
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 160
    Top = 72
    Width = 23
    Height = 22
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 104
    Top = 120
    Width = 33
    Height = 22
    Caption = 'Done'
    OnClick = SpeedButton3Click
  end
  object ListBox1: TListBox
    Left = 200
    Top = 8
    Width = 193
    Height = 186
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 16
    ParentFont = False
    TabOrder = 0
  end
  object HP1: THProcess
    OnTerminate = HP1Terminate
    OnDraw = HP1Draw
    OnTrace = HP1Trace
    Priority = tpNormal
    Suspended = False
    OnExecute = HP1Execute
    OnException = HP1Exception
    Interval = 0
    Cycled = False
    TraceName = 'Генератор'
    Left = 8
  end
  object HP2: THProcess
    OnTerminate = HP2Terminate
    OnDraw = HP2Draw
    OnTrace = HP1Trace
    Priority = tpNormal
    Suspended = False
    OnExecute = HP2Execute
    OnException = HP2Exception
    Interval = 0
    Cycled = False
    TraceName = 'Обработчик'
    Left = 8
    Top = 40
  end
  object O: THProcess
    OnTerminate = OTerminate
    Priority = tpNormal
    Suspended = False
    OnExecute = OExecute
    Interval = 0
    Cycled = False
    TraceName = 'O'
    Left = 120
    Top = 24
  end
  object HP3: THProcess
    OnTerminate = HP3Terminate
    OnDraw = HP1Draw
    OnTrace = HP1Trace
    Priority = tpNormal
    Suspended = False
    OnExecute = HP3Execute
    OnException = HP3Exception
    Interval = 0
    Cycled = False
    TraceName = 'Потребитель'
    Left = 8
    Top = 88
  end
  object CH: THChannel
    Left = 104
    Top = 144
  end
  object CH2: THChannel
    Left = 144
    Top = 144
  end
  object FormPlacement1: TFormPlacement
    Left = 48
    Top = 136
  end
end
