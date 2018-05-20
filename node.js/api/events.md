# Events

## EventEmitter

* ~~EventEmitter.listenerCount(emitter, eventName)~~
* EventEmitter.defaultMaxListeners

## Events

* Event: 'newListener'
* Event: 'removeListener'

## Interfaces

* emitter.once(eventName, listener)
* emitter.on(eventName, listener)
* emitter.addListener(eventName, listener)
* emitter.prependListener(eventName, listener)
* emitter.prependOnceListener(eventName, listener)
* emitter.emit(eventName[, ...args])
* emitter.eventNames()
* emitter.listenerCount(eventName)
* emitter.listeners(eventName)
* emitter.removeAllListeners([eventName])
* emitter.removeListener(eventName, listener)
* emitter.setMaxListeners(n)
* emitter.getMaxListeners()

## Examples

```js
const util = require('util');
const EventEmitter = require('events').EventEmitter;

function Pulser(){
  EventEmitter.call(this);
}
util.inherits(Pulser, EventEmitter);

Pulser.prototype.start = function () {
  this.id = setInterval(() => {
    util.log('>>>>pulse');
    this.emit('pulse');
    util.log('<<<<pulse');
  }, 1000);
}

const pulser = new Pulser();
pulser.on('pulse', () => { util.log('----pulse:1'); });
pulser.on('pulse', () => { util.log('----pulse:2'); });
pulser.on('pulse', () => { util.log('----pulse:3'); });
pulser.start();
```

Note：

* 从 `emit('pulse')` 到 `on('pulse')` 是同步调用的，即，相当于通过 事件 的方式在系统相应的位置植入 钩子 函数。
* 多个 `on('pulse')` 之间是按顺序同步调用的

Asynchronous：

```js
porcess.nextTick(() => {
  this.emit('pulse');
});
```

这种方式将 `emit()` 延迟到下一次 事件循环，由于 `nextTick()` 级别较高，所以在 `start()` 函数之后（或JavaSript调用栈为空）即被调用。

