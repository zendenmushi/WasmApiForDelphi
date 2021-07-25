unit Wasm.Wasi;
// [ApiNamespace] wasi

interface
uses
  Wasm, Ownership
  ;

type
  PWasiConfig = ^TWasiConfig;

  // [OwnBegin] wasi_config
  TOwnWasiConfig = record
  private
    FStrongRef : IRcContainer<PWasiConfig>;
  public
    class function Wrap(p : PWasiConfig; deleter : TRcDeleter) : TOwnWasiConfig; overload; static; inline;
    class function Wrap(p : PWasiConfig) : TOwnWasiConfig; overload; static;
    class operator Finalize(var Dest: TOwnWasiConfig);
    class operator Implicit(const Src : IRcContainer<PWasiConfig>) : TOwnWasiConfig;
    class operator Positive(Src : TOwnWasiConfig) : PWasiConfig;
    class operator Negative(Src : TOwnWasiConfig) : IRcContainer<PWasiConfig>;
    function Unwrap() : PWasiConfig;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  TWasiConfig = record
  public
    class function New() : TOwnWasiConfig;  static;
    procedure SetArgv(const argv : array of string);
    procedure InheritArgv();
    procedure SetEnv(const names : array of string; const values : array of string);
    procedure InheritEnv();
    procedure SetStdinFile(const path : string);
    procedure InheritStdin();
    procedure SetStdoutFile(const path : string);
    procedure InheritStdout();
    procedure SetStderrFile(const path : string);
    procedure InheritStderr();
    procedure PreopenDir(const path : string; const guest_path : string);
  end;

  TWasiConfigDelete = procedure({own} name : PWasiConfig); cdecl;
{$REGION 'TWasiConfigNew'}
(*
 * \brief Creates a new empty configuration object.
 *
 * The caller is expected to deallocate the returned configuration
 *)
{$ENDREGION}
  TWasiConfigNew = function() : PWasiConfig; cdecl;

