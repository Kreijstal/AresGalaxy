{ Minimal DirectShow headers for building Ares with Free Pascal.

  Replaces the subset of DSPack's DirectShow9.pas that Ares uses. The
  interface layouts (method order) follow the Windows SDK / mingw-w64
  strmif.h, control.h, amstream.h, mmstream.h, ddstream.h and qedit.h, and
  are valid for both Win32 and Win64. Parameter passing follows DSPack's
  Pascal translation so the Ares sources compile unchanged. }
unit DirectShow9;

{$mode delphi}
{$MINENUMSIZE 4}
{$PACKRECORDS C}

interface

uses
  Windows, ActiveX, DirectDraw;

type
  REFERENCE_TIME = Int64;
  TReferenceTime = REFERENCE_TIME;
  PReferenceTime = ^TReferenceTime;
  REFTIME = Double;
  TRefTime = REFTIME;
  STREAM_TIME = Int64;
  TStreamTime = STREAM_TIME;
  OAHWND = LONG_PTR;
  OAEVENT = LONG_PTR;
  OAFilterState = Longint;

  TFilterState = (State_Stopped, State_Paused, State_Running);
  TPinDirection = (PINDIR_INPUT, PINDIR_OUTPUT);
  PIN_DIRECTION = TPinDirection;

  PAMMediaType = ^TAMMediaType;
  _AMMediaType = record
    majortype: TGUID;
    subtype: TGUID;
    bFixedSizeSamples: BOOL;
    bTemporalCompression: BOOL;
    lSampleSize: ULONG;
    formattype: TGUID;
    pUnk: Pointer;
    cbFormat: ULONG;
    pbFormat: Pointer;
  end;
  TAMMediaType = _AMMediaType;
  AM_MEDIA_TYPE = _AMMediaType;

  { multimedia streaming }
  STREAM_TYPE = (STREAMTYPE_READ, STREAMTYPE_WRITE, STREAMTYPE_TRANSFORM);
  TStreamType = STREAM_TYPE;
  STREAM_STATE = (STREAMSTATE_STOP, STREAMSTATE_RUN);
  TStreamState = STREAM_STATE;
  MSPID = TGUID;
  TMSPID = MSPID;
  PMSPID = ^MSPID;

  IBaseFilter = interface;
  IPin = interface;
  IEnumPins = interface;
  IFilterGraph = interface;
  IGraphBuilder = interface;
  IMultiMediaStream = interface;
  IMediaStream = interface;

  TPinInfo = record
    pFilter: Pointer; // IBaseFilter, not reference counted here
    dir: TPinDirection;
    achName: array[0..127] of WideChar;
  end;

  TFilterInfo = record
    achName: array[0..127] of WideChar;
    pGraph: Pointer; // IFilterGraph
  end;

  IPin = interface(IUnknown)
    ['{56A86891-0AD4-11CE-B03A-0020AF0BA770}']
    function Connect(pReceivePin: IPin; pmt: PAMMediaType): HRESULT; stdcall;
    function ReceiveConnection(pConnector: IPin; const pmt: TAMMediaType): HRESULT; stdcall;
    function Disconnect: HRESULT; stdcall;
    function ConnectedTo(out pPin: IPin): HRESULT; stdcall;
    function ConnectionMediaType(out pmt: TAMMediaType): HRESULT; stdcall;
    function QueryPinInfo(out pInfo: TPinInfo): HRESULT; stdcall;
    function QueryDirection(out pPinDir: TPinDirection): HRESULT; stdcall;
    function QueryId(out Id: PWideChar): HRESULT; stdcall;
    function QueryAccept(const pmt: TAMMediaType): HRESULT; stdcall;
    function EnumMediaTypes(out ppEnum: IUnknown): HRESULT; stdcall;
    function QueryInternalConnections(out apPin: IPin; var nPin: ULONG): HRESULT; stdcall;
    function EndOfStream: HRESULT; stdcall;
    function BeginFlush: HRESULT; stdcall;
    function EndFlush: HRESULT; stdcall;
    function NewSegment(tStart, tStop: TReferenceTime; dRate: Double): HRESULT; stdcall;
  end;

  IEnumPins = interface(IUnknown)
    ['{56A86892-0AD4-11CE-B03A-0020AF0BA770}']
    function Next(cPins: ULONG; out ppPins: IPin; pcFetched: PULONG): HRESULT; stdcall;
    function Skip(cPins: ULONG): HRESULT; stdcall;
    function Reset: HRESULT; stdcall;
    function Clone(out ppEnum: IEnumPins): HRESULT; stdcall;
  end;

  IMediaFilter = interface(IPersist)
    ['{56A86899-0AD4-11CE-B03A-0020AF0BA770}']
    function Stop: HRESULT; stdcall;
    function Pause: HRESULT; stdcall;
    function Run(tStart: TReferenceTime): HRESULT; stdcall;
    function GetState(dwMilliSecsTimeout: DWORD; out State: TFilterState): HRESULT; stdcall;
    function SetSyncSource(pClock: IUnknown): HRESULT; stdcall;
    function GetSyncSource(out pClock: IUnknown): HRESULT; stdcall;
  end;

  IBaseFilter = interface(IMediaFilter)
    ['{56A86895-0AD4-11CE-B03A-0020AF0BA770}']
    function EnumPins(out ppEnum: IEnumPins): HRESULT; stdcall;
    function FindPin(Id: PWideChar; out ppPin: IPin): HRESULT; stdcall;
    function QueryFilterInfo(out pInfo: TFilterInfo): HRESULT; stdcall;
    function JoinFilterGraph(pGraph: IFilterGraph; pName: PWideChar): HRESULT; stdcall;
    function QueryVendorInfo(out pVendorInfo: PWideChar): HRESULT; stdcall;
  end;

  IFilterGraph = interface(IUnknown)
    ['{56A8689F-0AD4-11CE-B03A-0020AF0BA770}']
    function AddFilter(pFilter: IBaseFilter; pName: PWideChar): HRESULT; stdcall;
    function RemoveFilter(pFilter: IBaseFilter): HRESULT; stdcall;
    function EnumFilters(out ppEnum: IUnknown): HRESULT; stdcall;
    function FindFilterByName(pName: PWideChar; out ppFilter: IBaseFilter): HRESULT; stdcall;
    function ConnectDirect(ppinOut, ppinIn: IPin; pmt: PAMMediaType): HRESULT; stdcall;
    function Reconnect(ppin: IPin): HRESULT; stdcall;
    function Disconnect(ppin: IPin): HRESULT; stdcall;
    function SetDefaultSyncSource: HRESULT; stdcall;
  end;

  IGraphBuilder = interface(IFilterGraph)
    ['{56A868A9-0AD4-11CE-B03A-0020AF0BA770}']
    function Connect(ppinOut, ppinIn: IPin): HRESULT; stdcall;
    function Render(ppinOut: IPin): HRESULT; stdcall;
    function RenderFile(lpcwstrFile, lpcwstrPlayList: PWideChar): HRESULT; stdcall;
    function AddSourceFilter(lpcwstrFileName, lpcwstrFilterName: PWideChar;
      out ppFilter: IBaseFilter): HRESULT; stdcall;
    function SetLogFile(hFile: DWORD_PTR): HRESULT; stdcall;
    function Abort: HRESULT; stdcall;
    function ShouldOperationContinue: HRESULT; stdcall;
  end;

  IFileSourceFilter = interface(IUnknown)
    ['{56A868A6-0AD4-11CE-B03A-0020AF0BA770}']
    function Load(pszFileName: PWideChar; pmt: PAMMediaType): HRESULT; stdcall;
    function GetCurFile(out ppszFileName: PWideChar; pmt: PAMMediaType): HRESULT; stdcall;
  end;

  IMediaSeeking = interface(IUnknown)
    ['{36B73880-C2C8-11CF-8B46-00805F6CEF60}']
    function GetCapabilities(out pCapabilities: DWORD): HRESULT; stdcall;
    function CheckCapabilities(var pCapabilities: DWORD): HRESULT; stdcall;
    function IsFormatSupported(const pFormat: TGUID): HRESULT; stdcall;
    function QueryPreferredFormat(out pFormat: TGUID): HRESULT; stdcall;
    function GetTimeFormat(out pFormat: TGUID): HRESULT; stdcall;
    function IsUsingTimeFormat(const pFormat: TGUID): HRESULT; stdcall;
    function SetTimeFormat(const pFormat: TGUID): HRESULT; stdcall;
    function GetDuration(out pDuration: Int64): HRESULT; stdcall;
    function GetStopPosition(out pStop: Int64): HRESULT; stdcall;
    function GetCurrentPosition(out pCurrent: Int64): HRESULT; stdcall;
    function ConvertTimeFormat(out pTarget: Int64; pTargetFormat: PGUID; Source: Int64;
      pSourceFormat: PGUID): HRESULT; stdcall;
    function SetPositions(var pCurrent: Int64; dwCurrentFlags: DWORD; var pStop: Int64;
      dwStopFlags: DWORD): HRESULT; stdcall;
    function GetPositions(out pCurrent, pStop: Int64): HRESULT; stdcall;
    function GetAvailable(out pEarliest, pLatest: Int64): HRESULT; stdcall;
    function SetRate(dRate: Double): HRESULT; stdcall;
    function GetRate(out pdRate: Double): HRESULT; stdcall;
    function GetPreroll(out pllPreroll: Int64): HRESULT; stdcall;
  end;

  IMediaControl = interface(IDispatch)
    ['{56A868B1-0AD4-11CE-B03A-0020AF0BA770}']
    function Run: HRESULT; stdcall;
    function Pause: HRESULT; stdcall;
    function Stop: HRESULT; stdcall;
    function GetState(msTimeout: Longint; out pfs: TFilterState): HRESULT; stdcall;
    function RenderFile(strFilename: WideString): HRESULT; stdcall;
    function AddSourceFilter(strFilename: WideString; out ppUnk: IDispatch): HRESULT; stdcall;
    function get_FilterCollection(out ppUnk: IDispatch): HRESULT; stdcall;
    function get_RegFilterCollection(out ppUnk: IDispatch): HRESULT; stdcall;
    function StopWhenReady: HRESULT; stdcall;
  end;

  IBasicAudio = interface(IDispatch)
    ['{56A868B3-0AD4-11CE-B03A-0020AF0BA770}']
    function put_Volume(lVolume: Longint): HRESULT; stdcall;
    function get_Volume(out plVolume: Longint): HRESULT; stdcall;
    function put_Balance(lBalance: Longint): HRESULT; stdcall;
    function get_Balance(out plBalance: Longint): HRESULT; stdcall;
  end;

  IVideoWindow = interface(IDispatch)
    ['{56A868B4-0AD4-11CE-B03A-0020AF0BA770}']
    function put_Caption(strCaption: WideString): HRESULT; stdcall;
    function get_Caption(out strCaption: WideString): HRESULT; stdcall;
    function put_WindowStyle(WindowStyle: Longint): HRESULT; stdcall;
    function get_WindowStyle(out WindowStyle: Longint): HRESULT; stdcall;
    function put_WindowStyleEx(WindowStyleEx: Longint): HRESULT; stdcall;
    function get_WindowStyleEx(out WindowStyleEx: Longint): HRESULT; stdcall;
    function put_AutoShow(AutoShow: LongBool): HRESULT; stdcall;
    function get_AutoShow(out AutoShow: LongBool): HRESULT; stdcall;
    function put_WindowState(WindowState: Longint): HRESULT; stdcall;
    function get_WindowState(out WindowState: Longint): HRESULT; stdcall;
    function put_BackgroundPalette(BackgroundPalette: Longint): HRESULT; stdcall;
    function get_BackgroundPalette(out pBackgroundPalette: Longint): HRESULT; stdcall;
    function put_Visible(Visible: LongBool): HRESULT; stdcall;
    function get_Visible(out pVisible: LongBool): HRESULT; stdcall;
    function put_Left(Left: Longint): HRESULT; stdcall;
    function get_Left(out pLeft: Longint): HRESULT; stdcall;
    function put_Width(Width: Longint): HRESULT; stdcall;
    function get_Width(out pWidth: Longint): HRESULT; stdcall;
    function put_Top(Top: Longint): HRESULT; stdcall;
    function get_Top(out pTop: Longint): HRESULT; stdcall;
    function put_Height(Height: Longint): HRESULT; stdcall;
    function get_Height(out pHeight: Longint): HRESULT; stdcall;
    function put_Owner(Owner: OAHWND): HRESULT; stdcall;
    function get_Owner(out Owner: OAHWND): HRESULT; stdcall;
    function put_MessageDrain(Drain: OAHWND): HRESULT; stdcall;
    function get_MessageDrain(out Drain: OAHWND): HRESULT; stdcall;
    function get_BorderColor(out Color: Longint): HRESULT; stdcall;
    function put_BorderColor(Color: Longint): HRESULT; stdcall;
    function get_FullScreenMode(out FullScreenMode: LongBool): HRESULT; stdcall;
    function put_FullScreenMode(FullScreenMode: LongBool): HRESULT; stdcall;
    function SetWindowForeground(Focus: Longint): HRESULT; stdcall;
    function NotifyOwnerMessage(hwnd: OAHWND; uMsg: Longint; wParam: LONG_PTR;
      lParam: LONG_PTR): HRESULT; stdcall;
    function SetWindowPosition(Left, Top, Width, Height: Longint): HRESULT; stdcall;
    function GetWindowPosition(out pLeft, pTop, pWidth, pHeight: Longint): HRESULT; stdcall;
    function GetMinIdealImageSize(out pWidth, pHeight: Longint): HRESULT; stdcall;
    function GetMaxIdealImageSize(out pWidth, pHeight: Longint): HRESULT; stdcall;
    function GetRestorePosition(out pLeft, pTop, pWidth, pHeight: Longint): HRESULT; stdcall;
    function HideCursor(HideCursor: LongBool): HRESULT; stdcall;
    function IsCursorHidden(out CursorHidden: LongBool): HRESULT; stdcall;
  end;

  IBasicVideo = interface(IDispatch)
    ['{56A868B5-0AD4-11CE-B03A-0020AF0BA770}']
    function get_AvgTimePerFrame(out pAvgTimePerFrame: TRefTime): HRESULT; stdcall;
    function get_BitRate(out pBitRate: Longint): HRESULT; stdcall;
    function get_BitErrorRate(out pBitErrorRate: Longint): HRESULT; stdcall;
    function get_VideoWidth(out pVideoWidth: Longint): HRESULT; stdcall;
    function get_VideoHeight(out pVideoHeight: Longint): HRESULT; stdcall;
    function put_SourceLeft(SourceLeft: Longint): HRESULT; stdcall;
    function get_SourceLeft(out pSourceLeft: Longint): HRESULT; stdcall;
    function put_SourceWidth(SourceWidth: Longint): HRESULT; stdcall;
    function get_SourceWidth(out pSourceWidth: Longint): HRESULT; stdcall;
    function put_SourceTop(SourceTop: Longint): HRESULT; stdcall;
    function get_SourceTop(out pSourceTop: Longint): HRESULT; stdcall;
    function put_SourceHeight(SourceHeight: Longint): HRESULT; stdcall;
    function get_SourceHeight(out pSourceHeight: Longint): HRESULT; stdcall;
    function put_DestinationLeft(DestinationLeft: Longint): HRESULT; stdcall;
    function get_DestinationLeft(out pDestinationLeft: Longint): HRESULT; stdcall;
    function put_DestinationWidth(DestinationWidth: Longint): HRESULT; stdcall;
    function get_DestinationWidth(out pDestinationWidth: Longint): HRESULT; stdcall;
    function put_DestinationTop(DestinationTop: Longint): HRESULT; stdcall;
    function get_DestinationTop(out pDestinationTop: Longint): HRESULT; stdcall;
    function put_DestinationHeight(DestinationHeight: Longint): HRESULT; stdcall;
    function get_DestinationHeight(out pDestinationHeight: Longint): HRESULT; stdcall;
    function SetSourcePosition(Left, Top, Width, Height: Longint): HRESULT; stdcall;
    function GetSourcePosition(out pLeft, pTop, pWidth, pHeight: Longint): HRESULT; stdcall;
    function SetDefaultSourcePosition: HRESULT; stdcall;
    function SetDestinationPosition(Left, Top, Width, Height: Longint): HRESULT; stdcall;
    function GetDestinationPosition(out pLeft, pTop, pWidth, pHeight: Longint): HRESULT; stdcall;
    function SetDefaultDestinationPosition: HRESULT; stdcall;
    function GetVideoSize(out pWidth, pHeight: Longint): HRESULT; stdcall;
    function GetVideoPaletteEntries(StartIndex, Entries: Longint; out pRetrieved: Longint;
      out pPalette: Longint): HRESULT; stdcall;
    function GetCurrentImage(var BufferSize: Longint; var pDIBImage): HRESULT; stdcall;
    function IsUsingDefaultSource: HRESULT; stdcall;
    function IsUsingDefaultDestination: HRESULT; stdcall;
  end;

  IMediaDet = interface(IUnknown)
    ['{65BD0710-24D2-4FF7-9324-ED2E5D3ABAFA}']
    function get_Filter(out pVal: IUnknown): HRESULT; stdcall;
    function put_Filter(newVal: IUnknown): HRESULT; stdcall;
    function get_OutputStreams(out pVal: Longint): HRESULT; stdcall;
    function get_CurrentStream(out pVal: Longint): HRESULT; stdcall;
    function put_CurrentStream(newVal: Longint): HRESULT; stdcall;
    function get_StreamType(out pVal: TGUID): HRESULT; stdcall;
    function get_StreamTypeB(out pVal: WideString): HRESULT; stdcall;
    function get_StreamLength(out pVal: Double): HRESULT; stdcall;
    function get_Filename(out pVal: WideString): HRESULT; stdcall;
    function put_Filename(newVal: WideString): HRESULT; stdcall;
    function GetBitmapBits(StreamTime: Double; pBufferSize: PLongint; pBuffer: PAnsiChar;
      Width, Height: Longint): HRESULT; stdcall;
    function WriteBitmapBits(StreamTime: Double; Width, Height: Longint;
      Filename: WideString): HRESULT; stdcall;
    function get_StreamMediaType(out pVal: TAMMediaType): HRESULT; stdcall;
    function GetSampleGrabber(out ppVal: IUnknown): HRESULT; stdcall;
    function get_FrameRate(out pVal: Double): HRESULT; stdcall;
    function EnterBitmapGrabMode(SeekTime: Double): HRESULT; stdcall;
  end;

  IMultiMediaStream = interface(IUnknown)
    ['{B502D1BC-9A57-11D0-8FDE-00C04FD9189D}']
    function GetInformation(pdwFlags: PDWORD; pStreamType: Pointer): HRESULT; stdcall;
    function GetMediaStream(const idPurpose: TMSPID; out ppMediaStream: IMediaStream): HRESULT; stdcall;
    function EnumMediaStreams(Index: Longint; out ppMediaStream: IMediaStream): HRESULT; stdcall;
    function GetState(out pCurrentState: TStreamState): HRESULT; stdcall;
    function SetState(NewState: TStreamState): HRESULT; stdcall;
    function GetTime(out pCurrentTime: TStreamTime): HRESULT; stdcall;
    function GetDuration(out pDuration: TStreamTime): HRESULT; stdcall;
    function Seek(SeekTime: TStreamTime): HRESULT; stdcall;
    function GetEndOfStreamEventHandle(out phEOS: THandle): HRESULT; stdcall;
  end;

  IAMMultiMediaStream = interface(IMultiMediaStream)
    ['{BEBE595C-9A6F-11D0-8FDE-00C04FD9189D}']
    function Initialize(StreamType: TStreamType; dwFlags: DWORD; pFilterGraph: IGraphBuilder): HRESULT; stdcall;
    function GetFilterGraph(out ppGraphBuilder: IGraphBuilder): HRESULT; stdcall;
    function GetFilter(out ppFilter: IUnknown): HRESULT; stdcall;
    { ppNewStream may be IMediaStream(nil^) }
    function AddMediaStream(pStreamObject: IUnknown; PurposeId: PMSPID; dwFlags: DWORD;
      var ppNewStream): HRESULT; stdcall;
    function OpenFile(pszFileName: PWideChar; dwFlags: DWORD): HRESULT; stdcall;
    function OpenMoniker(pCtx: IBindCtx; pMoniker: IMoniker; dwFlags: DWORD): HRESULT; stdcall;
    function Render(dwFlags: DWORD): HRESULT; stdcall;
  end;

  IMediaStream = interface(IUnknown)
    ['{B502D1BD-9A57-11D0-8FDE-00C04FD9189D}']
    function GetMultiMediaStream(out ppMultiMediaStream: IMultiMediaStream): HRESULT; stdcall;
    function GetInformation(pPurposeId: PMSPID; pType: Pointer): HRESULT; stdcall;
    function SetSameFormat(pStreamThatHasDesiredFormat: IMediaStream; dwFlags: DWORD): HRESULT; stdcall;
    function AllocateSample(dwFlags: DWORD; out ppSample: IUnknown): HRESULT; stdcall;
    function CreateSharedSample(pExistingSample: IUnknown; dwFlags: DWORD;
      out ppNewSample: IUnknown): HRESULT; stdcall;
    function SendEndOfStream(dwFlags: DWORD): HRESULT; stdcall;
  end;

  IDirectDrawMediaStream = interface(IMediaStream)
    ['{F4104FCE-9A70-11D0-8FDE-00C04FD9189D}']
    { all four may be passed as Type(nil^) }
    function GetFormat(var pDDSDCurrent; var ppDirectDrawPalette; var pDDSDDesired;
      var pdwFlags): HRESULT; stdcall;
    function SetFormat(const pDDSurfaceDesc: TDDSurfaceDesc; pDirectDrawPalette: IDirectDrawPalette): HRESULT; stdcall;
    function GetDirectDraw(out ppDirectDraw: IDirectDraw): HRESULT; stdcall;
    function SetDirectDraw(pDirectDraw: IDirectDraw): HRESULT; stdcall;
    function CreateSample(pSurface: IDirectDrawSurface; pRect: PRect; dwFlags: DWORD;
      out ppSample: IUnknown): HRESULT; stdcall;
    function GetTimePerFrame(out pFrameTime: TStreamTime): HRESULT; stdcall;
  end;

