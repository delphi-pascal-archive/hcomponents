unit Unit1;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, HProcess, StdCtrls;

type
   TForm1 = class( TForm )
      HProcess1: THProcess;
      Label1: TLabel;
      procedure HProcess1Execute( HP: THProcess );
      procedure HProcess1Trace( HP: THProcess; S: string );
   private
      { Private declarations }
   public
      { Public declarations }
   end;

var
   Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.HProcess1Execute( HP: THProcess );
var
   n: Integer;
begin
   n:=0;
   repeat
      HP.Trace( IntToStr( n ) );
      Inc( n );
      Sleep( 200 );
   until False;
end;

procedure TForm1.HProcess1Trace( HP: THProcess; S: string );
begin
   Label1.Caption := S;
end;

end.

