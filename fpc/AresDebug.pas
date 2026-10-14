{ Startup/exception tracing for FPC builds of Ares.

  Compiled in only with -dARES_DEBUG: messages go to %TEMP%\ares_debug.log.
  (Ares swallows most exceptions, which hides porting problems otherwise.) }
unit AresDebug;

{$mode delphi}

interface

uses
  SysUtils;

procedure AresDebugLog(const S: string; E: Exception = nil);

implementation

procedure AresDebugLog(const S: string; E: Exception);
{$IFDEF ARES_DEBUG}
var
  F: TextFile;
begin
  AssignFile(F, GetEnvironmentVariable('TEMP') + '\ares_debug.log');
  {$I-}
  Append(F);
  if IOResult <> 0 then
    Rewrite(F);
  {$I+}
  if IOResult <> 0 then
    Exit;
  WriteLn(F, FormatDateTime('hh:nn:ss.zzz', Now), ' ', S);
  if E <> nil then
  begin
    WriteLn(F, '  ', E.ClassName, ': ', E.Message);
    DumpExceptionBackTrace(F);
  end;
  CloseFile(F);
end;
{$ELSE}
begin
end;
{$ENDIF}

end.
