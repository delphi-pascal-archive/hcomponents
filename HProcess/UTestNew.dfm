object Form1: TForm1
  Left = 180
  Top = 120
  Width = 328
  Height = 181
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 48
    Top = 104
    Width = 57
    Height = 22
    Caption = 'New'
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 120
    Top = 104
    Width = 23
    Height = 22
    OnClick = SpeedButton2Click
  end
  object Label2: TLabel
    Left = 8
    Top = 88
    Width = 32
    Height = 13
    Caption = 'Label2'
  end
  object LB1: TListBox
    Left = 152
    Top = 8
    Width = 161
    Height = 97
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
  end
  object BitBtn1: TBitBtn
    Left = 176
    Top = 112
    Width = 75
    Height = 33
    Caption = '&Help'
    TabOrder = 1
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333336633
      3333333333333FF3333333330000333333364463333333333333388F33333333
      00003333333E66433333333333338F38F3333333000033333333E66333333333
      33338FF8F3333333000033333333333333333333333338833333333300003333
      3333446333333333333333FF3333333300003333333666433333333333333888
      F333333300003333333E66433333333333338F38F333333300003333333E6664
      3333333333338F38F3333333000033333333E6664333333333338F338F333333
      0000333333333E6664333333333338F338F3333300003333344333E666433333
      333F338F338F3333000033336664333E664333333388F338F338F33300003333
      E66644466643333338F38FFF8338F333000033333E6666666663333338F33888
      3338F3330000333333EE666666333333338FF33333383333000033333333EEEE
      E333333333388FFFFF8333330000333333333333333333333333388888333333
      0000}
    Layout = blGlyphRight
    NumGlyphs = 2
  end
  object HP1: THProcess
    OnTerminate = HP2Terminate
    OnDraw = HP1Draw
    OnTrace = HP1Trace
    Priority = tpNormal
    Suspended = False
    OnExecute = HP1Execute
    OnException = HP2Exception
    Interval = 0
    Cycled = False
    TraceName = 'HP1'
    Left = 40
    Top = 16
  end
  object HP2: THProcess
    OnTerminate = HP2Terminate
    OnDraw = HP1Draw
    OnTrace = HP1Trace
    Priority = tpNormal
    Suspended = False
    OnExecute = HP1Execute
    OnException = HP2Exception
    Interval = 0
    Cycled = False
    TraceName = 'HP2'
    Left = 112
    Top = 16
  end
end
