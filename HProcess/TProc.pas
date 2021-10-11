unit TProc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  HProcess, StdCtrls, Buttons, Placemnt;

type
  TForm1 = class(TForm)
    HP1: THProcess;
    Label1: TLabel;
    HP2: THProcess;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ListBox1: TListBox;
    SpeedButton3: TSpeedButton;
    O: THProcess;
    HP3: THProcess;
    CH: THChannel;
    CH2: THChannel;
    FormPlacement1: TFormPlacement;
    procedure HP1Execute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HP1Draw(Sender: TObject);
    procedure HP2Draw(Sender: TObject);
    procedure HP2Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure HP1Trace(P : Pointer; S: String);
    procedure SpeedButton3Click(Sender: TObject);
    procedure OExecute(Sender: TObject);
    procedure HP3Execute(Sender: TObject);
    procedure OTerminate(Sender: TObject);
    procedure HP2Exception(Sender: TObject);
    procedure HP1Exception(Sender: TObject);
    procedure HP3Exception(Sender: TObject);
    procedure HP1Terminate(Sender: TObject);
    procedure HP2Terminate(Sender: TObject);
    procedure HP3Terminate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Tmr :
     Record
        P1 : Integer;
        P2 : Integer;
     end;

Const
   Done : Boolean = false;

implementation

{$R *.DFM}

procedure TForm1.HP1Execute(Sender: TObject);
{
   Процесс - генератор ДАННЫХ
}
Var
   j : Integer;
begin
   With HP1 do
      begin
         Repeat
            j := Random( 1000 ); { Генерируем данные }
            Trace('begin');
            Delay(400);  { Имитируем процесс генерации }
            Trace('Write CH');
            WriteData( j, CH, SizeOf( Integer ) ); { Отправляем в обработку }
            if WaitResult = wrTimeOut then
               begin
                  Trace('Write TimeOUT');
                  Continue;
               end;
            Draw( Addr( j ) );  { Изображаем на экране }
         Until Done or Terminated;
//         Trace('HP1 End' );
//         CH.Post;
      end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
   HP1.TerminateHard;
   HP2.TerminateHard;
   HP3.TerminateHard;
   O.TerminateHard;
end;

procedure TForm1.HP1Draw(Sender: TObject);
Var
   P : ^Integer absolute Sender;
begin
   Label1.Caption := IntToStr( P^ );
end;

procedure TForm1.HP2Draw(Sender: TObject);
Var
   P : ^Integer absolute Sender;
begin
   Label2.Caption := IntToStr( P^ );
end;

procedure TForm1.HP2Execute(Sender: TObject);
{
   Процесс - обработчик ДАННЫХ
}
Var
   j : Integer;
begin
   With HP2 do
      Repeat
         Trace( 'begin' );
         Tmr.P2 := 0;
         Trace('Read CH' );
         ReadData( CH, j, SizeOf( Integer ) ); { Читаем данные }
         if WaitResult = wrTimeOut then
            Continue;
         Trace( 'begin' );
         Draw( Addr( j ) );  { Изображаем на экране }
         j := j * 1000;      { Обрабатываем }
         Tmr.P2 := 1;
         Delay( 500 );       { Имитирует процесс обработки }
         Tmr.P2 := 0;
         Trace( 'Write CH2 ');
         WriteData( j, CH2, SizeOf( Integer ) ); { Отсылаем  }
         if WaitResult = wrTimeOut then
            Trace('Write TimeOUT');
         if WaitResult = wrAbandoned then
            Trace('Write Abandoned' );
         if WaitResult = wrSignaled then
            Trace('Write Signaled' );
      Until Done or Terminated;
//      HP2.Trace('HP2 End' );
      CH2.Post;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   tmr.p1 := 0;
   tmr.P2 := 0;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
   Ch.Post;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
   ch2.Post;
end;

procedure TForm1.HP1Trace( P : Pointer; S: String );
Var
   T : String;
   PR : ^THProcess Absolute P;
begin
   T := FormatDateTime( 'hh:nn:ss:zzz', Now ) + ' - ' + PR^.TraceName +
      ': "' + S + '"';
   ListBox1.Items.Add( T );
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
   Done := True;
end;

procedure TForm1.OExecute(Sender: TObject);
Var
   S : String;
begin
   repeat
      S := IntToStr( Tmr.P1 ) + ' ' + IntToStr( Tmr.P2 );
    //  O.Trace( S );
      Sleep( 100 );
   Until Done or O.Terminated;
end;

procedure TForm1.HP3Execute(Sender: TObject);
Var
   j, i : Integer;
begin
   With HP3 do
      Repeat
         Trace( 'begin' );
         Trace( 'Read CH2' );
         ReadData( CH2, j, SizeOf(Integer) );
         Trace( 'Draw j = ' + IntToStr( j ) );
         Try
            i := Round( 1000 / j ); { Деление для EXCEPT }
         except
            i := 0;
            Trace( 'Draw j = ' + IntToStr( j ) + ' - Деление на 0 !' );
            //Terminate;
         end;
         Draw( Addr( i ) );
         Trace( 'Draw' );
      Until Done or Terminated;
   CH.Post;
   Done := True;
end;

procedure TForm1.OTerminate(Sender: TObject);
begin
   O.Trace('---------------------O End' );
end;

procedure TForm1.HP2Exception(Sender: TObject);
begin
   ShowMessage( 'HP2 Exception.' );
end;

procedure TForm1.HP1Exception(Sender: TObject);
begin
   ShowMessage('HP1 Exeption.');
end;

procedure TForm1.HP3Exception(Sender: TObject);
begin
   ShowMessage( 'HP3 Exeption.' + Exception(Sender).Message );
end;


procedure TForm1.HP1Terminate(Sender: TObject);
begin
   HP1.Trace( '------------HP1 end.' );
end;

procedure TForm1.HP2Terminate(Sender: TObject);
begin
   HP2.Trace( '------------HP2 end.' );
end;

procedure TForm1.HP3Terminate(Sender: TObject);
begin
   HP3.Trace( '------------HP3 end.' );
end;

end.
