{*******************************************************}
{                                                       }
{      HProcess, HChannel, HMonitor Components          }
{             for parallel programming                  }
{                                                       }
{              Copyright (c) HNV 2001 - 2003            }
{                                                       }
{*******************************************************}

unit HProcess;

interface

uses
   Windows,
   Dialogs,
   Classes,
   SysUtils,
   Forms,
   SyncObjs;

type
   TThreadClass =
      class( TThread )
   private
      FOnExecute: TNotifyEvent;
   protected
      procedure Execute; override;
   public
      property OnExecute: TNotifyEvent read FOnExecute write FOnExecute;
      property Terminated;
   end;
   {
      The channel of an exchange given between processes
   }
   THChannel =
      class( TComponent )
   protected
      GetProc: TList;
      { The list of processes of expecting reception of the data }
      PutProc: TList;
      { The list of processes of expecting data transfer }
      FLatch: TCriticalSection;
   public
      constructor Create( AOwner: TComponent ); override;
      destructor Destroy; override;
      procedure Post;
      procedure Lock;
      procedure UnLock;
   end;

   THWaitResult =
      ( wrSignaled, wrTimeout, wrAbandoned, wrError );

   THProcess =
      class;

   PHProcess =
      ^THProcess;

   TExecProc =
      procedure( HP: THProcess ) of object;

   TActionProc =
      procedure( Action: Integer; Sender: TObject; Params: Pointer ) of
      object;

   TTRaceProc =
      procedure( HP: THProcess; S: string ) of object;

   TDrawProc =
      procedure( HP: THProcess; Params: Pointer ) of object;

   TExceptProc =
      procedure( HP: THProcess; E: Exception ) of object;
   {
      Mutual exclusive used module of parallel processes
   }
   THMonitor =
      class( TComponent )
   protected
      FLatch: TRTLCriticalSection;
      FModule: TDrawProc;
      FAction: TActionProc;
   public
      constructor Create( AOwner: TComponent ); override;
      destructor Destroy; override;
      procedure Enter( HP: THProcess; Params: Pointer );
      procedure Action( A: Integer; Sender: TObject = nil; Params: Pointer =
         nil );
      procedure Lock;
      procedure UnLock;
   published
      property OnEnter: TDrawProc read FModule write FModule;
      property OnAction: TActionProc read FAction write FAction;
   end;

   THProcess =
      class( TComponent )
   private
      FThread: TThreadClass;
      FOwner: TComponent;
      FSyncMethod: TNotifyEvent;
      FDrawMethod: TDrawProc;
      FSyncParams: Pointer;
      FDesignedSuspended: Boolean;
      FCycled: Boolean;
      FExitCode: Integer;
      FActive: Boolean;
      FInterval: integer;
      FThreadPriority: TThreadPriority;

      {  HNV 2003 }
      FMonitor: THMonitor;

      FOnExecute: TExecProc;
      FOnStart: TExecProc;
      FOnTerminate: TExecProc;
      FOnEnded: TExecProc;
      FOnResume: TExecProc;
      FOnSuspend: TExecProc;

      FReadChannel: THChannel;
      FWriteChannel: THChannel;
      FOnException: TExceptProc;
      FTraceProc: TTraceProc;
      FData: Pointer; { Адрес данных }
      FLength: LongWord; { Длина данных }
      FECB: TSimpleEvent;
      FWaitResult: THWaitResult;
      FName: string;

      FInternalName: string;
      FRecursiveFlag: Boolean; // flag of recursive call 2003

      procedure InternalSynchronize;
      procedure InternalTrace( S: TObject );
      procedure InternalDraw( S: TObject );
      procedure InternalTerminate( S: TObject );
      procedure DoTerminate( Sender: TObject );
      procedure DoAbortFromVCL( Sender: TObject );
      function GetHandle: THandle;
      function GetThreadID: THandle;
      function GetReturnValue: Integer;
      procedure SetReturnValue( Value: Integer );
      function GetSuspended: Boolean;
      procedure SetSuspended( Value: Boolean );
      function GetTerminated: boolean;
      function GetProcessName: string;
   protected
      procedure DoExecute( Sender: TObject ); virtual;
      procedure DoException( Sender: TObject ); virtual;
      procedure Loaded; override;
      procedure CreateThread;
   public
      ProcessID: Integer;
      Params: Pointer;
      constructor Create( AOwner: TComponent ); override;
      destructor Destroy; override;
      procedure Execute;
      procedure Synchronize( Method: TThreadMethod );
      procedure DoSynchron( PSync: TNotifyEvent; Proc: THProcess; P: Pointer
         );
      procedure Draw( Params: Pointer = nil );
      procedure MonitorEnter( Params: Pointer = nil );
      procedure Trace( S: string );
      procedure Suspend;
      procedure Resume;
      procedure Terminate;
      function TerminateWaitFor: Integer;
      procedure TerminateHard;
      function WaitFor: Integer;
      property Active: Boolean read FActive;
      property DataAddr: Pointer read FData;
      { Адрес данных }
      property DataLength: LongWord read FLength;
      { Длина }
      property ReturnValue: Integer read GetReturnValue write SetReturnValue;
      property ExitCode: Integer read FExitCode write FExitCode;
      property Handle: THandle read GetHandle;
      property ThreadID: THandle read GetThreadID;
      property Terminated: Boolean read GetTerminated;

      function WaitResult: THWaitResult;
      procedure Delay( MSecs: Longint );

      { To read the data from the channel }
      procedure ReadData( Source: THChannel; var Dest;
         Count: LongWord;
         TOut: LongWord = Infinite ); overload;
      { Recording of the data to the channel }
      procedure WriteData( var Source; Dest: THChannel;
         Count: LongWord;
         TOut: LongWord = Infinite ); overload;
      { To load the data from the channel }
      procedure LoadData( Source: THChannel;
         TOut: LongWord = Infinite ); overload;

      procedure ReadData( var Dest; Count: LongWord;
         TOut: LongWord = Infinite ); overload;

      procedure WriteData( var Source; Count: LongWord;
         TOut: LongWord = Infinite ); overload;

      function ReadStr( TOut: LongWord = Infinite ): string; overload;

      procedure WriteStr( S: string; TOut: LongWord = Infinite ); overload;

      function ReadStr( Source: THChannel; TOut: LongWord = Infinite ):
         string; overload;

      procedure WriteStr( S: string; Dest: THChannel; TOut: LongWord =
         Infinite ); overload;

      procedure LoadData( TOut: LongWord = Infinite );
         overload;

      { To remove the loaded data }
      procedure FreeData;

      { To create new component - process }
      function CreateNew: PHProcess;

      { Recursive call of execute method in new thread }
      procedure RecursiveCall( Id: Integer; Params: Pointer );

      function GetProcessorTime: LongWord;

      { for all clones HProcess of CreateNew method }
      function GetAllClonesProcessorTime: LongWord;

   published
      property Monitor: THMonitor read FMonitor write FMonitor;
      property Read: THChannel read FReadChannel write FReadChannel;
      property Write: THChannel read FWriteChannel write FWriteChannel;
      property Interval: integer read FInterval write FInterval;
      property Cycled: boolean read FCycled write FCycled;
      property TraceName: string read GetProcessName write FName;
      property Priority: TThreadPriority read FThreadPriority write
         FThreadPriority
         default tpLower;
      property Suspended: Boolean read GetSuspended write SetSuspended;

      property OnExecute: TExecProc read FOnExecute write FOnExecute;
      property OnResume: TExecProc read FOnResume write FOnResume;
      property OnSuspend: TExecProc read FOnSuspend write FOnSuspend;
      property OnStart: TExecProc read FOnStart write FOnStart;
      property OnTerminate: TExecProc read FOnTerminate write FOnTerminate;
      property OnEnded: TExecProc read FOnEnded write FOnEnded;

      property OnException: TExceptProc read FOnException write FOnException;
      property OnDraw: TDrawProc read FDrawMethod write FDrawMethod;
      property OnTrace: TTraceProc read FTraceProc write FTraceProc;

   end;

   PHChannel =
      ^THChannel;

   TTraceParam =
      record
      Proc: PHProcess;
      Mess: string;
   end;

   { get current HProcess-component of application }
