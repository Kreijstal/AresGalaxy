{ Free Pascal / LCL replacement for the ShockwaveFlash ActiveX wrapper.

  The Adobe Flash ActiveX control (and the Delphi OleCtrls host it relied on)
  is not available: Windows 10/11 removed Flash and the LCL has no TOleControl.
  This keeps the TShockwaveFlashEx API that Ares' FLV/net players use, but the
  constructor raises EFlashUnavailable, so the existing try/except blocks in
  uflvplayer/unetplayer simply skip Flash playback. }

interface

uses
  Windows, SysUtils, Classes, Controls;

type
  EFlashUnavailable = class(Exception);

  TShockwaveFlashOnFSCommand = procedure(ASender: TObject; const command, args: WideString) of object;

  TShockwaveFlashEx = class(TWinControl)
  private
    FOnFSCommand: TShockwaveFlashOnFSCommand;
    FBackgroundColor: Integer;
    FScale, FSAlign, FAllowFullScreen, FWMode, FMovie: WideString;
    FScaleMode, FQuality: Integer;
    FMenu, FLoop: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateWnd; override;
    procedure LoadMovieFromStream(Src: TStream);
    procedure SetVariable(const name, value: WideString);
    function GetVariable(const name: WideString): WideString;
    procedure Play;
    procedure Stop;
    property BackgroundColor: Integer read FBackgroundColor write FBackgroundColor;
    property Scale: WideString read FScale write FScale;
    property ScaleMode: Integer read FScaleMode write FScaleMode;
    property Quality: Integer read FQuality write FQuality;
    property AllowFullScreen: WideString read FAllowFullScreen write FAllowFullScreen;
    property SAlign: WideString read FSAlign write FSAlign;
    property Menu: Boolean read FMenu write FMenu;
    property Loop: Boolean read FLoop write FLoop;
    property WMode: WideString read FWMode write FWMode;
    property Movie: WideString read FMovie write FMovie;
    property OnFSCommand: TShockwaveFlashOnFSCommand read FOnFSCommand write FOnFSCommand;
  end;

procedure Register;

implementation

constructor TShockwaveFlashEx.Create(AOwner: TComponent);
begin
  raise EFlashUnavailable.Create('Adobe Flash ActiveX is not available in this build');
end;

procedure TShockwaveFlashEx.CreateWnd;
begin
  inherited CreateWnd;
end;

procedure TShockwaveFlashEx.LoadMovieFromStream(Src: TStream);
begin
end;

procedure TShockwaveFlashEx.SetVariable(const name, value: WideString);
begin
end;

function TShockwaveFlashEx.GetVariable(const name: WideString): WideString;
begin
  Result := '';
end;

procedure TShockwaveFlashEx.Play;
begin
end;

procedure TShockwaveFlashEx.Stop;
begin
end;

procedure Register;
begin
end;

end.
