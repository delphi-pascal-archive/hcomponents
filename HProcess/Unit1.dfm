object Form1: TForm1
  Left = 176
  Top = 134
  Width = 725
  Height = 375
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 104
    Top = 32
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object HProcess1: THProcess
    Interval = 0
    Cycled = False
    TraceName = 'HProcess1'
    Suspended = False
    OnExecute = HProcess1Execute
    OnTrace = HProcess1Trace
    Left = 24
    Top = 24
  end
end
