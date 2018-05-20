# Understand Stream

> Added in: v0.9.4

## 流是什么？

* 流是一种高级别的抽象，目的是为了方便理解，简化应用程序对`IO对象`的读写操作。
* 流是一种高级别的抽象，那么就不能直接只用`Stream`，而应该使用流的`Implementation`。
* 流定义和实现了一套 *接口* 和 *内部机制* ，但是需要流的实施者实现流对 *src/dst* 的读写。
* 流的核心在于 *自动* 和 *管道*。*自动* 源源不断的从数据源读取数据直到全部数据读取完成，使用者只需要监听相关事件。*管道* 可以将 `Readable` 和 `Writable` 连接到一起，并自动传递数据。
* 流的内部分别有 *读写缓冲区*，并实现相应状态管理机制，通过缓冲区自动调节流速。
* 流的实现者 主要就是实现 `Stream` 与 *src/dst* 交互，*src/dst* 可以是文件、网络、终端等，甚至是一个函数的输入参数和返回值。
* 流的使用者 主要使用流的 *接口* 或 *事件* 来访问流。

## Class: stream.Readable

`Readable` 有两种模式：流动模式、停顿模式。

* 在 流动模式 下，流自动的从底层读取数据，并通过 `EventEmitter` 事件接口 通知流数据消费者。
* 在 停顿模式 下，需要 数据消费者 主动 调用 `read` 函数读取数据，直到读取需要的全部的数据，这通常需要一个循环，实现需要更多代码。

创建一个 `const readable = new Readable()` 并不会触发 流 开始从底层数据源读取数据，即： 流 开始处于 停顿模式。

切换到 流动模式 的方式:

* Adding a `'data'` event handler.
* Calling the `stream.resume()` method.
* Calling the `stream.pipe()` method to send the data to a Writable.

切换回 暂停模式 的方式:

* If there are no pipe destinations, by calling the `stream.pause()` method.
* If there are pipe destinations, by removing any `'data'` event handlers, and removing all pipe destinations by calling the `stream.unpipe()` method.

注意：要避免 切回 暂停模式:

* 流动模式 是期待的使用方式，也是最佳实践
* 切换模式 需要更多的代码及状态管理，难以控制

监听 `'readable'` 或 `'data'` 事件，将触发 在下个事件循环 调用 `read(0)` 从底层数据源 读取数据`push(data)`到缓冲区，并 `emit('readable')` 和 `emit('data', data)`。

* 在 流动模式 下，如果没有消费者 `on('data', handle)` 消费数据，将会导致数据丢失，数据被忽略了。
* 在 停顿模式 下，如果数据没有 机制 被消费（数据被忽略也算被消费），流 将停止 生产数据。

### Events

* `'readable'`：通知有数据可读，此时即可调用 `read(n)` 读取数据
* `'data'`    ：流将数据从流缓冲区取出并传递给消费者
* `'close'`   ：流或者底层数据源关闭 `close()`，之后不会再有其他事件产生
* `'end'`     ：流中没有更多数据可以消费
* `'error'`   ：读取过程中产生错误，如：底层错误、流的实现有错误、数据无效等，几乎不会有使用者的错误

### interfaces

* readable.read([size])

* readable.isPaused()
* readable.pause()
* readable.resume()

* readable.pipe(destination[, options])
* readable.unpipe([destination])

* readable.unshift(chunk)

* readable.setEncoding(encoding)

* readable.wrap(stream)

## Class: stream.Writable

相比 `Readable`，`Writable` 更简单。

### Events

* `'drain'`   ：当 `Writable` 写缓冲区满了之后，继续 `write() => false`，等待 缓冲区 排干之后才能继续写，`'drain'` 就是排干的信号。
* `'finish'`  ：`stream.end()`调用 且 数据 刷新到底层系统，将触发此事件。 
* `'close'`   ：流或者底层数据源关闭 `close()`，之后不会再有其他事件产生
* `'error'`   ：写入过程中产生错误，如：底层错误、流的实现有错误，操作错误如：`'write after end'`
* `'pipe'`    ：`readable.pipe(writable)`
* `'unpipe'`  ：`readable.unpipe(writable)`

```js
// Write the data to the supplied writable stream one million times.
// Be attentive to back-pressure.
function writeOneMillionTimes(writer, data, encoding, callback) {
  let i = 1000000;
  write();
  function write() {
    var ok = true;
    do {
      i--;
      if (i === 0) {
        // last time!
        writer.write(data, encoding, callback);
      } else {
        // see if we should continue, or wait
        // don't pass the callback, because we're not done yet.
        ok = writer.write(data, encoding);
      }
    } while (i > 0 && ok);
    if (i > 0) {
      // had to stop early!
      // write some more once it drains
      writer.once('drain', write);
    }
  }
}
```

### interfaces

* writable.write(chunk[, encoding][, callback])
* writable.end([chunk][, encoding][, callback])
* writable.cork()
* writable.uncork()
* writable.setDefaultEncoding(encoding)

## pipe

|Readable    |Writable   |
|------------|-----------|
|`pipe()`    |`'pipe'`   |
|`unpipe()`  |`'unpipe'` |
