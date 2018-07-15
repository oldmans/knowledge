# Go—Lang

## 程序结构

```go
package main

import "fmt"

const PI = 3.14

func main() {
    fmt.Println("PI: %s", PI)
}
```

### 关键字

* package、import
* var、const
* func、return、defer
* if、else、switch、case、break、continue、for、fallthrough、goto、default
* interface
* struct
* type
* map
* range
* go
* select
* chan

### 预声明常量、类型、函数

1. 常量

    ```go
    true、false、iota、nil
    ```

1. 类型

    ```go
    int、int8、int16、int32、int64
    uint、uint8、uint16、uint32、uint64
    float32、float64
    complex64、complex128
    ```

1. 函数

    ```go
    new、delete、make
    len、cap
    append、copy
    close、panic、recover
    complex、real、imag
    ```

### 可见性

1. 函数内声明，仅函数内可见
1. 函数外声明，包内可见
1. 函数外声明且首字母大写，其它包可见

### 命名风格

1. 驼峰式命名，大驼峰可导出，小驼峰不可导出
1. go 倾向于使用短名称，特别是作用域娇小的局部变量

### 声明

有4种主要的声明方式：

1. var
1. const
1. type
1. func

### 变量

```go
var name type = expression
```

必须能够确定变量类型（同时确定了零值），所以，type 和 expression 只可以省略一个

零值：

| type            | 0     |
| --------------- | ----- |
| number          | 0     |
| boolean         | false |
| string          | ""    |
| interface & ref | nil   |

零值机制保障所有的变量都是良好定义的，不存在未初始化的变量

### 短变量

```go
name := expression
```

仅能用在函数内部，类型由 `expression` 决定

因其短小、灵活，故而在局部变量初始化中主要使用短变量声明

Note：

1. `var` 通常用于跟初始化表达式类型不一致的局部变量保留的，或者用于后面才对变量赋值以及初始值不重要的情况
2. `:=` 表示 声明， `=` 表示 赋值
3. 短变量声明不要声明所有 `:=` 左边的变量，但至少有一个变量是新声明的，其他变量被赋值

最佳实践：短变量只用来做变量声明

### 指针

指针的值是一个变量的地址，所有的变量都有地址，但不是所有的值都有地址。使用指针可以在不知道变量名字的情况下，间接读取或操作变量的值。

```go
x := 1
p := &x
fmt.Println(*p)
*p = 2
```

函数返回局部变量的地址是安全的，【闭包】

### new

`new(T)` 创建一个 `T` 类型的变量，初始化为 `T` 类型的零值，并返回其地址，省了一个名字

```go
p := new(int)
```

### 变量的生命周期

1. 包级别的变量存在于整个程序的执行过程
1. 局部变量有一个动态的生命周期，从创建到不可访问，然后被垃圾回收
1. 逃逸，闭包

### 赋值 & 多重赋值

```go
x = 1
*p = true
person.name = "Bob"
count[x] = 100
```

```go
x, y = y, x
a[i], a[j] = a[j], a[i]
```

### 可赋值性

可复制性根据不同的类型有不同的规制。

1. 类型必须完全匹配
1. nil可以赋值给任何接口变量或引用类型
1. 常量有更灵活的可赋值性规则避免显示转换
1. 在任何比较中，第一个操作数相对于第二个操作数必须是可赋值的，或者可反过来赋值的

### 类型声明

`type` 声明定义了一个新的命名类型，它和已有的类型使用同样的底层类型

```go
type name underlying_type
```

Note：

1. 类型名字遵循名字可见性规则
1. 使用相同底层类型声明的类型，不是相同的类型，不能使用算数表达式进行比较或合并
1. 相同底层类型上层类型，或二者都指向相同底层类型变量的未命名指针类型，可类型转换 `T(x)`
1. 类型有层次，则形成类型树，但实际可能是同一底层类型，底层类型决定结构和表达方式
1. 命名类型的底层类型决定了它的结构和表达方式以及它致辞的内部操作集合，这些内部操作与直接使用底层类型的情况相同。如：底层类型是 `int`，则可直接使用算数运算符。

### 包

1. 包提供了一个独立的命名空间
1. 包可以让我们通过变量的可见性来隐藏信息

### 包初始化

1. 包初始化从包级别的变量开始，这些变量按照声明的顺序初始化，在依赖已解析完毕的情况下，根据依赖顺序进行。

    ```go
    var a = b + c
    var b = f()
    var c = 1
    func f() int { return c + 1 }
    ```

