unit Ownership;

interface
uses
  System.SysUtils, System.SyncObjs;

type

  IRcContainer<T> = Interface
    function Unwrap : T;
    function Move : T;
  End;

  TRcDeleter = reference to procedure(Data : Pointer);
  //TRcDeleter<T> = procedure(data : T)にすると内部エラーが出るので致し方なし

  TRcContainer<T> = class(TInterfacedObject, IRcContainer<T>)
  private
    FData : T;
    FDeleter : TRcDeleter;
  public
    constructor Create(Data : T; Deleter : TRcDeleter = nil);
    destructor  Destroy; override;
    function Unwrap : T;
    function Move : T; // 所有権を移動させる/移動したことを示す状態にする(FDeleterをnilにする。)  ※TObjectに対しては無効
  end;

  ERcDroppedException = class(Exception)
  end;

  TRcUnwrapProc<T> = reference to procedure(const data : T);

  // 参照カウント型スマートポインタ
  // classのインスタンスを管理する場合はDeleter指定不要。自動的にFreeが呼ばれる
  // ポインターを管理する場合は独自のDeleterを指定する。(nilもしくは省略すると何もしない)
  // New()したレコードへのポインターを管理する場合、DeleterにDefaultRecordDisposer()を指定する必要あり
  //  ※Deleterを指定しないとメモリリークが発生する
  //  (ここに記述している内容は実際にはI/TRcContainer<>が処理している)
  TRc<T> = record
  private
    FStrongRef : IRcContainer<T>;
  public
    class function Wrap(Data : T; Deleter : TRcDeleter = nil) : TRc<T>; inline; static;
    class operator Implicit(const Src : IRcContainer<T>) : TRc<T>; overload;
    class operator Finalize(var Dest : TRc<T>);
    class operator Positive(Src : TRc<T>) : T;
    class operator Negative(Src : TRc<T>) : IRcContainer<T>;
    function Unwrap : T; overload;
    procedure Unwrap(func : TRcUnwrapProc<T>); overload;

