{ Free Pascal backend for Ares' ZLib.pas.

  The Delphi build links Borland-compiled zlib .obj files (32 bit OMF), which
  cannot be linked into a Free Pascal / Win64 program. Here the low-level zlib
  entry points are implemented on top of FPC's paszlib (a Pascal port of
  zlib, producing the identical zlib/deflate formats). Each TZStreamRec owns a
  paszlib stream (kept in TZStreamRec.state); the public fields are copied in
  and out around every call. }

type
  PPasZStream = ^paszlib.TZStream;

procedure ZRecToPas(var strm: TZStreamRec; P: PPasZStream);
begin
  P^.next_in := PByte(strm.next_in);
  P^.avail_in := strm.avail_in;
  P^.next_out := PByte(strm.next_out);
  P^.avail_out := strm.avail_out;
end;

procedure ZPasToRec(var strm: TZStreamRec; P: PPasZStream);
begin
  strm.next_in := PChar(P^.next_in);
  strm.avail_in := P^.avail_in;
  strm.total_in := P^.total_in;
  strm.next_out := PChar(P^.next_out);
  strm.avail_out := P^.avail_out;
  strm.total_out := P^.total_out;
  strm.data_type := P^.data_type;
  strm.adler := P^.adler;
end;

function ZNewPas(var strm: TZStreamRec): PPasZStream;
begin
  New(Result);
  FillChar(Result^, SizeOf(Result^), 0);
  ZRecToPas(strm, Result);
end;

function ZFinishInit(var strm: TZStreamRec; P: PPasZStream; Res: Integer): Integer;
begin
  Result := Res;
  if Res < 0 then
  begin
    Dispose(P);
    strm.state := nil;
  end
  else
  begin
    strm.state := P;
    ZPasToRec(strm, P);
  end;
end;

function deflateInit_(var strm: TZStreamRec; level: Integer; version: PChar; recsize: Integer): Integer;
var
  P: PPasZStream;
begin
  P := ZNewPas(strm);
  Result := ZFinishInit(strm, P, paszlib.deflateInit_(P^, level, version, SizeOf(P^)));
end;

function DeflateInit2_(var strm: TZStreamRec; level: integer; method: integer; windowBits: integer;
  memLevel: integer; strategy: integer; version: PChar; recsize: integer): integer;
var
  P: PPasZStream;
begin
  P := ZNewPas(strm);
  Result := ZFinishInit(strm, P, paszlib.deflateInit2_(P^, level, method, windowBits, memLevel,
    strategy, version, SizeOf(P^)));
end;

function deflate(var strm: TZStreamRec; flush: Integer): Integer;
var
  P: PPasZStream;
begin
  P := strm.state;
  if P = nil then
    Exit(Z_STREAM_ERROR);
  ZRecToPas(strm, P);
  Result := paszlib.deflate(P^, flush);
  ZPasToRec(strm, P);
end;

function deflateEnd(var strm: TZStreamRec): Integer;
var
  P: PPasZStream;
begin
  P := strm.state;
  if P = nil then
    Exit(Z_STREAM_ERROR);
  Result := paszlib.deflateEnd(P^);
  Dispose(P);
  strm.state := nil;
end;

function inflateInit_(var strm: TZStreamRec; version: PChar; recsize: Integer): Integer;
var
  P: PPasZStream;
begin
  P := ZNewPas(strm);
  Result := ZFinishInit(strm, P, paszlib.inflateInit_(P^, version, SizeOf(P^)));
end;

function inflateInit2_(var strm: TZStreamRec; windowBits: integer; version: PChar; recsize: integer): integer;
var
  P: PPasZStream;
begin
  P := ZNewPas(strm);
  Result := ZFinishInit(strm, P, paszlib.inflateInit2_(P^, windowBits, version, SizeOf(P^)));
end;

function inflate(var strm: TZStreamRec; flush: Integer): Integer;
var
  P: PPasZStream;
begin
  P := strm.state;
  if P = nil then
    Exit(Z_STREAM_ERROR);
  ZRecToPas(strm, P);
  Result := paszlib.inflate(P^, flush);
  ZPasToRec(strm, P);
end;

function inflateEnd(var strm: TZStreamRec): Integer;
var
  P: PPasZStream;
begin
  P := strm.state;
  if P = nil then
    Exit(Z_STREAM_ERROR);
  Result := paszlib.inflateEnd(P^);
  Dispose(P);
  strm.state := nil;
end;

function inflateReset(var strm: TZStreamRec): Integer;
var
  P: PPasZStream;
begin
  P := strm.state;
  if P = nil then
    Exit(Z_STREAM_ERROR);
  Result := paszlib.inflateReset(P^);
  ZPasToRec(strm, P);
end;

function adler32(adler: LongInt; const buf: PChar; len: Integer): LongInt;
begin
  Result := LongInt(paszlib.adler32(Cardinal(adler), buf, len));
end;