function GetCurrentHProcess: THProcess;

{ get time of processor use by application }
function GetProcessorTime: LongWord;

{ Under duress finishes process in any enclosed procedure}
procedure EndProcess( Code: Integer = 0 );

procedure Register;

implementation

var
   GlobalLatch: TRTLCriticalSection;

function GetCurrentHProcess: THProcess;
var
   F: TForm;
   i: Integer;

   function GetCurrentHProcessPrim( F: TForm ): THProcess;
   var
      i: Integer;
      H: LongWord;
      HP: THProcess;
   begin
      H := GetCurrentThreadId;
      RESULT := nil;
      for I := 1 to F.ComponentCount do
         begin
            if F.Components[ i - 1 ] is THProcess then
               begin
                  HP := THProcess( F.Components[ i - 1 ] );
                  if not HP.Active then
                     Continue;
                  if HP.ThreadId = H then
                     begin
                        Result := HP;
                        break;
                     end;
               end;
         end;
   end;

begin
   Result := nil;
   EnterCriticalSection( GlobalLatch );
   try
      for i := 1 to Screen.FormCount do
         begin
            F := TForm( FindGlobalComponent( Screen.Forms[ i - 1 ].Name ) );
            Result := GetCurrentHprocessPrim( F );
            if Result <> nil then
               exit;
         end;
   finally
      LeaveCriticalSection( GlobalLatch );
   end;
