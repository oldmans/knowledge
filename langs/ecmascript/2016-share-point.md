# 2016年会分享

Node.js开发过程中几个核心问题原理分享

## 一、JavaScript Core

### 1.1 对象构造和原型链继承

### 1.2 执行上下文堆栈

### 1.3 执行过程

### 1.4 JavaScript 线程模型

众所周知，JavaScript 是单线程运行的。

#### 为什么 JavaScript 是单线程的？

单线程是相对多线程而言的，假如没有多线程这个概念，那么就不会有这个问题存在了。

那为什么会存在这个问题呢？

单线程通常都有一个严重的问题，就是代码会被耗时操作阻塞，整个运行逻辑将会卡在这里，无法利用多线程的处理方式实现并发，难道 JavaScript 的应用场景中不会遇到阻塞的问题？显然不是的，然而 JavaScript 却依然选择了单线程的方式。

一定是 JavaScript 以某种模式实现了 非阻塞、并发，使得 JavaScript 可以选择单线程的运行模式。
假如 JavaScript 没有实现 非阻塞、并发，那么 JavaScript 也不会选择单线程的方式运行了。

所以引出了另外的问题： JavaScript 如何用单线程实现并发？

JavaScript 是以单线程的方式运行的，说到线程就自然联想到进程。

进程是应用程序的执行实例，每一个进程都是由私有的 *虚拟地址空间*、*代码*、*数据* 和 *其它系统资源* 所组成；

线程则是进程内的一个独立执行单元，不同的线程可以共享进程资源。

在系统创建进程之后就开始启动执行进程的主线程，而进程的生命周期和这个主线程的生命周期一致，主线程的退出也就意味着进程的终止和销毁。

主线程是由系统进程所创建的，同时用户也可以自主创建其它线程，这一系列的线程都会并发地运行于同一个进程中。

显然，在多线程操作下可以实现应用的 *并行* 处理，从而以更高的CPU利用率提高整个应用程序的 *性能* 和 *吞吐量*。

特别是现在很多语言都支持多核并行处理技术，然而 JavaScript 却以单线程执行。

既然多线程原生的就支持并发，且可以避免阻塞，那么问题来了

#### 为什么 JavaScript 不采用多线程？

网上很多地方都说这和它的历史有关系，这样的答案并不能说明其本质。
一个根本原因——*避免死锁*。

作为浏览器脚本语言， JavaScript 的主要用途是与用户交互以及操作DOM，若以多线程的方式操作这些DOM，则非常容易出现操作的冲突。

假设有两个线程同时操作一个DOM元素，DOM元素称为线程之间的共享数据，*线程1* 要求浏览器删除DOM，*线程2*却要求修改DOM样式，这时浏览器就无法决定采用哪个线程的操作。
当然，我们可以为浏览器引入*锁* 的机制来解决这些冲突，但这会大大提高复杂性，所以 JavaScript 从诞生开始就想办法避免这个问题，选择了单线程执行。

