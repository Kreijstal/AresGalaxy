{ FPC/LCL compatibility shim for the TntWare Unicode Controls used by Ares.
  Under the LCL every control is already Unicode (UTF-8 strings), so the Tnt
  classes are thin subclasses that keep the .dfm class names streamable. }
unit TntWindows;

{$mode delphi}

interface

uses
  Windows, ShellAPI;

function Tnt_CreateFileW(lpFileName: PWideChar; dwDesiredAccess, dwShareMode: DWORD;
  lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
  hTemplateFile: THandle): THandle;
function Tnt_CreateDirectoryW(lpPathName: PWideChar; lpSecurityAttributes: PSecurityAttributes): BOOL;
function Tnt_RemoveDirectoryW(lpPathName: PWideChar): BOOL;
function Tnt_DeleteFileW(lpFileName: PWideChar): BOOL;
function Tnt_MoveFileW(lpExistingFileName, lpNewFileName: PWideChar): BOOL;
function Tnt_FindFirstFileW(lpFileName: PWideChar; var lpFindFileData: TWin32FindDataW): THandle;
function Tnt_FindNextFileW(hFindFile: THandle; var lpFindFileData: TWin32FindDataW): BOOL;
function Tnt_GetDiskFreeSpaceExW(lpDirectoryName: PWideChar; var lpFreeBytesAvailableToCaller,
  lpTotalNumberOfBytes; lpTotalNumberOfFreeBytes: PLargeInteger): BOOL;
function Tnt_ShellExecuteW(hWnd: HWND; Operation, FileName, Parameters, Directory: PWideChar;
  ShowCmd: Integer): HINST;

implementation

function Tnt_CreateFileW(lpFileName: PWideChar; dwDesiredAccess, dwShareMode: DWORD;
  lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
  hTemplateFile: THandle): THandle;
begin
  Result := CreateFileW(lpFileName, dwDesiredAccess, dwShareMode, lpSecurityAttributes,
    dwCreationDisposition, dwFlagsAndAttributes, hTemplateFile);
end;

function Tnt_CreateDirectoryW(lpPathName: PWideChar; lpSecurityAttributes: PSecurityAttributes): BOOL;
begin
  Result := CreateDirectoryW(lpPathName, lpSecurityAttributes);
end;

function Tnt_RemoveDirectoryW(lpPathName: PWideChar): BOOL;
begin
  Result := RemoveDirectoryW(lpPathName);
end;

function Tnt_DeleteFileW(lpFileName: PWideChar): BOOL;
begin
  Result := DeleteFileW(lpFileName);
end;

function Tnt_MoveFileW(lpExistingFileName, lpNewFileName: PWideChar): BOOL;
begin
  Result := MoveFileW(lpExistingFileName, lpNewFileName);
end;

function Tnt_FindFirstFileW(lpFileName: PWideChar; var lpFindFileData: TWin32FindDataW): THandle;
begin
  Result := FindFirstFileW(lpFileName, lpFindFileData);
end;

function Tnt_FindNextFileW(hFindFile: THandle; var lpFindFileData: TWin32FindDataW): BOOL;
begin
  Result := FindNextFileW(hFindFile, lpFindFileData);
end;

function Tnt_GetDiskFreeSpaceExW(lpDirectoryName: PWideChar; var lpFreeBytesAvailableToCaller,
  lpTotalNumberOfBytes; lpTotalNumberOfFreeBytes: PLargeInteger): BOOL;
begin
  Result := GetDiskFreeSpaceExW(lpDirectoryName, @lpFreeBytesAvailableToCaller,
    @lpTotalNumberOfBytes, lpTotalNumberOfFreeBytes);
end;

function Tnt_ShellExecuteW(hWnd: HWND; Operation, FileName, Parameters, Directory: PWideChar;
  ShowCmd: Integer): HINST;
begin
  Result := ShellExecuteW(hWnd, Operation, FileName, Parameters, Directory, ShowCmd);
end;

end.
