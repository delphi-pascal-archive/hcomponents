object Form1: TForm1
  Left = 274
  Top = 120
  Cursor = crCross
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  AutoScroll = False
  Caption = 'Bugs'
  ClientHeight = 274
  ClientWidth = 431
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -30
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClick = FormClick
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  DesignSize = (
    431
    274)
  PixelsPerInch = 120
  TextHeight = 32
  object BNew: TSpeedButton
    Left = 324
    Top = 241
    Width = 92
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = 'New Bubble'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = BNewClick
  end
  object Label1: TLabel
    Left = 9
    Top = 9
    Width = 47
    Height = 16
    Caption = 'Miss :  0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 9
    Top = 26
    Width = 33
    Height = 16
    Caption = 'Kill : 0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 9
    Top = 44
    Width = 52
    Height = 16
    Caption = 'Score : 0'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object SpeedButton1: TSpeedButton
    Left = 9
    Top = 238
    Width = 91
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'New Form'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = SpeedButton1Click
  end
  object HProcess1: THProcess
    Monitor = HMonitor1
    Interval = 0
    Cycled = False
    TraceName = 'HProcess1'
    Priority = tpLowest
    Suspended = True
    OnExecute = HProcess1Execute
    OnTerminate = HProcess1Terminate
    OnException = HProcess1Exception
    OnDraw = HProcess1Draw
    Left = 24
    Top = 112
  end
  object HMonitor1: THMonitor
    OnEnter = HMonitor1Enter
    Left = 96
    Top = 120
  end
  object HProcess2: THProcess
    Interval = 0
    Cycled = False
    TraceName = 'HProcess2'
    Suspended = True
    OnExecute = HProcess2Execute
    OnTerminate = HProcess2Terminate
    OnDraw = HProcess2Draw
    Left = 144
    Top = 72
  end
end
