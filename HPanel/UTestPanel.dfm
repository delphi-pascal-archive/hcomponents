object Form1: TForm1
  Left = 289
  Top = 146
  Width = 387
  Height = 320
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object B1: THPanel
    Left = 12
    Top = 12
    Width = 337
    Height = 245
    BevelInner = bvRaised
    BevelWidth = 2
    BorderWidth = 1
    TabOrder = 0
    SizeControl = True
    PressColor = clBtnFace
    PressTextColor = clRed
    DownUp = False
    CanMove = False
    object B2: THPanel
      Left = 16
      Top = 28
      Width = 141
      Height = 93
      BevelInner = bvRaised
      BevelWidth = 2
      BorderWidth = 1
      Caption = 'Move'
      TabOrder = 0
      SizeControl = False
      PressColor = clBtnFace
      PressTextColor = clSilver
      DownUp = False
      CanMove = True
    end
    object B3: THPanel
      Left = 16
      Top = 128
      Width = 141
      Height = 93
      BevelInner = bvRaised
      BevelWidth = 2
      BorderWidth = 1
      Caption = 'Down Up'
      TabOrder = 1
      SizeControl = False
      PressColor = clBtnFace
      PressTextColor = clSilver
      DownUp = True
      CanMove = False
    end
    object B4: THPanel
      Left = 172
      Top = 28
      Width = 141
      Height = 93
      BevelInner = bvRaised
      BevelWidth = 2
      BorderWidth = 1
      Caption = 'Move and Dow Up'
      TabOrder = 2
      SizeControl = False
      PressColor = clBtnFace
      PressTextColor = clSilver
      DownUp = True
      CanMove = True
    end
    object HPanel1: THPanel
      Left = 172
      Top = 128
      Width = 141
      Height = 93
      BevelInner = bvRaised
      BevelWidth = 2
      BorderWidth = 1
      Caption = 'Press Color'
      Color = clMoneyGreen
      TabOrder = 3
      SizeControl = False
      PressColor = clGradientActiveCaption
      PressTextColor = clBtnShadow
      DownUp = True
      CanMove = False
    end
  end
end
