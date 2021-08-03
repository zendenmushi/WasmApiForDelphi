// Convert form wasmtime.h & etc  -> Delphi
unit Wasmtime;
// [ApiNamespace] wasmtime

interface
uses
  System.Classes, System.SysUtils,
  Wasm, Wasm.Wasi, Ownership
  ;

type

  PPByte = ^PByte;
  TWasmtimeStrategy = (WASMTIME_STARATEGY_AUTO, WASMTIME_STRATEGY_CRANELIFT, WASMTIME_STRATEGY_LIGHTBEAM);
  TWasmtimeOptLevel = (WASMTIME_OPT_LEVEL_NONE, WASMTIME_OPT_LEVEL_SPEED, WASMTIME_OPT_LEVEL_SPEED_AND_SIZE);
  TWasmtimeProfilingStrategy = (WASMTIME_PROFILING_STRATEGY_NONE, WASMTIME_PROFILING_STRATEGY_JITDUMP, WASMTIME_PROFILING_STRATEGY_VTUNE);

  PWasmtimeError = ^TWasmtimeError;
  PWasmtimeFunc = ^TWasmtimeFunc;
  PWasmtimeTable = ^TWasmtimeTable;
  PWasmtimeMemory = ^TWasmtimeMemory;
  PWasmtimeInstance = ^TWasmtimeInstance;
  PWasmtimeGlobal = ^TWasmtimeGlobal;
  PWasmtimeModule = ^TWasmtimeModule;
  PWasmtimeExtern = ^TWasmtimeExtern;
  PWasmtimeContext = ^TWasmtimeContext;
  PWasmtimeStore = ^TWasmtimeStore;
  PWasmtimeInterruptHandle = ^TWasmtimeInterruptHandle;
  PWasmtimeCaller = ^TWasmtimeCaller;
  PWasmtimeExternref = ^TWasmtimeExternref;
  PWasmtimeVal = ^TWasmtimeVal;
  PWasmtimeInstancetype = ^TWasmtimeInstancetype;
  PWasmtimeLinker = ^TWasmtimeLinker;
  PWasmtimeModuletype = ^TWasmtimeModuletype;

  PPWasmtimeModule = ^PWasmtimeModule;

  TWasmtimeFuncCallback = function(env : Pointer; caller : PWasmtimeCaller; const args : PWasmtimeVal; nargs : NativeUInt; results : PWasmtimeVal; nresults : NativeUInt) : PWasmTrap; cdecl;

  // [OwnBegin] wasmtime_error, IsError
  TOwnWasmtimeError = record
  private
    FStrongRef : IRcContainer<PWasmtimeError>;
  public
    class function Wrap(p : PWasmtimeError; deleter : TRcDeleter) : TOwnWasmtimeError; overload; static; inline;
    class function Wrap(p : PWasmtimeError) : TOwnWasmtimeError; overload; static;
    class operator Finalize(var Dest: TOwnWasmtimeError);
    class operator Implicit(const Src : IRcContainer<PWasmtimeError>) : TOwnWasmtimeError;
    class operator Positive(Src : TOwnWasmtimeError) : PWasmtimeError;
    class operator Negative(Src : TOwnWasmtimeError) : IRcContainer<PWasmtimeError>;
    function Unwrap() : PWasmtimeError;
    function IsNone() : Boolean;
    function IsError() : Boolean; overload;
    function IsError(proc : TWasmUnwrapProc<PWasmtimeError>) : Boolean; overload;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmtime_extern
  TOwnWasmtimeExtern = record
  private
    FStrongRef : IRcContainer<PWasmtimeExtern>;
  public
    class function Wrap(p : PWasmtimeExtern; deleter : TRcDeleter) : TOwnWasmtimeExtern; overload; static; inline;
    class function Wrap(p : PWasmtimeExtern) : TOwnWasmtimeExtern; overload; static;
    class operator Finalize(var Dest: TOwnWasmtimeExtern);
    class operator Implicit(const Src : IRcContainer<PWasmtimeExtern>) : TOwnWasmtimeExtern;
    class operator Positive(Src : TOwnWasmtimeExtern) : PWasmtimeExtern;
    class operator Negative(Src : TOwnWasmtimeExtern) : IRcContainer<PWasmtimeExtern>;
    function Unwrap() : PWasmtimeExtern;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]


  // [OwnBegin] wasmtime_module
  TOwnWasmtimeModule = record
  private
    FStrongRef : IRcContainer<PWasmtimeModule>;
  public
    class function Wrap(p : PWasmtimeModule; deleter : TRcDeleter) : TOwnWasmtimeModule; overload; static; inline;
    class function Wrap(p : PWasmtimeModule) : TOwnWasmtimeModule; overload; static;
    class operator Finalize(var Dest: TOwnWasmtimeModule);
    class operator Implicit(const Src : IRcContainer<PWasmtimeModule>) : TOwnWasmtimeModule;
    class operator Positive(Src : TOwnWasmtimeModule) : PWasmtimeModule;
    class operator Negative(Src : TOwnWasmtimeModule) : IRcContainer<PWasmtimeModule>;
    function Unwrap() : PWasmtimeModule;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmtime_store
  TOwnWasmtimeStore = record
  private
    FStrongRef : IRcContainer<PWasmtimeStore>;
  public
    class function Wrap(p : PWasmtimeStore; deleter : TRcDeleter) : TOwnWasmtimeStore; overload; static; inline;
    class function Wrap(p : PWasmtimeStore) : TOwnWasmtimeStore; overload; static;
    class operator Finalize(var Dest: TOwnWasmtimeStore);
    class operator Implicit(const Src : IRcContainer<PWasmtimeStore>) : TOwnWasmtimeStore;
    class operator Positive(Src : TOwnWasmtimeStore) : PWasmtimeStore;
    class operator Negative(Src : TOwnWasmtimeStore) : IRcContainer<PWasmtimeStore>;
    function Unwrap() : PWasmtimeStore;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmtime_interrupt_handle
  TOwnWasmtimeInterruptHandle = record
  private
    FStrongRef : IRcContainer<PWasmtimeInterruptHandle>;
  public
    class function Wrap(p : PWasmtimeInterruptHandle; deleter : TRcDeleter) : TOwnWasmtimeInterruptHandle; overload; static; inline;
    class function Wrap(p : PWasmtimeInterruptHandle) : TOwnWasmtimeInterruptHandle; overload; static;
    class operator Finalize(var Dest: TOwnWasmtimeInterruptHandle);
    class operator Implicit(const Src : IRcContainer<PWasmtimeInterruptHandle>) : TOwnWasmtimeInterruptHandle;
    class operator Positive(Src : TOwnWasmtimeInterruptHandle) : PWasmtimeInterruptHandle;
    class operator Negative(Src : TOwnWasmtimeInterruptHandle) : IRcContainer<PWasmtimeInterruptHandle>;
    function Unwrap() : PWasmtimeInterruptHandle;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmtime_externref
  TOwnWasmtimeExternref = record
  private
    FStrongRef : IRcContainer<PWasmtimeExternref>;
  public
    class function Wrap(p : PWasmtimeExternref; deleter : TRcDeleter) : TOwnWasmtimeExternref; overload; static; inline;
    class function Wrap(p : PWasmtimeExternref) : TOwnWasmtimeExternref; overload; static;
    class operator Finalize(var Dest: TOwnWasmtimeExternref);
    class operator Implicit(const Src : IRcContainer<PWasmtimeExternref>) : TOwnWasmtimeExternref;
    class operator Positive(Src : TOwnWasmtimeExternref) : PWasmtimeExternref;
    class operator Negative(Src : TOwnWasmtimeExternref) : IRcContainer<PWasmtimeExternref>;
    function Unwrap() : PWasmtimeExternref;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmtime_val
  TOwnWasmtimeVal = record
  private
    FStrongRef : IRcContainer<PWasmtimeVal>;
  public
    class function Wrap(p : PWasmtimeVal; deleter : TRcDeleter) : TOwnWasmtimeVal; overload; static; inline;
    class function Wrap(p : PWasmtimeVal) : TOwnWasmtimeVal; overload; static;
    class operator Finalize(var Dest: TOwnWasmtimeVal);
    class operator Implicit(const Src : IRcContainer<PWasmtimeVal>) : TOwnWasmtimeVal;
    class operator Positive(Src : TOwnWasmtimeVal) : PWasmtimeVal;
    class operator Negative(Src : TOwnWasmtimeVal) : IRcContainer<PWasmtimeVal>;
    function Unwrap() : PWasmtimeVal;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmtime_instancetype
  TOwnWasmtimeInstancetype = record
  private
    FStrongRef : IRcContainer<PWasmtimeInstancetype>;
  public
    class function Wrap(p : PWasmtimeInstancetype; deleter : TRcDeleter) : TOwnWasmtimeInstancetype; overload; static; inline;
    class function Wrap(p : PWasmtimeInstancetype) : TOwnWasmtimeInstancetype; overload; static;
    class operator Finalize(var Dest: TOwnWasmtimeInstancetype);
    class operator Implicit(const Src : IRcContainer<PWasmtimeInstancetype>) : TOwnWasmtimeInstancetype;
    class operator Positive(Src : TOwnWasmtimeInstancetype) : PWasmtimeInstancetype;
    class operator Negative(Src : TOwnWasmtimeInstancetype) : IRcContainer<PWasmtimeInstancetype>;
    function Unwrap() : PWasmtimeInstancetype;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmtime_linker
  TOwnWasmtimeLinker = record
  private
    FStrongRef : IRcContainer<PWasmtimeLinker>;
  public
    class function Wrap(p : PWasmtimeLinker; deleter : TRcDeleter) : TOwnWasmtimeLinker; overload; static; inline;
    class function Wrap(p : PWasmtimeLinker) : TOwnWasmtimeLinker; overload; static;
    class operator Finalize(var Dest: TOwnWasmtimeLinker);
    class operator Implicit(const Src : IRcContainer<PWasmtimeLinker>) : TOwnWasmtimeLinker;
    class operator Positive(Src : TOwnWasmtimeLinker) : PWasmtimeLinker;
    class operator Negative(Src : TOwnWasmtimeLinker) : IRcContainer<PWasmtimeLinker>;
    function Unwrap() : PWasmtimeLinker;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmtime_moduletype
  TOwnWasmtimeModuletype = record
  private
    FStrongRef : IRcContainer<PWasmtimeModuletype>;
  public
    class function Wrap(p : PWasmtimeModuletype; deleter : TRcDeleter) : TOwnWasmtimeModuletype; overload; static; inline;
    class function Wrap(p : PWasmtimeModuletype) : TOwnWasmtimeModuletype; overload; static;
    class operator Finalize(var Dest: TOwnWasmtimeModuletype);
    class operator Implicit(const Src : IRcContainer<PWasmtimeModuletype>) : TOwnWasmtimeModuletype;
    class operator Positive(Src : TOwnWasmtimeModuletype) : PWasmtimeModuletype;
    class operator Negative(Src : TOwnWasmtimeModuletype) : IRcContainer<PWasmtimeModuletype>;
    function Unwrap() : PWasmtimeModuletype;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmtime_table , default_disposer
  TOwnWasmtimeTable = record
  private
    FStrongRef : IRcContainer<PWasmtimeTable>;
  public
    class function Wrap(p : PWasmtimeTable) : TOwnWasmtimeTable; static;
    class operator Finalize(var Dest: TOwnWasmtimeTable);
    class operator Implicit(const Src : IRcContainer<PWasmtimeTable>) : TOwnWasmtimeTable;
    class operator Positive(Src : TOwnWasmtimeTable) : PWasmtimeTable;
    class operator Negative(Src : TOwnWasmtimeTable) : IRcContainer<PWasmtimeTable>;
    function Unwrap() : PWasmtimeTable;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmtime_global , default_disposer
  TOwnWasmtimeGlobal = record
  private
    FStrongRef : IRcContainer<PWasmtimeGlobal>;
  public
    class function Wrap(p : PWasmtimeGlobal) : TOwnWasmtimeGlobal; static;
    class operator Finalize(var Dest: TOwnWasmtimeGlobal);
    class operator Implicit(const Src : IRcContainer<PWasmtimeGlobal>) : TOwnWasmtimeGlobal;
    class operator Positive(Src : TOwnWasmtimeGlobal) : PWasmtimeGlobal;
    class operator Negative(Src : TOwnWasmtimeGlobal) : IRcContainer<PWasmtimeGlobal>;
    function Unwrap() : PWasmtimeGlobal;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmtime_func , default_disposer
  TOwnWasmtimeFunc = record
  private
    FStrongRef : IRcContainer<PWasmtimeFunc>;
  public
    class function Wrap(p : PWasmtimeFunc) : TOwnWasmtimeFunc; static;
    class operator Finalize(var Dest: TOwnWasmtimeFunc);
    class operator Implicit(const Src : IRcContainer<PWasmtimeFunc>) : TOwnWasmtimeFunc;
    class operator Positive(Src : TOwnWasmtimeFunc) : PWasmtimeFunc;
    class operator Negative(Src : TOwnWasmtimeFunc) : IRcContainer<PWasmtimeFunc>;
    function Unwrap() : PWasmtimeFunc;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmtime_memory , default_disposer
  TOwnWasmtimeMemory = record
  private
    FStrongRef : IRcContainer<PWasmtimeMemory>;
  public
    class function Wrap(p : PWasmtimeMemory) : TOwnWasmtimeMemory; static;
    class operator Finalize(var Dest: TOwnWasmtimeMemory);
    class operator Implicit(const Src : IRcContainer<PWasmtimeMemory>) : TOwnWasmtimeMemory;
    class operator Positive(Src : TOwnWasmtimeMemory) : PWasmtimeMemory;
    class operator Negative(Src : TOwnWasmtimeMemory) : IRcContainer<PWasmtimeMemory>;
    function Unwrap() : PWasmtimeMemory;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmtime_instance , default_disposer
  TOwnWasmtimeInstance = record
  private
    FStrongRef : IRcContainer<PWasmtimeInstance>;
  public
    class function Wrap(p : PWasmtimeInstance) : TOwnWasmtimeInstance; static;
    class operator Finalize(var Dest: TOwnWasmtimeInstance);
    class operator Implicit(const Src : IRcContainer<PWasmtimeInstance>) : TOwnWasmtimeInstance;
    class operator Positive(Src : TOwnWasmtimeInstance) : PWasmtimeInstance;
    class operator Negative(Src : TOwnWasmtimeInstance) : IRcContainer<PWasmtimeInstance>;
    function Unwrap() : PWasmtimeInstance;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  TResultWasmtimeModule = record
  public
    IsError : Boolean;
    Error : TOwnWasmtimeError;
    Module : TOwnWasmtimeModule;
  end;

  TResultWasmtimeTable = record
  public
    IsError : Boolean;
    Error : TOwnWasmtimeError;
    Table : TOwnWasmtimeTable;
  end;

  TResultWasmtimeMemory = record
  public
    IsError : Boolean;
    Error : TOwnWasmtimeError;
    Memory : TOwnWasmtimeMemory;
  end;

  TResultWasmtimeInstance = record
  public
    IsError : Boolean;
    Error : TOwnWasmtimeError;
    Instance : TOwnWasmtimeInstance;
    Trap : TOwnTrap;
  end;

  TResultWasmtimeGlobal = record
  public
    IsError : Boolean;
    Error : TOwnWasmtimeError;
    Global : TOwnWasmtimeGlobal;
  end;

  TResultWasmtimeFunc = record
  public
    IsError : Boolean;
    Error : TOwnWasmtimeError;
    Func : TOwnWasmtimeFunc;
  end;

  TResultByteVec = record
  public
    IsError : Boolean;
    Error : TOwnWasmtimeError;
    ByteVec : TOwnByteVec;
  end;

  // wrapper & helper

  TWasmByteVecHelper = record helper for TWasmByteVec
    function LoadFromWatFile(fname : string) : Boolean;
    function Wat2Wasm(wat : string) : TOwnWasmtimeError;
  end;

  TWasmtimeError = record
  public
    function GetMessage() : string;
  end;

  TWasmtimeFunc = record
  public
    class function New(context : PWasmtimeContext; const typ : PWasmFunctype; callback : TWasmtimeFuncCallback; env : Pointer; finalizer : TWasmFinalizer) : TWasmtimeFunc; static;
    function GetType() : TOwnFunctype;
    function Call(const args : PWasmtimeVal; nargs : NativeUInt; results : PWasmtimeVal; nresults : NativeUInt; var trap: TOwnTrap) : TOwnWasmtimeError;
  public
    store_id : UInt64;
    index : NativeUInt;
  private
    context : PWasmtimeContext;
  end;

  TWasmtimeTable = record
  public
    class function New(context : PWasmtimeContext; const ty : PWasmTabletype; const init : PWasmtimeVal) : TResultWasmtimeTable; static;
    function GetType() : TOwnTabletype;
    function GetValue(index : UInt32) : TOwnWasmtimeVal;
    function SetValue(index : UInt32; const value : PWasmtimeVal) : TOwnWasmtimeError;
    function Size() : UInt32;
    function Grow(delta : UInt32; const init : PWasmtimeVal; prev_size : PUInt32) : TOwnWasmtimeError;
  public
    store_id : UInt64;
    index : NativeUInt;
  private
    context : PWasmtimeContext;

  end;

  TWasmtimeMemory = record
  public
    class function New(context : PWasmtimeContext; const ty : PWasmMemorytype) : TResultWasmtimeMemory; static;
    function GetType() : TOwnMemorytype;
    function Data() : PByte;
    function DataSize() : NativeUInt;
    function Size() : UInt32;
    function Grow(delta : UInt32; var prev_size : UInt32) : TOwnWasmtimeError;
  public
    store_id : UInt64;
    index : NativeUInt;
  private
    context : PWasmtimeContext;
  end;

  TWasmtimeInstance = record
  public
    class function New(context  : PWasmtimeContext; const module : PWasmtimeModule; const imports : PWasmtimeExtern; nimports : NativeUInt) : TResultWasmtimeInstance; static;
    function GetType() : TOwnWasmtimeInstancetype;
    function GetExport(name : UTF8String) : TOwnWasmtimeExtern;
    function GetExportByIndex(index : NativeUInt; out name : UTF8String) : TOwnWasmtimeExtern;
  public
    store_id : UInt64;
    index : NativeUInt;
  private
    context : PWasmtimeContext;
  end;

  TWasmtimeGlobal = record
  public
    class function New(context : PWasmtimeContext; const typ : PWasmGlobaltype; const val : PWasmtimeVal) : TResultWasmtimeGlobal; static;
    function GetType() : TOwnGlobaltype;
    function GetValue() : TOwnWasmtimeVal;
    function SetValue(val : PWasmtimeVal) : TOwnWasmtimeError;
  public
    store_id : UInt64;
    index : NativeUInt;
  private
    context : PWasmtimeContext;
  end;

