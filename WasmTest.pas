unit WasmTest;

interface
uses
  Wasm
  ,WasmSample_Callback
  ,WasmSample_Finalize
  ,WasmSample_Memory
  ,WasmSample_Multi
  ,WasmSample_Table
  ,WasmSample_Threads
  ,WasmtimeSample_Linking
{$ifndef USE_WASMER}
  , Wasmtime
{$else}
  , Wasmer
{$ifend}
 ;

procedure DoTest();

implementation

procedure DoTest();
var ch : Char;
begin
{$ifndef USE_WASMER}
  writeln('Loading Wasmtime...');
  TWasmtime.Init('wasmtime.dll');
{$else}
  writeln('Loading Wasmer...');
  TWasmer.Init('wasmer.dll');
{$ifend}

  repeat
    writeln('');
    writeln('1: Callback');
    writeln('2: Finalize (*NG : ''instance_set_host_info_with_finalizer'' is not implemented*)');
    writeln('3: Memory');
    writeln('4: Multi');
    writeln('5: Table (*NG : ''table_get'' is not implemented in wasmer, ''func_as_ref'' is not implemented)');
    writeln('6: Threads (* wasmer NG : ''module_share'' is not implemented in wasmer)');
    writeln('7: Linking / Wasmtime');
    writeln('');
    writeln('q: Quit');
    writeln('');
    write('>');

    Readln(ch);
    case ch of
    '1' : CallbackSample();
    '2' : FinalizeSample_CLike();
    '3' : MemorySample();
    '4' : MultiSample();
    '5' : TableSample();
    '6' : ThreadsSample();
    '7' : LinkingSample();
    end;
  until ch = 'q';
end;

end.
