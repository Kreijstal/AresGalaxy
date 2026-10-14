# AresGalaxy
Fork of the [Ares Galaxy project](https://sourceforge.net/projects/aresgalaxy/)

For copyright and license information please see the original project.

## Background of this fork
The original source code is not available in a modern source code repository with revision control. Also it is meant for an old Delphi version. For purpose of training, I decided to fork and modernize this project.

The code here is not meant to be complete or fully working. It's work in progress. Maybe someday it will be complete and fully running, compiled with a recent compiler. But probably not.   


## Building with Free Pascal (Win64)
The sources build as a native 64-bit Windows program with Free Pascal 3.2.2
and the Lazarus LCL (win32/win64 widgetset). From an MSYS2 UCRT64 or CLANG64
shell with FPC and Lazarus installed:

    ./build-fpc.sh        # incremental, produces Ares.exe
    ./build-fpc.sh -B     # rebuild everything

`fpc/` holds the compatibility units used only by this build: thin LCL
replacements for the TntWare Unicode controls, minimal DirectShow/DirectDraw
headers instead of DSPack, VCL helpers (`VCLCompat`), a paszlib backend for
`ZLib.pas` and a stub for the (long gone) Flash ActiveX player. Build with
`-dARES_DEBUG` to log otherwise swallowed exceptions to `%TEMP%\ares_debug.log`.
