# 函数

## 函数声明

```go
func name(parameter-list) (result-list) {}
```

函数声明包含：`函数名称`、`参数列表`、`返回列表`

返回列表：当函数返回一个未命名的返回值或没有返回值时，`result-list` 外层括号可省略。返回值可像形参一样具有名字，这时候，每个命名的返回值会声明为一个局部变量并根据类型初始化为相应的0值。当函数存在返回列表时，必须显示的以 `return` 语句结束。

以下两种函数声明等价

```go
func f(i, j, k int, s, t string) {}
func f(i int, j int, k int, s string, t string) {}
```

```go
func add(x int, y int) int { return x + y }
func sub(x, y int) (z int) { z = x - y; return}
func first(x, _ int) (int) { return x }
```

函数的类型：即`函数签名`，当两个函数具有相同的形参列表和相同的返回列表时，认为两个函数的签名是相同的，即类型是相同的。

函数参数没有默认值的概念，也不能指定实参名。函数形参和命名返回值同属于函数最外层作用域的局部变量。实参是按值传递的，所以函数接收到的是每个实参的副本，然而如果传递的是引用类型（pointer、slice、map、func、channel），实参是引用类型的拷贝，可通过形参变量间接的修改实参变量。

## 递归调用


## 多返回值

1. 最后一个返回值返回error类型的错误信息
2. 返回值不要太多，通常是：`(result interface{}, err error)`
3. 显示返回，避免裸写，易于理解

## 错误处理

1. 有些函数（不多）总是成功返回的，比如：`strings.Contains` `strconv.FormatBool` 等
2. 有些函数（不多）只要符合前置条件总是成功返回的，比如 `time.Date` 函数的最后一个参数为 `nil` 会导致崩溃，这意味着这是一个明显的 `bug`，应该避免这样使用
3. 有些函数（很多），即使在高质量的代码中，也不能保证一定能够成功返回，因为有些外部因素不受程序设计者掌控，比如常见的 `IO操作`，事实上，这是我们最需要关注的地方，很多地方可能会毫无征兆的发生错误。


因此，错误处理时包的API设计或者应用程序接口设计的重要部分，发生错误知识许多`预料的行为`中的一种而已。这就是GO语言错误处理的方法。

习惯上，将错误值作为最后一个返回值返回。如果错误只有一种情况，即失败，结果通常是 `boolean` 类型，变量名称是 `ok`。

error interface:

```go
type error interface {
    Error() string
}

type NotFoundError struct {}

func (e NotFoundError) Error() string {
    return fmt.Sprintf("NotFound")
}

var err error = errors.New("this is a new error")
var err error = fmt.Errorf("%s", "the error test for fmt.Errorf")
```

一个错误可能是一个空值nil或一个非空值，空值意味着成功而非空值意味者失败。当一个函数返回一个非空值时，其他的结果都认为是未定义的且应该忽略。某些情况下，可能发生错误，但是返回了部分有用的结果，正确的行为通常需要先处理这些不完整的返回值。

Go语言使用普通的值而非异常来报告错误，尽管Go有异常机制，但是Go语言异常值是针对程序bug导致的预料外的错误，而不能作为常规处理方法出现在程序当中。
异常会陷入带有错误信息的控制流去处理它，通常会导致预期外的结果：错误会以难以理解的栈跟踪信息报告给最终的用户，这些信息大都是关于程序结构方面的信息，而不是简洁明了的错误信息。
Go语言使用通常的控制流机制应对错误，这种方式在错误处理方面要求更加谨慎，但这恰恰是程序设计的要点。


错误处理策略：

当一个函数返回一个错误时，调用者应当负责检查错误并采取合适的处理应对。

1. 首先，最常见的情景就是将错误传递下去，使得在子例程中发生的错误变为主调历程的错误。

    将错误传递下去有时候需要添加额外相关的上下文信息来建立一个可读的错误描述。

    ```go
    if err != nil {
        return nil, fmt.Errorf("Read Error Path: %s", path, err)
    }
    ```

2. 对于固定的或不可预测的错误如IO错误，在短暂的时间间隔后对操作进行重试是合乎情理的，超出一定的重试次数和时间后在报错退出。

