{ FPC/LCL compatibility shim for the TntWare Unicode Controls used by Ares.
  Under the LCL every control is already Unicode (UTF-8 strings), so the Tnt
  classes are thin subclasses that keep the .dfm class names streamable. }
unit TntForms;

{$mode delphi}

interface

uses
  Classes, Forms;

type
  { Like the Tnt original, TTntForm.Caption is a WideString: Ares passes it
    straight to the W APIs (PWideChar(Caption)). }
  TTntForm = class(TForm)
  private
    function GetCaptionW: WideString;
    procedure SetCaptionW(const Value: WideString);
  published
    property Caption: WideString read GetCaptionW write SetCaptionW;
  end;

  TTntApplication = class
  end;

implementation

function TTntForm.GetCaptionW: WideString;
begin
  Result := UTF8Decode(inherited Caption);
end;

procedure TTntForm.SetCaptionW(const Value: WideString);
begin
  inherited Caption := UTF8Encode(Value);
end;

initialization
  RegisterClasses([TTntForm]);
end.