{$REGION 'TWasmtimeModule'}
(**
 * \typedef wasmtime_module_t
 * \brief Convenience alias for #wasmtime_module
 *
 * \struct wasmtime_module
 * \brief A compiled Wasmtime module.
 *
 * This type represents a compiled WebAssembly module. The compiled module is
 * ready to be instantiated and can be inspected for imports/exports. It is safe
 * to use a module across multiple threads simultaneously.
 *)
{$ENDREGION}
  TWasmtimeModule = record
  public
    class function New(engine : PWasmEngine; const binary : PWasmByteVec) : TResultWasmtimeModule; static;
    function Clone() : TOwnWasmtimeModule;
    function Validate(engine : PWasmEngine;  const binary : PWasmByteVec) : TOwnWasmtimeError;
    function GetType() : TOwnWasmtimeModuletype;
    function Serialize() : TResultByteVec;
    class function Deserialize(engine : PWasmEngine; const bytes : PByte; bytes_len : NativeUInt) : TResultWasmtimeModule; static;
  end;

  TWasmtimeExternKind = (WASMTIME_EXTERN_FUNC, WASMTIME_EXTERN_GLOBAL, WASMTIME_EXTERN_TABLE, WASMTIME_EXTERN_MEMORY, WASMTIME_EXTERN_INSTANCE, WASMTIME_EXTERN_MODULE);

  TWasmtimeExtern = record
  public
    function GetType(context : PWasmtimeContext) : TOwnExterntype;
  public
    kind : TWasmtimeExternKind;
    case TWasmtimeExternKind of
    WASMTIME_EXTERN_FUNC: (func : TWasmtimeFunc);
    WASMTIME_EXTERN_GLOBAL: (global : TWasmtimeGlobal);
    WASMTIME_EXTERN_TABLE: (table : TWasmtimeTable);
    WASMTIME_EXTERN_MEMORY: (memory : TWasmtimeMemory);
    WASMTIME_EXTERN_INSTANCE: (instance : TWasmtimeInstance);
    WASMTIME_EXTERN_MODULE: (module : PWasmtimeModule);
  end;

{$REGION 'TWasmtimeStore'}
(**
 * \typedef wasmtime_store_t
 * \brief Convenience alias for #wasmtime_store_t
 *
 * \struct wasmtime_store
 * \brief Storage of WebAssembly objects
 *
 * A store is the unit of isolation between WebAssembly instances in an
 * embedding of Wasmtime. Values in one #wasmtime_store_t cannot flow into
 * another #wasmtime_store_t. Stores are cheap to create and cheap to dispose.
 * It's expected that one-off stores are common in embeddings.
 *
 * Objects stored within a #wasmtime_store_t are referenced with integer handles
 * rather than interior pointers. This means that most APIs require that the
 * store be explicitly passed in, which is done via #wasmtime_context_t. It is
 * safe to move a #wasmtime_store_t to any thread at any time. A store generally
 * cannot be concurrently used, however.
 *)
{$ENDREGION}
  TWasmtimeStore = record
  public
    class function New(engine : PWasmEngine; data : Pointer; finalizer : TWasmFinalizer) : TOwnWasmtimeStore; static;
    function Context() : PWasmtimeContext;
  end;

{$REGION 'TWasmtimeContext'}
(**
 * \typedef wasmtime_context_t
 * \brief Convenience alias for #wasmtime_context
 *
 * \struct wasmtime_context
 * \brief An interior pointer into a #wasmtime_store_t which is used as
 * "context" for many functions.
 *
 * This context pointer is used pervasively throught Wasmtime's API. This can be
 * acquired from #wasmtime_store_context or #wasmtime_caller_context. The
 * context pointer for a store is the same for the entire lifetime of a store,
 * so it can safely be stored adjacent to a #wasmtime_store_t itself.
 *
 * Usage of a #wasmtime_context_t must not outlive the original
 * #wasmtime_store_t. Additionally #wasmtime_context_t can only be used in
 * situations where it has explicitly been granted access to doing so. For
 * example finalizers cannot use #wasmtime_context_t because they are not given
 * access to it.
 *)
{$ENDREGION}
  TWasmtimeContext = record
  public
    function GetData() : Pointer;
    procedure SetData(data : Pointer);
    procedure ContextGc();
    function AddFuel(fuel : UInt64) : TOwnWasmtimeError;
    procedure FuelConsumed(fuel : PUInt64);
    function SetWasi(wasi : TOwnWasiConfig) : TOwnWasmtimeError;
  end;

{$REGION 'TWasmtimeInterruptHandle'}
(**
 * \typedef wasmtime_interrupt_handle_t
 * \brief Convenience alias for #wasmtime_interrupt_handle_t
 *
 * \struct wasmtime_interrupt_handle_t
 * \brief A handle used to interrupt executing WebAssembly code.
 *
 * This structure is an opaque handle that represents a handle to a store. This
 * handle can be used to remotely (from another thread) interrupt currently
 * executing WebAssembly code.
 *
 * This structure is safe to share from multiple threads.
 *)
{$ENDREGION}
  TWasmtimeInterruptHandle = record
  public
    class function New(context : PWasmtimeContext) : TOwnWasmtimeInterruptHandle; static;
    procedure Interrupt();
  end;

  TWasmtimeCaller = record
  public
    function GetExport(name : UTF8String) : TOwnWasmtimeExtern;
    function Context() : PWasmtimeContext;
  end;

{$REGION 'TWasmtimeExternref'}
(**
 * \typedef wasmtime_externref_t
 * \brief Convenience alias for #wasmtime_externref
 *
 * \struct wasmtime_externref
 * \brief A host-defined un-forgeable reference to pass into WebAssembly.
 *
 * This structure represents an `externref` that can be passed to WebAssembly.
 * It cannot be forged by WebAssembly itself and is guaranteed to have been
 * created by the host.
 *)
{$ENDREGION}
  TWasmtimeExternref = record
  public
    class function New(data : Pointer; finalizer : TWasmFinalizer) : TOwnWasmtimeExternref; static;
    function Data() : Pointer;
    function Clone() : TOwnWasmtimeExternref;
  end;

  TWasmtimeValkind = (WASMTIME_I32, WASMTIME_I64, WASMTIME_F32, WASMTIME_F64, WASMTIME_V128, WASMTIME_FUNCREF, WASMTIME_EXTERNREF);
  TWasmtimeV128 = array[0..15] of Byte;

{$REGION 'TWasmtimeVal'}
(**
 * \typedef wasmtime_val_t
 * \brief Convenience alias for #wasmtime_val_t
 *
 * \union wasmtime_val
 * \brief Container for different kinds of wasm values.
 *
 * Note that this structure may contain an owned value, namely
 * #wasmtime_externref_t, depending on the context in which this is used. APIs
 * which consume a #wasmtime_val_t do not take ownership, but APIs that return
 * #wasmtime_val_t require that #wasmtime_val_delete is called to deallocate
 * the value.
 *)
{$ENDREGION}
  TWasmtimeVal = record
  public
    function Copy() : TOwnWasmtimeVal;
  public
    kind : TWasmtimeValkind;

    case TWasmtimeValkind of
    WASMTIME_I32 : (i32 : Int32);
    WASMTIME_I64 : (i64 : Int64);
    WASMTIME_F32 : (f32 : Single);
    WASMTIME_F64 : (f64 : Double);
    WASMTIME_FUNCREF : (funcref : TWasmtimeFunc);
    WASMTIME_EXTERNREF : (externref : PWasmtimeExternref);
    WASMTIME_V128 : (v128 : TWasmtimeV128);
  end;

  TWasmtimeInstancetype = record
  public
    function GetExports() : TOwnExporttypeVec;
    function AsExterntype() : PWasmExterntype;
  end;

  TWasmtimeExterntype = record helper for TWasmExterntype
    function AsInstancetype() : PWasmtimeInstancetype;
    function AsModuletype() : PWasmtimeModuletype;
  end;

{$REGION 'TWasmtimeLinker'}
(**
 * \typedef wasmtime_linker_t
 * \brief Alias to #wasmtime_linker
 *
 * \struct #wasmtime_linker
 * \brief Object used to conveniently link together and instantiate wasm
 * modules.
 *
 * This type corresponds to the `wasmtime::Linker` type in Rust. This
 * type is intended to make it easier to manage a set of modules that link
 * together, or to make it easier to link WebAssembly modules to WASI.
 *
 * A #wasmtime_linker_t is a higher level way to instantiate a module than
 * #wasm_instance_new since it works at the "string" level of imports rather
 * than requiring 1:1 mappings.
 *)
{$ENDREGION}
  TWasmtimeLinker = record
  public
    class function New(engine : PWasmEngine) : TOwnWasmtimeLinker; static;
    procedure AllowShadowing(allow_shadowing : Boolean);
    function Define(const module_name : string; const name : string; const item : PWasmtimeExtern) : TOwnWasmtimeError;
    function DefineWasi() : TOwnWasmtimeError;
    function DefineInstance(context : PWasmtimeContext; const name : string; const instance : PWasmtimeInstance) : TOwnWasmtimeError;
    function Instantiate(context : PWasmtimeContext; const module : PWasmtimeModule) : TResultWasmtimeInstance;
    function Module(context : PWasmtimeContext; const name : string; const module : PWasmtimeModule) : TOwnWasmtimeError;
    function GetDefault(context : PWasmtimeContext; const name : string) : TResultWasmtimeFunc;
    function Get(context : PWasmtimeContext; const module_name : string; const name : string) : TOwnWasmtimeExtern;
  end;

{$REGION 'TWasmtimeModuletype'}
(**
 * \brief An opaque object representing the type of a module.
 *)
{$ENDREGION}
  TWasmtimeModuletype = record
  public
    function Imports() : TOwnExporttypeVec;
    function AsExterntype() : TOwnExterntype;
  end;


  TWasmtimeConfig = record helper for TWasmConfig
  public
    procedure DebugInfoSet(value : Boolean);
    procedure InterruptableSet(value : Boolean);
    procedure ConsumeFuelSet(value : Boolean);
    procedure MaxWasmStackSet(value : NativeInt);
    procedure WasmThreadsSet(value : Boolean);
    procedure WasmReferebceTypesSet(value : Boolean);
    procedure WasmSimdSet(value : Boolean);
    procedure WasmBulkMemorySet(value : Boolean);
    procedure WasmMultiValueSet(value : Boolean);
    procedure WasmModuleLinkingSet(value : Boolean);
    function StrategySet(value : TWasmtimeStrategy) : TOwnWasmtimeError;
    procedure CraneliftDebugVerifierSet(value : Boolean);
    procedure CraneliftOptLevelSet(value : TWasmtimeOptLevel);
    procedure ProfilerSet(value : TWasmtimeProfilingStrategy);
    procedure StaticMemoryMaximumSizeSet(value : NativeUInt);
    procedure StaticMemoryGuardSizeSet(value : NativeUInt);
    procedure DynamicMemoryGuardSizeSet(value : NativeUInt);
    function CacheConfigLoad(const data : PByte) : TOwnWasmtimeError;

    property DebugInfo : Boolean write DebugInfoSet;
    property Interruptable : Boolean write InterruptableSet;
    property ConsumeFuel : Boolean write ConsumeFuelSet;
    property MaxWasmStack : NativeInt write MaxWasmStackSet;
  end;

  TWasmtimeTrap = record helper for TWasmTrap
    class function New(const msg : string) : TOwnTrap; static;
    function ExitStatus(var status : Int32) : Boolean;
  end;

  TWasmtimeFrame = record helper for TWasmFrame
    function FuncName() : string;
    function ModuleName() : string;
  end;

  // wasmtime_error.h

  TWasmtimeErrorDeleteAPI = procedure(error : PWasmtimeError); cdecl;
  TWasmtimeErrorMessageAPI = procedure(const error : PWasmtimeError; message : PWasmName); cdecl;

  // wasmtime.h

  TWasmtimeWat2WasmAPI = function(const wat : PAnsiChar; wat_len : NativeInt; ret : PWasmByteVec) : PWasmtimeError; cdecl;

  // wasttime_config.h

  //TWamtimeConfig##name##Set = function(config : PWasmConfig; value : ty) : ret; cdecl;
  TWasmtimeConfigDebugInfoSetAPI = procedure(config : PWasmConfig; value : Boolean); cdecl;
  TWasmtimeConfigInterruptableSetAPI = procedure(config : PWasmConfig; value : Boolean); cdecl;
  TWasmtimeConfigConsumeFuelSetAPI = procedure(config : PWasmConfig; value : Boolean); cdecl;
  TWasmtimeConfigMaxWasmStackSetAPI = procedure(config : PWasmConfig; value : NativeInt); cdecl;
  TWasmtimeConfigWasmThreadsSetAPI = procedure(config : PWasmConfig; value : Boolean); cdecl;
  TWasmtimeConfigWasmReferenceTypesSetAPI = procedure(config : PWasmConfig; value : Boolean); cdecl;
  TWasmtimeConfigWasmSimdSetAPI = procedure(config : PWasmConfig; value : Boolean); cdecl;
  TWasmtimeConfigWasmBulkMemorySetAPI = procedure(config : PWasmConfig; value : Boolean); cdecl;
  TWasmtimeConfigWasmMultiValueSetAPI = procedure(config : PWasmConfig; value : Boolean); cdecl;
  TWasmtimeConfigWasmModuleLinkingSetAPI = procedure(config : PWasmConfig; value : Boolean); cdecl;
  TWasmtimeConfigStrategySetAPI = function(config : PWasmConfig; value : TWasmtimeStrategy) : PWasmtimeError; cdecl;
  TWasmtimeConfigCraneliftDebugVerifierSetAPI = procedure(config : PWasmConfig; value : Boolean); cdecl;
  TWasmtimeConfigCraneliftOptLevelSetAPI = procedure(config : PWasmConfig; value : TWasmtimeOptLevel); cdecl;
  TWasmtimeConfigProfilerSetAPI = function(config : PWasmConfig; value : TWasmtimeProfilingStrategy) : PWasmtimeError; cdecl;
  TWasmtimeConfigStaticMemoryMaximumSizeSetAPI = procedure(config : PWasmConfig; value : NativeUInt); cdecl;
  TWasmtimeConfigStaticMemoryGuardSizeSetAPI = procedure(config : PWasmConfig; value : NativeUInt); cdecl;
  TWasmtimeConfigDynamicMemoryGuardSizeSetAPI = procedure(config : PWasmConfig; value : NativeUInt); cdecl;
  TWasmtimeConfigCacheConfigLoadAPI = function(config : PWasmConfig; const data : PByte) : PWasmtimeError; cdecl;

  // wasmtile_extern.h

  TWasmtimeExternDeleteAPI = procedure(val : PWasmtimeExtern); cdecl;
  TWasmtimeExternTypeAPI = function(context : PWasmtimeContext; val : PWasmtimeExtern) : {own} PWasmExterntype; cdecl;

  // wasmtime_func.h