{$REGION 'TWasiConfigSetArgv'}
(*
 * \brief Sets the argv list for this configuration object.
 *
 * By default WASI programs have an empty argv list, but this can be used to
 * explicitly specify what the argv list for the program is.
 *
 * The arguments are copied into the `config` object as part of this function
 * call, so the `argv` pointer only needs to stay alive for this function call.
 *)
{$ENDREGION}
  TWasiConfigSetArgv = procedure(config : PWasiConfig; argc : Int32; const argv : PPAnsiChar); cdecl;
{$REGION 'TWasiConfigInheritArgv'}
(*
 * \brief Indicates that the argv list should be inherited from this process's
 * argv list.
 *)
{$ENDREGION}
  TWasiConfigInheritArgv = procedure(config : PWasiConfig); cdecl;
{$REGION 'TWasiConfigSetEnv'}
(*
 * \brief Sets the list of environment variables available to the WASI instance.
 *
 * By default WASI programs have a blank environment, but this can be used to
 * define some environment variables for them.
 *
 * It is required that the `names` and `values` lists both have `envc` entries.
 *
 * The env vars are copied into the `config` object as part of this function
 * call, so the `names` and `values` pointers only need to stay alive for this
 * function call.
 *)
{$ENDREGION}
  TWasiConfigSetEnv = procedure(config : PWasiConfig; envc : Int32; const names : PPAnsiChar;  const values : PPAnsiChar); cdecl;
{$REGION 'TWasiConfigInheritEnv'}
(*
 * \brief Indicates that the entire environment of the calling process should be
 * inherited by this WASI configuration.
 *)
{$ENDREGION}
  TWasiConfigInheritEnv = procedure(config : PWasiConfig); cdecl;
{$REGION 'TWasiConfigSetStdinFile'}
(*
 * \brief Configures standard input to be taken from the specified file.
 *
 * By default WASI programs have no stdin, but this configures the specified
 * file to be used as stdin for this configuration.
 *
 * If the stdin location does not exist or it cannot be opened for reading then
 * `false` is returned. Otherwise `true` is returned.
 *)
{$ENDREGION}
  TWasiConfigSetStdinFile = procedure(config : PWasiConfig; const path : PAnsiChar); cdecl;
{$REGION 'TWasiConfigInheritStdin'}
(*
 * \brief Configures this process's own stdin stream to be used as stdin for
 * this WASI configuration.
 *)
{$ENDREGION}
  TWasiConfigInheritStdin = procedure(config : PWasiConfig); cdecl;
{$REGION 'TWasiConfigSetStdoutFile'}
(*
 * \brief Configures standard output to be written to the specified file.
 *
 * By default WASI programs have no stdout, but this configures the specified
 * file to be used as stdout.
 *
 * If the stdout location could not be opened for writing then `false` is
 * returned. Otherwise `true` is returned.
 *)
{$ENDREGION}
  TWasiConfigSetStdoutFile = procedure(config : PWasiConfig; const path : PAnsiChar); cdecl;
{$REGION 'TWasiConfigInheritStdout'}
(*
 * \brief Configures this process's own stdout stream to be used as stdout for
 * this WASI configuration.
 *)
{$ENDREGION}
  TWasiConfigInheritStdout = procedure(config : PWasiConfig); cdecl;
{$REGION 'TWasiConfigSetStderrFile'}
(*
 * \brief Configures standard output to be written to the specified file.
 *
 * By default WASI programs have no stderr, but this configures the specified
 * file to be used as stderr.
 *
 * If the stderr location could not be opened for writing then `false` is
 * returned. Otherwise `true` is returned.
 *)
{$ENDREGION}
  TWasiConfigSetStderrFile = procedure(config : PWasiConfig; const path : PAnsiChar); cdecl;
{$REGION 'TWasiConfigInheritStderr'}
(*
 * \brief Configures this process's own stderr stream to be used as stderr for
 * this WASI configuration.
 *)
{$ENDREGION}
  TWasiConfigInheritStderr = procedure(config : PWasiConfig); cdecl;
{$REGION 'TWasiConfigInheritStderr'}
(*
 * \brief Configures a "preopened directory" to be available to WASI APIs.
 *
 * By default WASI programs do not have access to anything on the filesystem.
 * This API can be used to grant WASI programs access to a directory on the
 * filesystem, but only that directory (its whole contents but nothing above it).
 *
 * The `path` argument here is a path name on the host filesystem, and
 * `guest_path` is the name by which it will be known in wasm.
 *)
{$ENDREGION}
  TWasiConfigPreopenDir = procedure(config : PWasiConfig; const path : PAnsiChar; const guest_path : PAnsiChar); cdecl;


  TWasi = record
  public class var
    config_delete : TWasiConfigDelete;
    config_new : TWasiConfigNew;
    config_set_argv : TWasiConfigSetArgv;
    config_inherit_argv : TWasiConfigInheritArgv;
    config_set_env : TWasiConfigSetEnv;
    config_inherit_env : TWasiConfigInheritEnv;
    config_set_stdin_file : TWasiConfigSetStdinFile;
    config_inherit_stdin : TWasiConfigInheritStdin;
    config_set_stdout_file : TWasiConfigSetStdoutFile;
    config_inherit_stdout : TWasiConfigInheritStdout;
    config_set_stderr_file : TWasiConfigSetStderrFile;
    config_inherit_stderr : TWasiConfigInheritStderr;
    config_preopen_dir : TWasiConfigPreopenDir;
  public
    class procedure InitAPIs(runtime : HMODULE); static;
  end;

implementation
uses
  Windows;


{ TWasi }

class procedure TWasi.InitAPIs(runtime: HMODULE);
  function ProcAddress(name : string) : Pointer;
  begin
    result := GetProcAddress(runtime, PWideChar(name));
  end;

