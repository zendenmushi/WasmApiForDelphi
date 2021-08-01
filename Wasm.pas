// WebAssembly C API -> Delphi
unit Wasm;

interface
uses
  System.SysUtils, Ownership;

type
  // vector utility
  TWasmVec<T> = record
  public type
    PT = ^T;
  private
    size : NativeInt; // ** offset+0:size   : Same  wasm_xxx_vec_t
    data : PT;        // ** offset+8:bodies : Same  wasm_xxx_vec_t
  private
    function GetItem(i : Integer) : T;
    procedure SetItem(i : Integer; Value : T);
    function GetPointers(i : Integer) : Pointer;
  public
    constructor Create(size : NativeInt; data : PT); overload;
    constructor Create(const arry : array of T); overload;
    class operator Implicit(const arry : array of T) : TWasmVec<T>;
    property Items[i : Integer] : T read GetItem write SetItem; default;
    property Pointers[i : Integer] : Pointer read GetPointers;
  end;

  TWasmMutability = (WASM_CONST, WASM_VAR);

  PWasmLimits = ^TWasmLimits;
  TWasmLimits = record
  public
    min : Cardinal;
    max : Cardinal;
  public
    constructor Create(min, max : Cardinal);
  end;

  TWasmExternKind = (WASM_EXTERN_FUNC, WASM_EXTERN_GLOBAL, WASM_EXTERN_TABLE, WASM_EXTERN_MEMORY);

  TWasmValkind = (WASM_I32, WASM_I64, WASM_F32, WASM_F64, WASM_ANYREF=128, WASM_FUNCREF);

  TWasmValKindHelper = record helper for TWasmValKind
    function IsNum : Boolean;
    function IsRef : Boolean;
  end;

  TWasmByte = Byte;
  PWasmByte = ^TWasmByte;
  TWasmTableSize = Cardinal;
  TWasmMemoryPages = Cardinal;

    TWasmUnwrapProc<T> = reference to procedure(data : T);

  PWasmByteVec = ^TWasmByteVec;
  PPWasmByteVec = ^PWasmByteVec;
  PWasmConfig = ^TWasmConfig;
  PPWasmConfig = ^PWasmConfig;
  PWasmEngine = ^TWasmEngine;
  PPWasmEngine = ^PWasmEngine;
  PWasmStore = ^TWasmStore;
  PPWasmStore = ^PWasmStore;
  PWasmValtype = ^TWasmValtype;
  PPWasmValtype = ^PWasmValtype;
  PWasmValtypeVec = ^TWasmValtypeVec;
  PPWasmValtypeVec = ^PWasmValtypeVec;
  PWasmFunctype = ^TWasmFunctype;
  PPWasmFunctype = ^PWasmFunctype;
  PWasmFunctypeVec = ^TWasmFunctypeVec;
  PPWasmFunctypeVec = ^PWasmFunctypeVec;
  PWasmGlobaltype = ^TWasmGlobaltype;
  PPWasmGlobaltype = ^PWasmGlobaltype;
  PWasmGlobaltypeVec = ^TWasmGlobaltypeVec;
  PPWasmGlobaltypeVec = ^PWasmGlobaltypeVec;
  PWasmTabletype = ^TWasmTabletype;
  PPWasmTabletype = ^PWasmTabletype;
  PWasmTabletypeVec = ^TWasmTabletypeVec;
  PPWasmTabletypeVec = ^PWasmTabletypeVec;
  PWasmMemorytype = ^TWasmMemorytype;
  PPWasmMemorytype = ^PWasmMemorytype;
  PWasmMemorytypeVec = ^TWasmMemorytypeVec;
  PPWasmMemorytypeVec = ^PWasmMemorytypeVec;
  PWasmExterntype = ^TWasmExterntype;
  PPWasmExterntype = ^PWasmExterntype;
  PWasmExterntypeVec = ^TWasmExterntypeVec;
  PPWasmExterntypeVec = ^PWasmExterntypeVec;
  PWasmImporttype = ^TWasmImporttype;
  PPWasmImporttype = ^PWasmImporttype;
  PWasmImporttypeVec = ^TWasmImporttypeVec;
  PPWasmImporttypeVec = ^PWasmImporttypeVec;
  PWasmExporttype = ^TWasmExporttype;
  PPWasmExporttype = ^PWasmExporttype;
  PWasmExporttypeVec = ^TWasmExporttypeVec;
  PPWasmExporttypeVec = ^PWasmExporttypeVec;
  PWasmVal = ^TWasmVal;
  PPWasmVal = ^PWasmVal;
  PWasmValVec = ^TWasmValVec;
  PPWasmValVec = ^PWasmValVec;
  PWasmRef = ^TWasmRef;
  PPWasmRef = ^PWasmRef;
  PWasmFrame = ^TWasmFrame;
  PPWasmFrame = ^PWasmFrame;
  PWasmFrameVec = ^TWasmFrameVec;
  PPWasmFrameVec = ^PWasmFrameVec;
  PWasmTrap = ^TWasmTrap;
  PPWasmTrap = ^PWasmTrap;
  PWasmForeign = ^TWasmForeign;
  PPWasmForeign = ^PWasmForeign;
  PWasmModule = ^TWasmModule;
  PPWasmModule = ^PWasmModule;
  PWasmSharedModule = ^TWasmSharedModule;
  PPWasmSharedModule = ^PWasmSharedModule;
  PWasmFunc = ^TWasmFunc;
  PPWasmFunc = ^PWasmFunc;
  PWasmGlobal = ^TWasmGlobal;
  PPWasmGlobal = ^PWasmGlobal;
  PWasmTable = ^TWasmTable;
  PPWasmTable = ^PWasmTable;
  PWasmMemory = ^TWasmMemory;
  PPWasmMemory = ^PWasmMemory;
  PWasmExtern = ^TWasmExtern;
  PPWasmExtern = ^PWasmExtern;
  PWasmExternVec = ^TWasmExternVec;
  PPWasmExternVec = ^PWasmExternVec;
  PWasmInstance = ^TWasmInstance;
  PPWasmInstance = ^PWasmInstance;

  TOwnByteVec = record  // = TRc<PWasmByteVec>
  public
    FStrongRef : IRcContainer<PWasmByteVec>;
  public
    class function Wrap(p : PWasmByteVec; deleter : TRcDeleter) : TOwnByteVec; overload; static; inline;
    class function Wrap(p : PWasmByteVec) : TOwnByteVec; overload; static;
    class operator Finalize(var Dest: TOwnByteVec);
    class operator Implicit(const Src : IRcContainer<PWasmByteVec>) : TOwnByteVec; overload;
    class operator Positive(Src : TOwnByteVec) : PWasmByteVec;
    class operator Negative(Src : TOwnByteVec) : IRcContainer<PWasmByteVec>;
    function Unwrap() : PWasmByteVec;
    function IsNone() : Boolean;
  end;


  TOwnName = TOwnByteVec;
  TOwnMessage = TOwnName;

  TOwnConfig = record  // = TRc<PWasmConfig>
  public
    FStrongRef : IRcContainer<PWasmConfig>;
  public
    class function Wrap(p : PWasmConfig; deleter : TRcDeleter) : TOwnConfig; overload; static; inline;
    class function Wrap(p : PWasmConfig) : TOwnConfig; overload; static;
    class operator Finalize(var Dest: TOwnConfig);
    class operator Implicit(const Src : IRcContainer<PWasmConfig>) : TOwnConfig; overload;
    class operator Positive(Src : TOwnConfig) : PWasmConfig;
    class operator Negative(Src : TOwnConfig) : IRcContainer<PWasmConfig>;
    function Unwrap() : PWasmConfig;
    function IsNone() : Boolean;
  end;


  TOwnEngine = record  // = TRc<PWasmEngine>
  public
    FStrongRef : IRcContainer<PWasmEngine>;
  public
    class function Wrap(p : PWasmEngine; deleter : TRcDeleter) : TOwnEngine; overload; static; inline;
    class function Wrap(p : PWasmEngine) : TOwnEngine; overload; static;
    class operator Finalize(var Dest: TOwnEngine);
    class operator Implicit(const Src : IRcContainer<PWasmEngine>) : TOwnEngine; overload;
    class operator Positive(Src : TOwnEngine) : PWasmEngine;
    class operator Negative(Src : TOwnEngine) : IRcContainer<PWasmEngine>;
    function Unwrap() : PWasmEngine;
    function IsNone() : Boolean;
  end;


  TOwnStore = record  // = TRc<PWasmStore>
  public
    FStrongRef : IRcContainer<PWasmStore>;
  public
    class function Wrap(p : PWasmStore; deleter : TRcDeleter) : TOwnStore; overload; static; inline;
    class function Wrap(p : PWasmStore) : TOwnStore; overload; static;
    class operator Finalize(var Dest: TOwnStore);
    class operator Implicit(const Src : IRcContainer<PWasmStore>) : TOwnStore; overload;
    class operator Positive(Src : TOwnStore) : PWasmStore;
    class operator Negative(Src : TOwnStore) : IRcContainer<PWasmStore>;
    function Unwrap() : PWasmStore;
    function IsNone() : Boolean;
  end;


  TOwnValtypeVec = record  // = TRc<PWasmValtypeVec>
  public
    FStrongRef : IRcContainer<PWasmValtypeVec>;
  public
    class function Wrap(p : PWasmValtypeVec; deleter : TRcDeleter) : TOwnValtypeVec; overload; static; inline;
    class function Wrap(p : PWasmValtypeVec) : TOwnValtypeVec; overload; static;
    class operator Finalize(var Dest: TOwnValtypeVec);
    class operator Implicit(const Src : IRcContainer<PWasmValtypeVec>) : TOwnValtypeVec; overload;
    class operator Positive(Src : TOwnValtypeVec) : PWasmValtypeVec;
    class operator Negative(Src : TOwnValtypeVec) : IRcContainer<PWasmValtypeVec>;
    function Unwrap() : PWasmValtypeVec;
    function IsNone() : Boolean;
  end;


  TOwnValtype = record  // = TRc<PWasmValtype>
  public
    FStrongRef : IRcContainer<PWasmValtype>;
  public
    class function Wrap(p : PWasmValtype; deleter : TRcDeleter) : TOwnValtype; overload; static; inline;
    class function Wrap(p : PWasmValtype) : TOwnValtype; overload; static;
    class operator Finalize(var Dest: TOwnValtype);
    class operator Implicit(const Src : IRcContainer<PWasmValtype>) : TOwnValtype; overload;
    class operator Positive(Src : TOwnValtype) : PWasmValtype;
    class operator Negative(Src : TOwnValtype) : IRcContainer<PWasmValtype>;
    function Unwrap() : PWasmValtype;
    function IsNone() : Boolean;
  end;


  TOwnFunctypeVec = record  // = TRc<PWasmFunctypeVec>
  public
    FStrongRef : IRcContainer<PWasmFunctypeVec>;
  public
    class function Wrap(p : PWasmFunctypeVec; deleter : TRcDeleter) : TOwnFunctypeVec; overload; static; inline;
    class function Wrap(p : PWasmFunctypeVec) : TOwnFunctypeVec; overload; static;
    class operator Finalize(var Dest: TOwnFunctypeVec);
    class operator Implicit(const Src : IRcContainer<PWasmFunctypeVec>) : TOwnFunctypeVec; overload;
    class operator Positive(Src : TOwnFunctypeVec) : PWasmFunctypeVec;
    class operator Negative(Src : TOwnFunctypeVec) : IRcContainer<PWasmFunctypeVec>;
    function Unwrap() : PWasmFunctypeVec;
    function IsNone() : Boolean;
  end;


  TOwnFunctype = record  // = TRc<PWasmFunctype>
  public
    FStrongRef : IRcContainer<PWasmFunctype>;
  public
    class function Wrap(p : PWasmFunctype; deleter : TRcDeleter) : TOwnFunctype; overload; static; inline;
    class function Wrap(p : PWasmFunctype) : TOwnFunctype; overload; static;
    class operator Finalize(var Dest: TOwnFunctype);
    class operator Implicit(const Src : IRcContainer<PWasmFunctype>) : TOwnFunctype; overload;
    class operator Positive(Src : TOwnFunctype) : PWasmFunctype;
    class operator Negative(Src : TOwnFunctype) : IRcContainer<PWasmFunctype>;
    function Unwrap() : PWasmFunctype;
    function IsNone() : Boolean;
  end;


  TOwnGlobaltypeVec = record  // = TRc<PWasmGlobaltypeVec>
  public
    FStrongRef : IRcContainer<PWasmGlobaltypeVec>;
  public
    class function Wrap(p : PWasmGlobaltypeVec; deleter : TRcDeleter) : TOwnGlobaltypeVec; overload; static; inline;
    class function Wrap(p : PWasmGlobaltypeVec) : TOwnGlobaltypeVec; overload; static;
    class operator Finalize(var Dest: TOwnGlobaltypeVec);
    class operator Implicit(const Src : IRcContainer<PWasmGlobaltypeVec>) : TOwnGlobaltypeVec; overload;
    class operator Positive(Src : TOwnGlobaltypeVec) : PWasmGlobaltypeVec;
    class operator Negative(Src : TOwnGlobaltypeVec) : IRcContainer<PWasmGlobaltypeVec>;
    function Unwrap() : PWasmGlobaltypeVec;
    function IsNone() : Boolean;
  end;


  TOwnGlobaltype = record  // = TRc<PWasmGlobaltype>
  public
    FStrongRef : IRcContainer<PWasmGlobaltype>;
  public
    class function Wrap(p : PWasmGlobaltype; deleter : TRcDeleter) : TOwnGlobaltype; overload; static; inline;
    class function Wrap(p : PWasmGlobaltype) : TOwnGlobaltype; overload; static;
    class operator Finalize(var Dest: TOwnGlobaltype);
    class operator Implicit(const Src : IRcContainer<PWasmGlobaltype>) : TOwnGlobaltype; overload;
    class operator Positive(Src : TOwnGlobaltype) : PWasmGlobaltype;
    class operator Negative(Src : TOwnGlobaltype) : IRcContainer<PWasmGlobaltype>;
    function Unwrap() : PWasmGlobaltype;
    function IsNone() : Boolean;
  end;


  TOwnTabletypeVec = record  // = TRc<PWasmTabletypeVec>
  public
    FStrongRef : IRcContainer<PWasmTabletypeVec>;
  public
    class function Wrap(p : PWasmTabletypeVec; deleter : TRcDeleter) : TOwnTabletypeVec; overload; static; inline;
    class function Wrap(p : PWasmTabletypeVec) : TOwnTabletypeVec; overload; static;
    class operator Finalize(var Dest: TOwnTabletypeVec);
    class operator Implicit(const Src : IRcContainer<PWasmTabletypeVec>) : TOwnTabletypeVec; overload;
    class operator Positive(Src : TOwnTabletypeVec) : PWasmTabletypeVec;
    class operator Negative(Src : TOwnTabletypeVec) : IRcContainer<PWasmTabletypeVec>;
    function Unwrap() : PWasmTabletypeVec;
    function IsNone() : Boolean;
  end;


  TOwnTabletype = record  // = TRc<PWasmTabletype>
  public
    FStrongRef : IRcContainer<PWasmTabletype>;
  public
    class function Wrap(p : PWasmTabletype; deleter : TRcDeleter) : TOwnTabletype; overload; static; inline;
    class function Wrap(p : PWasmTabletype) : TOwnTabletype; overload; static;
    class operator Finalize(var Dest: TOwnTabletype);
    class operator Implicit(const Src : IRcContainer<PWasmTabletype>) : TOwnTabletype; overload;
    class operator Positive(Src : TOwnTabletype) : PWasmTabletype;
    class operator Negative(Src : TOwnTabletype) : IRcContainer<PWasmTabletype>;
    function Unwrap() : PWasmTabletype;
    function IsNone() : Boolean;
  end;


  TOwnMemorytypeVec = record  // = TRc<PWasmMemorytypeVec>
  public
    FStrongRef : IRcContainer<PWasmMemorytypeVec>;
  public
    class function Wrap(p : PWasmMemorytypeVec; deleter : TRcDeleter) : TOwnMemorytypeVec; overload; static; inline;
    class function Wrap(p : PWasmMemorytypeVec) : TOwnMemorytypeVec; overload; static;
    class operator Finalize(var Dest: TOwnMemorytypeVec);
    class operator Implicit(const Src : IRcContainer<PWasmMemorytypeVec>) : TOwnMemorytypeVec; overload;
    class operator Positive(Src : TOwnMemorytypeVec) : PWasmMemorytypeVec;
    class operator Negative(Src : TOwnMemorytypeVec) : IRcContainer<PWasmMemorytypeVec>;
    function Unwrap() : PWasmMemorytypeVec;
    function IsNone() : Boolean;
  end;


  TOwnMemorytype = record  // = TRc<PWasmMemorytype>
  public
    FStrongRef : IRcContainer<PWasmMemorytype>;
  public
    class function Wrap(p : PWasmMemorytype; deleter : TRcDeleter) : TOwnMemorytype; overload; static; inline;
    class function Wrap(p : PWasmMemorytype) : TOwnMemorytype; overload; static;
    class operator Finalize(var Dest: TOwnMemorytype);
    class operator Implicit(const Src : IRcContainer<PWasmMemorytype>) : TOwnMemorytype; overload;
    class operator Positive(Src : TOwnMemorytype) : PWasmMemorytype;
    class operator Negative(Src : TOwnMemorytype) : IRcContainer<PWasmMemorytype>;
    function Unwrap() : PWasmMemorytype;
    function IsNone() : Boolean;
  end;


  TOwnExterntypeVec = record  // = TRc<PWasmExterntypeVec>
  public
    FStrongRef : IRcContainer<PWasmExterntypeVec>;
  public
    class function Wrap(p : PWasmExterntypeVec; deleter : TRcDeleter) : TOwnExterntypeVec; overload; static; inline;
    class function Wrap(p : PWasmExterntypeVec) : TOwnExterntypeVec; overload; static;
    class operator Finalize(var Dest: TOwnExterntypeVec);
    class operator Implicit(const Src : IRcContainer<PWasmExterntypeVec>) : TOwnExterntypeVec; overload;
    class operator Positive(Src : TOwnExterntypeVec) : PWasmExterntypeVec;
    class operator Negative(Src : TOwnExterntypeVec) : IRcContainer<PWasmExterntypeVec>;
    function Unwrap() : PWasmExterntypeVec;
    function IsNone() : Boolean;
  end;


  TOwnExterntype = record  // = TRc<PWasmExterntype>
  public
    FStrongRef : IRcContainer<PWasmExterntype>;
  public
    class function Wrap(p : PWasmExterntype; deleter : TRcDeleter) : TOwnExterntype; overload; static; inline;
    class function Wrap(p : PWasmExterntype) : TOwnExterntype; overload; static;
    class operator Finalize(var Dest: TOwnExterntype);
    class operator Implicit(const Src : IRcContainer<PWasmExterntype>) : TOwnExterntype; overload;
    class operator Positive(Src : TOwnExterntype) : PWasmExterntype;
    class operator Negative(Src : TOwnExterntype) : IRcContainer<PWasmExterntype>;
    function Unwrap() : PWasmExterntype;
    function IsNone() : Boolean;
  end;


  TOwnImporttypeVec = record  // = TRc<PWasmImporttypeVec>
  public
    FStrongRef : IRcContainer<PWasmImporttypeVec>;
  public
    class function Wrap(p : PWasmImporttypeVec; deleter : TRcDeleter) : TOwnImporttypeVec; overload; static; inline;
    class function Wrap(p : PWasmImporttypeVec) : TOwnImporttypeVec; overload; static;
    class operator Finalize(var Dest: TOwnImporttypeVec);
    class operator Implicit(const Src : IRcContainer<PWasmImporttypeVec>) : TOwnImporttypeVec; overload;
    class operator Positive(Src : TOwnImporttypeVec) : PWasmImporttypeVec;
    class operator Negative(Src : TOwnImporttypeVec) : IRcContainer<PWasmImporttypeVec>;
    function Unwrap() : PWasmImporttypeVec;
    function IsNone() : Boolean;
  end;


  TOwnImporttype = record  // = TRc<PWasmImporttype>
  public
    FStrongRef : IRcContainer<PWasmImporttype>;
  public
    class function Wrap(p : PWasmImporttype; deleter : TRcDeleter) : TOwnImporttype; overload; static; inline;
    class function Wrap(p : PWasmImporttype) : TOwnImporttype; overload; static;
    class operator Finalize(var Dest: TOwnImporttype);
    class operator Implicit(const Src : IRcContainer<PWasmImporttype>) : TOwnImporttype; overload;
    class operator Positive(Src : TOwnImporttype) : PWasmImporttype;
    class operator Negative(Src : TOwnImporttype) : IRcContainer<PWasmImporttype>;
    function Unwrap() : PWasmImporttype;
    function IsNone() : Boolean;
  end;


  TOwnExporttypeVec = record  // = TRc<PWasmExporttypeVec>
  public
    FStrongRef : IRcContainer<PWasmExporttypeVec>;
  public
    class function Wrap(p : PWasmExporttypeVec; deleter : TRcDeleter) : TOwnExporttypeVec; overload; static; inline;
    class function Wrap(p : PWasmExporttypeVec) : TOwnExporttypeVec; overload; static;
    class operator Finalize(var Dest: TOwnExporttypeVec);
    class operator Implicit(const Src : IRcContainer<PWasmExporttypeVec>) : TOwnExporttypeVec; overload;
    class operator Positive(Src : TOwnExporttypeVec) : PWasmExporttypeVec;
    class operator Negative(Src : TOwnExporttypeVec) : IRcContainer<PWasmExporttypeVec>;
    function Unwrap() : PWasmExporttypeVec;
    function IsNone() : Boolean;
  end;


  TOwnExporttype = record  // = TRc<PWasmExporttype>
  public
    FStrongRef : IRcContainer<PWasmExporttype>;
  public
    class function Wrap(p : PWasmExporttype; deleter : TRcDeleter) : TOwnExporttype; overload; static; inline;
    class function Wrap(p : PWasmExporttype) : TOwnExporttype; overload; static;
    class operator Finalize(var Dest: TOwnExporttype);
    class operator Implicit(const Src : IRcContainer<PWasmExporttype>) : TOwnExporttype; overload;
    class operator Positive(Src : TOwnExporttype) : PWasmExporttype;
    class operator Negative(Src : TOwnExporttype) : IRcContainer<PWasmExporttype>;
    function Unwrap() : PWasmExporttype;
    function IsNone() : Boolean;
  end;


  TOwnVal = record  // = TRc<PWasmVal>
  public
    FStrongRef : IRcContainer<PWasmVal>;
  public
    class function Wrap(p : PWasmVal; deleter : TRcDeleter) : TOwnVal; overload; static; inline;
    class function Wrap(p : PWasmVal) : TOwnVal; overload; static;
    class operator Finalize(var Dest: TOwnVal);
    class operator Implicit(const Src : IRcContainer<PWasmVal>) : TOwnVal; overload;
    class operator Positive(Src : TOwnVal) : PWasmVal;
    class operator Negative(Src : TOwnVal) : IRcContainer<PWasmVal>;
    function Unwrap() : PWasmVal;
    function IsNone() : Boolean;
  end;


  TOwnValVec = record  // = TRc<PWasmValVec>
  public
    FStrongRef : IRcContainer<PWasmValVec>;
  public
    class function Wrap(p : PWasmValVec; deleter : TRcDeleter) : TOwnValVec; overload; static; inline;
    class function Wrap(p : PWasmValVec) : TOwnValVec; overload; static;
    class operator Finalize(var Dest: TOwnValVec);
    class operator Implicit(const Src : IRcContainer<PWasmValVec>) : TOwnValVec; overload;
    class operator Positive(Src : TOwnValVec) : PWasmValVec;
    class operator Negative(Src : TOwnValVec) : IRcContainer<PWasmValVec>;
    function Unwrap() : PWasmValVec;
    function IsNone() : Boolean;
  end;


  TOwnRef = record  // = TRc<PWasmRef>
  public
    FStrongRef : IRcContainer<PWasmRef>;
  public
    class function Wrap(p : PWasmRef; deleter : TRcDeleter) : TOwnRef; overload; static; inline;
    class function Wrap(p : PWasmRef) : TOwnRef; overload; static;
    class operator Finalize(var Dest: TOwnRef);
    class operator Implicit(const Src : IRcContainer<PWasmRef>) : TOwnRef; overload;
    class operator Positive(Src : TOwnRef) : PWasmRef;
    class operator Negative(Src : TOwnRef) : IRcContainer<PWasmRef>;
    function Unwrap() : PWasmRef;
    function IsNone() : Boolean;
  end;


  TOwnFrame = record  // = TRc<PWasmFrame>
  public
    FStrongRef : IRcContainer<PWasmFrame>;
  public
    class function Wrap(p : PWasmFrame; deleter : TRcDeleter) : TOwnFrame; overload; static; inline;
    class function Wrap(p : PWasmFrame) : TOwnFrame; overload; static;
    class operator Finalize(var Dest: TOwnFrame);
    class operator Implicit(const Src : IRcContainer<PWasmFrame>) : TOwnFrame; overload;
    class operator Positive(Src : TOwnFrame) : PWasmFrame;
    class operator Negative(Src : TOwnFrame) : IRcContainer<PWasmFrame>;
    function Unwrap() : PWasmFrame;
    function IsNone() : Boolean;
  end;


  TOwnFrameVec = record  // = TRc<PWasmFrameVec>
  public
    FStrongRef : IRcContainer<PWasmFrameVec>;
  public
    class function Wrap(p : PWasmFrameVec; deleter : TRcDeleter) : TOwnFrameVec; overload; static; inline;
    class function Wrap(p : PWasmFrameVec) : TOwnFrameVec; overload; static;
    class operator Finalize(var Dest: TOwnFrameVec);
    class operator Implicit(const Src : IRcContainer<PWasmFrameVec>) : TOwnFrameVec; overload;
    class operator Positive(Src : TOwnFrameVec) : PWasmFrameVec;
    class operator Negative(Src : TOwnFrameVec) : IRcContainer<PWasmFrameVec>;
    function Unwrap() : PWasmFrameVec;
    function IsNone() : Boolean;
  end;


  TOwnTrap = record  // = TRc<PWasmTrap>
  public
    FStrongRef : IRcContainer<PWasmTrap>;
  public
    class function Wrap(p : PWasmTrap; deleter : TRcDeleter) : TOwnTrap; overload; static; inline;
    class function Wrap(p : PWasmTrap) : TOwnTrap; overload; static;
    class operator Finalize(var Dest: TOwnTrap);
    class operator Implicit(const Src : IRcContainer<PWasmTrap>) : TOwnTrap; overload;
    class operator Positive(Src : TOwnTrap) : PWasmTrap;
    class operator Negative(Src : TOwnTrap) : IRcContainer<PWasmTrap>;
    function Unwrap() : PWasmTrap;
    function IsNone() : Boolean;
    function IsError() : Boolean; overload;
    function IsError(proc : TWasmUnwrapProc<PWasmTrap>) : Boolean; overload;
  end;


  TOwnForeign = record  // = TRc<PWasmForeign>
  public
    FStrongRef : IRcContainer<PWasmForeign>;
  public
    class function Wrap(p : PWasmForeign; deleter : TRcDeleter) : TOwnForeign; overload; static; inline;
    class function Wrap(p : PWasmForeign) : TOwnForeign; overload; static;
    class operator Finalize(var Dest: TOwnForeign);
    class operator Implicit(const Src : IRcContainer<PWasmForeign>) : TOwnForeign; overload;
    class operator Positive(Src : TOwnForeign) : PWasmForeign;
    class operator Negative(Src : TOwnForeign) : IRcContainer<PWasmForeign>;
    function Unwrap() : PWasmForeign;
    function IsNone() : Boolean;
  end;


  TOwnModule = record  // = TRc<PWasmModule>
  public
    FStrongRef : IRcContainer<PWasmModule>;
  public
    class function Wrap(p : PWasmModule; deleter : TRcDeleter) : TOwnModule; overload; static; inline;
    class function Wrap(p : PWasmModule) : TOwnModule; overload; static;
    class operator Finalize(var Dest: TOwnModule);
    class operator Implicit(const Src : IRcContainer<PWasmModule>) : TOwnModule; overload;
    class operator Positive(Src : TOwnModule) : PWasmModule;
    class operator Negative(Src : TOwnModule) : IRcContainer<PWasmModule>;
    function Unwrap() : PWasmModule;
    function IsNone() : Boolean;
  end;


  TOwnSharedModule = record  // = TRc<PWasmSharedModule>
  public
    FStrongRef : IRcContainer<PWasmSharedModule>;
  public
    class function Wrap(p : PWasmSharedModule; deleter : TRcDeleter) : TOwnSharedModule; overload; static; inline;
    class function Wrap(p : PWasmSharedModule) : TOwnSharedModule; overload; static;
    class operator Finalize(var Dest: TOwnSharedModule);
    class operator Implicit(const Src : IRcContainer<PWasmSharedModule>) : TOwnSharedModule; overload;
    class operator Positive(Src : TOwnSharedModule) : PWasmSharedModule;
    class operator Negative(Src : TOwnSharedModule) : IRcContainer<PWasmSharedModule>;
    function Unwrap() : PWasmSharedModule;
    function IsNone() : Boolean;
  end;


  TOwnFunc = record  // = TRc<PWasmFunc>
  public
    FStrongRef : IRcContainer<PWasmFunc>;
  public
    class function Wrap(p : PWasmFunc; deleter : TRcDeleter) : TOwnFunc; overload; static; inline;
    class function Wrap(p : PWasmFunc) : TOwnFunc; overload; static;
    class operator Finalize(var Dest: TOwnFunc);
    class operator Implicit(const Src : IRcContainer<PWasmFunc>) : TOwnFunc; overload;
    class operator Positive(Src : TOwnFunc) : PWasmFunc;
    class operator Negative(Src : TOwnFunc) : IRcContainer<PWasmFunc>;
    function Unwrap() : PWasmFunc;
    function IsNone() : Boolean;
  end;


  TOwnGlobal = record  // = TRc<PWasmGlobal>
  public
    FStrongRef : IRcContainer<PWasmGlobal>;
  public
    class function Wrap(p : PWasmGlobal; deleter : TRcDeleter) : TOwnGlobal; overload; static; inline;
    class function Wrap(p : PWasmGlobal) : TOwnGlobal; overload; static;
    class operator Finalize(var Dest: TOwnGlobal);
    class operator Implicit(const Src : IRcContainer<PWasmGlobal>) : TOwnGlobal; overload;
    class operator Positive(Src : TOwnGlobal) : PWasmGlobal;
    class operator Negative(Src : TOwnGlobal) : IRcContainer<PWasmGlobal>;
    function Unwrap() : PWasmGlobal;
    function IsNone() : Boolean;
  end;


  TOwnTable = record  // = TRc<PWasmTable>
  public
    FStrongRef : IRcContainer<PWasmTable>;
  public
    class function Wrap(p : PWasmTable; deleter : TRcDeleter) : TOwnTable; overload; static; inline;
    class function Wrap(p : PWasmTable) : TOwnTable; overload; static;
    class operator Finalize(var Dest: TOwnTable);
    class operator Implicit(const Src : IRcContainer<PWasmTable>) : TOwnTable; overload;
    class operator Positive(Src : TOwnTable) : PWasmTable;
    class operator Negative(Src : TOwnTable) : IRcContainer<PWasmTable>;
    function Unwrap() : PWasmTable;
    function IsNone() : Boolean;
  end;


  TOwnMemory = record  // = TRc<PWasmMemory>
  public
    FStrongRef : IRcContainer<PWasmMemory>;
  public
    class function Wrap(p : PWasmMemory; deleter : TRcDeleter) : TOwnMemory; overload; static; inline;
    class function Wrap(p : PWasmMemory) : TOwnMemory; overload; static;
    class operator Finalize(var Dest: TOwnMemory);
    class operator Implicit(const Src : IRcContainer<PWasmMemory>) : TOwnMemory; overload;
    class operator Positive(Src : TOwnMemory) : PWasmMemory;
    class operator Negative(Src : TOwnMemory) : IRcContainer<PWasmMemory>;
    function Unwrap() : PWasmMemory;
    function IsNone() : Boolean;
  end;


  TOwnExtern = record  // = TRc<PWasmExtern>
  public
    FStrongRef : IRcContainer<PWasmExtern>;
  public
    class function Wrap(p : PWasmExtern; deleter : TRcDeleter) : TOwnExtern; overload; static; inline;
    class function Wrap(p : PWasmExtern) : TOwnExtern; overload; static;
    class operator Finalize(var Dest: TOwnExtern);
    class operator Implicit(const Src : IRcContainer<PWasmExtern>) : TOwnExtern; overload;
    class operator Positive(Src : TOwnExtern) : PWasmExtern;
    class operator Negative(Src : TOwnExtern) : IRcContainer<PWasmExtern>;
    function Unwrap() : PWasmExtern;
    function IsNone() : Boolean;
  end;


  TOwnExternVec = record  // = TRc<PWasmExternVec>
  public
    FStrongRef : IRcContainer<PWasmExternVec>;
  public
    class function Wrap(p : PWasmExternVec; deleter : TRcDeleter) : TOwnExternVec; overload; static; inline;
    class function Wrap(p : PWasmExternVec) : TOwnExternVec; overload; static;
    class operator Finalize(var Dest: TOwnExternVec);
    class operator Implicit(const Src : IRcContainer<PWasmExternVec>) : TOwnExternVec; overload;
    class operator Positive(Src : TOwnExternVec) : PWasmExternVec;
    class operator Negative(Src : TOwnExternVec) : IRcContainer<PWasmExternVec>;
    function Unwrap() : PWasmExternVec;
    function IsNone() : Boolean;
  end;


  TOwnInstance = record  // = TRc<PWasmInstance>
  public
    FStrongRef : IRcContainer<PWasmInstance>;
  public
    class function Wrap(p : PWasmInstance; deleter : TRcDeleter) : TOwnInstance; overload; static; inline;
    class function Wrap(p : PWasmInstance) : TOwnInstance; overload; static;
    class operator Finalize(var Dest: TOwnInstance);
    class operator Implicit(const Src : IRcContainer<PWasmInstance>) : TOwnInstance; overload;
    class operator Positive(Src : TOwnInstance) : PWasmInstance;
    class operator Negative(Src : TOwnInstance) : IRcContainer<PWasmInstance>;
    function Unwrap() : PWasmInstance;
    function IsNone() : Boolean;
  end;

