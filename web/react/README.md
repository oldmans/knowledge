# React

> React + Redux + React-Redux + Redux-Saga + Redux-Actions + React-Router + React-Router-Redux + ReSelect

* react
* jsx
* react-router
* flux
* redux

## React基本原理

### Components

See: https://facebook.github.io/react/docs/components-and-props.html

React认为一个组件应该具有如下特征：

* （1）可组合（Composeable）：一个组件易于和其它组件一起使用，或者嵌套在另一个组件内部。如果一个组件内部创建了另一个组件，那么说父组件拥有（own）它创建的子组件，通过这个特性，一个复杂的UI可以拆分成多个简单的UI组件；
* （2）可重用（Reusable）：每个组件都是具有独立功能的，它可以被使用在多个UI场景；
* （3）可维护（Maintainable）：每个小的组件仅仅包含自身的逻辑，更容易被理解和维护；

#### Functional and Class Components

两种形式是等价的，但是class定义的组件拥有一些附加的特性。

```js
// use function
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}

// ES6 class
class Welcome extends React.Component {
  render() {
    return <h1>Hello, {this.props.name}</h1>;
  }
}
```

返回一个 `React element`

#### Rendering a Component

```jsx
// DOM tags
const element = <div />;

// user-defined component
const element = <Welcome name="Sara" />;
```

当 `React` 遇到一个自定义组件的时，传递JSX属性 `props`（一个JS对象）到组件当中，得到一个 `React element`。

渲染过程（将 `<Welcome name="Sara" />` 渲染到对应 `DOM` 节点）：

1. 调用 `ReactDOM.render()`
2. 使用 `{name: 'Sara'}` 作为 `props` 调用 `Welcome`
3. `Welcome` 返回 `<h1>Hello, Sara</h1>`
4. React DOM 高效的将 `<h1>Hello, Sara</h1>` 更新到 `DOM` 上

组件名称必须使用大写字母开头，用于与 `DOM tag` 区分

#### Composing Components

Components can refer to other components in their output.

#### Extracting Components

#### Props are Read-Only

All React components must act like pure functions with respect to their props.

### State and Lifecycle

`State` 类似 `props`，但是他是组件 `私有` 且 `被组件完全控制的`。

只能在 `Class` 定义的组件使用 `State`。

You can convert a functional component like Clock to a class in five steps:

* Create an ES6 class with the same name that extends React.Component.
* Add a single empty method to it called render().
* Move the body of the function into the render() method.
* Replace props with this.props in the render() body.
* Delete the remaining empty function declaration.

```jsx
class Clock extends React.Component {
  constructor(props) {
    super(props);
    this.state = {date: new Date()};
  }

  // InstanceMethod: lifecycle hooks
  componentDidMount() {
    this.timerID = setInterval(
      () => this.tick(),
      1000
    );
  }
  componentWillUnmount() {
    clearInterval(this.timerID);
  }

  // InstanceMethod
  tick() {
    this.setState({
      date: new Date()
    });
  }

  // Inherit:
  // this.setState

  render() {
    return (
      <div>
        <h1>Hello, world!</h1>
        <h2>It is {this.state.date.toLocaleTimeString()}.</h2>
      </div>
    );
  }
}
```

类组件在传递给 `ReactDOM.render()` 时进行实例化，得到组件实例，实例的 `render` 方法描述了实例如何呈现在页面上，渲染 `render` 的返回到 匹配的 `DOM` 上。

当 组件 被渲染到 `DOM` 上之后，`React` 调用 `componentDidMount()` 勾子。

`tick` 函数通过 `this.setState()` 函数更新组件状态，`React` 通过观察 `this.setState()` 函数调用，得知需要更新组件，开始通过 `diff` 状态判断是否需要更新。如果需要更新，则使用新的 `state` re `render()`，并更新 `DOM`。

当 组件 被移出 `DOM` 之前 `componentWillUnmount()` 勾子被调用。

#### Using State Correctly

* Do Not Modify State Directly
* State Updates May Be Asynchronous. Because this.props and this.state may be updated asynchronously, you should not rely on their values for calculating the next state.
* State Updates are Merged

#### The Data Flows Down

### Handling Events

### Conditional Rendering

### Lists and Keys

#### Rendering Multiple Components

#### Basic List Component

#### Extracting Components with Keys

#### Keys Must Only Be Unique Among Siblings

#### Embedding map() in JSX

### Class

#### ReactDOM

* render()
* unmountComponentAtNode()
* findDOMNode()

#### ReactDOMServer

* renderToString()
* renderToStaticMarkup()

#### DOM Elements

Differences In Attributes:

checked
defaultChecked
className
dangerouslySetInnerHTML
htmlFor
onChange
selected
style
suppressContentEditableWarning
value

