{ FPC/LCL compatibility shim for the TntWare Unicode Controls used by Ares.
  Under the LCL every control is already Unicode (UTF-8 strings), so the Tnt
  classes are thin subclasses that keep the .dfm class names streamable. }
unit TntButtons;

{$mode delphi}

interface

uses
  Classes, Buttons;

type
  TTntBitBtn = class(TBitBtn);
  TTntSpeedButton = class(TSpeedButton);

implementation

initialization
  RegisterClasses([TTntBitBtn, TTntSpeedButton]);
end.
