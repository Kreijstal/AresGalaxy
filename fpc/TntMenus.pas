{ FPC/LCL compatibility shim for the TntWare Unicode Controls used by Ares.
  Under the LCL every control is already Unicode (UTF-8 strings), so the Tnt
  classes are thin subclasses that keep the .dfm class names streamable. }
unit TntMenus;

{$mode delphi}

interface

uses
  Classes, Menus;

type
  TTntMenuItem = class(TMenuItem);
  TTntPopupMenu = class(TPopupMenu);
  TTntMainMenu = class(TMainMenu);

implementation

initialization
  RegisterClasses([TTntMenuItem, TTntPopupMenu, TTntMainMenu]);
end.
