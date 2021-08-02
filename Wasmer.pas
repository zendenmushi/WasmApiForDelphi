unit Wasmer;

interface
uses
  System.Classes, System.SysUtils,
  Wasm, Ownership
  ;

type
  TWasmerWasiVersion = (INVALID_VERSION=-1, LATEST, SNAPSHOT0, SNAPSHOT1);
  TWasmerCompiler = (CRANELIFT, LLVM, SINGLEPASS);
  TWasmerEngine = (UNIVERSAL, DYLIB, STATICLIB);

{$REGION 'TWasmerParserOperator'}
  TWasmerParserOperator = (
  Unreachable,
  Nop,
  Block,
  Loop,
  &If,
  &Else,
  &Try,
  Catch,
  CatchAll,
  Delegate,
  Throw,
  Rethrow,
  Unwind,
  &End,
  Br,
  BrIf,
  BrTable,
  Return,
  Call,
  CallIndirect,
  ReturnCall,
  ReturnCallIndirect,
  Drop,
  Select,
  TypedSelect,
  LocalGet,
  LocalSet,
  LocalTee,
  GlobalGet,
  GlobalSet,
  I32Load,
  I64Load,
  F32Load,
  F64Load,
  I32Load8S,
  I32Load8U,
  I32Load16S,
  I32Load16U,
  I64Load8S,
  I64Load8U,
  I64Load16S,
  I64Load16U,
  I64Load32S,
  I64Load32U,
  I32Store,
  I64Store,
  F32Store,
  F64Store,
  I32Store8,
  I32Store16,
  I64Store8,
  I64Store16,
  I64Store32,
  MemorySize,
  MemoryGrow,
  I32Const,
  I64Const,
  F32Const,
  F64Const,
  RefNull,
  RefIsNull,
  RefFunc,
  I32Eqz,
  I32Eq,
  I32Ne,
  I32LtS,
  I32LtU,
  I32GtS,
  I32GtU,
  I32LeS,
  I32LeU,
  I32GeS,
  I32GeU,
  I64Eqz,
  I64Eq,
  I64Ne,
  I64LtS,
  I64LtU,
  I64GtS,
  I64GtU,
  I64LeS,
  I64LeU,
  I64GeS,
  I64GeU,
  F32Eq,
  F32Ne,
  F32Lt,
  F32Gt,
  F32Le,
  F32Ge,
  F64Eq,
  F64Ne,
  F64Lt,
  F64Gt,
  F64Le,
  F64Ge,
  I32Clz,
  I32Ctz,
  I32Popcnt,
  I32Add,
  I32Sub,
  I32Mul,
  I32DivS,
  I32DivU,
  I32RemS,
  I32RemU,
  I32And,
  I32Or,
  I32Xor,
  I32Shl,
  I32ShrS,
  I32ShrU,
  I32Rotl,
  I32Rotr,
  I64Clz,
  I64Ctz,
  I64Popcnt,
  I64Add,
  I64Sub,
  I64Mul,
  I64DivS,
  I64DivU,
  I64RemS,
  I64RemU,
  I64And,
  I64Or,
  I64Xor,
  I64Shl,
  I64ShrS,
  I64ShrU,
  I64Rotl,
  I64Rotr,
  F32Abs,
  F32Neg,
  F32Ceil,
  F32Floor,
  F32Trunc,
  F32Nearest,
  F32Sqrt,
  F32Add,
  F32Sub,
  F32Mul,
  F32Div,
  F32Min,
  F32Max,
  F32Copysign,
  F64Abs,
  F64Neg,
  F64Ceil,
  F64Floor,
  F64Trunc,
  F64Nearest,
  F64Sqrt,
  F64Add,
  F64Sub,
  F64Mul,
  F64Div,
  F64Min,
  F64Max,
  F64Copysign,
  I32WrapI64,
  I32TruncF32S,
  I32TruncF32U,
  I32TruncF64S,
  I32TruncF64U,
  I64ExtendI32S,
  I64ExtendI32U,
  I64TruncF32S,
  I64TruncF32U,
  I64TruncF64S,
  I64TruncF64U,
  F32ConvertI32S,
  F32ConvertI32U,
  F32ConvertI64S,
  F32ConvertI64U,
  F32DemoteF64,
  F64ConvertI32S,
  F64ConvertI32U,
  F64ConvertI64S,
  F64ConvertI64U,
  F64PromoteF32,
  I32ReinterpretF32,
  I64ReinterpretF64,
  F32ReinterpretI32,
  F64ReinterpretI64,
  I32Extend8S,
  I32Extend16S,
  I64Extend8S,
  I64Extend16S,
  I64Extend32S,
  I32TruncSatF32S,
  I32TruncSatF32U,
  I32TruncSatF64S,
  I32TruncSatF64U,
  I64TruncSatF32S,
  I64TruncSatF32U,
  I64TruncSatF64S,
  I64TruncSatF64U,
  MemoryInit,
  DataDrop,
  MemoryCopy,
  MemoryFill,
  TableInit,
  ElemDrop,
  TableCopy,
  TableFill,
  TableGet,
  TableSet,
  TableGrow,
  TableSize,
  MemoryAtomicNotify,
  MemoryAtomicWait32,
  MemoryAtomicWait64,
  AtomicFence,
  I32AtomicLoad,
  I64AtomicLoad,
  I32AtomicLoad8U,
  I32AtomicLoad16U,
  I64AtomicLoad8U,
  I64AtomicLoad16U,
  I64AtomicLoad32U,
  I32AtomicStore,
  I64AtomicStore,
  I32AtomicStore8,
  I32AtomicStore16,
  I64AtomicStore8,
  I64AtomicStore16,
  I64AtomicStore32,
  I32AtomicRmwAdd,
  I64AtomicRmwAdd,
  I32AtomicRmw8AddU,
  I32AtomicRmw16AddU,
  I64AtomicRmw8AddU,
  I64AtomicRmw16AddU,
  I64AtomicRmw32AddU,
  I32AtomicRmwSub,
  I64AtomicRmwSub,
  I32AtomicRmw8SubU,
  I32AtomicRmw16SubU,
  I64AtomicRmw8SubU,
  I64AtomicRmw16SubU,
  I64AtomicRmw32SubU,
  I32AtomicRmwAnd,
  I64AtomicRmwAnd,
  I32AtomicRmw8AndU,
  I32AtomicRmw16AndU,
  I64AtomicRmw8AndU,
  I64AtomicRmw16AndU,
  I64AtomicRmw32AndU,
  I32AtomicRmwOr,
  I64AtomicRmwOr,
  I32AtomicRmw8OrU,
  I32AtomicRmw16OrU,
  I64AtomicRmw8OrU,
  I64AtomicRmw16OrU,
  I64AtomicRmw32OrU,
  I32AtomicRmwXor,
  I64AtomicRmwXor,
  I32AtomicRmw8XorU,
  I32AtomicRmw16XorU,
  I64AtomicRmw8XorU,
  I64AtomicRmw16XorU,
  I64AtomicRmw32XorU,
  I32AtomicRmwXchg,
  I64AtomicRmwXchg,
  I32AtomicRmw8XchgU,
  I32AtomicRmw16XchgU,
  I64AtomicRmw8XchgU,
  I64AtomicRmw16XchgU,
  I64AtomicRmw32XchgU,
  I32AtomicRmwCmpxchg,
  I64AtomicRmwCmpxchg,
  I32AtomicRmw8CmpxchgU,
  I32AtomicRmw16CmpxchgU,
  I64AtomicRmw8CmpxchgU,
  I64AtomicRmw16CmpxchgU,
  I64AtomicRmw32CmpxchgU,
  V128Load,
  V128Store,
  V128Const,
  I8x16Splat,
  I8x16ExtractLaneS,
  I8x16ExtractLaneU,
  I8x16ReplaceLane,
  I16x8Splat,
  I16x8ExtractLaneS,
  I16x8ExtractLaneU,
  I16x8ReplaceLane,
  I32x4Splat,
  I32x4ExtractLane,
  I32x4ReplaceLane,
  I64x2Splat,
  I64x2ExtractLane,
  I64x2ReplaceLane,
  F32x4Splat,
  F32x4ExtractLane,
  F32x4ReplaceLane,
  F64x2Splat,
  F64x2ExtractLane,
  F64x2ReplaceLane,
  I8x16Eq,
  I8x16Ne,
  I8x16LtS,
  I8x16LtU,
  I8x16GtS,
  I8x16GtU,
  I8x16LeS,
  I8x16LeU,
  I8x16GeS,
  I8x16GeU,
  I16x8Eq,
  I16x8Ne,
  I16x8LtS,
  I16x8LtU,
  I16x8GtS,
  I16x8GtU,
  I16x8LeS,
  I16x8LeU,
  I16x8GeS,
  I16x8GeU,
  I32x4Eq,
  I32x4Ne,
  I32x4LtS,
  I32x4LtU,
  I32x4GtS,
  I32x4GtU,
  I32x4LeS,
  I32x4LeU,
  I32x4GeS,
  I32x4GeU,
  I64x2Eq,
  I64x2Ne,
  I64x2LtS,
  I64x2GtS,
  I64x2LeS,
  I64x2GeS,
  F32x4Eq,
  F32x4Ne,
  F32x4Lt,
  F32x4Gt,
  F32x4Le,
  F32x4Ge,
  F64x2Eq,
  F64x2Ne,
  F64x2Lt,
  F64x2Gt,
  F64x2Le,
  F64x2Ge,
  V128Not,
  V128And,
  V128AndNot,
  V128Or,
  V128Xor,
  V128Bitselect,
  V128AnyTrue,
  I8x16Abs,
  I8x16Neg,
  I8x16AllTrue,
  I8x16Bitmask,
  I8x16Shl,
  I8x16ShrS,
  I8x16ShrU,
  I8x16Add,
  I8x16AddSatS,
  I8x16AddSatU,
  I8x16Sub,
  I8x16SubSatS,
  I8x16SubSatU,
  I8x16MinS,
  I8x16MinU,
  I8x16MaxS,
  I8x16MaxU,
  I8x16Popcnt,
  I16x8Abs,
  I16x8Neg,
  I16x8AllTrue,
  I16x8Bitmask,
  I16x8Shl,
  I16x8ShrS,
  I16x8ShrU,
  I16x8Add,
  I16x8AddSatS,
  I16x8AddSatU,
  I16x8Sub,
  I16x8SubSatS,
  I16x8SubSatU,
  I16x8Mul,
  I16x8MinS,
  I16x8MinU,
  I16x8MaxS,
  I16x8MaxU,
  I16x8ExtAddPairwiseI8x16S,
  I16x8ExtAddPairwiseI8x16U,
  I32x4Abs,
  I32x4Neg,
  I32x4AllTrue,
  I32x4Bitmask,
  I32x4Shl,
  I32x4ShrS,
  I32x4ShrU,
  I32x4Add,
  I32x4Sub,
  I32x4Mul,
  I32x4MinS,
  I32x4MinU,
  I32x4MaxS,
  I32x4MaxU,
  I32x4DotI16x8S,
  I32x4ExtAddPairwiseI16x8S,
  I32x4ExtAddPairwiseI16x8U,
  I64x2Abs,
  I64x2Neg,
  I64x2AllTrue,
  I64x2Bitmask,
  I64x2Shl,
  I64x2ShrS,
  I64x2ShrU,
  I64x2Add,
  I64x2Sub,
  I64x2Mul,
  F32x4Ceil,
  F32x4Floor,
  F32x4Trunc,
  F32x4Nearest,
  F64x2Ceil,
  F64x2Floor,
  F64x2Trunc,
  F64x2Nearest,
  F32x4Abs,
  F32x4Neg,
  F32x4Sqrt,
  F32x4Add,
  F32x4Sub,
  F32x4Mul,
  F32x4Div,
  F32x4Min,
  F32x4Max,
  F32x4PMin,
  F32x4PMax,
  F64x2Abs,
  F64x2Neg,
  F64x2Sqrt,
  F64x2Add,
  F64x2Sub,
  F64x2Mul,
  F64x2Div,
  F64x2Min,
  F64x2Max,
  F64x2PMin,
  F64x2PMax,
  I32x4TruncSatF32x4S,
  I32x4TruncSatF32x4U,
  F32x4ConvertI32x4S,
  F32x4ConvertI32x4U,
  I8x16Swizzle,
  I8x16Shuffle,
  V128Load8Splat,
  V128Load16Splat,
  V128Load32Splat,
  V128Load32Zero,
  V128Load64Splat,
  V128Load64Zero,
  I8x16NarrowI16x8S,
  I8x16NarrowI16x8U,
  I16x8NarrowI32x4S,
  I16x8NarrowI32x4U,
  I16x8ExtendLowI8x16S,
  I16x8ExtendHighI8x16S,
  I16x8ExtendLowI8x16U,
  I16x8ExtendHighI8x16U,
  I32x4ExtendLowI16x8S,
  I32x4ExtendHighI16x8S,
  I32x4ExtendLowI16x8U,
  I32x4ExtendHighI16x8U,
  I64x2ExtendLowI32x4S,
  I64x2ExtendHighI32x4S,
  I64x2ExtendLowI32x4U,
  I64x2ExtendHighI32x4U,
  I16x8ExtMulLowI8x16S,
  I16x8ExtMulHighI8x16S,
  I16x8ExtMulLowI8x16U,
  I16x8ExtMulHighI8x16U,
  I32x4ExtMulLowI16x8S,
  I32x4ExtMulHighI16x8S,
  I32x4ExtMulLowI16x8U,
  I32x4ExtMulHighI16x8U,
  I64x2ExtMulLowI32x4S,
  I64x2ExtMulHighI32x4S,
  I64x2ExtMulLowI32x4U,
  I64x2ExtMulHighI32x4U,
  V128Load8x8S,
  V128Load8x8U,
  V128Load16x4S,
  V128Load16x4U,
  V128Load32x2S,
  V128Load32x2U,
  V128Load8Lane,
  V128Load16Lane,
  V128Load32Lane,
  V128Load64Lane,
  V128Store8Lane,
  V128Store16Lane,
  V128Store32Lane,
  V128Store64Lane,
  I8x16RoundingAverageU,
  I16x8RoundingAverageU,
  I16x8Q15MulrSatS,
  F32x4DemoteF64x2Zero,
  F64x2PromoteLowF32x4,
  F64x2ConvertLowI32x4S,
  F64x2ConvertLowI32x4U,
  I32x4TruncSatF64x2SZero,
  I32x4TruncSatF64x2UZero  );
{$ENDREGION}

  PWasiConfig =  ^TWasiConfig;

  PWasiEnv = ^TWasiEnv;

  PWasmerCpuFeatures = ^TWasmerCpuFeatures;

  PWasmerFeatures = ^TWasmerFeatures;

  PWasmerMetering = ^TWasmerMetering;

  PWasmerMiddleware = ^TWasmerMiddleware;

  PWasmerNamedExtern = ^TWasmerNamedExtern;
  PPWasmerNamedExtern = PWasmerNamedExtern;

  PWasmerTarget = ^TWasmerTarget;

  PWasmerTriple = ^TWasmerTriple;

  PWasmerNamedExternVec = ^TWasmerNamedExternVec;

  // [ApiNamespace] wasi
  // [OwnBegin] wasi_env
  TOwnWasiEnv = record
  private
    FStrongRef : IRcContainer<PWasiEnv>;
  public
    class function Wrap(p : PWasiEnv; deleter : TRcDeleter) : TOwnWasiEnv; overload; static; inline;
    class function Wrap(p : PWasiEnv) : TOwnWasiEnv; overload; static;
    class operator Finalize(var Dest: TOwnWasiEnv);
    class operator Implicit(const Src : IRcContainer<PWasiEnv>) : TOwnWasiEnv;
    class operator Positive(Src : TOwnWasiEnv) : PWasiEnv;
    class operator Negative(Src : TOwnWasiEnv) : IRcContainer<PWasiEnv>;
    function Unwrap() : PWasiEnv;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [ApiNamespace] wasmer
  // [OwnBegin] wasmer_cpu_features
  TOwnWasmerCpuFeatures = record
  private
    FStrongRef : IRcContainer<PWasmerCpuFeatures>;
  public
    class function Wrap(p : PWasmerCpuFeatures; deleter : TRcDeleter) : TOwnWasmerCpuFeatures; overload; static; inline;
    class function Wrap(p : PWasmerCpuFeatures) : TOwnWasmerCpuFeatures; overload; static;
    class operator Finalize(var Dest: TOwnWasmerCpuFeatures);
    class operator Implicit(const Src : IRcContainer<PWasmerCpuFeatures>) : TOwnWasmerCpuFeatures;
    class operator Positive(Src : TOwnWasmerCpuFeatures) : PWasmerCpuFeatures;
    class operator Negative(Src : TOwnWasmerCpuFeatures) : IRcContainer<PWasmerCpuFeatures>;
    function Unwrap() : PWasmerCpuFeatures;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmer_features
  TOwnWasmerFeatures = record
  private
    FStrongRef : IRcContainer<PWasmerFeatures>;
  public
    class function Wrap(p : PWasmerFeatures; deleter : TRcDeleter) : TOwnWasmerFeatures; overload; static; inline;
    class function Wrap(p : PWasmerFeatures) : TOwnWasmerFeatures; overload; static;
    class operator Finalize(var Dest: TOwnWasmerFeatures);
    class operator Implicit(const Src : IRcContainer<PWasmerFeatures>) : TOwnWasmerFeatures;
    class operator Positive(Src : TOwnWasmerFeatures) : PWasmerFeatures;
    class operator Negative(Src : TOwnWasmerFeatures) : IRcContainer<PWasmerFeatures>;
    function Unwrap() : PWasmerFeatures;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmer_metering
  TOwnWasmerMetering = record
  private
    FStrongRef : IRcContainer<PWasmerMetering>;
  public
    class function Wrap(p : PWasmerMetering; deleter : TRcDeleter) : TOwnWasmerMetering; overload; static; inline;
    class function Wrap(p : PWasmerMetering) : TOwnWasmerMetering; overload; static;
    class operator Finalize(var Dest: TOwnWasmerMetering);
    class operator Implicit(const Src : IRcContainer<PWasmerMetering>) : TOwnWasmerMetering;
    class operator Positive(Src : TOwnWasmerMetering) : PWasmerMetering;
    class operator Negative(Src : TOwnWasmerMetering) : IRcContainer<PWasmerMetering>;
    function Unwrap() : PWasmerMetering;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmer_named_extern_vec
  TOwnWasmerNamedExternVec = record
  private
    FStrongRef : IRcContainer<PWasmerNamedExternVec>;
  public
    class function Wrap(p : PWasmerNamedExternVec; deleter : TRcDeleter) : TOwnWasmerNamedExternVec; overload; static; inline;
    class function Wrap(p : PWasmerNamedExternVec) : TOwnWasmerNamedExternVec; overload; static;
    class operator Finalize(var Dest: TOwnWasmerNamedExternVec);
    class operator Implicit(const Src : IRcContainer<PWasmerNamedExternVec>) : TOwnWasmerNamedExternVec;
    class operator Positive(Src : TOwnWasmerNamedExternVec) : PWasmerNamedExternVec;
    class operator Negative(Src : TOwnWasmerNamedExternVec) : IRcContainer<PWasmerNamedExternVec>;
    function Unwrap() : PWasmerNamedExternVec;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmer_target
  TOwnWasmerTarget = record
  private
    FStrongRef : IRcContainer<PWasmerTarget>;
  public
    class function Wrap(p : PWasmerTarget; deleter : TRcDeleter) : TOwnWasmerTarget; overload; static; inline;
    class function Wrap(p : PWasmerTarget) : TOwnWasmerTarget; overload; static;
    class operator Finalize(var Dest: TOwnWasmerTarget);
    class operator Implicit(const Src : IRcContainer<PWasmerTarget>) : TOwnWasmerTarget;
    class operator Positive(Src : TOwnWasmerTarget) : PWasmerTarget;
    class operator Negative(Src : TOwnWasmerTarget) : IRcContainer<PWasmerTarget>;
    function Unwrap() : PWasmerTarget;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  // [OwnBegin] wasmer_triple
  TOwnWasmerTriple = record
  private
    FStrongRef : IRcContainer<PWasmerTriple>;
  public
    class function Wrap(p : PWasmerTriple; deleter : TRcDeleter) : TOwnWasmerTriple; overload; static; inline;
    class function Wrap(p : PWasmerTriple) : TOwnWasmerTriple; overload; static;
    class operator Finalize(var Dest: TOwnWasmerTriple);
    class operator Implicit(const Src : IRcContainer<PWasmerTriple>) : TOwnWasmerTriple;
    class operator Positive(Src : TOwnWasmerTriple) : PWasmerTriple;
    class operator Negative(Src : TOwnWasmerTriple) : IRcContainer<PWasmerTriple>;
    function Unwrap() : PWasmerTriple;
    function IsNone() : Boolean;
  end;
  // [OwnEnd]

  TWasmerMeteringCostFunction = function (wasm_operator : TWasmerParserOperator) : UInt64; cdecl;

  TWasiConfigArgAPI = procedure(config : PWasiConfig; const arg : PAnsiChar); cdecl;
  TWasiConfigCaptureStderrAPI = procedure(config : PWasiConfig); cdecl;
  TWasiConfigCaptureStdoutAPI = procedure(config : PWasiConfig); cdecl;
  TWasiConfigEnvAPI = procedure(config : PWasiConfig; const key : PAnsiChar; const value : PAnsiChar); cdecl;
  TWasiConfigInheritStderrAPI = procedure(config : PWasiConfig); cdecl;
  TWasiConfigInheritStdinAPI = procedure(config : PWasiConfig); cdecl;
  TWasiConfigInheritStdoutAPI = procedure(config : PWasiConfig); cdecl;
  TWasiConfigMapdirAPI = function(config : PWasiConfig; const alias : PAnsiChar; const dir : PAnsiChar): Boolean; cdecl;
  TWasiConfigNewAPI = function(const program_name : PAnsiChar) : PWasiConfig; cdecl;
  TWasiConfigPreopenDirAPI = function(config : PWasiConfig; const dir : PAnsiChar) : Boolean; cdecl;
  TWasiEnvDeleteAPI = procedure(state : PWasiEnv); cdecl;
  TWasiEnvNewAPI = function(config : PWasiConfig) : PWasiEnv; cdecl;
  TWasiEnvReadStderrAPI = function(env : PWasiEnv; buffer : PByte; len : NativeUInt) : PInteger; cdecl;
  TWasiEnvReadStdoutAPI = function(env : PWasiEnv; buffer : PByte; len : NativeUInt) : PInteger; cdecl;
  TWasiGetImportsAPI = function(const store : PWasmStore; const module : PWasmModule; const wasi_env : PWasiEnv; imports : PWasmExternVec) : Boolean; cdecl;
  TWasiGetStartFunctionAPI = function(instance : PWasmInstance): PWasmFunc; cdecl;
  TWasiGetUnorderedImportsAPI = function(const store : PWasmStore; const module : PWasmModule; const wasi_env : PWasiEnv; imports : PWasmerNamedExternVec): Boolean; cdecl;
  TWasiGetWasiVersionAPI = function(const module : PWasmModule): TWasmerWasiVersion; cdecl;
  TWasmConfigCanonicalizeNansAPI = procedure(config : PWasmConfig; enable : Boolean); cdecl;
  TWasmConfigPushMiddlewareAPI = procedure(config : PWasmConfig; middleware : PWasmerMiddleWare); cdecl;
  TWasmConfigSetCompilerAPI = procedure(config : PWasmConfig; compiler : TWasmerCompiler); cdecl;
  TWasmConfigSetEngineAPI = procedure(config : PWasmConfig; engine : TWasmerEngine); cdecl;
  TWasmConfigSetFeaturesAPI = procedure(config : PWasmConfig; features : PWasmerFeatures); cdecl;
  TWasmConfigSetTargetAPI = procedure(config : PWasmConfig; target : PWasmerTarget); cdecl;
  TWasmerCpuFeaturesAddAPI = function(cpu_features : PWasmerCpuFeatures; const feature : PWasmName) : Boolean; cdecl;
  TWasmerCpuFeaturesDeleteAPI = procedure(cpu_features : PWasmerCpuFeatures); cdecl;
  TWasmerCpuFeaturesNewAPI = function(): PWasmerCpuFeatures; cdecl;
  TWasmerFeaturesBulkMemoryAPI = function(fueatures : PWasmerFeatures; enable : Boolean) : Boolean; cdecl;
  TWasmerFeaturesDeleteAPI = procedure(features : PWasmerFeatures); cdecl;
  TWasmerFeaturesMemory64API = function(features : PWasmerFeatures; enable : Boolean) : Boolean; cdecl;
  TWasmerFeaturesModuleLinkingAPI = function(features : PWasmerFeatures; enable : Boolean) : Boolean; cdecl;
  TWasmerFeaturesMultiMemoryAPI = function(features : PWasmerFeatures; enable : Boolean) : Boolean; cdecl;
  TWasmerFeaturesMultiValueAPI = function(features : PWasmerFeatures; enable : Boolean) : Boolean; cdecl;
  TWasmerFeaturesNewAPI = function() : PWasmerFeatures; cdecl;
  TWasmerFeaturesReferenceTypesAPI = function(features : PWasmerFeatures; enable : Boolean) : Boolean; cdecl;
  TWasmerFeaturesSimdAPI = function(features : PWasmerFeatures; enable : Boolean) : Boolean; cdecl;
  TWasmerFeaturesTailCallAPI = function(features : PWasmerFeatures; enable : Boolean) : Boolean; cdecl;
  TWasmerFeaturesThreadsAPI = function(features : PWasmerFeatures; enable : Boolean) : Boolean; cdecl;
  TWasmerIsCompilerAvailableAPI = function(compiler : TWasmerCompiler) : Boolean; cdecl;
  TWasmerIsEngineAvailableAPI = function(engine : TWasmerEngine) : Boolean; cdecl;
  TWasmerIsHeadlessAPI = function() : Boolean; cdecl;
  TWasmerLastErrorLengthAPI = function() : Integer; cdecl;
  TWasmerLastErrorMessageAPI = function(buffer : PByte; length : Integer) : Integer; cdecl;
  TWasmerMeteringAsMiddlewareAPI = function(metering : PWasmerMetering) : PWasmerMiddleware; cdecl;
  TWasmerMeteringDeleteAPI = procedure(metering : PWasmerMetering); cdecl;
  TWasmerMeteringGetRemainingPointsAPI = function(instance : PWasmInstance) : UInt64; cdecl;
  TWasmerMeteringNewAPI = function(initial_limit : UInt64; cost_function : TWasmerMeteringCostFunction) : PWasmerMetering; cdecl;
  TWasmerMeteringPointsAreExhaustedAPI = function(instance : PWasmInstance) : boolean; cdecl;
  TWasmerMeteringSetRemainingPointsAPI = procedure(instance : PWasmInstance; new_limit : UInt64); cdecl;
  TWasmerModuleNameAPI = procedure(module : PWasmModule; out_ : PWasmName); cdecl;
  TWasmerModuleSetNameAPI = function(module : PWasmModule; const name : PWasmName) : Boolean; cdecl;
  TWasmerNamedExternModuleAPI = function(named_extern : PWasmerNamedExtern) : {const} PWasmName; cdecl;
  TWasmerNamedExternNameAPI = function(named_extern : PWasmerNamedExtern) : {const} PWasmName; cdecl;
  TWasmerNamedExternUnwrapAPI = function(named_extern : PWasmerNamedExtern) : {const} PWasmExtern; cdecl;
  TWasmerNamedExternVecCopyAPI = procedure(out_ptr : PWasmerNamedExternVec; const in_ptr : PWasmerNamedExternVec); cdecl;
  TWasmerNamedExternVecDeleteAPI = procedure(ptr : PWasmerNamedExternVec); cdecl;
  TWasmerNamedExternVecNewAPI = procedure(out_ : PWasmerNamedExternVec; length : PUInt32; const init : PPWasmerNamedExtern); cdecl;
  TWasmerNamedExternVecNewEmptyAPI = procedure(out_ : PWasmerNamedExternVec); cdecl;
  TWasmerNamedExternVecNewUninitializedAPI = procedure(out_ : PWasmerNamedExternVec; length : PUInt32); cdecl;
  TWasmerTargetDeleteAPI = procedure(target : PWasmerTarget); cdecl;
  TWasmerTargetNewAPI = function(triple : PWasmerTriple; cpu_features : PWasmerCpuFeatures) : PWasmerTarget; cdecl;
  TWasmerTripleDeleteAPI = procedure(triple : PWasmerTriple); cdecl;
  TWasmerTripleNewAPI = function(const triple : PWasmName) : PWasmerTriple; cdecl;
  TWasmerTripleNewFromHostAPI = function() : PWasmerTriple; cdecl;
  TWasmerVersionAPI = function() : {const} PAnsiChar; cdecl;
  TWasmerVersionMajorAPI = function() : UInt8; cdecl;
  TWasmerVersionMinorAPI = function() : UInt8; cdecl;
  TWasmerVersionPatchAPI = function() : UInt8; cdecl;
  TWasmerVersionPreAPI = function() : {const} PAnsiChar; cdecl;
  TWasmerWat2Wasm = procedure(const wat : PWasmByteVec; out_ : PWasmByteVec); cdecl;

  // wrapper & helper

  TWasmByteVecHelper = record helper for TWasmByteVec
    function LoadFromWatFile(fname : string) : Boolean;
    procedure Wat2Wasm(wat : string);
  end;

  TWasiConfig = record
  public
    class function New(const program_name : string) : PWasiConfig; static;
    procedure Arg(const arg : string);
    procedure CaptureStderr();
    procedure CaptureStdout();
    procedure Env(const key : string; const value : string);
    procedure InheritStderr();
    procedure InheritStdin();
    procedure InheritStdout();
    function Mapdir(const alias : string; const dir : string): Boolean;
    function PreopenDir(const dir : string) : Boolean; cdecl;
  end;

  TWasmerConfig = record helper for TWasmConfig
  public
    procedure CanonicalizeNans(enable : Boolean);
    procedure PushMiddleware(middleware : PWasmerMiddleWare);
    procedure SetCompiler(compiler : TWasmerCompiler);
    procedure SetEngine(engine : TWasmerEngine);
    procedure SetFeatures(features : TOwnWasmerFeatures);
    procedure SetTarget(target : TOwnWasmerTarget);
  end;

  TWasmerModule = record helper for TWasmModule
  public
    function Name() : string;
    function SetName(const name : string) : Boolean;
  end;

  TWasmerCpuFeatures = record
  public
    class function New() : TOwnWasmerCpuFeatures; static;
    function CpuFeaturesAdd(const feature : string) : Boolean;
  end;

  TWasmerFeatures = record
  public
    class function New() : TOwnWasmerFeatures; static;
    function BulkMemory(enable : Boolean) : Boolean;
    function Memory64(enable : Boolean) : Boolean;
    function ModuleLinking(enable : Boolean) : Boolean;
    function MultiMemory(enable : Boolean) : Boolean;
    function MultiValue(enable : Boolean) : Boolean;
    function ReferenceTypes(enable : Boolean) : Boolean;
    function Simd(enable : Boolean) : Boolean;
    function TailCall(enable : Boolean) : Boolean;
    function Threads(enable : Boolean) : Boolean;
  end;

  TWasiEnv = record
  public
    class function New(config : PWasiConfig) : TOwnWasiEnv; static;
    function ReadStderr(buffer : PByte; len : NativeUInt) : PInteger;
    function ReadStdout(buffer : PByte; len : NativeUInt) : PInteger;
  end;

  TWasmerMetering = record
  public
    class function New(initial_limit : UInt64; cost_function : TWasmerMeteringCostFunction) : TOwnWasmerMetering; static;
    function AsMiddleware() : PWasmerMiddleware;
    function GetRemainingPoints(instance : PWasmInstance) : UInt64;
    function PointsAreExhausted(instance : PWasmInstance) : boolean;
    procedure SetRemainingPoints(instance : PWasmInstance; new_limit : UInt64);
  end;

  TWasmerMiddleware = record
  end;

  TWasmerNamedExtern = record
  public
    function Module() : string;
    function Name() : string;
    function Unwrap() : PWasmExtern;
  end;

  TWasmerTarget = record
  public
    class function New(triple : PWasmerTriple; cpu_features : TOwnWasmerCpuFeatures) : TOwnWasmerTarget; static;
  end;

  TWasmerTriple = record
  public
    class function New(const triple : string) : TOwnWasmerTriple; static;
    class function NewFromHost() : TOwnWasmerTriple; static;
  end;

  TWasmerNamedExternVec = record
  public
    class function New(length : PUInt32; const init : PPWasmerNamedExtern) : TOwnWasmerNamedExternVec; static;
    class function NewEmpty() : TOwnWasmerNamedExternVec; static;
    class function NewUninitialized(length : PUInt32) : TOwnWasmerNamedExternVec; static;
    function Copy() : TOwnWasmerNamedExternVec;
  public
    case Integer of
    0 :(size : NativeInt; data : PPWasmerNamedExtern);
    1 :(Items : TWasmVec<PWasmerNamedExtern>);
  end;


  TWasi = record
  public class var
    config_arg : TWasiConfigArgAPI;
    config_capture_stderr : TWasiConfigCaptureStderrAPI;
    config_capture_stdout : TWasiConfigCaptureStdoutAPI;
    config_env : TWasiConfigEnvAPI;
    config_inherit_stderr : TWasiConfigInheritStderrAPI;
    config_inherit_stdin : TWasiConfigInheritStdinAPI;
    config_ibherit_stdout : TWasiConfigInheritStdoutAPI;
    config_mapdir : TWasiConfigMapdirAPI;
    config_new : TWasiConfigNewAPI;
    config_preopen_dir : TWasiConfigPreopenDirAPI;
    env_delete : TWasiEnvDeleteAPI;
    env_new : TWasiEnvNewAPI;
    env_read_stderr : TWasiEnvReadStderrAPI;
    env_read_stdout : TWasiEnvReadStdoutAPI;
    get_imports : TWasiGetImportsAPI;
    get_start_function : TWasiGetStartFunctionAPI;
    get_unordered_imports : TWasiGetUnorderedImportsAPI;
    get_wasi_version : TWasiGetWasiVersionAPI;
  public
    function GetImports(const store : PWasmStore; const module : PWasmModule; const wasi_env : PWasiEnv; imports : PWasmExternVec) : Boolean;
    function GetStartFunction(instance : PWasmInstance): PWasmFunc;
    function GetUnorderedImports(const store : PWasmStore; const module : PWasmModule; const wasi_env : PWasiEnv; imports : PWasmerNamedExternVec): Boolean;
    function GetWasiVersion(const module : PWasmModule): TWasmerWasiVersion;
  public
    class procedure InitAPIs(runtime : HMODULE); static;
  end;

  TWasmer = record
  public class var
    config_canonical_nans : TWasmConfigCanonicalizeNansAPI;
    config_push_middleware : TWasmConfigPushMiddlewareAPI;
    config_set_compiler : TWasmConfigSetCompilerAPI;
    config_set_engine : TWasmConfigSetEngineAPI;
    config_set_features : TWasmConfigSetFeaturesAPI;
    config_set_target : TWasmConfigSetTargetAPI;
    cpu_features_add : TWasmerCpuFeaturesAddAPI;
    cpu_features_delete : TWasmerCpuFeaturesDeleteAPI;
    cpu_features_new : TWasmerCpuFeaturesNewAPI;
    features_bulk_memory : TWasmerFeaturesBulkMemoryAPI;
    features_delete : TWasmerFeaturesDeleteAPI;
    features_memory64 : TWasmerFeaturesMemory64API;
    features_module_linking : TWasmerFeaturesModuleLinkingAPI;
    features_multi_memory : TWasmerFeaturesMultiMemoryAPI;
    features_multi_value : TWasmerFeaturesMultiValueAPI;
    features_new : TWasmerFeaturesNewAPI;
    features_reference_types : TWasmerFeaturesReferenceTypesAPI;
    features_simd : TWasmerFeaturesSimdAPI;
    features_tail_call : TWasmerFeaturesTailCallAPI;
    features_threads : TWasmerFeaturesThreadsAPI;
    is_compiler_available : TWasmerIsCompilerAvailableAPI;
    is_engine_available : TWasmerIsEngineAvailableAPI;
    is_headless : TWasmerIsHeadlessAPI;
    last_error_length : TWasmerLastErrorLengthAPI;
    last_error_message : TWasmerLastErrorMessageAPI;
    metering_as_middleware : TWasmerMeteringAsMiddlewareAPI;
    metering_delete : TWasmerMeteringDeleteAPI;
    metering_get_remaining_points : TWasmerMeteringGetRemainingPointsAPI;
    metering_new : TWasmerMeteringNewAPI;
    metering_points_are_exhausted : TWasmerMeteringPointsAreExhaustedAPI;
    metering_set_remaining_points : TWasmerMeteringSetRemainingPointsAPI;
    module_name : TWasmerModuleNameAPI;
    module_set_name : TWasmerModuleSetNameAPI;
    named_extern_module : TWasmerNamedExternModuleAPI;
    named_extern_name : TWasmerNamedExternNameAPI;
    named_extern_unwrap : TWasmerNamedExternUnwrapAPI;
    named_extern_vec_copy : TWasmerNamedExternVecCopyAPI;
    named_extern_vec_delete : TWasmerNamedExternVecDeleteAPI;
    named_extern_vec_new : TWasmerNamedExternVecNewAPI;
    named_extern_vec_new_empty : TWasmerNamedExternVecNewEmptyAPI;
    named_extern_vec_new_uninitialized : TWasmerNamedExternVecNewUninitializedAPI;
    target_delete : TWasmerTargetDeleteAPI;
    target_new : TWasmerTargetNewAPI;
    triple_delete : TWasmerTripleDeleteAPI;
    triple_new : TWasmerTripleNewAPI;
    triple_new_from_host : TWasmerTripleNewFromHostAPI;
    version : TWasmerVersionAPI;
    version_major : TWasmerVersionMajorAPI;
    version_minor : TWasmerVersionMinorAPI;
    version_patch : TWasmerVersionPatchAPI;
    version_pre : TWasmerVersionPreAPI;
    wat2wasm : TWasmerWat2Wasm;
  public
    function IsCompilerAvailable(compiler : TWasmerCompiler) : Boolean;
    function IsEngineAvailable(engine : TWasmerEngine) : Boolean;
    function IsHeadless() : Boolean;
    function LastErrorMessage : string;
  public
    class procedure Init(dll_name : string); static;
    class procedure InitAPIs(runtime : HMODULE); static;
  end;

