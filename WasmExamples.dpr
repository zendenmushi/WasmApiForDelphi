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
  WasmSample_Threads in 'WasmSample_Threads.pas';

begin
  try
    { TODO -oUser -cConsole ���C�� : �����ɃR�[�h���L�q���Ă������� }
    DoTest();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