const
  IID_IPin: TGUID = '{56A86891-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IEnumPins: TGUID = '{56A86892-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMediaFilter: TGUID = '{56A86899-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IBaseFilter: TGUID = '{56A86895-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IFilterGraph: TGUID = '{56A8689F-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IGraphBuilder: TGUID = '{56A868A9-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IFileSourceFilter: TGUID = '{56A868A6-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMediaSeeking: TGUID = '{36B73880-C2C8-11CF-8B46-00805F6CEF60}';
  IID_IMediaControl: TGUID = '{56A868B1-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IBasicAudio: TGUID = '{56A868B3-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IVideoWindow: TGUID = '{56A868B4-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IBasicVideo: TGUID = '{56A868B5-0AD4-11CE-B03A-0020AF0BA770}';
  IID_IMediaDet: TGUID = '{65BD0710-24D2-4FF7-9324-ED2E5D3ABAFA}';
  IID_IMultiMediaStream: TGUID = '{B502D1BC-9A57-11D0-8FDE-00C04FD9189D}';
  IID_IAMMultiMediaStream: TGUID = '{BEBE595C-9A6F-11D0-8FDE-00C04FD9189D}';
  IID_IMediaStream: TGUID = '{B502D1BD-9A57-11D0-8FDE-00C04FD9189D}';
  IID_IDirectDrawMediaStream: TGUID = '{F4104FCE-9A70-11D0-8FDE-00C04FD9189D}';
  IID_IMixerPinConfig2: TGUID = '{EBF47182-8764-11D1-9E69-00C04FD7C15B}';

  CLSID_FilterGraph: TGUID = '{E436EBB3-524F-11CE-9F53-0020AF0BA770}';
  CLSID_MediaDet: TGUID = '{65BD0711-24D2-4FF7-9324-ED2E5D3ABAFA}';
  CLSID_AMMultiMediaStream: TGUID = '{49C47CE5-9BA4-11D0-8212-00C04FC32C45}';
  CLSID_MPEG1Splitter: TGUID = '{336475D0-942A-11CE-A870-00AA002FEAB5}';
  CLSID_CMpegAudioCodec: TGUID = '{4A2286E0-7BEF-11CE-9BD9-0000E202599C}';

  MEDIATYPE_Audio: TGUID = '{73647561-0000-0010-8000-00AA00389B71}';
  MEDIATYPE_Video: TGUID = '{73646976-0000-0010-8000-00AA00389B71}';
  MEDIASUBTYPE_MPEG1AudioPayload: TGUID = '{00000050-0000-0010-8000-00AA00389B71}';

  TIME_FORMAT_NONE: TGUID = '{00000000-0000-0000-0000-000000000000}';
  TIME_FORMAT_FRAME: TGUID = '{7B785570-8C82-11CF-BC0C-00AA00AC74F6}';
  TIME_FORMAT_BYTE: TGUID = '{7B785571-8C82-11CF-BC0C-00AA00AC74F6}';
  TIME_FORMAT_SAMPLE: TGUID = '{7B785572-8C82-11CF-BC0C-00AA00AC74F6}';
  TIME_FORMAT_FIELD: TGUID = '{7B785573-8C82-11CF-BC0C-00AA00AC74F6}';
  TIME_FORMAT_MEDIA_TIME: TGUID = '{7B785574-8C82-11CF-BC0C-00AA00AC74F6}';

  MSPID_PrimaryVideo: TGUID = '{A35FF56A-9FDA-11D0-8FDF-00C04FD9189D}';
  MSPID_PrimaryAudio: TGUID = '{A35FF56B-9FDA-11D0-8FDF-00C04FD9189D}';

  { IAMMultiMediaStream flags }
  AMMSF_NOGRAPHTHREAD = $1;
  AMMSF_ADDDEFAULTRENDERER = $1;
  AMMSF_CREATEPEER = $2;
  AMMSF_STOPIFNOSAMPLES = $4;
  AMMSF_NOSTALL = $8;
  AMMSF_RENDERTYPEMASK = $3;
  AMMSF_RENDERTOEXISTING = 0;
  AMMSF_RENDERALLSTREAMS = $1;
  AMMSF_NORENDER = $2;
  AMMSF_NOCLOCK = $4;
  AMMSF_RUN = $8;

  { IMediaSeeking }
  AM_SEEKING_NoPositioning = 0;
  AM_SEEKING_AbsolutePositioning = $1;
  AM_SEEKING_RelativePositioning = $2;
  AM_SEEKING_IncrementalPositioning = $3;
  AM_SEEKING_PositioningBitsMask = $3;
  AM_SEEKING_SeekToKeyFrame = $4;
  AM_SEEKING_ReturnTime = $8;
  AM_SEEKING_Segment = $10;
  AM_SEEKING_NoFlush = $20;

  { event codes }
  EC_COMPLETE = $01;
  EC_USERABORT = $02;
  EC_ERRORABORT = $03;

  VFW_E_NOT_FOUND = HRESULT($80040216);

implementation

end.