3. 如果已经不能顺利进行下去，调用者能够输出错误然后优雅的停止程序，但一般这样的处理应该留给主程序部分。

    ```go
    fmt.Fprintf(os.Stderr, "Site is down: %v\n", err)
    os.Exit(1)

    log.Fatalf("Site is down: %v\n", err)
    ```

4. 在某些情况下，错误并不影响程序，只记录错误信息然后程序继续运行。

5. 在某些罕见的情况下，我们可以直接完全的忽略掉整个日志，比如写入日志操作本身失败。

Go语言错误处理有特定的规律：进行错误检查之后，检查到的失败的情况往往都在成功之前。如果检查到失败导致函数返回，成功的逻辑一般不会放在 `else` 作用域中，因为在检查到错误时通常将错误返回给上层函数，而不会走成功的逻辑，错误处理通常应返回到整个逻辑（不一定是整个应用程序）的最外层，而不是应该内部消化，除非错误可以修复。函数会有一种通常的形式，在开头有一连串的检查用来返回错误。

错误可以分为：

* 操作失败

    操作失败是所有正确的程序应该处理的错误情形，只要被妥善处理它们不一定会预示着Bug或是严重的问题。

    是正确编写的程序在运行时产生的错误。它并不是程序的Bug，反而经常是其它问题：系统本身（内存不足或者打开文件数过多），系统配置（没有到达远程主机的路由）， 网络问题（端口挂起），远程服务（500错误，连接失败）。

    处理办法：
    * 直接处理
    * 把出错扩散到客户端
    * 重试操作
    * 直接崩溃
    * 记录错误，其他什么都不做

* 程序员的失误

    是程序里的Bug。这些错误往往可以通过修改代码避免。它们永远都没法被有效的处理。

    处理办法：最好的从失误恢复的方法是立刻崩溃。

操作失败是程序正常操作的一部分。而由程序员的失误则是Bug。

类似的，如果不处理好操作失败, 这本身就是一个失误。

panic/recover

## 函数类型

函数的类型：即`函数签名`，当两个函数具有相同的形参列表和相同的返回列表时，认为两个函数的签名是相同的，即类型是相同的。

在Go语言中，函数是一等公民，如同其他值一样，函数变量拥有类型，而且他们可以赋值给变量或者作为参数传递。

函数类型的零值是：`nil`，调用一个值为 `nil` 的函数变量将导致崩溃。

函数是一种引用类型，函数类型的值可以进行比较。

## 匿名函数

命名函数只能在包级别的作用域进行声明，即不能再任何函数内声明函数。但是能够使用`函数字面量`表达式内指定函数变量。

`匿名函数`不能作为类型的`方法`，因为匿名函数无名字，无法被访问。

`匿名函数` 只能 `立即调用` 或通过 `引用调用`。

闭包：使得函数能拥有内部状态。

## 变长函数

变长函数在调用时可以有可变的参数个数。

```go
func sum(vals ...int) int {
	total := 0
	for _, v := range vals {total += v}
	return total
}

sum([]int{1, 2, 3}...)
```

## defer

语法上，`defer` 语句就是一个普通的函数或方法调用，在调用前加上 `defer` 关键字，`defer` 将调用延迟到函数执行完。

`defer` 语句无次数限制，执行时与 `defer` 调用的顺序相反。

`defer` 语句通常用于成对的操作上，比如打开关闭、连接断开，加锁解锁。

`defer` 语句也可以用来调试一个复杂函数，即在函数 `入口` 和 `出口` 出设置调试行为。

`defer` 执行的函数在 `return` 后执行，并且可以更新函数的命名返回值，所以也可以在函数完成时打印执行结果。

defer 的思想类似于C++中的析构函数，不过Go语言中“析构”的不是对象，而是函数，defer就是用来添加函数结束时执行的语句。

## panic/recover

`painc` 用于 “抛出” 异常, `recover` 用于 “捕获” 异常。

```go
func main () {
	defer func () {
		fmt.Println(recover())
	}()
	panic(123)
	return
}
```