// Byte vectors
  TWasmByteVec = record
  public
    constructor Create(const arry: array of TWasmByte);
    class function NewEmpty() : TOwnByteVec; static;
    class function NewUninitialized(size : NativeInt) : TOwnByteVec; static;
    class function New(const init : array of TWasmByte) : TOwnByteVec; overload;  static;
    function LoadFromFile(fname : string) : Boolean;
    class function NewFromString(s : UTF8String): TOwnName; overload; static;
    class function NewFromStringNt(s : UTF8String): TOwnName; overload; static;
    class function NewFromString(s : String): TOwnName; overload; static;
    class function NewFromStringNt(s : String): TOwnName; overload; static;
    function AsUTF8String : UTF8String;
    function AsString : string;
    function Copy() : TOwnByteVec;
    procedure Assign(const Src : TOwnByteVec);
  public
    case Integer of
    0 :(size : NativeInt; data : PWasmByte);
    1 :(Items : TWasmVec<TWasmByte>);
  end;

  TWasmName = TWasmByteVec;
  PWasmName = ^TWasmByteVec;

  TWasmMessage = TWasmName;
  PWasmMessage = ^TWasmByteVec;

  TWasmFinalizer = procedure(p : Pointer); cdecl;
  TWasmFuncCallBack = function(const args : PWasmValVec; {own} results : PWasmValVec): {own} PWasmTrap; cdecl;
  TWasmFuncCallBackWithEnv = function(env : Pointer; const args : PWasmValVec; {own} results : PWasmValVec): {own} PWasmTrap; cdecl;

///////////////////////////////////////////////////////////////////////////////
// Runtime Environment
// Configuration
  TWasmConfig = record
  public
    class function New() : TOwnConfig; overload; static;
  end;
// Embedders may provide custom functions for manipulating configs.
// Engine
  TWasmEngine = record
  public
    class function New() : TOwnEngine; overload; static;
    class function NewWithConfig(config : TOwnConfig) : TOwnEngine; overload; static;
  end;
// Store
  TWasmStore = record
  public
    class function New(engine : PWasmEngine) : TOwnStore; overload; static;
  end;
  TWasmValtypeVec = record
  public
    constructor Create(const arry: array of PWasmValtype);
    class function NewEmpty() : TOwnValtypeVec; static;
    class function NewUninitialized(size : NativeInt) : TOwnValtypeVec; static;
    class function New(const init : array of PWasmValtype; elem_release : Boolean) : TOwnValtypeVec; overload;  static;
    class function New(const arry: array of TWasmValkind): TOwnValtypeVec; overload; static;
    class function New(const init: array of TOwnValtype): TOwnValtypeVec; overload; static;
    function Copy() : TOwnValtypeVec;
    procedure Assign(const Src : TOwnValtypeVec);
  public
    case Integer of
    0 :(size : NativeInt; data : PPWasmValtype);
    1 :(Items : TWasmVec<PWasmValtype>);
  end;
///////////////////////////////////////////////////////////////////////////////
// Type Representations
// Type attributes
// Generic
// Value Types
  TWasmValtype = record
  public
    function Copy() : TOwnValtype;
    class function New(valkind : TWasmValkind) : TOwnValtype; overload; static;
    function Kind() : TWasmValkind;
  end;
  TWasmFunctypeVec = record
  public
    constructor Create(const arry: array of PWasmFunctype);
    class function NewEmpty() : TOwnFunctypeVec; static;
    class function NewUninitialized(size : NativeInt) : TOwnFunctypeVec; static;
    class function New(const init : array of PWasmFunctype; elem_release : Boolean) : TOwnFunctypeVec; overload;  static;
    function Copy() : TOwnFunctypeVec;
    procedure Assign(const Src : TOwnFunctypeVec);
  public
    case Integer of
    0 :(size : NativeInt; data : PPWasmFunctype);
    1 :(Items : TWasmVec<PWasmFunctype>);
  end;
// Function Types
  TWasmFunctype = record
  public
    function Copy() : TOwnFunctype;
    class function New(const p,  r: array of TWasmValkind): TOwnFunctype; overload; static;
    class function New(const p, r: array of TOwnValtype): TOwnFunctype; overload; static;
    class function New(params : TOwnValtypeVec; results : TOwnValtypeVec) : TOwnFunctype; overload; static;
    function Params() : PWasmValtypeVec;
    function Results() : PWasmValtypeVec;
    function AsExterntype() : PWasmExterntype;
    function AsExterntypeConst() : PWasmExterntype;
  end;
  TWasmGlobaltypeVec = record
  public
    constructor Create(const arry: array of PWasmGlobaltype);
    class function NewEmpty() : TOwnGlobaltypeVec; static;
    class function NewUninitialized(size : NativeInt) : TOwnGlobaltypeVec; static;
    class function New(const init : array of PWasmGlobaltype; elem_release : Boolean) : TOwnGlobaltypeVec; overload;  static;
    function Copy() : TOwnGlobaltypeVec;
    procedure Assign(const Src : TOwnGlobaltypeVec);
  public
    case Integer of
    0 :(size : NativeInt; data : PPWasmGlobaltype);
    1 :(Items : TWasmVec<PWasmGlobaltype>);
  end;
// Global Types
  TWasmGlobaltype = record
  public
    function Copy() : TOwnGlobaltype;
    class function New(valkind : TWasmValKind; mutability : TWasmMutability) : TOwnGlobaltype; overload; static;
    class function New(valtype : TOwnValtype; mutability : TWasmMutability) : TOwnGlobaltype; overload; static;
    function Content() : PWasmValtype;
    function Mutability() : TWasmMutability;
    function AsExterntype() : PWasmExterntype;
    function AsExterntypeConst() : PWasmExterntype;
  end;
  TWasmTabletypeVec = record
  public
    constructor Create(const arry: array of PWasmTabletype);
    class function NewEmpty() : TOwnTabletypeVec; static;
    class function NewUninitialized(size : NativeInt) : TOwnTabletypeVec; static;
    class function New(const init : array of PWasmTabletype; elem_release : Boolean) : TOwnTabletypeVec; overload;  static;
    function Copy() : TOwnTabletypeVec;
    procedure Assign(const Src : TOwnTabletypeVec);
  public
    case Integer of
    0 :(size : NativeInt; data : PPWasmTabletype);
    1 :(Items : TWasmVec<PWasmTabletype>);
  end;
// Table Types
  TWasmTabletype = record
  public
    function Copy() : TOwnTabletype;
    class function New(valtype : TOwnValtype;  const limits : PWasmLimits) : TOwnTabletype; overload; static;
    function Element() : PWasmValtype;
    function Limits() : PWasmLimits;
    function AsExterntype() : PWasmExterntype;
    function AsExterntypeConst() : PWasmExterntype;
  end;
  TWasmMemorytypeVec = record
  public
    constructor Create(const arry: array of PWasmMemorytype);
    class function NewEmpty() : TOwnMemorytypeVec; static;
    class function NewUninitialized(size : NativeInt) : TOwnMemorytypeVec; static;
    class function New(const init : array of PWasmMemorytype; elem_release : Boolean) : TOwnMemorytypeVec; overload;  static;
    function Copy() : TOwnMemorytypeVec;
    procedure Assign(const Src : TOwnMemorytypeVec);
  public
    case Integer of
    0 :(size : NativeInt; data : PPWasmMemorytype);
    1 :(Items : TWasmVec<PWasmMemorytype>);
  end;
// Memory Types
  TWasmMemorytype = record
  public
    function Copy() : TOwnMemorytype;
    class function New( const limits : PWasmLimits) : TOwnMemorytype; overload; static;
    function Limits() : PWasmLimits;
    function AsExterntype() : PWasmExterntype;
    function AsExterntypeConst() : PWasmExterntype;
  end;
  TWasmExterntypeVec = record
  public
    constructor Create(const arry: array of PWasmExterntype);
    class function NewEmpty() : TOwnExterntypeVec; static;
    class function NewUninitialized(size : NativeInt) : TOwnExterntypeVec; static;
    class function New(const init : array of PWasmExterntype; elem_release : Boolean) : TOwnExterntypeVec; overload;  static;
    function Copy() : TOwnExterntypeVec;
    procedure Assign(const Src : TOwnExterntypeVec);
  public
    case Integer of
    0 :(size : NativeInt; data : PPWasmExterntype);
    1 :(Items : TWasmVec<PWasmExterntype>);
  end;
// Extern Types
  TWasmExterntype = record
  public
    function Copy() : TOwnExterntype;
    function Kind() : TWasmExternkind;
    function AsFunctype() : PWasmFunctype;
    function AsGlobaltype() : PWasmGlobaltype;
    function AsTabletype() : PWasmTabletype;
    function AsMemorytype() : PWasmMemorytype;
    function AsFunctypeConst() : PWasmFunctype;
    function AsGlobaltypeConst() : PWasmGlobaltype;
    function AsTabletypeConst() : PWasmTabletype;
    function AsMemorytypeConst() : PWasmMemorytype;
  end;
  TWasmImporttypeVec = record
  public
    constructor Create(const arry: array of PWasmImporttype);
    class function NewEmpty() : TOwnImporttypeVec; static;
    class function NewUninitialized(size : NativeInt) : TOwnImporttypeVec; static;
    class function New(const init : array of PWasmImporttype; elem_release : Boolean) : TOwnImporttypeVec; overload;  static;
    function Copy() : TOwnImporttypeVec;
    procedure Assign(const Src : TOwnImporttypeVec);
  public
    case Integer of
    0 :(size : NativeInt; data : PPWasmImporttype);
    1 :(Items : TWasmVec<PWasmImporttype>);
  end;
// Import Types
  TWasmImporttype = record
  public
    function Copy() : TOwnImporttype;
    class function New(module : string; name : string; externtype : TOwnExterntype) : TOwnImporttype; overload; static;
    function Module() : string;
    function Name() : string;
    function GetType() : PWasmExterntype;
  end;
  TWasmExporttypeVec = record
  public
    constructor Create(const arry: array of PWasmExporttype);
    class function NewEmpty() : TOwnExporttypeVec; static;
    class function NewUninitialized(size : NativeInt) : TOwnExporttypeVec; static;
    class function New(const init : array of PWasmExporttype; elem_release : Boolean) : TOwnExporttypeVec; overload;  static;
    function Copy() : TOwnExporttypeVec;
    procedure Assign(const Src : TOwnExporttypeVec);
  public
    case Integer of
    0 :(size : NativeInt; data : PPWasmExporttype);
    1 :(Items : TWasmVec<PWasmExporttype>);
  end;
// Export Types
  TWasmExporttype = record
  public
    function Copy() : TOwnExporttype;
    class function New(name : string; externtype : TOwnExterntype) : TOwnExporttype; overload; static;
    function Name() : string;
    function GetType() : PWasmExterntype;
  end;
  TWasmVal = record
  public
    constructor Create(val:Integer); overload;
    constructor Create(val:Int64); overload;
    constructor Create(val:Single); overload;
    constructor Create(val:Double); overload;
    constructor Create(val:PWasmRef); overload;
    class operator Implicit(val:Integer) : TWasmVal; overload;
    class operator Implicit(val:Int64) : TWasmVal; overload;
    class operator Implicit(val:Single) : TWasmVal; overload;
    class operator Implicit(val:Double) : TWasmVal; overload;
    class operator Implicit(val:PWasmRef) : TWasmVal; overload;
  public
    kind : TWasmValkind;
    case Integer of
    0 : (i32 : Integer);
    1 : (i64 : Int64);
    2 : (f32 : Single);
    3 : (f64 : Double);
    4 : (ref : PWasmRef);
  end;
///////////////////////////////////////////////////////////////////////////////
// Runtime Objects
// Values
  TWasmValVec = record
  public
    constructor Create(const arry: array of TWasmVal);
    class function NewEmpty() : TOwnValVec; static;
    class function NewUninitialized(size : NativeInt) : TOwnValVec; static;
    class function New(const init : array of TWasmVal) : TOwnValVec; overload;  static;
    function Copy() : TOwnValVec;
    procedure Assign(const Src : TOwnValVec);
  public
    case Integer of
    0 :(size : NativeInt; data : PWasmVal);
    1 :(Items : TWasmVec<TWasmVal>);
  end;
// References
  TWasmRef = record
  public
    function Copy() : TOwnRef;
    function Same(const p : PWasmRef) : Boolean;
    function GetHostInfo : Pointer;
    procedure SetHostInfo(info : Pointer);
    procedure SetHostInfoWithFinalizer(info : Pointer ;finalizer : TWasmFinalizer);
    function AsTrapConst() : PWasmTrap;
    function AsTrap() : PWasmTrap;
    function AsForeignConst() : PWasmForeign;
    function AsForeign() : PWasmForeign;
    function AsModuleConst() : PWasmModule;
    function AsModule() : PWasmModule;
    function AsFuncConst() : PWasmFunc;
    function AsFunc() : PWasmFunc;
    function AsGlobalConst() : PWasmGlobal;
    function AsGlobal() : PWasmGlobal;
    function AsTableConst() : PWasmTable;
    function AsTable() : PWasmTable;
    function AsMemoryConst() : PWasmMemory;
    function AsMemory() : PWasmMemory;
    function AsExternConst() : PWasmExtern;
    function AsExtern() : PWasmExtern;
    function AsInstanceConst() : PWasmInstance;
    function AsInstance() : PWasmInstance;
  end;
// Frames
  TWasmFrame = record
  public
    function Copy() : TOwnFrame;
    function Instance() : PWasmInstance;
    function FuncIndex() : Cardinal;
    function FuncOffset() : NativeInt;
    function ModuleOffset() : NativeInt;
  end;
  TWasmFrameVec = record
  public
    constructor Create(const arry: array of PWasmFrame);
    class function NewEmpty() : TOwnFrameVec; static;
    class function NewUninitialized(size : NativeInt) : TOwnFrameVec; static;
    class function New(const init : array of PWasmFrame; elem_release : Boolean) : TOwnFrameVec; overload;  static;
    function Copy() : TOwnFrameVec;
    procedure Assign(const Src : TOwnFrameVec);
  public
    case Integer of
    0 :(size : NativeInt; data : PPWasmFrame);
    1 :(Items : TWasmVec<PWasmFrame>);
  end;
// Traps
// null terminated
  TWasmTrap = record
  public
    function Copy() : TOwnTrap;
    function Same(const p : PWasmTrap) : Boolean;
    function GetHostInfo : Pointer;
    procedure SetHostInfo(info : Pointer);
    procedure SetHostInfoWithFinalizer(info : Pointer ;finalizer : TWasmFinalizer);
    function AsRef : PWasmRef;
    function AsRefConst : PWasmRef;
    class function New(store : PWasmStore;  const message : PWasmMessage) : TOwnTrap; overload; static;
    function GetMessage() : string;
    function Origin() : TOwnFrame;
    function Trace() : TOwnFrameVec;
  end;
// Foreign Objects
  TWasmForeign = record
  public
    function Copy() : TOwnForeign;
    function Same(const p : PWasmForeign) : Boolean;
    function GetHostInfo : Pointer;
    procedure SetHostInfo(info : Pointer);
    procedure SetHostInfoWithFinalizer(info : Pointer ;finalizer : TWasmFinalizer);
    function AsRef : PWasmRef;
    function AsRefConst : PWasmRef;
    class function New(store : PWasmStore) : TOwnForeign; overload; static;
  end;
  TWasmModule = record
  public
    function Copy() : TOwnModule;
    function Same(const p : PWasmModule) : Boolean;
    function GetHostInfo : Pointer;
    procedure SetHostInfo(info : Pointer);
    procedure SetHostInfoWithFinalizer(info : Pointer ;finalizer : TWasmFinalizer);
    function Share() : TOwnSharedModule;
    function AsRef : PWasmRef;
    function AsRefConst : PWasmRef;
    class function New(store : PWasmStore;  const binary : PWasmByteVec) : TOwnModule; overload; static;
    function Validate(store : PWasmStore;  const binary : PWasmByteVec) : Boolean;
    function Imports() : TOwnImporttypeVec;
    function GetExports() : TOwnExporttypeVec;
    function Serialize() : TOwnByteVec;
    class function Deserialize(store : PWasmStore;  const byte_vec : PWasmByteVec) : TOwnModule; overload; static;
  end;
// Modules
  TWasmSharedModule = record
  public
    function Obtain(store : PWasmStore) : TOwnModule;
  end;
// Function Instances
  TWasmFunc = record
  public
    function Copy() : TOwnFunc;
    function Same(const p : PWasmFunc) : Boolean;
    function GetHostInfo : Pointer;
    procedure SetHostInfo(info : Pointer);
    procedure SetHostInfoWithFinalizer(info : Pointer ;finalizer : TWasmFinalizer);
    function AsRef : PWasmRef;
    function AsRefConst : PWasmRef;
    class function New(store : PWasmStore;  const functype : PWasmFunctype; func_callback : TWasmFuncCallback) : TOwnFunc; overload; static;
    class function NewWithEnv(store : PWasmStore;  const typ : PWasmFunctype; func_callback_with_env : TWasmFuncCallbackWithEnv; env : Pointer; finalizer : TWasmFinalizer) : TOwnFunc; overload; static;
    function GetType() : TOwnFunctype;
    function ParamArity() : NativeInt;
    function ResultArity() : NativeInt;
    function Call( const args : PWasmValVec; results : PWasmValVec) : TOwnTrap;
    function AsExtern() : PWasmExtern;
    function AsExternConst() : PWasmExtern;
  end;
// Global Instances
  TWasmGlobal = record
  public
    function Copy() : TOwnGlobal;
    function Same(const p : PWasmGlobal) : Boolean;
    function GetHostInfo : Pointer;
    procedure SetHostInfo(info : Pointer);
    procedure SetHostInfoWithFinalizer(info : Pointer ;finalizer : TWasmFinalizer);
    function AsRef : PWasmRef;
    function AsRefConst : PWasmRef;
    class function New(store : PWasmStore;  const globaltype : PWasmGlobaltype;  const val : PWasmVal) : TOwnGlobal; overload; static;
    function GetType() : TOwnGlobaltype;
    function GetVal() : TOwnVal;
    procedure SetVal( const val : PWasmVal);
    function AsExtern() : PWasmExtern;
    function AsExternConst() : PWasmExtern;
  end;
// Table Instances
  TWasmTable = record
  public
    function Copy() : TOwnTable;
    function Same(const p : PWasmTable) : Boolean;
    function GetHostInfo : Pointer;
    procedure SetHostInfo(info : Pointer);
    procedure SetHostInfoWithFinalizer(info : Pointer ;finalizer : TWasmFinalizer);
    function AsRef : PWasmRef;
    function AsRefConst : PWasmRef;
    class function New(store : PWasmStore;  const tabletype : PWasmTabletype; init : PWasmRef) : TOwnTable; overload; static;
    function GetType() : TOwnTabletype;
    function GetRef(index : TWasmTableSize) : TOwnRef;
    function SetRef(index : TWasmTableSize; ref : PWasmRef) : Boolean;
    function Size() : TWasmTableSize;
    function Grow(delta : TWasmTableSize; init : PWasmRef) : Boolean;
    function AsExtern() : PWasmExtern;
    function AsExternConst() : PWasmExtern;
  end;
// Memory Instances
  TWasmMemory = record
  public
    function Copy() : TOwnMemory;
    function Same(const p : PWasmMemory) : Boolean;
    function GetHostInfo : Pointer;
    procedure SetHostInfo(info : Pointer);
    procedure SetHostInfoWithFinalizer(info : Pointer ;finalizer : TWasmFinalizer);
    function AsRef : PWasmRef;
    function AsRefConst : PWasmRef;
    class function New(store : PWasmStore;  const memorytype : PWasmMemorytype) : TOwnMemory; overload; static;
    function GetType() : TOwnMemorytype;
    function Data() : PByte;
    function DataSize() : NativeInt;
    function Size() : TWasmMemoryPages;
    function Grow(delta : TWasmMemoryPages) : Boolean;
    function AsExtern() : PWasmExtern;
    function AsExternConst() : PWasmExtern;
  end;
// Externals
  TWasmExtern = record
  public
    function Copy() : TOwnExtern;
    function Same(const p : PWasmExtern) : Boolean;
    function GetHostInfo : Pointer;
    procedure SetHostInfo(info : Pointer);
    procedure SetHostInfoWithFinalizer(info : Pointer ;finalizer : TWasmFinalizer);
    function AsRef : PWasmRef;
    function AsRefConst : PWasmRef;
    function Kind() : TWasmExternkind;
    function GetType() : TOwnExterntype;
    function AsFunc() : PWasmFunc;
    function AsGlobal() : PWasmGlobal;
    function AsTable() : PWasmTable;
    function AsMemory() : PWasmMemory;
    function AsFuncConst() : PWasmFunc;
    function AsGlobalConst() : PWasmGlobal;
    function AsTableConst() : PWasmTable;
    function AsMemoryConst() : PWasmMemory;
  end;
  TWasmExternVec = record
  public
    constructor Create(const arry: array of PWasmExtern);
    class function NewEmpty() : TOwnExternVec; static;
    class function NewUninitialized(size : NativeInt) : TOwnExternVec; static;
    class function New(const init : array of PWasmExtern; elem_release : Boolean) : TOwnExternVec; overload;  static;
    function Copy() : TOwnExternVec;
    procedure Assign(const Src : TOwnExternVec);
  public
    case Integer of
    0 :(size : NativeInt; data : PPWasmExtern);
    1 :(Items : TWasmVec<PWasmExtern>);
  end;
