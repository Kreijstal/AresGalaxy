{ Minimal replacement for the DSPack component library used by Ares.

  Ares drives DirectShow mostly through raw COM interfaces (see
  DirectShow9.pas); from DSPack it only needs TGraphState and a small
  TFilterGraph used to measure the duration of a media file. This unit
  implements just that on top of the DirectShow filter graph manager. }
unit DSPack;

{$mode delphi}

interface

uses
  Windows, SysUtils, Classes, ActiveX, ComObj, DirectShow9;

type
  TGraphState = (gsUninitialized, gsStopped, gsPaused, gsPlaying);

  TFilterGraph = class(TComponent)
  private
    FGraph: IGraphBuilder;
    function GetActive: Boolean;
    procedure SetActive(Value: Boolean);
    function GetDuration: Integer;
  public
    destructor Destroy; override;
    procedure ClearGraph;
    function RenderFile(const FileName: WideString): HRESULT;
    property Active: Boolean read GetActive write SetActive;
    { duration of the rendered media in milliseconds }
    property Duration: Integer read GetDuration;
  end;

implementation

destructor TFilterGraph.Destroy;
begin
  Active := False;
  inherited Destroy;
end;

function TFilterGraph.GetActive: Boolean;
begin
  Result := FGraph <> nil;
end;

procedure TFilterGraph.SetActive(Value: Boolean);
begin
  if Value = Active then
    Exit;
  if Value then
    OleCheck(CoCreateInstance(CLSID_FilterGraph, nil, CLSCTX_INPROC_SERVER, IID_IGraphBuilder, FGraph))
  else
  begin
    ClearGraph;
    FGraph := nil;
  end;
end;

procedure TFilterGraph.ClearGraph;
var
  Control: IMediaControl;
begin
  if (FGraph <> nil) and Succeeded(FGraph.QueryInterface(IID_IMediaControl, Control)) then
    Control.Stop;
end;

function TFilterGraph.RenderFile(const FileName: WideString): HRESULT;
begin
  if FGraph = nil then
    Active := True;
  Result := FGraph.RenderFile(PWideChar(FileName), nil);
  OleCheck(Result);
end;

function TFilterGraph.GetDuration: Integer;
var
  Seeking: IMediaSeeking;
  D: Int64;
begin
  Result := 0;
  if (FGraph <> nil) and Succeeded(FGraph.QueryInterface(IID_IMediaSeeking, Seeking)) then
    if Succeeded(Seeking.GetDuration(D)) then
      Result := D div 10000; // 100ns units -> ms
end;

end.
