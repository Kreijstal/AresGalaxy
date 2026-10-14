{ FPC/LCL compatibility shim for the TntWare Unicode Controls used by Ares.
  Under the LCL every control is already Unicode (UTF-8 strings), so the Tnt
  classes are thin subclasses that keep the .dfm class names streamable. }
unit TntExtCtrls;

{$mode delphi}

interface

uses
  Classes, ExtCtrls;

type
  TTntPanel = class(TPanel);
  TTntImage = class(TImage);
  TTntRadioGroup = class(TRadioGroup);

implementation

initialization
  RegisterClasses([TTntPanel, TTntImage, TTntRadioGroup]);
end.
