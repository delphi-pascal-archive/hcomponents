object Form1: TForm1
  Left = 277
  Top = 146
  Width = 492
  Height = 463
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 12
    Height = 26
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object SpeedButton1: TSpeedButton
    Left = 6
    Top = 98
    Width = 100
    Height = 28
    Caption = 'Execute'
    OnClick = SpeedButton1Click
  end
  object Label2: TLabel
    Left = 0
    Top = 30
    Width = 12
    Height = 26
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 0
    Top = 59
    Width = 12
    Height = 26
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object btn1: TSpeedButton
    Left = 6
    Top = 130
    Width = 100
    Height = 28
    Caption = 'Resume'
    OnClick = btn1Click
  end
  object btn2: TSpeedButton
    Left = 12
    Top = 256
    Width = 81
    Height = 22
    Caption = 'Send Zero'
    OnClick = btn2Click
  end
  object mmo1: TMemo
    Left = 108
    Top = 8
    Width = 357
    Height = 401
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -20
    Font.Name = 'Courier'
    Font.Style = [fsBold]
    Lines.Strings = (
      'mmo1')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object frmplcmnt1: TFormPlacement
    Left = 40
    Top = 48
  end
  object HP1: THProcess
    Write = HChannel1
    Interval = 0
    Cycled = False
    TraceName = 'HProcess1'
    Suspended = True
    OnExecute = HP1Execute
    OnTerminate = HP1Terminate
    OnEnded = HP1Ended
    OnDraw = HP1Draw
    OnTrace = HP1Trace
    Left = 24
    Top = 180
  end
  object HP2: THProcess
    Read = HChannel1
    Interval = 0
    Cycled = False
    TraceName = 'HP2'
    Suspended = True
    OnExecute = HP2Execute
    OnDraw = HP2Draw
    Left = 108
    Top = 60
  end
  object HChannel1: THChannel
    Left = 112
    Top = 152
  end
end
