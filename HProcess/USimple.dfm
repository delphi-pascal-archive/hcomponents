object Form1: TForm1
  Left = 128
  Top = 146
  Width = 196
  Height = 116
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClick = FormClick
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 80
    Top = 24
    Width = 32
    Height = 13
    Caption = 'Label1'
    OnClick = Label1Click
  end
  object HProcess1: THProcess
    Interval = 0
    Cycled = False
    TraceName = 'HProcess1'
    Suspended = False
    OnExecute = HProcess1Execute
    OnTerminate = HProcess1Terminate
    OnDraw = HProcess1Draw
    Left = 16
    Top = 24
  end
end