end;

function THProcess.GetProcessorTime: LongWord;
var
   t1, t2, t3, t4: TFileTime;
begin
   RESULT := 0;
   if GetThreadTimes( FThread.Handle, t1, t2, t3, t4 ) then
      RESULT := ( t3.dwLowDateTime + t4.dwLowDateTime ) div 10000;
end;

function GetProcessorTime: LongWord;
var
   t1, t2, t3, t4: TFileTime;
begin
   RESULT := 0;
   if GetProcessTimes( GetCurrentProcess, t1, t2, t3, t4 ) then
      RESULT := ( t3.dwLowDateTime + t4.dwLowDateTime ) div 10000;
end;

function GetAllClonesProcessPrim( F: TForm; N: string ): LongWord;
var
   i: Integer;
   HP: THProcess;
begin
   RESULT := 0;
   for I := 1 to F.ComponentCount do
      begin
         if F.Components[ i - 1 ] is THProcess then
            begin
               HP := THProcess( F.Components[ i - 1 ] );
               if not HP.Active then
                  Continue;
               if HP.FInternalName = N then
                  begin
                     RESULT := RESULT + HP.GetProcessorTime;
                  end;
            end;
      end;
end;

function THProcess.GetAllClonesProcessorTime: LongWord;
var
   F: TForm;
   i: Integer;
begin
   RESULT := 0;
   EnterCriticalSection( GlobalLatch );
   try
      for i := 1 to Screen.FormCount do
         begin
            F := TForm( FindGlobalComponent( Screen.Forms[ i - 1 ].Name ) );
            RESULT := RESULT + GetAllClonesProcessPrim( F, FInternalName );
         end;
   finally
      LeaveCriticalSection( GlobalLatch );
   end;
end;

function THProcess.CreateNew: PHProcess;
begin
   EnterCriticalSection( GlobalLatch );
   New( RESULT );
   RESULT^ := THProcess.Create( FOwner );
   RESULT^.OnExecute := OnExecute;
   RESULT^.OnTerminate := OnTerminate;
   RESULT^.OnException := OnException;
   RESULT^.OnDraw := OnDraw;
   RESULT^.OnTrace := OnTrace;
   RESULT^.OnSuspend := OnSuspend;
   RESULT^.OnResume := OnResume;
   RESULT^.OnStart := OnStart;
   RESULT^.Name := '';
   RESULT^.Monitor := Monitor;
   RESULT^.Priority := Priority;
   RESULT^.Read := Read;
   RESULT^.Write := Write;
   RESULT^.FInternalName := FInternalName;
   RESULT^.FRecursiveFlag := false;
   LeaveCriticalSection( GlobalLatch );
end;

procedure THProcess.RecursiveCall( Id: Integer; Params: Pointer );
var
   HPNew: PHProcess;
begin
   HPNew := CreateNew;
   HPNew^.ProcessID := Id;
   HPNew^.Params := Params;
   HPNew^.FRecursiveFlag := true;
   HPNew^.Execute;
end;

