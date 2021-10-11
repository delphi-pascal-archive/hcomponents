{
   ������ ������������� �������������� ���������� ���������
   � VCL-�������, ������������ �������� � ���������� ���������,
   ������������� ������ ������ � ������ ����������������,
   �������� � ������������� ���������� ��������, ������������
   �������� � �������� �����������, ������������� ���������
   ����������.

   ������ ������� �� ����� � ����������� �� �� ������. ������ �����
   ����������� ������. ���������� ������� �� ����� ���� ������
   ������������� �����(������ �����). ��� ����� � ���� �����
   ���������� : ������� ��������, ���������� �������, ������������
   �����.

   ����� ����� ��������� ���� �����. �����, � ���� �������,
   ������� ���� ������ � �. �.

   PS
    � ������� ������������� �������� ���������� ���������,
    �� �� ��������������.
}

unit UBugs;

interface

uses
   Windows,
   Messages,
   SysUtils,
   Classes,
   Graphics,
   Controls,
   Forms,
   Math,
   Dialogs,
   ExtCtrls,
   StdCtrls,
   HProcess,
   Buttons,
   AppEvnts;

type
   TForm1 = class( TForm )
      HProcess1 : THProcess;
      BNew : TSpeedButton;
      Label1 : TLabel;
      Label2 : TLabel;
      Label3 : TLabel;
      SpeedButton1 : TSpeedButton;
      HMonitor1 : THMonitor;
      HProcess2 : THProcess;
      procedure HProcess1Execute( Sender : THProcess );
      procedure HProcess1Draw( Sender : THProcess; Params : Pointer );
      procedure HMonitor1Enter( Sender : THProcess; Params : Pointer );
      procedure FormCreate( Sender : TObject );
      procedure BNewClick( Sender : TObject );
      procedure HProcess1Exception( Sender : THProcess; E : Exception );
      procedure Shape1MouseDown( Sender : TObject; Button : TMouseButton;
         Shift : TShiftState; X, Y : Integer );
      procedure FormClick( Sender : TObject );
      procedure HProcess1Terminate( Sender : THProcess );
      procedure SpeedButton1Click( Sender : TObject );
      procedure FormClose( Sender : TObject; var Action : TCloseAction );
      procedure FormShow( Sender : TObject );
      procedure HProcess2Execute( HP : THProcess );
      procedure HProcess2Draw( HP : THProcess; Params : Pointer );
      procedure HProcess2Terminate( HP : THProcess );
      procedure FormResize( Sender : TObject );
   private
      { Private declarations }
      BodyArray : TList;
      fH, fW : Integer;
      NP : Integer;
      NPMax : Integer;
      Mas : Integer;
      Kill : Integer;
      Speed : Integer;
      Score : Integer;
      Flag : Boolean;
   public
      { Public declarations }
   end;

var
   Form1 : TForm1;

type
   ParamsRec =
      record
      iX, iY : Real; // ����������
      iD, iR : Real; // ������� � ������
      DelX, DelY : Real; // ��������� ����������
      Body : TShape; // ���� ������
   end;

   PParams =
      ^ParamsRec;

var
   StartTime : LongWord;

implementation

{$R *.DFM}

procedure TForm1.HProcess1Execute( Sender : THProcess );
{ ��������� ������� �������� }
var
   HX : THProcess absolute Sender;
begin
   HX := GetCurrentHProcess;
   with HX do
      repeat
         MonitorEnter( Params );
         Draw( Params );
         Sleep( Speed );
      until Terminated;
end;

function Sign( i : Real ) : Integer;
begin
   if i < 0 then
      RESULT := -1
   else
      RESULT := 1;
end;

procedure CalcBoom( var a, b : ParamsRec );
const
   Mu = 1;
var
   AB, aa, bb, V1, V2,
      aPrXx, aPrXy,
      aPrYx, aPrYy,
      aPrX, aPrY,
      bPrXx, bPrXy,
      bPrYx, bPrYy,
      bPrX, bPrY,
      alfaA, betaA, gammaA,
      alfaB, betaB, gammaB : Extended;
   {
      ��������� �� ���, ����� �� "��������� ������� ������������
      ���������� �����".
      �� ��������...
   }

