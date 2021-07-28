unit WasmTest_ShareMemory;

interface
uses
  System.SysUtils
  , Wasm, Wasmtime
  ;


function ShareMemory() : Boolean;

implementation



// A function to be called from Wasm code.
function  callback(const args : PWasmValVec; results : PWasmValVec) : PWasmTrap; cdecl;
begin
  writeln('Calling back...');
  write('> ');
  writeln( Format('> %x %x %x %x', [
    args.Items[0].i32, args.Items[1].i32,
    args.Items[2].i32, args.Items[3].i32]));
  writeln('');

  TWasm.val_copy(results.Items.Pointers[0], args.Items.Pointers[3]);
  TWasm.val_copy(results.Items.Pointers[1], args.Items.Pointers[2]);
  TWasm.val_copy(results.Items.Pointers[2], args.Items.Pointers[1]);
  TWasm.val_copy(results.Items.Pointers[3], args.Items.Pointers[0]);
  result := nil;
end;



function ShareMemory() : Boolean;
begin
  // Initialize.
  writeln('Initializing...');
  var engine := TWasmEngine.New();
  var store := TWasmStore.New(+engine);

  // Load binary.
  writeln('Loading binary (import memory)...');
  var binary := TWasmByteVec.NewEmpty;
  var wat : AnsiString :=

    '(module'+
    '  (memory (import "" "memory") 1)'+
    '  (func $f (import "" "f") (param i32 i32 i32 i32) (result i32 i32 i32 i32))'+
    ''+
    '  (func $g (export "g")  (result i32 i32 i32 i32)'+
    '    (i32.load (i32.const 0x0000))'+
    '    (i32.load (i32.const 0x1004))'+
    '    (i32.load (i32.const 0x1008))'+
    '    (i32.load (i32.const 0x100C))'+
    '    (call $f)'+
    '  )'+
    '  (data (i32.const 0x0) "\55\AA\55\AA")'+
    ')';

  var err := binary.Unwrap.Wat2Wasm(wat);
  if err.IsError then
  begin
    writeln(err.Unwrap.GetMessage);
    exit(false);
  end;

  // Compile.
  writeln('Compiling import memory module...');
  var module := TWasmModule.New(+store, +binary);
  if module.IsNone then
  begin
    writeln('> Error compiling import memory module!');
    exit(false)
  end;

  writeln('Loading binary (export memory)...');
  var wat2 : AnsiString :=
    '(module'+
    '  (memory (export "memory") 1)'+
    ''+
    '  (func (export "size") (result i32) (memory.size))'+
    '  (func (export "load") (param i32) (result i32) (i32.load8_s (local.get 0)))'+
    '  (func (export "store") (param i32 i32)'+
    '    (i32.store8 (local.get 0) (local.get 1))'+
    '  )'+
    ''+
    '  (data (i32.const 0x1000) "\01\00\01\00\02\00\02\00\03\00\03\00\04\05\06\07")'+
    ')';
  binary.Unwrap.Wat2Wasm(wat2);

  writeln('Compiling export memory module...');
  var module2 := TWasmModule.New(+store, +binary);
  if module2.IsNone then
  begin
    writeln('> Error compiling export module!');
    exit(false)
  end;

  writeln('Instantiating export memory module...');
  var imports2 := TWasmExternVec.Create([]);
  var instance2 := TWasmInstance.New(+store, +module2, @imports2, nil);
  if instance2.IsNone then
  begin
    writeln('> Error instantiating export module!');
    exit(false);
  end;

  var export_s2 := (+instance2).GetExports;

  // Create external print functions.
  writeln('Creating callback...');
  var callback_func := TWasmFunc.New(+store, +TWasmFunctype.New([WASM_I32, WASM_I32, WASM_I32, WASM_I32], [WASM_I32, WASM_I32, WASM_I32, WASM_I32]), callback);

  Assert(export_s2.Unwrap.Items[0].AsMemory <> nil);
  // Instantiate.
  writeln('Instantiating import memory module...');
  var imports := TWasmExternVec.Create([ export_s2.Unwrap.Items[0], (+callback_func).AsExtern ]);
  var instance := TWasmInstance.New(+store, +module, @imports, nil);
  if instance.IsNone then
  begin
    writeln('> Error instantiating import memory module!');
    exit(false);
  end;

//  TWasm.func_delete(callback_func);

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
  writeln('Calling import memory func...');
  var res := [
    WASM_INIT_VAL, WASM_INIT_VAL, WASM_INIT_VAL, WASM_INIT_VAL
  ];
  var args := TWasmValVec.Create([]);
  var results := TWasmValVec.Create(res);
  if run_func.Call( @args, @results).IsError then
  begin
    writeln('> Error calling function!');
    exit(false);
  end;

  // Print result.
  writeln('Printing result...');
  writeln( Format('> %x %x %x %x', [
    res[0].i32, res[1].i32, res[2].i32, res[3].i32]));

  assert(res[0].i32 = $07060504);
  assert(res[1].i32 = $030003);
  assert(res[2].i32 = $020002);
  assert(UInt32(res[3].i32) = $AA55AA55);

  // Shut down.
  writeln('Shutting down...');

  // All done.
  writeln('Done.');
  result := true;
end;

end.
