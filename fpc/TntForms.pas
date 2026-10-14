{ FPC/LCL compatibility shim for the TntWare Unicode Controls used by Ares.
  Under the LCL every control is already Unicode (UTF-8 strings), so the Tnt
  classes are thin subclasses that keep the .dfm class names streamable. }
unit TntForms;

{$mode delphi}

interface

uses
  Classes, Forms;

type
  TTntForm = class(TForm);
  TTntApplication = class
  end;

implementation

initialization
  RegisterClasses([TTntForm]);
end.
