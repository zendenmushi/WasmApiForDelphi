# Wasm api for Delphi

## build
Open .dpoj by Delphi10.4 or later  
(Now Windows x64 only)

## Run
Need WebAssembly runtime. (default=wasmtime, need rebuild=wasmer)  
If you use wasmer, please define USE_WASMER and rebuild it.

wasmer/ https://github.com/wasmerio/wasmer/releases/tag/2.0.0   
wasmtime / https://github.com/bytecodealliance/wasmtime/releases/tag/v0.28.0 

copy wasmer.dll or wasmtime.dll to Bin.

