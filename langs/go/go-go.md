# Goroutine & Channel

## Goroutine

`Goroutine` 是 `go` 程序的并发执行体

在Go中，每个并发执行的活动称为 `goroutine`，当一个Go程序启动时，只有一个 `goroutine` 来调用main函数，它是主 `goroutine`。通过 `go` 关键字可以创建新的 `goroutine`，`go` 语句使函数在一个新创建的 `goroutine` 中被调用。`go`语句本身的执行立即完成。

spinner.go

```go
package main

import (
	"fmt"
	"time"
)

func spinner(delay time.Duration) {
	for {
		for _, r := range `-\|/` {
			fmt.Printf("\r%c", r)
			time.Sleep(delay)
		}
	}
}

func fib(n int) int {
	if n < 2 {
		return n
	}
	return fib(n - 1) + fib(n - 2)
}

func main () {
	go spinner(100 * time.Millisecond)
	const n = 45
	fibN := fib(45)
	fmt.Printf("\rFibonacci(%d) = %d\n", n, fibN)
}
```

## Channel

`Channel` 是 `Goroutine` 之间的连接，`Channel` 是 `Goroutine` 间传输数据的通道，这个通道是一个具体类型的导管，叫做通道的 `元素类型`。

`Channel` 是一个普通的数据类型，其内部需要引用的数据类型。

`Channel` 是一种 引用，零值是 `nil`

`Channel` 是可比较的，当两个通道引用了同一通道数据时，比较结果为 `true`。

`Channel` 的两种 主要操作：`发送`、`接收`，统称为通信。通道还有 `关闭` 操作。

```go
ch := make(chan int)
ch <- // 发送
<- ch // 接收，此操作会阻塞
close(ch)
```

在同一 `Goroutine` 内 `发送` 和 `接收` 数据容易造成死锁

`Channel` 容量：

* =0 - `无缓冲通道`，在无缓冲通道上的发送操作会阻塞，直到有另外一个 Gotoutine 在对用的通道上执行接收操作，这时，数据传送完成，两个 Goroutine 都可以继续执行。先发操作将阻塞，后发操作将解除先发操作的阻塞。无缓冲通道使得 `发送和接收` 同步化，因此也称为 `同步通道`。
* >0 - `有缓存通道`

`Channel` 可以实现 管道。

`Channel` 在使用的时候一定要判断是否关闭，否则容易出现错误。在接收端可以使用 `range` 接收数据。

`Channel` 不是必须关闭的，只有需要通知接收方所有数据发送完毕时才需要关闭通道，通道可以根据它是否可以访问来决定是否可以被GC回收，而不是根据它是否被关闭。关闭一个已经关闭的通道将导致崩溃。`关闭` 操作需要在发送端进行。

`Channel` 可以作为参数传递，当一个 `Channel` 作为参数传递是，它总是有意的被限制为 只能发送 或 只能接收。只能发送：`chan<- int`，只能接收：`<-chan int`。只能在支持发送的通道上调用 `close` 函数。

通道属性：

* 通道容量：cap(ch)
* 通道用量：len(ch)

## 共享变量

一个能在串行程序中正常工作的函数，如果这个函数能在并发调用时仍然能够正常工作，那么这个函数是`并发安全`的。

让一个程序并发安全并不需要程序中的每个具体的类型都是并发安全的，实际上并发安全的类型是个特例，而不是普遍存在的，所以仅在文档指出的情况下，才可以认为是并发安全的。

对于绝大部分变量，如要回避并发访问，要么限制变量只存在于一个goroutine内，要么维护一个更高级别的`互斥不变量`。

导出的包级别的函数通常可以认为是并发安全的。因为包级别的变量无法现在在一个goroutine内，所以那些修改这些变量的函数就必须采取互斥机制。

```go
balance = balance + amount
```

如上代码编译之后实际上存在`读写`两个步骤，在读写之间存在`时间窗口`，可能存在其他的goroutine同时读写balance，带来严重的问题。

内存同步问题：

如果两个goroutine在不同的CPU上执行，每个CPU都有自己的缓存，那么一个goroutine的写入操作在同步到内存之前对应另外一个goroutine的读取操作是不可见的。

应尽可能杜绝在多个goroutine中同时操作同一变量的行为。

数据竞态解决方法：

1. 不要修改变量
	对于一次性初始化之后就不再变化的变量，在其他goroutine访问之前就完成初始化。
2. 避免从多个goroutine中访问同一变量
	由于其他goroutine无法直接访问变量，因此他们就必须通过通道向受限的goroutine发送读写请求。
	go箴言：`不要通过共享内存来通信，而应该通过通信来共享内存`
3. 允许多个goroutine访问同一变量，但是同一时间只有一个goroutine访问，增加互斥锁
	同样是保证非并发的访问共享变量

锁：

```go
sync.Mutex
sync.RWMutex
sync.Once
```

竞态检测器：

```sh
go build -race
go run -race
```

## goroutine VS thread

1. 栈

	thread拥有固定的栈内存，通常是2MB，goroutine的栈内存是不固定的，它可以按需增大或缩小，通常开始时是2KB，最大可大1GB。

2. 调度

	OS线程有OS内核调度，每隔几毫秒就会有个硬件中断发送到CPU，CPU进行线程调度。线程的调度需要完整的上下文切换，即保存线程状态到内存，再恢复另外一个线程的状态。
	Go运行时包含一个内置的调度器，实现一个叫`m:n`的调度技术，它可以调度m个goroutine到n个线程上。因为不需要切换上下文，所以goroutine比调度一个线程成本低很多。

3. GOMAXPROCS

	Go调度器通过`GOMAXPROCS`环境变量确定需要使用多少个OS线程来执行Go代码，即`m:n`中的`n`。默认值未CPU数量。

4. 标识

	goroutine没有标识
