{
   ѕример взаимодействи€ трех процессов по двум каналам.
   ѕервый процесс генерирует число и передает по первому каналу
   во второй. ¬торой процесс, в свою очередь, обрабатывает
   ( умножает на 100 ) и передает в третий, третий завершает
   обработку ( прибавл€ет 20 ).
   ѕервый процесс можно сн€ть и возобновить нажатием кнопки,
   третий можно приостановить и возобновить аналогично.
   ¬ первом процессе недетерминированное ожидание при передаче
   данных( TimeOut = 2 сек) - он закончитс€, если третий процесс
   будет приостановлен и не оживлен через две секунды.
}
unit UTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  HProcess, StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    HP1: THProcess;
    SpeedButton1: TSpeedButton;
    HP2: THProcess;
    Label2: TLabel;
    SpeedButton2: TSpeedButton;
    CH1: THChannel;
    HP3: THProcess;
    CH2: THChannel;
    Label3: TLabel;
    SpeedButton3: TSpeedButton;
    procedure HP1Execute(Sender: THProcess);
    procedure SpeedButton1Click(Sender: TObject);
    procedure HP2Execute(Sender: THProcess);
    procedure SpeedButton2Click(Sender: TObject);
    procedure HP3Execute(Sender: THProcess);
    procedure HP3Draw(Sender: THProcess; Params: Pointer);
    procedure HP1Terminate(Sender: THProcess);
    procedure HP1Draw(Sender: THProcess; Params: Pointer);
    procedure HP2Draw(Sender: THProcess; Params: Pointer);
    procedure SpeedButton3Click(Sender: TObject);
    procedure HP1Trace(Sender: THProcess; S: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.HP1Execute(Sender: THProcess);
Var
   i : Integer;
   HP : THProcess Absolute Sender;
begin
   HP.Trace( 'Go' );
   I := 0;
   With HP do
      repeat
         Draw( Addr( i ) );
         Sleep( 10 );
         WriteData( i, SizeOf( i ), 2000 );
         if WaitResult = wrTimeOut then
            begin
               HP.Trace( 'Time out.' );
               exit;
            end;
         Inc( i );
      Until Terminated;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
   HP1.Terminate;
end;

procedure TForm1.HP2Execute(Sender: THProcess);
Var
   HP : THProcess Absolute Sender;
   i : Integer;
begin
   With HP do
      repeat
         ReadData( i, SizeOf( i ) );
         i := i * 100;
         Draw( Addr( i ) );
         i := i + 20;
         WriteData( i, SizeOf( i ) );
      Until Terminated;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
   if HP3.Suspended then
      begin
         HP3.Resume;
         SpeedButton2.Caption := 'Suspend HP3'
      end
   else
      begin
         HP3.Suspend;
         SpeedButton2.Caption := 'Resume HP3'
      end;   
end;

procedure TForm1.HP3Execute(Sender: THProcess);
Var
   i : Integer;
   HP : THProcess Absolute Sender;
begin
   With HP do
      Repeat
         ReadData( i, SizeOf( i ) );
         Draw( Addr( i ) );
      Until Terminated;
end;

procedure TForm1.HP3Draw(Sender: THProcess; Params: Pointer);
Var
   Px : ^Integer Absolute Params;
begin
   Label3.Caption := IntToStr( Px^ );
end;

procedure TForm1.HP1Terminate(Sender: THProcess);
Var
   HP : THProcess Absolute Sender;
begin
   ShowMessage( HP.Name + ' : End' );
end;

procedure TForm1.HP1Draw(Sender: THProcess; Params: Pointer);
Var
   Px : ^Integer Absolute Params;
begin
   Label1.Caption := IntToStr( Px^ );
end;

procedure TForm1.HP2Draw(Sender: THProcess; Params: Pointer);
Var
   Px : ^Integer Absolute Params;
begin
   Label2.Caption := IntToStr( Px^ );
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
    HP1.Resume;
end;

procedure TForm1.HP1Trace(Sender: THProcess; S: String);
Var
   HP : THProcess Absolute Sender;
begin
   ShowMessage( HP.Name + ' : ' + S );
end;

end.