constructor THChannel.Create( AOwner: TComponent );
begin
   inherited;
   GetProc := TList.Create;
   PutProc := TList.Create;
   FLatch := TCriticalSection.Create;
end;

destructor THChannel.Destroy;
begin
   GetProc.Destroy;
   PutProc.Destroy;
   FLatch.Destroy;
   inherited;
end;

constructor THMonitor.Create( AOwner: TComponent );
begin
   inherited;
   InitializeCriticalSection( FLatch );
end;

destructor THMonitor.Destroy;
begin
   DeleteCriticalSection( FLatch );
   inherited;
end;

procedure THMonitor.Lock;
begin
   EnterCriticalSection( FLatch );
end;

procedure THMonitor.UnLock;
begin
   LeaveCriticalSection( FLatch );
end;

procedure THMonitor.Enter( HP: THProcess; Params: Pointer );
begin
   if Assigned( OnEnter ) then
      begin
         Lock;
         try
            FModule( HP, Params );
         finally
            UnLock;
         end;
      end;
end;

procedure THMonitor.Action( A: Integer; Sender: TObject;
   Params: Pointer );
begin
   if Assigned( OnAction ) then
      begin
         Lock;
         try
            FAction( A, Sender, Params );
         finally
            UnLock;
         end;
      end;
end;

procedure THChannel.Post;
var
   i: Integer;
begin
   Lock;
   try
      begin
         if GetProc.Count > 0 then
            for i := 0 to GetProc.Count - 1 do
               begin
                  PHProcess( GetProc.Items[ i ] )^.FWaitResult := wrAbandoned;
                  PHProcess( GetProc.Items[ i ] )^.FECB.SetEvent;
               end;

         GetProc.Clear;

         if PutProc.Count > 0 then
            for i := 0 to PutProc.Count - 1 do
               begin
                  PHProcess( PutProc.Items[ i ] )^.FWaitResult := wrAbandoned;
                  PHProcess( PutProc.Items[ i ] )^.FECB.SetEvent;
               end;

         PutProc.Clear;
      end
   finally
      UnLock;
   end;
end;

procedure THChannel.Lock;
begin
   FLatch.Enter;
end;

procedure THChannel.UnLock;
begin
   FLatch.Leave;
end;

{ Get }

procedure GetChannel( P1, P2: Pointer );
var
   Channel: PHChannel absolute P2;
   PAddr: PHProcess absolute P1;
begin
   Channel^.Lock;
   try
      begin
         PAddr.FECB.ResetEvent;

         if Channel^.PutProc.Count > 0 then
            begin
               PHProcess( P1 )^.FData :=
                  PHProcess( Channel^.PutProc.Items[ 0 ] )^.FData;

               PHProcess( P1 )^.FLength :=
                  PHProcess( Channel^.PutProc.Items[ 0 ] )^.FLength;

               PHProcess( Channel^.PutProc.Items[ 0 ] )^.FECB.SetEvent;
               Channel^.PutProc.Delete( 0 );

               PAddr.FECB.SetEvent;
            end
         else
            Channel^.GetProc.Add( P1 );
      end
   finally
      Channel^.UnLock;
   end;
end;

{ Put }

procedure PutChannel( P1, P2: Pointer );
var
   Channel: PHChannel absolute P2;
   PAddr: PHProcess absolute P1;
begin

   Channel^.Lock;

   try
      begin
         PAddr.FECB.ResetEvent;
         { It is supposed to wait... }

         if Channel^.GetProc.Count > 0 then
            begin
               { To send the data to other process }
               PHProcess( Channel^.GetProc.Items[ 0 ] )^.FData :=
                  PHProcess( P1 )^.FData;
               { The address of the data}
               PHProcess( Channel^.GetProc.Items[ 0 ] )^.FLength :=
                  PHProcess( P1 )^.FLength;
               { Length of the data }
               { To notify }
               PHProcess( Channel^.GetProc.Items[ 0 ] )^.FECB.SetEvent;
               Channel^.GetProc.Delete( 0 );
               { To throw out from turn }
               PAddr.FECB.SetEvent;
               { To cancel expectation... }
            end
         else
            Channel^.PutProc.Add( P1 );
      end
   finally
      Channel^.UnLock;
   end;
end;

function THProcess.WaitResult: THWaitResult;
begin
   Result := FWaitResult;