implementation
uses
  Windows
  ;

var
  wasmer_runtime : HMODULE;

{ TWasmer }

class procedure TWasmer.Init(dll_name: string);
begin
  wasmer_runtime := LoadLibrary(PWideChar(dll_name));
  InitAPIs(wasmer_runtime);
  TWasi.InitAPIs(wasmer_runtime);
  TWasm.InitAPIs(wasmer_runtime);
end;

class procedure TWasmer.InitAPIs(runtime : HMODULE);
  function ProcAddress(name : string) : Pointer;
  begin
    result := GetProcAddress(runtime, PWideChar(name));
  end;

begin

  if runtime <> 0 then
  begin
    config_canonical_nans := ProcAddress('wasm_config_canonical_nans');
    config_push_middleware := ProcAddress('wasm_config_push_middleware');
    config_set_compiler := ProcAddress('wasm_config_set_compiler');
    config_set_engine := ProcAddress('wasm_config_set_engine');
    config_set_features := ProcAddress('wasm_config_set_features');
    config_set_target := ProcAddress('wasm_config_set_target');
    cpu_features_add := ProcAddress('wasmer_cpu_features_add');
    cpu_features_delete := ProcAddress('wasmer_cpu_features_delete');
    cpu_features_new := ProcAddress('wasmer_cpu_features_new');
    features_bulk_memory := ProcAddress('wasmer_features_bulk_memory');
    features_delete := ProcAddress('wasmer_features_delete');
    features_memory64 := ProcAddress('wasmer_features_memory64');
    features_module_linking := ProcAddress('wasmer_features_module_linking');
    features_multi_memory := ProcAddress('wasmer_features_multi_memory');
    features_multi_value := ProcAddress('wasmer_features_multi_value');
    features_new := ProcAddress('wasmer_features_new');
    features_reference_types := ProcAddress('wasmer_features_reference_types');
    features_simd := ProcAddress('wasmer_features_simd');
    features_tail_call := ProcAddress('wasmer_features_tail_call');
    features_threads := ProcAddress('wasmer_features_threads');
    is_compiler_available := ProcAddress('wasmer_is_compiler_available');
    is_engine_available := ProcAddress('wasmer_is_engine_available');
    is_headless := ProcAddress('wasmer_is_headless');
    last_error_length := ProcAddress('wasmer_last_error_length');
    last_error_message := ProcAddress('wasmer_last_error_message');
    metering_as_middleware := ProcAddress('wasmer_metering_as_middleware');
    metering_delete := ProcAddress('wasmer_metering_delete');
    metering_get_remaining_points := ProcAddress('wasmer_metering_get_remaining_points');
    metering_new := ProcAddress('wasmer_metering_new');
    metering_points_are_exhausted := ProcAddress('wasmer_metering_points_are_exhausted');
    metering_set_remaining_points := ProcAddress('wasmer_metering_set_remaining_points');
    module_name := ProcAddress('wasmer_module_name');
    module_set_name := ProcAddress('wasmer_module_set_name');
    named_extern_module := ProcAddress('wasmer_named_extern_module');
    named_extern_name := ProcAddress('wasmer_named_extern_name');
    named_extern_unwrap := ProcAddress('wasmer_named_extern_unwrap');
    named_extern_vec_copy := ProcAddress('wasmer_named_extern_vec_copy');
    named_extern_vec_delete := ProcAddress('wasmer_named_extern_vec_delete');
    named_extern_vec_new := ProcAddress('wasmer_named_extern_vec_new');
    named_extern_vec_new_empty := ProcAddress('wasmer_named_extern_vec_new_empty');
    named_extern_vec_new_uninitialized := ProcAddress('wasmer_named_extern_vec_new_uninitialized');
    target_delete := ProcAddress('wasmer_target_delete');
    target_new := ProcAddress('wasmer_target_new');
    triple_delete := ProcAddress('wasmer_triple_delete');
    triple_new := ProcAddress('wasmer_triple_new');
    triple_new_from_host := ProcAddress('wasmer_triple_new_from_host');
    version := ProcAddress('wasmer_version');
    version_major := ProcAddress('wasmer_version_major');
    version_minor := ProcAddress('wasmer_version_minor');
    version_patch := ProcAddress('wasmer_version_patch');
    version_pre := ProcAddress('wasmer_version_pre');

    wat2wasm := ProcAddress('wat2wasm');
  end;
