unit HPanel;

interface

uses
   SysUtils,
   Classes,
   Graphics,
   Forms,
   Windows,
   Messages,
   Dialogs,
   Controls,
   ExtCtrls;

type
   THPanel = class( TPanel )
   private
      { Private declarations }
      FPess : Boolean;
      Fx0, Fy0 : Integer;
      FOwner : TComponent;

      FSizeControl : Boolean;

      FSaveColor : TColor;
      FSaveTextColor : TColor;

      FPressTextColor : TColor;
      FPressColor : TColor;

      FDownUp : Boolean;
      FInner : TPanelBevel;
      FCanMove : Boolean;
   protected
      { Protected declarations }
      procedure Loaded; override;

      procedure MouseDown( var Message : TWMLButtonDown );
         message WM_LBUTTONDOWN;

      procedure MouseUp( var Message : TWMLButtonUp );
         message WM_LBUTTONUP;

      procedure MouseMove( var Message : TWMMouseMove );
         message WM_MOUSEMOVE;
   public
      { Public declarations }
      constructor Create( AOwner : TComponent ); override;
      destructor Destroy; override;
   published
      { Published declarations }
      property SizeControl : Boolean
         read FSizeControl
         write FSizeControl;

      property PressColor : TColor
      read FPressColor
      write FPressColor;

      property PressTextColor : TColor
         read FPressTextColor
         write FPressTextColor;

      property DownUp : Boolean
         read FDownUp
         write FDownUp;

      property CanMove : Boolean
         read FCanMove
         write FCanMove;
   end;

procedure Register;

implementation

procedure THPanel.MouseDown( var Message : TWMLButtonDown );
begin
   inherited;

   Fx0 := Message.XPos;
   Fy0 := Message.YPos;
   FPess := True;

   if not DownUp then
      Exit;

   FInner := BevelInner;
   BevelInner := bvLowered;

   FSaveTextColor := Font.Color;
   FSaveColor := Color;

   Font.Color := FPressTextColor;
   Color := FPressColor;

end;

procedure THPanel.MouseUp( var Message : TWMLButtonUp );
begin
   inherited;
   FPess := False;

   if not DownUp then
      Exit;

   BevelInner := FInner;
   Font.Color := FSaveTextColor;
   Color := FSaveColor;

end;

procedure THPanel.MouseMove( var Message : TWMMouseMove );
begin
   inherited;
   if ( FOwner is TForm ) and FCanMove then
      if FPess then
         begin
            TForm( FOwner ).Left := TForm( FOwner ).Left
               - Fx0 + Message.XPos;
            TForm( FOwner ).Top := TForm( FOwner ).Top
               - Fy0 + Message.YPos;
         end;
end;

constructor THPanel.Create( AOwner : TComponent );
begin
   inherited Create( AOwner );
   FOwner := AOwner;
   FPess := False;
   FPressTextColor := clSilver;
   FPressColor := clBtnface;
   FSizeControl := False;
   FDownUp := False;
end;

procedure THPanel.Loaded;
begin
   if ( FOwner is TForm ) and FSizeControl then
      begin
         TForm( FOwner ).Constraints.MinWidth := Left + Width
            + ( TForm( FOwner ).Width - TForm( FOwner ).ClientWidth );
         TForm( FOwner ).Constraints.MinHeight := top + Height
            + ( TForm( FOwner ).Height - TForm( FOwner ).ClientHeight );
      end;
end;

destructor THPanel.Destroy;
begin
   inherited Destroy;
end;

procedure Register;
begin
   RegisterComponents( 'HNV', [ THPanel ] );
end;

end.

