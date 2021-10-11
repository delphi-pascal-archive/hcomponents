{*********************************************************}
{*                  TPSTRDEV.PAS 5.21                    *}
{*     Copyright (c) TurboPower Software 1987, 1992.     *}
{* Portions Copyright (c) Sunny Hill Software 1985, 1986 *}
{*     and used under license to TurboPower Software     *}
{*                 All rights reserved.                  *}
{*********************************************************}

unit HVCLOut;
{-Routines for reading and writing strings}

interface
uses
   Windows,
   Dialogs,
   Classes,
   Messages,
   SysUtils,
   StdCtrls,
   ComCtrls,
   SyncObjs;

procedure AssignOut( C: TComponent );

{==========================================================================}

implementation

type
   {structure of a Turbo File Interface Block}
   TTextRecVCL = packed record
      (* must match the size the compiler generates: 460 bytes *)
      Handle: Integer; (* must overlay with TFileRec *)
      Mode: Word;
      Flags: Word;
      BufSize: Cardinal;
      BufPos: Cardinal;
      BufEnd: Cardinal;
      BufPtr: PChar;
      OpenFunc: Pointer;
      InOutFunc: Pointer;
      FlushFunc: Pointer;
      CloseFunc: Pointer;
      VCLStr: TComponent; //    HNV(2012)
      UserData: array[ 1..28 ] of Byte; //    HNV(2012)
      Name: array[ 0..259 ] of Char;
      Buffer: TTextBuf;
   end;

type
   {text buffer}
   TTextBuffer = array[ 0..65520 ] of Char;

var
   Buff: TTextBuffer;
   HPid: THandle;

procedure TestReent;
begin
   if GetCurrentThreadId <> HPid then
      raise
         Exception.CreateFmt(
         'This version of ''Write/WriteLn'' is not reentrant.'
         , [ ] );
end;

function StrOut( var F: TTextRec ): Word;
{-Update the length byte of StrBuf}
begin
   TestReent;
   StrOut := 0;
end;

function StrZero( var F: TTextRec ): Word;
{-Return success flag, but do nothing}
begin
   TestReent;
   StrZero := 0;
end;

procedure Scroll( M: TComponent );
begin
   if M is TMemo then
      begin
         TMemo( M ).Lines.BeginUpdate;
         TMemo( M ).Perform( EM_LINESCROLL, 0, TMemo( M ).Lines.Count );
         TMemo( M ).SelStart := Length( TMemo( M ).Text );
         TMemo( M ).Lines.EndUpdate;
      end
   else
      if M is TRichEdit then
         begin
            TRichEdit( M ).SetFocus;
            TRichEdit( M ).SelStart := Length( TRichEdit( M ).Text );
            SendMessage( TRichEdit( M ).Handle, WM_KEYDOWN, VK_END, 0 );
            TRichEdit( M ).Update;
         end;
end;

function Flash( var F: TTextRec ): Word;
{-Return success flag, but do nothing}
var
   FStruct: TTextRecVCL absolute F;
   S: string;
   i: Integer;
begin
   TestReent;
   with FStruct do
      begin
         SetLength( S, BufPos );
         for i := 1 to BufPos do
            S[ i ] := Buff[ i - 1 ];
         BufPos := 0;
         if VCLStr is TMemo then
            TMemo( VCLStr ).Text := TMemo( VCLStr ).Text + S
         else
            if VCLStr is TRichEdit then
               TRichEdit( VCLStr ).Text := TRichEdit( VCLStr ).Text + S;
         Scroll( VCLStr );
      end;
   RESULT := 0;
end;

procedure AssignOut( C: TComponent );
{-Initialize the File Interface Block}
var
   FOutPut: TTextRecVCL absolute Output;
begin
   with FOutPut do
      begin
         Mode := $D7B3; // FMClosed;
         OpenFunc := @StrZero;
         FlushFunc := @Flash;
         CloseFunc := @StrZero;
         InOutFunc := @StrOut;
         BufEnd := 0;
         BufPos := 0;
         BufPtr := @Buff;
         BufSize := 255;
         Name[ 0 ] := #0;
         VCLStr := C;
      end;
end;
initialization
   HPid := GetCurrentThreadId;
end.

