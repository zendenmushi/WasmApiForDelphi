unit Wasmer;
// tiny porting

interface
uses
  System.Classes, System.SysUtils,
  Wasm, Ownership
  ;

type
  TWasmerCompiler = (CRANELIFT, LLVM, SINGLEPASS);

  // wrapper & helper

  TWasmByteVecHelper = record helper for TWasmByteVec
    function LoadFromWatFile(fname : string) : Boolean;
    procedure Wat2Wasm(wat : string);
  end;

  TWasmerConfig = record helper for TWasmConfig
    procedure SetCompiler(compiler : TWasmerCompiler);
  end;

  TWasmerWat2Wasm = procedure(const wat : PWasmByteVec; out_ : PWasmByteVec); cdecl;

  TWasmConfigSetCompiler = procedure(config : PWasmConfig; Compiler : TWasmerCompiler); cdecl;

  TWasmer = record
  public class var
    wat2wasm : TWasmerWat2Wasm;
    config_set_compiler : TWasmConfigSetCompiler;
  public
    class procedure Init(dll_name : string); static;
    class procedure InitAPIs(runtime : HMODULE); static;
  end;

implementation
uses
  Windows
  ;

var
  wasmer_runtime : HMODULE;

class procedure TWasmer.Init(dll_name: string);
begin
  wasmer_runtime := LoadLibrary(PWideChar(dll_name));
  InitAPIs(wasmer_runtime);
  TWasm.InitAPIs(wasmer_runtime);
end;

class procedure TWasmer.InitAPIs(runtime : HMODULE);
  function ProcAddress(name : string) : Pointer;
  begin
    result := GetProcAddress(runtime, PWideChar(name));
  end;

begin

  if runtime <> 0 then
  begin
    wat2wasm := ProcAddress('wat2wasm');
    config_set_compiler := ProcAddress('wasm_config_set_compiler');
  end;
end;

{ TWasmByteVecHelper }

function TWasmByteVecHelper.LoadFromWatFile(fname: string): Boolean;
begin
  var stream := TRc.Wrap(TFileStream.Create(fname, fmOpenRead));
  var file_size := (+stream).Size;
  var binary := TWasmByteVec.NewUninitialized(file_size);
  if (+stream).ReadData((+binary).data, file_size) <> file_size then
  begin
    exit(false);
  end;

  TWasmer.wat2wasm(binary.Unwrap, @self);
  result := true;
end;

procedure TWasmByteVecHelper.Wat2Wasm(wat: string);
begin
  var binary := TWasmByteVec.NewFromString(wat);
  TWasmer.wat2wasm(binary.Unwrap, @self);
end;

{ TWasmerConfig }

procedure TWasmerConfig.SetCompiler(compiler: TWasmerCompiler);
begin
  TWasmer.config_set_compiler(@self, compiler);
end;

end.