// Module Instances
  TWasmInstance = record
  public
    class function New(store : PWasmStore; const module : PWasmModule; const imports : array of PWasmExtern) : TOwnInstance; overload; static;
    class function New(store : PWasmStore; const module : PWasmModule; const imports : array of PWasmExtern; var trap : TOwnTrap) : TOwnInstance; overload; static;
    class function New(store : PWasmStore;  const module : PWasmModule;  const imports : PWasmExternVec) : TOwnInstance; overload; static;
    function Copy() : TOwnInstance;
    function Same(const p : PWasmInstance) : Boolean;
    function GetHostInfo : Pointer;
    procedure SetHostInfo(info : Pointer);
    procedure SetHostInfoWithFinalizer(info : Pointer ;finalizer : TWasmFinalizer);
    function AsRef : PWasmRef;
    function AsRefConst : PWasmRef;
    class function New(store : PWasmStore;  const module : PWasmModule;  const imports : PWasmExternVec; var {own} trap : TOwnTrap) : TOwnInstance; overload; static;
    function GetExports() : TOwnExternVec;
  end;
  TWasmByteVecNewEmptyAPI = procedure({own} out_ : PWasmByteVec); cdecl;
  TWasmByteVecNewUninitializedAPI = procedure({own} out_ : PWasmByteVec; size : NativeInt); cdecl;
  TWasmByteVecNewAPI = procedure({own} out_ : PWasmByteVec; size : NativeInt; {own} const init : PWasmByte); cdecl;
  TWasmByteVecCopyAPI = procedure({own} out_ : PWasmByteVec; src : PWasmByteVec); cdecl;
  TWasmByteVecDeleteAPI = procedure(p : PWasmByteVec); cdecl;
  TWasmConfigDeleteAPI = procedure(p : PWasmConfig); cdecl;
  TWasmConfigNewAPI = function () : {own} PWasmConfig; cdecl;
  TWasmEngineDeleteAPI = procedure(p : PWasmEngine); cdecl;
  TWasmEngineNewAPI = function () : {own} PWasmEngine; cdecl;
  TWasmEngineNewWithConfigAPI = function ({own} config : PWasmConfig) : {own} PWasmEngine; cdecl;
  TWasmStoreDeleteAPI = procedure(p : PWasmStore); cdecl;
  TWasmStoreNewAPI = function (engine : PWasmEngine) : {own} PWasmStore; cdecl;
  TWasmValtypeDeleteAPI = procedure(p : PWasmValtype); cdecl;
  TWasmValtypeCopyAPI = function(const {own} self : PWasmValtype) : PWasmValtype; cdecl;
  TWasmValtypeVecNewEmptyAPI = procedure({own} out_ : PWasmValtypeVec); cdecl;
  TWasmValtypeVecNewUninitializedAPI = procedure({own} out_ : PWasmValtypeVec; size : NativeInt); cdecl;
  TWasmValtypeVecNewAPI = procedure({own} out_ : PWasmValtypeVec; size : NativeInt; {own} const init : PPWasmValtype); cdecl;
  TWasmValtypeVecCopyAPI = procedure({own} out_ : PWasmValtypeVec; src : PWasmValtypeVec); cdecl;
  TWasmValtypeVecDeleteAPI = procedure(p : PWasmValtypeVec); cdecl;
  TWasmValtypeNewAPI = function (valkind : TWasmValkind) : {own} PWasmValtype; cdecl;
  TWasmValtypeKindAPI = function (const valtype : PWasmValtype) : TWasmValkind; cdecl;
  TWasmFunctypeDeleteAPI = procedure(p : PWasmFunctype); cdecl;
  TWasmFunctypeCopyAPI = function(const {own} self : PWasmFunctype) : PWasmFunctype; cdecl;
  TWasmFunctypeVecNewEmptyAPI = procedure({own} out_ : PWasmFunctypeVec); cdecl;
  TWasmFunctypeVecNewUninitializedAPI = procedure({own} out_ : PWasmFunctypeVec; size : NativeInt); cdecl;
  TWasmFunctypeVecNewAPI = procedure({own} out_ : PWasmFunctypeVec; size : NativeInt; {own} const init : PPWasmFunctype); cdecl;
  TWasmFunctypeVecCopyAPI = procedure({own} out_ : PWasmFunctypeVec; src : PWasmFunctypeVec); cdecl;
  TWasmFunctypeVecDeleteAPI = procedure(p : PWasmFunctypeVec); cdecl;
  TWasmFunctypeNewAPI = function ({own} params : PWasmValtypeVec; {own} results : PWasmValtypeVec) : {own} PWasmFunctype; cdecl;
  TWasmFunctypeParamsAPI = function (const functype : PWasmFunctype) : PWasmValtypeVec; cdecl;
  TWasmFunctypeResultsAPI = function (const functype : PWasmFunctype) : PWasmValtypeVec; cdecl;
  TWasmGlobaltypeDeleteAPI = procedure(p : PWasmGlobaltype); cdecl;
  TWasmGlobaltypeCopyAPI = function(const {own} self : PWasmGlobaltype) : PWasmGlobaltype; cdecl;
  TWasmGlobaltypeVecNewEmptyAPI = procedure({own} out_ : PWasmGlobaltypeVec); cdecl;
  TWasmGlobaltypeVecNewUninitializedAPI = procedure({own} out_ : PWasmGlobaltypeVec; size : NativeInt); cdecl;
  TWasmGlobaltypeVecNewAPI = procedure({own} out_ : PWasmGlobaltypeVec; size : NativeInt; {own} const init : PPWasmGlobaltype); cdecl;
  TWasmGlobaltypeVecCopyAPI = procedure({own} out_ : PWasmGlobaltypeVec; src : PWasmGlobaltypeVec); cdecl;
  TWasmGlobaltypeVecDeleteAPI = procedure(p : PWasmGlobaltypeVec); cdecl;
  TWasmGlobaltypeNewAPI = function ({own} valtype : PWasmValtype; mutability : TWasmMutability) : {own} PWasmGlobaltype; cdecl;
  TWasmGlobaltypeContentAPI = function (const globaltype : PWasmGlobaltype) : PWasmValtype; cdecl;
  TWasmGlobaltypeMutabilityAPI = function (const globaltype : PWasmGlobaltype) : TWasmMutability; cdecl;
  TWasmTabletypeDeleteAPI = procedure(p : PWasmTabletype); cdecl;
  TWasmTabletypeCopyAPI = function(const {own} self : PWasmTabletype) : PWasmTabletype; cdecl;
  TWasmTabletypeVecNewEmptyAPI = procedure({own} out_ : PWasmTabletypeVec); cdecl;
  TWasmTabletypeVecNewUninitializedAPI = procedure({own} out_ : PWasmTabletypeVec; size : NativeInt); cdecl;
  TWasmTabletypeVecNewAPI = procedure({own} out_ : PWasmTabletypeVec; size : NativeInt; {own} const init : PPWasmTabletype); cdecl;
  TWasmTabletypeVecCopyAPI = procedure({own} out_ : PWasmTabletypeVec; src : PWasmTabletypeVec); cdecl;
  TWasmTabletypeVecDeleteAPI = procedure(p : PWasmTabletypeVec); cdecl;
  TWasmTabletypeNewAPI = function ({own} valtype : PWasmValtype; const limits : PWasmLimits) : {own} PWasmTabletype; cdecl;
  TWasmTabletypeElementAPI = function (const tabletype : PWasmTabletype) : PWasmValtype; cdecl;
  TWasmTabletypeLimitsAPI = function (const tabletype : PWasmTabletype) : PWasmLimits; cdecl;
  TWasmMemorytypeDeleteAPI = procedure(p : PWasmMemorytype); cdecl;
  TWasmMemorytypeCopyAPI = function(const {own} self : PWasmMemorytype) : PWasmMemorytype; cdecl;
  TWasmMemorytypeVecNewEmptyAPI = procedure({own} out_ : PWasmMemorytypeVec); cdecl;
  TWasmMemorytypeVecNewUninitializedAPI = procedure({own} out_ : PWasmMemorytypeVec; size : NativeInt); cdecl;
  TWasmMemorytypeVecNewAPI = procedure({own} out_ : PWasmMemorytypeVec; size : NativeInt; {own} const init : PPWasmMemorytype); cdecl;
  TWasmMemorytypeVecCopyAPI = procedure({own} out_ : PWasmMemorytypeVec; src : PWasmMemorytypeVec); cdecl;
  TWasmMemorytypeVecDeleteAPI = procedure(p : PWasmMemorytypeVec); cdecl;
  TWasmMemorytypeNewAPI = function (const limits : PWasmLimits) : {own} PWasmMemorytype; cdecl;
  TWasmMemorytypeLimitsAPI = function (const memorytype : PWasmMemorytype) : PWasmLimits; cdecl;
  TWasmExterntypeDeleteAPI = procedure(p : PWasmExterntype); cdecl;
  TWasmExterntypeCopyAPI = function(const {own} self : PWasmExterntype) : PWasmExterntype; cdecl;
  TWasmExterntypeVecNewEmptyAPI = procedure({own} out_ : PWasmExterntypeVec); cdecl;
  TWasmExterntypeVecNewUninitializedAPI = procedure({own} out_ : PWasmExterntypeVec; size : NativeInt); cdecl;
  TWasmExterntypeVecNewAPI = procedure({own} out_ : PWasmExterntypeVec; size : NativeInt; {own} const init : PPWasmExterntype); cdecl;
  TWasmExterntypeVecCopyAPI = procedure({own} out_ : PWasmExterntypeVec; src : PWasmExterntypeVec); cdecl;
  TWasmExterntypeVecDeleteAPI = procedure(p : PWasmExterntypeVec); cdecl;
  TWasmExterntypeKindAPI = function (const externtype : PWasmExterntype) : TWasmExternkind; cdecl;
  TWasmFunctypeAsExterntypeAPI = function (functype : PWasmFunctype) : PWasmExterntype; cdecl;
  TWasmGlobaltypeAsExterntypeAPI = function (globaltype : PWasmGlobaltype) : PWasmExterntype; cdecl;
  TWasmTabletypeAsExterntypeAPI = function (tabletype : PWasmTabletype) : PWasmExterntype; cdecl;
  TWasmMemorytypeAsExterntypeAPI = function (memorytype : PWasmMemorytype) : PWasmExterntype; cdecl;
  TWasmExterntypeAsFunctypeAPI = function (externtype : PWasmExterntype) : PWasmFunctype; cdecl;
  TWasmExterntypeAsGlobaltypeAPI = function (externtype : PWasmExterntype) : PWasmGlobaltype; cdecl;
  TWasmExterntypeAsTabletypeAPI = function (externtype : PWasmExterntype) : PWasmTabletype; cdecl;
  TWasmExterntypeAsMemorytypeAPI = function (externtype : PWasmExterntype) : PWasmMemorytype; cdecl;
  TWasmFunctypeAsExterntypeConstAPI = function (const functype : PWasmFunctype) : PWasmExterntype; cdecl;
  TWasmGlobaltypeAsExterntypeConstAPI = function (const globaltype : PWasmGlobaltype) : PWasmExterntype; cdecl;
  TWasmTabletypeAsExterntypeConstAPI = function (const tabletype : PWasmTabletype) : PWasmExterntype; cdecl;
  TWasmMemorytypeAsExterntypeConstAPI = function (const memorytype : PWasmMemorytype) : PWasmExterntype; cdecl;
  TWasmExterntypeAsFunctypeConstAPI = function (const externtype : PWasmExterntype) : PWasmFunctype; cdecl;
  TWasmExterntypeAsGlobaltypeConstAPI = function (const externtype : PWasmExterntype) : PWasmGlobaltype; cdecl;
  TWasmExterntypeAsTabletypeConstAPI = function (const externtype : PWasmExterntype) : PWasmTabletype; cdecl;
  TWasmExterntypeAsMemorytypeConstAPI = function (const externtype : PWasmExterntype) : PWasmMemorytype; cdecl;
  TWasmImporttypeDeleteAPI = procedure(p : PWasmImporttype); cdecl;
  TWasmImporttypeCopyAPI = function(const {own} self : PWasmImporttype) : PWasmImporttype; cdecl;
  TWasmImporttypeVecNewEmptyAPI = procedure({own} out_ : PWasmImporttypeVec); cdecl;
  TWasmImporttypeVecNewUninitializedAPI = procedure({own} out_ : PWasmImporttypeVec; size : NativeInt); cdecl;
  TWasmImporttypeVecNewAPI = procedure({own} out_ : PWasmImporttypeVec; size : NativeInt; {own} const init : PPWasmImporttype); cdecl;
  TWasmImporttypeVecCopyAPI = procedure({own} out_ : PWasmImporttypeVec; src : PWasmImporttypeVec); cdecl;
  TWasmImporttypeVecDeleteAPI = procedure(p : PWasmImporttypeVec); cdecl;
  TWasmImporttypeNewAPI = function ({own} module : PWasmName; {own} name : PWasmName; {own} externtype : PWasmExterntype) : {own} PWasmImporttype; cdecl;
  TWasmImporttypeModuleAPI = function (const importtype : PWasmImporttype) : PWasmName; cdecl;
  TWasmImporttypeNameAPI = function (const importtype : PWasmImporttype) : PWasmName; cdecl;
  TWasmImporttypeTypeAPI = function (const importtype : PWasmImporttype) : PWasmExterntype; cdecl;
  TWasmExporttypeDeleteAPI = procedure(p : PWasmExporttype); cdecl;
  TWasmExporttypeCopyAPI = function(const {own} self : PWasmExporttype) : PWasmExporttype; cdecl;
  TWasmExporttypeVecNewEmptyAPI = procedure({own} out_ : PWasmExporttypeVec); cdecl;
  TWasmExporttypeVecNewUninitializedAPI = procedure({own} out_ : PWasmExporttypeVec; size : NativeInt); cdecl;
  TWasmExporttypeVecNewAPI = procedure({own} out_ : PWasmExporttypeVec; size : NativeInt; {own} const init : PPWasmExporttype); cdecl;
  TWasmExporttypeVecCopyAPI = procedure({own} out_ : PWasmExporttypeVec; src : PWasmExporttypeVec); cdecl;
  TWasmExporttypeVecDeleteAPI = procedure(p : PWasmExporttypeVec); cdecl;
  TWasmExporttypeNewAPI = function ({own} name : PWasmName; {own} externtype : PWasmExterntype) : {own} PWasmExporttype; cdecl;
  TWasmExporttypeNameAPI = function (const exporttype : PWasmExporttype) : PWasmName; cdecl;
  TWasmExporttypeTypeAPI = function (const exporttype : PWasmExporttype) : PWasmExterntype; cdecl;
  TWasmValDeleteAPI = procedure ({own} v : PWasmVal); cdecl;
  TWasmValCopyAPI = procedure ({own} out_ : PWasmVal; const val1 : PWasmVal); cdecl;
  TWasmValVecNewEmptyAPI = procedure({own} out_ : PWasmValVec); cdecl;
  TWasmValVecNewUninitializedAPI = procedure({own} out_ : PWasmValVec; size : NativeInt); cdecl;
  TWasmValVecNewAPI = procedure({own} out_ : PWasmValVec; size : NativeInt; {own} const init : PWasmVal); cdecl;
  TWasmValVecCopyAPI = procedure({own} out_ : PWasmValVec; src : PWasmValVec); cdecl;
  TWasmValVecDeleteAPI = procedure(p : PWasmValVec); cdecl;
  TWasmRefDeleteAPI = procedure(p : PWasmRef); cdecl;
  TWasmRefCopyAPI = function(const {own} self : PWasmRef) : PWasmRef; cdecl;
  TWasmRefSameAPI = function(const {own} self : PWasmRef; target : PWasmRef) : Boolean; cdecl;
  TWasmRefGetHostInfoAPI = function(const {own} self : PWasmRef) : Pointer; cdecl;
  TWasmRefSetHostInfoAPI = procedure(const {own} self : PWasmRef; info : Pointer); cdecl;
  TWasmRefSetHostInfoWithFinalizerAPI = procedure(const {own} self : PWasmRef; info : Pointer; finalizer : TWasmFinalizer); cdecl;
  TWasmFrameDeleteAPI = procedure(p : PWasmFrame); cdecl;
  TWasmFrameVecNewEmptyAPI = procedure({own} out_ : PWasmFrameVec); cdecl;
  TWasmFrameVecNewUninitializedAPI = procedure({own} out_ : PWasmFrameVec; size : NativeInt); cdecl;
  TWasmFrameVecNewAPI = procedure({own} out_ : PWasmFrameVec; size : NativeInt; {own} const init : PPWasmFrame); cdecl;
  TWasmFrameVecCopyAPI = procedure({own} out_ : PWasmFrameVec; src : PWasmFrameVec); cdecl;
  TWasmFrameVecDeleteAPI = procedure(p : PWasmFrameVec); cdecl;
  TWasmFrameCopyAPI = function (const frame : PWasmFrame) : {own} PWasmFrame; cdecl;
  TWasmFrameInstanceAPI = function (const frame : PWasmFrame) : PWasmInstance; cdecl;
  TWasmFrameFuncIndexAPI = function (const frame : PWasmFrame) : Cardinal; cdecl;
  TWasmFrameFuncOffsetAPI = function (const frame : PWasmFrame) : NativeInt; cdecl;
  TWasmFrameModuleOffsetAPI = function (const frame : PWasmFrame) : NativeInt; cdecl;
  TWasmTrapDeleteAPI = procedure(p : PWasmTrap); cdecl;
  TWasmTrapCopyAPI = function(const {own} self : PWasmTrap) : PWasmTrap; cdecl;
  TWasmTrapSameAPI = function(const {own} self : PWasmTrap; target : PWasmTrap) : Boolean; cdecl;
  TWasmTrapGetHostInfoAPI = function(const {own} self : PWasmTrap) : Pointer; cdecl;
  TWasmTrapSetHostInfoAPI = procedure(const {own} self : PWasmTrap; info : Pointer); cdecl;
  TWasmTrapSetHostInfoWithFinalizerAPI = procedure(const {own} self : PWasmTrap; info : Pointer; finalizer : TWasmFinalizer); cdecl;
  TWasmTrapAsRefAPI = function({own} self : PWasmTrap) : PWasmRef; cdecl;
  TWasmTrapAsRefConstAPI = function(const {own} self : PWasmTrap) : PWasmRef; cdecl;
  TWasmRefAsTrapAPI= function({own} self : PWasmRef) : PWasmTrap; cdecl;
  TWasmRefAsTrapConstAPI = function(const {own} self : PWasmRef) : PWasmTrap; cdecl;
  TWasmTrapNewAPI = function (store : PWasmStore; const message : PWasmMessage) : {own} PWasmTrap; cdecl;
  TWasmTrapMessageAPI = procedure (const trap : PWasmTrap; {own} out_ : PWasmMessage); cdecl;
  TWasmTrapOriginAPI = function (const trap : PWasmTrap) : {own} PWasmFrame; cdecl;
  TWasmTrapTraceAPI = procedure (const trap : PWasmTrap; {own} out_ : PWasmFrameVec); cdecl;
  TWasmForeignDeleteAPI = procedure(p : PWasmForeign); cdecl;
  TWasmForeignCopyAPI = function(const {own} self : PWasmForeign) : PWasmForeign; cdecl;
  TWasmForeignSameAPI = function(const {own} self : PWasmForeign; target : PWasmForeign) : Boolean; cdecl;
  TWasmForeignGetHostInfoAPI = function(const {own} self : PWasmForeign) : Pointer; cdecl;
  TWasmForeignSetHostInfoAPI = procedure(const {own} self : PWasmForeign; info : Pointer); cdecl;
  TWasmForeignSetHostInfoWithFinalizerAPI = procedure(const {own} self : PWasmForeign; info : Pointer; finalizer : TWasmFinalizer); cdecl;
  TWasmForeignAsRefAPI = function({own} self : PWasmForeign) : PWasmRef; cdecl;
  TWasmForeignAsRefConstAPI = function(const {own} self : PWasmForeign) : PWasmRef; cdecl;
  TWasmRefAsForeignAPI= function({own} self : PWasmRef) : PWasmForeign; cdecl;
  TWasmRefAsForeignConstAPI = function(const {own} self : PWasmRef) : PWasmForeign; cdecl;
  TWasmForeignNewAPI = function (store : PWasmStore) : {own} PWasmForeign; cdecl;
  TWasmModuleDeleteAPI = procedure(p : PWasmModule); cdecl;
  TWasmModuleCopyAPI = function(const {own} self : PWasmModule) : PWasmModule; cdecl;
  TWasmModuleSameAPI = function(const {own} self : PWasmModule; target : PWasmModule) : Boolean; cdecl;
  TWasmModuleGetHostInfoAPI = function(const {own} self : PWasmModule) : Pointer; cdecl;
  TWasmModuleSetHostInfoAPI = procedure(const {own} self : PWasmModule; info : Pointer); cdecl;
  TWasmModuleSetHostInfoWithFinalizerAPI = procedure(const {own} self : PWasmModule; info : Pointer; finalizer : TWasmFinalizer); cdecl;
  TWasmModuleAsRefAPI = function({own} self : PWasmModule) : PWasmRef; cdecl;
  TWasmModuleAsRefConstAPI = function(const {own} self : PWasmModule) : PWasmRef; cdecl;
  TWasmRefAsModuleAPI= function({own} self : PWasmRef) : PWasmModule; cdecl;
  TWasmRefAsModuleConstAPI = function(const {own} self : PWasmRef) : PWasmModule; cdecl;
  TWasmSharedModuleDeleteAPI = procedure(p : PWasmSharedModule); cdecl;
  TWasmSharedModuleCopyAPI = function(const {own} self : PWasmSharedModule) : PWasmSharedModule; cdecl;
  TWasmSharedModuleSameAPI = function(const {own} self : PWasmSharedModule; target : PWasmSharedModule) : Boolean; cdecl;
  TWasmSharedModuleGetHostInfoAPI = function(const {own} self : PWasmSharedModule) : Pointer; cdecl;
  TWasmSharedModuleSetHostInfoAPI = procedure(const {own} self : PWasmSharedModule; info : Pointer); cdecl;
  TWasmSharedModuleSetHostInfoWithFinalizerAPI = procedure(const {own} self : PWasmSharedModule; info : Pointer; finalizer : TWasmFinalizer); cdecl;
  TWasmSharedModuleAsRefAPI = function({own} self : PWasmSharedModule) : PWasmRef; cdecl;
  TWasmSharedModuleAsRefConstAPI = function(const {own} self : PWasmSharedModule) : PWasmRef; cdecl;
  TWasmRefAsSharedModuleAPI= function({own} self : PWasmRef) : PWasmSharedModule; cdecl;
  TWasmRefAsSharedModuleConstAPI = function(const {own} self : PWasmRef) : PWasmSharedModule; cdecl;
  TWasmModuleShareAPI = function(const {own} self : PWasmModule) : {own} PWasmSharedModule; cdecl;
  TWasmModuleObtainAPI = function(store : PWasmStore; const {own} self : PWasmSharedModule) : {own} PWasmModule; cdecl;
  TWasmModuleNewAPI = function (store : PWasmStore; const binary : PWasmByteVec) : {own} PWasmModule; cdecl;
  TWasmModuleValidateAPI = function (store : PWasmStore; const binary : PWasmByteVec) : Boolean; cdecl;
  TWasmModuleImportsAPI = procedure (const module : PWasmModule; {own} out_ : PWasmImporttypeVec); cdecl;
  TWasmModuleExportsAPI = procedure (const module : PWasmModule; {own} out_ : PWasmExporttypeVec); cdecl;
  TWasmModuleSerializeAPI = procedure (const module : PWasmModule; {own} out_ : PWasmByteVec); cdecl;
  TWasmModuleDeserializeAPI = function (store : PWasmStore; const byte_vec : PWasmByteVec) : {own} PWasmModule; cdecl;
  TWasmFuncDeleteAPI = procedure(p : PWasmFunc); cdecl;
  TWasmFuncCopyAPI = function(const {own} self : PWasmFunc) : PWasmFunc; cdecl;
  TWasmFuncSameAPI = function(const {own} self : PWasmFunc; target : PWasmFunc) : Boolean; cdecl;
  TWasmFuncGetHostInfoAPI = function(const {own} self : PWasmFunc) : Pointer; cdecl;
  TWasmFuncSetHostInfoAPI = procedure(const {own} self : PWasmFunc; info : Pointer); cdecl;
  TWasmFuncSetHostInfoWithFinalizerAPI = procedure(const {own} self : PWasmFunc; info : Pointer; finalizer : TWasmFinalizer); cdecl;
  TWasmFuncAsRefAPI = function({own} self : PWasmFunc) : PWasmRef; cdecl;
  TWasmFuncAsRefConstAPI = function(const {own} self : PWasmFunc) : PWasmRef; cdecl;
  TWasmRefAsFuncAPI= function({own} self : PWasmRef) : PWasmFunc; cdecl;
  TWasmRefAsFuncConstAPI = function(const {own} self : PWasmRef) : PWasmFunc; cdecl;
  TWasmFuncNewAPI = function (store : PWasmStore; const functype : PWasmFunctype; func_callback : TWasmFuncCallback) : {own} PWasmFunc; cdecl;
  TWasmFuncNewWithEnvAPI = function (store : PWasmStore; const typ : PWasmFunctype; func_callback_with_env : TWasmFuncCallbackWithEnv; env : Pointer; finalizer : TWasmFinalizer) : {own} PWasmFunc; cdecl;
  TWasmFuncTypeAPI = function (const func : PWasmFunc) : {own} PWasmFunctype; cdecl;
  TWasmFuncParamArityAPI = function (const func : PWasmFunc) : NativeInt; cdecl;
  TWasmFuncResultArityAPI = function (const func : PWasmFunc) : NativeInt; cdecl;
  TWasmFuncCallAPI = function (const func : PWasmFunc; const args : PWasmValVec; results : PWasmValVec) : {own} PWasmTrap; cdecl;
  TWasmGlobalDeleteAPI = procedure(p : PWasmGlobal); cdecl;
  TWasmGlobalCopyAPI = function(const {own} self : PWasmGlobal) : PWasmGlobal; cdecl;
  TWasmGlobalSameAPI = function(const {own} self : PWasmGlobal; target : PWasmGlobal) : Boolean; cdecl;
  TWasmGlobalGetHostInfoAPI = function(const {own} self : PWasmGlobal) : Pointer; cdecl;
  TWasmGlobalSetHostInfoAPI = procedure(const {own} self : PWasmGlobal; info : Pointer); cdecl;
  TWasmGlobalSetHostInfoWithFinalizerAPI = procedure(const {own} self : PWasmGlobal; info : Pointer; finalizer : TWasmFinalizer); cdecl;
  TWasmGlobalAsRefAPI = function({own} self : PWasmGlobal) : PWasmRef; cdecl;
  TWasmGlobalAsRefConstAPI = function(const {own} self : PWasmGlobal) : PWasmRef; cdecl;
  TWasmRefAsGlobalAPI= function({own} self : PWasmRef) : PWasmGlobal; cdecl;
  TWasmRefAsGlobalConstAPI = function(const {own} self : PWasmRef) : PWasmGlobal; cdecl;
  TWasmGlobalNewAPI = function (store : PWasmStore; const globaltype : PWasmGlobaltype; const val : PWasmVal) : {own} PWasmGlobal; cdecl;
  TWasmGlobalTypeAPI = function (const global : PWasmGlobal) : {own} PWasmGlobaltype; cdecl;
  TWasmGlobalGetAPI = procedure (const global : PWasmGlobal; {own} out_ : PWasmVal); cdecl;
  TWasmGlobalSetAPI = procedure (global : PWasmGlobal; const val : PWasmVal); cdecl;
  TWasmTableDeleteAPI = procedure(p : PWasmTable); cdecl;
  TWasmTableCopyAPI = function(const {own} self : PWasmTable) : PWasmTable; cdecl;
  TWasmTableSameAPI = function(const {own} self : PWasmTable; target : PWasmTable) : Boolean; cdecl;
  TWasmTableGetHostInfoAPI = function(const {own} self : PWasmTable) : Pointer; cdecl;
  TWasmTableSetHostInfoAPI = procedure(const {own} self : PWasmTable; info : Pointer); cdecl;
  TWasmTableSetHostInfoWithFinalizerAPI = procedure(const {own} self : PWasmTable; info : Pointer; finalizer : TWasmFinalizer); cdecl;
  TWasmTableAsRefAPI = function({own} self : PWasmTable) : PWasmRef; cdecl;
  TWasmTableAsRefConstAPI = function(const {own} self : PWasmTable) : PWasmRef; cdecl;
  TWasmRefAsTableAPI= function({own} self : PWasmRef) : PWasmTable; cdecl;
  TWasmRefAsTableConstAPI = function(const {own} self : PWasmRef) : PWasmTable; cdecl;
  TWasmTableNewAPI = function (store : PWasmStore; const tabletype : PWasmTabletype; init : PWasmRef) : {own} PWasmTable; cdecl;
  TWasmTableTypeAPI = function (const table : PWasmTable) : {own} PWasmTabletype; cdecl;
  TWasmTableGetAPI = function (const table : PWasmTable; index : TWasmTableSize) : {own} PWasmRef; cdecl;
  TWasmTableSetAPI = function (table : PWasmTable; index : TWasmTableSize; ref : PWasmRef) : Boolean; cdecl;
  TWasmTableSizeAPI = function (const table : PWasmTable) : TWasmTableSize; cdecl;
  TWasmTableGrowAPI = function (table : PWasmTable; delta : TWasmTableSize; init : PWasmRef) : Boolean; cdecl;
  TWasmMemoryDeleteAPI = procedure(p : PWasmMemory); cdecl;
  TWasmMemoryCopyAPI = function(const {own} self : PWasmMemory) : PWasmMemory; cdecl;
  TWasmMemorySameAPI = function(const {own} self : PWasmMemory; target : PWasmMemory) : Boolean; cdecl;
  TWasmMemoryGetHostInfoAPI = function(const {own} self : PWasmMemory) : Pointer; cdecl;
  TWasmMemorySetHostInfoAPI = procedure(const {own} self : PWasmMemory; info : Pointer); cdecl;
  TWasmMemorySetHostInfoWithFinalizerAPI = procedure(const {own} self : PWasmMemory; info : Pointer; finalizer : TWasmFinalizer); cdecl;
  TWasmMemoryAsRefAPI = function({own} self : PWasmMemory) : PWasmRef; cdecl;
  TWasmMemoryAsRefConstAPI = function(const {own} self : PWasmMemory) : PWasmRef; cdecl;
  TWasmRefAsMemoryAPI= function({own} self : PWasmRef) : PWasmMemory; cdecl;
  TWasmRefAsMemoryConstAPI = function(const {own} self : PWasmRef) : PWasmMemory; cdecl;
  TWasmMemoryNewAPI = function (store : PWasmStore; const memorytype : PWasmMemorytype) : {own} PWasmMemory; cdecl;
  TWasmMemoryTypeAPI = function (const memory : PWasmMemory) : {own} PWasmMemorytype; cdecl;
  TWasmMemoryDataAPI = function (memory : PWasmMemory) : PByte; cdecl;
  TWasmMemoryDataSizeAPI = function (const memory : PWasmMemory) : NativeInt; cdecl;
  TWasmMemorySizeAPI = function (const memory : PWasmMemory) : TWasmMemoryPages; cdecl;
  TWasmMemoryGrowAPI = function (memory : PWasmMemory; delta : TWasmMemoryPages) : Boolean; cdecl;
  TWasmExternDeleteAPI = procedure(p : PWasmExtern); cdecl;
  TWasmExternCopyAPI = function(const {own} self : PWasmExtern) : PWasmExtern; cdecl;
  TWasmExternSameAPI = function(const {own} self : PWasmExtern; target : PWasmExtern) : Boolean; cdecl;
  TWasmExternGetHostInfoAPI = function(const {own} self : PWasmExtern) : Pointer; cdecl;
  TWasmExternSetHostInfoAPI = procedure(const {own} self : PWasmExtern; info : Pointer); cdecl;
  TWasmExternSetHostInfoWithFinalizerAPI = procedure(const {own} self : PWasmExtern; info : Pointer; finalizer : TWasmFinalizer); cdecl;
  TWasmExternAsRefAPI = function({own} self : PWasmExtern) : PWasmRef; cdecl;
  TWasmExternAsRefConstAPI = function(const {own} self : PWasmExtern) : PWasmRef; cdecl;
  TWasmRefAsExternAPI= function({own} self : PWasmRef) : PWasmExtern; cdecl;
  TWasmRefAsExternConstAPI = function(const {own} self : PWasmRef) : PWasmExtern; cdecl;
  TWasmExternVecNewEmptyAPI = procedure({own} out_ : PWasmExternVec); cdecl;
  TWasmExternVecNewUninitializedAPI = procedure({own} out_ : PWasmExternVec; size : NativeInt); cdecl;
  TWasmExternVecNewAPI = procedure({own} out_ : PWasmExternVec; size : NativeInt; {own} const init : PPWasmExtern); cdecl;
  TWasmExternVecCopyAPI = procedure({own} out_ : PWasmExternVec; src : PWasmExternVec); cdecl;
  TWasmExternVecDeleteAPI = procedure(p : PWasmExternVec); cdecl;
  TWasmExternKindAPI = function (const extern : PWasmExtern) : TWasmExternkind; cdecl;
  TWasmExternTypeAPI = function (const extern : PWasmExtern) : {own} PWasmExterntype; cdecl;
  TWasmFuncAsExternAPI = function (func : PWasmFunc) : PWasmExtern; cdecl;
  TWasmGlobalAsExternAPI = function (global : PWasmGlobal) : PWasmExtern; cdecl;
  TWasmTableAsExternAPI = function (table : PWasmTable) : PWasmExtern; cdecl;
  TWasmMemoryAsExternAPI = function (memory : PWasmMemory) : PWasmExtern; cdecl;
  TWasmExternAsFuncAPI = function (extern : PWasmExtern) : PWasmFunc; cdecl;
  TWasmExternAsGlobalAPI = function (extern : PWasmExtern) : PWasmGlobal; cdecl;
  TWasmExternAsTableAPI = function (extern : PWasmExtern) : PWasmTable; cdecl;
  TWasmExternAsMemoryAPI = function (extern : PWasmExtern) : PWasmMemory; cdecl;
  TWasmFuncAsExternConstAPI = function (const func : PWasmFunc) : PWasmExtern; cdecl;
  TWasmGlobalAsExternConstAPI = function (const global : PWasmGlobal) : PWasmExtern; cdecl;
  TWasmTableAsExternConstAPI = function (const table : PWasmTable) : PWasmExtern; cdecl;
  TWasmMemoryAsExternConstAPI = function (const memory : PWasmMemory) : PWasmExtern; cdecl;
  TWasmExternAsFuncConstAPI = function (const extern : PWasmExtern) : PWasmFunc; cdecl;
  TWasmExternAsGlobalConstAPI = function (const extern : PWasmExtern) : PWasmGlobal; cdecl;
  TWasmExternAsTableConstAPI = function (const extern : PWasmExtern) : PWasmTable; cdecl;
  TWasmExternAsMemoryConstAPI = function (const extern : PWasmExtern) : PWasmMemory; cdecl;
  TWasmInstanceDeleteAPI = procedure(p : PWasmInstance); cdecl;
  TWasmInstanceCopyAPI = function(const {own} self : PWasmInstance) : PWasmInstance; cdecl;
  TWasmInstanceSameAPI = function(const {own} self : PWasmInstance; target : PWasmInstance) : Boolean; cdecl;
  TWasmInstanceGetHostInfoAPI = function(const {own} self : PWasmInstance) : Pointer; cdecl;
  TWasmInstanceSetHostInfoAPI = procedure(const {own} self : PWasmInstance; info : Pointer); cdecl;
  TWasmInstanceSetHostInfoWithFinalizerAPI = procedure(const {own} self : PWasmInstance; info : Pointer; finalizer : TWasmFinalizer); cdecl;
  TWasmInstanceAsRefAPI = function({own} self : PWasmInstance) : PWasmRef; cdecl;
  TWasmInstanceAsRefConstAPI = function(const {own} self : PWasmInstance) : PWasmRef; cdecl;
  TWasmRefAsInstanceAPI= function({own} self : PWasmRef) : PWasmInstance; cdecl;
  TWasmRefAsInstanceConstAPI = function(const {own} self : PWasmRef) : PWasmInstance; cdecl;
  TWasmInstanceNewAPI = function (store : PWasmStore; const module : PWasmModule; const imports : PWasmExternVec; {own} trap : PPWasmTrap) : {own} PWasmInstance; cdecl;
  TWasmInstanceExportsAPI = procedure (const instance : PWasmInstance; {own} out_ : PWasmExternVec); cdecl;

  TWasm = record
  public class var
    byte_vec_new_empty : TWasmByteVecNewEmptyAPI;
    byte_vec_new_uninitialized : TWasmByteVecNewUninitializedAPI;
    byte_vec_new : TWasmByteVecNewAPI;
    byte_vec_copy : TWasmByteVecCopyAPI;
    byte_vec_delete : TWasmByteVecDeleteAPI;
    config_delete : TWasmConfigDeleteAPI;
    config_new : TWasmConfigNewAPI;
    engine_delete : TWasmEngineDeleteAPI;
    engine_new : TWasmEngineNewAPI;
    engine_new_with_config : TWasmEngineNewWithConfigAPI;
    store_delete : TWasmStoreDeleteAPI;
    store_new : TWasmStoreNewAPI;
    valtype_delete : TWasmValtypeDeleteAPI;
    valtype_copy : TWasmValtypeCopyAPI;
    valtype_vec_new_empty : TWasmValtypeVecNewEmptyAPI;
    valtype_vec_new_uninitialized : TWasmValtypeVecNewUninitializedAPI;
    valtype_vec_new : TWasmValtypeVecNewAPI;
    valtype_vec_copy : TWasmValtypeVecCopyAPI;
    valtype_vec_delete : TWasmValtypeVecDeleteAPI;
    valtype_new : TWasmValtypeNewAPI;
    valtype_kind : TWasmValtypeKindAPI;
    functype_delete : TWasmFunctypeDeleteAPI;
    functype_copy : TWasmFunctypeCopyAPI;
    functype_vec_new_empty : TWasmFunctypeVecNewEmptyAPI;
    functype_vec_new_uninitialized : TWasmFunctypeVecNewUninitializedAPI;
    functype_vec_new : TWasmFunctypeVecNewAPI;
    functype_vec_copy : TWasmFunctypeVecCopyAPI;
    functype_vec_delete : TWasmFunctypeVecDeleteAPI;
    functype_new : TWasmFunctypeNewAPI;
    functype_params : TWasmFunctypeParamsAPI;
    functype_results : TWasmFunctypeResultsAPI;
    globaltype_delete : TWasmGlobaltypeDeleteAPI;
    globaltype_copy : TWasmGlobaltypeCopyAPI;
    globaltype_vec_new_empty : TWasmGlobaltypeVecNewEmptyAPI;
    globaltype_vec_new_uninitialized : TWasmGlobaltypeVecNewUninitializedAPI;
    globaltype_vec_new : TWasmGlobaltypeVecNewAPI;
    globaltype_vec_copy : TWasmGlobaltypeVecCopyAPI;
    globaltype_vec_delete : TWasmGlobaltypeVecDeleteAPI;
    globaltype_new : TWasmGlobaltypeNewAPI;
    globaltype_content : TWasmGlobaltypeContentAPI;
    globaltype_mutability : TWasmGlobaltypeMutabilityAPI;
    tabletype_delete : TWasmTabletypeDeleteAPI;
    tabletype_copy : TWasmTabletypeCopyAPI;
    tabletype_vec_new_empty : TWasmTabletypeVecNewEmptyAPI;
    tabletype_vec_new_uninitialized : TWasmTabletypeVecNewUninitializedAPI;
    tabletype_vec_new : TWasmTabletypeVecNewAPI;
    tabletype_vec_copy : TWasmTabletypeVecCopyAPI;
    tabletype_vec_delete : TWasmTabletypeVecDeleteAPI;
    tabletype_new : TWasmTabletypeNewAPI;
    tabletype_element : TWasmTabletypeElementAPI;
    tabletype_limits : TWasmTabletypeLimitsAPI;
    memorytype_delete : TWasmMemorytypeDeleteAPI;
    memorytype_copy : TWasmMemorytypeCopyAPI;
    memorytype_vec_new_empty : TWasmMemorytypeVecNewEmptyAPI;
    memorytype_vec_new_uninitialized : TWasmMemorytypeVecNewUninitializedAPI;
    memorytype_vec_new : TWasmMemorytypeVecNewAPI;
    memorytype_vec_copy : TWasmMemorytypeVecCopyAPI;
    memorytype_vec_delete : TWasmMemorytypeVecDeleteAPI;
    memorytype_new : TWasmMemorytypeNewAPI;
    memorytype_limits : TWasmMemorytypeLimitsAPI;
    externtype_delete : TWasmExterntypeDeleteAPI;
    externtype_copy : TWasmExterntypeCopyAPI;
    externtype_vec_new_empty : TWasmExterntypeVecNewEmptyAPI;
    externtype_vec_new_uninitialized : TWasmExterntypeVecNewUninitializedAPI;
    externtype_vec_new : TWasmExterntypeVecNewAPI;
    externtype_vec_copy : TWasmExterntypeVecCopyAPI;
    externtype_vec_delete : TWasmExterntypeVecDeleteAPI;
    externtype_kind : TWasmExterntypeKindAPI;
    functype_as_externtype : TWasmFunctypeAsExterntypeAPI;
    globaltype_as_externtype : TWasmGlobaltypeAsExterntypeAPI;
    tabletype_as_externtype : TWasmTabletypeAsExterntypeAPI;
    memorytype_as_externtype : TWasmMemorytypeAsExterntypeAPI;
    externtype_as_functype : TWasmExterntypeAsFunctypeAPI;
    externtype_as_globaltype : TWasmExterntypeAsGlobaltypeAPI;
    externtype_as_tabletype : TWasmExterntypeAsTabletypeAPI;
    externtype_as_memorytype : TWasmExterntypeAsMemorytypeAPI;
    functype_as_externtype_const : TWasmFunctypeAsExterntypeConstAPI;
    globaltype_as_externtype_const : TWasmGlobaltypeAsExterntypeConstAPI;
    tabletype_as_externtype_const : TWasmTabletypeAsExterntypeConstAPI;
    memorytype_as_externtype_const : TWasmMemorytypeAsExterntypeConstAPI;
    externtype_as_functype_const : TWasmExterntypeAsFunctypeConstAPI;
    externtype_as_globaltype_const : TWasmExterntypeAsGlobaltypeConstAPI;
    externtype_as_tabletype_const : TWasmExterntypeAsTabletypeConstAPI;
    externtype_as_memorytype_const : TWasmExterntypeAsMemorytypeConstAPI;
    importtype_delete : TWasmImporttypeDeleteAPI;
    importtype_copy : TWasmImporttypeCopyAPI;
    importtype_vec_new_empty : TWasmImporttypeVecNewEmptyAPI;
    importtype_vec_new_uninitialized : TWasmImporttypeVecNewUninitializedAPI;
    importtype_vec_new : TWasmImporttypeVecNewAPI;
    importtype_vec_copy : TWasmImporttypeVecCopyAPI;
    importtype_vec_delete : TWasmImporttypeVecDeleteAPI;
    importtype_new : TWasmImporttypeNewAPI;
    importtype_module : TWasmImporttypeModuleAPI;
    importtype_name : TWasmImporttypeNameAPI;
    importtype_type : TWasmImporttypeTypeAPI;
    exporttype_delete : TWasmExporttypeDeleteAPI;
    exporttype_copy : TWasmExporttypeCopyAPI;
    exporttype_vec_new_empty : TWasmExporttypeVecNewEmptyAPI;
    exporttype_vec_new_uninitialized : TWasmExporttypeVecNewUninitializedAPI;
    exporttype_vec_new : TWasmExporttypeVecNewAPI;
    exporttype_vec_copy : TWasmExporttypeVecCopyAPI;
    exporttype_vec_delete : TWasmExporttypeVecDeleteAPI;
    exporttype_new : TWasmExporttypeNewAPI;
    exporttype_name : TWasmExporttypeNameAPI;
    exporttype_type : TWasmExporttypeTypeAPI;
    val_delete : TWasmValDeleteAPI;
    val_copy : TWasmValCopyAPI;
    val_vec_new_empty : TWasmValVecNewEmptyAPI;
    val_vec_new_uninitialized : TWasmValVecNewUninitializedAPI;
    val_vec_new : TWasmValVecNewAPI;
    val_vec_copy : TWasmValVecCopyAPI;
    val_vec_delete : TWasmValVecDeleteAPI;
    ref_delete : TWasmRefDeleteAPI;
    ref_copy : TWasmRefCopyAPI;
    ref_same : TWasmRefSameAPI;
    ref_get_host_info : TWasmRefGetHostInfoAPI;
    ref_set_host_info : TWasmRefSetHostInfoAPI;
    ref_set_host_info_with_finalizer : TWasmRefSetHostInfoWithFinalizerAPI;
    frame_delete : TWasmFrameDeleteAPI;
    frame_vec_new_empty : TWasmFrameVecNewEmptyAPI;
    frame_vec_new_uninitialized : TWasmFrameVecNewUninitializedAPI;
    frame_vec_new : TWasmFrameVecNewAPI;
    frame_vec_copy : TWasmFrameVecCopyAPI;
    frame_vec_delete : TWasmFrameVecDeleteAPI;
    frame_copy : TWasmFrameCopyAPI;
    frame_instance : TWasmFrameInstanceAPI;
    frame_func_index : TWasmFrameFuncIndexAPI;
    frame_func_offset : TWasmFrameFuncOffsetAPI;
    frame_module_offset : TWasmFrameModuleOffsetAPI;
    trap_delete : TWasmTrapDeleteAPI;
    trap_copy : TWasmTrapCopyAPI;
    trap_same : TWasmTrapSameAPI;
    trap_get_host_info : TWasmTrapGetHostInfoAPI;
    trap_set_host_info : TWasmTrapSetHostInfoAPI;
    trap_set_host_info_with_finalizer : TWasmTrapSetHostInfoWithFinalizerAPI;
    trap_as_ref : TWasmTrapAsRefAPI;
    trap_as_ref_const : TWasmTrapAsRefAPI;
    ref_as_trap : TWasmRefAsTrapAPI;
    ref_as_trap_const : TWasmRefAsTrapConstAPI;
    trap_new : TWasmTrapNewAPI;
    trap_message : TWasmTrapMessageAPI;
    trap_origin : TWasmTrapOriginAPI;
    trap_trace : TWasmTrapTraceAPI;
    foreign_delete : TWasmForeignDeleteAPI;
    foreign_copy : TWasmForeignCopyAPI;
    foreign_same : TWasmForeignSameAPI;
    foreign_get_host_info : TWasmForeignGetHostInfoAPI;
    foreign_set_host_info : TWasmForeignSetHostInfoAPI;
    foreign_set_host_info_with_finalizer : TWasmForeignSetHostInfoWithFinalizerAPI;
    foreign_as_ref : TWasmForeignAsRefAPI;
    foreign_as_ref_const : TWasmForeignAsRefAPI;
    ref_as_foreign : TWasmRefAsForeignAPI;
    ref_as_foreign_const : TWasmRefAsForeignConstAPI;
    foreign_new : TWasmForeignNewAPI;
    module_delete : TWasmModuleDeleteAPI;
    module_copy : TWasmModuleCopyAPI;
    module_same : TWasmModuleSameAPI;
    module_get_host_info : TWasmModuleGetHostInfoAPI;
    module_set_host_info : TWasmModuleSetHostInfoAPI;
    module_set_host_info_with_finalizer : TWasmModuleSetHostInfoWithFinalizerAPI;
    module_as_ref : TWasmModuleAsRefAPI;
    module_as_ref_const : TWasmModuleAsRefAPI;
    ref_as_module : TWasmRefAsModuleAPI;
    ref_as_module_const : TWasmRefAsModuleConstAPI;
    shared_module_delete : TWasmSharedModuleDeleteAPI;
    shared_module_copy : TWasmSharedModuleCopyAPI;
    shared_module_same : TWasmSharedModuleSameAPI;
    shared_module_get_host_info : TWasmSharedModuleGetHostInfoAPI;
    shared_module_set_host_info : TWasmSharedModuleSetHostInfoAPI;
    shared_module_set_host_info_with_finalizer : TWasmSharedModuleSetHostInfoWithFinalizerAPI;
    shared_module_as_ref : TWasmSharedModuleAsRefAPI;
    shared_module_as_ref_const : TWasmSharedModuleAsRefAPI;
    ref_as_shared_module : TWasmRefAsSharedModuleAPI;
    ref_as_shared_module_const : TWasmRefAsSharedModuleConstAPI;
    module_share : TWasmModuleShareAPI;
    module_obtain : TWasmModuleObtainAPI;
    module_new : TWasmModuleNewAPI;
    module_validate : TWasmModuleValidateAPI;
    module_imports : TWasmModuleImportsAPI;
    module_exports : TWasmModuleExportsAPI;
    module_serialize : TWasmModuleSerializeAPI;
    module_deserialize : TWasmModuleDeserializeAPI;
    func_delete : TWasmFuncDeleteAPI;
    func_copy : TWasmFuncCopyAPI;
    func_same : TWasmFuncSameAPI;
    func_get_host_info : TWasmFuncGetHostInfoAPI;
    func_set_host_info : TWasmFuncSetHostInfoAPI;
    func_set_host_info_with_finalizer : TWasmFuncSetHostInfoWithFinalizerAPI;
    func_as_ref : TWasmFuncAsRefAPI;
    func_as_ref_const : TWasmFuncAsRefAPI;
    ref_as_func : TWasmRefAsFuncAPI;
    ref_as_func_const : TWasmRefAsFuncConstAPI;
    func_new : TWasmFuncNewAPI;
    func_new_with_env : TWasmFuncNewWithEnvAPI;
    func_type : TWasmFuncTypeAPI;
    func_param_arity : TWasmFuncParamArityAPI;
    func_result_arity : TWasmFuncResultArityAPI;
    func_call : TWasmFuncCallAPI;
    global_delete : TWasmGlobalDeleteAPI;
    global_copy : TWasmGlobalCopyAPI;
    global_same : TWasmGlobalSameAPI;
    global_get_host_info : TWasmGlobalGetHostInfoAPI;
    global_set_host_info : TWasmGlobalSetHostInfoAPI;
    global_set_host_info_with_finalizer : TWasmGlobalSetHostInfoWithFinalizerAPI;
    global_as_ref : TWasmGlobalAsRefAPI;
    global_as_ref_const : TWasmGlobalAsRefAPI;
    ref_as_global : TWasmRefAsGlobalAPI;
    ref_as_global_const : TWasmRefAsGlobalConstAPI;
    global_new : TWasmGlobalNewAPI;
    global_type : TWasmGlobalTypeAPI;
    global_get : TWasmGlobalGetAPI;
    global_set : TWasmGlobalSetAPI;
    table_delete : TWasmTableDeleteAPI;
    table_copy : TWasmTableCopyAPI;
    table_same : TWasmTableSameAPI;
    table_get_host_info : TWasmTableGetHostInfoAPI;
    table_set_host_info : TWasmTableSetHostInfoAPI;
    table_set_host_info_with_finalizer : TWasmTableSetHostInfoWithFinalizerAPI;
    table_as_ref : TWasmTableAsRefAPI;
    table_as_ref_const : TWasmTableAsRefAPI;
    ref_as_table : TWasmRefAsTableAPI;
    ref_as_table_const : TWasmRefAsTableConstAPI;
    table_new : TWasmTableNewAPI;
    table_type : TWasmTableTypeAPI;
    table_get : TWasmTableGetAPI;
    table_set : TWasmTableSetAPI;
    table_size : TWasmTableSizeAPI;
    table_grow : TWasmTableGrowAPI;
    memory_delete : TWasmMemoryDeleteAPI;
    memory_copy : TWasmMemoryCopyAPI;
    memory_same : TWasmMemorySameAPI;
    memory_get_host_info : TWasmMemoryGetHostInfoAPI;
    memory_set_host_info : TWasmMemorySetHostInfoAPI;
    memory_set_host_info_with_finalizer : TWasmMemorySetHostInfoWithFinalizerAPI;
    memory_as_ref : TWasmMemoryAsRefAPI;
    memory_as_ref_const : TWasmMemoryAsRefAPI;
    ref_as_memory : TWasmRefAsMemoryAPI;
    ref_as_memory_const : TWasmRefAsMemoryConstAPI;
    memory_new : TWasmMemoryNewAPI;
    memory_type : TWasmMemoryTypeAPI;
    memory_data : TWasmMemoryDataAPI;
    memory_data_size : TWasmMemoryDataSizeAPI;
    memory_size : TWasmMemorySizeAPI;
    memory_grow : TWasmMemoryGrowAPI;
    extern_delete : TWasmExternDeleteAPI;
    extern_copy : TWasmExternCopyAPI;
    extern_same : TWasmExternSameAPI;
    extern_get_host_info : TWasmExternGetHostInfoAPI;
    extern_set_host_info : TWasmExternSetHostInfoAPI;
    extern_set_host_info_with_finalizer : TWasmExternSetHostInfoWithFinalizerAPI;
    extern_as_ref : TWasmExternAsRefAPI;
    extern_as_ref_const : TWasmExternAsRefAPI;
    ref_as_extern : TWasmRefAsExternAPI;
    ref_as_extern_const : TWasmRefAsExternConstAPI;
    extern_vec_new_empty : TWasmExternVecNewEmptyAPI;
    extern_vec_new_uninitialized : TWasmExternVecNewUninitializedAPI;
    extern_vec_new : TWasmExternVecNewAPI;
    extern_vec_copy : TWasmExternVecCopyAPI;
    extern_vec_delete : TWasmExternVecDeleteAPI;
    extern_kind : TWasmExternKindAPI;
    extern_type : TWasmExternTypeAPI;
    func_as_extern : TWasmFuncAsExternAPI;
    global_as_extern : TWasmGlobalAsExternAPI;
    table_as_extern : TWasmTableAsExternAPI;
    memory_as_extern : TWasmMemoryAsExternAPI;
    extern_as_func : TWasmExternAsFuncAPI;
    extern_as_global : TWasmExternAsGlobalAPI;
    extern_as_table : TWasmExternAsTableAPI;
    extern_as_memory : TWasmExternAsMemoryAPI;
    func_as_extern_const : TWasmFuncAsExternConstAPI;
    global_as_extern_const : TWasmGlobalAsExternConstAPI;
    table_as_extern_const : TWasmTableAsExternConstAPI;
    memory_as_extern_const : TWasmMemoryAsExternConstAPI;
    extern_as_func_const : TWasmExternAsFuncConstAPI;
    extern_as_global_const : TWasmExternAsGlobalConstAPI;
    extern_as_table_const : TWasmExternAsTableConstAPI;
    extern_as_memory_const : TWasmExternAsMemoryConstAPI;
    instance_delete : TWasmInstanceDeleteAPI;
    instance_copy : TWasmInstanceCopyAPI;
    instance_same : TWasmInstanceSameAPI;
    instance_get_host_info : TWasmInstanceGetHostInfoAPI;
    instance_set_host_info : TWasmInstanceSetHostInfoAPI;
    instance_set_host_info_with_finalizer : TWasmInstanceSetHostInfoWithFinalizerAPI;
    instance_as_ref : TWasmInstanceAsRefAPI;
    instance_as_ref_const : TWasmInstanceAsRefAPI;
    ref_as_instance : TWasmRefAsInstanceAPI;
    ref_as_instance_const : TWasmRefAsInstanceConstAPI;
    instance_new : TWasmInstanceNewAPI;
    instance_exports : TWasmInstanceExportsAPI;

    class procedure name_new_from_string({own} out_ : PWasmName; const s : UTF8String); inline; static;
    class procedure name_new_from_string_nt({own} out_ : PWasmName; const s : UTF8String); inline; static;
    class function valkind_is_num(k : TWasmValkind) : Boolean; inline; static;
    class function valkind_is_ref(k : TWasmValkind) : Boolean; inline; static;
    class function valtype_is_num(const t : PWasmValType) : Boolean; inline; static;
    class function valtype_is_ref(const t : PWasmValType) : Boolean; inline; static;
    class function valtype_new_i32() : PWasmValType; inline; static;
    class function valtype_new_i64() : PWasmValType; inline; static;
    class function valtype_new_f32() : PWasmValType; inline; static;
    class function valtype_new_f64() : PWasmValType; inline; static;
    class function valtype_new_anyref() : PWasmValType; inline; static;
    class function valtype_new_funcref() : PWasmValType; inline; static;
    class function functype_new_0_0() : PWasmFunctype; inline; static;
    class function functype_new_1_0(p : PWasmValType) : PWasmFunctype; inline; static;
    class function functype_new_2_0({own}p1,p2 : PWasmValType) : PWasmFunctype; inline; static;
    class function functype_new_3_0({own}p1,p2,p3 : PWasmValType) : PWasmFunctype; inline; static;
    class function functype_new_0_1({own} r : PWasmValType) : PWasmFunctype; inline; static;
    class function functype_new_1_1({own} p, r : PWasmValType) : PWasmFunctype; inline; static;
    class function functype_new_2_1({own} p1,p2, r : PWasmValType) : PWasmFunctype; inline; static;
    class function functype_new_3_1({own} p1,p2,p3, r : PWasmValType) : PWasmFunctype; inline; static;
    class function functype_new_0_2({own} r1,r2 : PWasmValType) : PWasmFunctype; inline; static;
    class function functype_new_1_2({own} p, r1,r2 : PWasmValType) : PWasmFunctype; inline; static;
    class function functype_new_2_2({own} p1,p2, r1,r2 : PWasmValType) : PWasmFunctype; inline; static;
    class function functype_new_3_2({own} p1,p2,p3, r1,r2 : PWasmValType) : PWasmFunctype; inline; static;
    class function functype_new_array(const p : array of PWasmValType; const r : array of PWasmValType) : PWasmFunctype; static;
  public
    class procedure Init(dll_name : string); static;
    class procedure InitAPIs(runtime : HMODULE); static;
  end;