end;


function TWasmer.IsCompilerAvailable(compiler: TWasmerCompiler): Boolean;
begin
  result := is_compiler_available(compiler);
end;

function TWasmer.IsEngineAvailable(engine: TWasmerEngine): Boolean;
begin
  result := is_engine_available(engine);
end;

function TWasmer.IsHeadless: Boolean;
begin
  result := is_headless();
end;

function TWasmer.LastErrorMessage: string;
begin
  var len := last_error_length();
  var buf := TArray<Byte>.Create();
  SetLength(buf, len+1);
  last_error_message(@buf[0], len);
  var u8 := UTF8String(PAnsiChar(@buf[0]));
  result := string(u8);
end;

{ TWasi }

function TWasi.GetImports(const store: PWasmStore; const module: PWasmModule; const wasi_env: PWasiEnv; imports: PWasmExternVec): Boolean;
begin
  result := TWasi.get_imports(store, module, wasi_env, imports);
end;

function TWasi.GetStartFunction(instance: PWasmInstance): PWasmFunc;
begin
  result := TWasi.get_start_function(instance);
end;

function TWasi.GetUnorderedImports(const store: PWasmStore; const module: PWasmModule; const wasi_env: PWasiEnv; imports: PWasmerNamedExternVec): Boolean;
begin
  result := TWasi.get_unordered_imports(store, module, wasi_env, imports);