end;

procedure THProcess.MonitorEnter( Params: Pointer );
begin
   if Assigned( FMonitor ) then
      FMonitor.Enter( SELF, Params );
end;

procedure THProcess.ReadData( Source: THChannel; var
   Dest; Count: LongWord;
   TOut: LongWord = Infinite );
var
   Temp: THWaitResult;
begin
   GetChannel( Addr( SELF ), Addr( Source ) );

   Temp := THWaitResult( FECB.WaitFor( TOut ) );

   if FWaitResult = wrAbandoned then
      exit;

   FWaitResult := Temp;

   if FWaitResult = wrTimeOut then
      begin
         PutChannel( Addr( SELF ), Addr( Source ) );
         exit;
      end;

   if FData <> nil then
      begin
         Move( FData^, Dest, Count );
         FreeMem( FData );
         FData := nil;
      end;
   FLength := 0;
end;

procedure THProcess.WriteData( var Source; Dest:
   THChannel; Count: LongWord;
   TOut: LongWord = Infinite );
var
   Temp: THWaitResult;
begin
   FLength := Count;
   FData := nil;
   if FLength <> 0 then
      begin
         GetMem( FData, FLength );
         Move( Source, FData^, FLength );
      end;

   PutChannel( Addr( SELF ), Addr( Dest ) );

   Temp := THWaitResult( FECB.WaitFor( TOut ) );

   if FWaitResult = wrAbandoned then
      exit;

   FWaitResult := Temp;

   if FWaitResult = wrTimeout then
      GetChannel( Addr( SELF ), Addr( Dest ) );
end;

procedure THProcess.LoadData( Source: THChannel; TOut:
   LongWord = Infinite );
var
   Temp: THWaitResult;
begin
   GetChannel( Addr( SELF ), Addr( Source ) );

   Temp := THWaitResult( FECB.WaitFor( TOut ) );

   if FWaitResult = wrAbandoned then
      exit;

   FWaitResult := Temp;

   if FWaitResult = wrTimeOut then
      PutChannel( Addr( SELF ), Addr( Source ) );
end;

procedure THProcess.ReadData( var Dest; Count: LongWord;
   TOut: LongWord = Infinite );
begin
   if Assigned( FReadChannel ) then
      ReadData( FReadChannel, Dest, Count, TOut );
end;

procedure THProcess.WriteData( var Source; Count:
   LongWord;
   TOut: LongWord = Infinite );
begin
   if Assigned( FWriteChannel ) then
      WriteData( Source, FWriteChannel, Count, TOut );
end;

function THProcess.ReadStr( TOut: LongWord = Infinite ): string;
var
   PS: ^string;
begin
   if Assigned( FReadChannel ) then
      begin
         ReadData( FReadChannel, PS, SizeOf( PS ), TOut );
         RESULT := PS^;
         Dispose( PS );
      end;
end;
{ Recording of the data in the channel}

procedure THProcess.WriteStr( S: string; TOut: LongWord = Infinite );
var
   PS: ^string;
begin
   if Assigned( FWriteChannel ) then
      begin
         New( PS );
         PS^ := S;
         WriteData( PS, FWriteChannel, SizeOf( PS ), TOut );
      end;
end;

function THProcess.ReadStr( Source: THChannel; TOut: LongWord = Infinite ):
   string;
var
   PS: ^string;
begin
   ReadData( Source, PS, SizeOf( PS ), TOut );
   RESULT := PS^;
   Dispose( PS );
end;
{ Recording of the data in the channel}

procedure THProcess.WriteStr( S: string; Dest: THChannel; TOut: LongWord =
   Infinite );
var
   PS: ^string;
begin
   New( PS );
   PS^ := S;
   WriteData( PS, Dest, SizeOf( PS ), TOut );
end;

{ To load the data from the channel }

procedure THProcess.LoadData( TOut: LongWord = Infinite );
begin
   if Assigned( FReadChannel ) then
      LoadData( FReadChannel, TOut );
end;

procedure THProcess.FreeData;
begin
   if FData <> nil then
      begin
         FreeMem( FData );
         FData := nil;
      end;
end;

function THProcess.GetProcessName: string;
begin
   if FName = '' then
      Result := Name
   else
      Result := FName;
end;