组件就是一个简单的类，组件实例化为一个 `VirtualDOM`，实例化需要 `props` 参数，组件实例 可以输出（render）相应的 html，即组件的UI，组件同时具备内部状态 `state`。

组件可以嵌套组合，形成父子组件，父子组件可以通过 `props` 参数进行交互，父组件向子组件传递参数，子组件回调父组件，在父组件中可以通过 `children` 引用子组件。
兄弟组件之间交互需要依托父组件做为中介。

Higher-order components

```js
var enhanceComponent = (Component) =>
  class Enhance extends React.Component {
    render() {
      return (
        <Component
          {...this.state}
          {...this.props}
        />
      )
    }
  };

export default enhanceComponent;
```

Dependency injection

## Redux

http://redux.js.org
http://cn.redux.js.org

https://github.com/reactjs/redux
https://github.com/reactjs/react-redux

https://github.com/acdlite/flux-standard-action

https://github.com/acdlite/redux-actions

https://github.com/lelandrichardson/redux-pack
https://github.com/gaearon/redux-thunk
https://github.com/acdlite/redux-promise
https://github.com/pburtchaell/redux-promise-middleware
https://github.com/redux-observable/redux-observable
https://github.com/redux-saga/redux-saga

https://github.com/evgenyrodionov/redux-logger

https://github.com/paularmstrong/normalizr

https://developer.mozilla.org/en/docs/Web/API/Fetch_API
https://github.com/matthew-andrews/isomorphic-fetch

https://github.com/dvajs/dva

https://facebook.github.io/immutable-js
https://github.com/facebook/immutable-js

https://github.com/react-guide

## Links

* [深入理解 JSX](http://www.css88.com/react/docs/jsx-in-depth.html)
* [JSX in Depth](http://reactjs.cn/react/docs/jsx-in-depth.html)
* [前端之React实战-JSX介绍与使用](https://segmentfault.com/a/1190000003748270)
* [React 入门实例教程](http://www.ruanyifeng.com/blog/2015/03/react.html)
* [React Router 使用教程](http://www.ruanyifeng.com/blog/2016/05/react_router.html)
* [一看就懂的ReactJs入门教程-精华版](http://www.cnblogs.com/yunfeifei/p/4486125.html?)
* [React设计模式:深入理解React&Redux原理套路](https://segmentfault.com/a/1190000006112093)
* [GUI应用程序架构的十年变迁:MVC,MVP,MVVM,Unidirectional,Clean](https://segmentfault.com/a/1190000006016817)
* [React 最佳实践——那些 React 没告诉你但很重要的事](https://segmentfault.com/a/1190000005013207)
* [SegmentFault 技术周刊 Vol.11 - React 应用与实践](https://segmentfault.com/a/1190000007345731)
* [解读redux工作原理](https://segmentfault.com/a/1190000004236064)
* [理解 React，但不理解 Redux，该如何通俗易懂的理解 Redux？](https://www.zhihu.com/question/41312576)
* [深入理解React、Redux](http://www.jianshu.com/p/0e42799be566)
* [React.js 小书](http://huziketang.com/books/react/)
* [Redux 核心概念](http://www.jianshu.com/p/3334467e4b32)
* [深入到源码：解读 redux 的设计思路与用法](http://div.io/topic/1309)
* [redux原理分析](https://segmentfault.com/a/1190000008648319)
* [解读redux工作原理](https://segmentfault.com/a/1190000004236064)
* [从 React Router 谈谈路由的那些事](http://www.tuicool.com/articles/JBviInY)
* [深入理解 react-router 路由系统](https://zhuanlan.zhihu.com/p/20381597)
* [react-router的实现原理](http://www.tuicool.com/articles/eUBvIjj)
* [React’s diff algorithm](https://calendar.perfplanet.com/2013/diff/)

* https://facebook.github.io/react/
* https://github.com/ReactTraining/react-router
* https://reacttraining.com/

* https://github.com/dvajs/dva
* https://github.com/dvajs/dva-knowledgemap
* https://github.com/dvajs/dva/docs/API_zh-CN.md
* https://github.com/dvajs/dva/docs/Concepts_zh-CN.md
* https://github.com/ant-design/ant-design

http://www.cnblogs.com/netfocus/p/4055346.html
http://www.cnblogs.com/netfocus/p/3149156.html
http://www.cnblogs.com/Leo_wl/p/4449295.html
https://sanwen8.cn/p/1e9pyg7.html

* http://reactide.io

https://github.com/wxyyxc1992/Web-Development-And-Engineering-Practices/blob/master/Framework/View/React/BestPractices/React-In-Patterns.md

https://github.com/facebook/react/wiki/Complementary-Tools