{$REGION 'TWasmtimeFuncNewAPI'}
(**
 * \brief Creates a new host-defined function.
 *
 * Inserts a host-defined function into the `store` provided which can be used
 * to then instantiate a module with or define within a #wasmtime_linker_t.
 *
 * \param store the store in which to create the function
 * \param type the wasm type of the function that's being created
 * \param callback the host-defined callback to invoke
 * \param env host-specific data passed to the callback invocation, can be
 * `NULL`
 * \param finalizer optional finalizer for `env`, can be `NULL`
 * \param ret the #wasmtime_func_t return value to be filled in.
 *
 * The returned function can only be used with the specified `store`.
 *)
{$ENDREGION}
  TWasmtimeFuncNewAPI = procedure(context : PWasmtimeContext; const typ : PWasmFunctype; callback : TWasmtimeFuncCallback; env : Pointer; finalizer : TWasmFinalizer; var ret : TWasmtimeFunc); cdecl;
{$REGION 'TWasmtimeFuncTypeAPI'}
(**
 * \brief Returns the type of the function specified
 *
 * The returned #wasm_functype_t is owned by the caller.
 *)
{$ENDREGION}
  TWasmtimeFuncTypeAPI = function(const context : PWasmtimeContext; const func : PWasmtimeFunc) : PWasmFunctype; cdecl;
{$REGION 'TWasmtimeFuncCallAPI'}
(**
 * \brief Call a WebAssembly function.
 *
 * This function is used to invoke a function defined within a store. For
 * example this might be used after extracting a function from a
 * #wasmtime_instance_t.
 *
 * \param store the store which owns `func`
 * \param func the function to call
 * \param args the arguments to the function call
 * \param nargs the number of arguments provided
 * \param results where to write the results of the function call
 * \param nresults the number of results expected
 * \param trap where to store a trap, if one happens.
 *
 * There are three possible return states from this function:
 *
 * 1. The returned error is non-null. This means `results`
 *    wasn't written to and `trap` will have `NULL` written to it. This state
 *    means that programmer error happened when calling the function, for
 *    example when the size of the arguments/results was wrong, the types of the
 *    arguments were wrong, or arguments may come from the wrong store.
 * 2. The trap pointer is filled in. This means the returned error is `NULL` and
 *    `results` was not written to. This state means that the function was
 *    executing but hit a wasm trap while executing.
 * 3. The error and trap returned are both `NULL` and `results` are written to.
 *    This means that the function call succeeded and the specified results were
 *    produced.
 *
 * The `trap` pointer cannot be `NULL`. The `args` and `results` pointers may be
 * `NULL` if the corresponding length is zero.
 *
 * Does not take ownership of #wasmtime_val_t arguments. Gives ownership of
 * #wasmtime_val_t results.
 *)
{$ENDREGION}
  TWasmtimeFuncCallAPI = function(context : PWasmtimeContext; const func : PWasmtimeFunc; const args : PWasmtimeVal; nargs : NativeUInt; results : PWasmtimeVal; nresults : NativeUInt; trap : PPWasmTrap) : PWasmtimeError; cdecl;

{$REGION 'TWasmtimeCallerExportGetAPI'}
(**
 * \brief Loads a #wasmtime_extern_t from the caller's context
 *
 * This function will attempt to look up the export named `name` on the caller
 * instance provided. If it is found then the #wasmtime_extern_t for that is
 * returned, otherwise `NULL` is returned.
 *
 * Note that this only works for exported memories right now for WASI
 * compatibility.
 *
 * \param caller the caller object to look up the export from
 * \param name the name that's being looked up
 * \param name_len the byte length of `name`
 * \param item where to store the return value
 *
 * Returns a nonzero value if the export was found, or 0 if the export wasn't
 * found. If the export wasn't found then `item` isn't written to.
 *)
{$ENDREGION}
  TWasmtimeCallerExportGetAPI = function(caller : PWasmtimeCaller; const name : PAnsiChar; name_len : NativeUInt; item : PWasmtimeExtern) : Boolean; cdecl;
{$REGION 'TWasmtimeCallerContextAPI'}
(**
 * \brief Returns the store context of the caller object.
 *)
{$ENDREGION}
  TWasmtimeCallerContextAPI = function(caller : PWasmtimeCaller) : PWasmtimeContext; cdecl;

  // wasmtime_global.h

  TWasmtimeGlobalNewAPI = function(context : PWasmtimeContext; const typ : PWasmGlobaltype; const val : PWasmtimeVal; var ret : TWasmtimeGlobal) : PWasmtimeError; cdecl;
  TWasmtimeGlobalTypeAPI = function(const context : PWasmtimeContext; const global : PWasmtimeGlobal) : PWasmGlobaltype; cdecl;
  TWasmtimeGlobalGetAPI = procedure(context : PWasmtimeContext; const global : PWasmtimeGlobal; out_ : PWasmtimeVal); cdecl;
  TWasmtimeGlobalSetAPI = function(context : PWasmtimeContext; const global : PWasmtimeGlobal; val : PWasmtimeVal) : PWasmtimeError; cdecl;

  // wasmtime_instance.h

  TWasmtimeInstancetypeDeleteAPI = procedure(ty : PWasmtimeInstancetype); cdecl;
{$REGION 'TWasmtimeInstancetypeExportsAPI'}
(**
 * \brief Returns the list of exports that this instance type provides.
 *
 * This function does not take ownership of the provided instance type but
 * ownership of `out` is passed to the caller. Note that `out` is treated as
 * uninitialized when passed to this function.
 *)
{$ENDREGION}
  TWasmtimeInstancetypeExportsAPI = procedure(const ty : PWasmtimeInstancetype; {own} out_ : PWasmExporttypeVec); cdecl;
{$REGION 'TWasmtimeInstancetypeAsExterntypeAPI'}
(**
 * \brief Converts a #wasmtime_instancetype_t to a #wasm_externtype_t
 *
 * The returned value is owned by the #wasmtime_instancetype_t argument and should not
 * be deleted.
 *)
{$ENDREGION}
  TWasmtimeInstancetypeAsExterntypeAPI = function(ty : PWasmtimeInstancetype) : PWasmExterntype; cdecl;
{$REGION 'TWasmtimeExterntypeAsInstancetypeAPI'}
(**
 * \brief Attempts to convert a #wasm_externtype_t to a #wasmtime_instancetype_t
 *
 * The returned value is owned by the #wasmtime_instancetype_t argument and should not
 * be deleted. Returns `NULL` if the provided argument is not a
 * #wasmtime_instancetype_t.
 *)
{$ENDREGION}
  TWasmtimeExterntypeAsInstancetypeAPI = function(extern : PWasmExterntype) : PWasmtimeInstancetype; cdecl;

{$REGION 'TWasmtimeInstanceNewAPI'}
(**
 * \brief Instantiate a wasm module.
 *
 * This function will instantiate a WebAssembly module with the provided
 * imports, creating a WebAssembly instance. The returned instance can then
 * afterwards be inspected for exports.
 *
 * \param store the store in which to create the instance
 * \param module the module that's being instantiated
 * \param imports the imports provided to the module
 * \param nimports the size of `imports`
 * \param instance where to store the returned instance
 * \param trap where to store the returned trap
 *
 * This function requires that `imports` is the same size as the imports that
 * `module` has. Additionally the `imports` array must be 1:1 lined up with the
 * imports of the `module` specified. This is intended to be relatively low
 * level, and #wasmtime_linker_instantiate is provided for a more ergonomic
 * name-based resolution API.
 *
 * The states of return values from this function are similar to
 * #wasmtime_func_call where an error can be returned meaning something like a
 * link error in this context. A trap can be returned (meaning no error or
 * instance is returned), or an instance can be returned (meaning no error or
 * trap is returned).
 *
 * Note that this function requires that all `imports` specified must be owned
 * by the `store` provided as well.
 *
 * This function does not take ownership of any of its arguments, but all return
 * values are owned by the caller.
 *)
{$ENDREGION}
  TWasmtimeInstanceNewAPI = function(context : PWasmtimeContext; const module : PWasmtimeModule; const imports : PWasmtimeExtern; nimports : NativeUInt; var instance : TWasmtimeInstance; trap : PPWasmTrap) : PWasmtimeError; cdecl;
{$REGION 'TWasmtimeInstanceTypeAPI'}
(**
 * \brief Returns the type of the specified instance.
 *
 * The returned type is owned by the caller.
 *)
{$ENDREGION}
  TWasmtimeInstanceTypeAPI = function(const context : PWasmtimeContext; const instance : PWasmtimeInstance) : {own} PWasmtimeInstancetype; cdecl;
{$REGION 'TWasmtimeInstanceExportGetAPI'}
(**
 * \brief Get an export by name from an instance.
 *
 * \param store the store that owns `instance`
 * \param instance the instance to lookup within
 * \param name the export name to lookup
 * \param name_len the byte length of `name`
 * \param item where to store the returned value
 *
 * Returns nonzero if the export was found, and `item` is filled in. Otherwise
 * returns 0.
 *
 * Doesn't take ownership of any arguments but does return ownership of the
 * #wasmtime_extern_t.
 *)
{$ENDREGION}
  TWasmtimeInstanceExportGetAPI = function(context : PWasmtimeContext; const instance : PWasmtimeInstance; const name : PAnsiChar; name_len : NativeUInt; var {own} item : TWasmtimeExtern) : Boolean; cdecl;
{$REGION 'TWasmtimeInstanceExportNthAPI'}
(**
 * \brief Get an export by index from an instance.
 *
 * \param store the store that owns `instance`
 * \param instance the instance to lookup within
 * \param index the index to lookup
 * \param name where to store the name of the export
 * \param name_len where to store the byte length of the name
 * \param item where to store the export itself
 *
 * Returns nonzero if the export was found, and `name`, `name_len`, and `item`
 * are filled in. Otherwise returns 0.
 *
 * Doesn't take ownership of any arguments but does return ownership of the
 * #wasmtime_extern_t. The `name` pointer return value is owned by the `store`
 * and must be immediately used before calling any other APIs on
 * #wasmtime_context_t.
 *)
{$ENDREGION}
  TWasmtimeInstanceExportNthAPI = function(context : PWasmtimeContext; const instance : PWasmtimeInstance; index : NativeUint; var out_name : PAnsiChar; var name_len : NativeUInt; var {own} item : TWasmtimeExtern) : Boolean; cdecl;

  // wasmtime_table.h

{$REGION 'TWasmtimeTableNewAPI'}
(**
 * \brief Creates a new host-defined wasm table.
 *
 * \param store the store to create the table within
 * \param ty the type of the table to create
 * \param init the initial value for this table's elements
 * \param table where to store the returned table
 *
 * This function does not take ownership of any of its parameters, but yields
 * ownership of returned error. This function may return an error if the `init`
 * value does not match `ty`, for example.
 *)
{$ENDREGION}
  TWasmtimeTableNewAPI = function(context : PWasmtimeContext; const ty : PWasmTabletype; const init : PWasmtimeVal; var table : TWasmtimeTable) : {own} PWasmtimeError; cdecl;
{$REGION 'TWasmtimeTableTypeAPI'}
(**
 * \brief Returns the type of this table.
 *
 * The caller has ownership of the returned #wasm_tabletype_t
 *)
{$ENDREGION}
  TWasmtimeTableTypeAPI = function(const context : PWasmtimeContext; const table : PWasmtimeTable) : {own} PWasmTabletype; cdecl;
{$REGION 'TWasmtimeTableGetAPI'}
(**
 * \brief Gets a value in a table.
 *
 * \param store the store that owns `table`
 * \param table the table to access
 * \param index the table index to access
 * \param val where to store the table's value
 *
 * This function will attempt to access a table element. If a nonzero value is
 * returned then `val` is filled in and is owned by the caller. Otherwise zero
 * is returned because the `index` is out-of-bounds.
 *)
{$ENDREGION}
  TWasmtimeTableGetAPI = function(context : PWasmtimeContext; const table : PWasmtimeTable; index : UInt32; {own} val : PWasmtimeVal) : Boolean; cdecl;
{$REGION 'TWasmtimeTableSetAPI'}
(**
 * \brief Sets a value in a table.
 *
 * \param store the store that owns `table`
 * \param table the table to write to
 * \param index the table index to write
 * \param value the value to store.
 *
 * This function will store `value` into the specified index in the table. This
 * does not take ownership of any argument but yields ownership of the error.
 * This function can fail if `value` has the wrong type for the table, or if
 * `index` is out of bounds.
 *)
{$ENDREGION}
  TWasmtimeTableSetAPI = function(context : PWasmtimeContext; const table : PWasmtimeTable; index : UInt32; const value : PWasmtimeVal) : {own} PWasmtimeError; cdecl;
{$REGION 'TWasmtimeTableSizeAPI'}
(**
 * \brief Returns the size, in elements, of the specified table
 *)
{$ENDREGION}
  TWasmtimeTableSizeAPI = function(context : PWasmtimeContext; const table : PWasmtimeTable) : UInt32; cdecl;
{$REGION 'TWasmtimeTableGrowAPI'}
(**
 * \brief Grows a table.
 *
 * \param store the store that owns `table`
 * \param table the table to grow
 * \param delta the number of elements to grow the table by
 * \param init the initial value for new table element slots
 * \param prev_size where to store the previous size of the table before growth
 *
 * This function will attempt to grow the table by `delta` table elements. This
 * can fail if `delta` would exceed the maximum size of the table or if `init`
 * is the wrong type for this table. If growth is successful then `NULL` is
 * returned and `prev_size` is filled in with the previous size of the table, in
 * elements, before the growth happened.
 *
 * This function does not take ownership of any of its arguments.
 *)
 {$ENDREGION}
  TWasmtimeTableGrowAPI = function(context : PWasmtimeContext; const table : PWasmtimeTable; delta : UInt32; const init : PWasmtimeVal; prev_size : PUInt32) : {own} PWasmtimeError; cdecl;


  // wasmtime_linker.h

