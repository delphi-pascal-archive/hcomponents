unit UTestNew;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  HProcess, StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    HP1: THProcess;
    HP2: THProcess;
    LB1: TListBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    procedure HP1Draw(Sender: TObject; Params: Pointer);
    procedure HP1Execute(Sender: TObject);
    procedure HP1Trace(Sender: TObject; S: String);
    procedure HP2Exception(Sender: TObject; E: Exception);
    procedure HP2Terminate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

Const
   NP : Integer = 0;

Var
   HP : Array[1..27] of THProcess;

implementation

{$R *.DFM}

procedure TForm1.HP1Draw(Sender: TObject; Params: Pointer);
Var
   i : ^Integer Absolute Params;
begin
   With THProcess(Sender) do
      LB1.Items.Add( 'Draw ' + IntToStr( i^ ) + ' ' + Name );
end;

procedure TForm1.HP1Execute(Sender: TObject);
Var
   i, j : Integer;
begin
   j := 1;
   With THProcess(Sender) do
      begin
         if Name = 'HP1' then
            i := Round( 12345 / j )
         else
            i := Round( 54321 / j );
         Draw( Addr(i) );
         Trace( Name );
         Sleep( Random( 100 ) );
      end;
end;

procedure TForm1.HP1Trace(Sender: TObject; S: String);
begin
   LB1.Items.Add( 'Trace ' + S + '=' + THProcess(Sender).Name );
end;

procedure TForm1.HP2Exception(Sender: TObject; E: Exception);
begin
   With THProcess(Sender) do
      Trace( 'Except ' + Name + ' ' + E.Message );
end;

procedure TForm1.HP2Terminate(Sender: TObject);
Var
   Process : THProcess Absolute Sender;
begin
   With Process do
      begin
         Trace( 'Terminate "' + Name + '" ' +
            IntToStr( ProcessID ) + ' End.' );
         if Name = '' then
            begin
               Dec( NP );
               Label2.Caption := IntToStr( NP );
               Destroy;
            end;
      end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
   Inc( NP );
   Label2.Caption := IntToStr( NP );
   HP[NP] := CreateBy( '', HP1 );
   HP[NP].ProcessID := NP;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
Var
   i : Integer;
begin
   for i:=1 to NP do
      HP[i].Resume;
end;

end.
