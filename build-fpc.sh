#!/usr/bin/env bash
# Build Ares for Win64 with Free Pascal + LCL (Lazarus) from an MSYS2 UCRT64/CLANG64 shell:
#   ./build-fpc.sh            incremental build
#   ./build-fpc.sh -B         rebuild everything
# Override LAZDIR if Lazarus lives elsewhere.
set -e
cd "$(dirname "$0")"
LAZDIR=${LAZDIR:-$MINGW_PREFIX/lib/lazarus}
# fpc is a native Windows program: hand it Windows paths and stop MSYS from
# rewriting its arguments.
command -v cygpath >/dev/null && LAZDIR=$(cygpath -m "$LAZDIR")
export MSYS2_ARG_CONV_EXCL="*"
CPU=${FPC_CPU:-x86_64}
TOS=${FPC_OS:-win64}
T=$CPU-$TOS
mkdir -p lib/$T
exec fpc -Mdelphi -T$TOS -P$CPU -WG -gl -O1 \
  -dLCL -dLCLwin32 \
  -FUlib/$T -FE. -oAres.exe \
  -Fufpc -FuVCLs -FuBitTorrent -FuDHT -Fifpc -FiVCLs \
  -Fu"$LAZDIR/lcl/units/$T" -Fu"$LAZDIR/lcl/units/$T/win32" \
  -Fu"$LAZDIR/components/lazutils/lib/$T" \
  -vewn "$@" ${MAIN:-Ares.DPR}
