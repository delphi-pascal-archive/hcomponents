unit UBags;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, HProcess, Buttons;

type
  TForm1 = class(TForm)
    HProcess1: THProcess;
    HMutex1: THMutex;
    BNew: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure HProcess1Execute(Sender: THProcess);
    procedure HProcess1Draw(Sender: THProcess; Params: Pointer);
    procedure HMutex1Enter(Sender: THProcess; Params: Pointer);
    procedure FormCreate(Sender: TObject);
    procedure BNewClick(Sender: TObject);
    procedure HProcess1Exception(Sender: THProcess; E: Exception);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClick(Sender: TObject);
    procedure HProcess1Terminate(Sender: THProcess);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

Const
   NP : Integer = 0;
   NPMax = 9;
   Mas : Integer = 0;
   Kill : Integer = 0;
   Speed : Integer = 20;
   Score : Integer = 0;

Type
   ParamsRec =
      Record
        // Action : Integer;
         TimeLive : Real;
         iX, iY : Real;
         iD, iR : Real;
         DelX, DelY : Real;
         Body : TShape;
      end;

   PParams =
      ^ParamsRec;

Var
   BodyArray : TList;
   D1 : ParamsRec;
   fH, fW : Integer;

Const
   Flag   : Boolean = false;

implementation

{$R *.DFM}

procedure TForm1.HProcess1Execute(Sender: THProcess);
{ ��������� ������� �������� }
Var
   HP : THProcess absolute Sender;
begin
   With HP do
      repeat
         HMutex1Enter( Sender, Params );
         Draw( Params );
         Sleep( Speed );
       Until Terminated;
end;

procedure TForm1.HProcess1Draw(Sender: THProcess; Params: Pointer);
{ ���������� ������ }
Var
   P : PParams Absolute Params;
   S : String;
begin
   with P^ do
      begin

         Body.Top := Trunc(iY); // ����������� �� �����
         Body.Left := Trunc(iX);// �������
         S := IntToStr( Sender.ProcessID );
        
         if NP < NPMax then
            BNewClick(Sender);

      end;
end;

function Sign( i : Real ) : Integer;
begin
   if i < 0 then
      RESULT := -1
   else
      RESULT := 1;
end;

procedure TForm1.HMutex1Enter(Sender: THProcess; Params: Pointer);
{ ��������� ������� �����������
  ��������������� ������ ��������� �������� �� ����������
  �������� VCL-����������� }
Var
   P1 : PParams Absolute Params;
   HP : THProcess Absolute Sender;
   PHP : PHProcess;
   P2 : PParams;
   i : Integer;
   X, Y, Xc, Yc, NDel : Real;
   Xc2, Yc2, l1, l2, L : Real;
   Cycles : Integer;
begin
   Cycles := 0;

   With P1^ do
      begin
         X := iX + DelX;
         Y := iY + DelY;

{         NDel := Sqrt( DelX * DelX + DelY * DelY );

         for i:=1 to BodyArray.Count do // ����� ������� �������
            begin                       // ����� ���������� ��������� ������...
               PHP := BodyArray.Items[i-1];

               if Sender = PHP^ then
                  Continue;

               P2 := PHP^.Params;

               Xc := X + P1^.iR;
               Yc := Y + P1^.iR;

               Xc2 := P2^.iX + P2^.iR;
               Yc2 := P2^.iY + P2^.iR;

               l1 := Sqr( Xc - Xc2 );
               l2 := Sqr( Yc - Yc2 );

               L := Sqrt( l1 + l2 );  // ���������� ����� ��������

               l1 := P1^.iR + P2^.iR;

               if L < l1 then
                  begin
                     // ������������

                     X := iX + ( l1 - L ) * DelX / NDel;
                     Y := iY + ( l1 - L ) * DelY / NDel;

                     NDel := Sqrt( DelX * DelX + P2^.DelX * P2^.DelX );
                     DelX := -( DelX - P2^.DelX ) / NDel;

                     NDel := Sqrt( DelY * DelY + P2^.DelY * P2^.DelY );
                     DelY := -( DelY - P2^.DelY ) / NDel;

                     NDel := Sqrt( DelX * DelX + P2^.DelX * P2^.DelX );
                     P2^.DelX := -( DelX - P2^.DelX ) / NDel;

                     NDel := Sqrt( DelY * DelY + P2^.DelY * P2^.DelY );
                     P2^.DelY := -( DelY - P2^.DelY ) / NDel;

                  end;
               // ...
            end; }

