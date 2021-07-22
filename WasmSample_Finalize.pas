unit WasmSample_Finalize;

interface
uses
  System.SysUtils, System.Classes
  , Wasm
{$ifndef USE_WASMER}
  , Wasmtime
{$else}
  , Wasmer
{$ifend}
  ;

// wasm_instance_set_host_info_with_finalizer  is not implemented!

function FinalizeSample_Clike() : Boolean;

implementation

const iterations = 100000;

var live_count : Integer = 0;

procedure finalize(data : Pointer); cdecl;
begin
  var i := NativeInt(data);
  if (i mod (iterations div 10)) = 0 then
  begin
    writeln('Finalizing #'+IntToStr(i)+'...');
  end;
  Dec(live_count);
end;

function run_in_store(const store : TOwnStore) : Boolean;
begin
  result := true;
  // Load binary.
  writeln('Loading binary...');
  var binary := TWasmByteVec.NewEmpty;
{$ifdef USE_WASMFILE}
  binary.Unwrap.LoadFromFile('finalize.wasm');
{$else}
  var wat : AnsiString :=
    '(module'+
    '  (func (export "f"))'+
    '  (func (export "g"))'+
    '  (func (export "h"))'+
    ')';
  binary.Unwrap.Wat2Wasm(wat);
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
  for var i := 0 to iterations do
  begin
    if (i mod (iterations div 10) = 0) then writeln(IntToStr(i));
    var imports := TWasmExternVec.Create([]);
    var instance := TWasm.instance_new(+store, +module, @imports, nil);
    if  instance = nil then
    begin
      writeln('> Error instantiating module '+IntToStr(i)+'!');
      exit(false);
    end;
    var data := Pointer(i);

    TWasm.instance_set_host_info_with_finalizer(instance, data, finalize);    // not implemented
    TWasm.instance_delete(instance);
    Inc(live_count);
  end;

end;

function FinalizeSample_Clike() : Boolean;
begin
  // Initialize.
  writeln('Initializing...');
  begin
    var engine := TWasmEngine.New();

    writeln('Live count '+IntToStr(live_count));
    writeln('Creating store 1...');
    begin
      var store1 := TWasmStore.New(+engine);

      writeln('Running in store 1...');
      run_in_store(store1);
      writeln('Live count '+IntToStr(live_count));

      writeln('Creating store 2...');
      begin
        var store2 := TWasmStore.New(+engine);

        writeln('Running in store 2...');
        run_in_store(store2);
        writeln('Live count '+IntToStr(live_count));

        writeln('Deleting store 2...');
      end;
      writeln('Live count '+IntToStr(live_count));

      writeln('Running in store 1...');
      run_in_store(store1);
      writeln('Live count '+IntToStr(live_count));

      writeln('Deleting store 1...');
    end;
    writeln('Live count '+IntToStr(live_count));

    assert(live_count = 0);

    // Shut down.
    writeln('Shutting down...');
  end;

  // All done.
  writeln('Done.');
  result := true;
end;

end.