procedure TThreadClass.Execute;
begin
   if Assigned( FOnExecute ) then
      FOnExecute( SELF );
end;

constructor THProcess.Create( AOwner: TComponent );
begin
   inherited Create( AOwner );
   FOwner := AOwner;
   FDesignedSuspended := True;
   FInterval := 0;
   FCycled := false;
   FActive := false;
   FThreadPriority := tpLower;
   FECB := TSimpleEvent.Create;
   FRecursiveFlag := false;
   FData := nil;
end;

destructor THProcess.Destroy;
begin
   FData := nil;
   EnterCriticalSection( GlobalLatch );
   try
      if FActive and ( FThread.Handle <> 0 ) then
         begin
            TerminateThread( FThread.Handle, 0 );
            CloseHandle( FThread.Handle );
         end;
      FECB.Destroy;
      inherited;
   finally
      LeaveCriticalSection( GlobalLatch );
   end;
end;

procedure THProcess.DoSynchron( PSync: TNotifyEvent;
   Proc: THProcess; P: Pointer );
var
   Temp: TNotifyEvent;
begin
   Temp := Proc.FSyncMethod;
   Proc.FSyncMethod := PSync;
   Proc.FSyncParams := P;
   try
      Proc.FThread.Synchronize( Proc.InternalSynchronize );
   finally
      Proc.FSyncMethod := Temp;
   end;
end;

procedure THProcess.InternalSynchronize;
begin
   FSyncMethod( FSyncParams );
end;

procedure THProcess.DoExecute( Sender: TObject );
begin
   if Assigned( FOnExecute ) then
      repeat
         FActive := True;
         if FThread.Terminated then
            break
         else
            try
               if Assigned( FOnStart ) then
                  DoSynchron( TNotifyEvent( FOnStart ), SELF, SELF );
               FOnExecute( SELF );
            except
               FActive := false;
               DoSynchron( DoException, SELF,
                  ExceptObject );
            end;

         if Cycled then
            Delay( FInterval );

      until FThread.Terminated or not ( Cycled );
   FActive := false;
end;

procedure THProcess.DoException( Sender: TObject );
var
   s: string;
begin
   if Assigned( FOnException ) then
      FOnException( SELF, Exception( Sender ) )
   else
      begin
         s := Format(
            'HProcess %s raised exception class %s with message ''%s''.',
            [ Name, Exception( Sender ).ClassName,
            Exception( Sender ).Message ] );
         Application.MessageBox( PChar( s ), PChar(
            Application.Title ),
            MB_ICONERROR or MB_SETFOREGROUND or
            MB_APPLMODAL );
      end;
end;

function THProcess.GetHandle: THandle;
begin
   Result := FThread.Handle;
end;

procedure THProcess.InternalTerminate( S: TObject );
begin
   FActive := false;
   EnterCriticalSection( GlobalLatch );
   try
      if Assigned( FOnEnded ) and ( FExitCode = 0 ) then
         FOnEnded( Self )
      else
         if Assigned( FOnTerminate ) then
            FOnTerminate( SELF );
      if FRecursiveFlag then
         Destroy;
   finally
      LeaveCriticalSection( GlobalLatch );
   end;
end;

function THProcess.GetReturnValue: Integer;
begin
   Result := FThread.ReturnValue;
end;

function THProcess.GetSuspended: Boolean;
begin
   if not ( csDesigning in ComponentState ) then
      Result := FThread.Suspended
   else
      Result := FDesignedSuspended;
end;

procedure THProcess.Execute;
begin
   if not Assigned( FOnExecute ) then
      exit;
   FExitCode := 0;
   if not Active then
      begin
         CreateThread;
         if Suspended then
            FThread.Resume;
      end;
end;

procedure THProcess.Resume;
begin
   if Assigned( FOnResume ) then
      FOnResume( SELF );
   if not Active then // HNV 2.03.2006
      Execute // HNV 2.03.2006
   else // HNV 2.03.2006
      FThread.Resume;
end;

procedure THProcess.Loaded;
begin
   inherited;
   FInternalName := FName;
   if not Assigned( FOnExecute ) then
      exit;
   if not FDesignedSuspended then
      begin
         CreateThread;
         SetSuspended( FDesignedSuspended );
      end;
end;

