unit WasmSample_Threads;

interface
uses
  System.Classes, System.SysUtils
  , Wasm
{$ifndef USE_WASMER}
  , Wasmtime
{$else}
  , Wasmer
{$ifend}
  ;

function ThreadsSample() : Boolean;

implementation

const N_THREADS = 10;
const N_REPS = 3;

// A function to be called from Wasm code.
function callback(const args : PWasmValVec; results : PWasmValVec) : PWasmTrap; cdecl;
begin
  assert(args.Items[0].kind = WASM_I32);
  writeln('> Thread '+IntToStr(args.Items[0].i32)+' running');
  result := nil;
end;

type TThreadArgs = record
  engine : TOwnEngine;
  module : TOwnSharedModule;
  id : Integer;
end;
PThreadArgs = ^TThreadArgs;

function run(const args : TThreadArgs) : Boolean;
begin

  // Rereate store and module.
  var store := TWasmStore.New(+args.engine);
  var module := (+args.module).Obtain(+store);

  // Run the example N times.
  for var i := 0  to N_REPS-1 do
  begin
    Sleep(100);


    // Create imports.
    var func := TWasmFunc.New(+store, +TWasmFunctype.New([WASM_I32],[]), callback);

    var val := WASM_I32_VAL(args.id);
    var global_type := TWasmGlobaltype.New(TWasm.valtype_new_i32(), WASM_CONST);
    var global := TWasmGlobal.New(+store, +global_type, @val);

    // Instantiate.
    var externs := [ (+func).AsExtern, (+global).AsExtern ];
    var instance := TWasmInstance.New(+store, +module, externs, nil);
    if instance.IsNone then
    begin
      writeln('> Error instantiating module!');
      exit(false);
    end;

    // Extract export.
    var export_s := (+instance).GetExports;
    if export_s.Unwrap.size = 0 then
    begin
      writeln('> Error accessing exports!');
      exit(false);
    end;
    var run_func := export_s.Unwrap.Items[0].AsFunc;
    if run_func = nil then
    begin
      writeln('> Error accessing export!');
      exit(false);
    end;

    // Call.
    var empty := Default(TWasmValVec);
    if run_func.Call(@empty, @empty).IsError then
    begin
      writeln('> Error calling function!!');
      exit(false);
    end;

  end;

  result := true;
end;

function ThreadsSample() : Boolean;
  function makeProc(arg : TThreadArgs) : TProc;
  begin
    result := procedure
    begin
      run(arg);
    end;
  end;
begin
  // Initialize.
  writeln('Initializing...');
  var engine := TWasmEngine.New();
  var store := TWasmStore.New(+engine);

  // Load binary.
  writeln('Loading binary...');
  var binary := TWasmByteVec.NewEmpty;
{$ifdef USE_WASMFILE}
  if not (+binary).LoadFromFile('threads.wasm') then
  begin
    writeln('> Error loading module!');
    exit(false);
  end;
{$else}
  var wat : AnsiString :=
    '(module'+
    '  (func $message (import "" "hello") (param i32))'+
    '  (global $id (import "" "id") i32)'+
    '  (func (export "run") (call $message (global.get $id)))'+
    ')';
  (+binary).Wat2Wasm(wat);
{$ifend}

  // Compile.
  writeln('Compiling module...');
  var module := TWasmModule.New(+store, +binary);
  if module.IsNone then
  begin
    writeln('> Error compiling module!');
    exit(false);
  end;

  var shared := module.Unwrap.Share();

  // Spawn threads.
  var threads : TArray<TThread>;
  SetLength(threads, N_THREADS);

  for var i := 0 to N_THREADS-1 do
  begin
    writeln('Initializing thread '+IntToStr(i)+'...');
    var arg := Default(TThreadArgs);
    arg.id := i;
    arg.engine := engine;
    arg.module := shared;

    threads[i] := TThread.CreateAnonymousThread(makeProc(arg));
    threads[i].FreeOnTerminate := false;
    threads[i].Start;
  end;

  for var i := 0 to N_THREADS-1 do
  begin
    writeln('Waiting for thread: '+IntToStr(i));
    threads[i].WaitFor;
    threads[i].Free;
  end;

  writeln('finished');

  result := true;
end;

end.
