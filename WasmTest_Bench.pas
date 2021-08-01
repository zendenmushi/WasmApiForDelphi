unit WasmTest_Bench;

interface
uses
  System.SysUtils, System.Generics.Collections
  , Wasm
{$ifndef USE_WASMER}
  , Wasmtime
{$else}
  , Wasmer
{$ifend}
  ;

function Bench() : Boolean;

implementation
uses
  Diagnostics, Ownership;

function fibonacci(n : Integer) : Integer;
begin
  case n of
    0: result := 0;
    1: result := 1;
  else
    var p1 := 0;
    for var i := 1 to 2 do
    begin
      p1 := p1 + fibonacci(n-i);
    end;
    result := p1;
  end;
end;

function vec_bench() : Integer;
begin
  var dat := TList<Integer>.Create();
  for var i := 0 to 1000000-1 do
  begin
    dat.add(i);
  end;

  var sum := 0;
  for var d in dat do
  begin
    sum := sum + (d+1);
  end;

  result := sum;
  dat.Free;
end;


function Bench() : Boolean;
begin
  // Initialize.
  writeln('Initializing...');
  var config := TWasmConfig.New();
{$ifdef USE_WASMER}
  (+config).SetCompiler(TWasmerCompiler.CRANELIFT);
{$else}
  (+config).StrategySet(TWasmtimeStrategy.WASMTIME_STRATEGY_CRANELIFT);
{$endif}
  var engine := TWasmEngine.NewWithConfig(config);
  var store := TWasmStore.New(+engine);

  // Load binary.
  var binary := TWasmByteVec.NewEmpty;
{$ifdef USE_WASMER_AOT}
  var fname := '../wasm_bench_llvm.wasmu';
{$else}
  var fname := '../wasm_bench.wasm';
{$endif}
  writeln('Loading binary '+fname);
  binary.Unwrap.LoadFromFile(fname);


  // Compile.
  writeln('Compiling module...');
{$ifdef USE_WASMER_AOT}
  var module := TWasmModule.Deserialize(+store, +binary);
{$else}
  var module := TWasmModule.New(+store, +binary);
{$endif}
  if module.IsNone then
  begin
    writeln('> Error compiling module!');
    exit(false)
  end;

  var fibonacci_bench_id := -1;
  var vec_bench_id := -1;

  var export_types := (+module).GetExports;
  for var i := 0 to (+export_types).size-1 do
  begin
    var name := (+export_types).items[i].Name;
    if name = 'fibonacci_bench' then fibonacci_bench_id := i
    else if name = 'vec_bench' then vec_bench_id := i;
  end;


  // Instantiate.
  writeln('Instantiating module...');
  var imports := TWasmExternVec.Create([]);
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

  var fibonacci_bench_func := (+export_s).Items[fibonacci_bench_id].AsFunc;
  var vec_bench_func := (+export_s).Items[vec_bench_id].AsFunc;

  if fibonacci_bench_func <> nil then
  begin
    // Call.
    writeln('Calling export [fibonacci_bench]...');
    var sw := TStopWatch.Create();

    var res := [ WASM_INIT_VAL ];
    var args := TWasmValVec.Create([]);

    sw.Start();
    var results := TWasmValVec.Create(res);
    if fibonacci_bench_func.Call( @args, @results).IsError then
    begin
      writeln('> Error calling function!');
      exit(false);
    end;
    sw.Stop();

    // Print result.
    writeln('Printing result...');
    writeln( Format('Wasm-fibonacci> %u (%d ms)', [ UInt32(res[0].i32), sw.ElapsedMilliseconds ]));

    sw.Reset;
    sw.Start;
    var nr := fibonacci(38);
    sw.Stop();
    writeln( Format('Delphi-fibonacci> %u (%d ms)', [ nr, sw.ElapsedMilliseconds ]));
  end;

  if vec_bench_func <> nil then
  begin
    // Call.
    writeln('Calling export [vec_bench]...');
    var sw := TStopWatch.Create();

    var res := [ WASM_INIT_VAL ];
    var args := TWasmValVec.Create([]);

    sw.Start();
    var results := TWasmValVec.Create(res);
    if vec_bench_func.Call( @args, @results).IsError then
    begin
      writeln('> Error calling function!');
      exit(false);
    end;
    sw.Stop();

    // Print result.
    writeln('Printing result...');
    writeln( Format('Wasm-vec_bench> %u (%d ms)', [ UInt32(res[0].i32), sw.ElapsedMilliseconds ]));

    sw.Reset;
    sw.Start;
    var nr := vec_bench();
    sw.Stop();
    writeln( Format('Delphi-vec_bench> %u (%d ms)', [ nr, sw.ElapsedMilliseconds ]));
  end;


  // Shut down.
  writeln('Shutting down...');

  // All done.
  writeln('Done.');
  result := true;


end;

end.