//    procedure Drop; // Drop後にUnwrapされるのを防ぎようがないのでコメントアウトしておく。意図したタイミングで解放したい場合はbegin/endでスコープを作る
  end;

  // TWeak<T>からTRc<T>に昇格させる場合、既に解放済のケースがあるので解放済(IsNone)を表現可能なTOptionRc<T>に昇格させる
  TOptionRc<T> = record
  private
    FStrongRef : IRcContainer<T>;
  public
    class function Wrap(Data : T; Deleter : TRcDeleter = nil) : TOptionRc<T>; static;
    class operator Finalize(var Dest : TOptionRc<T>);
    class operator Negative(Src : TOptionRc<T>) : IRcContainer<T>;

    function IsNone() : Boolean;
    function TryUnwrap(Func : TRcUnwrapProc<T>) : Boolean; overload;
    function TryUnwrap(out Data : T) : Boolean; overload;
    function TryUnwrap(out Data : TRc<T>) : Boolean; overload;

    procedure Drop;
  end;

  ENewWrapException = class(Exception)
  public
    class constructor Create();
  end;

  TRcUpgradeProc<T> = reference to procedure(const rc : TRc<T>);

  // TRc<>で管理しているオブジェクトへの弱い参照を管理する
  // 保持している参照は既に存在しない場合があるため
  // オブジェクトにアクセスするためにはTryUpgadeでTRc<>に昇格する必要がある
  TWeak<T> = record
  private
    [Weak] FWeakRef : IRcContainer<T>;
  public
    class operator Implicit(const Src : TRc<T>) : TWeak<T>; overload;
    class operator Implicit(const Src : IRcContainer<T>) : TWeak<T>; overload;
    class operator Positive(Src : TWeak<T>) : TOptionRc<T>;

    function TryUpgrade(var Dest : TRc<T>) : Boolean; overload;
    function TryUpgrade(func : TRcUpgradeProc<T>) : Boolean; overload;
    function Upgrade() : TOptionRc<T>;
    procedure Drop;
  end;

  // TRc<>を少ない記述量で生成するための関数群
  TRc = class
  public
    class function Wrap<T>(Data : T; Deleter : TRcDeleter = nil) : TRc<T>; static;
    class function NewWrap<PT,T>(Deleter : TRcDeleter = nil) : TRc<PT>; static;
    class function CreateWrap<T:class, constructor>() : TRc<T>; static;
  end;

  // 参照を唯一のオーナーが持つスマートポインタ
  // ※ただしTryUnwrapしたものを保持されてしまうことは防げない・・・
  // 他のTUniq<>への代入(コピー)は許されない(強制的に移動になる)
  // TRc<>(IRcContainer経由)への移動は許される。TWeak<>にも移動できるが無意味
  // 参照が移動されている可能性があるため、保持しているオブジェクトにアクセスする場合はTryUnwrap
  // をもちいる
  // Assign()が使用されている場合は例外を出してコピーを禁止する方法を試してみたが
  // Moveを実装しようとするとAssign()が使われてしまうのでどうにもならなかった
  TUniq<T> = record
  private
    FStrongRef : IRcContainer<T>;
  public
    class function Wrap(Data : T; Deleter : TRcDeleter = nil) : TUniq<T>; static;
    class operator Finalize(var Dest : TUniq<T>);
    class operator Assign(var Dest : TUniq<T>; var Src : TUniq<T>);

    function IsNone() : Boolean;
    function TryUnwrap(var Data: T): Boolean; overload;
    function TryUnwrap(Func: TRcUnwrapProc<T>): Boolean; overload;
    function MoveTo : IRcContainer<T>; overload;
    procedure Drop;  // TRc<>とは違い、TryUnwarpでしか取り出せないのでDropも有効にした。
  end;

  TUniq = class
  public
    class function Wrap<T>(Data : T; Deleter : TRcDeleter = nil) : TUniq<T>; static;
  end;

  TRcLockedContainer<T> = class(TInterfacedObject, IRcContainer<T>)
  private
    FLock : TLightweightMREW;
    FData : T;
    FDeleter : TRcDeleter;
  public
    constructor Create(Data : T; Deleter : TRcDeleter = nil);
    destructor  Destroy; override;
    function Unwrap : T;
    function Move : T;
  end;

  TMuxtexGuardW<T> = record
  private
    FData : TRcLockedContainer<T>;
  public
    class operator Finalize(var Dest : TMuxtexGuardW<T>);
    function Unwrap : T; inline;
    procedure ReWrap(data : T); inline;
  end;

  TMuxtexGuardR<T> = record
  private
    FData : TRcLockedContainer<T>;
  public
    class operator Finalize(var Dest : TMuxtexGuardR<T>);
    function Unwrap : T; inline;
  end;

  TArcMutex<T> = record
  private
    FStrongRef : IRcContainer<T>;
  public
    class function Wrap(Data : T; Deleter : TRcDeleter = nil) : TArcMutex<T>; static;
    class operator Implicit(const Src : IRcContainer<T>) : TArcMutex<T>; overload;
    class operator Finalize(var Dest : TArcMutex<T>);

    function LockW : TMuxtexGuardW<T>;
    function LockR : TMuxtexGuardR<T>;
  end;

  TArcMutex = class
  public
    class function Wrap<T>(Data : T; Deleter : TRcDeleter = nil) : TArcMutex<T>; static;
  end;

procedure DefaultRecordDisposer(p : Pointer);
procedure DefaultObjectDeleter(Data : Pointer);


implementation


procedure DefaultRecordDisposer(p : Pointer);
begin
  Dispose(p);
end;

procedure DefaultObjectDeleter(Data : Pointer);
begin
  TObject(Data).Free;
end;

{ TRcContainer<T> }

constructor TRcContainer<T>.Create(Data: T; Deleter: TRcDeleter);
begin
  FData := data;
  if GetTypeKind(T) = tkClass then
  begin
    if not Assigned(Deleter) then  FDeleter := DefaultObjectDeleter
    else                           FDeleter := Deleter;
  end else begin
    FDeleter := deleter;
  end;
end;

destructor TRcContainer<T>.Destroy;
var
  p : TObject;
  o : T absolute p;
begin
  o := FData;
  if Assigned(FDeleter) then FDeleter(Pointer(p));
  inherited;
end;

function TRcContainer<T>.Move : T;
begin
  result := FData;
  FDeleter := nil;
end;

function TRcContainer<T>.Unwrap: T;
begin
  result := FData;
end;

{ TRc<T> }

 // Drop後にUnwrapされるのを防ぎようがないのでコメントアウトしておく
 {
procedure TRc<T>.Drop;
begin
  FStrongRef := nil; // ref --
end;
}

class operator TRc<T>.Finalize(var Dest: TRc<T>);
begin
  Dest.FStrongRef := nil; // ref --
end;

class operator TRc<T>.Implicit(const Src: IRcContainer<T>): TRc<T>;
begin
  result.FStrongRef := Src;