begin
   AB := sqrt( sqr( a.ix - b.ix ) + sqr( a.iY - b.iY ) );
   V1 := sqrt( a.DelX * a.DelX + a.DelY * a.DelY );
   V2 := sqrt( b.DelX * b.DelX + b.DelY * b.DelY );

   aPrXx := 0;
   aPrXy := 0;
   bPrXx := 0;
   bPrXy := 0;
   ////////-ball #1-
   if V1 > 0.01 then
      begin
         if ( b.iy - a.iy ) > 0 then
            alfaA := arccos( ( b.ix - a.ix ) / AB )
         else
            alfaA := -arccos( ( b.ix - a.ix ) / AB );

         if a.DelY > 0.01 then
            gammaA := arccos( a.DelX / V1 )
         else
            gammaA := -arccos( a.DelX / V1 );

         betaA := gammaA - alfaA;

         aPrX := V1 * cos( betaA );
         aPrY := V1 * sin( betaA );
         aPrXx := aPrX * cos( alfaA );
         aPrXy := aPrX * sin( alfaA );
         aPrYx := aPrY * sin( alfaA );
         aPrYy := aPrY * cos( alfaA );
      end;

   //////////////-ball #2-
   if V2 > 0.01 then
      begin
         if ( a.iy - b.iy ) > 0 then
            alfaB := arccos( ( a.ix - b.ix ) / AB ) //=alfaA+pi
         else
            alfaB := -arccos( ( a.ix - b.ix ) / AB );

         if b.DelY > 0.01 then
            gammaB := arccos( b.DelX / V2 )
         else
            gammaB := -arccos( b.DelX / V2 );

         betaB := gammaB - alfaB;

         bPrX := V2 * cos( betaB );
         bPrY := V2 * sin( betaB );
         bPrXx := bPrX * cos( alfaB );
         bPrXy := bPrX * sin( alfaB );
         bPrYx := bPrY * sin( alfaB );
         bPrYy := bPrY * cos( alfaB );
      end;

   a.DelX := ( ( a.DelX - aPrXx ) + bPrXx ) * mu; // = mu*(bPrXx - aPrXx)
   a.DelY := ( ( a.DelY - aPrXy ) + bPrXy ) * mu; // = mu*(bPrXy - aPrXy)
   b.DelX := ( ( b.DelX - bPrXx ) + aPrXx ) * mu; // = mu*(aPrXx - bPrXx)
   b.DelY := ( ( b.DelY - bPrXy ) + aPrXy ) * mu; // = mu*(aPrXy - bPrXy)
end;

procedure TForm1.HMonitor1Enter( Sender : THProcess; Params : Pointer );
{ ��������� ������� �����������
  ��������������� ������ ��������� �������� �� ����������
  �������� VCL-����������� }
var
   P1 : PParams absolute Params;
   HP : THProcess absolute Sender;
   PHP : PHProcess;
   P2 : PParams;
   i : Integer;
   X, Y, Xc, Yc : Real;
   Xc2, Yc2, l1, l2, L : Real;
   TSh : TShapeType;

begin

   with P1^ do
      begin
         X := iX + DelX;
         Y := iY + DelY;

         for i := 1 to BodyArray.Count do // ����� ������� �������
            begin // ����� ���������� ��������� ������...
               PHP := BodyArray.Items[ i - 1 ];

               if HP = PHP^ then
                  Continue;

               P2 := PHP^.Params; // ��������� ������� ������

               Xc := X - P2^.iX;
               Yc := Y - P2^.iY;

               l1 := Sqr( Xc );
               l2 := Sqr( Yc );

               L := Sqrt( l1 + l2 ); // ���������� ����� ��������

               l1 := P1^.iR + P2^.iR;

               if L <= l1 then
                  begin
                     // ������������
                     X := X + DelX * ( L - l1 ) / Sqrt( DelX * DelX + DelY * DelY );
                     Y := Y + DelY * ( L - l1 ) / Sqrt( DelX * DelX + DelY * DelY );
                     HP.Draw( P1 );
                     CalcBoom( P1^, P2^ );
                  end;

               // ...
            end;

         { �������� ����������� (������) }
         if ( Y + iD > fH ) or ( Y <= 0 ) then
            DelY := -DelY;

         if ( Y + iD >= fH ) then
            Y := fH - iD;

         if ( Y <= 0 ) then
            Y := 0;

         if ( X + iD >= fW ) or ( X <= 0 ) then
            DelX := -DelX;

         if ( X + iD >= fW ) then
            X := fW - iD;

         if ( X <= 0 ) then
            X := 0;

         iX := X;
         iY := Y;
      end;
end;

procedure TForm1.HProcess1Draw( Sender : THProcess; Params : Pointer );
{ ���������� ������ }
var
   P : PParams absolute Params;
   S : string;

begin
{   Str( HProcess1.GetAllClonesProcessorTime / GetProcessorTime * 100 : 6 : 3, S );
   PT.Caption := S;
   Str( GetProcessorTime / ( GetTickCount - StartTime ) * 100 : 6 : 3, S );
   PT.Caption := PT.Caption + '/' + S;}
   with P^ do
      begin
         FormResize( Sender );
         Body.Top := Trunc( iY ); // ����������� �� �����
         Body.Left := Trunc( iX ); // �������
         S := IntToStr( Sender.ProcessID );

         if NP < NPMax then
            BNewClick( Sender );

      end;
end;

procedure TForm1.FormCreate( Sender : TObject );
begin
   BodyArray := TList.Create;
   NP := 0;
   NPMax := 3;
   Mas := 0;
   Kill := 0;
   Speed := 20;
   Score := 0;
   Flag := false;
   Randomize;
end;

procedure TForm1.BNewClick( Sender : TObject );
var
   P : PParams;
   PHP : PHProcess;