`recover()` 可以像任何其他函数一样在语法允许的位置调用，但是只有在 `defer` 中调用才有可能 “捕获” 异常，这意味着 `panic` 异常处理只能在 `defer` 函数内进行。

https://ieevee.com/tech/2017/11/23/go-panic.html

## 方法

方法是某种特定类型的函数，需要通过特定类型的对象调用。

面向对象编程的两个原则：封装、组合。

### 方法的声明

```go
func (t Target) name(parameter-list) (result-list) {}
```

方法的名字：`Target.name`

与普通的函数声明相比增加了 `接收者`，用来描述调用方法就像向对象 `发送消息`，也就是方法的 `作用对象`。

与其他语言不同，`接收者` 是作为一个参数传递给函数的，而不是使用特殊的名称如 `this`、`self` 等，`接收者` 的名字会被频繁的使用，因此最好选择简短且在整个方法中名称始终保持一致的名字。

与其他语言不同，可以将方法绑定到任何类型（除了`指针类型`和`接口类型`）上。可以很方便的为简单类型（如：`int*、uint*、string、slice、map`）定义附加行为。

> 注意：只能在包内为包内的类型声明方法，即限制只有包的创建者或开发者可以声明方法，避免方法泛滥。

```go
// 定义新类型
type MyInt int
func (i MyInt) Show() {} // success

// 类型别名
type IntAlias = int
func (i IntAlias) Show() {} // cannot define new methods on non-local type int
```

无效的接收者：

```go
type PType *Type
func (pT Type) Show() {} // invalid receiver type PType (PType is a pointer type)

type EmptyInterface interface {}
func (ei EmptyInterface) Show() {} // invalid receiver type EmptyInterface (EmptyInterface is an interface type)
```

### 指针接收者

由于主调函数会复制每个实参变量，如果函数需要更新变量，或者避免复制整个实参，我们必须使用指针来传递变量的地址，这也同样适用于`接收者`，这时需要`指针类型的接收者`

即：

```go
func (t *Target) name(parameter-list) (result-list) {}
```

方法的名字：`(*Target).name`，而不是`*(Target.name)`

习惯上，如果 `Target` 的任何方法使用指针接收者，那么 `Target` 的所有方法都应该使用指针接收者，即使有些方法并不需要。

命名类型 `Target` 与 指向它的指针 `*Target` 是唯一可以出现在接收者声明处的类型。

```go
type Point struct{X, Y float64}

func (p * Point) ScaleBy(factory float64) {
	p.X *= factory
	p.Y *= factory
}
func main () {
	p := Point{1, 2}

    // 编译器对 `p` 进行 `&p` 的隐式转换，所以以下两种方式等价。
    // 但是只要变量才允许这样写，不能对不能取地址的进行类似调用。
	(&p).ScaleBy(3)
    p.ScaleBy(3)
    
    // cannot call pointer method on Point literal
    // cannot take the address of Point literal
    Point{1, 2}.ScaleBy(3)
}
```

三种情况：

1. 实参接收者类型 和 形参接收者类型 是同一种类型，都是 `T` 或 都是 `*T`
    直接传递 `T` 或 `*T`
2. 实参接收者类型是 `T ` 而 形参接收者类型是 `*T`
    编译器会隐式的获取 `T` 的地址，然后传递地址值
3. 实参接收者类型是 `*T` 而 形参接收者类型是 `T `
    编译器会隐式的获取 `*T` 的实际值，然后传递实际值


> `nil` 是某些类型的合理值，所以 `nil` 是一个合法的接收者

### 组合：通过结构体内嵌组合类型

```go
type Point struct{X, Y float64}

func (p * Point) ScaleBy(factory float64) {
	p.X *= factory
	p.Y *= factory
}

type ColoredPoint struct {
	Point
	Color 	color.RGBA
}
```

`ColoredPoint` 包含 `Point` 类型所有 `字段`，当然包括 `Point`的 `方法`。

### 封装：通过结构体数据隐藏封装

要封装一个对象必须使用 `结构体`

Go语言封装的单元是包而不是类型，结构体类型的字段 无论是函数内还是方法内 在同一个包内都是可见的。

