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
   Windows,
   Messages,
   SysUtils,
   Classes,
   Graphics,
   Controls,
   Forms,
   Dialogs,
   HProcess,
   StdCtrls,
   Buttons,
   HVCLOut,
   Placemnt;

type
   TForm1 = class( TForm )
      Label1: TLabel;
      SpeedButton1: TSpeedButton;
      Label2: TLabel;
      Label3: TLabel;
      frmplcmnt1: TFormPlacement;
      btn1: TSpeedButton;
      mmo1: TMemo;
      HP1: THProcess;
      HP2: THProcess;
      HChannel1: THChannel;
      btn2: TSpeedButton;
      procedure HP1Execute( Sender: THProcess );
      procedure SpeedButton1Click( Sender: TObject );
      procedure HP2Execute( Sender: THProcess );
      procedure HP1Draw( Sender: THProcess; Params: Pointer );
      procedure HP2Draw( Sender: THProcess; Params: Pointer );
      procedure btn1Click( Sender: TObject );
      procedure HP1Terminate( HP: THProcess );
      procedure HP1Ended( HP: THProcess );
      procedure HP1Trace( HP: THProcess; S: string );
      procedure btn2Click( Sender: TObject );
   private
      { Private declarations }
   public
      { Public declarations }
   end;

var
   Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.HP1Execute( Sender: THProcess );
var
   i, j: Integer;
   HP: THProcess absolute Sender;
begin
   HP.Trace( 'Go' );
   //Writeln('HP1 Started...');
   i := 0;
   with HP do
      for i := 1 to 5 do
         begin
            Draw( Addr( i ) );
            j := i;
            writeData( j, SizeOf( Integer ) );
            //Sleep( 350 );
         end;
   HP.Trace( 'HP1 Wait...' );
  // Writeln( 'HP1 Wait...' );
   HP.LoadData( HChannel1 );
   HP.Trace( IntToStr( HP.DataLength ) );
end;

procedure TForm1.SpeedButton1Click( Sender: TObject );
begin
   AssignOut( mmo1 );
   HP1.Execute;
   HP2.Execute;
end;

procedure TForm1.HP2Execute( Sender: THProcess );
var
   HP: THProcess absolute Sender;
   i: Integer;
begin
   with HP do
      repeat
         readData( i, SizeOf( Integer ), 1000 );
         if WaitResult = wrTimeOut then
            Break;
         Draw( Addr( i ) );
         //Sleep( 200 );
         if i = 3 then
            HP1.Terminate;
      until Terminated;
   HP.Trace( 'HP2 Timeout...' );
   HP.WriteData( i, HChannel1, 0 );
end;

procedure TForm1.HP1Draw( Sender: THProcess; Params: Pointer );
var
   Px: ^Integer absolute Params;
begin
   WriteLn( 'HP1 ', Px^: 5 );
end;

procedure TForm1.HP2Draw( Sender: THProcess; Params: Pointer );
var
   Px: ^Integer absolute Params;
begin
   Writeln( 'HP2 ', Px^: 5 );
end;

procedure TForm1.btn1Click( Sender: TObject );
begin
   HP1.Resume;
   HP2.Resume;
end;

procedure TForm1.HP1Terminate( HP: THProcess );
begin
   Writeln( 'HP1 Term ' {, HP.ExitCode} );
end;

procedure TForm1.HP1Ended( HP: THProcess );
begin
   Writeln( 'HP1 End' );
end;

procedure TForm1.HP1Trace( HP: THProcess; S: string );
begin
   Writeln( S );
end;

procedure TForm1.btn2Click( Sender: TObject );
var
   z: Integer;
begin

end;

end.

