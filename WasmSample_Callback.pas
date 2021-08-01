unit WasmSample_Callback;

interface
uses
  System.Classes, System.StrUtils, System.SysUtils,
  Wasm, Ownership
{$ifndef USE_WASMER}
  , Wasmtime
{$else}
  , Wasmer
{$ifend}
  ;

function CallbackSample_Clike() : Boolean;
function CallbackSample() : Boolean;

implementation

procedure wasm_val_print(val : TWasmVal);
begin
  case val.kind of
  WASM_I32:
    writeln(IntToStr(val.i32));
  WASM_I64:
    writeln(IntToStr(val.i64));
  WASM_F32:
    writeln(FloatToStr(val.f32));
  WASM_F64:
    writeln(FloatToStr(val.f64));
  WASM_ANYREF, WASM_FUNCREF:
    if val.ref = nil then
      writeln('nil')
    else
      writeln(IntToHex(Int64(val.ref), 16));
  end;
end;

// A function to be called from Wasm code.
function print_callback(const args : PWasmValVec; results : PWasmValVec) : PWasmTrap; cdecl;
begin
  write('Calling back...'#10'> ');
  wasm_val_print(args.data^);
  writeln('');

  TWasm.val_copy(results.data, args.data);
  result := nil;
end;

// A function closure.
function closure_callback(env : Pointer; const args : PWasmValVec; results : PWasmValVec) : PWasmTrap; cdecl;
begin
  var i := (PInteger(env))^;
  writeln('Calling back closure...');
  writeln('> '+IntToStr(i));

  results.data.kind := WASM_I32;
  results.data.i32 := Integer(i);
  result := nil;
end;

function CallbackSample_Clike() : Boolean;
begin
  // Initialize.
  writeln('Initializing...');
  var engine := TWasm.engine_new();
  var store := TWasm.store_new(engine);


  // Load binary.
  writeln('Loading binary...');
  var binary : TWasmByteVec;
{$ifdef USE_WASMFILE}
  var stream := TFileStream.Create('callback.wasm', fmOpenRead);
  try
    var file_size := stream.Size;
    TWasm.byte_vec_new_uninitialized(@binary, file_size);
    if stream.ReadData(binary.data, file_size) <> file_size then
    begin
      writeln('> Error loading module!');
      exit(false);
    end;
  finally
    stream.Free;
  end;
{$else}
    var wat :=
      '(module'+
      '  (func $print (import "" "print") (param i32) (result i32))'+
      '  (func $closure (import "" "closure") (result i32))'+
      '  (func (export "run") (param $x i32) (param $y i32) (result i32)'+
      '    (i32.add'+
      '      (call $print (i32.add (local.get $x) (local.get $y)))'+
      '      (call $closure)'+
      '    )'+
      '  )'+
      ')';
    binary.Wat2Wasm(wat);
{$ifend}

  // Compile.
  writeln('Compiling module...');
  var module := TWasm.module_new(store, @binary);
  if module = nil then
  begin
    writeln('> Error compiling module!');
    exit(false);
  end;

  TWasm.byte_vec_delete(@binary);

  // Create external print functions.
  writeln('Creating callback...');
  var print_type := TWasm.functype_new_1_1(TWasm.valtype_new_i32(), TWasm.valtype_new_i32());
  var print_func := TWasm.func_new(store, print_type, print_callback);

  var i := 42;
  var closure_type := TWasm.functype_new_0_1(TWasm.valtype_new_i32());
  var closure_func := TWasm.func_new_with_env(store, closure_type, closure_callback, @i, nil);

  TWasm.functype_delete(print_type);
  TWasm.functype_delete(closure_type);

  // Instantiate.
  Writeln('Instantiating module...');

  var externs : TArray<PWasmExtern> := [
    TWasm.func_as_extern(print_func), TWasm.func_as_extern(closure_func)
  ];
  var imports := TWasmExternVec.Create(externs);
  var instance := TWasm.instance_new(store, module, @imports, nil);
  if instance = nil then
  begin
    writeln('> Error instantiating module!');
    exit(false);
  end;

  TWasm.func_delete(print_func);
  TWasm.func_delete(closure_func);

  // Extract export.
  writeln('Extracting export...');
  var exportfns : TWasmExternVec;
  TWasm.instance_exports(instance, @exportfns);
  if exportfns.size = 0 then
  begin
    writeln('> Error accessing exports!');
    exit(false);
  end;

  var run_func := TWasm.extern_as_func(exportfns.data^);
  if run_func = nil then
  begin
    writeln('> Error accessing export!');
    exit(false);
  end;

  TWasm.module_delete(module);
  TWasm.instance_delete(instance);

  // Call.
  writeln('Calling export...');
  var arg := [ WASM_I32_VAL(3), WASM_I32_VAL(4) ];
  var rs := [ WASM_INIT_VAL ];
  var args := TWasmValVec.Create(arg);
  var results := TWasmValVec.Create(rs);
  if TWasm.func_call(run_func, @args, @results) <> nil then
  begin
    writeln('> Error calling function!');
    exit(false);
  end;

  TWasm.extern_vec_delete(@exportfns);

  // Print result.
  writeln('Printing result...');
  writeln('> '+IntToStr(rs[0].i32));

  // Shut down.
  writeln('Shutting down...');
  TWasm.store_delete(store);
  TWasm.engine_delete(engine);

  // All done.
  writeln('Done.');
  exit(true);
end;

function CallbackSample() : Boolean;
begin
  // Initialize.
  writeln('Initializing...');
  var engine := TWasmEngine.New();
  var store := TWasmStore.New(+engine);

  var module : TOwnModule;
  begin
    // Load binary.
    writeln('Loading binary...');
    var binary := TWasmByteVec.NewEmpty;
{$ifdef USE_WASMFILE}
    if not (+binary).LoadFromFile('callback.wasm') then
    begin
      writeln('> Error loading module!');
      exit(false);
    end;
{$else}
    var wat :=
      '(module'+
      '  (func $print (import "" "print") (param i32) (result i32))'+
      '  (func $closure (import "" "closure") (result i32))'+
      '  (func (export "run") (param $x i32) (param $y i32) (result i32)'+
      '    (i32.add'+
      '      (call $print (i32.add (local.get $x) (local.get $y)))'+
      '      (call $closure)'+
      '    )'+
      '  )'+
      ')';
{$ifndef USE_WASMER}
    if (+binary).Wat2Wasm(wat).IsError(
      procedure(e : PWasmtimeError)
      begin
        writeln(e.GetMessage());
      end) then
    begin
      writeln('> Error loading wat!');
      exit(false);
    end;
{$else}
    (+binary).Wat2Wasm(wat);
{$ifend}
{$ifend}

    // Compile.
    writeln('Compiling module...');
    module := TWasmModule.New(+store, +binary);
    if module.IsNone then
    begin
      writeln('> Error compiling module!');
      exit(false);
    end;

  end;


  // Create external print functions.
  writeln('Creating callback...');

  var print_func := TWasmFunc.New(+store, +TWasmFunctype.New([WASM_I32], [WASM_I32]), print_callback);
  var i := 42;
  var closure_func := TWasmFunc.NewWithEnv(+store, +TWasmFunctype.New([], [WASM_I32]), closure_callback, @i, nil);

  // Instantiate.
  Writeln('Instantiating module...');

  var externs := [ (+print_func).AsExtern, (+closure_func).AsExtern ];
  var instance := TWasmInstance.New(+store, +module, externs);
  if instance.IsNone then
  begin
    writeln('> Error instantiating module!');
    exit(false);
  end;

  // Extract export.
  writeln('Extracting export...');
  var exportfns := (+instance).GetExports;
  if (+exportfns).size = 0 then
  begin
    writeln('> Error accessing exports!');
    exit(false);
  end;


  var run_func := (+exportfns).Items[0].AsFunc;
  if run_func = nil then
  begin
    writeln('> Error accessing export!');
    exit(false);
  end;

  // Call.
  writeln('Calling export...');
  var args := TWasmValVec.Create([ 3, 4 ]);
  var results := TWasmValVec.Create([nil]);


  if run_func.Call(@args, @results).IsError then
  begin
    writeln('> Error calling function!');
    exit(false);
  end;

  // Print result.
  writeln('Printing result...');
  writeln('> '+IntToStr(results.Items[0].i32));

  // Shut down.
  writeln('Shutting down...');

  // All done.
  writeln('Done.');
  exit(true);
end;

end.