end;

function TWasi.GetWasiVersion(const module: PWasmModule): TWasmerWasiVersion;
begin
  result := TWasi.get_wasi_version(module);
end;

class procedure TWasi.InitAPIs(runtime: HMODULE);
  function ProcAddress(name : string) : Pointer;
  begin
    result := GetProcAddress(runtime, PWideChar(name));
  end;

begin

  if runtime <> 0 then
  begin
    config_arg := ProcAddress('wasi_config_arg');
    config_capture_stderr := ProcAddress('wasi_config_capture_stderr');
    config_capture_stdout := ProcAddress('wasi_config_capture_stdout');
    config_env := ProcAddress('wasi_config_env');
    config_inherit_stderr := ProcAddress('wasi_config_inherit_stderr');
    config_inherit_stdin := ProcAddress('wasi_config_inherit_stdin');
    config_ibherit_stdout := ProcAddress('wasi_config_ibherit_stdout');
    config_mapdir := ProcAddress('wasi_config_mapdir');
    config_new := ProcAddress('wasi_config_new');
    config_preopen_dir := ProcAddress('wasi_config_preopen_dir');
    env_delete := ProcAddress('wasi_env_delete');
    env_new := ProcAddress('wasi_env_new');
    env_read_stderr := ProcAddress('wasi_env_read_stderr');
    env_read_stdout := ProcAddress('wasi_env_read_stdout');
    get_imports := ProcAddress('wasi_get_imports');
    get_start_function := ProcAddress('wasi_get_start_function');
    get_unordered_imports := ProcAddress('wasi_get_unordered_imports');
    get_wasi_version := ProcAddress('wasi_get_wasi_version');
  end;
