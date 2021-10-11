
unit HChannel;

interface

uses
   Windows,
   Dialogs,
   Classes,
   SysUtils,
   Forms,
   SyncObjs;

type

   TDataType =
      array[ 1..1 ] of Byte;

   TDataChannel = record
      ThreadID : THandle;
      Suspended : Boolean;
      DataPTR : Pointer;
      DataLen : Cardinal;
   end;

   THChannelNew =
      class
   protected
      QueueR : TList;
      QueueW : TList;
      FLatch : TCriticalSection;
   public
      procedure write( var Data; L : Cardinal ); overload;
      //procedure write( S : string ); overload;
      procedure read( var Data; L : Cardinal ); overload;
      //procedure read( var S : string ); overload;
      procedure Lock;
      procedure UnLock;
   end;

   { get current HProcess-component of application }
procedure AllocChannel( var Ch : THChannelNew );
procedure EraseChannel( var Ch : THChannelNew );

implementation

procedure THChannelNew.Lock;
begin
   FLatch.Enter;
end;

procedure THChannelNew.UnLock;
begin
   FLatch.Leave;
end;

procedure THChannelNew.write( var Data; L : Cardinal );
var
   t : ^TDataType;
   W, R : ^TDataChannel;
begin
  // Lock;
   while QueueR.Count > 0 do
      begin
         R := QueueR[ 0 ];
         Move( Data, R^.DataPtr^, R^.DataLen );
         QueueR.Delete( 0 );
         ResumeThread( R^.ThreadID );
         FreeMem( R );
         UnLock;
         Exit;
      end;

   GetMem( t, L );
   GetMem( W, SizeOf( TDataChannel ) );
   W^.ThreadID := GetCurrentThread;
   W^.DataPTR := t;
   W^.DataLen := L;
   QueueW.Add( W );
   Move( Data, W^.DataPtr^, L );
   UnLock;
   SuspendThread( W^.ThreadID ); 
end;

procedure THChannelNew.read( var Data; L : Cardinal );
var
   W, R : ^TDataChannel;
begin
   //Lock;
   while QueueW.Count > 0 do
      begin
         W := QueueW[ 0 ];
         Move( W^.DataPtr^, Data, W^.DataLen );
         FreeMem( W.DataPTR );
         QueueW.Delete( 0 );
         ResumeThread( W^.ThreadID );
         FreeMem( W );
         UnLock;
         Exit;
      end;
   GetMem( R, SizeOf( TDataChannel ) );
   R^.ThreadID := GetCurrentThread;
   R^.DataPTR := Addr( Data );
   R^.DataLen := L;
   QueueR.Add( R );
   UnLock;
   SuspendThread( R^.ThreadID );  
end;

procedure AllocChannel( var Ch : THChannelNew );
begin
   Ch := THChannelNew.Create;
   Ch.QueueR := TList.Create;
   Ch.QueueW := TList.Create;
   Ch.FLatch := TCriticalSection.Create;
end;

procedure EraseChannel( var Ch : THChannelNew );
begin
   Ch.QueueR.Destroy;
   Ch.QueueW.Destroy;
   Ch.FLatch.Destroy;
   Ch.Destroy;
end;

end.

