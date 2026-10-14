{ FPC/LCL compatibility shim for the TntWare Unicode Controls used by Ares.
  Under the LCL every control is already Unicode (UTF-8 strings), so the Tnt
  classes are thin subclasses that keep the .dfm class names streamable. }
unit TntComCtrls;

{$mode delphi}

interface

uses
  Classes, ComCtrls;

type
  TTntTabSheet = class(TTabSheet);
  TTntPageControl = class(TPageControl);
  TTntStatusBar = class(TStatusBar);

implementation

initialization
  RegisterClasses([TTntTabSheet, TTntPageControl, TTntStatusBar]);
end.
