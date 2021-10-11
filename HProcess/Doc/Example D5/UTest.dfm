object Form1: TForm1
  Left = 178
  Top = 115
  Width = 282
  Height = 148
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 10
    Height = 24
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object SpeedButton1: TSpeedButton
    Left = 8
    Top = 80
    Width = 81
    Height = 22
    Caption = 'Terminate HP1'
    OnClick = SpeedButton1Click
  end
  object Label2: TLabel
    Left = 0
    Top = 24
    Width = 10
    Height = 24
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object SpeedButton2: TSpeedButton
    Left = 88
    Top = 80
    Width = 81
    Height = 22
    Caption = 'Suspend HP3'
    OnClick = SpeedButton2Click
  end
  object Label3: TLabel
    Left = 0
    Top = 48
    Width = 10
    Height = 24
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object SpeedButton3: TSpeedButton
    Left = 168
    Top = 80
    Width = 89
    Height = 22
    Caption = 'Resume HP1'
    OnClick = SpeedButton3Click
  end
  object HP1: THProcess
    Write = CH1
    Interval = 0
    Cycled = False
    TraceName = 'HP1'
    Suspended = False
    OnExecute = HP1Execute
    OnTerminate = HP1Terminate
    OnDraw = HP1Draw
    OnTrace = HP1Trace
    Left = 56
  end
  object HP2: THProcess
    Read = CH1
    Write = CH2
    Interval = 0
    Cycled = False
    TraceName = 'HP2'
    Suspended = False
    OnExecute = HP2Execute
    OnTerminate = HP1Terminate
    OnDraw = HP2Draw
    Left = 104
  end
  object CH1: THChannel
    Left = 232
  end
  object HP3: THProcess
    Read = CH2
    Interval = 0
    Cycled = False
    TraceName = 'HP3'
    Suspended = False
    OnExecute = HP3Execute
    OnTerminate = HP1Terminate
    OnDraw = HP3Draw
    Left = 152
  end
  object CH2: THChannel
    Left = 192
  end
end