function WASM_I32_VAL(val : Integer) : TWasmVal; inline;
function WASM_I64_VAL(val : Int64) : TWasmVal; inline;
function WASM_F32_VAL(val : Single) : TWasmVal; inline;
function WASM_F64_VAL(val : Double) : TWasmVal; inline;
function WASM_REF_VAL(val : PWasmRef) : TWasmVal; inline;
function WASM_INIT_VAL() : TWasmVal; inline;
implementation
uses
  Windows, System.Classes;
const
  wasm_limits_max_default = $ffffffff;
  MEMORY_PAGE_SIZE = $10000;

{ TWasm }

var
  wasm_runtime : HMODULE;

class procedure TWasm.Init(dll_name: string);
begin
  wasm_runtime := LoadLibrary(PWideChar(dll_name));
  InitAPIs(wasm_runtime);
end;

class procedure TWasm.InitAPIs(runtime : HMODULE);
  function ProcAddress(name : string) : Pointer;
  begin
    result := GetProcAddress(runtime, PWideChar(name));
  end;

begin

  if runtime <> 0 then
  begin
    byte_vec_new_empty := ProcAddress('wasm_byte_vec_new_empty');
    byte_vec_new_uninitialized := ProcAddress('wasm_byte_vec_new_uninitialized');
    byte_vec_new := ProcAddress('wasm_byte_vec_new');
    byte_vec_copy := ProcAddress('wasm_byte_vec_copy');
    byte_vec_delete := ProcAddress('wasm_byte_vec_delete');
    config_delete := ProcAddress('wasm_config_delete');
    config_new := ProcAddress('wasm_config_new');
    engine_delete := ProcAddress('wasm_engine_delete');
    engine_new := ProcAddress('wasm_engine_new');
    engine_new_with_config := ProcAddress('wasm_engine_new_with_config');
    store_delete := ProcAddress('wasm_store_delete');
    store_new := ProcAddress('wasm_store_new');
    valtype_delete := ProcAddress('wasm_valtype_delete');
    valtype_copy := ProcAddress('wasm_valtype_copy');
    valtype_vec_new_empty := ProcAddress('wasm_valtype_vec_new_empty');
    valtype_vec_new_uninitialized := ProcAddress('wasm_valtype_vec_new_uninitialized');
    valtype_vec_new := ProcAddress('wasm_valtype_vec_new');
    valtype_vec_copy := ProcAddress('wasm_valtype_vec_copy');
    valtype_vec_delete := ProcAddress('wasm_valtype_vec_delete');
    valtype_new := ProcAddress('wasm_valtype_new');
    valtype_kind := ProcAddress('wasm_valtype_kind');
    functype_delete := ProcAddress('wasm_functype_delete');
    functype_copy := ProcAddress('wasm_functype_copy');
    functype_vec_new_empty := ProcAddress('wasm_functype_vec_new_empty');
    functype_vec_new_uninitialized := ProcAddress('wasm_functype_vec_new_uninitialized');
    functype_vec_new := ProcAddress('wasm_functype_vec_new');
    functype_vec_copy := ProcAddress('wasm_functype_vec_copy');
    functype_vec_delete := ProcAddress('wasm_functype_vec_delete');
    functype_new := ProcAddress('wasm_functype_new');
    functype_params := ProcAddress('wasm_functype_params');
    functype_results := ProcAddress('wasm_functype_results');
    globaltype_delete := ProcAddress('wasm_globaltype_delete');
    globaltype_copy := ProcAddress('wasm_globaltype_copy');
    globaltype_vec_new_empty := ProcAddress('wasm_globaltype_vec_new_empty');
    globaltype_vec_new_uninitialized := ProcAddress('wasm_globaltype_vec_new_uninitialized');
    globaltype_vec_new := ProcAddress('wasm_globaltype_vec_new');
    globaltype_vec_copy := ProcAddress('wasm_globaltype_vec_copy');
    globaltype_vec_delete := ProcAddress('wasm_globaltype_vec_delete');
    globaltype_new := ProcAddress('wasm_globaltype_new');
    globaltype_content := ProcAddress('wasm_globaltype_content');
    globaltype_mutability := ProcAddress('wasm_globaltype_mutability');
    tabletype_delete := ProcAddress('wasm_tabletype_delete');
    tabletype_copy := ProcAddress('wasm_tabletype_copy');
    tabletype_vec_new_empty := ProcAddress('wasm_tabletype_vec_new_empty');
    tabletype_vec_new_uninitialized := ProcAddress('wasm_tabletype_vec_new_uninitialized');
    tabletype_vec_new := ProcAddress('wasm_tabletype_vec_new');
    tabletype_vec_copy := ProcAddress('wasm_tabletype_vec_copy');
    tabletype_vec_delete := ProcAddress('wasm_tabletype_vec_delete');
    tabletype_new := ProcAddress('wasm_tabletype_new');
    tabletype_element := ProcAddress('wasm_tabletype_element');
    tabletype_limits := ProcAddress('wasm_tabletype_limits');
    memorytype_delete := ProcAddress('wasm_memorytype_delete');
    memorytype_copy := ProcAddress('wasm_memorytype_copy');
    memorytype_vec_new_empty := ProcAddress('wasm_memorytype_vec_new_empty');
    memorytype_vec_new_uninitialized := ProcAddress('wasm_memorytype_vec_new_uninitialized');
    memorytype_vec_new := ProcAddress('wasm_memorytype_vec_new');
    memorytype_vec_copy := ProcAddress('wasm_memorytype_vec_copy');
    memorytype_vec_delete := ProcAddress('wasm_memorytype_vec_delete');
    memorytype_new := ProcAddress('wasm_memorytype_new');
    memorytype_limits := ProcAddress('wasm_memorytype_limits');
    externtype_delete := ProcAddress('wasm_externtype_delete');
    externtype_copy := ProcAddress('wasm_externtype_copy');
    externtype_vec_new_empty := ProcAddress('wasm_externtype_vec_new_empty');
    externtype_vec_new_uninitialized := ProcAddress('wasm_externtype_vec_new_uninitialized');
    externtype_vec_new := ProcAddress('wasm_externtype_vec_new');
    externtype_vec_copy := ProcAddress('wasm_externtype_vec_copy');
    externtype_vec_delete := ProcAddress('wasm_externtype_vec_delete');
    externtype_kind := ProcAddress('wasm_externtype_kind');
    functype_as_externtype := ProcAddress('wasm_functype_as_externtype');
    globaltype_as_externtype := ProcAddress('wasm_globaltype_as_externtype');
    tabletype_as_externtype := ProcAddress('wasm_tabletype_as_externtype');
    memorytype_as_externtype := ProcAddress('wasm_memorytype_as_externtype');
    externtype_as_functype := ProcAddress('wasm_externtype_as_functype');
    externtype_as_globaltype := ProcAddress('wasm_externtype_as_globaltype');
    externtype_as_tabletype := ProcAddress('wasm_externtype_as_tabletype');
    externtype_as_memorytype := ProcAddress('wasm_externtype_as_memorytype');
    functype_as_externtype_const := ProcAddress('wasm_functype_as_externtype_const');
    globaltype_as_externtype_const := ProcAddress('wasm_globaltype_as_externtype_const');
    tabletype_as_externtype_const := ProcAddress('wasm_tabletype_as_externtype_const');
    memorytype_as_externtype_const := ProcAddress('wasm_memorytype_as_externtype_const');
    externtype_as_functype_const := ProcAddress('wasm_externtype_as_functype_const');
    externtype_as_globaltype_const := ProcAddress('wasm_externtype_as_globaltype_const');
    externtype_as_tabletype_const := ProcAddress('wasm_externtype_as_tabletype_const');
    externtype_as_memorytype_const := ProcAddress('wasm_externtype_as_memorytype_const');
    importtype_delete := ProcAddress('wasm_importtype_delete');
    importtype_copy := ProcAddress('wasm_importtype_copy');
    importtype_vec_new_empty := ProcAddress('wasm_importtype_vec_new_empty');
    importtype_vec_new_uninitialized := ProcAddress('wasm_importtype_vec_new_uninitialized');
    importtype_vec_new := ProcAddress('wasm_importtype_vec_new');
    importtype_vec_copy := ProcAddress('wasm_importtype_vec_copy');
    importtype_vec_delete := ProcAddress('wasm_importtype_vec_delete');
    importtype_new := ProcAddress('wasm_importtype_new');
    importtype_module := ProcAddress('wasm_importtype_module');
    importtype_name := ProcAddress('wasm_importtype_name');
    importtype_type := ProcAddress('wasm_importtype_type');
    exporttype_delete := ProcAddress('wasm_exporttype_delete');
    exporttype_copy := ProcAddress('wasm_exporttype_copy');
    exporttype_vec_new_empty := ProcAddress('wasm_exporttype_vec_new_empty');
    exporttype_vec_new_uninitialized := ProcAddress('wasm_exporttype_vec_new_uninitialized');
    exporttype_vec_new := ProcAddress('wasm_exporttype_vec_new');
    exporttype_vec_copy := ProcAddress('wasm_exporttype_vec_copy');
    exporttype_vec_delete := ProcAddress('wasm_exporttype_vec_delete');
    exporttype_new := ProcAddress('wasm_exporttype_new');
    exporttype_name := ProcAddress('wasm_exporttype_name');
    exporttype_type := ProcAddress('wasm_exporttype_type');
    val_delete := ProcAddress('wasm_val_delete');
    val_copy := ProcAddress('wasm_val_copy');
    val_vec_new_empty := ProcAddress('wasm_val_vec_new_empty');
    val_vec_new_uninitialized := ProcAddress('wasm_val_vec_new_uninitialized');
    val_vec_new := ProcAddress('wasm_val_vec_new');
    val_vec_copy := ProcAddress('wasm_val_vec_copy');
    val_vec_delete := ProcAddress('wasm_val_vec_delete');
    ref_delete := ProcAddress('wasm_ref_delete');
    ref_copy := ProcAddress('wasm_ref_copy');
    ref_same := ProcAddress('wasm_ref_same');
    ref_get_host_info := ProcAddress('wasm_ref_same');
    ref_set_host_info := ProcAddress('wasm_ref_set_host_info');
    ref_set_host_info_with_finalizer := ProcAddress('wasm_ref_set_host_info_with_finalizer');
    frame_delete := ProcAddress('wasm_frame_delete');
    frame_vec_new_empty := ProcAddress('wasm_frame_vec_new_empty');
    frame_vec_new_uninitialized := ProcAddress('wasm_frame_vec_new_uninitialized');
    frame_vec_new := ProcAddress('wasm_frame_vec_new');
    frame_vec_copy := ProcAddress('wasm_frame_vec_copy');
    frame_vec_delete := ProcAddress('wasm_frame_vec_delete');
    frame_copy := ProcAddress('wasm_frame_copy');
    frame_instance := ProcAddress('wasm_frame_instance');
    frame_func_index := ProcAddress('wasm_frame_func_index');
    frame_func_offset := ProcAddress('wasm_frame_func_offset');
    frame_module_offset := ProcAddress('wasm_frame_module_offset');
    trap_delete := ProcAddress('wasm_trap_delete');
    trap_copy := ProcAddress('wasm_trap_copy');
    trap_same := ProcAddress('wasm_trap_same');
    trap_get_host_info := ProcAddress('wasm_trap_same');
    trap_set_host_info := ProcAddress('wasm_trap_set_host_info');
    trap_set_host_info_with_finalizer := ProcAddress('wasm_trap_set_host_info_with_finalizer');
    trap_as_ref := ProcAddress('wasm_trap_as_ref');
    trap_as_ref_const := ProcAddress('wasm_trap_as_ref_const');
    ref_as_trap := ProcAddress('wasm_ref_as_trap');
    ref_as_trap_const := ProcAddress('wasm_ref_as_trap_const');
    trap_new := ProcAddress('wasm_trap_new');
    trap_message := ProcAddress('wasm_trap_message');
    trap_origin := ProcAddress('wasm_trap_origin');
    trap_trace := ProcAddress('wasm_trap_trace');
    foreign_delete := ProcAddress('wasm_foreign_delete');
    foreign_copy := ProcAddress('wasm_foreign_copy');
    foreign_same := ProcAddress('wasm_foreign_same');
    foreign_get_host_info := ProcAddress('wasm_foreign_same');
    foreign_set_host_info := ProcAddress('wasm_foreign_set_host_info');
    foreign_set_host_info_with_finalizer := ProcAddress('wasm_foreign_set_host_info_with_finalizer');
    foreign_as_ref := ProcAddress('wasm_foreign_as_ref');
    foreign_as_ref_const := ProcAddress('wasm_foreign_as_ref_const');
    ref_as_foreign := ProcAddress('wasm_ref_as_foreign');
    ref_as_foreign_const := ProcAddress('wasm_ref_as_foreign_const');
    foreign_new := ProcAddress('wasm_foreign_new');
    module_delete := ProcAddress('wasm_module_delete');
    module_copy := ProcAddress('wasm_module_copy');
    module_same := ProcAddress('wasm_module_same');
    module_get_host_info := ProcAddress('wasm_module_same');
    module_set_host_info := ProcAddress('wasm_module_set_host_info');
    module_set_host_info_with_finalizer := ProcAddress('wasm_module_set_host_info_with_finalizer');
    module_as_ref := ProcAddress('wasm_module_as_ref');
    module_as_ref_const := ProcAddress('wasm_module_as_ref_const');
    ref_as_module := ProcAddress('wasm_ref_as_module');
    ref_as_module_const := ProcAddress('wasm_ref_as_module_const');
    shared_module_delete := ProcAddress('wasm_shared_module_delete');
    shared_module_copy := ProcAddress('wasm_shared_module_copy');
    shared_module_same := ProcAddress('wasm_shared_module_same');
    shared_module_get_host_info := ProcAddress('wasm_shared_module_same');
    shared_module_set_host_info := ProcAddress('wasm_shared_module_set_host_info');
    shared_module_set_host_info_with_finalizer := ProcAddress('wasm_shared_module_set_host_info_with_finalizer');
    shared_module_as_ref := ProcAddress('wasm_shared_module_as_ref');
    shared_module_as_ref_const := ProcAddress('wasm_shared_module_as_ref_const');
    ref_as_shared_module := ProcAddress('wasm_ref_as_shared_module');
    ref_as_shared_module_const := ProcAddress('wasm_ref_as_shared_module_const');
    module_share := ProcAddress('wasm_module_share');
    module_obtain := ProcAddress('wasm_module_obtain');
    module_new := ProcAddress('wasm_module_new');
    module_validate := ProcAddress('wasm_module_validate');
    module_imports := ProcAddress('wasm_module_imports');
    module_exports := ProcAddress('wasm_module_exports');
    module_serialize := ProcAddress('wasm_module_serialize');
    module_deserialize := ProcAddress('wasm_module_deserialize');
    func_delete := ProcAddress('wasm_func_delete');
    func_copy := ProcAddress('wasm_func_copy');
    func_same := ProcAddress('wasm_func_same');
    func_get_host_info := ProcAddress('wasm_func_same');
    func_set_host_info := ProcAddress('wasm_func_set_host_info');
    func_set_host_info_with_finalizer := ProcAddress('wasm_func_set_host_info_with_finalizer');
    func_as_ref := ProcAddress('wasm_func_as_ref');
    func_as_ref_const := ProcAddress('wasm_func_as_ref_const');
    ref_as_func := ProcAddress('wasm_ref_as_func');
    ref_as_func_const := ProcAddress('wasm_ref_as_func_const');
    func_new := ProcAddress('wasm_func_new');
    func_new_with_env := ProcAddress('wasm_func_new_with_env');
    func_type := ProcAddress('wasm_func_type');
    func_param_arity := ProcAddress('wasm_func_param_arity');
    func_result_arity := ProcAddress('wasm_func_result_arity');
    func_call := ProcAddress('wasm_func_call');
    global_delete := ProcAddress('wasm_global_delete');
    global_copy := ProcAddress('wasm_global_copy');
    global_same := ProcAddress('wasm_global_same');
    global_get_host_info := ProcAddress('wasm_global_same');
    global_set_host_info := ProcAddress('wasm_global_set_host_info');
    global_set_host_info_with_finalizer := ProcAddress('wasm_global_set_host_info_with_finalizer');
    global_as_ref := ProcAddress('wasm_global_as_ref');
    global_as_ref_const := ProcAddress('wasm_global_as_ref_const');
    ref_as_global := ProcAddress('wasm_ref_as_global');
    ref_as_global_const := ProcAddress('wasm_ref_as_global_const');
    global_new := ProcAddress('wasm_global_new');
    global_type := ProcAddress('wasm_global_type');
    global_get := ProcAddress('wasm_global_get');
    global_set := ProcAddress('wasm_global_set');
    table_delete := ProcAddress('wasm_table_delete');
    table_copy := ProcAddress('wasm_table_copy');
    table_same := ProcAddress('wasm_table_same');
    table_get_host_info := ProcAddress('wasm_table_same');
    table_set_host_info := ProcAddress('wasm_table_set_host_info');
    table_set_host_info_with_finalizer := ProcAddress('wasm_table_set_host_info_with_finalizer');
    table_as_ref := ProcAddress('wasm_table_as_ref');
    table_as_ref_const := ProcAddress('wasm_table_as_ref_const');
    ref_as_table := ProcAddress('wasm_ref_as_table');
    ref_as_table_const := ProcAddress('wasm_ref_as_table_const');
    table_new := ProcAddress('wasm_table_new');
    table_type := ProcAddress('wasm_table_type');
    table_get := ProcAddress('wasm_table_get');
    table_set := ProcAddress('wasm_table_set');
    table_size := ProcAddress('wasm_table_size');
    table_grow := ProcAddress('wasm_table_grow');
    memory_delete := ProcAddress('wasm_memory_delete');
    memory_copy := ProcAddress('wasm_memory_copy');
    memory_same := ProcAddress('wasm_memory_same');
    memory_get_host_info := ProcAddress('wasm_memory_same');
    memory_set_host_info := ProcAddress('wasm_memory_set_host_info');
    memory_set_host_info_with_finalizer := ProcAddress('wasm_memory_set_host_info_with_finalizer');
    memory_as_ref := ProcAddress('wasm_memory_as_ref');
    memory_as_ref_const := ProcAddress('wasm_memory_as_ref_const');
    ref_as_memory := ProcAddress('wasm_ref_as_memory');
    ref_as_memory_const := ProcAddress('wasm_ref_as_memory_const');
    memory_new := ProcAddress('wasm_memory_new');
    memory_type := ProcAddress('wasm_memory_type');
    memory_data := ProcAddress('wasm_memory_data');
    memory_data_size := ProcAddress('wasm_memory_data_size');
    memory_size := ProcAddress('wasm_memory_size');
    memory_grow := ProcAddress('wasm_memory_grow');
    extern_delete := ProcAddress('wasm_extern_delete');
    extern_copy := ProcAddress('wasm_extern_copy');
    extern_same := ProcAddress('wasm_extern_same');
    extern_get_host_info := ProcAddress('wasm_extern_same');
    extern_set_host_info := ProcAddress('wasm_extern_set_host_info');
    extern_set_host_info_with_finalizer := ProcAddress('wasm_extern_set_host_info_with_finalizer');
    extern_as_ref := ProcAddress('wasm_extern_as_ref');
    extern_as_ref_const := ProcAddress('wasm_extern_as_ref_const');
    ref_as_extern := ProcAddress('wasm_ref_as_extern');
    ref_as_extern_const := ProcAddress('wasm_ref_as_extern_const');
    extern_vec_new_empty := ProcAddress('wasm_extern_vec_new_empty');
    extern_vec_new_uninitialized := ProcAddress('wasm_extern_vec_new_uninitialized');
    extern_vec_new := ProcAddress('wasm_extern_vec_new');
    extern_vec_copy := ProcAddress('wasm_extern_vec_copy');
    extern_vec_delete := ProcAddress('wasm_extern_vec_delete');
    extern_kind := ProcAddress('wasm_extern_kind');
    extern_type := ProcAddress('wasm_extern_type');
    func_as_extern := ProcAddress('wasm_func_as_extern');
    global_as_extern := ProcAddress('wasm_global_as_extern');
    table_as_extern := ProcAddress('wasm_table_as_extern');
    memory_as_extern := ProcAddress('wasm_memory_as_extern');
    extern_as_func := ProcAddress('wasm_extern_as_func');
    extern_as_global := ProcAddress('wasm_extern_as_global');
    extern_as_table := ProcAddress('wasm_extern_as_table');
    extern_as_memory := ProcAddress('wasm_extern_as_memory');
    func_as_extern_const := ProcAddress('wasm_func_as_extern_const');
    global_as_extern_const := ProcAddress('wasm_global_as_extern_const');
    table_as_extern_const := ProcAddress('wasm_table_as_extern_const');
    memory_as_extern_const := ProcAddress('wasm_memory_as_extern_const');
    extern_as_func_const := ProcAddress('wasm_extern_as_func_const');
    extern_as_global_const := ProcAddress('wasm_extern_as_global_const');
    extern_as_table_const := ProcAddress('wasm_extern_as_table_const');
    extern_as_memory_const := ProcAddress('wasm_extern_as_memory_const');
    instance_delete := ProcAddress('wasm_instance_delete');
    instance_copy := ProcAddress('wasm_instance_copy');
    instance_same := ProcAddress('wasm_instance_same');
    instance_get_host_info := ProcAddress('wasm_instance_same');
    instance_set_host_info := ProcAddress('wasm_instance_set_host_info');
    instance_set_host_info_with_finalizer := ProcAddress('wasm_instance_set_host_info_with_finalizer');
    instance_as_ref := ProcAddress('wasm_instance_as_ref');
    instance_as_ref_const := ProcAddress('wasm_instance_as_ref_const');
    ref_as_instance := ProcAddress('wasm_ref_as_instance');
    ref_as_instance_const := ProcAddress('wasm_ref_as_instance_const');
    instance_new := ProcAddress('wasm_instance_new');
    instance_exports := ProcAddress('wasm_instance_exports');

  end;
