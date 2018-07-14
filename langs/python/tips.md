# python

## 12 模块

模块用来组织Python代码，包则用来组织模块。

### 12.1 什么是模块

自我包含且有组织的代码片段就是模块。

### 12.2 模块和文件

模块是在逻辑层面组织代码，文件在物理层面组织代码。
一个文件被看作是一个模块，一个模块同样也被看作是一个文件，模块的文件名就是模块名加上`.py`。

### 12.2.1 模块和命名空间

一个名称空间就是一个从名称到对象的关系映射集合。每个模块都需要定义唯一的名称空间，完整授权名称防止命名冲突。

### 12.2.2 搜索路径和路径搜索

模块导入是一个叫做`路径搜索`的过程。即，在文件系统预定区域查找模块的过程。

预订区域：

```sh
echo ${PYTHONPATH}
```

```py
import sys
print sys.path
```

## 12.3 名称空间

名称空间是名称到对象的映射。改变一个名字的绑定叫`重新绑定`，删除一个名字的绑定叫`解除绑定`。

三个名称空间：`局部名称空间`、`全局名称空间`、`内建名称空间`。

Python解释器首先加载内建的名称空间，他是由`__builtins__`模块中的名字组成，随后加载执行模块的全局名称空间，他会在模块加载之后变成活动的名称空间。

在执行期间调用函数，那么将创建局部名称空间。

可以通过`globals()`和`locals()`判断名字属于哪个名称空间。

`__builtins__` 和 `__builtin__`

`__builtins__`模块包含内建名称空间中的内建名字集合，其中大多数来自`__builtin__`。

### 12.3.1 名称空间和变量作用域比较

### 12.3.2 名字查找、确定作用域、覆盖

访问一个属性时，解释器必须在三个名称空间中找到它。

### 12.3.3 无限制的名称空间

你可以把任何想要的东西放入一个名称空间中去。

## 12.4 导入模块

### 12.4.1 import

```py
import module1
import module2

import module1[,module2[,... moduleN]]
```

### 12.4.2 from-import

```py
from module import name1[, name2[,... nameN]]
```

### 12.4.3 多行导入

```py
from Tkinter import (name1, name2, name3)
```

### 12.4.4 import as

```py
import Tkinter as tk
```

## 12.5 模块导入的特性

### 12.5.1 载入时执行

导入模块会导致这个模块顶层代码被执行。

### 12.5.2 import load

## 12.6 模块内建函数

### 12.6.1 __import__()

import 实际调用 `__import__()` 函数

```py
__import__(module_name[, globals=globals()[, locals=locals()[, fromlist=[]]]])
```

### 12.6.2 globals() locals()

```py
print(globals())
print(locals())


def local_func():
    num = 1
    print(locals())
```

### 12.6.3 reload()

```py
reload(module)
```

重新导入模块，模块必须全部导入，而且必须导入成功。
参数必须是模块自身而不是模块名称的字符串。
import执行一次，reload会再次执行模块一次。

## 12.7 package

包是一个有层次的目录结构，它定义了一个由模块和子包组成的应用程序执行环境。

* 为平坦的名称空间加入有层次的组织结构
* 允许程序员把有联系的模块组织到一起
* 允许分发者使用目录而不是一大堆混乱的文件
* 帮助解决有冲突的模块名称

### 12.7.1 目录结构

```py
__init__.py
```

### 12.7.2 

#### 12.7.2.1 绝对导入

所有的import导入都认为是绝对的，必须通过Python路径访问。

#### 12.7.2.2 相对导入

import总是执行绝对导入，from-import可以执行相对导入

```py
import Phone.Mobile.Analog as Analog
from .Analog import dial

dial()
Analog.dial()
```

## 12.8 模块的其他特性

### 12.8.1 自动载入模块

sys.modules包含当前载入到解释器的模块组成的字典。

### 12.8.2 阻止属性导入

_开头的属性不会被`from module import *`导入。显式依然可以导入成功。

### 12.8.3 不区分大小写的导入

### 12.8.4 模块的编码

```py
# -*- coding: UTF-8 -*-
```

### 12.8.5 导入循环

### 12.8.6 模块的执行

### 12.9 相关模块

```py
modulefinder、pkgutil、zipimport、imp、site
```
