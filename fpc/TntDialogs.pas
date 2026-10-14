{ FPC/LCL compatibility shim for the TntWare Unicode Controls used by Ares.
  Under the LCL every control is already Unicode (UTF-8 strings), so the Tnt
  classes are thin subclasses that keep the .dfm class names streamable. }
unit TntDialogs;

{$mode delphi}

interface

uses
  Classes, Dialogs;

type
  TTntOpenDialog = class(TOpenDialog);
  TTntSaveDialog = class(TSaveDialog);

implementation

initialization
  RegisterClasses([TTntOpenDialog, TTntSaveDialog]);
end.
