unit WasmtimeSample_Linking;
(*
Example of compiling, instantiating, and linking two WebAssembly modules
together.
*)

interface
uses
  Wasm, Wasmtime, Wasm.Wasi
  ;

function LinkingSample() : Boolean;

implementation

procedure exit_with_error(const msg : string; error : TOwnWasmtimeError; trap : PWasmTrap);
begin
  writeln('error: '+msg);
  var error_message : string;
  if (error.IsError) then
  begin
    error_message := error.Unwrap.GetMessage;
  end else if trap <> nil then
  begin
    error_message := trap.GetMessage();
  end;
  writeln(error_message);
  halt(1);
end;

function LinkingSample() : Boolean;
begin
  var engine := TWasmEngine.New();
  assert(not engine.IsNone);
  var store := TWasmtimeStore.New(+engine, nil, nil);
  assert(not store.IsNone);
  var context := (+store).Context;

  var linking1wasm := TWasmByteVec.NewEmpty;
  var ret := (+linking1wasm).Wat2Wasm(
    '(module'#10+
    '  (import "linking2" "double" (func $double (param i32) (result i32)))'#10+
    '  (import "linking2" "log" (func $log (param i32 i32)))'#10+
    '  (import "linking2" "memory" (memory 1))'#10+
    '  (import "linking2" "memory_offset" (global $offset i32))'#10+
    '  (func (export "run")'#10+
    '    ;; Call into the other module to double our number, and we could print it'#10+
    '    ;; here but for now we just drop it'#10+
    '    i32.const 2'#10+
    '    call $double'#10+
    '    drop'#10+
    '    ;; Our `data` segment initialized our imported memory, so let''s print the'#10+
    '    ;; string there now.'#10+
    '    global.get $offset'#10+
    '    i32.const 14'#10+
    '    call $log'#10+
    '  )'#10+
    '  (data (global.get $offset) "Hello, world!\n")'#10+
    ')'
  );
  if ret.IsError then exit_with_error('Failed to wat2wasm linking1', ret, nil);

  var linking2wasm := TWasmByteVec.NewEmpty;
  ret := (+linking2wasm).Wat2Wasm(
    '(module'#10+
    '  (type $fd_write_ty (func (param i32 i32 i32 i32) (result i32)))'#10+
    '  (import "wasi_snapshot_preview1" "fd_write" (func $fd_write (type $fd_write_ty)))'#10+
    '  (func (export "double") (param i32) (result i32)'#10+
    '    local.get 0'#10+
    '    i32.const 2'#10+
    '    i32.mul'#10+
    '  )'#10+
    '  (func (export "log") (param i32 i32)'#10+
    '    ;; store the pointer in the first iovec field'#10+
    '    i32.const 4'#10+
    '    local.get 0'#10+
    '    i32.store'#10+
    '    ;; store the length in the first iovec field'#10+
    '    i32.const 4'#10+
    '    local.get 1'#10+
    '    i32.store offset=4'#10+
    '    ;; call the `fd_write` import'#10+
    '    i32.const 1     ;; stdout fd'#10+
    '    i32.const 4     ;; iovs start'#10+
    '    i32.const 1     ;; number of iovs'#10+
    '    i32.const 0     ;; where to write nwritten bytes'#10+
    '    call $fd_write'#10+
    '    drop'#10+
    '  )'#10+
    '  (memory (export "memory") 2)'#10+
    '  (global (export "memory_offset") i32 (i32.const 65536))'#10+
    ')'
  );
  if ret.IsError then exit_with_error('Failed to wat2wasm linking2', ret, nil);

  var module := TWasmtimeModule.New(+engine, +linking1wasm);
  if module.IsError then exit_with_error('Failed to compile linking1', module.Error, nil);
  var linking1_module := module.Module;

  module := TWasmtimeModule.New(+engine, +linking2wasm);
  if module.IsError then exit_with_error('Failed to compile linking2', module.Error, nil);
  var linking2_module := module.Module;

  var trap : TOwnTrap;
  // Configure WASI and store it within our `wasmtime_store_t`
  var wasi_config := TWasiConfig.New;
  assert(not wasi_config.IsNone);
  (+wasi_config).InheritArgv();
  (+wasi_config).InheritEnv();
  (+wasi_config).InheritStdin();
  (+wasi_config).InheritStdout();
  (+wasi_config).InheritStderr();
  ret := context.SetWasi(wasi_config);
  if ret.IsError then exit_with_error('Failed to instantiate wasi', ret, nil);

  // Create our linker which will be linking our modules together, and then add
  // our WASI instance to it.
  var linker := TWasmtimeLinker.New(+engine);
  ret := (+linker).DefineWasi;
  if ret.IsError then exit_with_error('Failed to link wasi', ret, nil);

  // Instantiate `linking2` with our linker.
  var linking2 := (+linker).Instantiate(context, +linking2_module);
  if linking2.IsError or linking2.Trap.IsError then exit_with_error('Failed to instantiate linking2', linking2.Error, linking2.Trap.Unwrap);

  // Register our new `linking2` instance with the linker
  ret := (+linker).DefineInstance(context, 'linking2', +linking2.Instance);
  if ret.IsError then exit_with_error('Failed to link linking2', ret, nil);


  // Instantiate `linking1` with the linker now that `linking2` is defined
  var linking1 := (+linker).Instantiate(context, +linking1_module);
  if linking1.IsError or linking1.Trap.IsError then exit_with_error('Failed to instantiate linking1', linking1.Error, linking2.Trap.Unwrap);

  // Lookup our `run` export function
  var run := (+linking1.Instance).GetExport('run');
  assert(not run.IsNone);
  assert((+run).kind = WASMTIME_EXTERN_FUNC);
  ret := (+run).func.Call(nil, 0, nil, 0, trap);
  if ret.IsError or trap.IsError then  exit_with_error('Failed to call run', ret, nil);

  result := true;
end;

end.