begin

  if runtime <> 0 then
  begin
    config_delete := ProcAddress('wasi_config_delete');
    config_new := ProcAddress('wasi_config_new');
    config_set_argv := ProcAddress('wasi_config_set_argv');
    config_inherit_argv := ProcAddress('wasi_config_inherit_argv');
    config_set_env := ProcAddress('wasi_config_set_env');
    config_inherit_env := ProcAddress('wasi_config_inherit_env');
    config_set_stdin_file := ProcAddress('wasi_config_set_stdin_file');
    config_inherit_stdin := ProcAddress('wasi_config_inherit_stdin');
    config_set_stdout_file := ProcAddress('wasi_config_set_stdout_file');
    config_inherit_stdout := ProcAddress('wasi_config_inherit_stdout');
    config_set_stderr_file := ProcAddress('wasi_config_set_stderr_file');
    config_inherit_stderr := ProcAddress('wasi_config_inherit_stderr');
    config_preopen_dir := ProcAddress('wasi_config_preopen_dir');
  end;
end;


// [OwnImplBegin]

{ TOwnWasiConfig }

procedure wasi_config_disposer(p : Pointer);
begin
  TWasi.config_delete(p);
end;

class operator TOwnWasiConfig.Finalize(var Dest: TOwnWasiConfig);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasiConfig.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasiConfig.Negative(Src: TOwnWasiConfig): IRcContainer<PWasiConfig>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasiConfig.Positive(Src: TOwnWasiConfig): PWasiConfig;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasiConfig.Implicit(const Src : IRcContainer<PWasiConfig>) : TOwnWasiConfig;
begin
  result.FStrongRef := Src;
end;

function TOwnWasiConfig.Unwrap: PWasiConfig;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasiConfig.Wrap(p : PWasiConfig) : TOwnWasiConfig;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasiConfig>.Create(p, wasi_config_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasiConfig.Wrap(p : PWasiConfig; deleter : TRcDeleter) : TOwnWasiConfig;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasiConfig>.Create(p, deleter)
  else result.FStrongRef := nil;
end;
// [OwnImplEnd]

{ TWasiConfig }

procedure TWasiConfig.InheritArgv;
begin
  TWasi.config_inherit_argv(@self);
end;

procedure TWasiConfig.InheritEnv;
begin
  TWasi.config_inherit_env(@self);
end;

procedure TWasiConfig.InheritStderr;
begin
  TWasi.config_inherit_stderr(@self);
end;

procedure TWasiConfig.InheritStdin;
begin
  TWasi.config_inherit_stdin(@self);
end;

procedure TWasiConfig.InheritStdout;
begin
  TWasi.config_inherit_stdout(@self);
end;

class function TWasiConfig.New: TOwnWasiConfig;
begin
  var p := TWasi.config_new();
  result := TOwnWasiConfig.Wrap(p);
end;

procedure TWasiConfig.PreopenDir(const path, guest_path: string);
begin
  TWasi.config_preopen_dir(@self, PAnsiChar(UTF8String(path)),  PAnsiChar(UTF8String(guest_path)) );
end;

procedure TWasiConfig.SetArgv(const argv: array of string);
begin
  var argvp : TArray<PPAnsiChar>;
  var len := Length(argv);
  SetLength(argvp, len);
  for var i := 0 to len-1 do
  begin
    argvp[i] := PPAnsiChar(UTF8String(argv[i]));
  end;
  TWasi.config_set_argv(@self, len, @argvp[0]);
end;

procedure TWasiConfig.SetEnv(const names, values: array of string);
begin
  var namep, valuep : TArray<PAnsiChar>;
  var len := Length(names);
  var len2 := Length(values);
  if len = len2 then
  begin
    SetLength(namep, len);
    SetLength(valuep, len);
    for var i := 0 to len-1 do
    begin
      namep[i] := PAnsiChar(UTF8String(names[i]));
      valuep[i] := PAnsiChar(UTF8String(values[i]));
    end;
    TWasi.config_set_env(@self, len, @namep[0], @valuep[0]);
  end;
end;

procedure TWasiConfig.SetStderrFile(const path: string);
begin
  TWasi.config_set_stderr_file(@self, PAnsiChar(UTF8String(path)));
end;

procedure TWasiConfig.SetStdinFile(const path: string);
begin
  TWasi.config_set_stdin_file(@self, PAnsiChar(UTF8String(path)));
end;

procedure TWasiConfig.SetStdoutFile(const path: string);
begin
  TWasi.config_set_stdout_file(@self, PAnsiChar(UTF8String(path)));
end;

end.
