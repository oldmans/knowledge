# Defer

理解 `defer` 调用的一个关键点：`return x` 这一条语句并不是一条原子指令!

```go
func f() (result int) {
    defer func() {
        result++
    }()
    return 0
}
```

相当于以下函数，`defer` 函数 在 `返回变量赋值` 和 `return` 之间执行。

```go
func f() (result int) {
    result = 0
    func() {
        result++
    }()
    return
}
```

当有多个 `defer` 存在时，`defer` 函数执行的顺序与 `defer` 调用的顺序相反，所以 `defer` 调用类似入栈操作。