end;

class procedure TWasm.name_new_from_string(out_: PWasmName;  const s: UTF8String);
begin
  TWasm.byte_vec_new(PWasmByteVec(out_), Length(s), @s[1]);
end;

class procedure TWasm.name_new_from_string_nt(out_: PWasmName;  const s: UTF8String);
begin
  TWasm.byte_vec_new(PWasmByteVec(out_), Length(s)+1, @s[1]);
end;

class function TWasm.valkind_is_num(k : TWasmValkind) : Boolean;
begin
  result := k < WASM_ANYREF;
end;

class function TWasm.valkind_is_ref(k : TWasmValkind) : Boolean;
begin
  result := k >= WASM_ANYREF;
end;

class function TWasm.valtype_is_num(const t : PWasmValType) : Boolean;
begin
  result := TWasm.valkind_is_num(TWasm.valtype_kind(t));
end;

class function TWasm.valtype_is_ref(const t : PWasmValType) : Boolean;
begin
  result := TWasm.valkind_is_ref(TWasm.valtype_kind(t));
end;

// Value Type construction short-hands

class function TWasm.valtype_new_i32() : PWasmValType;
begin
  result := TWasm.valtype_new(WASM_I32);
end;

class function TWasm.valtype_new_i64() : PWasmValType;
begin
  result := TWasm.valtype_new(WASM_I64);
end;

class function TWasm.valtype_new_f32() : PWasmValType;
begin
  result := TWasm.valtype_new(WASM_F32);
end;

class function TWasm.valtype_new_f64() : PWasmValType;
begin
 result := TWasm.valtype_new(WASM_F64);
end;

class function TWasm.valtype_new_anyref() : PWasmValType;
begin
  result := TWasm.valtype_new(WASM_ANYREF);
end;

class function TWasm.valtype_new_funcref() : PWasmValType;
begin
  result := TWasm.valtype_new(WASM_FUNCREF);
end;

// Function Types construction short-hands

class function TWasm.functype_new_0_0() : PWasmFunctype;
var
  params, results : TWasmValtypeVec;
begin
  TWasm.valtype_vec_new_empty(@params);
  TWasm.valtype_vec_new_empty(@results);
  result := TWasm.functype_new(@params, @results);
end;

class function TWasm.functype_new_1_0(p : PWasmValType) : PWasmFunctype;
var
  params, results : TWasmValtypeVec;
  ps : array[0..0] of PWasmValType;
begin
  ps[0] := p;
  TWasm.valtype_vec_new(@params, 1, @ps[0]);
  TWasm.valtype_vec_new_empty(@results);
  result := TWasm.functype_new(@params, @results);
end;

class function TWasm.functype_new_2_0({own}p1,p2 : PWasmValType) : PWasmFunctype;
var
  params, results : TWasmValtypeVec;
  ps : array[0..1] of PWasmValType;
begin
  ps[0] := p1;
  ps[1] := p2;
  TWasm.valtype_vec_new(@params, 2, @ps[0]);
  TWasm.valtype_vec_new_empty(@results);
  result := TWasm.functype_new(@params, @results);
end;

class function TWasm.functype_new_3_0({own}p1,p2,p3 : PWasmValType) : PWasmFunctype;
var
  params, results : TWasmValtypeVec;
  ps : array[0..2] of PWasmValType;
begin
  ps[0] := p1;
  ps[1] := p2;
  ps[2] := p3;
  TWasm.valtype_vec_new(@params, 3, @ps[0]);
  TWasm.valtype_vec_new_empty(@results);
  result := TWasm.functype_new(@params, @results);
end;

class function TWasm.functype_new_0_1({own} r : PWasmValType) : PWasmFunctype;
var
  params, results : TWasmValtypeVec;
 rs : array[0..0] of PWasmValType;
begin
  rs[0] := r;
  TWasm.valtype_vec_new_empty(@params);
  TWasm.valtype_vec_new(@results, 1, @rs[0]);
  result := TWasm.functype_new(@params, @results);
end;

class function TWasm.functype_new_1_1({own} p, r : PWasmValType) : PWasmFunctype;
var
  params, results : TWasmValtypeVec;
  ps : array[0..0] of PWasmValType;
  rs : array[0..0] of PWasmValType;
begin
  ps[0] := p;
  rs[0] := r;
  TWasm.valtype_vec_new(@params, 1, @ps[0]);
  TWasm.valtype_vec_new(@results, 1, @rs[0]);
  result := TWasm.functype_new(@params, @results);
end;

class function TWasm.functype_new_2_1({own} p1,p2, r : PWasmValType) : PWasmFunctype;
var
  params, results : TWasmValtypeVec;
  ps : array[0..1] of PWasmValType;
  rs : array[0..0] of PWasmValType;
begin
  ps[0] := p1;
  ps[1] := p2;
  rs[0] := r;
  TWasm.valtype_vec_new(@params, 2, @ps[0]);
  TWasm.valtype_vec_new(@results, 1, @rs[0]);
  result := TWasm.functype_new(@params, @results);
end;

class function TWasm.functype_new_3_1({own} p1,p2,p3, r : PWasmValType) : PWasmFunctype;
var
  params, results : TWasmValtypeVec;
  ps : array[0..2] of PWasmValType;
  rs : array[0..0] of PWasmValType;
begin
  ps[0] := p1;
  ps[1] := p2;
  ps[2] := p3;
  rs[0] := r;
  TWasm.valtype_vec_new(@params, 3, @ps[0]);
  TWasm.valtype_vec_new(@results, 1, @rs[0]);
  result := TWasm.functype_new(@params, @results);
end;

class function TWasm.functype_new_0_2({own} r1,r2 : PWasmValType) : PWasmFunctype;
var
  params, results : TWasmValtypeVec;
  rs : array[0..1] of PWasmValType;
begin
  rs[0] := r1;
  rs[1] := r2;
  TWasm.valtype_vec_new_empty(@params);
  TWasm.valtype_vec_new(@results, 2, @rs[0]);
  result := TWasm.functype_new(@params, @results);
end;

class function TWasm.functype_new_1_2({own} p, r1,r2 : PWasmValType) : PWasmFunctype;
var
  params, results : TWasmValtypeVec;
  ps : array[0..0] of PWasmValType;
  rs : array[0..1] of PWasmValType;
begin
  ps[0] := p;
  rs[0] := r1;
  rs[1] := r2;
  TWasm.valtype_vec_new(@params, 1, @ps[0]);
  TWasm.valtype_vec_new(@results, 2, @rs[0]);
  result := TWasm.functype_new(@params, @results);
end;

class function TWasm.functype_new_2_2({own} p1,p2, r1,r2 : PWasmValType) : PWasmFunctype;
var
  params, results : TWasmValtypeVec;
  ps : array[0..1] of PWasmValType;
  rs : array[0..1] of PWasmValType;
begin
  ps[0] := p1;
  ps[1] := p2;
  rs[0] := r1;
  rs[1] := r2;
  TWasm.valtype_vec_new(@params, 2, @ps[0]);
  TWasm.valtype_vec_new(@results, 2, @rs[0]);
  result := TWasm.functype_new(@params, @results);
end;

class function TWasm.functype_new_3_2({own} p1,p2,p3, r1,r2 : PWasmValType) : PWasmFunctype;
var
  params, results : TWasmValtypeVec;
  ps : array[0..2] of PWasmValType;
  rs : array[0..1] of PWasmValType;
begin
  ps[0] := p1;
  ps[1] := p2;
  ps[2] := p3;
  rs[0] := r1;
  rs[1] := r2;
  TWasm.valtype_vec_new(@params, 3, @ps[0]);
  TWasm.valtype_vec_new(@results, 2, @rs[0]);
  result := TWasm.functype_new(@params, @results);
end;

class function TWasm.functype_new_array(const p : array of PWasmValType; const r : array of PWasmValType) : PWasmFunctype;
var
  params, results : TWasmValtypeVec;
begin
  TWasm.valtype_vec_new(@params, Length(p), @p[0]);
  TWasm.valtype_vec_new(@results, Length(r), @r[0]);
  result := TWasm.functype_new(@params, @results);
end;


// Value construction short-hands

procedure WasmValInitPtr({own} out_ : PWasmVal; p : Pointer);
begin
{$ifdef CPU64BITS}
  out_.kind := WASM_I64;
  out_.i64 := Int64(p);
{$else}
  out_.kind := WASM_I32;
  out_.i32 := Ord(p);
{$endif}
end;

function WasmValPtr(const val : PWasmVal) : Pointer;
begin
{$ifdef CPU64BITS}
result := Pointer(val.i64);
{$else}
result := Pointer(val.i32);
{$endif}
end;

{ TWasmVec<T> }

constructor TWasmVec<T>.Create(const arry: array of T);
begin
  self.size := Length(arry);
  self.data := @arry[0];
end;

function TWasmVec<T>.GetItem(i: Integer): T;
begin
  var p := self.data;
  Inc(p, i);
  result := p^;
end;

function TWasmVec<T>.GetPointers(i : Integer) : Pointer;
begin
  var p := self.data;
  Inc(p, i);
  result := p;
end;

class operator TWasmVec<T>.Implicit(const arry: array of T): TWasmVec<T>;
begin
  result.Create(arry);
end;

procedure TWasmVec<T>.SetItem(i: Integer; Value: T);
begin
  var p := self.data;
  Inc(p, i);
  p^ := Value;
end;

constructor TWasmVec<T>.Create(size: NativeInt; data: PT);
begin
  self.size := size;
  self.data := data;
end;

{ TWasmLimits }

constructor TWasmLimits.Create(min, max: Cardinal);
begin
  self.min := min;
  self.max := max;
end;

{ TWasmValKindHelper }

function TWasmValKindHelper.IsNum: Boolean;
begin
  result := self < WASM_ANYREF;
end;

function TWasmValKindHelper.IsRef: Boolean;
begin
  result := self >= WASM_ANYREF;
end;
procedure byte_vec_disposer(p : Pointer);
begin
  TWasm.byte_vec_delete(p);
end;

procedure byte_vec_disposer_host_only(p : Pointer);
begin
  Dispose(p);
end;

procedure byte_vec_disposer_host(p : Pointer);
begin
  TWasm.byte_vec_delete(p);
  Dispose(p);
end;

procedure config_disposer(p : Pointer);
begin
  TWasm.config_delete(p);
end;

procedure engine_disposer(p : Pointer);
begin
  TWasm.engine_delete(p);
end;

procedure store_disposer(p : Pointer);
begin
  TWasm.store_delete(p);
end;

procedure valtype_disposer(p : Pointer);
begin
  TWasm.valtype_delete(p);
end;

procedure valtype_vec_disposer(p : Pointer);
begin
  TWasm.valtype_vec_delete(p);
end;

procedure valtype_vec_disposer_host_only(p : Pointer);
begin
  Dispose(p);
end;

procedure valtype_vec_disposer_host(p : Pointer);
begin
  TWasm.valtype_vec_delete(p);
  Dispose(p);
end;

procedure functype_disposer(p : Pointer);
begin
  TWasm.functype_delete(p);
end;

procedure functype_vec_disposer(p : Pointer);
begin
  TWasm.functype_vec_delete(p);
end;

procedure functype_vec_disposer_host_only(p : Pointer);
begin
  Dispose(p);
end;

procedure functype_vec_disposer_host(p : Pointer);
begin
  TWasm.functype_vec_delete(p);
  Dispose(p);
end;

procedure globaltype_disposer(p : Pointer);
begin
  TWasm.globaltype_delete(p);
end;

procedure globaltype_vec_disposer(p : Pointer);
begin
  TWasm.globaltype_vec_delete(p);
end;

procedure globaltype_vec_disposer_host_only(p : Pointer);
begin
  Dispose(p);
end;

procedure globaltype_vec_disposer_host(p : Pointer);
begin
  TWasm.globaltype_vec_delete(p);
  Dispose(p);
end;

procedure tabletype_disposer(p : Pointer);
begin
  TWasm.tabletype_delete(p);
end;

procedure tabletype_vec_disposer(p : Pointer);
begin
  TWasm.tabletype_vec_delete(p);
end;

procedure tabletype_vec_disposer_host_only(p : Pointer);
begin
  Dispose(p);
end;

procedure tabletype_vec_disposer_host(p : Pointer);
begin
  TWasm.tabletype_vec_delete(p);
  Dispose(p);
end;

procedure memorytype_disposer(p : Pointer);
begin
  TWasm.memorytype_delete(p);
end;

procedure memorytype_vec_disposer(p : Pointer);
begin
  TWasm.memorytype_vec_delete(p);
end;

procedure memorytype_vec_disposer_host_only(p : Pointer);
begin
  Dispose(p);
end;

procedure memorytype_vec_disposer_host(p : Pointer);
begin
  TWasm.memorytype_vec_delete(p);
  Dispose(p);
end;

procedure externtype_disposer(p : Pointer);
begin
  TWasm.externtype_delete(p);
end;

procedure externtype_vec_disposer(p : Pointer);
begin
  TWasm.externtype_vec_delete(p);
end;

procedure externtype_vec_disposer_host_only(p : Pointer);
begin
  Dispose(p);
end;

procedure externtype_vec_disposer_host(p : Pointer);
begin
  TWasm.externtype_vec_delete(p);
  Dispose(p);
end;

procedure importtype_disposer(p : Pointer);
begin
  TWasm.importtype_delete(p);
end;

procedure importtype_vec_disposer(p : Pointer);
begin
  TWasm.importtype_vec_delete(p);
end;

procedure importtype_vec_disposer_host_only(p : Pointer);
begin
  Dispose(p);
end;

procedure importtype_vec_disposer_host(p : Pointer);
begin
  TWasm.importtype_vec_delete(p);
  Dispose(p);
end;

procedure exporttype_disposer(p : Pointer);
begin
  TWasm.exporttype_delete(p);
end;

procedure exporttype_vec_disposer(p : Pointer);
begin
  TWasm.exporttype_vec_delete(p);
end;

procedure exporttype_vec_disposer_host_only(p : Pointer);
begin
  Dispose(p);
end;

procedure exporttype_vec_disposer_host(p : Pointer);
begin
  TWasm.exporttype_vec_delete(p);
  Dispose(p);
end;

procedure val_disposer(p : Pointer);
begin
  TWasm.val_delete(p);
end;

procedure val_disposer_host(p : Pointer);
begin
  TWasm.val_delete(p);
  Dispose(p);
end;

procedure val_vec_disposer(p : Pointer);
begin
  TWasm.val_vec_delete(p);
end;

procedure val_vec_disposer_host_only(p : Pointer);
begin
  Dispose(p);
end;

procedure val_vec_disposer_host(p : Pointer);
begin
  TWasm.val_vec_delete(p);
  Dispose(p);
end;

procedure ref_disposer(p : Pointer);
begin
  TWasm.ref_delete(p);
end;

procedure frame_disposer(p : Pointer);
begin
  TWasm.frame_delete(p);
end;

procedure frame_vec_disposer(p : Pointer);
begin
  TWasm.frame_vec_delete(p);
end;

procedure frame_vec_disposer_host_only(p : Pointer);
begin
  Dispose(p);
end;

procedure frame_vec_disposer_host(p : Pointer);
begin
  TWasm.frame_vec_delete(p);
  Dispose(p);
end;

procedure trap_disposer(p : Pointer);
begin
  TWasm.trap_delete(p);
end;

procedure foreign_disposer(p : Pointer);
begin
  TWasm.foreign_delete(p);
end;

procedure module_disposer(p : Pointer);
begin
  TWasm.module_delete(p);
end;

procedure shared_module_disposer(p : Pointer);
begin
  TWasm.shared_module_delete(p);
end;

procedure func_disposer(p : Pointer);
begin
  TWasm.func_delete(p);
end;

procedure global_disposer(p : Pointer);
begin
  TWasm.global_delete(p);
end;

procedure table_disposer(p : Pointer);
begin
  TWasm.table_delete(p);
end;

procedure memory_disposer(p : Pointer);
begin
  TWasm.memory_delete(p);
end;

procedure extern_disposer(p : Pointer);
begin
  TWasm.extern_delete(p);
end;

procedure extern_vec_disposer(p : Pointer);
begin
  TWasm.extern_vec_delete(p);
end;

procedure extern_vec_disposer_host_only(p : Pointer);
begin
  Dispose(p);
end;

procedure extern_vec_disposer_host(p : Pointer);
begin
  TWasm.extern_vec_delete(p);
  Dispose(p);
end;

procedure instance_disposer(p : Pointer);
begin
  TWasm.instance_delete(p);
end;


{ TOwnByteVec }

class function TOwnByteVec.Wrap(p: PWasmByteVec; deleter : TRcDeleter): TOwnByteVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmByteVec>.Create(p, deleter);
end;

class function TOwnByteVec.Wrap(p: PWasmByteVec): TOwnByteVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmByteVec>.Create(p, byte_vec_disposer);
end;

class operator TOwnByteVec.Finalize(var Dest: TOwnByteVec);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnByteVec.Implicit(const Src: IRcContainer<PWasmByteVec>): TOwnByteVec;
begin
  result.FStrongRef := Src;
end;

class operator TOwnByteVec.Negative(Src: TOwnByteVec): IRcContainer<PWasmByteVec>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnByteVec.Positive(Src: TOwnByteVec): PWasmByteVec;
begin
  result := Src.Unwrap;
end;

function TOwnByteVec.Unwrap: PWasmByteVec;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnByteVec.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmByteVec }

constructor TWasmByteVec.Create(const arry: array of TWasmByte);
begin
  size := Length(arry);
  if size = 0 then data := nil
  else             data := @arry[0];
end;

class function TWasmByteVec.New(const init: array of TWasmByte): TOwnByteVec;
var
  prec : PWasmByteVec;
begin
  System.New(prec);
  TWasm.byte_vec_new(prec, Length(init), @init[0]);
  result.FStrongRef := TRcContainer<PWasmByteVec>.Create(prec, byte_vec_disposer_host);
end;

class function TWasmByteVec.NewEmpty: TOwnByteVec;
var
  prec : PWasmByteVec;
begin
  System.New(prec);
  TWasm.byte_vec_new_empty(prec);
  result.FStrongRef := TRcContainer<PWasmByteVec>.Create(prec, byte_vec_disposer_host);
end;

class function TWasmByteVec.NewUninitialized(size: NativeInt): TOwnByteVec;
var
  prec : PWasmByteVec;
begin
  System.New(prec);
  TWasm.byte_vec_new_uninitialized(prec, size);
  result.FStrongRef := TRcContainer<PWasmByteVec>.Create(prec, byte_vec_disposer_host);
end;

function TWasmByteVec.Copy: TOwnByteVec;
var
  prec : PWasmByteVec;
begin
  System.New(prec);
  TWasm.byte_vec_copy(prec, @self);
  result.FStrongRef := TRcContainer<PWasmByteVec>.Create(prec, byte_vec_disposer_host);
end;

procedure TWasmByteVec.Assign(const Src :TOwnByteVec);
begin
  TWasm.byte_vec_copy(@self, Src.Unwrap);
end;

function TWasmByteVec.LoadFromFile(fname: string): Boolean;
begin
  var stream := TRc.Wrap(TFileStream.Create(fname, fmOpenRead));
  var file_size := (+stream).Size;
  var binary := TWasmByteVec.NewUninitialized(file_size);
  if (+stream).ReadData(binary.Unwrap.data, file_size) <> file_size then
  begin
    exit(false);
  end;

  Assign(binary);
  result := true;
