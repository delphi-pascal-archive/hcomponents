{
   ������ ������������� �������������� ���������� ���������
   � VCL-�������, ������������ �������� � ���������� ���������,
   ������������� ������ ������ � ������ ����������������,
   �������� � ������������� ���������� ��������, ������������
   �������� � �������� �����������, ������������� ���������
   ����������.

   ������ ������� �� ����� � ����������� �� �� ������. �� �����
   ���������� ������. ���������� ������� �� ����� ���� ������
   ������������� �����(������ �����). ��� ����� � ���� �����
   ���������� : ������� ��������, ������ �������, ������������
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, HProcess, Buttons;

type
  TForm1 = class(TForm)
    HProcess1: THProcess;
    BNew: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    HMonitor1: THMonitor;
    procedure HProcess1Execute(Sender: THProcess);
    procedure HProcess1Draw(Sender: THProcess; Params: Pointer);
    procedure HMonitor1Enter(Sender: THProcess; Params: Pointer);
    procedure FormCreate(Sender: TObject);
    procedure BNewClick(Sender: TObject);
    procedure HProcess1Exception(Sender: THProcess; E: Exception);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClick(Sender: TObject);
    procedure HProcess1Terminate(Sender: THProcess);
    procedure FormResize(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
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
  Form1: TForm1;

Type
   ParamsRec =
      Record
         iX, iY : Real; // ����������
         iD, iR : Real; // ������� � ������
         DelX, DelY : Real; // ��������� ����������
         Body : TShape;  // ���� ������
      end;

   PParams =
      ^ParamsRec;

implementation

{$R *.DFM}

procedure TForm1.HProcess1Execute(Sender: THProcess);
{ ��������� ������� �������� }
Var
   HP : THProcess absolute Sender;
begin
   With HP do
      repeat
         MonitorEnter( Params );
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

procedure TForm1.HMonitor1Enter(Sender: THProcess; Params: Pointer);
{ ��������� ������� �����������
  ��������������� ������ ��������� �������� �� ����������
  �������� VCL-����������� }
Var
   P1 : PParams Absolute Params;
   HP : THProcess Absolute Sender;
   PHP : PHProcess;
   P2 : PParams;
   i : Integer;
   X, Y, Xc, Yc : Real;
   Xc2, Yc2, l1, l2, L : Real;
begin

   With P1^ do
      begin
         X := iX + DelX;
         Y := iY + DelY;

         for i:=1 to BodyArray.Count do // ����� ������� �������
            begin                       // ����� ���������� ��������� ������...
               PHP := BodyArray.Items[i-1];

               if Sender = PHP^ then
                  Continue;

               P2 := PHP^.Params;  // ��������� ������� ������

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
                     { ....... }

                  end;
               // ...
            end;

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
   NP := 0;
   NPMax := 9;
   Mas := 0;
   Kill := 0;
   Speed := 20;
   Score := 0;
   Flag := false;
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

         Body := TShape.Create( SELF );
         Body.Visible := false;

         Repeat
            iD := Random(70);
         Until iD > 20;

         iR := iD / 2;

         Repeat
            iY := Random(fH);
         Until iY + iD < fH;

         Repeat
            iX := Random(fW);
         Until iX + iD < fW;

         Body.Parent := SELF;

         Body.Brush.Color := Random($7FFF);
         Body.Shape := stCircle;
         //Body.Shape := TShapeType( Random( 5 ) );
         Body.Pen.Mode := pmNotMask;
         Body.OnMouseDown := SELF.Shape1MouseDown;

         Repeat
            DelX := Random( 6 ) - 3;
            DelY := Random( 6 ) - 3;
         Until ( DelX <> 0 ) and ( DelY <> 0 );

         Body.Height := Round(iD);
         Body.Width := Body.Height;
         Body.Top := Round(iY);
         Body.Left := Round(iX);

         Body.Visible := True;
      end;

{ �������� �������� }

   Inc( NP );
   New( PHP );
   PHP^ := HProcess1.CreateNew;
   PHP^.Params := P;

{ ��������� �������� }

   HMonitor1.Lock;  // ���� � ������ �������� ���� �����������...
   PHP^.ProcessID := BodyArray.Add( PHP ); { <--- � ��������� ������
                                                  ���������}
   HMonitor1.UnLock;

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

// ������ �� ������� ��������� � VCL

   HMonitor1.Lock;

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

   HMonitor1.UnLock;

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
   i, j, k : Integer;
begin
{ ���� ������� ��� ������ �� ������.
  �� ��� ��� ��������� ��������. �� ���� ���������. }
   P := HP.Params;

   i := P^.Body.Width;
   j := P^.Body.Top;
   k := P^.Body.Left;

   While i > 2 do
      begin
         Dec( i, 2 );
         Inc( j );
         Inc( k );
         P^.Body.Width := i;
         P^.Body.Top := j;
         P^.Body.Left := k;
         P^.Body.Update;
         Sleep( 10 );
      end;

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
   fH := Canvas.ClipRect.Bottom;
   fW := Canvas.ClipRect.Right;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
Var
   Temp : ^TForm1;
begin
   New( Temp );
   Temp^ := TForm1.Create( Form1 );
   Temp^.Flag := True;
   Temp^.Show;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if Flag then
      Destroy;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
   FormResize( Sender );
   if Flag then
      Caption := Caption + '( New )'
   else
      Caption := Caption + '( Main )';
end;

end.
