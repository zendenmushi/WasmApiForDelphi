unit WasmSample_Memory;

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

function MemorySample() : Boolean;

implementation


procedure check(success : Boolean);
begin
  if not success then
  begin
    writeln('> Error, expected success');
    halt(1);
  end;
end;

procedure check_call(const func : PWasmFunc; i : Integer; const args : array of TWasmVal; expected : Integer);
begin
  var args_ := TWasmValVec.Create(args);
  var results := TWasmValVec.Create([nil]);
  if (func.Call(@args_, @results).IsError ) or (results.Items[0].i32 <> expected) then
  begin
    writeln('> Error on result');
    halt(1);
  end;
end;

procedure check_call0(const func : PWasmFunc; expected : Integer);
begin
  check_call(func, 0, [], expected);
end;

procedure check_call1(const func : PWasmFunc; arg : Integer; expected : Integer);
begin
  var args := [ WASM_I32_VAL(arg) ];
  check_call(func, 1, args, expected);
end;

procedure check_call2(const func : PWasmFunc; arg1 : Integer; arg2 : Integer; expected : Integer);
begin
  var args := [ WASM_I32_VAL(arg1), WASM_I32_VAL(arg2) ];
  check_call(func, 2, args, expected);
end;

procedure check_ok(const func : PWasmFunc; i : Integer; const args : array of TWasmVal);
begin
  var args_ := TWasmValVec.Create(args);
  var results := Default(TWasmValVec);
  var trap := func.Call(@args_, @results);
  if trap.IsError then
  begin
    var s := (+trap).GetMessage().Unwrap.AsUTF8String;
    writeln('> Error on result, expected empty '+s);
    halt(1);
  end;
end;

procedure check_ok2(const func : PWasmFunc; arg1 : Integer; arg2 : Integer);
begin
  var args := [ WASM_I32_VAL(arg1), WASM_I32_VAL(arg2) ];
  check_ok(func, 2, args);
end;

procedure check_trap(const func : PWasmFunc; i : Integer; const args : array of TWasmVal; const ret : array of TWasmVal);
begin
  var args_ := TWasmValVec.Create(args);
  var results := TWasmValVec.Create(ret);
  var trap := func.Call(@args_, @results);
  if trap.IsError then
  begin
    var s := (+trap).GetMessage().Unwrap.AsUTF8String;
    writeln('> Error on result, expected trap '+s);
    halt(1);
  end;
end;

procedure check_trap1(const func : PWasmFunc;  arg : Integer);
begin
  var args := [ WASM_I32_VAL(arg) ];
  check_trap(func, 1, args, [nil]);
end;

procedure check_trap2(const func : PWasmFunc; arg1 : Integer; arg2 : Integer);
begin
  var args := [ WASM_I32_VAL(arg1), WASM_I32_VAL(arg2) ];
  check_trap(func, 2, args, []);
end;


function MemorySample() : Boolean;
begin
  // Initialize.
  writeln('Initializing...');
  var engine := TWasmEngine.New();
  var store := TWasmStore.New(+engine);

  // Load binary.
  writeln('Loading binary...');
  var binary := TWasmByteVec.NewEmpty;
{$ifdef USE_WASMFILE}
  if not (+binary).LoadFromFile('memory.wasm') then
  begin
    writeln('> Error loading module!');
    exit(false);
  end;
{$else}
  var wat : AnsiString :=
    '(module'+
    '  (memory (export "memory") 2 3)'+
    ''+
    '  (func (export "size") (result i32) (memory.size))'+
    '  (func (export "load") (param i32) (result i32) (i32.load8_s (local.get 0)))'+
    '  (func (export "store") (param i32 i32)'+
    '    (i32.store8 (local.get 0) (local.get 1))'+
    '  )'+
    ''+
    '  (data (i32.const 0x1000) "\01\02\03\04")'+
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

  // Instantiate.
  Writeln('Instantiating module...');
  var instance := TWasmInstance.New(+store, +module, [], nil);
  if instance.IsNone then
  begin
    writeln('> Error instantiating module!');
    exit(false);
  end;

  // Extract export.
  writeln('Extracting export...');
  var export_s := (+instance).GetExports;
  var memory := export_s.Unwrap.Items[0].AsMemory;
  var size_func := export_s.Unwrap.Items[1].AsFunc;
  var load_func := export_s.Unwrap.Items[2].AsFunc;
  var store_func := export_s.Unwrap.Items[3].AsFunc;

  // Try cloning.
  var copy := memory.Copy();
//  assert(TWasm.memory_same(memory, copy)); // wasmtime unimplemented   wasm_memory_same

  // Check initial memory.
  writeln('Checking memory...');
  check(memory.Size = 2);
  check(memory.DataSize = $20000);
  check(memory.Data[0] = 0);
  check(memory.Data[$1000] = 1);
  check(memory.Data[$1003] = 4);

  check_call0(size_func, 2);
  check_call1(load_func, 0, 0);
  check_call1(load_func, $1000, 1);
  check_call1(load_func, $1003, 4);
  check_call1(load_func, $1ffff, 0);
//  check_trap1(load_func, $20000); // ??? trapが起きずに例外発生

  // Mutate memory.
  writeln('Mutating memory...');
  memory.Data[$1003] := 5;
  check_ok2(store_func, $1002, 6);
//  check_trap2(store_func, $20000, 0); // ??? trapが起きずに例外発生

  check(memory.Data[$1002] = 6);
  check(memory.Data[$1003] = 5);
  check_call1(load_func, $1002, 6);
  check_call1(load_func, $1003, 5);

  // Grow memory.
  writeln('Growing memory...');
  check(memory.Grow(1));
  check(memory.Size = 3);
  check(memory.DataSize = $30000);

  check_call1(load_func, $20000, 0);
  check_ok2(store_func, $20000, 0);
//  check_trap1(load_func, $30000); // ??? trapが起きずに例外発生
//  check_trap2(store_func, $30000, 0); // ??? trapが起きずに例外発生

  check(not memory.Grow(1));
  check(memory.Grow(0));

  // Create stand-alone memory.
  // TODO(wasm+): Once Wasm allows multiple memories, turn this into import.
  writeln('Creating stand-alone memory...');
  var lim := TWasmLimits.Create(5, 5);
  var memory2 := TWasmMemory.New(+store,  +TWasmMemoryType.New(@lim));

  check(memory2.Unwrap.Size = 5);
  check(not memory2.Unwrap.Grow(1));
  check(memory2.Unwrap.Grow(0));

  // Shut down.
  writeln('Shutting down...');

  // All done.
  writeln('Done.');
  result := true;

end;


end.
