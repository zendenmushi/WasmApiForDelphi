unit WasmSample_Table;

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

function TableSample() : Boolean;

implementation

// A function to be called from Wasm code.
function neg_callback(const args : PWasmValVec; results : PWasmValVec) : PWasmTrap; cdecl;
begin
  writeln('Calling back...');
  results.Items[0] := TWasmVal.Create(-args.Items[0].i32);
  result := nil;
end;

procedure check(success : Boolean);
begin
  if not  success then
  begin
    writeln('> Error, expected success');
    halt(1);
  end;
end;

procedure check_call(func : PWasmFunc; arg1 : Integer; arg2 : Integer; expected : Integer);
begin
  var args := TWasmValVec.Create([WASM_I32_VAL(arg1), WASM_I32_VAL(arg2)]);
  var results := TWasmValVec.NewUninitialized(1);
  if (func.Call(@args, +results).IsError) or (results.Unwrap.Items[0].i32 <> expected) then
  begin
    writeln('> Error on result, expected return');
    halt(1);
  end;
end;

procedure check_trap(func : PWasmFunc; arg1 : Integer; arg2 : Integer);
begin
  var vs := [ WASM_I32_VAL(arg1), WASM_I32_VAL(arg2) ];
  var r := [ WASM_INIT_VAL ];
  var args := TWasmValVec.Create(vs);
  var results := TWasmValVec.Create(r);
  var trap := func.Call(@args, @results);
  if (trap.IsError) then
  begin
    writeln('> Error on result, expected trap');
    halt(1);
  end;
end;

procedure run();
begin
  // Initialize.
  writeln('Initializing...');
  var engine := TWasmEngine.New;
  var store := TWasmStore.New(+engine);

  // Load binary.
  var binary := TWasmByteVec.NewEmpty;
{$ifdef USE_WASMFILE}
  binary.Unwrap.LoadFromFile('table.wasm');
{$else}
  var wat : AnsiString :=
    '(module'+
    '  (table (export "table") 2 10 funcref)'+
    ''+
    '  (func (export "call_indirect") (param i32 i32) (result i32)'+
    '    (call_indirect (param i32) (result i32) (local.get 0) (local.get 1))'+
    '  )'+
    ''+
    '  (func $f (export "f") (param i32) (result i32) (local.get 0))'+
    '  (func (export "g") (param i32) (result i32) (i32.const 666))'+
    ''+
    '  (elem (i32.const 1) $f)'+
    ')';
  binary.Unwrap.Wat2Wasm(wat);
{$ifend}

  // Compile.
  writeln('Compiling module...');
  var module := TWasmModule.New(+store, +binary);
  if module.IsNone then
  begin
    writeln('> Error compiling module!');
    halt(1);
  end;

  // Instantiate.
  writeln('Instantiating module...');
  var imports := TWasmExternVec.NewEmpty;
  var instance := TWasmInstance.New(+store, +module, +imports, nil);
  if instance.IsNone then
  begin
    writeln('> Error instantiating module!');
    halt(1);
  end;

  // Extract export.
  writeln('Extracting exports...');
  var export_s := (+instance).GetExports();
  var table := export_s.Unwrap.Items[0].AsTable;
  var call_indirect := export_s.Unwrap.Items[1].AsFunc;
  var f := export_s.Unwrap.Items[2].AsFunc;
  var g := export_s.Unwrap.Items[3].AsFunc;

  // Create external function.
  writeln('Creating callback...');
  var neg_type := TWasmFunctype.New([WASM_I32], [WASM_I32]);
  var h := TWasmFunc.New(+store, +neg_type, neg_callback);

  // Try cloning.
//  assert(table.Copy.Unwrap.Same(table)); // wasm_table_same :Unimplemented in Wasmtime

  // Check initial table.
  writeln('Checking table...');
  check(table.Size = 2);
  check(table.GetRef(0).IsNone);
  check(not table.GetRef(1).IsNone);
//  check_trap(call_indirect, 0, 0);
  check_call(call_indirect, 7, 1, 7);
//  check_trap(call_indirect, 0, 2);

  // Mutate table.
  writeln('Mutating table...');
  check(table.SetRef(0, g.AsRef));      // wasm_func_as_ref :Unimplemented in Wasmtime
  check(table.SetRef(1, nil));
//  check(not table.SetRef(2, f.AsRef));
//  check(not table.GetRef(0).IsNone);
  check(table.GetRef(1).IsNone);
  check_call(call_indirect, 7, 0, 666);
//  check_trap(call_indirect, 0, 1);
//  check_trap(call_indirect, 0, 2);

  // Grow table.
  writeln('Growing table...');
  check(table.Grow(3,nil));
  check(table.Size() = 5);
  check(table.SetRef(2, f.AsRef));
  check(table.SetRef(3, (+h).AsRef));
  check(not table.SetRef(5, nil));
  check(not table.GetRef(2).IsNone);
  check(not table.GetRef(3).IsNone);
  check(table.GetRef(4).IsNone);
  check_call(call_indirect, 5, 2, 5);
  check_call(call_indirect, 6, 3, -6);
  check_trap(call_indirect, 0, 4);
  check_trap(call_indirect, 0, 5);

  check(table.Grow(2, f.AsRef));
  check(table.Size = 7);
  check(not table.GetRef(5).IsNone);
  check(not table.GetRef(6).IsNone);

  check(not table.Grow(5,nil));
  check(table.Grow(3,nil));
  check(table.Grow(0,nil));

  // Create stand-alone table.
  // TODO(wasm+): Once Wasm allows multiple tables, turn this into import.
  writeln('Creating stand-alone table...');
  var lim := TWasmLimits.Create(5,5);
  var tabletype := TWasmTableType.New( +TWasmValtype.New(WASM_FUNCREF), @lim);
  var table2 := TWasmTable.New(+store, +tabletype, nil);
  check(table2.Unwrap.Size = 5);
  check(not table2.Unwrap.Grow(1,nil));
  check(table2.Unwrap.Grow(0,nil));

  // Shut down.
  writeln('Shutting down...');
end;


function TableSample() : Boolean;
begin
  run();
  result := true;
end;

end.
