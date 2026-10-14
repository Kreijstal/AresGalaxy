{ Minimal DirectDraw (version 1) headers for building Ares with Free Pascal.

  Replaces the subset of DSPack's DirectDraw.pas that Ares uses (media info
  probing via IAMMultiMediaStream). Layouts follow the Windows SDK /
  mingw-w64 ddraw.h and are valid for Win32 and Win64. }
unit DirectDraw;

{$mode delphi}
{$PACKRECORDS C}

interface

uses
  Windows;

type
  TDDColorKey = record
    dwColorSpaceLowValue: DWORD;
    dwColorSpaceHighValue: DWORD;
  end;

  TDDPixelFormat = record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwFourCC: DWORD;
    case Integer of
      0: (dwRGBBitCount, dwRBitMask, dwGBitMask, dwBBitMask, dwRGBAlphaBitMask: DWORD);
      1: (dwYUVBitCount, dwYBitMask, dwUBitMask, dwVBitMask, dwYUVAlphaBitMask: DWORD);
      2: (dwZBufferBitDepth, dwStencilBitDepth, dwZBitMask, dwStencilBitMask, dwRGBZBitMask: DWORD);
      3: (dwAlphaBitDepth, dwLuminanceBitMask, dwBumpDvBitMask, dwBumpLuminanceBitMask, dwYUVZBitMask: DWORD);
  end;

  TDDSCaps = record
    dwCaps: DWORD;
  end;

  PDDSurfaceDesc = ^TDDSurfaceDesc;
  TDDSurfaceDesc = record
    dwSize: DWORD;
    dwFlags: DWORD;
    dwHeight: DWORD;
    dwWidth: DWORD;
    case Integer of
      0: (lPitch: Longint;
          dwBackBufferCount: DWORD;
          dwMipMapCount: DWORD;
          dwAlphaBitDepth: DWORD;
          dwReserved: DWORD;
          lpSurface: Pointer;
          ddckCKDestOverlay: TDDColorKey;
          ddckCKDestBlt: TDDColorKey;
          ddckCKSrcOverlay: TDDColorKey;
          ddckCKSrcBlt: TDDColorKey;
          ddpfPixelFormat: TDDPixelFormat;
          ddsCaps: TDDSCaps);
      1: (dwLinearSize: DWORD;
          dwBackBufferCount_: DWORD;
          dwRefreshRate: DWORD);
      2: (dwLinearSize_: DWORD;
          dwBackBufferCount__: DWORD;
          dwZBufferBitDepth: DWORD);
  end;
  DDSURFACEDESC = TDDSurfaceDesc;

  IDirectDrawSurface = interface;
  IDirectDrawPalette = interface;

  IDirectDraw = interface(IUnknown)
    ['{6C14DB80-A733-11CE-A521-0020AF0BE560}']
    function Compact: HRESULT; stdcall;
    function CreateClipper(dwFlags: DWORD; out lplpDDClipper: IUnknown; pUnkOuter: IUnknown): HRESULT; stdcall;
    function CreatePalette(dwFlags: DWORD; lpColorTable: Pointer; out lplpDDPalette: IDirectDrawPalette;
      pUnkOuter: IUnknown): HRESULT; stdcall;
    function CreateSurface(var lpDDSurfaceDesc: TDDSurfaceDesc; out lplpDDSurface: IDirectDrawSurface;
      pUnkOuter: IUnknown): HRESULT; stdcall;
    function DuplicateSurface(lpDDSurface: IDirectDrawSurface; out lplpDupDDSurface: IDirectDrawSurface): HRESULT; stdcall;
    function EnumDisplayModes(dwFlags: DWORD; lpDDSurfaceDesc: PDDSurfaceDesc; lpContext: Pointer;
      lpEnumModesCallback: Pointer): HRESULT; stdcall;
    function EnumSurfaces(dwFlags: DWORD; lpDDSD: PDDSurfaceDesc; lpContext: Pointer;
      lpEnumCallback: Pointer): HRESULT; stdcall;
    function FlipToGDISurface: HRESULT; stdcall;
    function GetCaps(lpDDDriverCaps: Pointer; lpDDHELCaps: Pointer): HRESULT; stdcall;
    function GetDisplayMode(out lpDDSurfaceDesc: TDDSurfaceDesc): HRESULT; stdcall;
    function GetFourCCCodes(var lpNumCodes: DWORD; lpCodes: PDWORD): HRESULT; stdcall;
    function GetGDISurface(out lplpGDIDDSSurface: IDirectDrawSurface): HRESULT; stdcall;
    function GetMonitorFrequency(out lpdwFrequency: DWORD): HRESULT; stdcall;
    function GetScanLine(out lpdwScanLine: DWORD): HRESULT; stdcall;
    function GetVerticalBlankStatus(out lpbIsInVB: BOOL): HRESULT; stdcall;
    function Initialize(lpGUID: PGUID): HRESULT; stdcall;
    function RestoreDisplayMode: HRESULT; stdcall;
    function SetCooperativeLevel(hWnd: HWND; dwFlags: DWORD): HRESULT; stdcall;
    function SetDisplayMode(dwWidth, dwHeight, dwBpp: DWORD): HRESULT; stdcall;
    function WaitForVerticalBlank(dwFlags: DWORD; hEvent: THandle): HRESULT; stdcall;
  end;

  IDirectDrawSurface = interface(IUnknown)
    ['{6C14DB81-A733-11CE-A521-0020AF0BE560}']
    function AddAttachedSurface(lpDDSAttachedSurface: IDirectDrawSurface): HRESULT; stdcall;
    function AddOverlayDirtyRect(const lpRect: TRect): HRESULT; stdcall;
    function Blt(lpDestRect: PRect; lpDDSrcSurface: IDirectDrawSurface; lpSrcRect: PRect;
      dwFlags: DWORD; lpDDBltFx: Pointer): HRESULT; stdcall;
    function BltBatch(lpDDBltBatch: Pointer; dwCount: DWORD; dwFlags: DWORD): HRESULT; stdcall;
    function BltFast(dwX, dwY: DWORD; lpDDSrcSurface: IDirectDrawSurface; lpSrcRect: PRect;
      dwTrans: DWORD): HRESULT; stdcall;
    function DeleteAttachedSurface(dwFlags: DWORD; lpDDSAttachedSurface: IDirectDrawSurface): HRESULT; stdcall;
    function EnumAttachedSurfaces(lpContext: Pointer; lpEnumSurfacesCallback: Pointer): HRESULT; stdcall;
    function EnumOverlayZOrders(dwFlags: DWORD; lpContext: Pointer; lpfnCallback: Pointer): HRESULT; stdcall;
    function Flip(lpDDSurfaceTargetOverride: IDirectDrawSurface; dwFlags: DWORD): HRESULT; stdcall;
    function GetAttachedSurface(var lpDDSCaps: TDDSCaps; out lplpDDAttachedSurface: IDirectDrawSurface): HRESULT; stdcall;
    function GetBltStatus(dwFlags: DWORD): HRESULT; stdcall;
    function GetCaps(out lpDDSCaps: TDDSCaps): HRESULT; stdcall;
    function GetClipper(out lplpDDClipper: IUnknown): HRESULT; stdcall;
    function GetColorKey(dwFlags: DWORD; out lpDDColorKey: TDDColorKey): HRESULT; stdcall;
    function GetDC(out lphDC: HDC): HRESULT; stdcall;
    function GetFlipStatus(dwFlags: DWORD): HRESULT; stdcall;
    function GetOverlayPosition(out lplX, lplY: Longint): HRESULT; stdcall;
    function GetPalette(out lplpDDPalette: IDirectDrawPalette): HRESULT; stdcall;
    function GetPixelFormat(out lpDDPixelFormat: TDDPixelFormat): HRESULT; stdcall;
    function GetSurfaceDesc(out lpDDSurfaceDesc: TDDSurfaceDesc): HRESULT; stdcall;
    function Initialize(lpDD: IDirectDraw; out lpDDSurfaceDesc: TDDSurfaceDesc): HRESULT; stdcall;
    function IsLost: HRESULT; stdcall;
    function Lock(lpDestRect: PRect; out lpDDSurfaceDesc: TDDSurfaceDesc; dwFlags: DWORD;
      hEvent: THandle): HRESULT; stdcall;
    function ReleaseDC(hDC: HDC): HRESULT; stdcall;
    function Restore: HRESULT; stdcall;
    function SetClipper(lpDDClipper: IUnknown): HRESULT; stdcall;
    function SetColorKey(dwFlags: DWORD; lpDDColorKey: Pointer): HRESULT; stdcall;
    function SetOverlayPosition(lX, lY: Longint): HRESULT; stdcall;
    function SetPalette(lpDDPalette: IDirectDrawPalette): HRESULT; stdcall;
    function Unlock(lpSurfaceData: Pointer): HRESULT; stdcall;
    function UpdateOverlay(lpSrcRect: PRect; lpDDDestSurface: IDirectDrawSurface; lpDestRect: PRect;
      dwFlags: DWORD; lpDDOverlayFx: Pointer): HRESULT; stdcall;
    function UpdateOverlayDisplay(dwFlags: DWORD): HRESULT; stdcall;
    function UpdateOverlayZOrder(dwFlags: DWORD; lpDDSReference: IDirectDrawSurface): HRESULT; stdcall;
  end;

  IDirectDrawPalette = interface(IUnknown)
    ['{6C14DB84-A733-11CE-A521-0020AF0BE560}']
    function GetCaps(out lpdwCaps: DWORD): HRESULT; stdcall;
    function GetEntries(dwFlags: DWORD; dwBase: DWORD; dwNumEntries: DWORD; lpEntries: Pointer): HRESULT; stdcall;
    function Initialize(lpDD: IDirectDraw; dwFlags: DWORD; lpDDColorTable: Pointer): HRESULT; stdcall;
    function SetEntries(dwFlags: DWORD; dwStartingEntry: DWORD; dwCount: DWORD; lpEntries: Pointer): HRESULT; stdcall;
  end;