end;

function TWasmByteVec.AsUTF8String: UTF8String;
begin
  var buf := TArray<Byte>.Create();
  SetLength(buf, size+1);
  Move(data^, buf[0], size);
  result := UTF8String(PAnsiChar(@buf[0]));
end;

function TWasmByteVec.AsString: string;
begin
  var buf := TArray<Byte>.Create();
  SetLength(buf, size+1);
  Move(data^, buf[0], size);
  result := string(PAnsiChar(@buf[0]));
end;

class function TWasmByteVec.NewFromString(s : UTF8String): TOwnName;
begin
  var ret : PWasmByteVec;
  System.New(ret);
  TWasm.byte_vec_new(ret, Length(s), @s[1]);
  result.FStrongRef := TRcContainer<PWasmByteVec>.Create(ret, byte_vec_disposer); // ref ++
end;

class function TWasmByteVec.NewFromStringNt(s : UTF8String): TOwnName;
begin
  var ret : PWasmByteVec;
  System.New(ret);
  TWasm.byte_vec_new(ret, Length(s)+1, @s[1]);
  result.FStrongRef := TRcContainer<PWasmByteVec>.Create(ret, byte_vec_disposer); // ref ++
end;

class function TWasmByteVec.NewFromStringNt(s : string): TOwnName;
begin
  var ret : PWasmByteVec;
  System.New(ret);
  var s8 := UTF8String(s);
  TWasm.byte_vec_new(ret, Length(s8)+1, @s8[1]);
  result.FStrongRef := TRcContainer<PWasmByteVec>.Create(ret, byte_vec_disposer); // ref ++
end;

class function TWasmByteVec.NewFromString(s : string): TOwnName;
begin
  var ret : PWasmByteVec;
  System.New(ret);
  var s8 := UTF8String(s);
  TWasm.byte_vec_new(ret, Length(s8), @s8[1]);
  result.FStrongRef := TRcContainer<PWasmByteVec>.Create(ret, byte_vec_disposer); // ref ++
end;

{ TOwnConfig }

class function TOwnConfig.Wrap(p: PWasmConfig; deleter : TRcDeleter): TOwnConfig;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmConfig>.Create(p, deleter);
end;

class function TOwnConfig.Wrap(p: PWasmConfig): TOwnConfig;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmConfig>.Create(p, config_disposer);
end;

class operator TOwnConfig.Finalize(var Dest: TOwnConfig);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnConfig.Implicit(const Src: IRcContainer<PWasmConfig>): TOwnConfig;
begin
  result.FStrongRef := Src;
end;

class operator TOwnConfig.Negative(Src: TOwnConfig): IRcContainer<PWasmConfig>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnConfig.Positive(Src: TOwnConfig): PWasmConfig;
begin
  result := Src.Unwrap;
end;

function TOwnConfig.Unwrap: PWasmConfig;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnConfig.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmConfig }


class function TWasmConfig.New() : TOwnConfig;
begin
  var p := TWasm.config_new();
  result := TOwnConfig.Wrap(p, config_disposer); // ref ++
end;

{ TOwnEngine }

class function TOwnEngine.Wrap(p: PWasmEngine; deleter : TRcDeleter): TOwnEngine;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmEngine>.Create(p, deleter);
end;

class function TOwnEngine.Wrap(p: PWasmEngine): TOwnEngine;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmEngine>.Create(p, engine_disposer);
end;

class operator TOwnEngine.Finalize(var Dest: TOwnEngine);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnEngine.Implicit(const Src: IRcContainer<PWasmEngine>): TOwnEngine;
begin
  result.FStrongRef := Src;
end;

class operator TOwnEngine.Negative(Src: TOwnEngine): IRcContainer<PWasmEngine>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnEngine.Positive(Src: TOwnEngine): PWasmEngine;
begin
  result := Src.Unwrap;
end;

function TOwnEngine.Unwrap: PWasmEngine;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnEngine.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmEngine }


class function TWasmEngine.New() : TOwnEngine;
begin
  var p := TWasm.engine_new();
  result := TOwnEngine.Wrap(p, engine_disposer); // ref ++
end;

class function TWasmEngine.NewWithConfig(config : TOwnConfig) : TOwnEngine;
begin
  var p := TWasm.engine_new_with_config((-config).Move);
  result := TOwnEngine.Wrap(p, engine_disposer); // ref ++
end;

{ TOwnStore }

class function TOwnStore.Wrap(p: PWasmStore; deleter : TRcDeleter): TOwnStore;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmStore>.Create(p, deleter);
end;

class function TOwnStore.Wrap(p: PWasmStore): TOwnStore;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmStore>.Create(p, store_disposer);
end;

class operator TOwnStore.Finalize(var Dest: TOwnStore);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnStore.Implicit(const Src: IRcContainer<PWasmStore>): TOwnStore;
begin
  result.FStrongRef := Src;
end;

class operator TOwnStore.Negative(Src: TOwnStore): IRcContainer<PWasmStore>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnStore.Positive(Src: TOwnStore): PWasmStore;
begin
  result := Src.Unwrap;
end;

function TOwnStore.Unwrap: PWasmStore;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnStore.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmStore }


class function TWasmStore.New(engine : PWasmEngine) : TOwnStore;
begin
  var p := TWasm.store_new(engine);
  result := TOwnStore.Wrap(p, store_disposer); // ref ++
end;

{ TOwnValtypeVec }

class function TOwnValtypeVec.Wrap(p: PWasmValtypeVec; deleter : TRcDeleter): TOwnValtypeVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmValtypeVec>.Create(p, deleter);
end;

class function TOwnValtypeVec.Wrap(p: PWasmValtypeVec): TOwnValtypeVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmValtypeVec>.Create(p, valtype_vec_disposer);
end;

class operator TOwnValtypeVec.Finalize(var Dest: TOwnValtypeVec);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnValtypeVec.Implicit(const Src: IRcContainer<PWasmValtypeVec>): TOwnValtypeVec;
begin
  result.FStrongRef := Src;
end;

class operator TOwnValtypeVec.Negative(Src: TOwnValtypeVec): IRcContainer<PWasmValtypeVec>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnValtypeVec.Positive(Src: TOwnValtypeVec): PWasmValtypeVec;
begin
  result := Src.Unwrap;
end;

function TOwnValtypeVec.Unwrap: PWasmValtypeVec;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnValtypeVec.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmValtypeVec }

constructor TWasmValtypeVec.Create(const arry: array of PWasmValtype);
begin
  size := Length(arry);
  if size = 0 then data := nil
  else             data := @arry[0];
end;

class function TWasmValtypeVec.New(const init: array of PWasmValtype; elem_release : Boolean): TOwnValtypeVec;
var
  prec : PWasmValtypeVec;
begin
  System.New(prec);
  TWasm.valtype_vec_new(prec, Length(init), @init[0]);
  if elem_release then
    result.FStrongRef := TRcContainer<PWasmValtypeVec>.Create(prec, valtype_vec_disposer_host)
  else
    result.FStrongRef := TRcContainer<PWasmValtypeVec>.Create(prec, valtype_vec_disposer_host_only);
end;

class function TWasmValtypeVec.NewEmpty: TOwnValtypeVec;
var
  prec : PWasmValtypeVec;
begin
  System.New(prec);
  TWasm.valtype_vec_new_empty(prec);
  result.FStrongRef := TRcContainer<PWasmValtypeVec>.Create(prec, valtype_vec_disposer_host);
end;

class function TWasmValtypeVec.NewUninitialized(size: NativeInt): TOwnValtypeVec;
var
  prec : PWasmValtypeVec;
begin
  System.New(prec);
  TWasm.valtype_vec_new_uninitialized(prec, size);
  result.FStrongRef := TRcContainer<PWasmValtypeVec>.Create(prec, valtype_vec_disposer_host);
end;

class function TWasmValtypeVec.New(const arry: array of TWasmValkind): TOwnValtypeVec;
begin
  var pw : TArray<PWasmValType>;
  SetLength(pw, Length(arry));
  for var i := 0 to Length(arry)-1 do
  begin
    var v := TWasmValtype.New(arry[i]);
    pw[i] := v.FStrongRef.Move;
  end;

  result := TWasmValtypeVec.New(pw, true);
end;

class function TWasmValtypeVec.New(const init : array of TOwnValtype) : TOwnValtypeVec;
begin
  var pw : TArray<PWasmValType>;
  SetLength(pw, Length(init));
  for var i := 0 to Length(init)-1 do
  begin
    pw[i] := init[i].FStrongRef.Move;
  end;
  result := New(pw, true);
end;
function TWasmValtypeVec.Copy: TOwnValtypeVec;
var
  prec : PWasmValtypeVec;
begin
  System.New(prec);
  TWasm.valtype_vec_copy(prec, @self);
  result.FStrongRef := TRcContainer<PWasmValtypeVec>.Create(prec, valtype_vec_disposer_host);
end;

procedure TWasmValtypeVec.Assign(const Src :TOwnValtypeVec);
begin
  TWasm.valtype_vec_copy(@self, Src.Unwrap);
end;

{ TOwnValtype }

class function TOwnValtype.Wrap(p: PWasmValtype; deleter : TRcDeleter): TOwnValtype;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmValtype>.Create(p, deleter);
end;

class function TOwnValtype.Wrap(p: PWasmValtype): TOwnValtype;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmValtype>.Create(p, valtype_disposer);
end;

class operator TOwnValtype.Finalize(var Dest: TOwnValtype);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnValtype.Implicit(const Src: IRcContainer<PWasmValtype>): TOwnValtype;
begin
  result.FStrongRef := Src;
end;

class operator TOwnValtype.Negative(Src: TOwnValtype): IRcContainer<PWasmValtype>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnValtype.Positive(Src: TOwnValtype): PWasmValtype;
begin
  result := Src.Unwrap;
end;

function TOwnValtype.Unwrap: PWasmValtype;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnValtype.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmValtype }

function TWasmValtype.Copy: TOwnValtype;
begin
  var p := TWasm.valtype_copy(@self);
  result.FStrongRef := TRcContainer<PWasmValtype>.Create(p, valtype_disposer);
end;


class function TWasmValtype.New(valkind : TWasmValkind) : TOwnValtype;
begin
  var p := TWasm.valtype_new(valkind);
  result := TOwnValtype.Wrap(p, valtype_disposer); // ref ++
end;

function TWasmValtype.Kind() : TWasmValkind;
begin
  result := TWasm.valtype_kind(@self);
end;

{ TOwnFunctypeVec }

class function TOwnFunctypeVec.Wrap(p: PWasmFunctypeVec; deleter : TRcDeleter): TOwnFunctypeVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmFunctypeVec>.Create(p, deleter);
end;

class function TOwnFunctypeVec.Wrap(p: PWasmFunctypeVec): TOwnFunctypeVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmFunctypeVec>.Create(p, functype_vec_disposer);
end;

class operator TOwnFunctypeVec.Finalize(var Dest: TOwnFunctypeVec);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnFunctypeVec.Implicit(const Src: IRcContainer<PWasmFunctypeVec>): TOwnFunctypeVec;
begin
  result.FStrongRef := Src;
end;

class operator TOwnFunctypeVec.Negative(Src: TOwnFunctypeVec): IRcContainer<PWasmFunctypeVec>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnFunctypeVec.Positive(Src: TOwnFunctypeVec): PWasmFunctypeVec;
begin
  result := Src.Unwrap;
end;

function TOwnFunctypeVec.Unwrap: PWasmFunctypeVec;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnFunctypeVec.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmFunctypeVec }

constructor TWasmFunctypeVec.Create(const arry: array of PWasmFunctype);
begin
  size := Length(arry);
  if size = 0 then data := nil
  else             data := @arry[0];
end;

class function TWasmFunctypeVec.New(const init: array of PWasmFunctype; elem_release : Boolean): TOwnFunctypeVec;
var
  prec : PWasmFunctypeVec;
begin
  System.New(prec);
  TWasm.functype_vec_new(prec, Length(init), @init[0]);
  if elem_release then
    result.FStrongRef := TRcContainer<PWasmFunctypeVec>.Create(prec, functype_vec_disposer_host)
  else
    result.FStrongRef := TRcContainer<PWasmFunctypeVec>.Create(prec, functype_vec_disposer_host_only);
end;

class function TWasmFunctypeVec.NewEmpty: TOwnFunctypeVec;
var
  prec : PWasmFunctypeVec;
begin
  System.New(prec);
  TWasm.functype_vec_new_empty(prec);
  result.FStrongRef := TRcContainer<PWasmFunctypeVec>.Create(prec, functype_vec_disposer_host);
end;

class function TWasmFunctypeVec.NewUninitialized(size: NativeInt): TOwnFunctypeVec;
var
  prec : PWasmFunctypeVec;
begin
  System.New(prec);
  TWasm.functype_vec_new_uninitialized(prec, size);
  result.FStrongRef := TRcContainer<PWasmFunctypeVec>.Create(prec, functype_vec_disposer_host);
end;

function TWasmFunctypeVec.Copy: TOwnFunctypeVec;
var
  prec : PWasmFunctypeVec;
begin
  System.New(prec);
  TWasm.functype_vec_copy(prec, @self);
  result.FStrongRef := TRcContainer<PWasmFunctypeVec>.Create(prec, functype_vec_disposer_host);
end;

procedure TWasmFunctypeVec.Assign(const Src :TOwnFunctypeVec);
begin
  TWasm.functype_vec_copy(@self, Src.Unwrap);
end;

{ TOwnFunctype }

class function TOwnFunctype.Wrap(p: PWasmFunctype; deleter : TRcDeleter): TOwnFunctype;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmFunctype>.Create(p, deleter);
end;

class function TOwnFunctype.Wrap(p: PWasmFunctype): TOwnFunctype;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmFunctype>.Create(p, functype_disposer);
end;

class operator TOwnFunctype.Finalize(var Dest: TOwnFunctype);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnFunctype.Implicit(const Src: IRcContainer<PWasmFunctype>): TOwnFunctype;
begin
  result.FStrongRef := Src;
end;

class operator TOwnFunctype.Negative(Src: TOwnFunctype): IRcContainer<PWasmFunctype>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnFunctype.Positive(Src: TOwnFunctype): PWasmFunctype;
begin
  result := Src.Unwrap;
end;

function TOwnFunctype.Unwrap: PWasmFunctype;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnFunctype.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmFunctype }

function TWasmFunctype.Copy: TOwnFunctype;
begin
  var p := TWasm.functype_copy(@self);
  result.FStrongRef := TRcContainer<PWasmFunctype>.Create(p, functype_disposer);
end;

class function TWasmFuncType.New(const p,  r: array of TWasmValkind): TOwnFunctype;
begin
  var pa := TWasmValtypeVec.New(p);
  var ra := TWasmValtypeVec.New(r);

  var func := TWasm.functype_new(pa.Unwrap, ra.Unwrap);
  if func <> nil then
  begin
    result.FStrongRef := TRcContainer<PWasmFunctype>.Create(func, functype_disposer);
  end else result.FStrongRef := nil;
end;

class function TWasmFuncType.New(const p, r: array of TOwnValtype): TOwnFunctype;
begin
  var pa := TWasmValtypeVec.New(p);
  var ra := TWasmValtypeVec.New(r);

  var func := TWasm.functype_new(pa.Unwrap, ra.Unwrap);
  if func <> nil then result.FStrongRef := TRcContainer<PWasmFunctype>.Create(func, functype_disposer)
  else result.FStrongRef := nil;
end;


class function TWasmFunctype.New(params : TOwnValtypeVec; results : TOwnValtypeVec) : TOwnFunctype;
begin
  var p := TWasm.functype_new((-params).Move, (-results).Move);
  result := TOwnFunctype.Wrap(p, functype_disposer); // ref ++
end;

function TWasmFunctype.Params() : PWasmValtypeVec;
begin
  result := TWasm.functype_params(@self);
end;

function TWasmFunctype.Results() : PWasmValtypeVec;
begin
  result := TWasm.functype_results(@self);
end;

function TWasmFunctype.AsExterntype() : PWasmExterntype;
begin
  result := TWasm.functype_as_externtype(@self);
end;

function TWasmFunctype.AsExterntypeConst() : PWasmExterntype;
begin
  result := TWasm.functype_as_externtype_const(@self);
end;

{ TOwnGlobaltypeVec }

class function TOwnGlobaltypeVec.Wrap(p: PWasmGlobaltypeVec; deleter : TRcDeleter): TOwnGlobaltypeVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmGlobaltypeVec>.Create(p, deleter);
end;

class function TOwnGlobaltypeVec.Wrap(p: PWasmGlobaltypeVec): TOwnGlobaltypeVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmGlobaltypeVec>.Create(p, globaltype_vec_disposer);
end;

class operator TOwnGlobaltypeVec.Finalize(var Dest: TOwnGlobaltypeVec);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnGlobaltypeVec.Implicit(const Src: IRcContainer<PWasmGlobaltypeVec>): TOwnGlobaltypeVec;
begin
  result.FStrongRef := Src;
end;

class operator TOwnGlobaltypeVec.Negative(Src: TOwnGlobaltypeVec): IRcContainer<PWasmGlobaltypeVec>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnGlobaltypeVec.Positive(Src: TOwnGlobaltypeVec): PWasmGlobaltypeVec;
begin
  result := Src.Unwrap;
end;

function TOwnGlobaltypeVec.Unwrap: PWasmGlobaltypeVec;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnGlobaltypeVec.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmGlobaltypeVec }

constructor TWasmGlobaltypeVec.Create(const arry: array of PWasmGlobaltype);
begin
  size := Length(arry);
  if size = 0 then data := nil
  else             data := @arry[0];
end;

class function TWasmGlobaltypeVec.New(const init: array of PWasmGlobaltype; elem_release : Boolean): TOwnGlobaltypeVec;
var
  prec : PWasmGlobaltypeVec;
begin
  System.New(prec);
  TWasm.globaltype_vec_new(prec, Length(init), @init[0]);
  if elem_release then
    result.FStrongRef := TRcContainer<PWasmGlobaltypeVec>.Create(prec, globaltype_vec_disposer_host)
  else
    result.FStrongRef := TRcContainer<PWasmGlobaltypeVec>.Create(prec, globaltype_vec_disposer_host_only);
end;

class function TWasmGlobaltypeVec.NewEmpty: TOwnGlobaltypeVec;
var
  prec : PWasmGlobaltypeVec;
begin
  System.New(prec);
  TWasm.globaltype_vec_new_empty(prec);
  result.FStrongRef := TRcContainer<PWasmGlobaltypeVec>.Create(prec, globaltype_vec_disposer_host);
end;

class function TWasmGlobaltypeVec.NewUninitialized(size: NativeInt): TOwnGlobaltypeVec;
var
  prec : PWasmGlobaltypeVec;
begin
  System.New(prec);
  TWasm.globaltype_vec_new_uninitialized(prec, size);
  result.FStrongRef := TRcContainer<PWasmGlobaltypeVec>.Create(prec, globaltype_vec_disposer_host);
end;

function TWasmGlobaltypeVec.Copy: TOwnGlobaltypeVec;
var
  prec : PWasmGlobaltypeVec;
begin
  System.New(prec);
  TWasm.globaltype_vec_copy(prec, @self);
  result.FStrongRef := TRcContainer<PWasmGlobaltypeVec>.Create(prec, globaltype_vec_disposer_host);
end;

procedure TWasmGlobaltypeVec.Assign(const Src :TOwnGlobaltypeVec);
begin
  TWasm.globaltype_vec_copy(@self, Src.Unwrap);
end;

{ TOwnGlobaltype }

class function TOwnGlobaltype.Wrap(p: PWasmGlobaltype; deleter : TRcDeleter): TOwnGlobaltype;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmGlobaltype>.Create(p, deleter);
end;

class function TOwnGlobaltype.Wrap(p: PWasmGlobaltype): TOwnGlobaltype;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmGlobaltype>.Create(p, globaltype_disposer);
end;

class operator TOwnGlobaltype.Finalize(var Dest: TOwnGlobaltype);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnGlobaltype.Implicit(const Src: IRcContainer<PWasmGlobaltype>): TOwnGlobaltype;
begin
  result.FStrongRef := Src;
end;

class operator TOwnGlobaltype.Negative(Src: TOwnGlobaltype): IRcContainer<PWasmGlobaltype>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnGlobaltype.Positive(Src: TOwnGlobaltype): PWasmGlobaltype;
begin
  result := Src.Unwrap;
end;

function TOwnGlobaltype.Unwrap: PWasmGlobaltype;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnGlobaltype.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmGlobaltype }

function TWasmGlobaltype.Copy: TOwnGlobaltype;
begin
  var p := TWasm.globaltype_copy(@self);
  result.FStrongRef := TRcContainer<PWasmGlobaltype>.Create(p, globaltype_disposer);
end;

class function TWasmGlobaltype.New(valkind : TWasmValKind; mutability : TWasmMutability) : TOwnGlobaltype;
begin
  var valtype := TWasmValtype.New(valkind);
  var p := TWasm.globaltype_new((-valtype).Move, mutability);
  result := TOwnGlobaltype.Wrap(p, globaltype_disposer); // ref ++
end;


class function TWasmGlobaltype.New(valtype : TOwnValtype; mutability : TWasmMutability) : TOwnGlobaltype;
begin
  var p := TWasm.globaltype_new((-valtype).Move, mutability);
  result := TOwnGlobaltype.Wrap(p, globaltype_disposer); // ref ++
end;

function TWasmGlobaltype.Content() : PWasmValtype;
begin
  result := TWasm.globaltype_content(@self);
end;

function TWasmGlobaltype.Mutability() : TWasmMutability;
begin
  result := TWasm.globaltype_mutability(@self);
end;

function TWasmGlobaltype.AsExterntype() : PWasmExterntype;
begin
  result := TWasm.globaltype_as_externtype(@self);
end;

function TWasmGlobaltype.AsExterntypeConst() : PWasmExterntype;
begin
  result := TWasm.globaltype_as_externtype_const(@self);
end;

{ TOwnTabletypeVec }

class function TOwnTabletypeVec.Wrap(p: PWasmTabletypeVec; deleter : TRcDeleter): TOwnTabletypeVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmTabletypeVec>.Create(p, deleter);
end;

class function TOwnTabletypeVec.Wrap(p: PWasmTabletypeVec): TOwnTabletypeVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmTabletypeVec>.Create(p, tabletype_vec_disposer);
end;

class operator TOwnTabletypeVec.Finalize(var Dest: TOwnTabletypeVec);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnTabletypeVec.Implicit(const Src: IRcContainer<PWasmTabletypeVec>): TOwnTabletypeVec;
begin
  result.FStrongRef := Src;
end;

class operator TOwnTabletypeVec.Negative(Src: TOwnTabletypeVec): IRcContainer<PWasmTabletypeVec>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnTabletypeVec.Positive(Src: TOwnTabletypeVec): PWasmTabletypeVec;
begin
  result := Src.Unwrap;
end;

function TOwnTabletypeVec.Unwrap: PWasmTabletypeVec;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnTabletypeVec.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmTabletypeVec }

constructor TWasmTabletypeVec.Create(const arry: array of PWasmTabletype);
begin
  size := Length(arry);
  if size = 0 then data := nil
  else             data := @arry[0];
end;

class function TWasmTabletypeVec.New(const init: array of PWasmTabletype; elem_release : Boolean): TOwnTabletypeVec;
var
  prec : PWasmTabletypeVec;
begin
  System.New(prec);
  TWasm.tabletype_vec_new(prec, Length(init), @init[0]);
  if elem_release then
    result.FStrongRef := TRcContainer<PWasmTabletypeVec>.Create(prec, tabletype_vec_disposer_host)
  else
    result.FStrongRef := TRcContainer<PWasmTabletypeVec>.Create(prec, tabletype_vec_disposer_host_only);
end;

class function TWasmTabletypeVec.NewEmpty: TOwnTabletypeVec;
var
  prec : PWasmTabletypeVec;
begin
  System.New(prec);
  TWasm.tabletype_vec_new_empty(prec);
  result.FStrongRef := TRcContainer<PWasmTabletypeVec>.Create(prec, tabletype_vec_disposer_host);
end;

class function TWasmTabletypeVec.NewUninitialized(size: NativeInt): TOwnTabletypeVec;
var
  prec : PWasmTabletypeVec;
begin
  System.New(prec);
  TWasm.tabletype_vec_new_uninitialized(prec, size);
  result.FStrongRef := TRcContainer<PWasmTabletypeVec>.Create(prec, tabletype_vec_disposer_host);
end;

function TWasmTabletypeVec.Copy: TOwnTabletypeVec;
var
  prec : PWasmTabletypeVec;
begin
  System.New(prec);
  TWasm.tabletype_vec_copy(prec, @self);
  result.FStrongRef := TRcContainer<PWasmTabletypeVec>.Create(prec, tabletype_vec_disposer_host);
end;

procedure TWasmTabletypeVec.Assign(const Src :TOwnTabletypeVec);
begin
  TWasm.tabletype_vec_copy(@self, Src.Unwrap);
end;

{ TOwnTabletype }

class function TOwnTabletype.Wrap(p: PWasmTabletype; deleter : TRcDeleter): TOwnTabletype;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmTabletype>.Create(p, deleter);
end;

class function TOwnTabletype.Wrap(p: PWasmTabletype): TOwnTabletype;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmTabletype>.Create(p, tabletype_disposer);
end;

class operator TOwnTabletype.Finalize(var Dest: TOwnTabletype);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnTabletype.Implicit(const Src: IRcContainer<PWasmTabletype>): TOwnTabletype;
begin
  result.FStrongRef := Src;
end;

class operator TOwnTabletype.Negative(Src: TOwnTabletype): IRcContainer<PWasmTabletype>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnTabletype.Positive(Src: TOwnTabletype): PWasmTabletype;
begin
  result := Src.Unwrap;
end;

function TOwnTabletype.Unwrap: PWasmTabletype;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnTabletype.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmTabletype }

function TWasmTabletype.Copy: TOwnTabletype;
begin
  var p := TWasm.tabletype_copy(@self);
  result.FStrongRef := TRcContainer<PWasmTabletype>.Create(p, tabletype_disposer);
end;


class function TWasmTabletype.New(valtype : TOwnValtype;  const limits : PWasmLimits) : TOwnTabletype;
begin
  var p := TWasm.tabletype_new((-valtype).Move, limits);
  result := TOwnTabletype.Wrap(p, tabletype_disposer); // ref ++
end;

function TWasmTabletype.Element() : PWasmValtype;
begin
  result := TWasm.tabletype_element(@self);
end;

function TWasmTabletype.Limits() : PWasmLimits;
begin
  result := TWasm.tabletype_limits(@self);
end;

function TWasmTabletype.AsExterntype() : PWasmExterntype;
begin
  result := TWasm.tabletype_as_externtype(@self);
end;

function TWasmTabletype.AsExterntypeConst() : PWasmExterntype;
begin
  result := TWasm.tabletype_as_externtype_const(@self);
end;

{ TOwnMemorytypeVec }

class function TOwnMemorytypeVec.Wrap(p: PWasmMemorytypeVec; deleter : TRcDeleter): TOwnMemorytypeVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmMemorytypeVec>.Create(p, deleter);
end;

class function TOwnMemorytypeVec.Wrap(p: PWasmMemorytypeVec): TOwnMemorytypeVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmMemorytypeVec>.Create(p, memorytype_vec_disposer);
end;

class operator TOwnMemorytypeVec.Finalize(var Dest: TOwnMemorytypeVec);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnMemorytypeVec.Implicit(const Src: IRcContainer<PWasmMemorytypeVec>): TOwnMemorytypeVec;
begin
  result.FStrongRef := Src;
end;

class operator TOwnMemorytypeVec.Negative(Src: TOwnMemorytypeVec): IRcContainer<PWasmMemorytypeVec>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnMemorytypeVec.Positive(Src: TOwnMemorytypeVec): PWasmMemorytypeVec;
begin
  result := Src.Unwrap;
end;

function TOwnMemorytypeVec.Unwrap: PWasmMemorytypeVec;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnMemorytypeVec.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmMemorytypeVec }

constructor TWasmMemorytypeVec.Create(const arry: array of PWasmMemorytype);
begin
  size := Length(arry);
  if size = 0 then data := nil
  else             data := @arry[0];
end;

class function TWasmMemorytypeVec.New(const init: array of PWasmMemorytype; elem_release : Boolean): TOwnMemorytypeVec;
var
  prec : PWasmMemorytypeVec;
begin
  System.New(prec);
  TWasm.memorytype_vec_new(prec, Length(init), @init[0]);
  if elem_release then
    result.FStrongRef := TRcContainer<PWasmMemorytypeVec>.Create(prec, memorytype_vec_disposer_host)
  else
    result.FStrongRef := TRcContainer<PWasmMemorytypeVec>.Create(prec, memorytype_vec_disposer_host_only);
end;

class function TWasmMemorytypeVec.NewEmpty: TOwnMemorytypeVec;
var
  prec : PWasmMemorytypeVec;
begin
  System.New(prec);
  TWasm.memorytype_vec_new_empty(prec);
  result.FStrongRef := TRcContainer<PWasmMemorytypeVec>.Create(prec, memorytype_vec_disposer_host);
end;

class function TWasmMemorytypeVec.NewUninitialized(size: NativeInt): TOwnMemorytypeVec;
var
  prec : PWasmMemorytypeVec;
begin
  System.New(prec);
  TWasm.memorytype_vec_new_uninitialized(prec, size);
  result.FStrongRef := TRcContainer<PWasmMemorytypeVec>.Create(prec, memorytype_vec_disposer_host);
end;

function TWasmMemorytypeVec.Copy: TOwnMemorytypeVec;
var
  prec : PWasmMemorytypeVec;
begin
  System.New(prec);
  TWasm.memorytype_vec_copy(prec, @self);
  result.FStrongRef := TRcContainer<PWasmMemorytypeVec>.Create(prec, memorytype_vec_disposer_host);
end;

procedure TWasmMemorytypeVec.Assign(const Src :TOwnMemorytypeVec);
begin
  TWasm.memorytype_vec_copy(@self, Src.Unwrap);
end;

{ TOwnMemorytype }

class function TOwnMemorytype.Wrap(p: PWasmMemorytype; deleter : TRcDeleter): TOwnMemorytype;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmMemorytype>.Create(p, deleter);
end;

class function TOwnMemorytype.Wrap(p: PWasmMemorytype): TOwnMemorytype;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmMemorytype>.Create(p, memorytype_disposer);
end;

class operator TOwnMemorytype.Finalize(var Dest: TOwnMemorytype);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnMemorytype.Implicit(const Src: IRcContainer<PWasmMemorytype>): TOwnMemorytype;
begin
  result.FStrongRef := Src;
end;

class operator TOwnMemorytype.Negative(Src: TOwnMemorytype): IRcContainer<PWasmMemorytype>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnMemorytype.Positive(Src: TOwnMemorytype): PWasmMemorytype;
begin
  result := Src.Unwrap;
end;

function TOwnMemorytype.Unwrap: PWasmMemorytype;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnMemorytype.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmMemorytype }

