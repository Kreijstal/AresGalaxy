{ VCL compatibility helpers for building Ares with Free Pascal + LCL (win32/win64 widgetset).

  Collects the small pieces of the Delphi 7 VCL that the LCL does not provide:
  a few message records, bevel types, DIB helpers and HInstance lookups.
  It also tells the LCL form reader to silently skip VCL-only properties that
  appear in the original .dfm files. }
unit VCLCompat;

{$mode delphi}

interface

uses
  Windows, Messages, Classes, SysUtils, Graphics, Controls;

type
  TBevelKind = (bkNone, bkTile, bkSoft, bkFlat);
  TBevelEdge = (beLeft, beTop, beRight, beBottom);
  TBevelEdges = set of TBevelEdge;

  TWMNCRButtonDown = TWMNCHitMessage;
  { WM_COPYDATA, missing from FPC's Messages unit (pointer sized layout) }
  TWMCopyData = record
    Msg: UINT;
    MsgFiller: TDWordFiller;
    From: HWND;
    CopyDataStruct: PCopyDataStruct;
    Result: LRESULT;
  end;
  TWMNCRButtonUp = TWMNCHitMessage;
  TWMNCRButtonDblClk = TWMNCHitMessage;

const
  ComCtlVersionIE3 = $00040046;
  ComCtlVersionIE4 = $00040047;
  ComCtlVersionIE401 = $00040048;
  ComCtlVersionIE5 = $00050050;
  ComCtlVersionIE501 = $00050051;
  ComCtlVersionIE6 = $00060000;

type
  TWndMethod = procedure(var Message: TMessage) of object;

{ VCL-style utility windows. FPC's Classes.AllocateHWnd is only a hook that the
  LCL does not fill with a TMessage based implementation, so provide one. The
  method receives every message and must call DefWindowProc itself for the
  ones it does not handle, exactly like with the VCL. }
function AllocateHWnd(Method: TWndMethod): HWND;
procedure DeallocateHWnd(Wnd: HWND);

function FindClassHInstance(AClass: TClass): HINST;
{ comctl32.dll version as MakeLong(minor, major), like the VCL's ComCtrls.GetComCtlVersion }
function GetComCtlVersion: Integer;
procedure RecreateWndCompat(AControl: TWinControl);
// VCL TCanvas.TextFlags (ETO_OPAQUE/ETO_CLIPPED) mapped onto the LCL TextStyle.
function CanvasTextFlags(ACanvas: TCanvas): Integer;
procedure SetCanvasTextFlags(ACanvas: TCanvas; Flags: Integer);
function CreateMappedRes(Instance: THandle; ResName: PChar; const OldColors,
  NewColors: array of TColor): HBITMAP;
procedure GetDIBSizes(Bitmap: HBITMAP; var InfoHeaderSize: Cardinal; var ImageSize: Cardinal);
function GetDIB(Bitmap: HBITMAP; Palette: HPALETTE; var BitmapInfo; var Bits): Boolean;

implementation

uses
  LResources;

type
  TCompatColorMap = record
    cFrom: COLORREF;
    cTo: COLORREF;
  end;

function CreateMappedBitmap(hInstance: HINST; idBitmap: PtrInt; wFlags: UINT;
  lpColorMap: Pointer; iNumMaps: Integer): HBITMAP; stdcall; external 'comctl32.dll';

function FindClassHInstance(AClass: TClass): HINST;
begin
  Result := HInstance;
end;

function CreateMappedRes(Instance: THandle; ResName: PChar; const OldColors,
  NewColors: array of TColor): HBITMAP;
var
  Map: array of TCompatColorMap;
  I: Integer;
begin
  SetLength(Map, Length(OldColors));
  for I := 0 to High(Map) do
  begin
    Map[I].cFrom := ColorToRGB(OldColors[I]);
    Map[I].cTo := ColorToRGB(NewColors[I]);
  end;
  if Length(Map) > 0 then
    Result := CreateMappedBitmap(Instance, PtrInt(ResName), 0, @Map[0], Length(Map))
  else
    Result := LoadBitmap(Instance, ResName);
end;

type
  TDllVersionInfo = record
    cbSize, dwMajorVersion, dwMinorVersion, dwBuildNumber, dwPlatformID: DWORD;
  end;

function GetComCtlVersion: Integer;
var
  Lib: HMODULE;
  DllGetVersion: function(var Info: TDllVersionInfo): HRESULT; stdcall;
  Info: TDllVersionInfo;
begin
  Result := 0;
  Lib := LoadLibrary('comctl32.dll');
  if Lib = 0 then
    Exit;
  try
    @DllGetVersion := GetProcAddress(Lib, 'DllGetVersion');
    if Assigned(DllGetVersion) then
    begin
      FillChar(Info, SizeOf(Info), 0);
      Info.cbSize := SizeOf(Info);
      if DllGetVersion(Info) = S_OK then
        Result := MakeLong(Info.dwMinorVersion, Info.dwMajorVersion);
    end;
  finally
    FreeLibrary(Lib);
  end;
end;

type
  PWndMethod = ^TWndMethod;

const
  UtilWindowClassName = 'AresVCLCompatUtilWindow';

var
  UtilClassRegistered: Boolean = False;

function UtilWindowProc(Wnd: HWND; Msg: UINT; WParam: WPARAM; LParam: LPARAM): LRESULT; stdcall;
var
  M: PWndMethod;
  Message: TMessage;
begin
  M := PWndMethod(GetWindowLongPtr(Wnd, GWLP_USERDATA));
  if M = nil then
    Exit(DefWindowProc(Wnd, Msg, WParam, LParam));
  Message.Msg := Msg;
  Message.WParam := WParam;
  Message.LParam := LParam;
  Message.Result := 0;
  M^(Message);
  Result := Message.Result;
end;

function AllocateHWnd(Method: TWndMethod): HWND;
var
  WC: TWndClass;
  M: PWndMethod;
begin
  if not UtilClassRegistered then
  begin
    FillChar(WC, SizeOf(WC), 0);
    WC.lpfnWndProc := @DefWindowProc;
    WC.hInstance := HInstance;
    WC.lpszClassName := UtilWindowClassName;
    Windows.RegisterClass(WC);
    UtilClassRegistered := True;
  end;
  Result := CreateWindowEx(WS_EX_TOOLWINDOW, UtilWindowClassName, '', WS_POPUP, 0, 0, 0, 0,
    0, 0, HInstance, nil);
  if Assigned(Method) then
  begin
    New(M);
    M^ := Method;
    SetWindowLongPtr(Result, GWLP_USERDATA, LONG_PTR(M));
    SetWindowLongPtr(Result, GWLP_WNDPROC, LONG_PTR(@UtilWindowProc));
  end;
end;

procedure DeallocateHWnd(Wnd: HWND);
var
  M: PWndMethod;
begin
  if Wnd = 0 then
    Exit;
  M := PWndMethod(GetWindowLongPtr(Wnd, GWLP_USERDATA));
  SetWindowLongPtr(Wnd, GWLP_WNDPROC, LONG_PTR(@DefWindowProc));
  DestroyWindow(Wnd);
  if M <> nil then
    Dispose(M);
end;

procedure RecreateWndCompat(AControl: TWinControl);
begin
  Controls.RecreateWnd(AControl);
end;

function CanvasTextFlags(ACanvas: TCanvas): Integer;
begin
  Result := 0;
  if ACanvas.TextStyle.Opaque then
    Result := Result or ETO_OPAQUE;
  if ACanvas.TextStyle.Clipping then
    Result := Result or ETO_CLIPPED;
end;

procedure SetCanvasTextFlags(ACanvas: TCanvas; Flags: Integer);
var
  TS: TTextStyle;
begin
  TS := ACanvas.TextStyle;
  TS.Opaque := (Flags and ETO_OPAQUE) <> 0;
  TS.Clipping := (Flags and ETO_CLIPPED) <> 0;
  ACanvas.TextStyle := TS;
end;

procedure GetDIBSizes(Bitmap: HBITMAP; var InfoHeaderSize: Cardinal; var ImageSize: Cardinal);
var
  BM: Windows.TBitmap;
begin
  // Always hand out a 32 bit DIB: header without color table plus DWORD aligned rows.
  FillChar(BM, SizeOf(BM), 0);
  GetObject(Bitmap, SizeOf(BM), @BM);
  InfoHeaderSize := SizeOf(TBitmapInfoHeader);
  ImageSize := Cardinal(BM.bmWidth) * 4 * Cardinal(Abs(BM.bmHeight));
end;

function GetDIB(Bitmap: HBITMAP; Palette: HPALETTE; var BitmapInfo; var Bits): Boolean;
var
  BM: Windows.TBitmap;
  DC: HDC;
  Info: TBitmapInfoHeader absolute BitmapInfo;
begin
  FillChar(BM, SizeOf(BM), 0);
  GetObject(Bitmap, SizeOf(BM), @BM);
  FillChar(Info, SizeOf(Info), 0);
  Info.biSize := SizeOf(Info);
  Info.biWidth := BM.bmWidth;
  Info.biHeight := BM.bmHeight;
  Info.biPlanes := 1;
  Info.biBitCount := 32;
  Info.biCompression := BI_RGB;
  DC := GetDC(0);
  try
    Result := GetDIBits(DC, Bitmap, 0, Abs(BM.bmHeight), @Bits, PBitmapInfo(@Info)^, DIB_RGB_COLORS) <> 0;
  finally
    ReleaseDC(0, DC);
  end;
end;

procedure SkipVCLOnlyProperties;
const
  // Delphi VCL (and Ares component) properties found in the .dfm files that
  // have no LCL counterpart. They are skipped while streaming forms in; the
  // LCL only consults this list for properties it cannot find.
  Props: array[0..15] of string = (
    'Ctl3D', 'ParentCtl3D', 'BevelKind', 'BevelEdges', 'BevelInner', 'BevelOuter',
    'ImeName', 'OldCreateOrder', 'TextHeight', 'PrintScale', 'OnCanResize',
    'AutoHotkeys', 'ThumbLength', 'bottomShadow', 'topShadow', 'index_disabled');
var
  S: string;
begin
  for S in Props do
    RegisterPropertyToSkip(TComponent, S, 'VCL compatibility property', '');
end;

initialization
  SkipVCLOnlyProperties;
end.
