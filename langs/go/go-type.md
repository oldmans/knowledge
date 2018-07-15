# Go-Type

```ebnf
Type      = TypeName | TypeLit | "(" Type ")" .
TypeName  = identifier | QualifiedIdent .
TypeLit   = ArrayType | SliceType | StructType | MapType | PointerType | FunctionType | InterfaceType | ChannelType .
```

Go的数据类型分四大类：`基础类型（数字、字符串、布尔值）`、`聚合类型（数组、结构体）`、`复合类型（数组、切片、字典、结构体）`、`引用类型（指针、切片、字典、函数、通道）`、`接口类型`


Type         | Literal               | Zero
-------------|-----------------------|----------------------
 int uint    | 123                   | 0
 string      | "ABC"                 | ""
 boolean     | true                  | false
 [n]ArrayType| ArrayType{1, 2, 3}    | nil
 []SliceType | SliceType{1, 2, 3}    | nil
 {}StructType| Type{key: "value"}    |

## 类型分类

### 基础类型

* 整数

```go
 int、 int8、 int16、 int32、 int64
uint、uint8、uint16、uint32、uint64
```

```go
byte int32同义词，强调原始数据（二进制）而非数值
rune int32同义词，表示Unicode码点
uintptr 足以存放指针
```

* 浮点数

```go
float32
float64
```

* 复数

```go
complex64
complex128
```

* 布尔值

```go
true
false
```

* 字符串

```go
bytes
strings
strconv
unicode
```

### 聚合类型

### 引用类型

### 接口类型

## 类型定义

类型决定了一组值以及特定于这些值的操作和方法。一个类型可以用一个类型名称表示，如果它有一个类型，或者使用一个类型字面值来指定，它从现有类型组成一个类型。

类型可以分为 `命名类型（Named Types）` 和 `未命名类型（Unnamed Types）`，`命名类型` 就是给类型取个名字，直接使用名字表示某种类型，未命名类型也就是没有名称，只有类型本身 `[6]int`。

```go
type definition
```

* StructType

```go
type NewStructType struct {i j k int}
```

* ArrayType

```go
type NewArrayType []ExistType
```

* MapType

```go
type NewMapType map[int]string
```

* PointerType

```go
type ExistTypePointer *ExistType
```

* FunctionType

```go
type FunctionType func(int) bool
```

* InterfaceType

```go
type Any interface {
    f func(int) bool
}
```

* ChannelType

```go
type Chan (chan ->)
```

## 类型别名

> 类型别名和原类型完全一样，只不过是另一种叫法而已

```go
type identifier = Type
```