{ �������� ����������� (������) }
         if ( Y + iD > fH ) Or ( Y <= 0 ) then
            DelY := -DelY;

         if ( Y + iD >= fH ) then
            Y := fH - iD;

         if ( Y <= 0 ) then
            Y := 0;

         if ( X + iD >= fW ) Or ( X <= 0 ) then
            DelX := -DelX;

         if ( X + iD >= fW ) then
            X := fW - iD;

         if ( X <= 0 ) then
            X := 0;

         iX := X;
         iY := Y;
      end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   BodyArray := TList.Create;
   Randomize;
end;

procedure TForm1.BNewClick(Sender: TObject);
Var
   P : PParams;
   PHP : ^THProcess;
begin
{ �������� ������ }
   New( P );
   With P^ do
      begin

         fH := Form1.Canvas.ClipRect.Bottom;
         fW := Form1.Canvas.ClipRect.Right;

         Body := TShape.Create( Form1 );
         Body.Visible := false;

         Repeat
            iD := Random(50);
         Until iD > 15;

         iR := iD / 2;

         Repeat
            iY := Random(fH);
         Until iY + iD < fH;

         Repeat
            iX := Random(fW);
         Until iX + iD < fW;

         Body.Parent := Form1;

         Body.Brush.Color := Random($7FFF);
         Body.Shape := stCircle;
         Body.Pen.Mode := pmNotMask;
         Body.OnMouseDown := Form1.Shape1MouseDown;

         Repeat
            DelX := Random( 6 ) - 3;
            DelY := Random( 6 ) - 3;
         Until ( DelX <> 0 ) and ( DelY <> 0 );

         Body.Height := Round(iD);
         Body.Width := Body.Height;
         Body.Top := Round(iY);
         Body.Left := Round(iX);

         Body.Visible := True;

         TimeLive := 0;
      end;

{ �������� �������� }

   Inc( NP );
   New( PHP );
   PHP^ := HProcess1.CreateNew;
   PHP^.Params := P;

{ ��������� �������� }

   HMutex1.Lock;  // ���� � ������ �������� ���� �����������...
   PHP^.ProcessID := BodyArray.Add( PHP ); { <--- � ��������� ������
                                                  ���������}
   HMutex1.UnLock;

   PHP^.Execute;
end;

procedure TForm1.HProcess1Exception(Sender: THProcess; E: Exception);
begin
   { ��������� ���� - ������ ����� ��������� �� ������ }
   ShowMessage( E.Message );
end;

procedure TForm1.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{ "��������" �������� �������� ������ ���� }
Var
   P : PParams;
   PHP : PHProcess;
   i, j : Integer;
begin
   Flag := True;

// ������ �� ������� ��������� � VCL

   HMutex1.Lock;

   for i:=1 to BodyArray.Count do
      begin
         j := i - 1;
         PHP := BodyArray.Items[j];
         P := PHP^.Params;
         { ����� Shape �� ������� ������ ���� }
         if  P^.Body = Sender then
            begin

               BodyArray.Delete( j ); // �� ������ - �������
               PHP^.Terminate; // ��������� �������

               Score := Score + Round( 50 - P^.iD );
               Label3.Caption := 'Score : ' + IntToStr( Score );
               Break;
            end;
      end;

   HMutex1.UnLock;

end;

procedure TForm1.FormClick(Sender: TObject);
{ ������ - ���� ����� �� ����� }
begin
   Inc( Mas );
   Label1.Caption := 'Miss : ' + IntToStr( Mas );
end;

procedure TForm1.HProcess1Terminate(Sender: THProcess);
Var
   HP : THProcess Absolute Sender;
   P : PParams;
begin
{ ���� ������� ��� ������ �� ������.
  �� ��� ��� ��������� ��������. �� ���� ���������. }
   P := HP.Params;
   P^.Body.Destroy; // ��������� Shape,
   Dispose( P );    // ��������� ����������,
   HP.Destroy;      // ��� �������
   Dec( NP );
   Inc( Kill );
   Label2.Caption := 'Kill : ' + IntToStr( Kill );
{ ps.
   ����� �������� ���������� ��������� ���
   ��������� ���������� ��������.
}
end;

procedure TForm1.FormResize(Sender: TObject);
begin
   fH := Form1.Canvas.ClipRect.Bottom;
   fW := Form1.Canvas.ClipRect.Right;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
   PaintDesktop( form1.Canvas.Handle );
   beep;
end;

end.
