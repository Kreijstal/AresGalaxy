{ FPC compatibility shim for the parts of TntWare's TntSysUtils used by Ares. }
unit TntSysUtils;

{$mode delphi}

interface

uses
  Windows, SysUtils;

function Tnt_WideLowerCase(const S: WideString): WideString;
function WideTextPos(const SubStr, S: WideString): Integer;
function WideGetModuleFileName(Instance: HMODULE): WideString;

implementation

function WideTextPos(const SubStr, S: WideString): Integer;
begin
  Result := Pos(WideUpperCase(SubStr), WideUpperCase(S));
end;

function Tnt_WideLowerCase(const S: WideString): WideString;
begin
  Result := WideLowerCase(S);
end;

function WideGetModuleFileName(Instance: HMODULE): WideString;
var
  Buf: array[0..MAX_PATH * 4] of WideChar;
  Len: DWORD;
begin
  Len := GetModuleFileNameW(Instance, Buf, Length(Buf));
  SetString(Result, PWideChar(@Buf[0]), Len);
end;

end.
