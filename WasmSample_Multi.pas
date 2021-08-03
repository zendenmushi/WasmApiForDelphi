unit WasmSample_Multi;

interface
uses
  System.SysUtils
  , Wasm
{$ifndef USE_WASMER}
  , Wasmtime
{$else}
  , Wasmer
{$ifend}
  ;

function MultiSample() : Boolean;


implementation


// A function to be called from Wasm code.
function  callback(const args : PWasmValVec; results : PWasmValVec) : PWasmTrap; cdecl;
begin
  writeln('Calling back...');
  write('> ');
  writeln( Format('> %u %u %u %u', [
    args.Items[0].i32, args.Items[1].i64,
    args.Items[2].i64, args.Items[3].i32]));
  writeln('');

  TWasm.val_copy(results.Items.Pointers[0], args.Items.Pointers[3]);
  TWasm.val_copy(results.Items.Pointers[1], args.Items.Pointers[1]);
  TWasm.val_copy(results.Items.Pointers[2], args.Items.Pointers[2]);
  TWasm.val_copy(results.Items.Pointers[3], args.Items.Pointers[0]);
  result := nil;
end;


// A function closure.
function closure_callback(env : Pointer; const args : PWasmValVec; results :  PWasmValVec) : PWasmTrap; cdecl;
begin
  var i := PInteger(env)^;
  writeln('Calling back closure...');
  writeln('>'+IntToStr(i));

  var d := Default(TWasmVal);
  d.kind := WASM_I32;
  d.i32 := i;
  results.Items[0] := d;
  result := nil;
end;


function MultiSample() : Boolean;
begin
  // Initialize.
  writeln('Initializing...');

{$ifdef USE_WASMER}
  var features := TWasmerFeatures.New();
  (+features).MultiValue(true); // Probably true by default, but test for wasmer_features_xxx

  var config := TWasmConfig.New();
  (+config).SetFeatures(features);

  var engine := TWasmEngine.NewWithConfig(config);
{$else}
  var engine := TWasmEngine.New();
{$endif}
  var store := TWasmStore.New(+engine);

  // Load binary.
  writeln('Loading binary...');
  var binary := TWasmByteVec.NewEmpty;
{$ifdef USE_WASMFILE}
  binary.Unwrap.LoadFromFile('multi.wasm');
{$else}
  var wat :=
    '(module'+
    '  (func $f (import "" "f") (param i32 i64 i64 i32) (result i32 i64 i64 i32))'+
    ''+
    '  (func $g (export "g") (param i32 i64 i64 i32) (result i32 i64 i64 i32)'+
    '    (call $f (local.get 0) (local.get 2) (local.get 1) (local.get 3))'+
    '  )'+
    ')';
  binary.Unwrap.Wat2Wasm(wat);
{$ifend}

  // Compile.
  writeln('Compiling module...');
  var module := TWasmModule.New(+store, +binary);
  if module.IsNone then
  begin
    writeln('> Error compiling module!');
    exit(false)
  end;

  // Create external print functions.
  writeln('Creating callback...');
  var callback_func := TWasmFunc.New(+store, +TWasmFunctype.New([WASM_I32, WASM_I64, WASM_I64, WASM_I32], [WASM_I32, WASM_I64, WASM_I64, WASM_I32]), callback);

  // Instantiate.
  writeln('Instantiating module...');
  var imports := TWasmExternVec.Create([ (+callback_func).AsExtern ]);
  var instance := TWasmInstance.New(+store, +module, @imports);
  if instance.IsNone then
  begin
    writeln('> Error instantiating module!');
    exit(false);
  end;

  // Extract export.
  writeln('Extracting export...');
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
  writeln('Calling export...');
  var vals := [
    WASM_I32_VAL(1), WASM_I64_VAL(2), WASM_I64_VAL(3), WASM_I32_VAL(4)
  ];
  var res := [
    WASM_INIT_VAL, WASM_INIT_VAL, WASM_INIT_VAL, WASM_INIT_VAL
  ];
  var args := TWasmValVec.Create(vals);
  var results := TWasmValVec.Create(res);
  if run_func.Call( @args, @results).IsError then
  begin
    writeln('> Error calling function!');
    exit(false);
  end;

  // Print result.
  writeln('Printing result...');
  writeln( Format('> %u %u %u %u', [
    res[0].i32, res[1].i64, res[2].i64, res[3].i32]));

  assert(res[0].i32 = 4);
  assert(res[1].i64 = 3);
  assert(res[2].i64 = 2);
  assert(res[3].i32 = 1);

  // Shut down.
  writeln('Shutting down...');

  // All done.
  writeln('Done.');
  result := true;
end;

end.
