# The Python Language Reference

[python-questions-on-stackoverflow](http://pyzh.readthedocs.io/en/latest/python-questions-on-stackoverflow.html)

## 3 Data model

## 3.1 Objects, values and types

`Objects` 是 Python 中所有数据的抽象，所有 Python 中的数据用来表示 objects 或者 objects 之间的关系。在某种意义上，在符合冯诺依曼的“存储程序计算机”，代码也是由objects表示的。

每一个 object 拥有 identity、type、value，identity 在创建之后将不再会被改变。可以把他看作的是对象的内存地址。is 操作比较两个对象的 identity，id() 函数返回identify的整数表示。

> CPython implementation detail: For CPython, id(x) is the memory address where x is stored.

对象类型决定他能进行什么样的操作，也能定义这个对象可能包含的值，type()函数返回对象类型。如同identity，对象的类型也是不可修改的。

对象的值是可以被修改的。哪个对象的可以修改据说是 `mutable`，不可被修改一旦他们在创建的时候调用 `immutable`。对象能不能修改由对象类型决定，instance、strings、numbers and tuples 是不可修改的，然而 dictionaries 是可以修改的。

Objects从来不需要显式的销毁，当他们变得 unreachable 时会被 garbage-collected。

> Note that the use of the implementation’s tracing or debugging facilities may keep objects alive that would normally be collectable. Also note that catching an exception with a ‘try...except‘ statement may keep objects alive.

一些对象引用到了外部资源，如打开文件或窗口。不用说这些资源会被释放掉当对象被GC的时候，然而垃圾回收不保证一定发生，因此objects还会提供显示的方式释放外部资源，通常是`close()`方法。强烈推荐显示的close这类资源。`try...finally` 和 `with` 提供了很方便的方式来做这件事。

有些对象会引用其他对象，这些被叫做容器。如 tuples、lists、dictionaries。

对象类型影响对象行为的方方面面。甚至在某些情形下会影响对象的identify。

## 3.2. The standard type hierarchy

### None : None(false)

This type has a single value. There is a single object with this value. This object is accessed through the built-in name None. 

It is used to signify the absence of a value in many situations, e.g., it is returned from functions that don’t explicitly return anything. 

### NotImplemented : NotImplemented(true) 未实现

This type has a single value. There is a single object with this value.

This object is accessed through the built-in name NotImplemented. 

Numeric methods and rich comparison methods should return this value if they do not implement the operation for the operands provided. 

Its truth value is true.

### Ellipsis : Ellipsis or ... (true) 省略号

This type has a single value. There is a single object with this value. 

This object is accessed through the literal ... or the built-in name Ellipsis. 

### numbers.Number 数字

#### numbers.Integral 整数

##### Integers (int)

##### Booleans (bool)

#### numbers.Real (float) 实数

#### numbers.Complex (complex) 复数

### Sequences 序列

这些代表使用非负整数索引的有限的有序的的点集。内建函数`len()`返回序列中条码的个数。n: 0 -> n-1;

a[i:j]: i <= k < j.
a[i:j:k]: x = i + n*k, n >= 0 and i <= x < j.

#### Immutable sequences 不可变序列

##### Strings

##### Tuples

##### Bytes

#### Mutable sequences 可变序列

##### Lists

##### Byte Arrays

### Set types

### Mappings

### Callable types

### Modules

### Custom classes

### Class instances

### I/O objects (also known as file objects)

### Internal types

## 3.3. Special method names

一个类可以通过定义特定名字的方法实现某些使用特定语法调用的操作。这是Pthon实现operator overloading的方式，允许类他们在尊重语言操作符的前提下定义自己的行为。

### 3.3.1. Basic customization

method                            | description
----------------------------------|------------------------------------------
`__new__(cls[, ...])`             | 构造器方法，必须返回一个合法的对象。
`__init__(self[, ...])`           | 构造器方法，做的实际上是对象初始化工作。
`__del__(self)`                   | 解构器方法，引用计数为0时执行。
`__repr__(self)`                  | Called by `repr()` built-in function. 
`__str__(self)`                   | Called by `str(object)` and the built-in functions `format()` and `print()`.
`__bytes__(self)`                 | Called by `bytes()` to compute a byte-string representation of an object.
`__format__(self, format_spec)`   | Called by `format()`. [formatspec](https://docs.python.org/3/library/string.html#formatspec)
`__lt__(self, other)`             | <
`__le__(self, other)`             | <=
`__eq__(self, other)`             | ==
`__ne__(self, other)`             | !=
`__gt__(self, other)`             | >
`__ge__(self, other)`             | >=
`__hash__(self)`                  | `__hash__()` should return an integer.
`__bool__(self)`                  | should return False or True.

### 3.3.2. Customizing attribute access

method                            | description
----------------------------------|------------------------
`__getattr__(self, name)`         | Called when an attribute lookup has not found the attribute in the usual places.
`__getattribute__(self, name)`    | Called unconditionally to implement attribute accesses for instances of the class.
`__setattr__(self, name, value)`  | Called when an attribute assignment is attempted.
`__delattr__(self, name)`         | Like `__setattr__()` but for attribute deletion instead of assignment.
`__dir__(self)`                   | Called when `dir()` is called on the object.

#### 3.3.2.1. Implementing Descriptors

In the examples below, “the attribute” refers to the attribute whose name is the key of the property in the owner class’ __dict__.

method                            | description
----------------------------------|------------------------
`__get__(self, instance, owner)`  | Called to get the attribute of the owner class or of an instance of that class.
`__set__(self, instance, value)`  | Called to set the attribute on an instance instance of the owner class to a new value.
`__delete__(self, instance)`      | Called to delete the attribute on an instance instance of the owner class.

#### 3.3.2.2. Invoking Descriptors

类似Javascript的访问器属性。

一般来说，一个描述符 绑定行为 的对象属性。通过描述符协议：`__get__()`, `__set__()`, and `__delete__()`复写属性访问。对象定义了其中任意的方法，就被是为一个描述符。

默认的属性访问行为是：get、set、delete属性从对象数据字典。如 `a.x lookup a.__dict__['x'] then type(a).__dict__['x']`.

method                            | description
----------------------------------|------------------------
Direct Call                       |`x.__get__(a)`
Instance Binding                  | `a.x` -> `type(a).__dict__['x'].__get__(a, type(a))`
Class Binding                     | `A.x` -> `A.__dict__['x'].__get__(None, A)`
Super Binding                     |

#### 3.3.2.3. `__slots__`

如果我们想要限制class的属性怎么办？比如，只允许对Student实例添加name和age属性。为了达到限制的目的，Python允许在定义class的时候，定义一个特殊的__slots__变量，来限制该class能添加的属性：

```py
class Student(object):
    __slots__ = ('name', 'age') # 用tuple定义允许绑定的属性名称
```

### 3.3.3. Customizing class creation

[python-metaclass](http://xiaocong.github.io/blog/2012/06/12/python-metaclass/)

By default, classes are constructed using type(). The class body is executed in a new namespace and the class name is bound locally to the result of type(name, bases, namespace).

The class creation process can be customized by passing the metaclass keyword argument in the class definition line, or by inheriting from an existing class that included such an argument. In the following example, both MyClass and MySubclass are instances of Meta:

```py
class Meta(type):
    pass

class MyClass(metaclass=Meta):
    pass

class MySubclass(MyClass):
    pass
```

When a class definition is executed, the following steps occur:

* the appropriate metaclass is determined，适当的元类型被确定
* the class namespace is prepared，类命名空间被准备
* the class body is executed，类体被执行
* the class object is created，类的对象实例被创建

#### 3.3.3.1. Determining the appropriate metaclass

The appropriate metaclass for a class definition is determined as follows:

* if no bases and no explicit metaclass are given, then type() is used
* if an explicit metaclass is given and it is not an instance of type(), then it is used directly as the metaclass
* if an instance of type() is given as the explicit metaclass, or bases are defined, then the most derived metaclass is used

The most derived metaclass is selected from the explicitly specified metaclass (if any) and the metaclasses (i.e. type(cls)) of all specified base classes. The most derived metaclass is one which is a subtype of all of these candidate metaclasses. If none of the candidate metaclasses meets that criterion, then the class definition will fail with TypeError.

#### 3.3.3.2. Preparing the class namespace

#### 3.3.3.3. Executing the class body

#### 3.3.3.4. Creating the class object

#### 3.3.3.5. Metaclass example

```py
class OrderedClass(type):

    @classmethod
    def __prepare__(metacls, name, bases, **kwds):
        return collections.OrderedDict()

    def __new__(cls, name, bases, namespace, **kwds):
        result = type.__new__(cls, name, bases, dict(namespace))
        result.members = tuple(namespace)
        return result

class A(metaclass=OrderedClass):
    def one(self): pass
    def two(self): pass
    def three(self): pass
    def four(self): pass

# >>> A.members
# ('__module__', 'one', 'two', 'three', 'four')
```

### 3.3.4. Customizing instance and subclass checks

method                              | description
------------------------------------|----------------------------
`__instancecheck__(self, instance)` | `isinstance(instance, class)`
`__subclasscheck__(self, subclass)` | `issubclass(subclass, class)`

### 3.3.5. Emulating callable objects

method                      | description
----------------------------|----------------------------
`__call__(self[, args...])` | `x(arg1, arg2, ...)` -> `x.__call__(arg1, arg2, ...)`

### 3.3.6. Emulating container types

method                            | description
----------------------------------|------------------------
`__len__(self)`                   | Called to implement the built-in function `len()`.
`__length_hint__(self)`           | Called to implement `operator.length_hint()`.
`__getitem__(self, key)`          | Called to implement evaluation of `self[key]`.
`__missing__(self, key)`          | Called by `dict.__getitem__()` to implement `self[key]`.
`__setitem__(self, key, value)`   | Called to implement assignment to `self[key]`.
`__delitem__(self, key)`          | Called to implement deletion of `self[key]`.
`__iter__(self)`                  | This method is called when an iterator is required for a container.
`__reversed__(self)`              | Called (if present) by the `1reversed()` built-in to implement reverse iteration.
`__contains__(self, item)`        | Called to implement membership test operators.

### 3.3.7. Emulating numeric types

method                            | description
----------------------------------|------------------------
`__add__(self, other)`            | `+`
`__sub__(self, other)`            | `-`
`__mul__(self, other)`            | `*`
`__matmul__(self, other)`         | `@`
`__truediv__(self, other)`        | `/`
`__floordiv__(self, other)`       | `//`
`__mod__(self, other)`            | `%`
`__divmod__(self, other)`         | `divmod()`
`__pow__(self, other[, modulo])`  | `pow()`、`**`
`__lshift__(self, other)`         | `<<`
`__rshift__(self, other)`         | `>>`
`__and__(self, other)`            | `&`
`__xor__(self, other)`            | `^`
`__or__(self, other)`             | `|`

method                            | description
----------------------------------|------------------------
`__radd__(self, other)`           | `+`
`__rsub__(self, other)`           | `-`
`__rmul__(self, other)`           | `*`
`__rmatmul__(self, other)`        | `@`
`__rtruediv__(self, other)`       | `/`
`__rfloordiv__(self, other)`      | `//`
`__rmod__(self, other)`           | `%`
`__rdivmod__(self, other)`        | `divmod()`
`__rpow__(self, other)`           | `pow()`、`**`
`__rlshift__(self, other)`        | `<<`
`__rrshift__(self, other)`        | `>>`
`__rand__(self, other)`           | `&`
`__rxor__(self, other)`           | `^`
`__ror__(self, other)`            | `|`

method                            | description
----------------------------------|------------------------
`__iadd__(self, other)`           | `+=`
`__isub__(self, other)`           | `-=`
`__imul__(self, other)`           | `*=`
`__imatmul__(self, other)`        | `@=`
`__itruediv__(self, other)`       | `/=`
`__ifloordiv__(self, other)`      | `//=`
`__imod__(self, other)`           | `%=` 
`__ipow__(self, other[, modulo])` | `**=`
`__ilshift__(self, other)`        | `<<=`
`__irshift__(self, other)`        | `>>=`
`__iand__(self, other)`           | `&=`
`__ixor__(self, other)`           | `^=`
`__ior__(self, other)`            | `|=`

method                            | description
----------------------------------|------------------------
`__neg__(self)`                   | `-`
`__pos__(self)`                   | `+`
`__abs__(self)`                   | `abs()`
`__invert__(self)`                | `~`

method                            | description
----------------------------------|------------------------
`__complex__(self)`               | `complex()`
`__int__(self)`                   | `int()`
`__float__(self)`                 | `float()`
`__round__(self[, n])`            | `round()`

method                            | description
----------------------------------|------------------------
`__index__(self)`                 | `index()`

### 3.3.8. With Statement Context Managers

method                            | description
----------------------------------|------------------------
`__enter__(self)`                 | Enter the runtime context related to this object.
`__exit__(self, exc_type, exc_value, traceback)`  | Exit the runtime context related to this object. 

### 3.3.9. Special method lookup

## 3.4. Coroutines

### 3.4.1. Awaitable Objects

method             | description
-------------------|------------------------
`__await__(self)`  | Must return an iterator. Should be used to implement awaitable objects.


### 3.4.2. Coroutine Objects

* `coroutine.send(value)`
* `coroutine.throw(type[, value[, traceback]])`
* `coroutine.close()`

### 3.4.3. Asynchronous Iterators

method             | description
-------------------|------------------------
`__aiter__(self)`  | Must return an asynchronous iterator object.
`__anext__(self)`  | Must return an awaitable resulting in a next value of the iterator.

### 3.4.4. Asynchronous Context Managers

method                                              | description
----------------------------------------------------|------------------------
`__aenter__(self)`                                  | Difference from `__enter__()` is it must return an awaitable.
`__aexit__(self, exc_type, exc_value, traceback)`   | Difference from `__exit__()`, is it must return an awaitable.

## 5. The import system

5.1. importlib

5.2. Packages

5.2.1. Regular packages

5.2.2. Namespace packages

5.3. Searching

5.3.1. The module cache

5.3.2. Finders and loaders

5.3.3. Import hooks

5.3.4. The meta path

5.4. Loading

5.4.1. Loaders

5.4.2. Submodules

5.4.3. Module spec

5.4.4. Import-related module attributes

5.4.5. `module.__path__`

5.4.6. Module reprs

5.5. The Path Based Finder

5.5.1. Path entry finders

5.5.2. Path entry finder protocol

5.6. Replacing the standard import system

5.7. Special considerations for `__main__`

5.7.1. `__main__.__spec__`

5.8. Open issues

5.9. References