end;

class operator TRc<T>.Negative(Src: TRc<T>): IRcContainer<T>;
begin
  result := Src.FStrongRef;
end;

class operator TRc<T>.Positive(Src: TRc<T>): T;
begin
  if Src.FStrongRef = nil then raise ERcDroppedException.Create('Unable to unwrap dropped references!');

  result := Src.FStrongRef.Unwrap;
end;

function TRc<T>.Unwrap: T;
begin
  if FStrongRef = nil then raise ERcDroppedException.Create('Unable to unwrap dropped references!');

  result := FStrongRef.Unwrap;
end;

procedure TRc<T>.Unwrap(func: TRcUnwrapProc<T>);
begin
  if FStrongRef = nil then raise ERcDroppedException.Create('Unable to unwrap dropped references!');
  func(FStrongRef.Unwrap);
end;

class function TRc<T>.Wrap(Data: T; Deleter: TRcDeleter): TRc<T>;
begin
  result.FStrongRef := TRcContainer<T>.Create(Data, Deleter); // ref ++
end;

{ TOptionRc<T> }

procedure TOptionRc<T>.Drop;
begin
  FStrongRef := nil; // ref --
end;

class operator TOptionRc<T>.Finalize(var Dest: TOptionRc<T>);
begin
  Dest.FStrongRef := nil; // ref --
end;

function TOptionRc<T>.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

class operator TOptionRc<T>.Negative(Src: TOptionRc<T>): IRcContainer<T>;
begin
  result := Src.FStrongRef;
end;

function TOptionRc<T>.TryUnwrap(out Data: TRc<T>): Boolean;
begin
  result := FStrongRef <> nil;
  if result then data.FStrongRef := FStrongRef;
end;

function TOptionRc<T>.TryUnwrap(Func: TRcUnwrapProc<T>): Boolean;
begin
  result := FStrongRef <> nil;
  if result then func(FStrongRef.Unwrap);
end;

function TOptionRc<T>.TryUnwrap(out Data: T): Boolean;
begin
  result := FStrongRef <> nil;
  if result then data := FStrongRef.Unwrap;
end;

class function TOptionRc<T>.Wrap(Data: T; Deleter: TRcDeleter): TOptionRc<T>;
begin
  result.FStrongRef := TRcContainer<T>.Create(Data, Deleter); // ref ++
end;

{ TRc }

class function TRc.CreateWrap<T>(): TRc<T>;
begin
  var obj := T.Create();
  result := TRc<T>.Wrap(obj, nil);
end;

class function TRc.NewWrap<PT,T>(Deleter: TRcDeleter): TRc<PT>;
type
  PR = ^T;
var
  p : PR;
  d : PT absolute p;
begin
  if GetTypeKind(PT) = tkPointer then
  begin
    System.New(p);
    p^ := Default(T);
    if Assigned(Deleter) then result := TRc<PT>.Wrap(d, Deleter)
    else                      result := TRc<PT>.Wrap(d, DefaultRecordDisposer);
  end else begin
    raise ENewWrapException.Create('TRc.NewWrap<PT,T>() PT must be record pointer! ');
  end;
end;

class function TRc.Wrap<T>(Data: T; Deleter: TRcDeleter): TRc<T>;
begin
  result := TRc<T>.Wrap(data, Deleter);
end;

{ TWeak<T> }

procedure TWeak<T>.Drop;
begin
  FWeakRef := nil;
end;

class operator TWeak<T>.Implicit(const Src: TRc<T>): TWeak<T>;
begin
  result.FWeakRef := Src.FStrongRef; // ref +-0
end;

class operator TWeak<T>.Implicit(const Src: IRcContainer<T>): TWeak<T>;
begin
  result.FWeakRef := Src; // ref +-0
end;

class operator TWeak<T>.Positive(Src: TWeak<T>): TOptionRc<T>;
begin
  result.FStrongRef := Src.FWeakRef;
end;

function TWeak<T>.TryUpgrade(var Dest: TRc<T>): Boolean;
begin
  Dest.FStrongRef := FWeakRef;  // ref++
  result := Dest.FStrongRef <> nil;
end;

function TWeak<T>.TryUpgrade(func: TRcUpgradeProc<T>): Boolean;
begin
  var rc : TRc<T>;
  if TryUpgrade(rc) then
  begin
    func(rc);
    result := true;
  end else begin
    result := false;
  end;
end;

function TWeak<T>.Upgrade: TOptionRc<T>;
begin
  result.FStrongRef := FWeakRef;
