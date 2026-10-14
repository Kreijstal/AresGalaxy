{*******************************************************}
{                                                       }
{       Borland Delphi Visual Component Library         }
{                                                       }
{  Copyright (c) 2002 Borland Software Corporation      }
{                                                       }
{*******************************************************}

unit XPMan;
{$WEAKPACKAGEUNIT ON} 
interface

uses
  SysUtils, Classes;

type
  TXPManifest = class(TComponent)
  end;

{$IFDEF FPC}
{$R ../fpc/ares_manifest.rc} // common controls v6 manifest, see fpc/ares.manifest
{$ELSE}
{$R WindowsXP.res}
{$ENDIF}

implementation

end.
 