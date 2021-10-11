unit ThSort;
{
   Этот пример взят из демо Delphi и приведен для демонстрации
   того, как реализуется программа с использованием компонентов.
   Из примера не удален изначальный код реализации, а просто
   добавлены три компонента THProcess. Даже прграмма обработки
   завершения процессов осталась из исходного примера... 
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Buttons, HProcess;

type
  TThreadSortForm = class(TForm)
    StartBtn: TButton;
    BubbleSortBox: TPaintBox;
    SelectionSortBox: TPaintBox;
    QuickSortBox: TPaintBox;
    Label1: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    HP1: THProcess;
    HP2: THProcess;
    HP3: THProcess;
    SpeedButton2: TSpeedButton;
    Label4: TLabel;
    procedure BubbleSortBoxPaint(Sender: TObject);
    procedure SelectionSortBoxPaint(Sender: TObject);
    procedure QuickSortBoxPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure HP1Execute(Sender: THProcess);
    procedure HP1Draw(Sender: THProcess; Params: Pointer);
    procedure SpeedButton2Click(Sender: TObject);
    procedure HP2Execute(Sender: THProcess);
    procedure HP3Execute(Sender: THProcess);
    procedure RandomizeArrays;
    procedure ThreadDone(Sender: TObject);
    procedure HP1Terminate(HP: THProcess);
  public
    procedure PaintArray(Box: TPaintBox; const A: array of Integer);
  end;

var
  ThreadSortForm: TThreadSortForm;
  T : LongWord;
  ThreadsRunning: Integer;
Const
   NE : Integer = 0;

implementation

uses SortThds;

{$R *.DFM}

type
  PSortArray = ^TSortArray;
  TSortArray =  array[0..114] of Integer;

Type
   TSortRec =  // Структура параметра процесса
      Record
        FA : Integer;
        FB : Integer;
        FI : Integer;
        FJ : Integer;
        FBox: TPaintBox;
        FSortArray: PSortArray;
        FSize: Integer;
     end;

  PSortRec =
     ^TSortRec;
var
  ArraysRandom: Boolean;
  BubbleSortArray,
  SelectionSortArray,
  QuickSortArray: TSortArray;
  SA1, SA2, SA3 : TSortRec;

{ TThreadSortForm }

procedure TThreadSortForm.PaintArray(Box: TPaintBox; const A: array of Integer);
var
  I: Integer;
begin
  with Box do
  begin
    Canvas.Pen.Color := clBlack;
    for I := Low(A) to High(A) do PaintLine(Canvas, I, A[I]);
  end;
end;

procedure TThreadSortForm.BubbleSortBoxPaint(Sender: TObject);
begin
  PaintArray(BubbleSortBox, BubbleSortArray);
end;

procedure TThreadSortForm.SelectionSortBoxPaint(Sender: TObject);
begin
  PaintArray(SelectionSortBox, SelectionSortArray);
end;

procedure TThreadSortForm.QuickSortBoxPaint(Sender: TObject);
begin
  PaintArray(QuickSortBox, QuickSortArray);
end;

procedure TThreadSortForm.FormCreate(Sender: TObject);
begin
  RandomizeArrays;

  SA1.FBox := BubbleSortBox;
  SA1.FSortArray := @BubbleSortArray;
  SA1.FSize := High(SA1.FSortArray^) - Low(SA1.FSortArray^) + 1;
  HP1.Params := @SA1;

  SA2.FBox := SelectionSortBox;
  SA2.FSortArray := @SelectionSortArray;
  SA2.FSize := High(SA2.FSortArray^) - Low(SA2.FSortArray^) + 1;
  HP2.Params := @SA2;

  SA3.FBox := QuickSortBox;
  SA3.FSortArray := @QuickSortArray;
  SA3.FSize := High(SA3.FSortArray^) - Low(SA3.FSortArray^) + 1;
  HP3.Params := @SA3;
end;

procedure TThreadSortForm.StartBtnClick(Sender: TObject);
begin
  RandomizeArrays;
  T := GetTickCount; // Start timer
  ThreadsRunning := 3;
  with TBubbleSort.Create(BubbleSortBox, BubbleSortArray) do
    OnTerminate := ThreadDone;
  with TSelectionSort.Create(SelectionSortBox, SelectionSortArray) do
    OnTerminate := ThreadDone;
  with TQuickSort.Create(QuickSortBox, QuickSortArray) do
    OnTerminate := ThreadDone;
  StartBtn.Enabled := False;
end;

procedure TThreadSortForm.RandomizeArrays;
var
  I: Integer;
begin
//  if not ArraysRandom then
  begin
    Randomize;

    for I := Low(BubbleSortArray) to High(BubbleSortArray) do
       BubbleSortArray[I] := Random(170);

    SelectionSortArray := BubbleSortArray;
    QuickSortArray := BubbleSortArray; 
    ArraysRandom := True;
    Repaint;
  end;
end;

procedure TThreadSortForm.ThreadDone(Sender: TObject);
begin
  Dec(ThreadsRunning);
  if ThreadsRunning = 0 then
  begin
    StartBtn.Enabled := true;
    SpeedButton2.Enabled := StartBtn.Enabled;
    ArraysRandom := False;
  end;
  Label4.Caption := IntToStr( GetTickCount - T ) + ' ms';
end;

procedure TThreadSortForm.SpeedButton1Click(Sender: TObject);
begin
   RandomizeArrays;
end;

procedure VisualSwap( Var SR : TSortRec; A, B, I, J: Integer);
begin
  SR.FA := A;
  SR.FB := B;
  SR.FI := I;
  SR.FJ := J;
  Application.ProcessMessages;
end;

{ TBubbleSort }
procedure TThreadSortForm.HP1Execute(Sender: THProcess);
var
  I, J, T: Integer;
  A : PSortArray;
  HP : THProcess Absolute Sender;
begin
   Repeat
      With HP do
         With PSortRec( Params )^ do
            begin
               A := FSortArray;
               for I := High(A^) downto Low(A^) do
                  for J := Low(A^) to High(A^) - 1 do
                     if A^[J] > A^[J + 1] then
                        begin
                           VisualSwap( PSortRec( Params )^, A^[J], A^[J + 1], J, J + 1);
                           Draw( Nil );
                           T := A^[J];
                           A^[J] := A^[J + 1];
                           A^[J + 1] := T;
                        end;
               exit;
            end;
   Until false;
end;

procedure TThreadSortForm.HP1Draw(Sender: THProcess; Params: Pointer);
Var
   HP : THProcess Absolute Sender;
begin
  with PSortRec( HP.Params )^ do
     with FBox do
        begin
           Canvas.Pen.Color := clBtnFace;
           PaintLine(Canvas, FI, FA);
           PaintLine(Canvas, FJ, FB);
           Canvas.Pen.Color := clBlack;
           PaintLine(Canvas, FI, FB);
           PaintLine(Canvas, FJ, FA);
        end;
end;

procedure TThreadSortForm.SpeedButton2Click(Sender: TObject);
begin
   RandomizeArrays;
   ThreadsRunning := 3;
   StartBtn.Enabled := False;
   SpeedButton2.Enabled := StartBtn.Enabled;
   T := GetTickCount;
   HP1.Resume;
   HP2.Resume;
   HP3.Resume;
end;

{ SelectionSort }
procedure TThreadSortForm.HP2Execute(Sender: THProcess);

Var
  I, J, T: Integer;
  A : PSortArray;
  HP : THProcess Absolute Sender;
begin
   Repeat
      With HP do
         With PSortRec( Params )^ do
            begin
               A := FSortArray;
               for I := Low(A^) to High(A^) - 1 do
                  for J := High(A^) downto I + 1 do
                     if A^[I] > A^[J] then
                        begin
                           VisualSwap( PSortRec( Params )^, A^[I], A^[J], I, J);
                           Draw( Nil );
                           T := A^[I];
                           A^[I] := A^[J];
                           A^[J] := T;
                        end;
               exit;
            end;
   Until false;
end;

{ QuickSort }
procedure TThreadSortForm.HP3Execute(Sender: THProcess);
Var
   A : PSortArray;
   SR : PSortRec;
   HP : THProcess Absolute Sender;

   procedure QuickSort(var A: array of Integer; iLo, iHi: Integer);
   var
      Lo, Hi, Mid, T: Integer;
   begin
      Lo := iLo;
      Hi := iHi;
      Mid := A[(Lo + Hi) div 2];
      repeat
         while A[Lo] < Mid do
            Inc(Lo);
         while A[Hi] > Mid do
            Dec(Hi);
         if Lo <= Hi then
            begin
               VisualSwap( SR^, A[Lo], A[Hi], Lo, Hi );
               HP.Draw( Nil );
               T := A[Lo];
               A[Lo] := A[Hi];
               A[Hi] := T;
               Inc(Lo);
               Dec(Hi);
            end;
      until Lo > Hi;

      if Hi > iLo then
         QuickSort(A, iLo, Hi);

      if Lo < iHi then
         QuickSort(A, Lo, iHi);
   end;

begin
   Repeat
      With HP do
         With PSortRec( Params )^ do
            begin
               A := FSortArray;
               SR := Params;
               QuickSort(A^, Low(A^), High(A^));
               exit;
            end;
   Until false;
end;

procedure TThreadSortForm.HP1Terminate(HP: THProcess);
begin
   ThreadDone( HP );
end;

end.