end;

// [OwnImplBegin]

{ TOwnWasiEnv }

procedure wasi_env_disposer(p : Pointer);
begin
  TWasi.env_delete(p);
end;

class operator TOwnWasiEnv.Finalize(var Dest: TOwnWasiEnv);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasiEnv.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasiEnv.Negative(Src: TOwnWasiEnv): IRcContainer<PWasiEnv>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasiEnv.Positive(Src: TOwnWasiEnv): PWasiEnv;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasiEnv.Implicit(const Src : IRcContainer<PWasiEnv>) : TOwnWasiEnv;
begin
  result.FStrongRef := Src;
end;

function TOwnWasiEnv.Unwrap: PWasiEnv;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasiEnv.Wrap(p : PWasiEnv) : TOwnWasiEnv;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasiEnv>.Create(p, wasi_env_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasiEnv.Wrap(p : PWasiEnv; deleter : TRcDeleter) : TOwnWasiEnv;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasiEnv>.Create(p, deleter)
  else result.FStrongRef := nil;
end;

{ TOwnWasmerCpuFeatures }

procedure wasmer_cpu_features_disposer(p : Pointer);
begin
  TWasmer.cpu_features_delete(p);
end;

class operator TOwnWasmerCpuFeatures.Finalize(var Dest: TOwnWasmerCpuFeatures);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmerCpuFeatures.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmerCpuFeatures.Negative(Src: TOwnWasmerCpuFeatures): IRcContainer<PWasmerCpuFeatures>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmerCpuFeatures.Positive(Src: TOwnWasmerCpuFeatures): PWasmerCpuFeatures;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmerCpuFeatures.Implicit(const Src : IRcContainer<PWasmerCpuFeatures>) : TOwnWasmerCpuFeatures;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmerCpuFeatures.Unwrap: PWasmerCpuFeatures;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmerCpuFeatures.Wrap(p : PWasmerCpuFeatures) : TOwnWasmerCpuFeatures;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmerCpuFeatures>.Create(p, wasmer_cpu_features_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasmerCpuFeatures.Wrap(p : PWasmerCpuFeatures; deleter : TRcDeleter) : TOwnWasmerCpuFeatures;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmerCpuFeatures>.Create(p, deleter)
  else result.FStrongRef := nil;
end;

{ TOwnWasmerFeatures }

procedure wasmer_features_disposer(p : Pointer);
begin
  TWasmer.features_delete(p);
end;

class operator TOwnWasmerFeatures.Finalize(var Dest: TOwnWasmerFeatures);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmerFeatures.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmerFeatures.Negative(Src: TOwnWasmerFeatures): IRcContainer<PWasmerFeatures>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmerFeatures.Positive(Src: TOwnWasmerFeatures): PWasmerFeatures;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmerFeatures.Implicit(const Src : IRcContainer<PWasmerFeatures>) : TOwnWasmerFeatures;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmerFeatures.Unwrap: PWasmerFeatures;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmerFeatures.Wrap(p : PWasmerFeatures) : TOwnWasmerFeatures;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmerFeatures>.Create(p, wasmer_features_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasmerFeatures.Wrap(p : PWasmerFeatures; deleter : TRcDeleter) : TOwnWasmerFeatures;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmerFeatures>.Create(p, deleter)
  else result.FStrongRef := nil;
end;

{ TOwnWasmerMetering }

procedure wasmer_metering_disposer(p : Pointer);
begin
  TWasmer.metering_delete(p);
end;

class operator TOwnWasmerMetering.Finalize(var Dest: TOwnWasmerMetering);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmerMetering.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmerMetering.Negative(Src: TOwnWasmerMetering): IRcContainer<PWasmerMetering>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmerMetering.Positive(Src: TOwnWasmerMetering): PWasmerMetering;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmerMetering.Implicit(const Src : IRcContainer<PWasmerMetering>) : TOwnWasmerMetering;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmerMetering.Unwrap: PWasmerMetering;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmerMetering.Wrap(p : PWasmerMetering) : TOwnWasmerMetering;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmerMetering>.Create(p, wasmer_metering_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasmerMetering.Wrap(p : PWasmerMetering; deleter : TRcDeleter) : TOwnWasmerMetering;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmerMetering>.Create(p, deleter)
  else result.FStrongRef := nil;
end;

{ TOwnWasmerNamedExternVec }

procedure wasmer_named_extern_vec_disposer(p : Pointer);
begin
  TWasmer.named_extern_vec_delete(p);
end;

class operator TOwnWasmerNamedExternVec.Finalize(var Dest: TOwnWasmerNamedExternVec);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmerNamedExternVec.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmerNamedExternVec.Negative(Src: TOwnWasmerNamedExternVec): IRcContainer<PWasmerNamedExternVec>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmerNamedExternVec.Positive(Src: TOwnWasmerNamedExternVec): PWasmerNamedExternVec;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmerNamedExternVec.Implicit(const Src : IRcContainer<PWasmerNamedExternVec>) : TOwnWasmerNamedExternVec;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmerNamedExternVec.Unwrap: PWasmerNamedExternVec;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmerNamedExternVec.Wrap(p : PWasmerNamedExternVec) : TOwnWasmerNamedExternVec;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmerNamedExternVec>.Create(p, wasmer_named_extern_vec_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasmerNamedExternVec.Wrap(p : PWasmerNamedExternVec; deleter : TRcDeleter) : TOwnWasmerNamedExternVec;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmerNamedExternVec>.Create(p, deleter)
  else result.FStrongRef := nil;
end;

{ TOwnWasmerTarget }

procedure wasmer_target_disposer(p : Pointer);
begin
  TWasmer.target_delete(p);
end;

class operator TOwnWasmerTarget.Finalize(var Dest: TOwnWasmerTarget);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmerTarget.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmerTarget.Negative(Src: TOwnWasmerTarget): IRcContainer<PWasmerTarget>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmerTarget.Positive(Src: TOwnWasmerTarget): PWasmerTarget;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmerTarget.Implicit(const Src : IRcContainer<PWasmerTarget>) : TOwnWasmerTarget;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmerTarget.Unwrap: PWasmerTarget;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmerTarget.Wrap(p : PWasmerTarget) : TOwnWasmerTarget;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmerTarget>.Create(p, wasmer_target_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasmerTarget.Wrap(p : PWasmerTarget; deleter : TRcDeleter) : TOwnWasmerTarget;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmerTarget>.Create(p, deleter)
  else result.FStrongRef := nil;
end;

{ TOwnWasmerTriple }

procedure wasmer_triple_disposer(p : Pointer);
begin
  TWasmer.triple_delete(p);
end;

class operator TOwnWasmerTriple.Finalize(var Dest: TOwnWasmerTriple);
begin
  Dest.FStrongRef := nil;
end;


function TOwnWasmerTriple.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOwnWasmerTriple.Negative(Src: TOwnWasmerTriple): IRcContainer<PWasmerTriple>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnWasmerTriple.Positive(Src: TOwnWasmerTriple): PWasmerTriple;
begin
  result := Src.Unwrap;
end;

class operator TOwnWasmerTriple.Implicit(const Src : IRcContainer<PWasmerTriple>) : TOwnWasmerTriple;
begin
  result.FStrongRef := Src;
end;

function TOwnWasmerTriple.Unwrap: PWasmerTriple;
begin
  result := FStrongRef.Unwrap;
end;

class function TOwnWasmerTriple.Wrap(p : PWasmerTriple) : TOwnWasmerTriple;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmerTriple>.Create(p, wasmer_triple_disposer)
  else result.FStrongRef := nil;
end;

class function TOwnWasmerTriple.Wrap(p : PWasmerTriple; deleter : TRcDeleter) : TOwnWasmerTriple;
begin
  if p <> nil then result.FStrongRef := TRcContainer<PWasmerTriple>.Create(p, deleter)
  else result.FStrongRef := nil;
end;
// [OwnImplEnd]


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

  TWasmer.wat2wasm(binary.Unwrap, @self);
  result := true;
end;

procedure TWasmByteVecHelper.Wat2Wasm(wat: string);
begin
  var binary := TWasmByteVec.NewFromString(wat);
  TWasmer.wat2wasm(binary.Unwrap, @self);
end;

{ TWasmerConfig }

procedure TWasmerConfig.CanonicalizeNans(enable: Boolean);
begin
  TWasmer.config_canonical_nans(@self, enable);
end;

procedure TWasmerConfig.PushMiddleware(middleware: PWasmerMiddleWare);
begin
  TWasmer.config_push_middleware(@self, middleware);
end;

procedure TWasmerConfig.SetCompiler(compiler: TWasmerCompiler);
begin
  TWasmer.config_set_compiler(@self, compiler);
end;

procedure TWasmerConfig.SetEngine(engine: TWasmerEngine);
begin
  TWasmer.config_set_engine(@self, engine);
end;

procedure TWasmerConfig.SetFeatures(features: TOwnWasmerFeatures);
begin
  TWasmer.config_set_features(@self, (-features).Move);
end;

procedure TWasmerConfig.SetTarget(target: TOwnWasmerTarget);
begin
  TWasmer.config_set_target(@self, (-target).Move);
end;

{ TWasmerCpuFeatures }

function TWasmerCpuFeatures.CpuFeaturesAdd(const feature: string): Boolean;
begin
  var pn := TWasmName.NewFromString(feature);
  TWasmer.cpu_features_add(@self, PWasmName(+pn));
end;

class function TWasmerCpuFeatures.New: TOwnWasmerCpuFeatures;
begin
  var p := TWasmer.cpu_features_new();
  result :=  TOwnWasmerCpuFeatures.Wrap(p);
end;

{ TWasmerFeatures }

function TWasmerFeatures.BulkMemory(enable: Boolean): Boolean;
begin
  result := TWasmer.features_bulk_memory(@self, enable);
end;

function TWasmerFeatures.Memory64(enable: Boolean): Boolean;
begin
  result := TWasmer.features_memory64(@self, enable);
end;

function TWasmerFeatures.ModuleLinking(enable: Boolean): Boolean;
begin
  result := TWasmer.features_module_linking(@self, enable);
end;

function TWasmerFeatures.MultiMemory(enable: Boolean): Boolean;
begin
  result := TWasmer.features_multi_memory(@self, enable);
end;

function TWasmerFeatures.MultiValue(enable: Boolean): Boolean;
begin
  result := TWasmer.features_multi_value(@self, enable);
end;

class function TWasmerFeatures.New: TOwnWasmerFeatures;
begin
  var p := TWasmer.features_new();
  result := TOwnWasmerFeatures.Wrap(p);
end;

function TWasmerFeatures.ReferenceTypes(enable: Boolean): Boolean;
begin
  result := TWasmer.features_reference_types(@self, enable);
end;

function TWasmerFeatures.Simd(enable: Boolean): Boolean;
begin
  result := TWasmer.features_simd(@self, enable);
end;

function TWasmerFeatures.TailCall(enable: Boolean): Boolean;
begin
  result := TWasmer.features_tail_call(@self, enable);
end;

function TWasmerFeatures.Threads(enable: Boolean): Boolean;
begin
  result := TWasmer.features_threads(@self, enable);
end;

{ TWasiConfig }

procedure TWasiConfig.Arg(const arg: string);
begin
  var u8 := UTF8String(arg);
  TWasi.config_arg(@self, PAnsiChar(u8));
end;

procedure TWasiConfig.CaptureStderr;
begin
  TWasi.config_capture_stderr(@self);
end;

procedure TWasiConfig.CaptureStdout;
begin
  TWasi.config_capture_stdout(@self);
end;

procedure TWasiConfig.Env(const key, value: string);
begin
  var u8key := UTF8String(key);
  var u8value := UTF8String(value);
  TWasi.config_env(@self, PAnsiChar(u8key), PAnsiChar(u8value));
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
  TWasi.config_ibherit_stdout(@self);
end;

function TWasiConfig.Mapdir(const alias, dir: string): Boolean;
begin
  var u8alias := UTF8String(alias);
  var u8dir := UTF8String(dir);
  result := TWasi.config_mapdir(@self, PAnsiChar(u8alias), PAnsiChar(u8dir));
end;

class function TWasiConfig.New(const program_name: string): PWasiConfig;
begin
  var u8 := UTF8String(program_name);
  var p := TWasi.config_new(PAnsiChar(u8));
  result := p;
end;

function TWasiConfig.PreopenDir(const dir: string): Boolean;
begin
  var u8 := UTF8String(dir);
  result := TWasi.config_preopen_dir(@self, PAnsiChar(u8));
end;

{ TWasiEnv }

class function TWasiEnv.New(config: PWasiConfig): TOwnWasiEnv;
begin
  var p := TWasi.env_new(config);
  result := TOwnWasiEnv.Wrap(p);
end;

function TWasiEnv.ReadStderr(buffer: PByte; len: NativeUInt): PInteger;
begin
  result := TWasi.env_read_stderr(@self, buffer, len);
end;

function TWasiEnv.ReadStdout(buffer: PByte; len: NativeUInt): PInteger;
begin
  result := TWasi.env_read_stdout(@self, buffer, len);
end;

{ TWasmerMetering }

function TWasmerMetering.AsMiddleware: PWasmerMiddleware;
begin
  result := TWasmer.metering_as_middleware(@self);
end;

function TWasmerMetering.GetRemainingPoints(instance: PWasmInstance): UInt64;
begin
  result := TWasmer.metering_get_remaining_points(instance);
end;

class function TWasmerMetering.New(initial_limit: UInt64; cost_function: TWasmerMeteringCostFunction): TOwnWasmerMetering;
begin
  var p := TWasmer.metering_new(initial_limit, cost_function);
  result := TOwnWasmerMetering.Wrap(p);
end;

function TWasmerMetering.PointsAreExhausted(instance: PWasmInstance): boolean;
begin
  result := TWasmer.metering_points_are_exhausted(instance);
end;

procedure TWasmerMetering.SetRemainingPoints(instance: PWasmInstance; new_limit: UInt64);
begin
  TWasmer.metering_set_remaining_points(instance, new_limit);
end;

{ TWasmerNamedExtern }

function TWasmerNamedExtern.Module: string;
begin
  var p := TWasmer.named_extern_module(@self);
  result := p.AsString;
end;

function TWasmerNamedExtern.Name: string;
begin
  var p := TWasmer.named_extern_name(@self);
  result := p.AsString;
end;

function TWasmerNamedExtern.Unwrap: PWasmExtern;
begin
  result := TWasmer.named_extern_unwrap(@self);
end;

{ TWasmerTarget }

class function TWasmerTarget.New(triple: PWasmerTriple; cpu_features: TOwnWasmerCpuFeatures): TOwnWasmerTarget;
begin
  var p := TWasmer.target_new(triple, (-cpu_features).Move);
  result := TOwnWasmerTarget.Wrap(p);
end;

{ TWasmerTriple }

class function TWasmerTriple.New(const triple: string): TOwnWasmerTriple;
begin
  var tn := TWasmName.NewFromString(triple);
  var p := TWasmer.triple_new(PWasmName(+tn));
  result := TOwnWasmerTriple.Wrap(p);
end;

class function TWasmerTriple.NewFromHost: TOwnWasmerTriple;
begin
  var p := TWasmer.triple_new_from_host();
  result := TOwnWasmerTriple.Wrap(p);
end;

{ TWasmerNamedExternVec }

procedure wasmer_named_extern_vec_disposer_host(p : Pointer);
begin
  TWasmer.named_extern_vec_delete(p);
  Dispose(p);
end;

function TWasmerNamedExternVec.Copy: TOwnWasmerNamedExternVec;
begin
  var out_ : PWasmerNamedExternVec;
  System.New(out_);
  TWasmer.named_extern_vec_copy(out_, @self);
  result := TOwnWasmerNamedExternVec.Wrap(out_, wasmer_named_extern_vec_disposer_host);
end;

class function TWasmerNamedExternVec.New(length: PUInt32; const init: PPWasmerNamedExtern): TOwnWasmerNamedExternVec;
begin
  var out_ : PWasmerNamedExternVec;
  System.New(out_);
  TWasmer.named_extern_vec_new(out_, length, init);
  result := TOwnWasmerNamedExternVec.Wrap(out_, wasmer_named_extern_vec_disposer_host);
end;

class function TWasmerNamedExternVec.NewEmpty: TOwnWasmerNamedExternVec;
begin
  var out_ : PWasmerNamedExternVec;
  System.New(out_);
  TWasmer.named_extern_vec_new_empty(out_);
  result := TOwnWasmerNamedExternVec.Wrap(out_, wasmer_named_extern_vec_disposer_host);
end;

class function TWasmerNamedExternVec.NewUninitialized(length: PUInt32): TOwnWasmerNamedExternVec;
begin
  var out_ : PWasmerNamedExternVec;
  System.New(out_);
  TWasmer.named_extern_vec_new_uninitialized(out_, length);
  result := TOwnWasmerNamedExternVec.Wrap(out_, wasmer_named_extern_vec_disposer_host);
end;

{ TWasmerModule }

function TWasmerModule.Name: string;
begin
  var pn : PWasmName;
  System.New(pn);
  try
    TWasmer.module_name(@self, pn);
    result := pn.AsString;
  finally
    TWasm.byte_vec_delete(PWasmByteVec(pn));
    Dispose(pn);
  end;
end;

function TWasmerModule.SetName(const name: string): Boolean;
begin
  var pn := TWasmName.NewFromString(name);
  result := TWasmer.module_set_name(@self, PWasmName(+pn));
end;

end.