end;

{ TUniq<T> }

class operator TUniq<T>.Assign(var Dest: TUniq<T>; var Src: TUniq<T>);
begin
  Dest.FStrongRef := Src.FStrongRef;
  Src.FStrongRef := nil;
end;

procedure TUniq<T>.Drop;
begin
  FStrongRef := nil; // ref --
end;

class operator TUniq<T>.Finalize(var Dest: TUniq<T>);
begin
  Dest.FStrongRef := nil; // ref --
end;

function TUniq<T>.IsNone: Boolean;
begin
  result := FStrongRef = nil;
end;

function TUniq<T>.MoveTo: IRcContainer<T>;
begin
  result := FStrongRef; // ref++
  FStrongRef := nil; // ref --
end;


function TUniq<T>.TryUnwrap(var Data: T): Boolean;
begin
  result := FStrongRef <> nil;
  if result then Data := FStrongRef.Unwrap;
end;

function TUniq<T>.TryUnwrap(Func: TRcUnwrapProc<T>): Boolean;
begin
  result := FStrongRef <> nil;
  if result then func(FStrongRef.Unwrap);
end;

class function TUniq<T>.Wrap(Data: T; Deleter: TRcDeleter): TUniq<T>;
begin
  result.FStrongRef := TRcContainer<T>.Create(Data, Deleter); // ref ++
end;

{ TUniq }

class function TUniq.Wrap<T>(Data: T; Deleter: TRcDeleter): TUniq<T>;
begin
  result := TUniq<T>.Wrap(Data, Deleter);
end;

{ ENewWrapException }

class constructor ENewWrapException.Create;
begin
  raise Exception.Create('TRc.NewWrap<PT,T>() PT must be record pointer! ');
end;


{ TArcMutex<T> }

class operator TArcMutex<T>.Finalize(var Dest: TArcMutex<T>);
begin
  Dest.FStrongRef := nil;
end;

class operator TArcMutex<T>.Implicit(const Src: IRcContainer<T>): TArcMutex<T>;
begin
  result.FStrongRef := Src;
end;


function TArcMutex<T>.LockR: TMuxtexGuardR<T>;
begin
  result.FData := FStrongRef as TRcLockedContainer<T>;
  result.FData.FLock.BeginRead;
end;

function TArcMutex<T>.LockW: TMuxtexGuardW<T>;
begin
  result.FData := FStrongRef as TRcLockedContainer<T>;
  result.FData.FLock.BeginWrite;
end;

class function TArcMutex<T>.Wrap(Data: T; Deleter: TRcDeleter): TArcMutex<T>;
begin
  result.FStrongRef := TRcLockedContainer<T>.Create(Data, Deleter);
end;

{ TRcLockedContainer<T> }

constructor TRcLockedContainer<T>.Create(Data: T; Deleter: TRcDeleter);
begin
  FData := Data;
  if GetTypeKind(T) = tkClass then
  begin
    if not Assigned(Deleter) then  FDeleter := DefaultObjectDeleter
    else                           FDeleter := Deleter;
  end else begin
    FDeleter := Deleter;
  end;
end;

destructor TRcLockedContainer<T>.Destroy;
var
  p : TObject;
  o : T absolute p;
begin
  o := FData;
  if Assigned(FDeleter) then FDeleter(Pointer(p));

  inherited;
end;

function TRcLockedContainer<T>.Move: T;
begin
  result := FData;
  FDeleter := nil;
end;

function TRcLockedContainer<T>.Unwrap: T;
begin
  result := Default(T);
end;

{ TMuxtexGuardW<T> }

class operator TMuxtexGuardW<T>.Finalize(var Dest: TMuxtexGuardW<T>);
begin
  Dest.FData.FLock.EndWrite;
end;

procedure TMuxtexGuardW<T>.ReWrap(data: T);
begin
  FData.FData := data;
end;

function TMuxtexGuardW<T>.Unwrap: T;
begin
  result := FData.FData;
end;

{ TMuxtexGuardR<T> }

class operator TMuxtexGuardR<T>.Finalize(var Dest: TMuxtexGuardR<T>);
begin
  Dest.FData.FLock.EndRead;
end;

function TMuxtexGuardR<T>.Unwrap: T;
begin
  result := FData.FData;
end;

{ TArcMutex }

class function TArcMutex.Wrap<T>(Data: T; Deleter: TRcDeleter): TArcMutex<T>;
begin
  result.FStrongRef := TRcLockedContainer<T>.Create(Data, Deleter);
end;

end.