begin
   { �������� ������ }
   New( P );

   with P^ do
      begin
         //         P^.FW := fW;
         //         P^.FH := fH;

         Body := TShape.Create( SELF );
         Body.Visible := false;

         repeat
            iD := Random( 70 );
         until iD > 20;

         iR := iD / 2;

         repeat
            iY := Random( fH );
         until iY + iD < fH;

         repeat
            iX := Random( fW );
         until iX + iD < fW;

         Body.Parent := SELF;

         Body.Brush.Color := Random( $7FFFF );
         Body.Shape := stCircle;
         Body.Pen.Mode := pmNotMask;
         Body.OnMouseDown := SELF.Shape1MouseDown;

         repeat
            DelX := Random( 10 ) - 5;
            DelY := Random( 10 ) - 5;
         until ( DelX <> 0 ) and ( DelY <> 0 );

         Body.Height := Round( iD );
         Body.Width := Body.Height;
         Body.Top := Round( iY );
         Body.Left := Round( iX );

         Body.Visible := True;
      end;

   { �������� �������� }

   Inc( NP );
   PHP := HProcess1.CreateNew;
   PHP^.Params := P;

   { ��������� �������� }

   HMonitor1.Lock; // ���� � ������ �������� ���� �����������...
   PHP^.ProcessID := BodyArray.Add( PHP ); { <--- � ��������� ������
   ���������}
   HMonitor1.UnLock;

   PHP^.Execute;
end;

procedure TForm1.HProcess1Exception( Sender : THProcess; E : Exception );
begin
   { ��������� ���� - ������ ����� ��������� �� ������ }
   ShowMessage( E.Message );
end;

procedure TForm1.Shape1MouseDown( Sender : TObject; Button : TMouseButton;
   Shift : TShiftState; X, Y : Integer );
{ "��������" �������� �������� ������ ���� }
var
   P : PParams;
   PHP : PHProcess;
   i, j : Integer;
begin

   // ������ �� ������� ��������� � VCL

   HMonitor1.Lock;

   for i := 1 to BodyArray.Count do
      begin
         j := i - 1;
         PHP := BodyArray.Items[ j ];
         P := PHP^.Params;
         { ����� Shape �� ������� ������ ���� }
         if P^.Body = Sender then
            begin

               BodyArray.Delete( j ); // �� ������ - �������
               PHP^.Terminate; // ��������� �������

               Score := Score + Round( 70 - P^.iD );
               Label3.Caption := 'Score : ' + IntToStr( Score );
               Break;
            end;
      end;

   HMonitor1.UnLock;

end;

procedure TForm1.FormClick( Sender : TObject );
{ ������ - ���� ����� �� ����� }
begin
   Inc( Mas );
   Label1.Caption := 'Miss : ' + IntToStr( Mas );
end;

procedure TForm1.HProcess1Terminate( Sender : THProcess );
var
   HP : THProcess absolute Sender;
   P : PParams;
   i, j, k : Integer;
   PHP : PHProcess;
begin
   { ���� ������� ��� ������ �� ������.
     �� ��� ��� ��������� ��������. �� �������� � ����� �������. }
   PHP := HProcess2.CreateNew;
   PHP^.Params := HP.Params;
   PHP^.Execute; // ���� ����� ������� ����� ������� ������...

   HP.Destroy; // ��� ������� �������
   Dec( NP );
   Inc( Kill );
   Label2.Caption := 'Kill : ' + IntToStr( Kill );
   { ps.
      ����� �������� ���������� ��������� ���
      ��������� ���������� ��������.
   }
end;

procedure TForm1.SpeedButton1Click( Sender : TObject );
var
   Temp : ^TForm1;
begin
   New( Temp );
   Temp^ := TForm1.Create( Form1 );
   Temp^.Flag := True;
   Temp^.Show;
end;

procedure TForm1.FormClose( Sender : TObject; var Action : TCloseAction );
begin
   if Flag then
      Destroy;
end;

procedure TForm1.FormShow( Sender : TObject );
begin
   FormResize( Sender );
   if Flag then
      Caption := Caption + '( New )'
   else
      Caption := Caption + '( Main )';

   StartTime := GetTickCount;   

end;

procedure TForm1.HProcess2Execute( HP : THProcess );
{ ������ ������ }
var
   P : PParams;
begin
   P := HP.Params;
   while P^.iD > 2 do
      begin
         P^.iD := P^.iD - 2;
         P^.iX := P^.iX + 1;
         P^.iY := P^.iY + 1;
         HP.Draw( P );
         Sleep( 50 );
      end;
end;

procedure TForm1.HProcess2Draw( HP : THProcess; Params : Pointer );
var
   P : PParams absolute Params;
begin
   P^.Body.Width := Round( P^.iD );
   P^.Body.Top := Round( P^.iY );
   P^.Body.Left := Round( P^.iX );
   // P^.Body.Brush.Style := TBrushStyle( Random( 9 ) );
   P^.Body.Update;
end;

procedure TForm1.HProcess2Terminate( HP : THProcess );
var
   P : PParams;
begin
   P := HP.Params;
   P.Body.Destroy;
   Dispose( P );
end;

procedure TForm1.FormResize( Sender : TObject );
begin
   fH := SELF.ClientHeight;
   fW := SELF.ClientWidth;
end;

end.