procedure THProcess.CreateThread;
begin
   FThread := TThreadClass.Create( True );
   FActive := True;
   FThread.OnExecute := DoExecute;
   FThread.FreeOnTerminate := True;
   FThread.OnTerminate := InternalTerminate;
   FThread.Priority := FThreadPriority;
   FExitCode := 0;
end;

procedure THProcess.SetReturnValue( Value: Integer );
begin
   FThread.ReturnValue := Value;
end;

procedure THProcess.SetSuspended( Value: Boolean );
begin
   if not ( csDesigning in ComponentState ) then
      begin
         if ( csLoading in ComponentState ) then
            FDesignedSuspended := Value
         else
            FThread.Suspended := Value;
      end
   else
      FDesignedSuspended := Value;
end;

procedure THProcess.Suspend;
begin
   if Assigned( FOnSuspend ) then
      FOnSuspend( SELF );
   if Active then
      FThread.Suspend;
end;

procedure THProcess.Synchronize( Method: TThreadMethod );
begin
   FThread.Synchronize( Method );
end;

procedure THProcess.InternalTrace( S: TObject );
var
   PS: ^TTraceParam absolute S;
begin
   FTraceProc( PS^.Proc^, PS^.Mess );
end;

procedure THProcess.InternalDraw( S: TObject );
var
   PS: Pointer absolute S;
begin
   FDrawMethod( SELF, PS );
end;

procedure THProcess.Trace( S: string );
var
   TP: TTraceParam;
begin
   if Assigned( FTraceProc ) then
      begin
         TP.Proc := Addr( SELF );
         TP.Mess := S;
         DoSynchron( InternalTrace, SELF, Addr( TP ) );
      end;
end;

procedure THProcess.Draw( Params: Pointer );
begin
   if Assigned( FDrawMethod ) then
      DoSynchron( InternalDraw, SELF, Params );
end;

procedure THProcess.Terminate;
begin
   if Active then
      begin
         FExitCode := 1;
         FThread.Terminate;
      end;
end;

function THProcess.TerminateWaitFor: Integer;
begin
   Terminate;
   Result := WaitFor;
end;

procedure THProcess.DoTerminate( Sender: TObject );
begin
   if Assigned( FOnTerminate ) then
      begin
         EnterCriticalSection( GlobalLatch );
         try
            FOnTerminate( THProcess( Sender ) );
         finally
            LeaveCriticalSection( GlobalLatch );
         end;
      end;
end;

procedure THProcess.DoAbortFromVCL( Sender: TObject );
begin
   FActive := false;
   TerminateThread( FThread.Handle, 0 );
   CloseHandle( FThread.Handle );
end;

procedure EndProcess( Code: Integer = 0 );
var
   HP: THProcess;
begin
   HP := GetCurrentHProcess;

   if HP = nil then
      Halt( Code );

   HP.FExitCode := Code;
   HP.DoSynchron( HP.DoTerminate, HP, nil );
   HP.DoSynchron( HP.DoAbortFromVCL, HP, nil );
end;

procedure THProcess.TerminateHard;
begin
   if not Active then
      exit;
   FExitCode := 100;
   DoAbortFromVCL( SELF );
   DoSynchron( DoTerminate, SELF, nil );
end;

function THProcess.WaitFor: Integer;
begin
   if not Active then
      Result := 0
   else
      Result := FThread.WaitFor;
end;

function THProcess.GetTerminated: boolean;
begin
   if Active then
      Result := FThread.Terminated
   else
      Result := True;
end;

function THProcess.GetThreadID: THandle;
begin
   if Active then
      Result := FThread.ThreadID
   else
      Result := 0;
end;

procedure THProcess.Delay( MSecs: Longint );
var
   FirstTickCount, Now: Longint;
begin
   if MSecs < 0 then
      exit;
   FirstTickCount := GetTickCount;
   repeat
      Sleep( 1 );
      Now := GetTickCount;
   until ( Now - FirstTickCount >= MSecs )
      or ( Now < FirstTickCount ) or Terminated;
end;

procedure Register;
begin
   RegisterComponents( 'HNV', [ THProcess, THChannel, THMonitor ] );
end;

initialization
   InitializeCriticalSection( GlobalLatch );
finalization
   DeleteCriticalSection( GlobalLatch );
end.

