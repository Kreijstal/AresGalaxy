{ Minimal replacement for the parts of DSPack's DSUtil unit used by Ares. }
unit DSUtil;

{$mode delphi}

interface

uses
  Windows, SysUtils, DirectShow9;

{ DirectShow REFERENCE_TIME is in 100 ns units }
function MiliSecToRefTime(Milli: Int64): TReferenceTime;
function RefTimeToMiliSec(RefTime: TReferenceTime): Int64;
{ text for a DirectShow/COM error code (quartz.dll AMGetErrorTextW) }
function GetErrorString(hr: HRESULT): string;
{ Num-th output pin of a filter, or nil }
function GetOutPin(Filter: IBaseFilter; Num: Integer): IPin;
{ Num-th input pin of a filter, or nil }
function GetInPin(Filter: IBaseFilter; Num: Integer): IPin;
{ map a 0..100 volume to IBasicAudio's -10000..0 (1/100 dB) scale and back }
function SetBasicAudioVolume(Value: Integer): Integer;
function GetBasicAudioVolume(Value: Integer): Integer;

implementation

function FindPinByDirection(Filter: IBaseFilter; Dir: TPinDirection; Num: Integer): IPin;
var
  Enum: IEnumPins;
  Pin: IPin;
  PinDir: TPinDirection;
begin
  Result := nil;
  if (Filter = nil) or Failed(Filter.EnumPins(Enum)) then
    Exit;
  while Enum.Next(1, Pin, nil) = S_OK do
  begin
    if Succeeded(Pin.QueryDirection(PinDir)) and (PinDir = Dir) then
    begin
      if Num = 0 then
      begin
        Result := Pin;
        Exit;
      end;
      Dec(Num);
    end;
    Pin := nil;
  end;
end;

function GetOutPin(Filter: IBaseFilter; Num: Integer): IPin;
begin
  Result := FindPinByDirection(Filter, PINDIR_OUTPUT, Num);
end;

function GetInPin(Filter: IBaseFilter; Num: Integer): IPin;
begin
  Result := FindPinByDirection(Filter, PINDIR_INPUT, Num);
end;

function SetBasicAudioVolume(Value: Integer): Integer;
begin
  Result := Round(1085.73 * Ln(Value * 100 + 1)) - 10000;
end;

function GetBasicAudioVolume(Value: Integer): Integer;
begin
  Result := Round((Exp((Value + 10000) / 1085.73) - 1) / 100);
end;


function MiliSecToRefTime(Milli: Int64): TReferenceTime;
begin
  Result := Milli * 10000;
end;

function RefTimeToMiliSec(RefTime: TReferenceTime): Int64;
begin
  Result := RefTime div 10000;
end;

function AMGetErrorTextW(hr: HRESULT; pBuffer: PWideChar; MaxLen: DWORD): DWORD; stdcall;
  external 'quartz.dll' name 'AMGetErrorTextW';

function GetErrorString(hr: HRESULT): string;
var
  Buf: array[0..511] of WideChar;
  Len: DWORD;
begin
  Len := 0;
  try
    Len := AMGetErrorTextW(hr, Buf, Length(Buf));
  except
    Len := 0;
  end;
  if Len > 0 then
    Result := UTF8Encode(WideString(PWideChar(@Buf[0])))
  else
    Result := SysErrorMessage(hr);
end;

end.