{$REGION 'TWasmtimeLinkerNewAPI'}
(**
 * \brief Creates a new linker for the specified engine.
 *
 * This function does not take ownership of the engine argument, and the caller
 * is expected to delete the returned linker.
 *)
{$ENDREGION}
  TWasmtimeLinkerNewAPI = function(engine : PWasmEngine) : PWasmtimeLinker; cdecl;
{$REGION 'TWasmtimeLinkerDeleteAPI'}
(**
 * \brief Deletes a linker
 *)
{$ENDREGION}
  TWasmtimeLinkerDeleteAPI = procedure(linker : PWasmtimeLinker); cdecl;
{$REGION 'TWasmtimeLinkerAllowShadowingAPI'}
(**
 * \brief Configures whether this linker allows later definitions to shadow
 * previous definitions.
 *
 * By default this setting is `false`.
 *)
{$ENDREGION}
  TWasmtimeLinkerAllowShadowingAPI = procedure(linker : PWasmtimeLinker; allow_shadowing : Boolean); cdecl;
{$REGION 'TWasmtimeLinkerDefineAPI'}
(**
 * \brief Defines a new item in this linker.
 *
 * \param linker the linker the name is being defined in.
 * \param module the module name the item is defined under.
 * \param module_len the byte length of `module`
 * \param name the field name the item is defined under
 * \param name_len the byte length of `name`
 * \param item the item that is being defined in this linker.
 *
 * \return On success `NULL` is returned, otherwise an error is returned which
 * describes why the definition failed.
 *
 * For more information about name resolution consult the [Rust
 * documentation](https://bytecodealliance.github.io/wasmtime/api/wasmtime/struct.Linker.html#name-resolution).
 *)
{$ENDREGION}
  TWasmtimeLinkerDefineAPI = function(linker : PWasmtimeLinker; const module : PAnsiChar; module_len : NativeUInt; const name : PAnsiChar; name_len : NativeUInt; const item : PWasmtimeExtern) : PWasmtimeError; cdecl;
{$REGION 'TWasmtimeLinkerDefineWasiAPI'}
(**
 * \brief Defines WASI functions in this linker.
 *
 * \param linker the linker the name is being defined in.
 *
 * \return On success `NULL` is returned, otherwise an error is returned which
 * describes why the definition failed.
 *
 * This function will provide WASI function names in the specified linker. Note
 * that when an instance is created within a store then the store also needs to
 * have its WASI settings configured with #wasmtime_context_set_wasi for WASI
 * functions to work, otherwise an assert will be tripped that will abort the
 * process.
 *
 * For more information about name resolution consult the [Rust
 * documentation](https://bytecodealliance.github.io/wasmtime/api/wasmtime/struct.Linker.html#name-resolution).
 *)
{$ENDREGION}
  TWasmtimeLinkerDefineWasiAPI = function(linker : PWasmtimeLinker) : PWasmtimeError; cdecl;
{$REGION 'TWasmtimeLinkerDefineInstanceAPI'}
(**
 * \brief Defines an instance under the specified name in this linker.
 *
 * \param linker the linker the name is being defined in.
 * \param store the store that owns `instance`
 * \param name the module name to define `instance` under.
 * \param name_len the byte length of `name`
 * \param instance a previously-created instance.
 *
 * \return On success `NULL` is returned, otherwise an error is returned which
 * describes why the definition failed.
 *
 * This function will take all of the exports of the `instance` provided and
 * defined them under a module called `name` with a field name as the export's
 * own name.
 *
 * For more information about name resolution consult the [Rust
 * documentation](https://bytecodealliance.github.io/wasmtime/api/wasmtime/struct.Linker.html#name-resolution).
 *)
{$ENDREGION}
  TWasmtimeLinkerDefineInstanceAPI = function(linker : PWasmtimeLinker; context : PWasmtimeContext; const name : PAnsiChar; name_len : NativeUInt; const instance : PWasmtimeInstance) : PWasmtimeError; cdecl;
{$REGION 'TWasmtimeLinkerInstantiateAPI'}
(**
 * \brief Instantiates a #wasm_module_t with the items defined in this linker.
 *
 * \param linker the linker used to instantiate the provided module.
 * \param store the store that is used to instantiate within
 * \param module the module that is being instantiated.
 * \param instance the returned instance, if successful.
 * \param trap a trap returned, if the start function traps.
 *
 * \return One of three things can happen as a result of this function. First
 * the module could be successfully instantiated and returned through
 * `instance`, meaning the return value and `trap` are both set to `NULL`.
 * Second the start function may trap, meaning the return value and `instance`
 * are set to `NULL` and `trap` describes the trap that happens. Finally
 * instantiation may fail for another reason, in which case an error is returned
 * and `trap` and `instance` are set to `NULL`.
 *
 * This function will attempt to satisfy all of the imports of the `module`
 * provided with items previously defined in this linker. If any name isn't
 * defined in the linker than an error is returned. (or if the previously
 * defined item is of the wrong type).
 *)
{$ENDREGION}
  TWasmtimeLinkerInstantiateAPI = function(linker : PWasmtimeLinker; context : PWasmtimeContext; const module : PWasmtimeModule; var instance : TWasmtimeInstance; trap : PPWasmTrap) : PWasmtimeError; cdecl;
{$REGION 'TWasmtimeLinkerModuleAPI'}
(**
 * \brief Defines automatic instantiations of a #wasm_module_t in this linker.
 *
 * \param linker the linker the module is being added to
 * \param store the store that is used to instantiate `module`
 * \param name the name of the module within the linker
 * \param name_len the byte length of `name`
 * \param module the module that's being instantiated
 *
 * \return An error if the module could not be instantiated or added or `NULL`
 * on success.
 *
 * This function automatically handles [Commands and
 * Reactors](https://github.com/WebAssembly/WASI/blob/master/design/application-abi.md#current-unstable-abi)
 * instantiation and initialization.
 *
 * For more information see the [Rust
 * documentation](https://bytecodealliance.github.io/wasmtime/api/wasmtime/struct.Linker.html#method.module).
 *)
{$ENDREGION}
  TWasmtimeLinkerModuleAPI = function(linker : PWasmtimeLinker; context : PWasmtimeContext; const name : PAnsiChar; name_len : NativeUInt; const module : PWasmtimeModule) : PWasmtimeError; cdecl;
{$REGION 'TWasmtimeLinkerGetDefaultAPI'}
(**
 * \brief Acquires the "default export" of the named module in this linker.
 *
 * \param linker the linker to load from
 * \param store the store to load a function into
 * \param name the name of the module to get the default export for
 * \param name_len the byte length of `name`
 * \param func where to store the extracted default function.
 *
 * \return An error is returned if the default export could not be found, or
 * `NULL` is returned and `func` is filled in otherwise.
 *
 * For more information see the [Rust
 * documentation](https://bytecodealliance.github.io/wasmtime/api/wasmtime/struct.Linker.html#method.get_default).
 *)
{$ENDREGION}
  TWasmtimeLinkerGetDefaultAPI = function(linker : PWasmtimeLinker; context : PWasmtimeContext; const name : PAnsiChar; name_len : NativeUInt; var func : TWasmtimeFunc) : PWasmtimeError; cdecl;
{$REGION 'TWasmtimeLinkerGetAPI'}
(**
 * \brief Loads an item by name from this linker.
 *
 * \param linker the linker to load from
 * \param store the store to load the item into
 * \param module the name of the module to get
 * \param module_len the byte length of `module`
 * \param name the name of the field to get
 * \param name_len the byte length of `name`
 * \param item where to store the extracted item
 *
 * \return A nonzero value if the item is defined, in which case `item` is also
 * filled in. Otherwise zero is returned.
 *)
{$ENDREGION}
  TWasmtimeLinkerGetAPI = function(linker : PWasmtimeLinker; context : PWasmtimeContext; const module : PAnsiChar; module_len : NativeUInt; const name : PAnsiChar; name_len : NativeUInt; item : PWasmtimeExtern) : Boolean; cdecl;

  // wasmtime_memory.h

{$REGION 'TWasmtimeMemoryNewAPI'}
(**
 * \brief Creates a new WebAssembly linear memory
 *
 * \param store the store to create the memory within
 * \param ty the type of the memory to create
 * \param ret where to store the returned memory
 *
 * If an error happens when creating the memory it's returned and owned by the
 * caller. If an error happens then `ret` is not filled in.
 *)
{$ENDREGION}
  TWasmtimeMemoryNewAPI = function(context : PWasmtimeContext; const ty : PWasmMemorytype; var ret : TWasmtimeMemory) : PWasmtimeError; cdecl;
{$REGION 'TWasmtimeMemoryTypeAPI'}
(**
 * \brief Returns the tyep of the memory specified
 *)
{$ENDREGION}
  TWasmtimeMemoryTypeAPI = function(const context : PWasmtimeContext; const memory : PWasmtimeMemory) : PWasmMemorytype; cdecl;
{$REGION 'TWasmtimeMemoryDataAPI'}
(**
 * \brief Returns the base pointer in memory where the linear memory starts.
 *)
{$ENDREGION}
  TWasmtimeMemoryDataAPI = function(const context : PWasmtimeContext; const memory : PWasmtimeMemory) : PByte; cdecl;
{$REGION 'TWasmtimeMemoryDataSizeAPI'}
(**
 * \brief Returns the byte length of this linear memory.
 *)
{$ENDREGION}
  TWasmtimeMemoryDataSizeAPI = function(const context : PWasmtimeContext; const memory : PWasmtimeMemory) : NativeUInt; cdecl;
{$REGION 'TWasmtimeMemorySizeAPI'}
(**
 * \brief Returns the length, in WebAssembly pages, of this linear memory
 *)
{$ENDREGION}
  TWasmtimeMemorySizeAPI =  function(const context : PWasmtimeContext; const memory : PWasmtimeMemory) : UInt32; cdecl;
{$REGION 'TWasmtimeMemoryGrowAPI'}
(**
 * \brief Attempts to grow the specified memory by `delta` pages.
 *
 * \param store the store that owns `memory`
 * \param memory the memory to grow
 * \param delta the number of pages to grow by
 * \param prev_size where to store the previous size of memory
 *
 * If memory cannot be grown then `prev_size` is left unchanged and an error is
 * returned. Otherwise `prev_size` is set to the previous size of the memory, in
 * WebAssembly pages, and `NULL` is returned.
 *)
{$ENDREGION}
  TWasmtimeMemoryGrowAPI = function(context : PWasmtimeContext; const memory : PWasmtimeMemory; delta : UInt32; prev_size : PUInt32) : PWasmtimeError; cdecl;

  // wasmtime_module.h

{$REGION 'TWasmtimeModuletypeDeleteAPI'}
(**
 * \brief Deletes a module type.
 *)
{$ENDREGION}
  TWasmtimeModuletypeDeleteAPI = procedure(ty : PWasmtimeModuletype); cdecl;
{$REGION 'TWasmtimeModuletypeImportsAPI'}
(**
 * \brief Returns the list of imports that this module type requires.
 *
 * This function does not take ownership of the provided module type but
 * ownership of `out` is passed to the caller. Note that `out` is treated as
 * uninitialized when passed to this function.
 *)
{$ENDREGION}
  TWasmtimeModuletypeImportsAPI = procedure(const ty : PWasmtimeModuletype; out_ : PWasmExporttypeVec); cdecl;
{$REGION 'TWasmtimeModuletypeAsExterntypeAPI'}
(**
 * \brief Returns the list of exports that this module type provides.
 *
 * This function does not take ownership of the provided module type but
 * ownership of `out` is passed to the caller. Note that `out` is treated as
 * uninitialized when passed to this function.
 *)
{$ENDREGION}
  TWasmtimeModuletypeAsExterntypeAPI = function(ty : PWasmtimeModuletype) : PWasmExterntype; cdecl;
{$REGION 'TWasmtimeExterntypeAsModuletypeAPI'}
(**
 * \brief Converts a #wasmtime_moduletype_t to a #wasm_externtype_t
 *
 * The returned value is owned by the #wasmtime_moduletype_t argument and should not
 * be deleted.
 *)
{$ENDREGION}
  TWasmtimeExterntypeAsModuletypeAPI = function(ty : PWasmExterntype) : PWasmtimeModuletype; cdecl;
{$REGION 'TWasmtimeModuleNewAPI'}
(**
 * \brief Compiles a WebAssembly binary into a #wasmtime_module_t
 *
 * This function will compile a WebAssembly binary into an owned #wasm_module_t.
 * This performs the same as #wasm_module_new except that it returns a
 * #wasmtime_error_t type to get richer error information.
 *
 * On success the returned #wasmtime_error_t is `NULL` and the `ret` pointer is
 * filled in with a #wasm_module_t. On failure the #wasmtime_error_t is
 * non-`NULL` and the `ret` pointer is unmodified.
 *
 * This function does not take ownership of any of its arguments, but the
 * returned error and module are owned by the caller.
 *)
{$ENDREGION}
  TWasmtimeModuleNewAPI = function(engine : PWasmEngine; const wasm : PByte; wasm_len : NativeUInt; ret : PPWasmtimeModule) : PWasmtimeError; cdecl;
{$REGION 'TWasmtimeModuleDeleteAPI'}
(**
 * \brief Deletes a module.
 *)
{$ENDREGION}
  TWasmtimeModuleDeleteAPI = procedure(m : PWasmtimeModule); cdecl;
{$REGION 'TWasmtimeModuleCloneAPI'}
(**
 * \brief Creates a shallow clone of the specified module, increasing the
 * internal reference count.
 *)
{$ENDREGION}
  TWasmtimeModuleCloneAPI = function(m : PWasmtimeModule) : PWasmtimeModule; cdecl;
{$REGION 'TWasmtimeModuleValidateAPI'}
(**
 * \brief Validate a WebAssembly binary.
 *
 * This function will validate the provided byte sequence to determine if it is
 * a valid WebAssembly binary within the context of the engine provided.
 *
 * This function does not take ownership of its arguments but the caller is
 * expected to deallocate the returned error if it is non-`NULL`.
 *
 * If the binary validates then `NULL` is returned, otherwise the error returned
 * describes why the binary did not validate.
 *)
{$ENDREGION}
  TWasmtimeModuleValidateAPI = function(engine : PWasmEngine; const wasm : PByte; wasm_len : NativeUInt) : PWasmtimeError; cdecl;
{$REGION 'TWasmtimeModuleTypeAPI'}
(**
 * \brief Returns the type of this module.
 *
 * The returned #wasmtime_moduletype_t is expected to be deallocated by the
 * caller.
 *)
{$ENDREGION}
  TWasmtimeModuleTypeAPI = function(const m : PWasmtimeModule) : PWasmtimeModuletype; cdecl;
{$REGION 'TWasmtimeModuleSerializeAPI'}
(**
 * \brief This function serializes compiled module artifacts as blob data.
 *
 * \param module the module
 * \param ret if the conversion is successful, this byte vector is filled in with
 *   the serialized compiled module.
 *
 * \return a non-null error if parsing fails, or returns `NULL`. If parsing
 * fails then `ret` isn't touched.
 *
 * This function does not take ownership of `module`, and the caller is
 * expected to deallocate the returned #wasmtime_error_t and #wasm_byte_vec_t.
 *)
{$ENDREGION}
  TWasmtimeModuleSerializeAPI= function(module : PWasmtimeModule; ret : PWasmByteVec) : PWasmtimeError; cdecl;
{$REGION 'TWasmtimeModuleDeserializeAPI'}
(**
 * \brief Build a module from serialized data.
 *
 * This function does not take ownership of any of its arguments, but the
 * returned error and module are owned by the caller.
 *
 * This function is not safe to receive arbitrary user input. See the Rust
 * documentation for more information on what inputs are safe to pass in here
 * (e.g. only that of #wasmtime_module_serialize)
 *)
{$ENDREGION}
  TWasmtimeModuleDeserializeAPI = function(engine : PWasmEngine; const bytes : PByte; bytes_len : NativeUInt; ret : PPWasmtimeModule) : PWasmtimeError; cdecl;

  // wasmtime_store.h

{$REGION 'TWasmtimeStoreNewAPI'}
(**
 * \brief Creates a new store within the specified engine.
 *
 * \param engine the compilation environment with configuration this store is
 * connected to
 * \param data user-provided data to store, can later be acquired with
 * #wasmtime_context_get_data.
 * \param finalizer an optional finalizer for `data`
 *
 * This function creates a fresh store with the provided configuration settings.
 * The returned store must be deleted with #wasmtime_store_delete.
 *)
{$ENDREGION}
  TWasmtimeStoreNewAPI = function(engine : PWasmEngine; data : Pointer; finalizer : TWasmFinalizer) : PWasmtimeStore; cdecl;
{$REGION 'TWasmtimeStoreContextAPI'}
(**
 * \brief Returns the interior #wasmtime_context_t pointer to this store
 *)
{$ENDREGION}
  TWasmtimeStoreContextAPI = function(store : PWasmtimeStore) : PWasmtimeContext; cdecl;
{$REGION 'TWasmtimeStoreDeleteAPI'}
(**
 * \brief Deletes a store.
 *)
{$ENDREGION}
  TWasmtimeStoreDeleteAPI = procedure(store : PWasmtimeStore); cdecl;

{$REGION 'TWasmtimeContextGetDataAPI'}
(**
 * \brief Returns the user-specified data associated with the specified store
 *)
{$ENDREGION}
  TWasmtimeContextGetDataAPI = function(const context : PWasmtimeContext) : Pointer; cdecl;
{$REGION 'TWasmtimeContextSetDataAPI'}
(**
 * \brief Overwrites the user-specified data associated with this store.
 *
 * Note that this does not execute the original finalizer for the provided data,
 * and the original finalizer will be executed for the provided data when the
 * store is deleted.
 *)
{$ENDREGION}
  TWasmtimeContextSetDataAPI = procedure(context : PWasmtimeContext; data : Pointer); cdecl;
{$REGION 'TWasmtimeContextGcAPI'}
(**
 * \brief Perform garbage collection within the given context.
 *
 * Garbage collects `externref`s that are used within this store. Any
 * `externref`s that are discovered to be unreachable by other code or objects
 * will have their finalizers run.
 *
 * The `context` argument must not be NULL.
 *)
{$ENDREGION}
  TWasmtimeContextGcAPI = procedure(context : PWasmtimeContext); cdecl;
{$REGION 'TWasmtimeContextAddFuelAPI'}
(**
 * \brief Adds fuel to this context's store for wasm to consume while executing.
 *
 * For this method to work fuel consumption must be enabled via
 * #wasmtime_config_consume_fuel_set. By default a store starts with 0 fuel
 * for wasm to execute with (meaning it will immediately trap).
 * This function must be called for the store to have
 * some fuel to allow WebAssembly to execute.
 *
 * Note that at this time when fuel is entirely consumed it will cause
 * wasm to trap. More usages of fuel are planned for the future.
 *
 * If fuel is not enabled within this store then an error is returned. If fuel
 * is successfully added then NULL is returned.
 *)
{$ENDREGION}
  TWasmtimeContextAddFuelAPI = function(context : PWasmtimeContext; fuel : UInt64) : PWasmtimeError; cdecl;
{$REGION 'TWasmtimeContextFuelConsumedAPI'}
(**
 * \brief Returns the amount of fuel consumed by this context's store execution
 * so far.
 *
 * If fuel consumption is not enabled via #wasmtime_config_consume_fuel_set
 * then this function will return false. Otherwise true is returned and the
 * fuel parameter is filled in with fuel consuemd so far.
 *
 * Also note that fuel, if enabled, must be originally configured via
 * #wasmtime_context_add_fuel.
 *)
{$ENDREGION}
  TWasmtimeContextFuelConsumedAPI = procedure(const context : PWasmtimeContext; fuel : PUInt64); cdecl;
{$REGION 'TWasmtimeContextSetWasiAPI'}
(**
 * \brief Configres WASI state within the specified store.
 *
 * This function is required if #wasmtime_linker_define_wasi is called. This
 * will configure the WASI state for instances defined within this store to the
 * configuration specified.
 *
 * This function does not take ownership of `context` but it does take ownership
 * of `wasi`. The caller should no longer use `wasi` after calling this function
 * (even if an error is returned).
 *)
{$ENDREGION}
  TWasmtimeContextSetWasiAPI = function(context : PWasmtimeContext; {own} wasi : PWasiConfig) : PWasmtimeError;

{$REGION 'TWasmtimeInterruptHandleNewAPI'}
(**
 * \brief Creates a new interrupt handle to interrupt executing WebAssembly from
 * the provided store.
 *
 * There are a number of caveats about how interrupt is handled in Wasmtime. For
 * more information see the [Rust
 * documentation](https://bytecodealliance.github.io/wasmtime/api/wasmtime/struct.Store.html#method.interrupt_handle).
 *
 * This function returns `NULL` if the store's configuration does not have
 * interrupts enabled. See #wasmtime_config_interruptable_set.
 *)
{$ENDREGION}
  TWasmtimeInterruptHandleNewAPI = function(context : PWasmtimeContext) : PWasmtimeInterruptHandle; cdecl;
{$REGION 'TWasmtimeInterruptHandleInterruptAPI'}
(**
 * \brief Requests that WebAssembly code running in the store attached to this
 * interrupt handle is interrupted.
 *
 * For more information about interrupts see #wasmtime_interrupt_handle_new.
 *
 * Note that this is safe to call from any thread.
 *)
{$ENDREGION}
  TWasmtimeInterruptHandleInterruptAPI = procedure(handle : PWasmtimeInterruptHandle); cdecl;
{$REGION 'TWasmtimeInterruptHandleDeleteAPI'}
(**
 * \brief Deletes an interrupt handle.
 *)
{$ENDREGION}
  TWasmtimeInterruptHandleDeleteAPI = procedure(handle : PWasmtimeInterruptHandle); cdecl;

  // wasmtime_trap.h

{$REGION 'TWasmtimeTrapNewAPI'}
(**
 * \brief Attempts to extract a WASI-specific exit status from this trap.
 *
 * Returns `true` if the trap is a WASI "exit" trap and has a return status. If
 * `true` is returned then the exit status is returned through the `status`
 * pointer. If `false` is returned then this is not a wasi exit trap.
 *)
{$ENDREGION}
  TWasmtimeTrapNewAPI = function(const msg : PAnsiChar; msg_len : NativeUInt) : PWasmTrap; cdecl;
{$REGION 'TWasmtimeTrapExitStatusAPI'}
(**
 * \brief Attempts to extract a WASI-specific exit status from this trap.
 *
 * Returns `true` if the trap is a WASI "exit" trap and has a return status. If
 * `true` is returned then the exit status is returned through the `status`
 * pointer. If `false` is returned then this is not a wasi exit trap.
 *)
{$ENDREGION}
  TWasmtimeTrapExitStatusAPI = function(const trap : PWasmTrap; var status : Int32) : Boolean; cdecl;
{$REGION 'TWasmtimeFrameFuncNameAPI'}
(**
 * \brief Returns a human-readable name for this frame's function.
 *
 * This function will attempt to load a human-readable name for function this
 * frame points to. This function may return `NULL`.
 *
 * The lifetime of the returned name is the same as the #wasm_frame_t itself.
 *)
{$ENDREGION}
  TWasmtimeFrameFuncNameAPI = function(const frame : PWasmFrame) : PWasmName; cdecl;
{$REGION 'TWasmtimeFrameModuleNameAPI'}
(**
 * \brief Returns a human-readable name for this frame's module.
 *
 * This function will attempt to load a human-readable name for module this
 * frame points to. This function may return `NULL`.
 *
 * The lifetime of the returned name is the same as the #wasm_frame_t itself.
 *)
{$ENDREGION}
  TWasmtimeFrameModuleNameAPI = function(const frame : PWasmFrame) : PWasmName; cdecl;

  // wasmtime_val.h

{$REGION 'TWasmtimeExternrefNewAPI'}
(**
 * \brief Create a new `externref` value.
 *
 * Creates a new `externref` value wrapping the provided data, returning the
 * pointer to the externref.
 *
 * \param data the host-specific data to wrap
 * \param finalizer an optional finalizer for `data`
 *
 * When the reference is reclaimed, the wrapped data is cleaned up with the
 * provided `finalizer`.
 *
 * The returned value must be deleted with #wasmtime_externref_delete
 *)
{$ENDREGION}
  TWasmtimeExternrefNewAPI = function(data : Pointer; finalizer : TWasmFinalizer) : PWasmtimeExternref; cdecl;
{$REGION 'TWasmtimeExternrefDataAPI'}
(**
 * \brief Get an `externref`'s wrapped data
 *
 * Returns the original `data` passed to #wasmtime_externref_new. It is required
 * that `data` is not `NULL`.
 *)
{$ENDREGION}
  TWasmtimeExternrefDataAPI = function(data : PWasmtimeExternref) : Pointer; cdecl;
{$REGION 'TWasmtimeExternrefCloneAPI'}
(**
 * \brief Creates a shallow copy of the `externref` argument, returning a
 * separately owned pointer (increases the reference count).
 *)
{$ENDREGION}
  TWasmtimeExternrefCloneAPI = function(ref : PWasmtimeExternref) : PWasmtimeExternref; cdecl;
{$REGION 'TWasmtimeExternrefDeleteAPI'}
(**
 * \brief Decrements the reference count of the `ref`, deleting it if it's the
 * last reference.
 *)
{$ENDREGION}
  TWasmtimeExternrefDeleteAPI = procedure(ref : PWasmtimeExternref); cdecl;

{$REGION 'TWasmtimeValDeleteAPI'}
(**
 * \brief Delets an owned #wasmtime_val_t.
 *
 * Note that this only deletes the contents, not the memory that `val` points to
 * itself (which is owned by the caller).
 *)
{$ENDREGION}
  TWasmtimeValDeleteAPI = procedure(val : PWasmtimeVal); cdecl;
{$REGION 'TWasmtimeValCopyAPI'}
(**
 * \brief Copies `src` into `dst`.
 *)
{$ENDREGION}
  TWasmtimeValCopyAPI = procedure(dst : PWasmtimeVal; const src : PWasmtimeVal); cdecl;

  TWasmtime = record
  public class var
    wat2wasm : TWasmtimeWat2WasmAPI;
    table_new : TWasmtimeTableNewAPI;
    table_type : TWasmtimeTableTypeAPI;
    table_get : TWasmtimeTableGetAPI;
    table_set : TWasmtimeTableSetAPI;
    table_size : TWasmtimeTableSizeAPI;
    table_grow : TWasmtimeTableGrowAPI;
    config_debug_info_set : TWasmtimeConfigDebugInfoSetAPI;
    config_interruptable_set : TWasmtimeConfigInterruptableSetAPI;
    config_consume_fuel_set : TWasmtimeConfigConsumeFuelSetAPI;
    config_max_wasm_stack_set : TWasmtimeConfigMaxWasmStackSetAPI;
    config_wasm_threads_set : TWasmtimeConfigWasmThreadsSetAPI;
    config_wasm_reference_types_set : TWasmtimeConfigWasmReferenceTypesSetAPI;
    config_wasm_simd_set : TWasmtimeConfigWasmSimdSetAPI;
    config_wasm_bulk_memory_set : TWasmtimeConfigWasmBulkMemorySetAPI;
    config_wasm_multi_value_set : TWasmtimeConfigWasmMultiValueSetAPI;
    config_wasm_module_linking_set : TWasmtimeConfigWasmModuleLinkingSetAPI;
    config_strategy_set : TWasmtimeConfigStrategySetAPI;
    config_cranelift_debug_verifier_set : TWasmtimeConfigCraneliftDebugVerifierSetAPI;
    config_cranelift_opt_level_set : TWasmtimeConfigCraneliftOptLevelSetAPI;
    config_profiler_set : TWasmtimeConfigProfilerSetAPI;
    config_static_memory_maximum_size_set : TWasmtimeConfigStaticMemoryMaximumSizeSetAPI;
    config_static_memory_guard_size_set : TWasmtimeConfigStaticMemoryGuardSizeSetAPI;
    config_dynamic_memory_guard_size_set : TWasmtimeConfigDynamicMemoryGuardSizeSetAPI;
    config_cache_config_load : TWasmtimeConfigCacheConfigLoadAPI;
    error_delete : TWasmtimeErrorDeleteAPI;
    error_message : TWasmtimeErrorMessageAPI;
    extern_delete : TWasmtimeExternDeleteAPI;
    extern_type : TWasmtimeExternTypeAPI;
    func_new : TWasmtimeFuncNewAPI;
    func_type : TWasmtimeFuncTypeAPI;
    func_call : TWasmtimeFuncCallAPI;
    caller_export_get : TWasmtimeCallerExportGetAPI;
    caller_context : TWasmtimeCallerContextAPI;
    global_new : TWasmtimeGlobalNewAPI;
    global_type : TWasmtimeGlobalTypeAPI;
    global_get : TWasmtimeGlobalGetAPI;
    global_set : TWasmtimeGlobalSetAPI;
    instancetype_delete : TWasmtimeInstancetypeDeleteAPI;
    instancetype_exports : TWasmtimeInstancetypeExportsAPI;
    instancetype_as_externtype : TWasmtimeInstancetypeAsExterntypeAPI;
    externtype_as_instancetype : TWasmtimeExterntypeAsInstancetypeAPI;
    instance_new : TWasmtimeInstanceNewAPI;
    instance_type : TWasmtimeInstanceTypeAPI;
    instance_export_get : TWasmtimeInstanceExportGetAPI;
    instance_export_nth : TWasmtimeInstanceExportNthAPI;
    linker_new : TWasmtimeLinkerNewAPI;
    linker_delete : TWasmtimeLinkerDeleteAPI;
    linker_allow_shadowing : TWasmtimeLinkerAllowShadowingAPI;
    linker_define : TWasmtimeLinkerDefineAPI;
    linker_define_wasi : TWasmtimeLinkerDefineWasiAPI;
    linker_define_instance : TWasmtimeLinkerDefineInstanceAPI;
    linker_instantiate : TWasmtimeLinkerInstantiateAPI;
    linker_module : TWasmtimeLinkerModuleAPI;
    linker_get_default : TWasmtimeLinkerGetDefaultAPI;
    linker_get : TWasmtimeLinkerGetAPI;
    memory_new : TWasmtimeMemoryNewAPI;
    memory_type : TWasmtimeMemoryTypeAPI;
    memory_data : TWasmtimeMemoryDataAPI;
    memory_data_size : TWasmtimeMemoryDataSizeAPI;
    memory_size : TWasmtimeMemorySizeAPI;
    memory_grow : TWasmtimeMemoryGrowAPI;
    moduletype_delete : TWasmtimeModuletypeDeleteAPI;
    moduletype_imports : TWasmtimeModuletypeImportsAPI;
    moduletype_as_externtype : TWasmtimeModuletypeAsExterntypeAPI;
    externtype_as_moduletype : TWasmtimeExterntypeAsModuletypeAPI;
    module_new : TWasmtimeModuleNewAPI;
    module_delete : TWasmtimeModuleDeleteAPI;
    module_clone : TWasmtimeModuleCloneAPI;
    module_validate : TWasmtimeModuleValidateAPI;
    module_type : TWasmtimeModuleTypeAPI;
    module_serialize : TWasmtimeModuleSerializeAPI;
    module_deserialize : TWasmtimeModuleDeserializeAPI;
    store_new : TWasmtimeStoreNewAPI;
    store_context : TWasmtimeStoreContextAPI;
    store_delete : TWasmtimeStoreDeleteAPI;
    context_get_data : TWasmtimeContextGetDataAPI;
    context_set_data : TWasmtimeContextSetDataAPI;
    context_gc : TWasmtimeContextGcAPI;
    context_add_fuel : TWasmtimeContextAddFuelAPI;
    context_fuel_consume : TWasmtimeContextFuelConsumedAPI;
    context_set_wasi : TWasmtimeContextSetWasiAPI;
    interrupt_handle_new : TWasmtimeInterruptHandleNewAPI;
    interrupt_handle_interrupt : TWasmtimeInterruptHandleInterruptAPI;
    interrupt_handle_delete : TWasmtimeInterruptHandleDeleteAPI;
    trap_new : TWasmtimeTrapNewAPI;
    trap_exit_status : TWasmtimeTrapExitStatusAPI;
    frame_func_name : TWasmtimeFrameFuncNameAPI;
    frame_module_name : TWasmtimeFrameModuleNameAPI;
    externref_new : TWasmtimeExternrefNewAPI;
    externref_data : TWasmtimeExternrefDataAPI;
    externref_clone : TWasmtimeExternrefCloneAPI;
    externref_delete : TWasmtimeExternrefDeleteAPI;
    val_delete : TWasmtimeValDeleteAPI;
    val_copy : TWasmtimeValCopyAPI;

  public
    class procedure Init(dll_name : string); static;
    class procedure InitAPIs(runtime : HMODULE); static;
  end;

implementation
uses
  Windows;

var
  wasmtime_runtime : HMODULE;

class procedure TWasmtime.Init(dll_name: string);
begin
  wasmtime_runtime := LoadLibrary(PWideChar(dll_name));
  InitAPIs(wasmtime_runtime);
  TWasm.InitAPIs(wasmtime_runtime);
  TWasi.InitAPIs(wasmtime_runtime);
end;

class procedure TWasmtime.InitAPIs(runtime : HMODULE);
  function ProcAddress(name : string) : Pointer;
  begin
    result := GetProcAddress(runtime, PWideChar(name));
  end;

begin

  if runtime <> 0 then
  begin
    wat2wasm := ProcAddress('wasmtime_wat2wasm');
    table_new := ProcAddress('wasmtime_table_new');
    table_type := ProcAddress('wasmtime_table_type');
    table_get := ProcAddress('wasmtime_table_get');
    table_set := ProcAddress('wasmtime_table_set');
    table_size := ProcAddress('wasmtime_table_size');
    table_grow := ProcAddress('wasmtime_table_grow');
    config_debug_info_set := ProcAddress('wasmtime_config_debug_info_set');
    config_interruptable_set := ProcAddress('wasmtime_config_interruptable_set');
    config_consume_fuel_set := ProcAddress('wasmtime_config_consume_fuel_set');
    config_max_wasm_stack_set := ProcAddress('wasmtime_config_max_wasm_stack_set');
    config_wasm_threads_set := ProcAddress('wasmtime_config_wasm_threads_set');
    config_wasm_reference_types_set := ProcAddress('wasmtime_config_wasm_reference_types_set');
    config_wasm_simd_set := ProcAddress('wasmtime_config_wasm_simd_set');
    config_wasm_bulk_memory_set := ProcAddress('wasmtime_config_wasm_bulk_memory_set');
    config_wasm_multi_value_set := ProcAddress('wasmtime_config_wasm_multi_value_set');
    config_wasm_module_linking_set := ProcAddress('wasmtime_config_wasm_module_linking_set');
    config_strategy_set := ProcAddress('wasmtime_config_strategy_set');
    config_cranelift_debug_verifier_set := ProcAddress('wasmtime_config_cranelift_debug_verifier_set');
    config_cranelift_opt_level_set := ProcAddress('wasmtime_config_cranelift_opt_level_set');
    config_profiler_set := ProcAddress('wasmtime_config_profiler_set');
    config_static_memory_maximum_size_set := ProcAddress('wasmtime_config_static_memory_maximum_size_set');
    config_static_memory_guard_size_set := ProcAddress('wasmtime_config_static_memory_guard_size_set');
    config_dynamic_memory_guard_size_set := ProcAddress('wasmtime_config_dynamic_memory_guard_size_set');
    config_cache_config_load := ProcAddress('wasmtime_config_cache_config_load');
    error_delete := ProcAddress('wasmtime_error_delete');
    error_message := ProcAddress('wasmtime_error_message');
    extern_delete := ProcAddress('wasmtime_extern_delete');
    extern_type := ProcAddress('wasmtime_extern_type');
    func_new := ProcAddress('wasmtime_func_new');
    func_type := ProcAddress('wasmtime_func_type');
    func_call := ProcAddress('wasmtime_func_call');
    caller_export_get := ProcAddress('wasmtime_caller_export_get');
    caller_context := ProcAddress('wasmtime_caller_context');
    global_new := ProcAddress('wasmtime_global_new');
    global_type := ProcAddress('wasmtime_global_type');
    global_get := ProcAddress('wasmtime_global_get');
    global_set := ProcAddress('wasmtime_global_set');
    instancetype_delete := ProcAddress('wasmtime_instancetype_delete');
    instancetype_exports := ProcAddress('wasmtime_instancetype_exports');
    instancetype_as_externtype := ProcAddress('wasmtime_instancetype_as_externtype');
    externtype_as_instancetype := ProcAddress('wasmtime_externtype_as_instancetype');
    instance_new := ProcAddress('wasmtime_instance_new');
    instance_type := ProcAddress('wasmtime_instance_type');
    instance_export_get := ProcAddress('wasmtime_instance_export_get');
    instance_export_nth := ProcAddress('wasmtime_instance_export_nth');
    linker_new  := ProcAddress('wasmtime_linker_new');
    linker_delete  := ProcAddress('wasmtime_linker_delete');
    linker_allow_shadowing  := ProcAddress('wasmtime_linker_allow_shadowing');
    linker_define := ProcAddress('wasmtime_linker_define');
    linker_define_wasi := ProcAddress('wasmtime_linker_define_wasi');
    linker_define_instance := ProcAddress('wasmtime_linker_define_instance');
    linker_instantiate := ProcAddress('wasmtime_linker_instantiate');
    linker_module := ProcAddress('wasmtime_linker_module');
    linker_get_default := ProcAddress('wasmtime_linker_get_default');
    linker_get := ProcAddress('wasmtime_linker_get');
    memory_new := ProcAddress('wasmtime_memory_new');
    memory_type := ProcAddress('wasmtime_memory_type');
    memory_data := ProcAddress('wasmtime_memory_data');
    memory_data_size := ProcAddress('wasmtime_memory_data_size');
    memory_size := ProcAddress('wasmtime_memory_size');
    memory_grow := ProcAddress('wasmtime_memory_grow');
    moduletype_delete := ProcAddress('wasmtime_moduletype_delete');
    moduletype_imports := ProcAddress('wasmtime_moduletype_imports');
    moduletype_as_externtype := ProcAddress('wasmtime_moduletype_as_externtype');
    externtype_as_moduletype := ProcAddress('wasmtime_externtype_as_moduletype');
    module_new := ProcAddress('wasmtime_module_new');
    module_delete := ProcAddress('wasmtime_module_delete');
    module_clone := ProcAddress('wasmtime_module_clone');
    module_validate := ProcAddress('wasmtime_module_validate');
    module_type := ProcAddress('wasmtime_module_type');
    module_serialize := ProcAddress('wasmtime_module_serialize');
    module_deserialize := ProcAddress('wasmtime_module_deserialize');
    store_new := ProcAddress('wasmtime_store_new');
    store_context := ProcAddress('wasmtime_store_context');
    store_delete := ProcAddress('wasmtime_store_delete');
    context_get_data := ProcAddress('wasmtime_context_get_data');
    context_set_data := ProcAddress('wasmtime_context_set_data');
    context_gc := ProcAddress('wasmtime_context_gc');
    context_add_fuel := ProcAddress('wasmtime_context_add_fuel');
    context_fuel_consume := ProcAddress('wasmtime_context_fuel_consume');
    context_set_wasi := ProcAddress('wasmtime_context_set_wasi');
    interrupt_handle_new := ProcAddress('wasmtime_interrupt_handle_new');
    interrupt_handle_interrupt := ProcAddress('wasmtime_interrupt_handle_interrupt');
    interrupt_handle_delete := ProcAddress('wasmtime_interrupt_handle_delete');
    trap_new := ProcAddress('wasmtime_trap_new');
    trap_exit_status := ProcAddress('wasmtime_trap_exit_status');
    frame_func_name := ProcAddress('wasmtime_frame_func_name');
    frame_module_name := ProcAddress('wasmtime_frame_module_name');
    externref_new := ProcAddress('wasmtime_extenref_new');
    externref_data := ProcAddress('wasmtime_externref_data');
    externref_clone := ProcAddress('wasmtime_externref_clone');
    externref_delete := ProcAddress('wasmtime_externref_delete');
    val_delete := ProcAddress('wasmtime_val_delete');
    val_copy := ProcAddress('wasmtime_val_copy');
  end;
end;


procedure wasmtime_extern_disposer_host(p : Pointer);
begin
  TWasmtime.extern_delete(p);
  Dispose(p);
end;

procedure wasmtime_val_disposer_host(p : Pointer);
begin
  TWasmtime.val_delete(p);
  Dispose(p);
end;

// [OwnImplBegin]

{ TOwnWasmtimeError }

procedure wasmtime_error_disposer(p : Pointer);
begin
  TWasmtime.error_delete(p);
end;

class operator TOwnWasmtimeError.Finalize(var Dest: TOwnWasmtimeError);
begin
  Dest.FStrongRef := nil;
end;

function TOwnWasmtimeError.IsError: Boolean;
begin
  result := FStrongRef <> nil;
end;

function TOwnWasmtimeError.IsError(proc : TWasmUnwrapProc<PWasmtimeError>) : Boolean;
begin
  result := FStrongRef <> nil;
  if result then proc(Unwrap);
end;


function TOwnWasmtimeError.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmtimeError.Negative(Src: TOwnWasmtimeError): IRcContainer<PWasmtimeError>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmtimeError.Positive(Src: TOwnWasmtimeError): PWasmtimeError;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmtimeError.Implicit(const Src : IRcContainer<PWasmtimeError>) : TOwnWasmtimeError;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmtimeError.Unwrap: PWasmtimeError;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmtimeError.Wrap(p : PWasmtimeError) : TOwnWasmtimeError;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeError>.Create(p, wasmtime_error_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasmtimeError.Wrap(p : PWasmtimeError; deleter : TRcDeleter) : TOwnWasmtimeError;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeError>.Create(p, deleter)
  else result.FStrongRef := nil;
end;

{ TOwnWasmtimeExtern }

procedure wasmtime_extern_disposer(p : Pointer);
begin
  TWasmtime.extern_delete(p);
end;

class operator TOwnWasmtimeExtern.Finalize(var Dest: TOwnWasmtimeExtern);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmtimeExtern.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmtimeExtern.Negative(Src: TOwnWasmtimeExtern): IRcContainer<PWasmtimeExtern>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmtimeExtern.Positive(Src: TOwnWasmtimeExtern): PWasmtimeExtern;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmtimeExtern.Implicit(const Src : IRcContainer<PWasmtimeExtern>) : TOwnWasmtimeExtern;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmtimeExtern.Unwrap: PWasmtimeExtern;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmtimeExtern.Wrap(p : PWasmtimeExtern) : TOwnWasmtimeExtern;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeExtern>.Create(p, wasmtime_extern_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasmtimeExtern.Wrap(p : PWasmtimeExtern; deleter : TRcDeleter) : TOwnWasmtimeExtern;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeExtern>.Create(p, deleter)
  else result.FStrongRef := nil;
end;

{ TOwnWasmtimeModule }

procedure wasmtime_module_disposer(p : Pointer);
begin
  TWasmtime.module_delete(p);
end;

class operator TOwnWasmtimeModule.Finalize(var Dest: TOwnWasmtimeModule);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmtimeModule.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmtimeModule.Negative(Src: TOwnWasmtimeModule): IRcContainer<PWasmtimeModule>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmtimeModule.Positive(Src: TOwnWasmtimeModule): PWasmtimeModule;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmtimeModule.Implicit(const Src : IRcContainer<PWasmtimeModule>) : TOwnWasmtimeModule;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmtimeModule.Unwrap: PWasmtimeModule;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmtimeModule.Wrap(p : PWasmtimeModule) : TOwnWasmtimeModule;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeModule>.Create(p, wasmtime_module_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasmtimeModule.Wrap(p : PWasmtimeModule; deleter : TRcDeleter) : TOwnWasmtimeModule;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeModule>.Create(p, deleter)
  else result.FStrongRef := nil;
end;

{ TOwnWasmtimeStore }

procedure wasmtime_store_disposer(p : Pointer);
begin
  TWasmtime.store_delete(p);
end;

class operator TOwnWasmtimeStore.Finalize(var Dest: TOwnWasmtimeStore);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmtimeStore.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmtimeStore.Negative(Src: TOwnWasmtimeStore): IRcContainer<PWasmtimeStore>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmtimeStore.Positive(Src: TOwnWasmtimeStore): PWasmtimeStore;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmtimeStore.Implicit(const Src : IRcContainer<PWasmtimeStore>) : TOwnWasmtimeStore;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmtimeStore.Unwrap: PWasmtimeStore;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmtimeStore.Wrap(p : PWasmtimeStore) : TOwnWasmtimeStore;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeStore>.Create(p, wasmtime_store_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasmtimeStore.Wrap(p : PWasmtimeStore; deleter : TRcDeleter) : TOwnWasmtimeStore;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeStore>.Create(p, deleter)
  else result.FStrongRef := nil;
end;

{ TOwnWasmtimeInterruptHandle }

procedure wasmtime_interrupt_handle_disposer(p : Pointer);
begin
  TWasmtime.interrupt_handle_delete(p);
end;

class operator TOwnWasmtimeInterruptHandle.Finalize(var Dest: TOwnWasmtimeInterruptHandle);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmtimeInterruptHandle.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmtimeInterruptHandle.Negative(Src: TOwnWasmtimeInterruptHandle): IRcContainer<PWasmtimeInterruptHandle>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmtimeInterruptHandle.Positive(Src: TOwnWasmtimeInterruptHandle): PWasmtimeInterruptHandle;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmtimeInterruptHandle.Implicit(const Src : IRcContainer<PWasmtimeInterruptHandle>) : TOwnWasmtimeInterruptHandle;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmtimeInterruptHandle.Unwrap: PWasmtimeInterruptHandle;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmtimeInterruptHandle.Wrap(p : PWasmtimeInterruptHandle) : TOwnWasmtimeInterruptHandle;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeInterruptHandle>.Create(p, wasmtime_interrupt_handle_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasmtimeInterruptHandle.Wrap(p : PWasmtimeInterruptHandle; deleter : TRcDeleter) : TOwnWasmtimeInterruptHandle;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeInterruptHandle>.Create(p, deleter)
  else result.FStrongRef := nil;
end;

{ TOwnWasmtimeExternref }

procedure wasmtime_externref_disposer(p : Pointer);
begin
  TWasmtime.externref_delete(p);
end;

class operator TOwnWasmtimeExternref.Finalize(var Dest: TOwnWasmtimeExternref);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmtimeExternref.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmtimeExternref.Negative(Src: TOwnWasmtimeExternref): IRcContainer<PWasmtimeExternref>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmtimeExternref.Positive(Src: TOwnWasmtimeExternref): PWasmtimeExternref;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmtimeExternref.Implicit(const Src : IRcContainer<PWasmtimeExternref>) : TOwnWasmtimeExternref;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmtimeExternref.Unwrap: PWasmtimeExternref;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmtimeExternref.Wrap(p : PWasmtimeExternref) : TOwnWasmtimeExternref;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeExternref>.Create(p, wasmtime_externref_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasmtimeExternref.Wrap(p : PWasmtimeExternref; deleter : TRcDeleter) : TOwnWasmtimeExternref;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeExternref>.Create(p, deleter)
  else result.FStrongRef := nil;
end;

{ TOwnWasmtimeVal }

procedure wasmtime_val_disposer(p : Pointer);
begin
  TWasmtime.val_delete(p);
end;

class operator TOwnWasmtimeVal.Finalize(var Dest: TOwnWasmtimeVal);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmtimeVal.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmtimeVal.Negative(Src: TOwnWasmtimeVal): IRcContainer<PWasmtimeVal>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmtimeVal.Positive(Src: TOwnWasmtimeVal): PWasmtimeVal;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmtimeVal.Implicit(const Src : IRcContainer<PWasmtimeVal>) : TOwnWasmtimeVal;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmtimeVal.Unwrap: PWasmtimeVal;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmtimeVal.Wrap(p : PWasmtimeVal) : TOwnWasmtimeVal;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeVal>.Create(p, wasmtime_val_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasmtimeVal.Wrap(p : PWasmtimeVal; deleter : TRcDeleter) : TOwnWasmtimeVal;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeVal>.Create(p, deleter)
  else result.FStrongRef := nil;
end;

{ TOwnWasmtimeInstancetype }

procedure wasmtime_instancetype_disposer(p : Pointer);
begin
  TWasmtime.instancetype_delete(p);
end;

class operator TOwnWasmtimeInstancetype.Finalize(var Dest: TOwnWasmtimeInstancetype);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmtimeInstancetype.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmtimeInstancetype.Negative(Src: TOwnWasmtimeInstancetype): IRcContainer<PWasmtimeInstancetype>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmtimeInstancetype.Positive(Src: TOwnWasmtimeInstancetype): PWasmtimeInstancetype;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmtimeInstancetype.Implicit(const Src : IRcContainer<PWasmtimeInstancetype>) : TOwnWasmtimeInstancetype;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmtimeInstancetype.Unwrap: PWasmtimeInstancetype;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmtimeInstancetype.Wrap(p : PWasmtimeInstancetype) : TOwnWasmtimeInstancetype;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeInstancetype>.Create(p, wasmtime_instancetype_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasmtimeInstancetype.Wrap(p : PWasmtimeInstancetype; deleter : TRcDeleter) : TOwnWasmtimeInstancetype;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeInstancetype>.Create(p, deleter)
  else result.FStrongRef := nil;
end;

{ TOwnWasmtimeLinker }

procedure wasmtime_linker_disposer(p : Pointer);
begin
  TWasmtime.linker_delete(p);
end;

class operator TOwnWasmtimeLinker.Finalize(var Dest: TOwnWasmtimeLinker);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmtimeLinker.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmtimeLinker.Negative(Src: TOwnWasmtimeLinker): IRcContainer<PWasmtimeLinker>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmtimeLinker.Positive(Src: TOwnWasmtimeLinker): PWasmtimeLinker;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmtimeLinker.Implicit(const Src : IRcContainer<PWasmtimeLinker>) : TOwnWasmtimeLinker;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmtimeLinker.Unwrap: PWasmtimeLinker;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmtimeLinker.Wrap(p : PWasmtimeLinker) : TOwnWasmtimeLinker;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeLinker>.Create(p, wasmtime_linker_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasmtimeLinker.Wrap(p : PWasmtimeLinker; deleter : TRcDeleter) : TOwnWasmtimeLinker;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeLinker>.Create(p, deleter)
  else result.FStrongRef := nil;
end;

{ TOwnWasmtimeModuletype }

procedure wasmtime_moduletype_disposer(p : Pointer);
begin
  TWasmtime.moduletype_delete(p);
end;

class operator TOwnWasmtimeModuletype.Finalize(var Dest: TOwnWasmtimeModuletype);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmtimeModuletype.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmtimeModuletype.Negative(Src: TOwnWasmtimeModuletype): IRcContainer<PWasmtimeModuletype>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmtimeModuletype.Positive(Src: TOwnWasmtimeModuletype): PWasmtimeModuletype;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmtimeModuletype.Implicit(const Src : IRcContainer<PWasmtimeModuletype>) : TOwnWasmtimeModuletype;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmtimeModuletype.Unwrap: PWasmtimeModuletype;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmtimeModuletype.Wrap(p : PWasmtimeModuletype) : TOwnWasmtimeModuletype;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeModuletype>.Create(p, wasmtime_moduletype_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasmtimeModuletype.Wrap(p : PWasmtimeModuletype; deleter : TRcDeleter) : TOwnWasmtimeModuletype;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeModuletype>.Create(p, deleter)
  else result.FStrongRef := nil;
end;

{ TOwnWasmtimeTable }

class operator TOwnWasmtimeTable.Finalize(var Dest: TOwnWasmtimeTable);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmtimeTable.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmtimeTable.Negative(Src: TOwnWasmtimeTable): IRcContainer<PWasmtimeTable>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmtimeTable.Positive(Src: TOwnWasmtimeTable): PWasmtimeTable;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmtimeTable.Implicit(const Src : IRcContainer<PWasmtimeTable>) : TOwnWasmtimeTable;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmtimeTable.Unwrap: PWasmtimeTable;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmtimeTable.Wrap(p : PWasmtimeTable) : TOwnWasmtimeTable;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeTable>.Create(p, DefaultRecordDisposer)
  else result.FStrongRef := nil;
end;


{ TOwnWasmtimeGlobal }

class operator TOwnWasmtimeGlobal.Finalize(var Dest: TOwnWasmtimeGlobal);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmtimeGlobal.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmtimeGlobal.Negative(Src: TOwnWasmtimeGlobal): IRcContainer<PWasmtimeGlobal>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmtimeGlobal.Positive(Src: TOwnWasmtimeGlobal): PWasmtimeGlobal;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmtimeGlobal.Implicit(const Src : IRcContainer<PWasmtimeGlobal>) : TOwnWasmtimeGlobal;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmtimeGlobal.Unwrap: PWasmtimeGlobal;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmtimeGlobal.Wrap(p : PWasmtimeGlobal) : TOwnWasmtimeGlobal;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeGlobal>.Create(p, DefaultRecordDisposer)
  else result.FStrongRef := nil;
end;


{ TOwnWasmtimeFunc }

class operator TOwnWasmtimeFunc.Finalize(var Dest: TOwnWasmtimeFunc);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmtimeFunc.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmtimeFunc.Negative(Src: TOwnWasmtimeFunc): IRcContainer<PWasmtimeFunc>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmtimeFunc.Positive(Src: TOwnWasmtimeFunc): PWasmtimeFunc;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmtimeFunc.Implicit(const Src : IRcContainer<PWasmtimeFunc>) : TOwnWasmtimeFunc;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmtimeFunc.Unwrap: PWasmtimeFunc;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmtimeFunc.Wrap(p : PWasmtimeFunc) : TOwnWasmtimeFunc;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeFunc>.Create(p, DefaultRecordDisposer)
  else result.FStrongRef := nil;
end;


{ TOwnWasmtimeMemory }

class operator TOwnWasmtimeMemory.Finalize(var Dest: TOwnWasmtimeMemory);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmtimeMemory.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmtimeMemory.Negative(Src: TOwnWasmtimeMemory): IRcContainer<PWasmtimeMemory>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmtimeMemory.Positive(Src: TOwnWasmtimeMemory): PWasmtimeMemory;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmtimeMemory.Implicit(const Src : IRcContainer<PWasmtimeMemory>) : TOwnWasmtimeMemory;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmtimeMemory.Unwrap: PWasmtimeMemory;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmtimeMemory.Wrap(p : PWasmtimeMemory) : TOwnWasmtimeMemory;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeMemory>.Create(p, DefaultRecordDisposer)
  else result.FStrongRef := nil;
end;


{ TOwnWasmtimeInstance }

class operator TOwnWasmtimeInstance.Finalize(var Dest: TOwnWasmtimeInstance);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmtimeInstance.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmtimeInstance.Negative(Src: TOwnWasmtimeInstance): IRcContainer<PWasmtimeInstance>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmtimeInstance.Positive(Src: TOwnWasmtimeInstance): PWasmtimeInstance;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmtimeInstance.Implicit(const Src : IRcContainer<PWasmtimeInstance>) : TOwnWasmtimeInstance;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmtimeInstance.Unwrap: PWasmtimeInstance;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmtimeInstance.Wrap(p : PWasmtimeInstance) : TOwnWasmtimeInstance;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmtimeInstance>.Create(p, DefaultRecordDisposer)
  else result.FStrongRef := nil;
end;

// [OwnImplEnd]


{ TWasmtimeError }

function TWasmtimeError.GetMessage() : string;
begin
  var m := Default(TWasmName);
  TWasmtime.error_message(@self, @m);
  try
    result := string(m.AsUTF8String);
  finally
    TWasm.byte_vec_delete(@m);
  end;
end;

{ TWasmtimeExtern }

function TWasmtimeExtern.GetType(context : PWasmtimeContext) : TOwnExterntype;
begin
  var p := TWasmtime.extern_type(context, @self);
  result := TOwnExterntype.Wrap(p);
end;


{ TWasmByteVecHelper }

function TWasmByteVecHelper.LoadFromWatFile(fname: string): Boolean;
begin
  var stream := TRc.Wrap(TFileStream.Create(fname, fmOpenRead));
  var file_size := (+stream).Size;
  var binary := TWasmByteVec.NewUninitialized(file_size);
  if (+stream).ReadData((+binary).data, file_size) <> file_size then
  begin
    exit(false);
  end;

  var error := TWasmtime.wat2wasm(PAnsiChar(binary.Unwrap.data), file_size, @self);
  result := error = nil;
end;

function TWasmByteVecHelper.Wat2Wasm(wat: string): TOwnWasmtimeError;
begin
  var s8 := UTF8String(wat);
  var len := Length(s8);
  var err := TWasmtime.wat2wasm(PAnsiChar(s8), len, @self);
  result := TOwnWasmtimeError.Wrap(err);
end;

{ TWasmtimeConfig }

procedure TWasmtimeConfig.DebugInfoSet(value : Boolean);
begin
  TWasmtime.config_debug_info_set(@self, value);
end;

procedure TWasmtimeConfig.InterruptableSet(value : Boolean);
begin
  TWasmtime.config_interruptable_set(@self, value);
end;

procedure TWasmtimeConfig.ConsumeFuelSet(value : Boolean);
begin
  TWasmtime.config_consume_fuel_set(@self, value);
end;

procedure TWasmtimeConfig.MaxWasmStackSet(value : NativeInt);
begin
  TWasmtime.config_max_wasm_stack_set(@self, value);
end;

procedure TWasmtimeConfig.WasmThreadsSet(value : Boolean);
begin
  TWasmtime.config_wasm_threads_set(@self, value);
end;

procedure TWasmtimeConfig.WasmReferebceTypesSet(value : Boolean);
begin
  TWasmtime.config_wasm_reference_types_set(@self, value);
end;

procedure TWasmtimeConfig.WasmSimdSet(value : Boolean);
begin
  TWasmtime.config_wasm_simd_set(@self, value);
end;

procedure TWasmtimeConfig.WasmBulkMemorySet(value : Boolean);
begin
  TWasmtime.config_wasm_bulk_memory_set(@self, value);
end;

procedure TWasmtimeConfig.WasmMultiValueSet(value : Boolean);
begin
  TWasmtime.config_wasm_multi_value_set(@self, value);
end;

procedure TWasmtimeConfig.WasmModuleLinkingSet(value : Boolean);
begin
  TWasmtime.config_wasm_module_linking_set(@self, value);
end;

function TWasmtimeConfig.StrategySet(value : TWasmtimeStrategy) : TOwnWasmtimeError;
begin
  var error := TWasmtime.config_strategy_set(@self, value);
  result := TOwnWasmtimeError.Wrap(error);
end;

procedure TWasmtimeConfig.CraneliftDebugVerifierSet(value : Boolean);
begin
  TWasmtime.config_cranelift_debug_verifier_set(@self, value);
end;

procedure TWasmtimeConfig.CraneliftOptLevelSet(value : TWasmtimeOptLevel);
begin
  TWasmtime.config_cranelift_opt_level_set(@self, value);
end;

procedure TWasmtimeConfig.ProfilerSet(value : TWasmtimeProfilingStrategy);
begin
  TWasmtime.config_profiler_set(@self, value);
end;

procedure TWasmtimeConfig.StaticMemoryMaximumSizeSet(value : NativeUInt);
begin
  TWasmtime.config_static_memory_maximum_size_set(@self, value);
end;

procedure TWasmtimeConfig.StaticMemoryGuardSizeSet(value : NativeUInt);
begin
  TWasmtime.config_static_memory_guard_size_set(@self, value);
end;

procedure TWasmtimeConfig.DynamicMemoryGuardSizeSet(value : NativeUInt);
begin
  TWasmtime.config_dynamic_memory_guard_size_set(@self, value);
end;

function TWasmtimeConfig.CacheConfigLoad(const data : PByte) : TOwnWasmtimeError;
begin
  var error := TWasmtime.config_cache_config_load(@self, data);
  result := TOwnWasmtimeError.Wrap(error);
end;

{ TWasmtimeFunc }

function TWasmtimeFunc.Call(const args: PWasmtimeVal; nargs: NativeUInt; results: PWasmtimeVal; nresults: NativeUInt; var trap: TOwnTrap): TOwnWasmtimeError;
begin
  var pt : PWasmTrap := nil;
  var error := TWasmtime.func_call(context, @self, args, nargs, results, nresults, @pt);
  result := TOwnWasmtimeError.Wrap(error);
  trap := TOwnTrap.Wrap(pt);
end;

function TWasmtimeFunc.GetType(): TOwnFunctype;
begin
  result := TOwnFunctype.Wrap(TWasmtime.func_type(context, @self));
end;

class function TWasmtimeFunc.New(context: PWasmtimeContext; const typ: PWasmFunctype; callback: TWasmtimeFuncCallback; env: Pointer; finalizer: TWasmFinalizer): TWasmtimeFunc;
begin
  TWasmtime.func_new(context, typ, callback, env, finalizer, result);
  result.context := context;
end;

{ TWasmtimeTable }

function TWasmtimeTable.GetType(): TOwnTabletype;
begin
  var p := TWasmtime.table_type(context, @self);
  result := TOwnTabletype.Wrap(p);
end;

function TWasmtimeTable.GetValue(index: UInt32): TOwnWasmtimeVal;
begin
  var p : PWasmtimeVal;
  System.New(p);
  var ok := TWasmtime.table_get(context, @self, index, p);
  if ok then result := TOwnWasmtimeVal.Wrap(p, wasmtime_val_disposer_host) else result := TOwnWasmtimeVal.Wrap(nil);
end;

function TWasmtimeTable.Grow(delta: UInt32; const init: PWasmtimeVal; prev_size: PUInt32): TOwnWasmtimeError;
begin
  var p := TWasmtime.table_grow(context, @self, delta, init, prev_size);
  result := TOwnWasmtimeError.Wrap(p);
end;

class function TWasmtimeTable.New(context: PWasmtimeContext; const ty: PWasmTabletype; const init: PWasmtimeVal): TResultWasmtimeTable;
begin
  var p : PWasmtimeTable;
  System.New(p);
  var err := TWasmtime.table_new(context, ty, init, p^);
  p.context := context;
  result.IsError := err <> nil;
  result.Table := TOwnWasmtimeTable.Wrap(p);
  result.Error := TOwnWasmtimeError.Wrap(err);
end;

function TWasmtimeTable.SetValue(index: UInt32; const value: PWasmtimeVal): TOwnWasmtimeError;
begin
  var err := TWasmtime.table_set(context, @self, index, value);
  result := TOwnWasmtimeError.Wrap(err);
end;

function TWasmtimeTable.Size(): UInt32;
begin
  result := TWasmtime.table_size(context, @self);
end;

{ TWasmtimeInstance }

function TWasmtimeInstance.GetExport(name: UTF8String): TOwnWasmtimeExtern;
begin
  var namep := PAnsiChar(name);
  var name_len := Length(name);
  var p : PWasmtimeExtern;
  System.New(p);
  var found := TWasmtime.instance_export_get(context, @self, namep, name_len, p^);
  if found then
  begin
    if p.kind <> WASMTIME_EXTERN_MODULE then p.instance.context := context;

    result := TOwnWasmtimeExtern.Wrap(p,wasmtime_extern_disposer_host);
  end else begin
    Dispose(p);
    result := TOwnWasmtimeExtern.Wrap(nil);
  end;
end;

function TWasmtimeInstance.GetExportByIndex(index: NativeUInt; out name: UTF8String): TOwnWasmtimeExtern;
begin
  var out_name : PAnsiChar;
  var name_len : NativeUInt;
  var p : PWasmtimeExtern;
  System.New(p);
  var found := TWasmtime.instance_export_nth(context, @self, index, out_name, name_len, p^);
  if found then
  begin
    var buf := TArray<Byte>.Create();
    SetLength(buf, name_len);
    Move(out_name^, buf[0], name_len);
    name := UTF8String(PAnsiChar(@buf[0]));

    if p.kind <> WASMTIME_EXTERN_MODULE then p.instance.context := context;
    result := TOwnWasmtimeExtern.Wrap(p, wasmtime_extern_disposer_host);
  end else begin
    Dispose(p);
    result := TOwnWasmtimeExtern.Wrap(nil);
  end;
end;

function TWasmtimeInstance.GetType: TOwnWasmtimeInstancetype;
begin
  var p := TWasmtime.instance_type(context, @self);
  result := TOwnWasmtimeInstancetype.Wrap(p);
end;

class function TWasmtimeInstance.New(context: PWasmtimeContext; const module: PWasmtimeModule; const imports: PWasmtimeExtern; nimports: NativeUInt): TResultWasmtimeInstance;
begin
  var p : PWasmtimeInstance;
  var trap : PWasmTrap;
  System.New(p);
  var err := TWasmtime.instance_new(context, module, imports, nimports, p^, @trap);
  p.context := context;
  result.IsError := err <> nil;
  result.Instance := TOwnWasmtimeInstance.Wrap(p);
  result.Error := TOwnWasmtimeError.Wrap(err);
  result.Trap := TOwnTrap.Wrap(trap);
end;

{ TWasmtimeGlobal }

function TWasmtimeGlobal.GetType: TOwnGlobaltype;
begin
  var t := TWasmtime.global_type(context, @self);
  result := TOwnGlobaltype.Wrap(t);
end;

function TWasmtimeGlobal.GetValue: TOwnWasmtimeVal;
begin
  var p : PWasmtimeVal;
  System.New(p);
  TWasmtime.global_get(context, @self, p);
  result := TOwnWasmtimeVal.Wrap(p, wasmtime_val_disposer_host);
end;

class function TWasmtimeGlobal.New(context: PWasmtimeContext; const typ: PWasmGlobaltype; const val: PWasmtimeVal): TResultWasmtimeGlobal;
begin
  var p : PWasmtimeGlobal;
  System.New(p);
  var err := TWasmtime.global_new(context, typ, val, p^);
  p.context := context;
  result.IsError := err <> nil;
  result.Global := TOwnWasmtimeGlobal.Wrap(p);
  result.Error := TOwnWasmtimeError.Wrap(err);
end;

function TWasmtimeGlobal.SetValue(val: PWasmtimeVal): TOwnWasmtimeError;
begin
  var err := TWasmtime.global_set(context, @self, val);
  result := TOwnWasmtimeError.Wrap(err);
end;

{ TWasmtimeCaller }

function TWasmtimeCaller.Context: PWasmtimeContext;
begin
  result := TWasmtime.caller_context(@self);
end;

function TWasmtimeCaller.GetExport(name: UTF8String): TOwnWasmtimeExtern;
begin
  var namep := PAnsiChar(name);
  var name_len := Length(name);

  var p : PWasmtimeExtern;
  System.New(p);
  TWasmtime.caller_export_get(@self, namep, name_len, p);  //todo: *** check! ownership of item
  if p.kind <> WASMTIME_EXTERN_MODULE then p.func.context := TWasmtime.caller_context(@self);

  result := TOwnWasmtimeExtern.Wrap(p, wasmtime_extern_disposer_host);
end;

{ TWasmtimeInstancetype }

function TWasmtimeInstancetype.AsExterntype: PWasmExterntype;
begin
  result := TWasmtime.instancetype_as_externtype(@self);
end;

function TWasmtimeInstancetype.GetExports: TOwnExporttypeVec;
begin
  result := TWasmExporttypeVec.NewEmpty();
  TWasmtime.instancetype_exports(@self, result.Unwrap);
end;

{ TWasmtimeExterntype }

function TWasmtimeExterntype.AsInstancetype: PWasmtimeInstancetype;
begin
  result := TWasmtime.externtype_as_instancetype(@self);
end;

function TWasmtimeExterntype.AsModuletype: PWasmtimeModuletype;
begin
  result := TWasmtime.externtype_as_moduletype(@self);
end;

{ TWasmtimeStore }

function TWasmtimeStore.Context: PWasmtimeContext;
begin
  result := TWasmtime.store_context(@self);
end;

class function TWasmtimeStore.New(engine: PWasmEngine; data: Pointer; finalizer: TWasmFinalizer): TOwnWasmtimeStore;
begin
  var p := TWasmtime.store_new(engine, data, finalizer);
  result := TOwnWasmtimeStore.Wrap(p);
end;

{ TWasmtimeContext }

function TWasmtimeContext.AddFuel(fuel: UInt64): TOwnWasmtimeError;
begin
  result := TOwnWasmtimeError.Wrap( TWasmtime.context_add_fuel(@self, fuel));
end;

procedure TWasmtimeContext.ContextGc;
begin
  TWasmtime.context_gc(@self);
end;

procedure TWasmtimeContext.FuelConsumed(fuel: PUInt64);
begin
  TWasmtime.context_fuel_consume(@self, fuel);
end;

function TWasmtimeContext.GetData: Pointer;
begin
  result := TWasmtime.context_get_data(@self);
end;

procedure TWasmtimeContext.SetData(data: Pointer);
begin
  TWasmtime.context_set_data(@self, data);
end;

function TWasmtimeContext.SetWasi(wasi: TOwnWasiConfig): TOwnWasmtimeError;
begin
  result := TOwnWasmtimeError.Wrap( TWasmtime.context_set_wasi(@self, (-wasi).Move));
end;

{ TWasmtimeInterruptHandle }

procedure TWasmtimeInterruptHandle.Interrupt;
begin
  TWasmtime.interrupt_handle_interrupt(@self);
end;

class function TWasmtimeInterruptHandle.New(context: PWasmtimeContext): TOwnWasmtimeInterruptHandle;
begin
  result := TOwnWasmtimeInterruptHandle.Wrap(TWasmtime.interrupt_handle_new(context));
end;

{ TWasmtimeTrap }

function TWasmtimeTrap.ExitStatus(var status: Int32): Boolean;
begin
  result := TWasmtime.trap_exit_status(@self, status);
end;

class function TWasmtimeTrap.New(const msg: string): TOwnTrap;
begin
  var utf8 := UTF8String(msg);
  result := TOwnTrap.Wrap(TWasmtime.trap_new(PAnsiChar(utf8), Length(utf8)));
end;

{ TWasmtimeFrame }

function TWasmtimeFrame.FuncName: string;
begin
  var pname := TWasmtime.frame_func_name(@self);
  result := string(pname.AsUTF8String);
end;

function TWasmtimeFrame.ModuleName: string;
begin
  var pname := TWasmtime.frame_module_name(@self);
  result := string(pname.AsUTF8String);
end;

{ TWasmtimeMemory }

function TWasmtimeMemory.Data: PByte;
begin
  result := TWasmtime.memory_data(context, @self);
end;

function TWasmtimeMemory.DataSize: NativeUInt;
begin
  result := TWasmtime.memory_data_size(context, @self);
end;

function TWasmtimeMemory.GetType: TOwnMemorytype;
begin
  result := TOwnMemoryType.Wrap( TWasmtime.memory_type(context, @self));
end;

function TWasmtimeMemory.Grow(delta: UInt32; var prev_size: UInt32): TOwnWasmtimeError;
begin
  result := TOwnWasmtimeError.Wrap( TWasmtime.memory_grow(context, @self, delta, @prev_size) );
end;

class function TWasmtimeMemory.New(context: PWasmtimeContext; const ty: PWasmMemorytype): TResultWasmtimeMemory;
begin
  var p : PWasmtimeMemory;
  System.New(p);
  var err := TWasmtime.memory_new(context, ty, p^);
  p.context := context;
  result.IsError := err <> nil;
  result.Memory := TOwnWasmtimeMemory.Wrap(p);
  result.Error := TOwnWasmtimeError.Wrap(err);
end;

function TWasmtimeMemory.Size: UInt32;
begin
  result := TWasmtime.memory_size(context, @self);
end;

{ TWasmtimeVal }

function TWasmtimeVal.Copy : TOwnWasmtimeVal;
begin
  var p : PWasmtimeVal;
  System.New(p);
  TWasmtime.val_copy(p, @self);
  result := TOwnWasmtimeVal.Wrap(p, wasmtime_val_disposer_host);
end;

{ TWasmtimeExternref }

function TWasmtimeExternref.Clone: TOwnWasmtimeExternref;
begin
  result := TOwnWasmtimeExternref.Wrap( TWasmtime.externref_clone(@self) );
end;

function TWasmtimeExternref.Data: Pointer;
begin
  result := TWasmtime.externref_data(@self);
end;

class function TWasmtimeExternref.New(data: Pointer; finalizer: TWasmFinalizer): TOwnWasmtimeExternref;
begin
  result := TOwnWasmtimeExternref.Wrap(TWasmtime.externref_new(data, finalizer) );
end;

{ TWasmtimeLinker }

procedure TWasmtimeLinker.AllowShadowing(allow_shadowing: Boolean);
begin
  TWasmtime.linker_allow_shadowing(@self, allow_shadowing);
end;

function TWasmtimeLinker.Define(const module_name, name: string; const item: PWasmtimeExtern): TOwnWasmtimeError;
begin
  var moduleutf8 := UTF8String(module_name);
  var nameutf8 := UTF8String(name);
  result := TOwnWasmtimeError.Wrap( TWasmtime.linker_define(@self, PAnsiChar(moduleutf8), Length(moduleutf8), PAnsiChar(nameutf8), Length(nameutf8), item) );
end;

function TWasmtimeLinker.DefineInstance(context: PWasmtimeContext; const name: string; const instance: PWasmtimeInstance): TOwnWasmtimeError;
begin
  var nameutf8 := UTF8String(name);
  result := TOwnWasmtimeError.Wrap( TWasmtime.linker_define_instance(@self, context, PAnsiChar(nameutf8), Length(nameutf8), instance) );
end;

function TWasmtimeLinker.DefineWasi: TOwnWasmtimeError;
begin
  result := TOwnWasmtimeError.Wrap( TWasmtime.linker_define_wasi(@self) );
end;

function TWasmtimeLinker.Get(context: PWasmtimeContext; const module_name, name: string): TOwnWasmtimeExtern;
begin
  var moduleutf8 := UTF8String(module_name);
  var nameutf8 := UTF8String(name);
  var p : PWasmtimeExtern;
  System.New(p);
  TWasmtime.linker_get(@self, context, PAnsiChar(moduleutf8), Length(moduleutf8), PAnsiChar(nameutf8), Length(nameutf8), p);
  if p.kind <> WASMTIME_EXTERN_MODULE then p.instance.context := context;

  result := TOwnWasmtimeExtern.Wrap(p, wasmtime_extern_disposer_host);
end;

function TWasmtimeLinker.GetDefault(context: PWasmtimeContext; const name: string): TResultWasmtimeFunc;
begin
  var nameutf8 := UTF8String(name);
  var p : PWasmtimeFunc;
  System.New(p);
  var err := TWasmtime.linker_get_default(@self, context, PAnsiChar(nameutf8), Length(nameutf8), p^);
  p.context := context;
  result.IsError := err <> nil;
  result.Func := TOwnWasmtimeFunc.Wrap(p);
  result.Error := TOwnWasmtimeError.Wrap(err);
end;

function TWasmtimeLinker.Instantiate(context: PWasmtimeContext; const module: PWasmtimeModule): TResultWasmtimeInstance;
begin
  var p : PWasmtimeInstance;
  System.New(p);
  var pt : PWasmTrap := nil;
  var err := TWasmtime.linker_instantiate(@self, context, module, p^, @pt);
  p.context := context;
  result.IsError := err <> nil;
  result.Instance := TOwnWasmtimeInstance.Wrap(p);
  result.Error := TOwnWasmtimeError.Wrap(err);
  result.Trap := TOwnTrap.Wrap(pt);
end;

function TWasmtimeLinker.Module(context: PWasmtimeContext; const name: string; const module: PWasmtimeModule): TOwnWasmtimeError;
begin
  var nameutf8 := UTF8String(name);
  var err := TWasmtime.linker_module(@self, context, PAnsiChar(nameutf8), Length(nameutf8), module);
  result := TOwnWasmtimeError.Wrap(err);
end;

class function TWasmtimeLinker.New(engine: PWasmEngine): TOwnWasmtimeLinker;
begin
  result := TOwnWasmtimeLinker.Wrap(TWasmtime.linker_new(engine));
end;

{ TWasmtimeModuletype }

function TWasmtimeModuletype.AsExterntype: TOwnExterntype;
begin
  result := TOwnExterntype.Wrap(TWasmtime.moduletype_as_externtype(@self));
end;

function TWasmtimeModuletype.Imports: TOwnExporttypeVec;
begin
  result := TWasmExporttypeVec.NewEmpty;
  TWasmtime.moduletype_imports(@self, result.Unwrap);
end;

{ TWasmtimeModule }

function TWasmtimeModule.Clone: TOwnWasmtimeModule;
begin
  result := TOwnWasmtimeModule.Wrap( TWasmtime.module_clone(@self) );
end;

class function TWasmtimeModule.Deserialize(engine: PWasmEngine; const bytes: PByte; bytes_len: NativeUInt): TResultWasmtimeModule;
begin
  var ret : PWasmtimeModule;
  var err := TWasmtime.module_deserialize(engine, bytes, bytes_len, @ret);
  result.IsError := err <> nil;
  result.Module := TOwnWasmtimeModule.Wrap(ret);
  result.Error := TOwnWasmtimeError.Wrap(err);
end;

function TWasmtimeModule.GetType: TOwnWasmtimeModuletype;
begin
  result := TOwnWasmtimeModuletype.Wrap(TWasmtime.module_type(@self));
end;

class function TWasmtimeModule.New(engine: PWasmEngine; const binary : PWasmByteVec): TResultWasmtimeModule;
begin
  var ret : PWasmtimeModule;
  var err := TWasmtime.module_new(engine, PByte(binary.data), binary.size, @ret);
  result.IsError := err <> nil;
  result.Module := TOwnWasmtimeModule.Wrap(ret);
  result.Error := TOwnWasmtimeError.Wrap(err);
end;

function TWasmtimeModule.Serialize: TResultByteVec;
begin
  var ret := TWasmByteVec.NewEmpty;
  var err := TWasmtime.module_serialize(@self, ret.Unwrap);
  result.IsError := err <> nil;
  result.ByteVec := ret;
  result.Error := TOwnWasmtimeError.Wrap(err);
end;

function TWasmtimeModule.Validate(engine: PWasmEngine;  const binary : PWasmByteVec): TOwnWasmtimeError;
begin
  var err := TWasmtime.module_validate(engine, PByte(binary.data), binary.size);
  result := TOwnWasmtimeError.Wrap(err);
end;

end.