const
  IID_IDirectDraw: TGUID = '{6C14DB80-A733-11CE-A521-0020AF0BE560}';
  IID_IDirectDrawSurface: TGUID = '{6C14DB81-A733-11CE-A521-0020AF0BE560}';
  IID_IDirectDrawPalette: TGUID = '{6C14DB84-A733-11CE-A521-0020AF0BE560}';

  DDSCL_FULLSCREEN = $00000001;
  DDSCL_ALLOWREBOOT = $00000002;
  DDSCL_NOWINDOWCHANGES = $00000004;
  DDSCL_NORMAL = $00000008;
  DDSCL_EXCLUSIVE = $00000010;

  DDSCAPS_OFFSCREENPLAIN = $00000040;
  DDSCAPS_PRIMARYSURFACE = $00000200;
  DDSCAPS_SYSTEMMEMORY = $00000800;
  DDSCAPS_VIDEOMEMORY = $00004000;

  DDSD_CAPS = $00000001;
  DDSD_HEIGHT = $00000002;
  DDSD_WIDTH = $00000004;
  DDSD_PITCH = $00000008;
  DDSD_BACKBUFFERCOUNT = $00000020;
  DDSD_ZBUFFERBITDEPTH = $00000040;
  DDSD_ALPHABITDEPTH = $00000080;
  DDSD_LPSURFACE = $00000800;
  DDSD_PIXELFORMAT = $00001000;
  DDSD_CKDESTOVERLAY = $00002000;
  DDSD_CKDESTBLT = $00004000;
  DDSD_CKSRCOVERLAY = $00008000;
  DDSD_CKSRCBLT = $00010000;
  DDSD_MIPMAPCOUNT = $00020000;
  DDSD_REFRESHRATE = $00040000;
  DDSD_LINEARSIZE = $00080000;
  DDSD_ALL = $00FFF9EE;

  DDPF_RGB = $00000040;

function DirectDrawCreate(lpGUID: PGUID; out lplpDD: IDirectDraw; pUnkOuter: IUnknown): HRESULT; stdcall;

implementation

function DirectDrawCreate(lpGUID: PGUID; out lplpDD: IDirectDraw; pUnkOuter: IUnknown): HRESULT; stdcall;
  external 'ddraw.dll' name 'DirectDrawCreate';

end.