function TWasmMemorytype.Copy: TOwnMemorytype;
begin
  var p := TWasm.memorytype_copy(@self);
  result.FStrongRef := TRcContainer<PWasmMemorytype>.Create(p, memorytype_disposer);
end;


class function TWasmMemorytype.New( const limits : PWasmLimits) : TOwnMemorytype;
begin
  var p := TWasm.memorytype_new(limits);
  result := TOwnMemorytype.Wrap(p, memorytype_disposer); // ref ++
end;

function TWasmMemorytype.Limits() : PWasmLimits;
begin
  result := TWasm.memorytype_limits(@self);
end;

function TWasmMemorytype.AsExterntype() : PWasmExterntype;
begin
  result := TWasm.memorytype_as_externtype(@self);
end;

function TWasmMemorytype.AsExterntypeConst() : PWasmExterntype;
begin
  result := TWasm.memorytype_as_externtype_const(@self);
end;

{ TOwnExterntypeVec }

class function TOwnExterntypeVec.Wrap(p: PWasmExterntypeVec; deleter : TRcDeleter): TOwnExterntypeVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmExterntypeVec>.Create(p, deleter);
end;

class function TOwnExterntypeVec.Wrap(p: PWasmExterntypeVec): TOwnExterntypeVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmExterntypeVec>.Create(p, externtype_vec_disposer);
end;

class operator TOwnExterntypeVec.Finalize(var Dest: TOwnExterntypeVec);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnExterntypeVec.Implicit(const Src: IRcContainer<PWasmExterntypeVec>): TOwnExterntypeVec;
begin
  result.FStrongRef := Src;
end;

class operator TOwnExterntypeVec.Negative(Src: TOwnExterntypeVec): IRcContainer<PWasmExterntypeVec>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnExterntypeVec.Positive(Src: TOwnExterntypeVec): PWasmExterntypeVec;
begin
  result := Src.Unwrap;
end;

function TOwnExterntypeVec.Unwrap: PWasmExterntypeVec;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnExterntypeVec.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmExterntypeVec }

constructor TWasmExterntypeVec.Create(const arry: array of PWasmExterntype);
begin
  size := Length(arry);
  if size = 0 then data := nil
  else             data := @arry[0];
end;

class function TWasmExterntypeVec.New(const init: array of PWasmExterntype; elem_release : Boolean): TOwnExterntypeVec;
var
  prec : PWasmExterntypeVec;
begin
  System.New(prec);
  TWasm.externtype_vec_new(prec, Length(init), @init[0]);
  if elem_release then
    result.FStrongRef := TRcContainer<PWasmExterntypeVec>.Create(prec, externtype_vec_disposer_host)
  else
    result.FStrongRef := TRcContainer<PWasmExterntypeVec>.Create(prec, externtype_vec_disposer_host_only);
end;

class function TWasmExterntypeVec.NewEmpty: TOwnExterntypeVec;
var
  prec : PWasmExterntypeVec;
begin
  System.New(prec);
  TWasm.externtype_vec_new_empty(prec);
  result.FStrongRef := TRcContainer<PWasmExterntypeVec>.Create(prec, externtype_vec_disposer_host);
end;

class function TWasmExterntypeVec.NewUninitialized(size: NativeInt): TOwnExterntypeVec;
var
  prec : PWasmExterntypeVec;
begin
  System.New(prec);
  TWasm.externtype_vec_new_uninitialized(prec, size);
  result.FStrongRef := TRcContainer<PWasmExterntypeVec>.Create(prec, externtype_vec_disposer_host);
end;

function TWasmExterntypeVec.Copy: TOwnExterntypeVec;
var
  prec : PWasmExterntypeVec;
begin
  System.New(prec);
  TWasm.externtype_vec_copy(prec, @self);
  result.FStrongRef := TRcContainer<PWasmExterntypeVec>.Create(prec, externtype_vec_disposer_host);
end;

procedure TWasmExterntypeVec.Assign(const Src :TOwnExterntypeVec);
begin
  TWasm.externtype_vec_copy(@self, Src.Unwrap);
end;

{ TOwnExterntype }

class function TOwnExterntype.Wrap(p: PWasmExterntype; deleter : TRcDeleter): TOwnExterntype;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmExterntype>.Create(p, deleter);
end;

class function TOwnExterntype.Wrap(p: PWasmExterntype): TOwnExterntype;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmExterntype>.Create(p, externtype_disposer);
end;

class operator TOwnExterntype.Finalize(var Dest: TOwnExterntype);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnExterntype.Implicit(const Src: IRcContainer<PWasmExterntype>): TOwnExterntype;
begin
  result.FStrongRef := Src;
end;

class operator TOwnExterntype.Negative(Src: TOwnExterntype): IRcContainer<PWasmExterntype>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnExterntype.Positive(Src: TOwnExterntype): PWasmExterntype;
begin
  result := Src.Unwrap;
end;

function TOwnExterntype.Unwrap: PWasmExterntype;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnExterntype.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmExterntype }

function TWasmExterntype.Copy: TOwnExterntype;
begin
  var p := TWasm.externtype_copy(@self);
  result.FStrongRef := TRcContainer<PWasmExterntype>.Create(p, externtype_disposer);
end;


function TWasmExterntype.Kind() : TWasmExternkind;
begin
  result := TWasm.externtype_kind(@self);
end;

function TWasmExterntype.AsFunctype() : PWasmFunctype;
begin
  result := TWasm.externtype_as_functype(@self);
end;

function TWasmExterntype.AsGlobaltype() : PWasmGlobaltype;
begin
  result := TWasm.externtype_as_globaltype(@self);
end;

function TWasmExterntype.AsTabletype() : PWasmTabletype;
begin
  result := TWasm.externtype_as_tabletype(@self);
end;

function TWasmExterntype.AsMemorytype() : PWasmMemorytype;
begin
  result := TWasm.externtype_as_memorytype(@self);
end;

function TWasmExterntype.AsFunctypeConst() : PWasmFunctype;
begin
  result := TWasm.externtype_as_functype_const(@self);
end;

function TWasmExterntype.AsGlobaltypeConst() : PWasmGlobaltype;
begin
  result := TWasm.externtype_as_globaltype_const(@self);
end;

function TWasmExterntype.AsTabletypeConst() : PWasmTabletype;
begin
  result := TWasm.externtype_as_tabletype_const(@self);
end;

function TWasmExterntype.AsMemorytypeConst() : PWasmMemorytype;
begin
  result := TWasm.externtype_as_memorytype_const(@self);
end;

{ TOwnImporttypeVec }

class function TOwnImporttypeVec.Wrap(p: PWasmImporttypeVec; deleter : TRcDeleter): TOwnImporttypeVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmImporttypeVec>.Create(p, deleter);
end;

class function TOwnImporttypeVec.Wrap(p: PWasmImporttypeVec): TOwnImporttypeVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmImporttypeVec>.Create(p, importtype_vec_disposer);
end;

class operator TOwnImporttypeVec.Finalize(var Dest: TOwnImporttypeVec);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnImporttypeVec.Implicit(const Src: IRcContainer<PWasmImporttypeVec>): TOwnImporttypeVec;
begin
  result.FStrongRef := Src;
end;

class operator TOwnImporttypeVec.Negative(Src: TOwnImporttypeVec): IRcContainer<PWasmImporttypeVec>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnImporttypeVec.Positive(Src: TOwnImporttypeVec): PWasmImporttypeVec;
begin
  result := Src.Unwrap;
end;

function TOwnImporttypeVec.Unwrap: PWasmImporttypeVec;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnImporttypeVec.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmImporttypeVec }

constructor TWasmImporttypeVec.Create(const arry: array of PWasmImporttype);
begin
  size := Length(arry);
  if size = 0 then data := nil
  else             data := @arry[0];
end;

class function TWasmImporttypeVec.New(const init: array of PWasmImporttype; elem_release : Boolean): TOwnImporttypeVec;
var
  prec : PWasmImporttypeVec;
begin
  System.New(prec);
  TWasm.importtype_vec_new(prec, Length(init), @init[0]);
  if elem_release then
    result.FStrongRef := TRcContainer<PWasmImporttypeVec>.Create(prec, importtype_vec_disposer_host)
  else
    result.FStrongRef := TRcContainer<PWasmImporttypeVec>.Create(prec, importtype_vec_disposer_host_only);
end;

class function TWasmImporttypeVec.NewEmpty: TOwnImporttypeVec;
var
  prec : PWasmImporttypeVec;
begin
  System.New(prec);
  TWasm.importtype_vec_new_empty(prec);
  result.FStrongRef := TRcContainer<PWasmImporttypeVec>.Create(prec, importtype_vec_disposer_host);
end;

class function TWasmImporttypeVec.NewUninitialized(size: NativeInt): TOwnImporttypeVec;
var
  prec : PWasmImporttypeVec;
begin
  System.New(prec);
  TWasm.importtype_vec_new_uninitialized(prec, size);
  result.FStrongRef := TRcContainer<PWasmImporttypeVec>.Create(prec, importtype_vec_disposer_host);
end;

function TWasmImporttypeVec.Copy: TOwnImporttypeVec;
var
  prec : PWasmImporttypeVec;
begin
  System.New(prec);
  TWasm.importtype_vec_copy(prec, @self);
  result.FStrongRef := TRcContainer<PWasmImporttypeVec>.Create(prec, importtype_vec_disposer_host);
end;

procedure TWasmImporttypeVec.Assign(const Src :TOwnImporttypeVec);
begin
  TWasm.importtype_vec_copy(@self, Src.Unwrap);
end;

{ TOwnImporttype }

class function TOwnImporttype.Wrap(p: PWasmImporttype; deleter : TRcDeleter): TOwnImporttype;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmImporttype>.Create(p, deleter);
end;

class function TOwnImporttype.Wrap(p: PWasmImporttype): TOwnImporttype;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmImporttype>.Create(p, importtype_disposer);
end;

class operator TOwnImporttype.Finalize(var Dest: TOwnImporttype);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnImporttype.Implicit(const Src: IRcContainer<PWasmImporttype>): TOwnImporttype;
begin
  result.FStrongRef := Src;
end;

class operator TOwnImporttype.Negative(Src: TOwnImporttype): IRcContainer<PWasmImporttype>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnImporttype.Positive(Src: TOwnImporttype): PWasmImporttype;
begin
  result := Src.Unwrap;
end;

function TOwnImporttype.Unwrap: PWasmImporttype;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnImporttype.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmImporttype }

function TWasmImporttype.Copy: TOwnImporttype;
begin
  var p := TWasm.importtype_copy(@self);
  result.FStrongRef := TRcContainer<PWasmImporttype>.Create(p, importtype_disposer);
end;


class function TWasmImporttype.New(module : string; name : string; externtype : TOwnExterntype) : TOwnImporttype;
begin
  var p := TWasm.importtype_new(PWasmName((-TWasmName.NewFromString(module)).Move), PWasmName((-TWasmName.NewFromString(name)).Move), (-externtype).Move);
  result := TOwnImporttype.Wrap(p, importtype_disposer); // ref ++
end;

function TWasmImporttype.Module() : string;
begin
  var p := TWasm.importtype_module(@self);
  result := p.AsString;
end;

function TWasmImporttype.Name() : string;
begin
  var p := TWasm.importtype_name(@self);
  result := p.AsString;
end;

function TWasmImporttype.GetType() : PWasmExterntype;
begin
  result := TWasm.importtype_type(@self);
end;

{ TOwnExporttypeVec }

class function TOwnExporttypeVec.Wrap(p: PWasmExporttypeVec; deleter : TRcDeleter): TOwnExporttypeVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmExporttypeVec>.Create(p, deleter);
end;

class function TOwnExporttypeVec.Wrap(p: PWasmExporttypeVec): TOwnExporttypeVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmExporttypeVec>.Create(p, exporttype_vec_disposer);
end;

class operator TOwnExporttypeVec.Finalize(var Dest: TOwnExporttypeVec);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnExporttypeVec.Implicit(const Src: IRcContainer<PWasmExporttypeVec>): TOwnExporttypeVec;
begin
  result.FStrongRef := Src;
end;

class operator TOwnExporttypeVec.Negative(Src: TOwnExporttypeVec): IRcContainer<PWasmExporttypeVec>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnExporttypeVec.Positive(Src: TOwnExporttypeVec): PWasmExporttypeVec;
begin
  result := Src.Unwrap;
end;

function TOwnExporttypeVec.Unwrap: PWasmExporttypeVec;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnExporttypeVec.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmExporttypeVec }

constructor TWasmExporttypeVec.Create(const arry: array of PWasmExporttype);
begin
  size := Length(arry);
  if size = 0 then data := nil
  else             data := @arry[0];
end;

class function TWasmExporttypeVec.New(const init: array of PWasmExporttype; elem_release : Boolean): TOwnExporttypeVec;
var
  prec : PWasmExporttypeVec;
begin
  System.New(prec);
  TWasm.exporttype_vec_new(prec, Length(init), @init[0]);
  if elem_release then
    result.FStrongRef := TRcContainer<PWasmExporttypeVec>.Create(prec, exporttype_vec_disposer_host)
  else
    result.FStrongRef := TRcContainer<PWasmExporttypeVec>.Create(prec, exporttype_vec_disposer_host_only);
end;

class function TWasmExporttypeVec.NewEmpty: TOwnExporttypeVec;
var
  prec : PWasmExporttypeVec;
begin
  System.New(prec);
  TWasm.exporttype_vec_new_empty(prec);
  result.FStrongRef := TRcContainer<PWasmExporttypeVec>.Create(prec, exporttype_vec_disposer_host);
end;

class function TWasmExporttypeVec.NewUninitialized(size: NativeInt): TOwnExporttypeVec;
var
  prec : PWasmExporttypeVec;
begin
  System.New(prec);
  TWasm.exporttype_vec_new_uninitialized(prec, size);
  result.FStrongRef := TRcContainer<PWasmExporttypeVec>.Create(prec, exporttype_vec_disposer_host);
end;

function TWasmExporttypeVec.Copy: TOwnExporttypeVec;
var
  prec : PWasmExporttypeVec;
begin
  System.New(prec);
  TWasm.exporttype_vec_copy(prec, @self);
  result.FStrongRef := TRcContainer<PWasmExporttypeVec>.Create(prec, exporttype_vec_disposer_host);
end;

procedure TWasmExporttypeVec.Assign(const Src :TOwnExporttypeVec);
begin
  TWasm.exporttype_vec_copy(@self, Src.Unwrap);
end;

{ TOwnExporttype }

class function TOwnExporttype.Wrap(p: PWasmExporttype; deleter : TRcDeleter): TOwnExporttype;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmExporttype>.Create(p, deleter);
end;

class function TOwnExporttype.Wrap(p: PWasmExporttype): TOwnExporttype;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmExporttype>.Create(p, exporttype_disposer);
end;

class operator TOwnExporttype.Finalize(var Dest: TOwnExporttype);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnExporttype.Implicit(const Src: IRcContainer<PWasmExporttype>): TOwnExporttype;
begin
  result.FStrongRef := Src;
end;

class operator TOwnExporttype.Negative(Src: TOwnExporttype): IRcContainer<PWasmExporttype>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnExporttype.Positive(Src: TOwnExporttype): PWasmExporttype;
begin
  result := Src.Unwrap;
end;

function TOwnExporttype.Unwrap: PWasmExporttype;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnExporttype.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmExporttype }

function TWasmExporttype.Copy: TOwnExporttype;
begin
  var p := TWasm.exporttype_copy(@self);
  result.FStrongRef := TRcContainer<PWasmExporttype>.Create(p, exporttype_disposer);
end;


class function TWasmExporttype.New(name : string; externtype : TOwnExterntype) : TOwnExporttype;
begin
  var p := TWasm.exporttype_new(PWasmName((-TWasmName.NewFromString(name)).Move), (-externtype).Move);
  result := TOwnExporttype.Wrap(p, exporttype_disposer); // ref ++
end;

function TWasmExporttype.Name() : string;
begin
  var p := TWasm.exporttype_name(@self);
  result := p.AsString;
end;

function TWasmExporttype.GetType() : PWasmExterntype;
begin
  result := TWasm.exporttype_type(@self);
end;

{ TOwnVal }

class function TOwnVal.Wrap(p: PWasmVal; deleter : TRcDeleter): TOwnVal;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmVal>.Create(p, deleter);
end;

class function TOwnVal.Wrap(p: PWasmVal): TOwnVal;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmVal>.Create(p, val_disposer);
end;

class operator TOwnVal.Finalize(var Dest: TOwnVal);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnVal.Implicit(const Src: IRcContainer<PWasmVal>): TOwnVal;
begin
  result.FStrongRef := Src;
end;

class operator TOwnVal.Negative(Src: TOwnVal): IRcContainer<PWasmVal>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnVal.Positive(Src: TOwnVal): PWasmVal;
begin
  result := Src.Unwrap;
end;

function TOwnVal.Unwrap: PWasmVal;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnVal.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmVal }

constructor TWasmVal.Create(val : Integer);
begin
  kind := WASM_I32;
  i32 := val;
end;

constructor TWasmVal.Create(val : Int64);
begin
  kind := WASM_I64;
  i64 := val;
end;

constructor TWasmVal.Create(val : Single);
begin
  kind := WASM_F32;
  f32 := val;
end;

constructor TWasmVal.Create(val : Double);
begin
  kind := WASM_F64;
  f64 := val;
end;

constructor TWasmVal.Create(val : PWasmRef);
begin
  kind := WASM_ANYREF;
  ref := val;
end;

class operator TWasmVal.Implicit (val : Integer) : TWasmVal;
begin
  result.kind := WASM_I32;
  result.i32 := val;
end;

class operator TWasmVal.Implicit (val : Int64) : TWasmVal;
begin
  result.kind := WASM_I64;
  result.i64 := val;
end;

class operator TWasmVal.Implicit (val : Single) : TWasmVal;
begin
  result.kind := WASM_F32;
  result.f32 := val;
end;

class operator TWasmVal.Implicit (val : Double) : TWasmVal;
begin
  result.kind := WASM_F64;
  result.f64 := val;
end;

class operator TWasmVal.Implicit (val : PWasmRef) : TWasmVal;
begin
  result.kind := WASM_ANYREF;
  result.ref := val;
end;

function WASM_I32_VAL(val : Integer) : TWasmVal;
begin
  result.kind := WASM_I32;
  result.i32 := val;
end;

function WASM_I64_VAL(val : Int64) : TWasmVal;
begin
  result.kind := WASM_I64;
  result.i64 := val;
end;

function WASM_F32_VAL(val : Single) : TWasmVal;
begin
  result.kind := WASM_F32;
  result.f32 := val;
end;

function WASM_F64_VAL(val : Double) : TWasmVal;
begin
  result.kind := WASM_F64;
  result.f64 := val;
end;

function WASM_REF_VAL(val : PWasmRef) : TWasmVal;
begin
  result.kind := WASM_ANYREF;
  result.ref := val;
end;

function WASM_INIT_VAL() : TWasmVal;
begin
  result.kind := WASM_ANYREF;
  result.ref := nil;
end;

{ TOwnValVec }

class function TOwnValVec.Wrap(p: PWasmValVec; deleter : TRcDeleter): TOwnValVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmValVec>.Create(p, deleter);
end;

class function TOwnValVec.Wrap(p: PWasmValVec): TOwnValVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmValVec>.Create(p, val_vec_disposer);
end;

class operator TOwnValVec.Finalize(var Dest: TOwnValVec);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnValVec.Implicit(const Src: IRcContainer<PWasmValVec>): TOwnValVec;
begin
  result.FStrongRef := Src;
end;

class operator TOwnValVec.Negative(Src: TOwnValVec): IRcContainer<PWasmValVec>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnValVec.Positive(Src: TOwnValVec): PWasmValVec;
begin
  result := Src.Unwrap;
end;

function TOwnValVec.Unwrap: PWasmValVec;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnValVec.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmValVec }

constructor TWasmValVec.Create(const arry: array of TWasmVal);
begin
  size := Length(arry);
  if size = 0 then data := nil
  else             data := @arry[0];
end;

class function TWasmValVec.New(const init: array of TWasmVal): TOwnValVec;
var
  prec : PWasmValVec;
begin
  System.New(prec);
  TWasm.val_vec_new(prec, Length(init), @init[0]);
  result.FStrongRef := TRcContainer<PWasmValVec>.Create(prec, val_vec_disposer_host);
end;

class function TWasmValVec.NewEmpty: TOwnValVec;
var
  prec : PWasmValVec;
begin
  System.New(prec);
  TWasm.val_vec_new_empty(prec);
  result.FStrongRef := TRcContainer<PWasmValVec>.Create(prec, val_vec_disposer_host);
end;

class function TWasmValVec.NewUninitialized(size: NativeInt): TOwnValVec;
var
  prec : PWasmValVec;
begin
  System.New(prec);
  TWasm.val_vec_new_uninitialized(prec, size);
  result.FStrongRef := TRcContainer<PWasmValVec>.Create(prec, val_vec_disposer_host);
end;

function TWasmValVec.Copy: TOwnValVec;
var
  prec : PWasmValVec;
begin
  System.New(prec);
  TWasm.val_vec_copy(prec, @self);
  result.FStrongRef := TRcContainer<PWasmValVec>.Create(prec, val_vec_disposer_host);
end;

procedure TWasmValVec.Assign(const Src :TOwnValVec);
begin
  TWasm.val_vec_copy(@self, Src.Unwrap);
end;

{ TOwnRef }

class function TOwnRef.Wrap(p: PWasmRef; deleter : TRcDeleter): TOwnRef;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmRef>.Create(p, deleter);
end;

class function TOwnRef.Wrap(p: PWasmRef): TOwnRef;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmRef>.Create(p, ref_disposer);
end;

class operator TOwnRef.Finalize(var Dest: TOwnRef);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnRef.Implicit(const Src: IRcContainer<PWasmRef>): TOwnRef;
begin
  result.FStrongRef := Src;
end;

class operator TOwnRef.Negative(Src: TOwnRef): IRcContainer<PWasmRef>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnRef.Positive(Src: TOwnRef): PWasmRef;
begin
  result := Src.Unwrap;
end;

function TOwnRef.Unwrap: PWasmRef;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnRef.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmRef }

function TWasmRef.Copy: TOwnRef;
begin
  var p := TWasm.ref_copy(@self);
  result.FStrongRef := TRcContainer<PWasmRef>.Create(p, ref_disposer);
end;

function TWasmRef.GetHostInfo: Pointer;
begin
  result := TWasm.ref_get_host_info(@self);
end;

function TWasmRef.Same(const p: PWasmRef): Boolean;
begin
  result := TWasm.ref_same(@self, p);
end;

procedure TWasmRef.SetHostInfo(info: Pointer);
begin
  TWasm.ref_set_host_info(@self, info);
end;

procedure TWasmRef.SetHostInfoWithFinalizer(info: Pointer; finalizer: TWasmFinalizer);
begin
  TWasm.ref_set_host_info_with_finalizer(@self, info, finalizer);
end;

function TWasmRef.AsTrap() : PWasmTrap;
begin
  result := TWasm.ref_as_trap(@self);
end;

function TWasmRef.AsTrapConst() : PWasmTrap;
begin
  result := TWasm.ref_as_trap_const(@self);
end;

function TWasmRef.AsForeign() : PWasmForeign;
begin
  result := TWasm.ref_as_foreign(@self);
end;

function TWasmRef.AsForeignConst() : PWasmForeign;
begin
  result := TWasm.ref_as_foreign_const(@self);
end;

function TWasmRef.AsModule() : PWasmModule;
begin
  result := TWasm.ref_as_module(@self);
end;

function TWasmRef.AsModuleConst() : PWasmModule;
begin
  result := TWasm.ref_as_module_const(@self);
end;

function TWasmRef.AsFunc() : PWasmFunc;
begin
  result := TWasm.ref_as_func(@self);
end;

function TWasmRef.AsFuncConst() : PWasmFunc;
begin
  result := TWasm.ref_as_func_const(@self);
end;

function TWasmRef.AsGlobal() : PWasmGlobal;
begin
  result := TWasm.ref_as_global(@self);
end;

function TWasmRef.AsGlobalConst() : PWasmGlobal;
begin
  result := TWasm.ref_as_global_const(@self);
end;

function TWasmRef.AsTable() : PWasmTable;
begin
  result := TWasm.ref_as_table(@self);
end;

function TWasmRef.AsTableConst() : PWasmTable;
begin
  result := TWasm.ref_as_table_const(@self);
end;

function TWasmRef.AsMemory() : PWasmMemory;
begin
  result := TWasm.ref_as_memory(@self);
end;

function TWasmRef.AsMemoryConst() : PWasmMemory;
begin
  result := TWasm.ref_as_memory_const(@self);
end;

function TWasmRef.AsExtern() : PWasmExtern;
begin
  result := TWasm.ref_as_extern(@self);
end;

function TWasmRef.AsExternConst() : PWasmExtern;
begin
  result := TWasm.ref_as_extern_const(@self);
end;

function TWasmRef.AsInstance() : PWasmInstance;
begin
  result := TWasm.ref_as_instance(@self);
end;

function TWasmRef.AsInstanceConst() : PWasmInstance;
begin
  result := TWasm.ref_as_instance_const(@self);
end;

{ TOwnFrame }

class function TOwnFrame.Wrap(p: PWasmFrame; deleter : TRcDeleter): TOwnFrame;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmFrame>.Create(p, deleter);
end;

class function TOwnFrame.Wrap(p: PWasmFrame): TOwnFrame;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmFrame>.Create(p, frame_disposer);
end;

class operator TOwnFrame.Finalize(var Dest: TOwnFrame);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnFrame.Implicit(const Src: IRcContainer<PWasmFrame>): TOwnFrame;
begin
  result.FStrongRef := Src;
end;

class operator TOwnFrame.Negative(Src: TOwnFrame): IRcContainer<PWasmFrame>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnFrame.Positive(Src: TOwnFrame): PWasmFrame;
begin
  result := Src.Unwrap;
end;

function TOwnFrame.Unwrap: PWasmFrame;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnFrame.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmFrame }


function TWasmFrame.Copy() : TOwnFrame;
begin
  var p := TWasm.frame_copy(@self);
  result := TOwnFrame.Wrap(p, frame_disposer); // ref ++
end;

function TWasmFrame.Instance() : PWasmInstance;
begin
  result := TWasm.frame_instance(@self);
end;

function TWasmFrame.FuncIndex() : Cardinal;
begin
  result := TWasm.frame_func_index(@self);
end;

function TWasmFrame.FuncOffset() : NativeInt;
begin
  result := TWasm.frame_func_offset(@self);
end;

function TWasmFrame.ModuleOffset() : NativeInt;
begin
  result := TWasm.frame_module_offset(@self);
end;

{ TOwnFrameVec }

class function TOwnFrameVec.Wrap(p: PWasmFrameVec; deleter : TRcDeleter): TOwnFrameVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmFrameVec>.Create(p, deleter);
end;

class function TOwnFrameVec.Wrap(p: PWasmFrameVec): TOwnFrameVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmFrameVec>.Create(p, frame_vec_disposer);
end;

class operator TOwnFrameVec.Finalize(var Dest: TOwnFrameVec);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnFrameVec.Implicit(const Src: IRcContainer<PWasmFrameVec>): TOwnFrameVec;
begin
  result.FStrongRef := Src;
end;

class operator TOwnFrameVec.Negative(Src: TOwnFrameVec): IRcContainer<PWasmFrameVec>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnFrameVec.Positive(Src: TOwnFrameVec): PWasmFrameVec;
begin
  result := Src.Unwrap;
end;

function TOwnFrameVec.Unwrap: PWasmFrameVec;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnFrameVec.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmFrameVec }

constructor TWasmFrameVec.Create(const arry: array of PWasmFrame);
begin
  size := Length(arry);
  if size = 0 then data := nil
  else             data := @arry[0];
end;

class function TWasmFrameVec.New(const init: array of PWasmFrame; elem_release : Boolean): TOwnFrameVec;
var
  prec : PWasmFrameVec;
begin
  System.New(prec);
  TWasm.frame_vec_new(prec, Length(init), @init[0]);
  if elem_release then
    result.FStrongRef := TRcContainer<PWasmFrameVec>.Create(prec, frame_vec_disposer_host)
  else
    result.FStrongRef := TRcContainer<PWasmFrameVec>.Create(prec, frame_vec_disposer_host_only);
end;

class function TWasmFrameVec.NewEmpty: TOwnFrameVec;
var
  prec : PWasmFrameVec;
begin
  System.New(prec);
  TWasm.frame_vec_new_empty(prec);
  result.FStrongRef := TRcContainer<PWasmFrameVec>.Create(prec, frame_vec_disposer_host);
end;

class function TWasmFrameVec.NewUninitialized(size: NativeInt): TOwnFrameVec;
var
  prec : PWasmFrameVec;
begin
  System.New(prec);
  TWasm.frame_vec_new_uninitialized(prec, size);
  result.FStrongRef := TRcContainer<PWasmFrameVec>.Create(prec, frame_vec_disposer_host);
end;

function TWasmFrameVec.Copy: TOwnFrameVec;
var
  prec : PWasmFrameVec;
begin
  System.New(prec);
  TWasm.frame_vec_copy(prec, @self);
  result.FStrongRef := TRcContainer<PWasmFrameVec>.Create(prec, frame_vec_disposer_host);
end;

procedure TWasmFrameVec.Assign(const Src :TOwnFrameVec);
begin
  TWasm.frame_vec_copy(@self, Src.Unwrap);
end;

{ TOwnTrap }

class function TOwnTrap.Wrap(p: PWasmTrap; deleter : TRcDeleter): TOwnTrap;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmTrap>.Create(p, deleter);
end;

class function TOwnTrap.Wrap(p: PWasmTrap): TOwnTrap;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmTrap>.Create(p, trap_disposer);
end;

class operator TOwnTrap.Finalize(var Dest: TOwnTrap);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnTrap.Implicit(const Src: IRcContainer<PWasmTrap>): TOwnTrap;
begin
  result.FStrongRef := Src;
end;

class operator TOwnTrap.Negative(Src: TOwnTrap): IRcContainer<PWasmTrap>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnTrap.Positive(Src: TOwnTrap): PWasmTrap;
begin
  result := Src.Unwrap;
end;

function TOwnTrap.Unwrap: PWasmTrap;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnTrap.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;

function TOwnTrap.IsError() : Boolean;
begin
  result := FStrongRef <> nil;
end;

function TOwnTrap.IsError(proc : TWasmUnwrapProc<PWasmTrap>) : Boolean;
begin
  result := FStrongRef <> nil;
  if result then proc(Unwrap);
end;


{ TWasmTrap }

function TWasmTrap.Copy: TOwnTrap;
begin
  var p := TWasm.trap_copy(@self);
  result.FStrongRef := TRcContainer<PWasmTrap>.Create(p, trap_disposer);
end;

function TWasmTrap.GetHostInfo: Pointer;
begin
  result := TWasm.trap_get_host_info(@self);
end;

function TWasmTrap.Same(const p: PWasmTrap): Boolean;
begin
  result := TWasm.trap_same(@self, p);
end;

procedure TWasmTrap.SetHostInfo(info: Pointer);
begin
  TWasm.trap_set_host_info(@self, info);
