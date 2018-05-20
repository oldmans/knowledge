# Error

* http://syaning.com/2015/08/10/asynchronous-error-handling/
* https://cnodejs.org/topic/5867d6be9ff78bc36af0440d

## 异步函数异常

异步函数内，进入异步调用之后抛出的异常是无法被捕获的，通常异步函数的回掉函数在 异步调用 完成之后才被调用，所以也是无法被捕获的。


一般情况下，我们会使用 `try-catch` 来进行异常处理，例如：

```js
function sync() {
	throw new Error('sync error');
}

try {
	sync();
} catch (err) {
	console.log('error caught:', err.message);
}

// error caught: sync error
```

然而对于异步函数，`try-catch`就无法得到想要的效果了，例如：

```js
function async() {
	setTimeout(function timeout() {
		throw new Error('async error');
	}, 1000);
}

try {
	async();
} catch (err) {
	console.log('error caught:', err.message);
}

// Uncaught Error: async error
```

执行阶段：

* 阶段1：JS 代码开始运行时，不会马上启动事件循环，而是会依照 Run-to-completion 会从头到尾执行同步代码。
* 阶段2：同步代码执行完毕后，才会启动事件循环以监听事件。

`try ... catch` 作为同步代码的异常捕获语句，是在阶段 1 执行的，异步的错误，发生阶段 2。.

稍微一想，可知：已经执行完毕的 `try ... catch` 不可能捕获到在它执行完毕后所发生的错误。

简单来说，因为 `async()` 立刻返回，`try-catch` 语句已经执行完成退栈了，`timeout()` 在被调用时，也已经脱离了原来的上下文当中，所以无法捕获。

异常产生时，`try-catch` 已经不在了。

解决方式就是通过参数传递 `err`：

* callback error first
* promise internal state transfer
* generator/yield
* async/await based on promise

异步异常本质上时无法捕获的，但是可以通过一定的手段转换为同步的可捕获的异常，如 `generator/yield`、`async/await`。
