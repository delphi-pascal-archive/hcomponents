object Form1: TForm1
  Left = 205
  Top = 144
  Cursor = crCross
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  AutoScroll = False
  Caption = 'Bugs'
  ClientHeight = 248
  ClientWidth = 391
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -24
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClick = FormClick
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 29
  object BNew: TSpeedButton
    Left = 294
    Top = 218
    Width = 83
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = 'New Bubble'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = BNewClick
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 39
    Height = 13
    Caption = 'Miss :  0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 24
    Width = 28
    Height = 13
    Caption = 'Kill : 0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 40
    Width = 43
    Height = 13
    Caption = 'Score : 0'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object SpeedButton1: TSpeedButton
    Left = 8
    Top = 216
    Width = 83
    Height = 22
    Anchors = [akLeft, akBottom]
    Caption = 'New Form'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
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
end
