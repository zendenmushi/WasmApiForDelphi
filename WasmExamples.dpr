program WasmExamples;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Wasm in 'Wasm.pas',
  WasmTest in 'WasmTest.pas',
  WasmSample_Callback in 'WasmSample_Callback.pas',
  WasmSample_Finalize in 'WasmSample_Finalize.pas',
  WasmSample_Memory in 'WasmSample_Memory.pas',
  WasmSample_Multi in 'WasmSample_Multi.pas',
  WasmSample_Table in 'WasmSample_Table.pas',
  WasmSample_Threads in 'WasmSample_Threads.pas',
  WasmtimeSample_Linking in 'WasmtimeSample_Linking.pas',
  WasmTest_ShareMemory in 'WasmTest_ShareMemory.pas',
  WasmTest_Bench in 'WasmTest_Bench.pas';

begin
  try
    { TODO -oUser -cConsole メイン : ここにコードを記述してください }
    DoTest();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