1. 如果包由多个 `.go` 文件组成，初始化按照编译器收到的文件的顺序进行：go工具会排序。
1. ` func init() {}`，在一个文件里，当程序启动的时候，`init` 按声明的顺序自动执行。
1. 包初始顺序按包在程序中导入的顺序进行，每次初始化一个包。`main` 包最后初始化。

### 导入

```go
import "fmt"
```

### 作用域

1. go 采用词法作用域，即 声明时在程序中出现的位置。
1. go 拥有块级作用域，词法块不一定有大括号 `{}`。
1. 词法块决定了作用域的大小。
1. 同名声明不能出现在同一个块中。
1. 包含了全部代码的词法块叫 `全局块`。
1. `int、len、true` 等内置类型函数或常量在 `全局块` 中声明，对整个程序可见。
1. 包级别的声明，可被包内的任何文件引用，具有包级别的作用域，对整个包可见。
1. 导入的包是文件级别的，仅在一个文件内可见。
1. 块内的声明仅在块内可见。
1. 全局 -> 包 -> 文件 -> 函数/块
1. 当编译器遇到一个名字引用时，将从内而外的进行名字查找。


## 基本数据类型

Go的数据类型分四大类：基础类型、聚合类型（数组、结构体）、引用类型（指针、切片、字典、函数、通道）、接口类型

### 整数

    ```go
    int、int8、int16、int32、int64
    uint、uint8、uint16、uint32、uint64
    ```

    ```go
    byte int32同义词，强调原始数据（二进制）而非数值
    rune int32同义词，表示Unicode码点
    uintptr 足以存放指针
    ```

    -(2^n-1) ~ (2^n-1 - 1)
    0 ~ (2^n-1)

    ```go
    * / % << >> & &^
    + - | ^
    == != < <= > >=
    &&
    ||
    ```

### 浮点数

    ```go
    float32、float64
    ```

### 复数

    ```go
    complex64、complex128
    ```

### 字符串

### 四个标准库：

`bytes strings strconv unicode`

strings提供用于搜索、替换、比较、修整、切分、连接字符串
bytes用于操作字节slice
strconv主要提供转换布尔值、整数、浮点数为与之对应的字符形式
unicode包备有判别文字符号值特性的函数

### 常量

## 复合数据类型

基本类型是原子，复合类型就是分子

### array

数组是具有固定长度且拥有零个或多个相同数据类型元素的序列。

使用方法与C类似，但GO中数组名是一个值，而C中数组名是一个指针。

```go
var a [3]int
fmt.Println(a[0])
fmt.Println(a[len(a)-1])
```

```go
var q [3]int = [3]int{1, 2, 3}
var r [3]int = [3]int{1, 2}
```

```go
var q = [...]int{1, 2, 3}
```

数组的长度是数组的一部分，所以 `[3]int` 和 `[4]int` 是不同类型，数组的长度必须是常量表达式。

```go
type Currency int

const (
	USD Currency = iota
	EUR
	RMB
)

symbol := [...]{USD: "$", EUR: "€", RMB: "￥"}
```

```go
r := [...]int{99: -1}
```

如果数组的类型是相同的，且数组的元素类型是可比较的，那么数组也是可比较的，可通过 `==` 比较两个数组的元素是否完全相同。

调用函数时，每个传入的参数都会创建副本，然后赋值给对应的函数，所以函数接收的是一个副本，而不是原始值。这种效率很低，解决办法是显示的传递一个数字的指针。

### slice

1. `slice` 表示一个拥有相同类型的可变长度的序列。通常写作 `[]T`，看起来像没有长度的数组。
1. `slice` 是一种轻量级数据结构，可以用来访问数组的部分或全部元素，而数组称为底层数组。
1. `slice` 拥有三个属性：指针、长度、容量。指针执行数组首地址，`len()` `cap()` 分别返回长度和容量。
1. 一个底层数组可以包含在多个 `slice` 中。这些 `slice` 可以引用数组的不同位置。
1. `slice` 无法进行 `==` 操作，除了 `[]byte` 可以用 `bytes.Equal`比较，必须自行实现比较函数。
1. `slice` 唯一允许的比较操作是和 `nil` 做比较。值为 `nil` 的 `slice` 长度和容量都是0。
1. `slice` 的声明和数组的区别主要体现在长度上。

```go
s := []int(nil)
```

```go
make([]T, len)
make([]T, len, cap)
```

`make` 创建一个无名数组并返回了一个它的 `slice`，这个数组尽可以通过 `slice` 访问。

* `slice = append(slice, e...)`

将元素追加到 `slice` 后面

* `n = copy(dst, src)`

为两个拥有相同类型元素的 `slice` 复制元素，不存在越界问题。

```go
type IntSlice struct {
    ptr *int
    len, cap int
}
```

