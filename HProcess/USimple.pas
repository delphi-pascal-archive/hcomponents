{
   Простой пример.
   Демонстрирует завершение-возобновление бесконечного
   процесса и взаимодействие процесса с VCL-потоком.
}
unit USimple;

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
   StdCtrls,
   HProcess;

type
   TForm1 = class( TForm )
      HProcess1 : THProcess;
      Label1 : TLabel;
      procedure HProcess1Draw( HP : THProcess; Params : Pointer );
      procedure HProcess1Execute( HP : THProcess );
      procedure Label1Click( Sender : TObject );
      procedure FormClick( Sender : TObject );
      procedure HProcess1Terminate( HP : THProcess );
   Private
      { Private declarations }
   Public
      { Public declarations }
   end;

var
   Form1 : TForm1;

implementation

{$R *.DFM}

procedure TForm1.HProcess1Draw( HP : THProcess; Params : Pointer );
var
   i : ^Integer Absolute Params;
begin
   Label1.Caption := IntToStr( i^ );
end;

procedure TForm1.HProcess1Execute( HP : THProcess );
var
   i : Integer;
begin
   i := 0;
   repeat
      HP.Draw( @i );
      Sleep( 100 );
      Inc( i );
   until false;
end;

procedure TForm1.Label1Click( Sender : TObject );
begin
   Close;
end;

procedure TForm1.FormClick( Sender : TObject );
begin
   if HProcess1.Terminated then
      HProcess1.Resume
   else
      HProcess1.TerminateHard;
end;

procedure TForm1.HProcess1Terminate( HP : THProcess );
begin
   ShowMessage( 'The process is completed...' );
end;

end.

