{
   Пример демонстрирует взаимодействие нескольких процессов
   с VCL-потоком, динамическое создание и завершение процессов,
   использование общего модуля в режиме взаимоисключения,
   передача и использование параметров процесса, динамическое
   создание и удаление компонентов, использование плавающей
   арифметики.

   Пузыри ползают по форме и отскакивают от ее границ. Их можно
   уничтожать мышкой. Количество пузырей не может быть меньше
   определенного числа(больше может). Три метки в углу формы
   показывают : сколько промахов, убитых пузырей, заработанных
   очков.

   Форма может создавать свою копию. Копия, в свою очередь,
   плодить свои пузыри и т. д.

   PS
    В примере отслеживается ситуация соударения пузырьков,
    но не обрабатывается.
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
         iX, iY : Real; // Координаты
         iD, iR : Real; // Диаметр и радиус
         DelX, DelY : Real; // Временное приращение
         Body : TShape;  // Тело пузыря
      end;

   PParams =
      ^ParamsRec;

implementation

{$R *.DFM}

procedure TForm1.HProcess1Execute(Sender: THProcess);
{ Программа каждого процесса }
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
{ Обновление экрана }
Var
   P : PParams Absolute Params;
   S : String;
begin
   with P^ do
      begin

         Body.Top := Trunc(iY); // Перемещение на новыю
         Body.Left := Trunc(iX);// позицию
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
{ Программа расчета перемещения
  Пересчитываются только параметры процесса не затрагивая
  свойства VCL-компонентов }
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

         for i:=1 to BodyArray.Count do // Здесь текущий процесс
            begin                       // может посмотреть состояние других...
               PHP := BodyArray.Items[i-1];

               if Sender = PHP^ then
                  Continue;

               P2 := PHP^.Params;  // Параметры другого пузыря

               Xc := X + P1^.iR;
               Yc := Y + P1^.iR;

               Xc2 := P2^.iX + P2^.iR;
               Yc2 := P2^.iY + P2^.iR;

               l1 := Sqr( Xc - Xc2 );
               l2 := Sqr( Yc - Yc2 );

               L := Sqrt( l1 + l2 );  // Расстояние между центрами

               l1 := P1^.iR + P2^.iR;

               if L < l1 then
                  begin
                     // Столкновение
                     { ....... }

                  end;
               // ...
            end;

{ Проверка препятствия (стенки) }
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
{ Создание шарика }
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

{ Создание процесса }

   Inc( NP );
   New( PHP );
   PHP^ := HProcess1.CreateNew;
   PHP^.Params := P;

{ изменение счетчика }

   HMonitor1.Lock;  // вход в модуль мьютекса надо блокировать...
   PHP^.ProcessID := BodyArray.Add( PHP ); { <--- и дополнить список
                                                  процессов}
   HMonitor1.UnLock;

   PHP^.Execute;
end;

procedure TForm1.HProcess1Exception(Sender: THProcess; E: Exception);
begin
   { Обработка сбоя - просто вывод сообщения об ошибке }
   ShowMessage( E.Message );
end;

procedure TForm1.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{ "Убийство" процесса нажатием кнопки мыши }
Var
   P : PParams;
   PHP : PHProcess;
   i, j : Integer;
begin

// Работа со списком процессов в VCL

   HMonitor1.Lock;

   for i:=1 to BodyArray.Count do
      begin
         j := i - 1;
         PHP := BodyArray.Items[j];
         P := PHP^.Params;
         { поиск Shape на которую попала мышь }
         if  P^.Body = Sender then
            begin

               BodyArray.Delete( j ); // из списка - удалить
               PHP^.Terminate; // Закончить процесс

               Score := Score + Round( 50 - P^.iD );
               Label3.Caption := 'Score : ' + IntToStr( Score );
               Break;
            end;
      end;

   HMonitor1.UnLock;

end;

procedure TForm1.FormClick(Sender: TObject);
{ Промах - если попал по форме }
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
{ Этот процесс уже удален из списка.
  Но все его параметры остались. Их надо зачистить. }
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

   P^.Body.Destroy; // Разрушить Shape,
   Dispose( P );    // структуру параметров,
   HP.Destroy;      // сам процесс
   Dec( NP );
   Inc( Kill );
   Label2.Caption := 'Kill : ' + IntToStr( Kill );
{ ps.
   нечто подобное необходимо проделать при
   аварийном завершении процесса.
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