end;

procedure TWasmTrap.SetHostInfoWithFinalizer(info: Pointer; finalizer: TWasmFinalizer);
begin
  TWasm.trap_set_host_info_with_finalizer(@self, info, finalizer);
end;

function TWasmTrap.AsRef: PWasmRef;
begin
  result := TWasm.trap_as_ref(@self);
end;

function TWasmTrap.AsRefConst: PWasmRef;
begin
  result := TWasm.trap_as_ref_const(@self);
end;

class function TWasmTrap.New(store : PWasmStore;  const message : PWasmMessage) : TOwnTrap;
begin
  var p := TWasm.trap_new(store, message);
  result := TOwnTrap.Wrap(p, trap_disposer); // ref ++
end;

function TWasmTrap.GetMessage() : string;
begin
  var vec : TWasmByteVec;
  var out_ := @vec;
  TWasm.trap_message(@self, out_);
  try
    result := vec.AsString();
  finally
    TWasm.byte_vec_delete(out_);
  end;
end;

function TWasmTrap.Origin() : TOwnFrame;
begin
  var p := TWasm.trap_origin(@self);
  result := TOwnFrame.Wrap(p, frame_disposer); // ref ++
end;

function TWasmTrap.Trace() : TOwnFrameVec;
begin
  var out_ : PWasmFrameVec;
  System.New(out_);
  TWasm.trap_trace(@self, out_);
  result := TOwnFrameVec.Wrap(out_, frame_vec_disposer_host); // ref ++
end;

{ TOwnForeign }

class function TOwnForeign.Wrap(p: PWasmForeign; deleter : TRcDeleter): TOwnForeign;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmForeign>.Create(p, deleter);
end;

class function TOwnForeign.Wrap(p: PWasmForeign): TOwnForeign;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmForeign>.Create(p, foreign_disposer);
end;

class operator TOwnForeign.Finalize(var Dest: TOwnForeign);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnForeign.Implicit(const Src: IRcContainer<PWasmForeign>): TOwnForeign;
begin
  result.FStrongRef := Src;
end;

class operator TOwnForeign.Negative(Src: TOwnForeign): IRcContainer<PWasmForeign>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnForeign.Positive(Src: TOwnForeign): PWasmForeign;
begin
  result := Src.Unwrap;
end;

function TOwnForeign.Unwrap: PWasmForeign;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnForeign.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmForeign }

function TWasmForeign.Copy: TOwnForeign;
begin
  var p := TWasm.foreign_copy(@self);
  result.FStrongRef := TRcContainer<PWasmForeign>.Create(p, foreign_disposer);
end;

function TWasmForeign.GetHostInfo: Pointer;
begin
  result := TWasm.foreign_get_host_info(@self);
end;

function TWasmForeign.Same(const p: PWasmForeign): Boolean;
begin
  result := TWasm.foreign_same(@self, p);
end;

procedure TWasmForeign.SetHostInfo(info: Pointer);
begin
  TWasm.foreign_set_host_info(@self, info);
end;

procedure TWasmForeign.SetHostInfoWithFinalizer(info: Pointer; finalizer: TWasmFinalizer);
begin
  TWasm.foreign_set_host_info_with_finalizer(@self, info, finalizer);
end;

function TWasmForeign.AsRef: PWasmRef;
begin
  result := TWasm.foreign_as_ref(@self);
end;

function TWasmForeign.AsRefConst: PWasmRef;
begin
  result := TWasm.foreign_as_ref_const(@self);
end;

class function TWasmForeign.New(store : PWasmStore) : TOwnForeign;
begin
  var p := TWasm.foreign_new(store);
  result := TOwnForeign.Wrap(p, foreign_disposer); // ref ++
end;

{ TOwnModule }

class function TOwnModule.Wrap(p: PWasmModule; deleter : TRcDeleter): TOwnModule;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmModule>.Create(p, deleter);
end;

class function TOwnModule.Wrap(p: PWasmModule): TOwnModule;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmModule>.Create(p, module_disposer);
end;

class operator TOwnModule.Finalize(var Dest: TOwnModule);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnModule.Implicit(const Src: IRcContainer<PWasmModule>): TOwnModule;
begin
  result.FStrongRef := Src;
end;

class operator TOwnModule.Negative(Src: TOwnModule): IRcContainer<PWasmModule>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnModule.Positive(Src: TOwnModule): PWasmModule;
begin
  result := Src.Unwrap;
end;

function TOwnModule.Unwrap: PWasmModule;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnModule.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmModule }

function TWasmModule.Copy: TOwnModule;
begin
  var p := TWasm.module_copy(@self);
  result.FStrongRef := TRcContainer<PWasmModule>.Create(p, module_disposer);
end;

function TWasmModule.GetHostInfo: Pointer;
begin
  result := TWasm.module_get_host_info(@self);
end;

function TWasmModule.Same(const p: PWasmModule): Boolean;
begin
  result := TWasm.module_same(@self, p);
end;

procedure TWasmModule.SetHostInfo(info: Pointer);
begin
  TWasm.module_set_host_info(@self, info);
end;

procedure TWasmModule.SetHostInfoWithFinalizer(info: Pointer; finalizer: TWasmFinalizer);
begin
  TWasm.module_set_host_info_with_finalizer(@self, info, finalizer);
end;

function TWasmModule.AsRef: PWasmRef;
begin
  result := TWasm.module_as_ref(@self);
end;

function TWasmModule.AsRefConst: PWasmRef;
begin
  result := TWasm.module_as_ref_const(@self);
end;
function TWasmModule.Share() : TOwnSharedModule;
begin
  var p := TWasm.module_share(@self);
  result := TOwnSharedModule.Wrap(p, shared_module_disposer);
end;

class function TWasmModule.New(store : PWasmStore;  const binary : PWasmByteVec) : TOwnModule;
begin
  var p := TWasm.module_new(store, binary);
  result := TOwnModule.Wrap(p, module_disposer); // ref ++
end;

function TWasmModule.Validate(store : PWasmStore;  const binary : PWasmByteVec) : Boolean;
begin
  result := TWasm.module_validate(store, binary);
end;

function TWasmModule.Imports() : TOwnImporttypeVec;
begin
  var out_ : PWasmImporttypeVec;
  System.New(out_);
  TWasm.module_imports(@self, out_);
  result := TOwnImporttypeVec.Wrap(out_, importtype_vec_disposer_host); // ref ++
end;

function TWasmModule.GetExports() : TOwnExporttypeVec;
begin
  var out_ : PWasmExporttypeVec;
  System.New(out_);
  TWasm.module_exports(@self, out_);
  result := TOwnExporttypeVec.Wrap(out_, exporttype_vec_disposer_host); // ref ++
end;

function TWasmModule.Serialize() : TOwnByteVec;
begin
  var out_ : PWasmByteVec;
  System.New(out_);
  TWasm.module_serialize(@self, out_);
  result := TOwnByteVec.Wrap(out_, byte_vec_disposer_host); // ref ++
end;

class function TWasmModule.Deserialize(store : PWasmStore;  const byte_vec : PWasmByteVec) : TOwnModule;
begin
  var p := TWasm.module_deserialize(store, byte_vec);
  result := TOwnModule.Wrap(p, module_disposer); // ref ++
end;

{ TOwnSharedModule }

class function TOwnSharedModule.Wrap(p: PWasmSharedModule; deleter : TRcDeleter): TOwnSharedModule;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmSharedModule>.Create(p, deleter);
end;

class function TOwnSharedModule.Wrap(p: PWasmSharedModule): TOwnSharedModule;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmSharedModule>.Create(p, shared_module_disposer);
end;

class operator TOwnSharedModule.Finalize(var Dest: TOwnSharedModule);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnSharedModule.Implicit(const Src: IRcContainer<PWasmSharedModule>): TOwnSharedModule;
begin
  result.FStrongRef := Src;
end;

class operator TOwnSharedModule.Negative(Src: TOwnSharedModule): IRcContainer<PWasmSharedModule>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnSharedModule.Positive(Src: TOwnSharedModule): PWasmSharedModule;
begin
  result := Src.Unwrap;
end;

function TOwnSharedModule.Unwrap: PWasmSharedModule;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnSharedModule.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmSharedModule }

function TWasmSharedModule.Obtain(store : PWasmStore): TOwnModule;
begin
  var p := TWasm.module_obtain(store, @self);
  result.FStrongRef := TRcContainer<PWasmModule>.Create(p, module_disposer);
end;


{ TOwnFunc }

class function TOwnFunc.Wrap(p: PWasmFunc; deleter : TRcDeleter): TOwnFunc;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmFunc>.Create(p, deleter);
end;

class function TOwnFunc.Wrap(p: PWasmFunc): TOwnFunc;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmFunc>.Create(p, func_disposer);
end;

class operator TOwnFunc.Finalize(var Dest: TOwnFunc);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnFunc.Implicit(const Src: IRcContainer<PWasmFunc>): TOwnFunc;
begin
  result.FStrongRef := Src;
end;

class operator TOwnFunc.Negative(Src: TOwnFunc): IRcContainer<PWasmFunc>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnFunc.Positive(Src: TOwnFunc): PWasmFunc;
begin
  result := Src.Unwrap;
end;

function TOwnFunc.Unwrap: PWasmFunc;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnFunc.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmFunc }

function TWasmFunc.Copy: TOwnFunc;
begin
  var p := TWasm.func_copy(@self);
  result.FStrongRef := TRcContainer<PWasmFunc>.Create(p, func_disposer);
end;

function TWasmFunc.GetHostInfo: Pointer;
begin
  result := TWasm.func_get_host_info(@self);
end;

function TWasmFunc.Same(const p: PWasmFunc): Boolean;
begin
  result := TWasm.func_same(@self, p);
end;

procedure TWasmFunc.SetHostInfo(info: Pointer);
begin
  TWasm.func_set_host_info(@self, info);
end;

procedure TWasmFunc.SetHostInfoWithFinalizer(info: Pointer; finalizer: TWasmFinalizer);
begin
  TWasm.func_set_host_info_with_finalizer(@self, info, finalizer);
end;

function TWasmFunc.AsRef: PWasmRef;
begin
  result := TWasm.func_as_ref(@self);
end;

function TWasmFunc.AsRefConst: PWasmRef;
begin
  result := TWasm.func_as_ref_const(@self);
end;

class function TWasmFunc.New(store : PWasmStore;  const functype : PWasmFunctype; func_callback : TWasmFuncCallback) : TOwnFunc;
begin
  var p := TWasm.func_new(store, functype, func_callback);
  result := TOwnFunc.Wrap(p, func_disposer); // ref ++
end;

class function TWasmFunc.NewWithEnv(store : PWasmStore;  const typ : PWasmFunctype; func_callback_with_env : TWasmFuncCallbackWithEnv; env : Pointer; finalizer : TWasmFinalizer) : TOwnFunc;
begin
  var p := TWasm.func_new_with_env(store, typ, func_callback_with_env, env, finalizer);
  result := TOwnFunc.Wrap(p, func_disposer); // ref ++
end;

function TWasmFunc.GetType() : TOwnFunctype;
begin
  var p := TWasm.func_type(@self);
  result := TOwnFunctype.Wrap(p, functype_disposer); // ref ++
end;

function TWasmFunc.ParamArity() : NativeInt;
begin
  result := TWasm.func_param_arity(@self);
end;

function TWasmFunc.ResultArity() : NativeInt;
begin
  result := TWasm.func_result_arity(@self);
end;

function TWasmFunc.Call( const args : PWasmValVec; results : PWasmValVec) : TOwnTrap;
begin
  var p := TWasm.func_call(@self, args, results);
  result := TOwnTrap.Wrap(p, trap_disposer); // ref ++
end;

function TWasmFunc.AsExtern() : PWasmExtern;
begin
  result := TWasm.func_as_extern(@self);
end;

function TWasmFunc.AsExternConst() : PWasmExtern;
begin
  result := TWasm.func_as_extern_const(@self);
end;

{ TOwnGlobal }

class function TOwnGlobal.Wrap(p: PWasmGlobal; deleter : TRcDeleter): TOwnGlobal;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmGlobal>.Create(p, deleter);
end;

class function TOwnGlobal.Wrap(p: PWasmGlobal): TOwnGlobal;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmGlobal>.Create(p, global_disposer);
end;

class operator TOwnGlobal.Finalize(var Dest: TOwnGlobal);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnGlobal.Implicit(const Src: IRcContainer<PWasmGlobal>): TOwnGlobal;
begin
  result.FStrongRef := Src;
end;

class operator TOwnGlobal.Negative(Src: TOwnGlobal): IRcContainer<PWasmGlobal>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnGlobal.Positive(Src: TOwnGlobal): PWasmGlobal;
begin
  result := Src.Unwrap;
end;

function TOwnGlobal.Unwrap: PWasmGlobal;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnGlobal.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmGlobal }

function TWasmGlobal.Copy: TOwnGlobal;
begin
  var p := TWasm.global_copy(@self);
  result.FStrongRef := TRcContainer<PWasmGlobal>.Create(p, global_disposer);
end;

function TWasmGlobal.GetHostInfo: Pointer;
begin
  result := TWasm.global_get_host_info(@self);
end;

function TWasmGlobal.Same(const p: PWasmGlobal): Boolean;
begin
  result := TWasm.global_same(@self, p);
end;

procedure TWasmGlobal.SetHostInfo(info: Pointer);
begin
  TWasm.global_set_host_info(@self, info);
end;

procedure TWasmGlobal.SetHostInfoWithFinalizer(info: Pointer; finalizer: TWasmFinalizer);
begin
  TWasm.global_set_host_info_with_finalizer(@self, info, finalizer);
end;

function TWasmGlobal.AsRef: PWasmRef;
begin
  result := TWasm.global_as_ref(@self);
end;

function TWasmGlobal.AsRefConst: PWasmRef;
begin
  result := TWasm.global_as_ref_const(@self);
end;

class function TWasmGlobal.New(store : PWasmStore;  const globaltype : PWasmGlobaltype;  const val : PWasmVal) : TOwnGlobal;
begin
  var p := TWasm.global_new(store, globaltype, val);
  result := TOwnGlobal.Wrap(p, global_disposer); // ref ++
end;

function TWasmGlobal.GetType() : TOwnGlobaltype;
begin
  var p := TWasm.global_type(@self);
  result := TOwnGlobaltype.Wrap(p, globaltype_disposer); // ref ++
end;

function TWasmGlobal.GetVal() : TOwnVal;
begin
  var out_ : PWasmVal;
  System.New(out_);
  TWasm.global_get(@self, out_);
  result := TOwnVal.Wrap(out_, val_disposer_host); // ref ++
end;

procedure TWasmGlobal.SetVal( const val : PWasmVal);
begin
  TWasm.global_set(@self, val);
end;

function TWasmGlobal.AsExtern() : PWasmExtern;
begin
  result := TWasm.global_as_extern(@self);
end;

function TWasmGlobal.AsExternConst() : PWasmExtern;
begin
  result := TWasm.global_as_extern_const(@self);
end;

{ TOwnTable }

class function TOwnTable.Wrap(p: PWasmTable; deleter : TRcDeleter): TOwnTable;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmTable>.Create(p, deleter);
end;

class function TOwnTable.Wrap(p: PWasmTable): TOwnTable;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmTable>.Create(p, table_disposer);
end;

class operator TOwnTable.Finalize(var Dest: TOwnTable);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnTable.Implicit(const Src: IRcContainer<PWasmTable>): TOwnTable;
begin
  result.FStrongRef := Src;
end;

class operator TOwnTable.Negative(Src: TOwnTable): IRcContainer<PWasmTable>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnTable.Positive(Src: TOwnTable): PWasmTable;
begin
  result := Src.Unwrap;
end;

function TOwnTable.Unwrap: PWasmTable;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnTable.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmTable }

function TWasmTable.Copy: TOwnTable;
begin
  var p := TWasm.table_copy(@self);
  result.FStrongRef := TRcContainer<PWasmTable>.Create(p, table_disposer);
end;

function TWasmTable.GetHostInfo: Pointer;
begin
  result := TWasm.table_get_host_info(@self);
end;

function TWasmTable.Same(const p: PWasmTable): Boolean;
begin
  result := TWasm.table_same(@self, p);
end;

procedure TWasmTable.SetHostInfo(info: Pointer);
begin
  TWasm.table_set_host_info(@self, info);
end;

procedure TWasmTable.SetHostInfoWithFinalizer(info: Pointer; finalizer: TWasmFinalizer);
begin
  TWasm.table_set_host_info_with_finalizer(@self, info, finalizer);
end;

function TWasmTable.AsRef: PWasmRef;
begin
  result := TWasm.table_as_ref(@self);
end;

function TWasmTable.AsRefConst: PWasmRef;
begin
  result := TWasm.table_as_ref_const(@self);
end;

class function TWasmTable.New(store : PWasmStore;  const tabletype : PWasmTabletype; init : PWasmRef) : TOwnTable;
begin
  var p := TWasm.table_new(store, tabletype, init);
  result := TOwnTable.Wrap(p, table_disposer); // ref ++
end;

function TWasmTable.GetType() : TOwnTabletype;
begin
  var p := TWasm.table_type(@self);
  result := TOwnTabletype.Wrap(p, tabletype_disposer); // ref ++
end;

function TWasmTable.GetRef(index : TWasmTableSize) : TOwnRef;
begin
  var p := TWasm.table_get(@self, index);
  result := TOwnRef.Wrap(p, ref_disposer); // ref ++
end;

function TWasmTable.SetRef(index : TWasmTableSize; ref : PWasmRef) : Boolean;
begin
  result := TWasm.table_set(@self, index, ref);
end;

function TWasmTable.Size() : TWasmTableSize;
begin
  result := TWasm.table_size(@self);
end;

function TWasmTable.Grow(delta : TWasmTableSize; init : PWasmRef) : Boolean;
begin
  result := TWasm.table_grow(@self, delta, init);
end;

function TWasmTable.AsExtern() : PWasmExtern;
begin
  result := TWasm.table_as_extern(@self);
end;

function TWasmTable.AsExternConst() : PWasmExtern;
begin
  result := TWasm.table_as_extern_const(@self);
end;

{ TOwnMemory }

class function TOwnMemory.Wrap(p: PWasmMemory; deleter : TRcDeleter): TOwnMemory;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmMemory>.Create(p, deleter);
end;

class function TOwnMemory.Wrap(p: PWasmMemory): TOwnMemory;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmMemory>.Create(p, memory_disposer);
end;

class operator TOwnMemory.Finalize(var Dest: TOwnMemory);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnMemory.Implicit(const Src: IRcContainer<PWasmMemory>): TOwnMemory;
begin
  result.FStrongRef := Src;
end;

class operator TOwnMemory.Negative(Src: TOwnMemory): IRcContainer<PWasmMemory>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnMemory.Positive(Src: TOwnMemory): PWasmMemory;
begin
  result := Src.Unwrap;
end;

function TOwnMemory.Unwrap: PWasmMemory;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnMemory.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmMemory }

function TWasmMemory.Copy: TOwnMemory;
begin
  var p := TWasm.memory_copy(@self);
  result.FStrongRef := TRcContainer<PWasmMemory>.Create(p, memory_disposer);
end;

function TWasmMemory.GetHostInfo: Pointer;
begin
  result := TWasm.memory_get_host_info(@self);
end;

function TWasmMemory.Same(const p: PWasmMemory): Boolean;
begin
  result := TWasm.memory_same(@self, p);
end;

procedure TWasmMemory.SetHostInfo(info: Pointer);
begin
  TWasm.memory_set_host_info(@self, info);
end;

procedure TWasmMemory.SetHostInfoWithFinalizer(info: Pointer; finalizer: TWasmFinalizer);
begin
  TWasm.memory_set_host_info_with_finalizer(@self, info, finalizer);
end;

function TWasmMemory.AsRef: PWasmRef;
begin
  result := TWasm.memory_as_ref(@self);
end;

function TWasmMemory.AsRefConst: PWasmRef;
begin
  result := TWasm.memory_as_ref_const(@self);
end;

class function TWasmMemory.New(store : PWasmStore;  const memorytype : PWasmMemorytype) : TOwnMemory;
begin
  var p := TWasm.memory_new(store, memorytype);
  result := TOwnMemory.Wrap(p, memory_disposer); // ref ++
end;

function TWasmMemory.GetType() : TOwnMemorytype;
begin
  var p := TWasm.memory_type(@self);
  result := TOwnMemorytype.Wrap(p, memorytype_disposer); // ref ++
end;

function TWasmMemory.Data() : PByte;
begin
  result := TWasm.memory_data(@self);
end;

function TWasmMemory.DataSize() : NativeInt;
begin
  result := TWasm.memory_data_size(@self);
end;

function TWasmMemory.Size() : TWasmMemoryPages;
begin
  result := TWasm.memory_size(@self);
end;

function TWasmMemory.Grow(delta : TWasmMemoryPages) : Boolean;
begin
  result := TWasm.memory_grow(@self, delta);
end;

function TWasmMemory.AsExtern() : PWasmExtern;
begin
  result := TWasm.memory_as_extern(@self);
end;

function TWasmMemory.AsExternConst() : PWasmExtern;
begin
  result := TWasm.memory_as_extern_const(@self);
end;

{ TOwnExtern }

class function TOwnExtern.Wrap(p: PWasmExtern; deleter : TRcDeleter): TOwnExtern;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmExtern>.Create(p, deleter);
end;

class function TOwnExtern.Wrap(p: PWasmExtern): TOwnExtern;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmExtern>.Create(p, extern_disposer);
end;

class operator TOwnExtern.Finalize(var Dest: TOwnExtern);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnExtern.Implicit(const Src: IRcContainer<PWasmExtern>): TOwnExtern;
begin
  result.FStrongRef := Src;
end;

class operator TOwnExtern.Negative(Src: TOwnExtern): IRcContainer<PWasmExtern>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnExtern.Positive(Src: TOwnExtern): PWasmExtern;
begin
  result := Src.Unwrap;
end;

function TOwnExtern.Unwrap: PWasmExtern;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnExtern.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmExtern }

function TWasmExtern.Copy: TOwnExtern;
begin
  var p := TWasm.extern_copy(@self);
  result.FStrongRef := TRcContainer<PWasmExtern>.Create(p, extern_disposer);
end;

function TWasmExtern.GetHostInfo: Pointer;
begin
  result := TWasm.extern_get_host_info(@self);
end;

function TWasmExtern.Same(const p: PWasmExtern): Boolean;
begin
  result := TWasm.extern_same(@self, p);
end;

procedure TWasmExtern.SetHostInfo(info: Pointer);
begin
  TWasm.extern_set_host_info(@self, info);
end;

procedure TWasmExtern.SetHostInfoWithFinalizer(info: Pointer; finalizer: TWasmFinalizer);
begin
  TWasm.extern_set_host_info_with_finalizer(@self, info, finalizer);
end;

function TWasmExtern.AsRef: PWasmRef;
begin
  result := TWasm.extern_as_ref(@self);
end;

function TWasmExtern.AsRefConst: PWasmRef;
begin
  result := TWasm.extern_as_ref_const(@self);
end;

function TWasmExtern.Kind() : TWasmExternkind;
begin
  result := TWasm.extern_kind(@self);
end;

function TWasmExtern.GetType() : TOwnExterntype;
begin
  var p := TWasm.extern_type(@self);
  result := TOwnExterntype.Wrap(p, externtype_disposer); // ref ++
end;

function TWasmExtern.AsFunc() : PWasmFunc;
begin
  result := TWasm.extern_as_func(@self);
end;

function TWasmExtern.AsGlobal() : PWasmGlobal;
begin
  result := TWasm.extern_as_global(@self);
end;

function TWasmExtern.AsTable() : PWasmTable;
begin
  result := TWasm.extern_as_table(@self);
end;

function TWasmExtern.AsMemory() : PWasmMemory;
begin
  result := TWasm.extern_as_memory(@self);
end;

function TWasmExtern.AsFuncConst() : PWasmFunc;
begin
  result := TWasm.extern_as_func_const(@self);
end;

function TWasmExtern.AsGlobalConst() : PWasmGlobal;
begin
  result := TWasm.extern_as_global_const(@self);
end;

function TWasmExtern.AsTableConst() : PWasmTable;
begin
  result := TWasm.extern_as_table_const(@self);
end;

function TWasmExtern.AsMemoryConst() : PWasmMemory;
begin
  result := TWasm.extern_as_memory_const(@self);
end;

{ TOwnExternVec }

class function TOwnExternVec.Wrap(p: PWasmExternVec; deleter : TRcDeleter): TOwnExternVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmExternVec>.Create(p, deleter);
end;

class function TOwnExternVec.Wrap(p: PWasmExternVec): TOwnExternVec;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmExternVec>.Create(p, extern_vec_disposer);
end;

class operator TOwnExternVec.Finalize(var Dest: TOwnExternVec);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnExternVec.Implicit(const Src: IRcContainer<PWasmExternVec>): TOwnExternVec;
begin
  result.FStrongRef := Src;
end;

class operator TOwnExternVec.Negative(Src: TOwnExternVec): IRcContainer<PWasmExternVec>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnExternVec.Positive(Src: TOwnExternVec): PWasmExternVec;
begin
  result := Src.Unwrap;
end;

function TOwnExternVec.Unwrap: PWasmExternVec;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnExternVec.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmExternVec }

constructor TWasmExternVec.Create(const arry: array of PWasmExtern);
begin
  size := Length(arry);
  if size = 0 then data := nil
  else             data := @arry[0];
end;

class function TWasmExternVec.New(const init: array of PWasmExtern; elem_release : Boolean): TOwnExternVec;
var
  prec : PWasmExternVec;
begin
  System.New(prec);
  TWasm.extern_vec_new(prec, Length(init), @init[0]);
  if elem_release then
    result.FStrongRef := TRcContainer<PWasmExternVec>.Create(prec, extern_vec_disposer_host)
  else
    result.FStrongRef := TRcContainer<PWasmExternVec>.Create(prec, extern_vec_disposer_host_only);
end;

class function TWasmExternVec.NewEmpty: TOwnExternVec;
var
  prec : PWasmExternVec;
begin
  System.New(prec);
  TWasm.extern_vec_new_empty(prec);
  result.FStrongRef := TRcContainer<PWasmExternVec>.Create(prec, extern_vec_disposer_host);
end;

class function TWasmExternVec.NewUninitialized(size: NativeInt): TOwnExternVec;
var
  prec : PWasmExternVec;
begin
  System.New(prec);
  TWasm.extern_vec_new_uninitialized(prec, size);
  result.FStrongRef := TRcContainer<PWasmExternVec>.Create(prec, extern_vec_disposer_host);
end;

function TWasmExternVec.Copy: TOwnExternVec;
var
  prec : PWasmExternVec;
begin
  System.New(prec);
  TWasm.extern_vec_copy(prec, @self);
  result.FStrongRef := TRcContainer<PWasmExternVec>.Create(prec, extern_vec_disposer_host);
end;

procedure TWasmExternVec.Assign(const Src :TOwnExternVec);
begin
  TWasm.extern_vec_copy(@self, Src.Unwrap);
end;

{ TOwnInstance }

class function TOwnInstance.Wrap(p: PWasmInstance; deleter : TRcDeleter): TOwnInstance;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmInstance>.Create(p, deleter);
end;

class function TOwnInstance.Wrap(p: PWasmInstance): TOwnInstance;
begin
  if p = nil then result.FStrongRef := nil
  else result.FStrongRef := TRcContainer<PWasmInstance>.Create(p, instance_disposer);
end;

class operator TOwnInstance.Finalize(var Dest: TOwnInstance);
begin
  Dest.FStrongRef := nil;
end;

class operator TOwnInstance.Implicit(const Src: IRcContainer<PWasmInstance>): TOwnInstance;
begin
  result.FStrongRef := Src;
end;

class operator TOwnInstance.Negative(Src: TOwnInstance): IRcContainer<PWasmInstance>;
begin
  result := Src.FStrongRef;
end;

class operator TOwnInstance.Positive(Src: TOwnInstance): PWasmInstance;
begin
  result := Src.Unwrap;
end;

function TOwnInstance.Unwrap: PWasmInstance;
begin
  result := FStrongRef.Unwrap;
end;

function TOwnInstance.IsNone() : Boolean;
begin
  result := FStrongRef = nil;
end;


{ TWasmInstance }

class function TWasmInstance.New(store: PWasmStore; const module: PWasmModule; const imports: array of PWasmExtern): TOwnInstance;
begin
  var imps := TWasmExternVec.Create(imports);

  var instance := TWasm.instance_new(store, module, @imps, nil);
  result := TOwnInstance.Wrap(instance, instance_disposer)
end;

class function TWasmInstance.New(store: PWasmStore; const module: PWasmModule; const imports: array of PWasmExtern; var trap: TOwnTrap): TOwnInstance;
begin
  var imps := TWasmExternVec.Create(imports);
  var tmp_trap : PWasmTrap;

  var instance := TWasm.instance_new(store, module, @imps, @tmp_trap);
  trap := TOwnTrap.Wrap(tmp_trap);
  result := TOwnInstance.Wrap(instance, instance_disposer)
end;

class function TWasmInstance.New(store : PWasmStore;  const module : PWasmModule;  const imports : PWasmExternVec) : TOwnInstance;
begin
  var p := TWasm.instance_new(store, module, imports, nil);
  result := TOwnInstance.Wrap(p, instance_disposer); // ref ++
end;
function TWasmInstance.Copy: TOwnInstance;
begin
  var p := TWasm.instance_copy(@self);
  result.FStrongRef := TRcContainer<PWasmInstance>.Create(p, instance_disposer);
end;

function TWasmInstance.GetHostInfo: Pointer;
begin
  result := TWasm.instance_get_host_info(@self);
end;

function TWasmInstance.Same(const p: PWasmInstance): Boolean;
begin
  result := TWasm.instance_same(@self, p);
end;

procedure TWasmInstance.SetHostInfo(info: Pointer);
begin
  TWasm.instance_set_host_info(@self, info);
end;

procedure TWasmInstance.SetHostInfoWithFinalizer(info: Pointer; finalizer: TWasmFinalizer);
begin
  TWasm.instance_set_host_info_with_finalizer(@self, info, finalizer);
end;

function TWasmInstance.AsRef: PWasmRef;
begin
  result := TWasm.instance_as_ref(@self);
end;

function TWasmInstance.AsRefConst: PWasmRef;
begin
  result := TWasm.instance_as_ref_const(@self);
end;

class function TWasmInstance.New(store : PWasmStore;  const module : PWasmModule;  const imports : PWasmExternVec; var {own} trap : TOwnTrap) : TOwnInstance;
begin
  var tmp_trap : PWasmTrap;
  var p := TWasm.instance_new(store, module, imports, @tmp_trap);
  trap := TOwnTrap.Wrap(tmp_trap);
  result := TOwnInstance.Wrap(p, instance_disposer); // ref ++
end;

function TWasmInstance.GetExports() : TOwnExternVec;
begin
  var out_ : PWasmExternVec;
  System.New(out_);
  TWasm.instance_exports(@self, out_);
  result := TOwnExternVec.Wrap(out_, extern_vec_disposer_host); // ref ++
end;

end.