`slice` 更像似上面的结构，对数组元素是间接引用的，但是 `ptr、len、cap` 是直接引用的。

`slice[i:j]`: 0 <= i <= j <= cap(slice)

字符串子串操作 和 字节slice切片操作 非常相似，都写作 `x[m:n]`，并且都返回原始 字节的子序列，同时他们底层的引用方式也是相同的，区别在于： x是字符串，返回子串，x是字节slice，返回字节slice。

将一个 slice 传递给函数的时候，可以在函数内部

### map

```go
map[k]v
map[k]v{}
```

```go
ages := make(map[string]int)
ages := map[string]int{
    "alice"  : 31,
    "charlie": 34
}
```

```go
ages["liuyanjie"] = 27
delete(ages, "liuyanjie") // 键不存在也是安全的∆¬
```

```go
var _ = &ages["alice"] // 编译错误，无法获取 map 元素的地址
```

```go
for name, age := range ages {
    fmt.Printf("%s\t%d\n", name, age)
}
```

### struct

```go
type Employee struct {
	ID int
	Name string
	Address string
	DoB time.Time
	Position string
	Salary int
	ManagerID int
}
var dilbert Employee
```

```go
type Point struct{X, Y int}
p := Point{1, 2}
```

### JSON

### Text & Template

## 函数

## 方法

## 接口

1. 接口类型是对其他类型行为的概括和抽象
1. 很多面向对象的语言都有接口这个概念，Go语言的接口的独特之处在于他的接口是 隐式实现 的。即，对于一个具体类型，无需声明它实现了哪些接口，只要提供接口要求的方法即可。这种方式的好处是：无需改变已有类型的实现，就可以为这些类型创建新的接口，对于不能修改的包的类型，特别有用。

### 接口即约定

约定：右操作数 满足 左操作数 的要求，具体类型要求类型完全一致，接口类型要求方法满足。

具体类型指定了它所包含的数据的精确布局，还暴露了基于这个精确布局的内部操作。所以，知道了数据的具体类型，就精确的知道了他是什么以及他能干什么。

接口是一种抽象类型，它并没有暴露所包含的数据的布局和内部结构，当然也没有那些数据的基本操作，它说提供的仅仅是一些方法而已。

用接口类型定义一个数据的时候，要求实际的数据满足接口类型约定的函数，而不再是严格的具体类型的全部条件，放宽了条件。

当拿到一个接口类型的数据值，你无从知道他是什么，但是你能知道他能做什么，精确地说就是他能提供哪些方法。

```go
package io

type Reader interface {
	Read(p []byte) (n, int, err error)
}

type Writer interface {
	Write(p []byte) (n, int, err error)
}

type Closer interface {
	Close() error
}

// 嵌入接口
type ReadWriter interface {
	Reader
	Writer
}

// 嵌入接口
type ReadWriterClose interface {
	ReadWriter
	Closer
}
```

如果一个类型实现了 一个接口的所有方法，那么这个类型实现了 这个接口。

Go 程序员通常说一个具体类型 `是一个is-a` X接口，这代表着该具体类型实现了该接口。

### 接口值

一个接口的值分为两个部分：一个具体类型（动态类型），该类型的具体值（动态值）。

对于像Go这样的静态类型语言，类型是编译时概念，所以类型不是一个值。类型描述符 提供了每个变量的具体信息，对应一个接口，类型部分就由对应的类型描述符表达。

接口的零值就是把接口值的两个部分都赋值为 `nil`。

```go
struct {
    type: nil
    value: nil
}
```

将一个具体类型的值 赋值 给一个 接口类型 的 变量时，类型赋值给 接口值的类型，值赋值给 接口类型的值。同时编译器会检查 是否符合接口类型值的要求。

## 反射

https://segmentfault.com/a/1190000006190038
https://blog.golang.org/laws-of-reflection

* 反射第一定律：反射可以将“接口类型变量”转换为“反射类型对象”。
* 反射第二定律：反射可以将“反射类型对象”转换为“接口类型变量”。
* 反射第三定律：如果要修改“反射类型对象”，其值必须是“可写的”（settable）。

使用反射绝大部分情形是因为我们使用了接口，因为使用接口，使得程序无法获取变量的运行时的动态类型，而如果程序对于变量的实际类型有要求，那么我们就需要在运行时获得变量的实际类型，即接口值的动态类型。

接口对赋给变量的值进行有针对性的约束。

## goroutine & channel

## 测试

> 我强烈的意识到我的余生的很大一部分时间都将用来的寻找我程序中的错误
> --- 《一个计算机先驱的回忆》

`go test`