实际上，多线程的GUI框架特别容易死锁。[《Multithreaded toolkits: A failed dream?》](https://community.oracle.com/blogs/kgh/2004/10/19/multithreaded-toolkits-failed-dream)描述了其中的缘由，

大致是说GUI的行为大多都是从更抽象的顶部一层一层调用到操作系统级别，而事件则是反过来，从下向上冒泡，结果就是两个方向相反的行为在碰头，给资源加锁的时候一个正序，一个逆序，极其容易出现互相等待而饿死的情况。
AWT最初其实就是想设计成多线程的，但是使用者非常容易引起死锁和竞争，最后 Swing 还是做成了单线程的。
但凡这种 *EventLoop+单线程* 执行的模式，我们还可以找到很多，比如 JDK 的 GUI 线程模型，主线程就是一个 *主事件循环* ，还有 MacOS/iOS 的 Cocoa 等等，都是这样的模式。

以上内容解释了 JavaScript 不使用多线程的原因：一个多线程的程序容易死锁，不好控制。另外一关键原因是，单线程同样有办法实现非阻塞、并发的效果，并能解决多线程的问题。

Links：

* https://segmentfault.com/a/1190000002452587
* http://blog.leapoahead.com/2015/09/15/js-closure/
* http://jibbering.com/faq/notes/closures/
* https://en.wikipedia.org/wiki/Funarg_problem
* https://en.wikipedia.org/wiki/Closure_(computer_programming)
* http://blog.leapoahead.com/2015/09/15/js-closure/
* https://yq.aliyun.com/articles/31538
* https://jgomezb.github.io/presentations/nodejs-threading-model* 
* https://web.stanford.edu/~ouster/cgi-bin/papers/threads.pdf
* https://courses.cs.washington.edu/courses/cse451/06au/slides/os-events.ppt
* http://courses.cs.vt.edu/cs5204/fall09-kafura/Presentations/Threads-VS-Events.pdf* 
* http://ifeve.com/why-threads-bad/
* https://web.stanford.edu/~ouster/cgi-bin/papers/threads.pdf* 
* http://www.boost.org/doc/libs/1_56_0/libs/coroutine/doc/html/coroutine/motivation.html
* http://stackoverflow.com/questions/25915634/difference-between-microtask-and-macrotask-within-an-event-loop-context* 
* https://whatwg.org/
* https://html.spec.whatwg.org/
* https://html.spec.whatwg.org/multipage/webappapis.html#task-queue
* https://jakearchibald.com/2015/tasks-microtasks-queues-and-schedules/* 
* http://graphics.stanford.edu/~seander/bithacks.html
* http://stackoverflow.com/questions/466204/rounding-up-to-nearest-power-of-2* 
* http://hllvm.group.iteye.com/group/topic/37596
* http://blog.leapoahead.com/2015/09/06/understanding-jwt/

#### 为什么要 非阻塞 & 并发？

因为 JavaScript 是单线程的，所以在某一时刻内只能执行一个任务。

对于 *I/O* 等耗时的任务，如果不能跳过等待，那么整个程序逻辑，将卡在 *I/O* 操作上，这是无法接受的。

在这些任务完成前，JavaScript 完全可以往下执行其他操作，当这些耗时的任务完成后，再由 JavaScript 去处理。

实际使用的方式就是 异步、非阻塞 的 *I/O* 模型。

多线程GUI框架容易死锁，所以选择了单线程。
单线程通常的行为是同步的执行，为了不阻塞，需要采用异步的方式执行。
为了能够同时处理多项任务，所以需要实现并发。

事件上，并不是多线程的情况就不需要实现异步了，只是单线程的情况特别需要实现异步模式。

对于不可避免的耗时操作，HTML5 提出了 WebWorker，它会在当前 JavaScript 的执行主线程中利用 Worker 开辟一个额外的线程来加载和运行特定的 JavaScript 脚本。
这个 新的线程 和 JavaScript 的 主线程 之间并不会互相影响和阻塞执行，而且在 WebWorker 中提供了这个新线程和 JavaScript 主线程之间数据交换的接口：`postMessage `和 `onMessage` 事件。
但 WebWorker 不能操作DOM的，任何需要操作 DOM 的任务都需要委托给 JavaScript 主线程来执行，所以虽然 HTML5 引入 WebWorker，但是他受限的。

事实上，JavaScript 语法层面并没有定义任何线程相关的内容，大部分语言都没有在语言层面直接定义线程的相关内容。
通常线程都是作为核心库或者第三方库提供给开发者调用，所以并不是因为 JavaScript 无法实现多线程。
Node.js 就有可以支持线程的库，如：fibers、threads_a_gogo，HTML5 引入的 WebWorker 实际上是给 JavaScript 提供了多线程的支持的。

上面解释了 JavaScript 选择以单线的方式运行原因，以及其他一些相关问题， 接下来讲解 JavaScript 是如何实现并发的。

#### JavaScript 如何用单线程实现并发？

JavaScript 有个基于 *EventLoop* 的 *并发模型*，能让单线程的 JavaScript 并发的处理任务。

##### *并发(Concurency)* 和 *并行(Parallelism)*：

* 并行是指：一组程序按 独立 异步 的速度执行，不等于时间上的重叠（同一个 *时刻* 发生）。
* 并发是指：在同一个 *时间段* 内，两个或多个程序执行，有时间上的重叠（宏观上是同时，微观上仍是顺序执行）。

前者是物理上的同时发生，而后者是逻辑上的同时发生。所以，单核处理器也能实现并发。

并发和并行的区别就是 *一个处理器同时处理多个任务* 和 *多个处理器或者是多核的处理器同时处理多个不同的任务*。

[通信中的 并行 串行](https://zh.wikipedia.org/wiki/%E4%B8%B2%E8%A1%8C%E9%80%9A%E4%BF%A1)

并行也指8位数据同时通过并行线进行传送，与之相对的是串行，这样数据传送速度大大提高，但并行传送的线路长度受到限制，因为长度增加，干扰就会增加，数据也就容易出错。

一个错误的结论：*javascript是不存在并发的，并发只是看起来像并发而已*。

![并发与并行](images/并发与并行.jpg)

如上图的第一个表，由于计算机系统只有一个 CPU，故 ABC 三个程序从 *微观* 上是交替使用CPU，但交替时间很短，用户察觉不到，形成了 *宏观* 意义上的 *并发* 操作。

这种 *并发模型* 通常称为 *asynchronous* 模型 或 *non-blocking* 模型。

实际上，个人计算机的核心数只有几个，如双核、四核、八核等，但是实际上可运行成百上千的进程，而线程数则是成千上万的。这就是操作系统频繁调度进程，使得活跃进程能够轮番的到执行的结果。
JavaScript 的 并发 和 操作系统进程调度实现的 并发 如出一辙，原理非常相似，类似于 信号传输 的 时分多路复用。
不同是，操作系统是进程级别的调度，而 JavaScript 引擎则是 Event（执行上下文） 级别的调度。
另外一点是，操作系统不能允许一个进程长时间占有CPU，以保证其他程序能够有机会得到执行，而 JavaScript 则不然。


了解了并发的概念及原理，接下来就要了解下 调度的 实现 机制是怎样的。


##### [Event_loop](https://en.wikipedia.org/wiki/Event_loop)


WiKiPedia:

> In computer science, the event loop, message dispatcher, message loop, message pump, or run loop is a programming construct that waits for and dispatches events or messages in a program. 

> 在计算机科学中，事件循环、消息分派、消息循环、消息泵、RunLoop 是一种 在程序中 等待分派 消息 和 事件 的 编程结构。

之所以被称为 EventLoop，因为它用类似以下方式实现：

```js
// other code
function EventLoop() {
  while(event = getNextEvents()){
    // 事件 是由 异步函数的回掉函数处理，
    // 也就是 processEvent 获取 原来 传递的回掉函数，
    // 进入其执行上下文。
    event.processEvent();
  }
}
EventLoop();
```

EventLoop 绝不能阻塞，即 `processEvent` 函数不应该执行 *“太久”*，如果执行阻塞，下一个事件的处理将会延迟，甚至是得不到处理，如死循环的情况。

所以 `processEvent` 要避免 进行 耗时 操作，如多层嵌套循环，也 避免进行 同步的 I/O 操作，否则，程序将长时间停在这里，在浏览器上，表现为：无响应，在Node.js上，表现为：其他请求无法被处理。

事实上，在 GUI 程序中，都采用 单线程 事件循环 的方式来处理 GUI 逻辑，就是因为多线程 GUI 容易死锁，难以控制。浏览器、Android、iOS。

事件 是从 事件队列 中获取的，那么接下来就需要了解下 事件队列 了。

另外一个非常重要的一点是：`EventLoop` 实际上并不是 JavaScript引擎 实现，通常由宿主环境实现，这是因为不同环境下的 事件循环 体系并不相同，往往需要根据平台定制，如 Node.js 中使用 libuv 来驱动。
JavaScript 引擎从职责上就是提供 JavaScript 执行环境，即VM，解析并执行 JavaScript 代码，管理上下文堆栈和垃圾回收等，事件循环也应该独立于引擎实现。
当然，事无绝对，也要看具体实现方式，V8引擎是这样处理的。

#### Event_Queue & Task_Queue

上面 事件循环 中的 `getNextEvents()` 轮询 事件队列 中待处理的事件，如：点击事件、定时器事件。

需要明确的是，事件队列 也可以称为 任务队列，因为 事件队列 中的 *事件处理函数*，就是即将要处理的任务，但是 这个队列的 中的内容，却代表着 触发的事件。

如果 I/O 设备完成任务 或 用户点击，那么相关 *事件处理函数* 就会进入 事件队列，当主线程处理完上一个 事件 时，就会获取 事件队列 里 下一个 待处理任务。

对于定时器，当到达其指定时间时，才会把 *事件处理函数* 插到 *任务队列* 尾部。

每当某个任务执行完后，其它任务才会被执行。也就是，当一个函数运行时，它不能被取代且会在其它代码运行前先完成。即任务不能被中断，不同于系统调度那样可能被调度器强制切换。
因此：当一个任务完成时间过长，那么应用就不能及时处理用户的交互（如点击事件），甚至导致该应用奔溃。

一个比较好解决方案是：将任务完成时间缩短，或者尽可能将一个任务分成多个任务执行，但是这需要开发人员来保证。后面将会介绍如何将一个任务拆分执行。

事件队列 也并不一定只有 一个队列，在 Node.js 中是同时存在 多个 队列的。

有了 任务队列，剩下的就是 任务队列 中的 任务 是哪里来的。

##### Async & Callback

* [回调函数](https://zh.wikipedia.org/wiki/%E5%9B%9E%E8%B0%83%E5%87%BD%E6%95%B0)
* [回调函数是什么？](https://www.zhihu.com/question/19801131)

任务是 异步函数处理完成 之后产生的，回掉函数就是接下来需要处理的任务。

回掉可以看作是一种协议，用来进行消息通知，Node.js 的 事件驱动 同样也是用来 消息通知，但同样也是由回掉函数来处理，Promise也是基于回掉的。

异步 和 回掉 不是一个整体，同步 依然 可以回调。下面这段代码，有回掉函数，但是依然是同步的，排序的每一步都需要等待 `compare` 的返回。

> Note: 从形式上来讲，同步函数和异步函数都可以有函数参数，并且在调用的过程中伴随着控制权转移，但实际上，通常回调函数都是指异步回调。

```js
function compare(l, r) {
  return l - r;
}
sort(compare);
```

通常回调函数表达的是函数执行流的返回，所以叫 `callback``·“ Don't Call Me, I'll Call You ”`。
这里有个 概念上的问题，即：同步函数的函数参数，能否称为回掉。因为这会影响到 异步和回掉 是不是 一个整体概念。不过我们不纠结于这个概念问题。
暂且认为，同步函数的函数参数不应该称为回掉函数，那这个函数不应该被称为回调函数。

异步函数 的 回掉函数 在 异步函数 执行完成之后，表现为被调用，实际上只是被放入了任务队列。异步函数内部都是由底层实现，暴露接口道JS运行环境中，回调函数在传递到底层之后，会被封装成底层的函数对象，封装之后的函数在执行的时候回将真正的回调函数放入任务队列中等待调度执行。

> 注意：同步函数 是不能将 回掉函数 放入 任务队列 的，因为放入任务队列就不是同步的了。

同样，JavaScript 语言规范 也没有定义任何 异步函数 及 相关概念，异步相关内容 通常由宿主环境定义，最常见的 `setTimeout` `setImmediate` 是由 BOM 定义的。

提供 异步函数 的目的就是要使用 防止阻塞。

不借助平台扩展函数，是无法实现其他异步函数的，如借助 `setTimeout` `setImmediate`、`process.nextTick` 等函数包装。

##### 异步函数 如何将 任务放入 任务队列 中？

想知道 异步函数 如何 将 任务放入 任务队列中，就需要之道异步函数是如何实现的。

首先，V8引擎 是可以被嵌入到 应用程序中的，提供 一个能够运行 JavaScript 代码的运行环境。

其次，宿主环境可以通过 V8引擎接口 向 JavaScript 运行环境中 注入 可以被 JavaScript 访问的对象，实现了 JavaScript 代码和 C++ 跨语言调用的能力。

Node.js 内部即通过这种方式向 JavaScript 运行时环境注入了大量 API，这些API，主要是由 libuv 来实现的。
同样，Node.js 提供了更有好的封装，使得 Node.js 开发者，更容易实现 C++Addons。

```c++
#include <node.h>

using namespace v8;

void RunCallback(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = Isolate::GetCurrent();
  HandleScope scope(isolate);

  Local<Function> cb = Local<Function>::Cast(args[0]);
  const unsigned argc = 1;
  Local<Value> argv[argc] = { String::NewFromUtf8(isolate, "hello world") };
  cb->Call(isolate->GetCurrentContext()->Global(), argc, argv);
}

void Init(Handle<Object> exports, Handle<Object> module) {
  NODE_SET_METHOD(module, "exports", RunCallback);
}

NODE_MODULE(addon, Init)
```

上面个的代码示例向Node.js运行环境中注入了一个函数，这个函数有一个函数参数，函数参数调用，并且传入了 "hello world" 字符串。

通过 JavaScript 传递的参数都被封装到了 `FunctionCallbackInfo<Value>` 对象中，其中包含回掉函数，部分参数又被 传入到 libuv 接口中。

一个异步调用过程：JS代码 -> Node.js API -> NodejsBinding API -> libuv API -> EnQueue -> return。

libuv将 IO 等异步请求 在 EnQueue 之后就由操作系统异步机制进行处理，之后就在一 事件循环 中查看是否有任务处理完成。
当任务完成之后，会被放入 Pending callbacks Queue 中，在 事件循环 到来之时，Pending callbacks 被调用。

##### EventLoop Running

Node.js 启动之后，进行一些初始工作，JavaScript 代码开始执行，然后开始进入事件循环。

JavaScript 最外层的全局代码主要进行的就是各种初始化工作，加载模块、初始化数据库连接池、创建目录、注册各类事件处理函数、发起请求、监听网络等。

实际上，上面提到的初始化工作在最外层代码执行的 异步函数 并没有开始工作，而要等到事件循环启动之后才开始真正开始工作。

事件循环启动之后，就有事件产生，体现就是响应事件的回掉函数被调用，如数据库连接成功、文件创建成功，端口监听成功。如果某些初始化工作依赖于其他初始化，那么就需要对代码逻辑进行同步。

初始化完成之后，即进入服务阶段：等待关注的事情发生。如：Web服务、定时任务等。

JavaScript 代码在运行时已经被V8 JIT编译成机器码。

事件循环 运行在主线程，JavaScript也运行在主线程。

这里需要注意的一点是，libuv 在主线程中运行，但是 libuv 处理的任务 都是 通过操作系统 提供的异步方案来实现，如select、epoll、kqueue、IOCP等，并不会阻塞主线程。另外，libuv也提供了同步访问文件系统的api，这部分api会阻塞主线程。

事实上，一次 事件循环 包括执行 JavaScript 代码 和 查看任务队列。

重要的是，循环中的每一步都 不应该 阻塞。

所以结论就是 JavaScript 运行在 事件循环 之中，而 事件循环 由 libuv 提供，同时 libuv 也为 JavaScript 异步IO函数 提供底层驱动。

JavaScript 连同 整个事件循环 运行在单线程中，但是 宿主环境 并不是单线程的。

Node.js 启动之后，就会存在 1 个主线程，默认情况，libuv 会创建其他 4 个线程用于访问文件。在主线程中，运行着 libuv eventloop 和 V8 Engine。

在 Node.js 中，主要通过 libuv 实现 主事件循环 和 其他 异步任务，并通过 V8引擎 编程接口 扩展 JavaScript，也就是平时用到的 API。

Node.js 除了内嵌 V8 Engine、libuv 以及其他第三方库 之外，主要就是实现这些 平台扩展接口，与浏览器的BOM、DOM接口不同，这些API主要是文件系统、网络、进程管理及一些常用基础库的接口。

在 事件循环 中 有个 Tick 的概念，即 事件循环 的 周期。

在 事件循环 中，有多个不同级别的队列，通过不同优先级别的队列，可以控制各个事件处理函数的优先级，例如 时间事件的处理函数 比 IO事件的处理函数 优先级高。

在一次事件循环中，会依次按级别从高到低读取队列中的任务进行处理。当任务处理完成之后，就会通过 回调函数 通知 JavaScript 执行线程，通知的方式就是将 回调函数 放入 JavaScript任务队列 中去。

Node.js执行过程：

* Node.js启动
* 主线程开始执行
* 进行一些列初始化工作
* 调用V8引擎 执行 JavaScript 代码，JavaScript 在执行过程中会调用 同步或异步的函数，异步函数 最终会 调用到 libuv 的异步IO库，立即返回，整个流程耗时很短。此时 **JavaScript调用栈为空**，**异步IO并没有开始**
* 调用`uv_run()`启动 libuv 事件循环
* 事件循环 不断的查看 任务队列 中是否有 任务需要处理。如果没有任务，则进入下次循环，如果有任务，则 通过调用 `f->Call(...)` 运行，进入 JavaScript 执行上下文，JavaScript 在执行过程中可能又会调用异步函数

因为整个流程运行在同一个线程中，所以，流程中的每一步都是不应该被阻塞。

主线程运行完 JavaScript 代码之后，即 JavaScript 函数调用栈 为空的时候，才能去 查看 任务队列。所以，JavaScript 不适合运行 耗时 任务，否则，事件队列中的 任务将不能即时被处理。

JavaScript 编写的回掉函数能够 完美运行是因为 一个 称之 *闭包* 的东西在起作用，*闭包* 基于 *词法作用域*，简单的说就是：不论函数被传递到什么位置，它都能访问到它原本的上下文。

异步函数带来的效果就是，回掉函数执行的时机是不确定的，它取决于异步函数什么时候完成，还取决于在任务队列中的位置，先进先出。
执行时机不再是代码的静态位置决定，但是闭包却又是静态作用域决定的。
这两点结合在一起构成一个强大的模型。

通过上面的分析可以看到，JS的执行过程实际上类似于树的遍历，但是既不是广度的也不是深度的，是时间优先的，谁先有机会执行就谁先。
而且这颗树在持续不断生长，甚至没有边界，直到进程退出。遍历过的部分正常情况都会被回收，静态的代码是有限的，动态的活动对象是无限的。

![eventloop-in-nodejs](images/eventloop-in-nodejs.png)

这张图在讲Node.js事件循环机制内容当中非常经典，但是这张图也会让人很困惑，其中困惑的地方就是 EventLoop 的位置。在代码中EventLoop确实在libuv中实现，但是在运行阶段，JavaScript代码的执行 占用 事件循环中的一部分，但是图中没有体现。

![eventloop-in-browser](images/eventloop-in-browser.png)

而 eventloop-in-browser 这张图就更合适一些了。

##### process.nextTick vs setTimeout

`process.nextTick`，给 开发者 直接 向 高优先级任务队列 中添加 任务 的能力，`setTimeout(() => {}, 0)`也可以向 任务队列 中添加 任务，但是却是 间接 的。

```js
function StreamLibrary(resourceName) {      
    process.nextTick(() => {
        this.emit('start');
    });

    // read from the file, and for every chunk read, do:        
    this.emit('data', chunkRead);       
}

const stream = new StreamLibrary('fooResource');

stream.on('start', function() {
    console.log('Reading has started');
});

stream.on('data', function(chunk) {
    console.log('Received: ' + chunk);
});
```


#### 小结

多线程的GUI框架特别容易死锁，所以很多设计采用的单线程的实现方式，避免死锁。
单线程又有个致命的弱点，容易阻塞，所以人们当然想办法解决阻塞的问题，就产生了事件驱动模型。

事件驱动 模型 底层实现 是 事件轮询 + 异步IO，异步IO可以避免阻塞。
代码层面，语句同步执行是可以接受的，因为非常快。
IO层面，IO函数同步执行是不可以接受的，因为慢，影响交互。

想象一下，你点击一个按钮提交数据到服务端，GUI界面就必须等待服务端返回才能继续响应，因为单线程。

这样避免多线程死锁解决了，单线程阻塞解决了，而这一编程模型又有利于程序设计，所以这种模式就很流行。

以上 **单线程+事件循环** 处理模式的 基本前提：事件循环的周期非常短暂，即CPU操作远远快于IO操作几个数量级。

但凡这种「既是单线程又是异步」的语言有一个共同特点：它们是 `event-driven` 的。

恰好，Node.js 和 浏览器 都是这种 event-driven 架构的软件。

JS执行引擎是整个程序的可编程的指挥中心，通过编码交代指挥中心工作，当指挥中心运行之后，会将交到的工作分配下去，初始化，然后进入事件循环，一直检查任务队列，检查有没有完成的任务。

从模式上来讲，JS 通过依赖注入的方式注入的 宿主 环境中。


#### Links

* https://v8docs.nodesource.com/
* http://docs.libuv.org/en/v1.x/
* https://nodejs.org/dist/latest-v6.x/docs/api/addons.html
* https://nodejs.org/api/process.html#process_process_nexttick_callback_args
* https://howtonode.org/understanding-process-next-tick
* http://stackoverflow.com/questions/15349733/setimmediate-vs-nexttick
* https://www.quora.com/What-does-process-nextTick-callback-actually-do-in-Node-js
* https://www.zhihu.com/question/30970837
* http://frontenddev.org/link/first-look-javascript-event-mechanism-the-implementation-of-the-a-node-js-event-driven-an-overview-of-the-implementation.html
* http://ejohn.org/blog/how-javascript-timers-work/
* https://danmartensen.svbtle.com/events-concurrency-and-javascript
* https://blog.risingstack.com/node-js-at-scale-understanding-node-js-event-loop/
* https://html.spec.whatwg.org/multipage/webappapis.html#event-loops
* http://www.myfreax.com/understanding-the-node-js-event-loop/
* http://altitudelabs.com/blog/what-is-the-javascript-event-loop/
* https://groups.google.com/forum/#!forum/libuv
* http://codedocker.com/transon-problems-with-threads-in-node-js/
* http://www.ruanyifeng.com/blog/2014/10/event-loop.html
* https://gist.github.com/jcouyang/9914091
* https://github.com/DDFE/init/blob/master/notes/nodejs/Nodejs%E5%BC%82%E6%AD%A5%E5%8D%95%E7%BA%BF%E7%A8%8B%E7%90%86%E8%AE%BA.md
* http://www.qdfuns.com/notes/17659/7cb0a395fea126caceeb64909b594b0f.html
* http://taobaofed.org/blog/2015/10/29/deep-into-node-1/
* http://bulk.fefe.de/scalable-networking.pdf
* https://www.zhihu.com/question/19653241
* http://www.cnblogs.com/dolphinX/p/3475090.html
* https://www.zhihu.com/question/30970837/answer/51566079
* https://cnodejs.org/user/bigtree9307/topics
* https://cnodejs.org/user/LanceHBZhang

### 1.5 ES5 ES6 ES7 ES.next ...

#### AsyncAwait

#### Babel.js

## 二、Node.js Core

> Node.js® is a JavaScript runtime built on Chrome's V8 JavaScript engine.

> Node.js uses an event-driven, non-blocking I/O model that makes it lightweight and efficient.

> Node.js' package ecosystem, npm, is the largest ecosystem of open source libraries in the world.

### 2.1 event-driven

#### Events的实现

### 2.2 non-blocking I/O model

#### 2.2.1 I/O model

#### 2.2.2 stream

流的实现原理，流的优势，流的应用

压缩流、限流、流的自动调节能力

## 三、开发实践

### 3.1 GIT开发模式

### 3.2 单元测试

### 3.3 自动化

### 3.4 监控

### 3.5 DevOps

## 四、总结

^_~
