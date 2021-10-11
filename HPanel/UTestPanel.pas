unit UTestPanel;

interface

uses
   Windows,
   Messages,
   SysUtils,
   Variants,
   Classes,
   Graphics,
   Controls,
   Forms,
   Dialogs,
   ExtCtrls,
   HPanel;

type
   TForm1 = class( TForm )
      B1 : THPanel;
    B2: THPanel;
    B3: THPanel;
    B4: THPanel;
    HPanel1: THPanel;
   private
      { Private declarations }
   public
      { Public declarations }
   end;

var
   Form1 : TForm1;

implementation

{$R *.dfm}

end.

