{ FPC/LCL compatibility shim for the TntWare Unicode Controls used by Ares.
  Under the LCL every control is already Unicode (UTF-8 strings), so the Tnt
  classes are thin subclasses that keep the .dfm class names streamable. }
unit TntStdCtrls;

{$mode delphi}

interface

uses
  Classes, StdCtrls;

type
  TTntLabel = class(TLabel);
  TTntEdit = class(TEdit)
  private
    function GetPasswordCharW: WideChar;
    procedure SetPasswordCharW(Value: WideChar);
  published
    property PasswordCharW: WideChar read GetPasswordCharW write SetPasswordCharW default #0;
  end;
  TTntMemo = class(TMemo);
  TTntButton = class(TButton);
  TTntCheckBox = class(TCheckBox);
  TTntRadioButton = class(TRadioButton);
  TTntComboBox = class(TComboBox);
  TTntListBox = class(TListBox);
  TTntGroupBox = class(TGroupBox);
  TTntCustomEdit = TCustomEdit;

implementation

function TTntEdit.GetPasswordCharW: WideChar;
begin
  Result := WideChar(Ord(PasswordChar));
end;

procedure TTntEdit.SetPasswordCharW(Value: WideChar);
begin
  if Ord(Value) > 127 then
    PasswordChar := '*'
  else
    PasswordChar := Char(Ord(Value));
end;

initialization
  RegisterClasses([TTntLabel, TTntEdit, TTntMemo, TTntButton, TTntCheckBox,
    TTntRadioButton, TTntComboBox, TTntListBox, TTntGroupBox]);
end.
