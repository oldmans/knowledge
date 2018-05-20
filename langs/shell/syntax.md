# Shell Syntax

以下内容大部分摘自 [《30分钟玩转Shell脚本编程》](http://outofmemory.cn/shell/learn-shell-in-30-minutes/)，同时也补充了很多内容，以及调整为Markdown格式。

## Reference

* [unix-shell](http://www.tutorialspoint.com/unix/unix-shell.htm)
* [30分钟玩转Shell脚本编程](http://outofmemory.cn/shell/learn-shell-in-30-minutes/) @OutOfMemory.CN技术专栏
* [30分钟玩转Shell脚本编程](http://c.biancheng.net/cpp/shell/) @C语言中文网
* [Linux Shell Scripting Tutorial (LSST) v2.0](https://bash.cyberciti.biz/guide/Main_Page)
* [Advanced Bash-Scripting Guide](http://tldp.org/LDP/abs/html/)
* [Tutorials](https://www.tutorialspoint.com/)

## Shell简介：什么是Shell，Shell命令的两种执行方式

Shell本身是一个用C语言编写的程序，它是用户使用Unix/Linux的桥梁，用户的大部分工作都是通过Shell完成的。

Shell既是一种命令语言，又是一种程序设计语言。作为命令语言，它交互式地解释和执行用户输入的命令；作为程序设计语言，它定义了各种变量和参数，并提供了许多在高级语言中才具有的控制结构，包括循环和分支。

它虽然不是Unix/Linux系统内核的一部分，但它调用了系统核心的大部分功能来执行程序、建立文件并以并行的方式协调各个程序的运行。

因此，对于用户来说，shell是最重要的实用程序，深入了解和熟练掌握shell的特性极其使用方法，是用好Unix/Linux系统的关键。

可以说，shell使用的熟练程度反映了用户对Unix/Linux使用的熟练程度。

注意：单独地学习 Shell 是没有意义的，请先参考Unix/Linux入门教程，了解 Unix/Linux 基础。

Shell有两种执行命令的方式：

* 交互式（Interactive）：解释执行用户的命令，用户输入一条命令，Shell就解释执行一条。
* 批处理（Batch）：用户事先写一个Shell脚本(Script)，其中有很多条命令，让Shell一次把这些命令执行完，而不必一条一条地敲命令。

Shell脚本和编程语言很相似，也有变量和流程控制语句，但Shell脚本是解释执行的，不需要编译，Shell程序从脚本中一行一行读取并执行这些命令，相当于一个用户把脚本中的命令一行一行敲到Shell提示符下执行。

Shell初学者请注意，在平常应用中，建议不要用 root 帐号运行 Shell 。作为普通用户，不管您有意还是无意，都无法破坏系统；但如果是 root，那就不同了，只要敲几个字母，就可能导致灾难性后果。


## 几种常见的Shell

上面提到过，Shell是一种脚本语言，那么，就必须有解释器来执行这些脚本。

Unix/Linux上常见的Shell脚本解释器有bash、sh、csh、ksh等，习惯上把它们称作一种Shell。我们常说有多少种Shell，其实说的是Shell脚本解释器。

### bash

bash是Linux标准默认的shell，本教程也基于bash讲解。bash由Brian Fox和Chet Ramey共同完成，是BourneAgain Shell的缩写，内部命令一共有40个。

Linux使用它作为默认的shell是因为它有诸如以下的特色：

* 可以使用类似DOS下面的doskey的功能，用方向键查阅和快速输入并修改命令。
* 自动通过查找匹配的方式给出以某字符串开头的命令。
* 包含了自身的帮助功能，你只要在提示符下面键入help就可以得到相关的帮助。

### sh

sh 由Steve Bourne开发，是Bourne Shell的缩写，sh 是Unix 标准默认的shell。

### ash

ash shell 是由Kenneth Almquist编写的，Linux中占用系统资源最少的一个小shell，它只包含24个内部命令，因而使用起来很不方便。

### csh

csh 是Linux比较大的内核，它由以William Joy为代表的共计47位作者编成，共有52个内部命令。该shell其实是指向/bin/tcsh这样的一个shell，也就是说，csh其实就是tcsh。

### ksh

ksh 是Korn shell的缩写，由Eric Gisin编写，共有42条内部命令。该shell最大的优点是几乎和商业发行版的ksh完全兼容，这样就可以在不用花钱购买商业版本的情况下尝试商业版本的性能了。

注意：bash是 Bourne Again Shell 的缩写，是linux标准的默认shell ，它基于Bourne shell，吸收了C shell和Korn shell的一些特性。bash完全兼容sh，也就是说，用sh写的脚本可以不加修改的在bash中执行。


### Shell脚本语言与编译型语言的差异

大体上，可以将程序设计语言可以分为两类：编译型语言和解释型语言。

#### 编译型语言

很多传统的程序设计语言，例如Fortran、Ada、Pascal、C、C++和Java，都是编译型语言。这类语言需要预先将我们写好的源代码(source code)转换成目标代码(object code)，这个过程被称作“编译”。

运行程序时，直接读取目标代码(object code)。由于编译后的目标代码(object code)非常接近计算机底层，因此执行效率很高，这是编译型语言的优点。

但是，由于编译型语言多半运作于底层，所处理的是字节、整数、浮点数或是其他机器层级的对象，往往实现一个简单的功能需要大量复杂的代码。例如，在C++里，就很难进行“将一个目录里所有的文件复制到另一个目录中”之类的简单操作。

#### 解释型语言

解释型语言也被称作“脚本语言”。执行这类程序时，解释器(interpreter)需要读取我们编写的源代码(source code)，并将其转换成目标代码(object code)，再由计算机运行。因为每次执行程序都多了编译的过程，因此效率有所下降。

使用脚本编程语言的好处是，它们多半运行在比编译型语言还高的层级，能够轻易处理文件与目录之类的对象；缺点是它们的效率通常不如编译型语言。不过权衡之下，通常使用脚本编程还是值得的：花一个小时写成的简单脚本，同样的功能用C或C++来编写实现，可能需要两天，而且一般来说，脚本执行的速度已经够快了，快到足以让人忽略它性能上的问题。脚本编程语言的例子有awk、Perl、Python、Ruby与Shell。


## 什么时候使用Shell

因为Shell似乎是各UNIX系统之间通用的功能，并且经过了POSIX的标准化。因此，Shell脚本只要“用心写”一次，即可应用到很多系统上。

因此，之所以要使用Shell脚本是基于：

* 简单性：Shell是一个高级语言；通过它，你可以简洁地表达复杂的操作。
* 可移植性：使用POSIX所定义的功能，可以做到脚本无须修改就可在不同的系统上执行。
* 开发容易：可以在短时间内完成一个功能强大又妤用的脚本。

但是，考虑到Shell脚本的命令限制和效率问题，下列情况一般不使用Shell：

* 资源密集型的任务，尤其在需要考虑效率时（比如，排序，hash等等）。
* 需要处理大任务的数学操作，尤其是浮点运算，精确运算，或者复杂的算术运算（这种情况一般使用C++或FORTRAN 来处理）。
* 有跨平台（操作系统）移植需求（一般使用C 或Java）。
* 复杂的应用，在必须使用结构化编程的时候（需要变量的类型检查，函数原型，等等）。
* 对于影响系统全局性的关键任务应用。
* 对于安全有很高要求的任务，比如你需要一个健壮的系统来防止入侵、破解、恶意破坏等等。
* 项目由连串的依赖的各个部分组成。
* 需要大规模的文件操作。
* 需要多维数组的支持。
* 需要数据结构的支持，比如链表或数等数据结构。
* 需要产生或操作图形化界面 GUI。
* 需要直接操作系统硬件。
* 需要 I/O 或socket 接口。
* 需要使用库或者遗留下来的老代码的接口。
* 私人的、闭源的应用（shell 脚本把代码就放在文本文件中，全世界都能看到）。

如果你的应用符合上边的任意一条，那么就考虑一下更强大的语言吧——或许是Perl、Tcl、Python、Ruby——或者是更高层次的编译语言比如C/C++，或者是Java。即使如此，你会发现，使用shell来原型开发你的应用，在开发步骤中也是非常有用的。


## 第一个Shell脚本


```sh
# hello.sh
#!/bin/bash
echo "Hello World!"
```

增加可执行权限执行

```sh
chmod +x ./test.sh
./test.sh
```

注意，一定要写成./test.sh，而不是test.sh，./ 表示当前目录，否则找不到命令。


作为解释器参数

```sh
/bin/sh test.sh
```

这种方式运行的脚本，不需要在第一行指定解释器信息，写了也没用。


## Shell变量：Shell变量的定义、删除变量、只读变量、变量类型

### 定义变量

```sh
variableName="value"
```

注意，变量名和等号之间不能有空格，这可能和你熟悉的所有编程语言都不一样。

同时，变量名的命名须遵循如下规则：

* 首个字符必须为字母（a-z，A-Z）。
* 中间不能有空格，可以使用下划线（_）。
* 不能使用标点符号。
* 不能使用bash里的关键字（可用help命令查看保留关键字）。

### 使用变量

使用一个定义过的变量，只要在变量名前面加美元符号（$）即可，如：

```sh
your_name="mozhiyan"
echo $your_name
echo ${your_name}
```

变量名外面的花括号是可选的，加不加都行，加花括号是为了帮助解释器识别变量的边界，比如下面这种情况：

```sh
for skill in Ada Coffe Action Java
do
    echo "I am good at ${skill}Script"
done
```

如果不给skill变量加花括号，写成echo "I am good at $skillScript"，解释器就会把$skillScript当成一个变量（其值为空），代码执行结果就不是我们期望的样子了。

推荐给所有变量加上花括号，这是个好的编程习惯。

### 重新定义变量

已定义的变量，可以被重新定义，如：

```sh
myUrl="http://OutOfMemory.CN/cpp/linux/"
echo ${myUrl}
myUrl="http://OutOfMemory.CN/cpp/shell/"
echo ${myUrl}
```

这样写是合法的，但注意，第二次赋值的时候不能写 `$myUrl=http://OutOfMemory.CN/cpp/shell/`，使用变量的时候才加美元符（$）。

### 只读变量

使用 readonly 命令可以将变量定义为只读变量，只读变量的值不能被改变。

下面的例子尝试更改只读变量，结果报错：

```sh
#!/bin/bash
myUrl="http://OutOfMemory.CN/cpp/shell/"
readonly myUrl
myUrl="http://OutOfMemory.CN/cpp/danpianji/"
```

运行脚本，结果如下：

```sh
/bin/sh: NAME: This variable is read only.
```

### 删除变量

使用 unset 命令可以删除变量。

语法：

```sh
unset variable_name
```

变量被删除后不能再次使用；unset 命令不能删除只读变量。

举个例子：

```sh
#!/bin/sh
myUrl="http://OutOfMemory.CN/cpp/u/xitong/"
unset myUrl
echo $myUrl
```

上面的脚本没有任何输出。

### 变量类型

运行shell时，会同时存在三种变量：

* 局部变量 局部变量在脚本或命令中定义，仅在当前shell实例中有效，其他shell启动的程序不能访问局部变量。
* 环境变量 所有的程序，包括shell启动的程序，都能访问环境变量，有些程序需要环境变量来保证其正常运行。必要的时候shell脚本也可以定义环境变量。
* shell变量 shell变量是由shell程序设置的特殊变量。shell变量中有一部分是环境变量，有一部分是局部变量，这些变量保证了shell的正常运行

### 变量替换，命令替换，转义字符

如果表达式中包含特殊字符，Shell 将会进行替换。例如，在双引号中使用变量就是一种替换，转义字符也是一种替换。

举个例子：

```sh
#!/bin/bash
a=10
echo -e "Value of a is $a \n"
```

```
运行结果：
Value of a is 10
这里 -e 表示对转义字符进行替换。如果不使用 -e 选项，将会原样输出：
Value of a is 10\n
```

下面的转义字符都可以用在 echo 中：

转义字符 | 含义
--------|-----
\\ | 反斜杠
\a | 警报，响铃
\b | 退格（删除键）
\f | 换页(FF)，将当前位置移到下页开头
\n | 换行
\r | 回车
\t | 水平制表符（tab键）
\v | 垂直制表符

可以使用 echo 命令的 -E 选项禁止转义，默认也是不转义的；使用 -n 选项可以禁止插入换行符。

### 命令替换

命令替换是指Shell可以先执行命令，将输出结果暂时保存，在适当的地方输出。

命令替换的语法：

```sh
`command`
```

注意是反引号，不是单引号，这个键位于 Esc 键下方。

下面的例子中，将命令执行结果保存在变量中：

```sh
#!/bin/bash
DATE=`date`
echo "Date is $DATE"
USERS=`who | wc -l`
echo "Logged in user are $USERS"
UP=`date ; uptime`
echo "Uptime is $UP"
```

```
运行结果：
Date is Thu Jul  2 03:59:57 MST 2009Logged in user are 1Uptime is Thu Jul  2 03:59:57 MST 200903:59:57 up 20 days, 14:03,  1 user,  load avg: 0.13, 0.07, 0.15
变量替换
变量替换可以根据变量的状态（是否为空、是否定义等）来改变它的值
```

可以使用的变量替换形式：

形式 | 说明
-----|-----
${var}         | 变量本来的值
${var:-word}   | 如果变量 var 为空或已被删除(unset)，那么返回 word，但不改变 var 的值。
${var:=word}   | 如果变量 var 为空或已被删除(unset)，那么返回 word，并将 var 的值设置为 word。
${var:?message}| 如果变量 var 为空或已被删除(unset)，那么将消息 message 送到标准错误输出，可以用来检测变量 var 是否可以被正常赋值。 若此替换出现在Shell脚本中，那么脚本将停止运行。
${var:+word}   | 如果变量 var 被定义，那么返回 word，但不改变 var 的值。


请看下面的例子：

```sh
#!/bin/bash
echo ${var:-"Variable is not set"}
echo "1 - Value of var is ${var}"
echo ${var:="Variable is not set"}
echo "2 - Value of var is ${var}"
unset var
echo ${var:+"This is default value"}
echo "3 - Value of var is $var"
var="Prefix"
echo ${var:+"This is default value"}
echo "4 - Value of var is $var"
echo ${var:?"Print this message"}
echo "5 - Value of var is ${var}"

运行结果：
Variable is not set1 - Value of var isVariable is not set2 - Value of var is Variable is not set
3 - Value of var isThis is default value
4 - Value of var is PrefixPrefix5 - Value of var is Prefix
```

```
shell变量是一种很“弱”的变量，默认情况下，一个变量保存一个串，shell不关心这个串是什么含义。
所以若要进行数学运算，必须使用一些命令例如let、declare、expr、双括号等。
shell变量可分为两类：局部变量和环境变量。局部变量只在创建它们的shell中可用。而环境变量则可以在创建它们的shell及其派生出来的任意子进程中使用。
有些变量是用户创建的，其他的则是专用shell变量。变量名必须以字母或下划线字符开头。其余的字符可以是字母、数字(0~9)或下划线字符。
任何其他的字符都标志着变量名的终止。名字是大小写敏感的。给变量赋值时，等号周围不能有任何空白符。
为了给变量赋空值，可以在等号后跟一个换行符。用set命令可以查看所有的变量，unset var命令可以清除变量var，var相当于没有定义过。
readonly var可以把var变为只读变量，定义之后不能对var进行任何更改。对shell变量的引用方式很多，用这些方式可以方便的获取shell变量的值，变量值的长度，变量的一个字串，变量被部分替换后的值等等。
```

### 2 环境变量

环境变量的定义方法如下：

```sh
var=value
export var
```

shell在初始化的时候会在执行profile等初始化脚本，脚本中定义了一些环境变量，这些变量会在创建子进程时传递给子进程。

用env命令可以查看当前的环境变量。常用的系统环境变量如下：

变量名 | 解释
----------|----------------------
_(下划线)  |上一条命令的最后一个参数
BASH      | 展开为调用bash实例时使用的全路径名
CDPATH    | cd命令的搜索路径。它是以冒号分隔的目录列表，shell通过它来搜索cd命令指定的目标目录。例如.:~:/usr
EDITOR    | 内置编辑器emacs、gmacs或vi的路径名
ENV       | 每一个新的bash shell(包括脚本)启动时执行的环境文件。通常赋予这个变量的文件名是.bashrc。
EUID      | 展开为在shell启动时被初始化的当前用户的有效ID
GROUPS    | 当前用户所属的组
HISTFILE  | 指定保存命令行历史的文件。默认值是~/.bash_history。如果被复位，交互式shell退出时将不保存命令行历史
HISTSIZE  | 记录在命令行历史文件中的命令数。默认是500
HOME      | 主目录。未指定目录时，cd命令将转向该目录
IFS       | 内部字段分隔符，一般是空格符、制表符和换行符，用于由命令替换，循环结构中的表和读取的输入产生的词的字段划分
LANG      | 用来为没有以LC_开头的变量明确选取的种类确定locale类
OLDPWD    | 前一个工作目录
PATH      | 命令搜索路径。一个由冒号分隔的目录列表，shell用它来搜索命令，一个普通值为 /usr/gnu/bin:/usr/local/bin:/usr/ucb:/usr/bin
PPID      | 父进程的进程ID
PS1       | 主提示符串，默认值是$
PS2       | 次提示符串，默认值是>
PS3       | 与select命令一起使用的选择提示符串，默认值是#?
PS4       | 当开启追踪时使用的调试提示符串，默认值是+。追踪可以用set –x开启
PWD       | 当前工作目录。由cd设置
RANDOM    | 每次引用该变量，就产生一个随机整数。随机数序列可以通过给RANDOM赋值来初始化。如果RANDOM被复位，即使随后再设置，它也将失去特定的属性
REPLY     | 当没有给read提供参数时设置
SHELL     | 当调用shell时，它扫描环境变量以寻找该名字。shell给PATH、PS1、PS2、MAILCHECK和IFS设置默认值。HOME和MAIL由login(1)设置
SHELLOPTS | 包含一列开启的shell选项，比如braceexpand、hashall、monitor等
UID       | 展开为当前用户的用户ID，在shell启动时初始化


### 5 特殊变量

变量名 | 解释
---------| -------------------
$0       | 当前脚本的文件名
$num     | num为从1开始的数字，$1是第一个参数，$2是第二个参数，${10}是第十个参数
$#       | 传入脚本的参数的个数
$*       | 所有的位置参数(作为单个字符串)
$@       | 所有的位置参数(每个都作为独立的字符串)。
$?       | 当前shell进程中，上一个命令的返回值，如果上一个命令成功执行则$?的值为0，否则为其他非零值，常用做if语句条件
$$       | 当前shell进程的pid
$!       | 后台运行的最后一个进程的pid
$-       | 显示shell使用的当前选项
$_       | 之前命令的最后一个参数


## Shell注释

以 `#` 开头的行就是注释，会被解释器忽略。sh里没有多行注释，只能每一行加一个#号。只能像这样：

```sh
#---------------------------------------
# shell 教程
# 以`#`开头的行就是注释，会被解释器忽略。
# sh里没有多行注释，只能每一行加一个#号。只能像这样：
#--------------------------------------------
# 这是一个自动打ipa的脚本，基于webfrogs的ipa-build书写：
# https://github.com/webfrogs/xcode_shell/blob/master/ipa-build
# 功能：自动为etao ios app打包，产出物为14个渠道的ipa包# 特色：全自动打包，不需要输入任何参数
#--------------------------------------------
##### 用户配置区 开始
######## 项目根目录，推荐将此脚本放在项目的根目录，这里就不用改了# 应用名，确保和Xcode里Product下的target_name.app名字一致
###### 用户配置区 结束  #####
```

如果在开发过程中，遇到大段的代码需要临时注释起来，过一会儿又取消注释，怎么办呢？

每一行加个#符号太费力了，可以把这一段要注释的代码用一对花括号括起来，定义成一个函数，没有地方调用这个函数，这块代码就不会执行，达到了和注释一样的效果。

## Shell字符串

字符串是shell编程中最常用最有用的数据类型（除了数字和字符串，也没啥其它类型好用了），字符串可以用单引号，也可以用双引号，也可以不用引号。单双引号的区别跟PHP类似。

### 单引号

```sh
str='this is a string'
```

单引号字符串的限制：

* 单引号里的任何字符都会原样输出，单引号字符串中的变量是无效的；
* 单引号字串中不能出现单引号（对单引号使用转义符后也不行）。

### 双引号

```sh
your_name='qinjx'
str="Hello, I know your are \"$your_name\"! \n"
```

双引号的优点：

* 双引号里可以有变量
* 双引号里可以出现转义字符

拼接字符串

```sh
your_name="qinjx"
greeting="hello, "$your_name" !"
greeting_1="hello, ${your_name} !"
echo $greeting $greeting_1
```

获取字符串长度

```sh
string="abcd"
echo ${#string} #输出 4
```

提取子字符串

```sh
string="alibaba is a great company"
echo ${string:1:4} #输出liba
```

查找子字符串

```sh
string="alibaba is a great company"
echo `expr index "$string" is`
```

一、判断读取字符串值

表达式 | 含义
----------------|--------
${var}          | 变量var的值, 与$var相同
${var-DEFAULT}  | 如果var没有被声明, 那么就以$DEFAULT作为其值 *
${var:-DEFAULT} | 如果var没有被声明, 或者其值为空, 那么就以$DEFAULT作为其值 *
${var=DEFAULT}  | 如果var没有被声明, 那么就以$DEFAULT作为其值 *
${var:=DEFAULT} | 如果var没有被声明, 或者其值为空, 那么就以$DEFAULT作为其值 *
${var+OTHER}    | 如果var声明了, 那么其值就是$OTHER, 否则就为null字符串
${var:+OTHER}   | 如果var被设置了, 那么其值就是$OTHER, 否则就为null字符串
${var?ERR\_MSG} | 如果var没被声明, 那么就打印$ERR_MSG *
${var:?ERR\_MSG}| 如果var没被设置, 那么就打印$ERR_MSG *
${!varprefix*}  | 匹配之前所有以varprefix开头进行声明的变量
${!varprefix@}  | 匹配之前所有以varprefix开头进行声明的变量

二、字符串操作（长度，读取，替换）

表达式 | 含义
---------------------------------|------------------------------------------------------------------
${#string}                       | $string的长度
${string:position}               | 在$string中, 从位置$position开始提取子串
${string:position:length}        | 在$string中, 从位置$position开始提取长度为$length的子串
${string#substring}              | 从变量$string的开头, 删除最短匹配$substring的子串
${string##substring}             | 从变量$string的开头, 删除最长匹配$substring的子串
${string%substring}              | 从变量$string的结尾, 删除最短匹配$substring的子串
${string%%substring}             | 从变量$string的结尾, 删除最长匹配$substring的子串
${string/substring/replacement}  | 使用$replacement, 来代替第一个匹配的$substring
${string//substring/replacement} | 使用$replacement, 代替所有匹配的$substring
${string/#substring/replacement} | 如果$string的前缀匹配$substring, 那么就用$replacement来代替匹配到的$substring
${string/%substring/replacement} | 如果$string的后缀匹配$substring, 那么就用$replacement来代替匹配到的$substring

在shell中，通过awk,sed,expr 等都可以实现，字符串上述操作。下面我们进行性能比较。


## Shell数组：shell数组的定义、数组长度

Shell在编程方面比Windows批处理强大很多，无论是在循环、运算。

bash支持一维数组（不支持多维数组），并且没有限定数组的大小。类似与C语言，数组元素的下标由0开始编号。获取数组中的元素要利用下标，下标可以是整数或算术表达式，其值应大于或等于0。

### 定义数组

在Shell中，用括号来表示数组，数组元素用“空格”符号分割开。定义数组的一般形式为：

```sh
array_name=(value1 ... valuen)
```

例如：

```sh
array_name=(value0 value1 value2 value3)
```

或者

```sh
array_name=(
value0
value1
value2
value3
)
```

还可以单独定义数组的各个分量：

```sh
array_name[0]=value0
array_name[1]=value1
array_name[2]=value2
```

可以不使用连续的下标，而且下标的范围没有限制。

### 读取数组

读取数组元素值的一般格式是：

```sh
${array_name[index]}
```

例如：

```sh
valuen=${array_name[2]}
```

举个例子：

```sh
#!/bin/sh
NAME[0]="Zara"
NAME[1]="Qadir"
NAME[2]="Mahnaz"
NAME[3]="Ayan"
NAME[4]="Daisy"
echo "First Index: ${NAME[0]}"
echo "Second Index: ${NAME[1]}"
```

```sh
运行脚本，输出：
$./test.sh
First Index: ZaraSecond Index: Qadir
```

使用@ 或 * 可以获取数组中的所有元素，例如：

```sh
${array_name[*]}
${array_name[@]}
```

举个例子：

```sh
#!/bin/sh
NAME[0]="Zara"
NAME[1]="Qadir"
NAME[2]="Mahnaz"
NAME[3]="Ayan"
NAME[4]="Daisy"
echo "First Method: ${NAME[*]}"
echo "Second Method: ${NAME[@]}"
```

```sh
运行脚本，输出：
$./test.sh
First Method: Zara Qadir Mahnaz Ayan DaisySecond Method: Zara Qadir Mahnaz Ayan Daisy
```

### 获取数组的长度

获取数组长度的方法与获取字符串长度的方法相同，例如：

```sh
# 取得数组元素的个数
length=${#array_name[@]}# 或者
length=${#array_name[*]}# 取得数组单个元素的长度
lengthn=${#array_name[n]}
```


## Shell 分支控制

### if-else

if 语句通过关系运算符判断表达式的真假来决定执行哪个分支。Shell 有三种 if ... else 语句：

* if ... fi 语句；
* if ... else ... fi 语句；
* if ... elif ... else ... fi 语句。

### if ... else 语句

语法：

```sh
if [ expression ] then
   Statement(s) to be executed if expression is true
fi
```

如果 expression 返回 true，then 后边的语句将会被执行；如果返回 false，不会执行任何语句。

最后必须以 fi 来结尾闭合 if，fi 就是 if 倒过来拼写，后面也会遇见。

注意：expression 和方括号([ ])之间必须有空格，否则会有语法错误。

举个例子：

```sh
#!/bin/sh
a=10
b=20
if [ $a == $b ] then
   echo "a is equal to b"
fi
if [ $a != $b ] then
   echo "a is not equal to b"
fi
```

```
运行结果：
a is not equal to b
```

### if ... else ... fi 语句

```sh
if [ expression ]
then
   Statement(s) to be executed if expression is true
else
   Statement(s) to be executed if expression is not true
fi
```

如果 expression 返回 true，那么 then 后边的语句将会被执行；否则，执行 else 后边的语句。

举个例子：

```sh
#!/bin/sh
a=10
b=20
if [ $a == $b ] then
   echo "a is equal to b" 
else
   echo "a is not equal to b"
fi
```

```
执行结果：
a is not equal to b
```

### if ... elif ... fi 语句

```sh
if [ expression 1 ] then
   Statement(s) to be executed if expression 1 is true
elif [ expression 2 ] then
   Statement(s) to be executed if expression 2 is true
elif [ expression 3 ] then
   Statement(s) to be executed if expression 3 is true
else
   Statement(s) to be executed if no expression is true
fi
```

哪一个 expression 的值为 true，就执行哪个 expression 后面的语句；如果都为 false，那么不执行任何语句。

举个例子：

```sh
#!/bin/sh
a=10
b=20
if [ $a == $b ] then
   echo "a is equal to b"
elif [ $a -gt $b ] then
   echo "a is greater than b"
elif [ $a -lt $b ] then
   echo "a is less than b"
else
   echo "None of the condition met"
fi
```

```
运行结果：
a is less than b
```

if ... else 语句也可以写成一行，以命令的方式来运行，像这样：

```sh
if test $[2*3] -eq $[1+5]; then echo 'The two numbers are equal!'; fi;
```

if ... else 语句也经常与 test 命令结合使用，如下所示：

```sh
num1=$[2*3]
num2=$[1+5]
if test $[num1] -eq $[num2] then
    echo 'The two numbers are equal!'
else
    echo 'The two numbers are not equal!'
fi
```

```
输出：
The two numbers are equal!
test 命令用于检查某个条件是否成立，与方括号([ ])类似。
```

## case-esac

case ... esac 与其他语言中的 switch ... case 语句类似，是一种多分枝选择结构。

case 语句匹配一个值或一个模式，如果匹配成功，执行相匹配的命令。

case语句格式如下：

```sh
case word in
  pattern1)
     Statement(s) to be executed if pattern1 matches
     ;;
  pattern2)
     Statement(s) to be executed if pattern2 matches
     ;;
  pattern3)
     Statement(s) to be executed if pattern3 matches
     ;;
esac
```

`case` 工作方式如上所示。取值后面必须为关键字 `in`，每一模式必须以右括号结束。

取值可以为变量或常数。匹配发现取值符合某一模式后，其间所有命令开始执行直至 `;;`。

`;;` 与其他语言中的 break 类似，意思是跳到整个 `case` 语句的最后。

取值将检测匹配的每一个模式。一旦模式匹配，则执行完匹配模式相应命令后不再继续其他模式。如果无一匹配模式，使用星号 * 捕获该值，再执行后面的命令。

下面的脚本提示输入1到4，与每一种模式进行匹配：

```sh
echo 'Input a number between 1 to 4'
echo 'Your number is:\c'
read aNum
case $aNum in
    1)  echo 'You select 1'
    ;;
    2)  echo 'You select 2'
    ;;
    3)  echo 'You select 3'
    ;;
    4)  echo 'You select 4'
    ;;
    *)  echo 'You do not select a number between 1 to 4'
    ;;
esac
```

```
输入不同的内容，会有不同的结果，例如：
Input a number between 1 to 4
Your number is:3
You select 3
```

## Shell 循环控制

## for

```sh
for 变量 in 列表 do
    command1
    command2
    ...
    commandN
done
```

列表是一组值（数字、字符串等）组成的序列，每个值通过空格分隔。每循环一次，就将列表中的下一个值赋给变量。

`in` 列表是可选的，如果不用它，`for` 循环使用命令行的位置参数。

例如，顺序输出当前列表中的数字：

```sh
for loop in 1 2 3 4 5
do
    echo "The value is: $loop"
done
```

```
运行结果：
The value is: 1The value is: 2The value is: 3The value is: 4The value is: 5
```

顺序输出字符串中的字符：

```sh
for str in 'This is a string'
do
    echo $str
done
```

```
运行结果：
This is a string
```

显示主目录下以 .bash 开头的文件：

```sh
#!/bin/bash
for FILE in $HOME/.bash*
do
   echo $FILE
done
```

```
运行结果：
/root/.bash_history
/root/.bash_logout
/root/.bash_profile
/root/.bashrc
```

## while

while循环用于不断执行一系列命令，也用于从输入文件中读取数据；命令通常为测试条件。其格式为：

```sh
while command
do
   Statement(s) to be executed if command is true
done
```

命令执行完毕，控制返回循环顶部，从头开始直至测试条件为假。

以下是一个基本的while循环，测试条件是：如果COUNTER小于5，那么返回 true。

COUNTER从0开始，每次循环处理时，COUNTER加1。运行上述脚本，返回数字1到5，然后终止。

```sh
COUNTER=0
while [ $COUNTER -lt 5 ]
do
    COUNTER='expr $COUNTER+1'
    echo $COUNTER
done
```

```
运行脚本，输出：
12345
```

while循环可用于读取键盘信息。下面的例子中，输入信息被设置为变量FILM，按`<Ctrl-D>`结束循环。

```sh
echo 'type `<CTRL-D>` to terminate'
echo -n 'enter your most liked film:'
while read FILM
do
    echo "Yeah! great film the $FILM"
done
```

```
运行脚本，输出类似下面：
type `<CTRL-D>` to terminate
enter your most liked film: Sound of MusicYeah! great film the Sound of Music
```

### until

until 循环执行一系列命令直至条件为 true 时停止。

until 循环与 while 循环在处理方式上刚好相反。

一般while循环优于until循环，但在某些时候，也只是极少数情况下，until 循环更加有用。

until 循环格式为：

```sh
until command
do
   Statement(s) to be executed when command is true
done
```

command 一般为条件表达式，如果返回值为 false，则继续执行循环体内的语句，否则跳出循环。

例如，使用 until 命令输出 0 ~ 9 的数字：

```sh
#!/bin/bash
a=0
until [ ! $a -lt 10 ]
do
   echo $a
   a=`expr $a + 1`
done
```

```
运行结果：
0123456789
Shell break和continue命令
在循环过程中，有时候需要在未达到循环结束条件时强制跳出循环，像大多数编程语言一样，Shell也使用 break 和 continue 来跳出循环。
```

### break

```sh
break
break n
```

break命令允许跳出所有循环（终止执行后面的所有循环）。

下面的例子中，脚本进入死循环直至用户输入数字大于5。要跳出这个循环，返回到shell提示符下，就要使用break命令。

```sh
#!/bin/bash
while :
do
    echo -n "Input a number between 1 to 5: "

    read aNum

    case $aNum in
        1|2|3|4|5) echo "Your number is $aNum!"
        ;;
        *) echo "You do not select a number between 1 to 5, game is over!"
            break
        ;;
    esac
done
```

在嵌套循环中，break 命令后面还可以跟一个整数，表示跳出第几层循环。

例如：

```sh
break n
```

表示跳出第 n 层循环。

下面是一个嵌套循环的例子，如果 var1 等于 2，并且 var2 等于 0，就跳出循环：

```sh
#!/bin/bash
for var1 in 1 2 3
do
   for var2 in 0 5
   do
      if [ $var1 -eq 2 -a $var2 -eq 0 ]
      then
         break 2
      else
         echo "$var1 $var2"
      fi
   done
done
```

如上，break 2 表示直接跳出外层循环。

```
运行结果：
1 01 5
```

### continue

```sh
continue
continue n
```

continue命令与break命令类似，只有一点差别，它不会跳出所有循环，仅仅跳出当前循环。

对上面的例子进行修改：

```sh
#!/bin/bash
while :
do
    echo -n "Input a number between 1 to 5: "
    read aNum
    case $aNum in
        1|2|3|4|5) echo "Your number is $aNum!"
        ;;
        *) echo "You do not select a number between 1 to 5!"
            continue
            echo "Game is over!"
        ;;
    esac
done
```

运行代码发现，当输入大于5的数字时，该例中的循环不会结束，语句：

```sh
echo "Game is over!"
```

永远不会被执行。

同样，continue 后面也可以跟一个数字，表示跳出第几层循环。

再看一个 continue 的例子：

```sh
#!/bin/bash
NUMS="1 2 3 4 5 6 7"
for NUM in $NUMS
do
   Q=`expr $NUM % 2`
   if [ $Q -eq 0 ]
   then
      echo "Number is an even number!!"
      continue
   fi
   echo "Found odd number"
done
```

```
运行结果：
Found odd number
Number is an even number!!Found odd number
Number is an even number!!Found odd number
Number is an even number!!Found odd number
```

## Shell 算数

### Shell 算数运算

算术运算符列表
运算符 | 说明 | 举例
------|------|-----
+| 加法`expr $a + $b` 结果为 30。|
-| 减法`expr $a - $b` 结果为 10。 |
*| 乘法`expr $a \* $b` 结果为  2 |
/| 除法`expr $b / $a` 结果为 2。 |
%| 取余`expr $b % $a` 结果为 0。 |
=| 赋值a=$b 将把变量 b 的值赋给 a。 |

### 按位操作运算符

运算符 | 名称 | 举例 | 解释value的值
------|------|-----|-----
<<   | 左移|   value=4>>2   | 4左移2位，value值为16
\>\> | 右移|   value=8<<2   | 8右移2位，value值为2
\&   | 按位与|  value=8&&4| 8按位与4，value值为0
|    | 按位或|  value=8|4| 8按位或4，value值为12
~    | 按位非|  value=~8    | 按位非8，value值为-9
^    | 按位异或| value=10^3   | 10按位异或3，value值为9

注：

对于按位非，若求“~a”则结果为-（a+1）举一个详细例子：求“~8”分析由于计算机通常用补码进行符号运算，[[x]补]补=[x]

所以 则8的二进制为00001000 求非为11110111，求反码为1001000求补码为1001001所以最后的结果为1001001，~8 即为-9。

### Shell 关系运算

关系运算符列表

运算符 | 说明 | 举例
------|------|-----
-eq | 检测两个数是否相等，相等返回 true。                 | [ $a -eq $b ] 返回 true。
-ne | 检测两个数是否相等，不相等返回 true。               | [ $a -ne $b ] 返回 true。
-gt | 检测左边的数是否大于右边的，如果是，则返回 true。    | [ $a -gt $b ] 返回 false。
-lt | 检测左边的数是否小于右边的，如果是，则返回 true。    | [ $a -lt $b ] 返回 true。
-ge | 检测左边的数是否大等于右边的，如果是，则返回 true。  | [ $a -ge $b ] 返回 false。
-le | 检测左边的数是否小于等于右边的，如果是，则返回 true。| [ $a -le $b ] 返回 true。
-a  | 双方都成立（and） 逻辑表达式 –a 逻辑表达式
-o  | 单方成立（or） 逻辑表达式 –o 逻辑表达式
-z  | 空字符串
-n  | 非空字符串
=   | 等于 应用于：整型或字符串比较 如果在[] 中，只能是字符串
!=  | 不等于 应用于：整型或字符串比较 如果在[] 中，只能是字符串
<   | 小于 应用于：整型比较 在[] 中，不能使用 表示字符串
\>  | 大于 应用于：整型比较 在[] 中，不能使用 表示字符串

### Shell 布尔运算

布尔运算符列表

运算符 | 说明 | 举例
------|------|-----
!  | 非运算，表达式为 true 则返回 false，否则返回 true。 | [ ! false ] 返回 true。
-o | 或运算，有一个表达式为 true 则返回 true。          | [ $a -lt 20 -o $b -gt 100 ] 返回 true。
-a | 与运算，两个表达式都为 true 才返回 true。          | [ $a -lt 20 -a $b -gt 100 ] 返回 false。

### Shell 字符串运算

字符串运算符列表

运算符 | 说明 | 举例
------|------|-----
=| 检测两个字符串是否相等，相等返回 true。 | [ $a = $b ] 返回 false。
!=| 检测两个字符串是否相等，不相等返回 true。 | [ $a != $b ] 返回 true。
-z| 检测字符串长度是否为0，为0返回 true。 | [ -z $a ] 返回 false。
-n| 检测字符串长度是否为0，不为0返回 true。 | [ -z $a ] 返回 true。
str| 检测字符串是否为空，不为空返回 true。| [  $a ] 返回 true。

### Shell 文件测试运算

文件测试运算符列表

操作符 | 说明 | 举例
------|------|-----
-b file | 检测文件是否是块设备文件，如果是，则返回 true。 | [ -b $file ] 返回 false。
-c file | 检测文件是否是字符设备文件，如果是，则返回 true。 | [ -b $file ] 返回 false。
-d file | 检测文件是否是目录，如果是，则返回 true。 | [ -d $file ] 返回 false。
-f file | 检测文件是否是普通文件（既不是目录，也不是设备文件），如果是，则返回 true。 | [ -f $file ] 返回 true。
-p file | 检测文件是否是具名管道，如果是，则返回 true。 | [ -p $file ] 返回 false。
-S file | 侦测是否为一个『 socket 标签档案』 |
-L file | 侦测是否为一个『 symbolic link 的档案』  |
-e file | 检测文件（包括目录）是否存在，如果是，则返回 true。 | [ -e $file ] 返回 true。
-r file | 检测文件是否可读，如果是，则返回 true。 | [ -r $file ] 返回 true。
-w file | 检测文件是否可写，如果是，则返回 true。 | [ -w $file ] 返回 true。
-x file | 检测文件是否可执行，如果是，则返回 true。 | [ -x $file ] 返回 true。
-s file | 检测文件是否为空（文件大小是否大于0），不为空返回 true。 | [ -s $file ] 返回 true。
-u file | 检测文件是否设置了 SUID 位，如果是，则返回 true。 | [ -u $file ] 返回 false。
-g file | 检测文件是否设置了 SGID 位，如果是，则返回 true。 | [ -g $file ] 返回 false。
-k file | 检测文件是否设置了粘着位(Sticky Bit)，如果是，则返回 true。 | [ -k $file ] 返回 false。
-G file | 侦测是否由 GID 所执行的程序所拥有 |
-O file | 侦测是否由 UID 所执行的程序所拥有 |
-nt     | 第一个档案比第二个档案新 | [ test file1 -nt file2 ]
-ot     | 第一个档案比第二个档案旧 | [ test file1 -ot file2 ]
-ef     | 第一个档案与第二个档案为同一个档案 | [ test file1 -ef file2 ]

## 逻辑表达式

### test

使用方法：

```sh
test EXPRESSION
```

如：

```sh
test 1 = 1 && echo 'ok'
test -d /etc/ && echo 'ok'
test 1 -eq 1 && echo 'ok'
if test 1 = 1 ; then echo 'ok'; fi
```

注意：所有字符 与逻辑运算符直接用“空格”分开，不能连到一起。

## 精简表达式

* [] 表达式

```sh
[ 1 -eq 1 ] && echo 'ok'
[ 2 < 1 ] && echo 'ok'
[ 2 \< 1 ] && echo 'ok'
[ 2 -gt 1 -a 3 -lt 4 ] && echo 'ok'
[ 2 -gt 1 && 3 -lt 4 ] && echo 'ok'
```

注意：

在[] 表达式中，常见的 `>,<` 需要加转义字符，表示字符串大小比较，以acill码 位置作为比较。 

不直接支持`<>`运算符，还有逻辑运算符 `|| &&` 它需要用`-a[and] –o[or]`表示。

* [[]] 表达式

```sh
[ 1 -eq 1 ] && echo 'ok'
[[ 2 < 3 ]] && echo 'ok'
[[ 2 < 3 && 4 > 5 ]] && echo 'ok'
```

## 性能比较

bash的条件表达式中有三个几乎等效的符号和命令：`test`，`[]`和`[[]]`。

通常，大家习惯用`if []; then`这样的形式。而`[[]]`的出现，根据ABS所说，是为了兼容`><`之类的运算符。

以下是比较它们性能，发现`[[]]`是最快的。

```sh
$ time (for m in {1..100000}; do test -d .;done;)
real    0m0.658s
user    0m0.558s
sys     0m0.100s

$ time (for m in {1..100000}; do [ -d . ];done;)
real    0m0.609s
user    0m0.524s
sys     0m0.085s

$ time (for m in {1..100000}; do [[ -d . ]];done;)
real    0m0.311s
user    0m0.275s
sys     0m0.036s
```

不考虑对低版本bash和对sh的兼容的情况下，用[[]]是兼容性强，而且性能比较快，在做条件运算时候，可以使用该运算符。

## Shell函数：Shell函数返回值、删除函数、在终端调用函数

函数可以让我们将一个复杂功能划分成若干模块，让程序结构更加清晰，代码重复利用率更高。像其他编程语言一样，Shell 也支持函数。Shell 函数必须先定义后使用。

### Shell 函数的定义

格式如下：

```sh
function_name () {
    list of commands
    [ return value ]
}

function function_name () {
    list of commands
    [ return value ]
}
```

函数返回值：可以显式增加return语句；如果不加，会将最后一条命令运行结果作为返回值。

Shell 函数返回值只能是整数，一般用来表示函数执行成功与否，0表示成功，其他值表示失败。

如果 return 其他数据，比如一个字符串，往往会得到错误提示：“numeric argument required”。

如果一定要让函数返回字符串，那么可以先定义一个变量，用来接收函数的计算结果，脚本在需要的时候访问这个变量来获得函数返回值。

先来看一个例子：

```sh
#!/bin/bash
# Define your function
hereHello () {
 echo "Url is http://OutOfMemory.CN/cpp/shell/"
}
# Invoke your functionHello
```

```
运行结果：
$./test.sh
Hello World
```

调用函数只需要给出函数名，不需要加括号。

再来看一个带有return语句的函数：

```sh
#!/bin/bash
funWithReturn (){
    echo "The function is to get the sum of two numbers..."
    echo -n "Input first number: "
    read aNum
    echo -n "Input another number: "
    read anotherNum
    echo "The two numbers are $aNum and $anotherNum !"
    return $(($aNum+$anotherNum))
}
```

```
funWithReturn
Capture value returnd by last command
ret=$?
echo "The sum of two numbers is $ret !"
运行结果：
The function is to get the sum of two numbers...Input first number: 25Input another number: 50The two numbers are 25 and 50 !The sum of two numbers is 75 !
```

函数返回值在调用该函数后通过 $? 来获得。

再来看一个函数嵌套的例子：


```sh
#!/bin/bash
# Calling one function from another
number_one () {
   echo "Url_1 is http://OutOfMemory.CN/cpp/shell/"
   number_two
}
number_two () {
   echo "Url_2 is http://OutOfMemory.CN/cpp/u/xitong/"
}
number_one
```

```
运行结果：
Url_1 is `http://OutOfMemory.CN/cpp/shell/`
Url_2 is `http://OutOfMemory.CN/cpp/u/xitong/`
```

像删除变量一样，删除函数也可以使用 unset 命令，不过要加上 .f 选项，如下所示：

```sh
unset .f function_name
```

如果你希望直接从终端调用函数，可以将函数定义在主目录下的 `.profile` 文件，这样每次登录后，在命令提示符后面输入函数名字就可以立即调用。

### Shell函数参数

在Shell中，调用函数时可以向其传递参数。

在函数体内部，通过 `$n` 的形式来获取参数的值，例如，`$1`表示第一个参数，`$2`表示第二个参数...

带参数的函数示例：

```sh
#!/bin/bash
funWithParam (){
    echo "The value of the first parameter is $1 !"
    echo "The value of the second parameter is $2 !"
    echo "The value of the tenth parameter is $10 !"
    echo "The value of the tenth parameter is ${10} !"
    echo "The value of the eleventh parameter is ${11} !"
    echo "The amount of the parameters is $# !"  # 参数个数
    echo "The string of the parameters is $* !"  # 传递给函数的所有参数
}
funWithParam 1 2 3 4 5 6 7 8 9 34 73
```

```
运行脚本：
The value of the first parameter is 1 !
The value of the second parameter is 2 !
The value of the tenth parameter is 10 !
The value of the tenth parameter is 34 !
The value of the eleventh parameter is 73 !
The amount of the parameters is 12 !
The string of the parameters is 1 2 3 4 5 6 7 8 9 34 73 !"
```

注意，`$10` 不能获取第十个参数，获取第十个参数需要`${10}`。当`n>=10`时，需要使用`${n}`来获取参数。

另外，还有几个特殊变量用来处理参数，前面已经提到：

特殊变量|说明
---|-------------------
$# | 传递给函数的参数个数。
$* | 显示所有传递给函数的参数。
$@ | 与$*相同，但是略有区别，请查看Shell特殊变量。
$? | 函数的返回值。

## Shell输入输出重定向：Shell Here Document，/dev/null文件

Unix 命令默认从标准输入设备(stdin)获取输入，将结果输出到标准输出设备(stdout)显示。一般情况下，标准输入设备就是键盘，标准输出设备就是终端，即显示器。

### 输出重定向

命令的输出不仅可以是显示器，还可以很容易的转移向到文件，这被称为输出重定向。

命令输出重定向的语法为：

```sh
command > file
```

这样，输出到显示器的内容就可以被重定向到文件。

例如，下面的命令在显示器上不会看到任何输出：

```sh
who > users
```

打开 users 文件，可以看到下面的内容：

```sh
$ cat users
oko         tty01   Sep 12 07:30
ai          tty15   Sep 12 13:32
ruth        tty21   Sep 12 10:10
pat         tty24   Sep 12 13:07
steve       tty25   Sep 12 13:03
```


输出重定向会覆盖文件内容，请看下面的例子：

```sh
$ echo line 1 > users
$ cat users
line 1
```

如果不希望文件内容被覆盖，可以使用 >> 追加到文件末尾，例如：

```sh
$ echo line 2 >> users
$ cat users
line 1
line 2
```

### 输入重定向

和输出重定向一样，Unix 命令也可以从文件获取输入，语法为：

```sh
command < file
```

这样，本来需要从键盘获取输入的命令会转移到文件读取内容。

注意：输出重定向是大于号(>)，输入重定向是小于号(<)。

例如，计算 users 文件中的行数，可以使用下面的命令：

```
$ wc -l users
2 users
```

也可以将输入重定向到 users 文件：

```
$ wc -l < users
2
```

注意：上面两个例子的结果不同：第一个例子，会输出文件名；第二个不会，因为它仅仅知道从标准输入读取内容。

### 重定向深入讲解

一般情况下，每个 Unix/Linux 命令运行时都会打开三个文件：

* 标准输入文件(stdin)：stdin的文件描述符为0，Unix程序默认从stdin读取数据。
* 标准输出文件(stdout)：stdout 的文件描述符为1，Unix程序默认向stdout输出数据。
* 标准错误文件(stderr)：stderr的文件描述符为2，Unix程序会向stderr流中写入错误信息。

默认情况下，`command > file` 将 `stdout` 重定向到 `file`，`command < file` 将 `stdin` 重定向到 `file`。

如果希望 `stderr` 重定向到 `file`，可以这样写：

```sh
command 2 > file
```

如果希望 `stderr` 追加到 `file` 文件末尾，可以这样写：

```sh
command 2 >> file
```

`2` 表示标准错误文件(stderr)。

如果希望将 `stdout` 和 `stderr` 合并后重定向到 `file`，可以这样写：

```sh
command > file 2>&1
```

或

```sh
command >> file 2>&1
```

如果希望对 `stdin` 和 `stdout` 都重定向，可以这样写：

```sh
command < file1 > file2
```

`command` 命令将 `stdin` 重定向到 `file1`，将 `stdout` 重定向到 `file2`。 


全部可用的重定向命令列表

命令    | 说明
--------|----------------------
command >  file | 将输出重定向到 file。
command <  file | 将输入重定向到 file。
command >> file | 将输出以追加的方式重定向到 file。
n       >  file | 将文件描述符为 n 的文件重定向到 file。
n       >> file | 将文件描述符为 n 的文件以追加的方式重定向到 file。
n       >& m    | 将输出文件 m 和 n 合并。
n       <& m    | 将输入文件 m 和 n 合并。
<< tag          | 将开始标记 tag 和结束标记 tag 之间的内容作为输入。


### Here Document

Here Document 目前没有统一的翻译，这里暂译为”嵌入文档“。

Here Document 是 Shell 中的一种特殊的重定向方式，它的基本的形式如下：

```sh
command << delimiter
    document
delimiter
```

它的作用是将两个 `delimiter` 之间的内容(document) 作为输入传递给 `command`。

注意：

* 结尾的delimiter 一定要顶格写，前面不能有任何字符，后面也不能有任何字符，包括空格和 tab 缩进。
* 开始的delimiter前后的空格会被忽略掉。

下面的例子，通过 wc -l 命令计算 document 的行数：

```sh
wc -l << EOF
    This is a simple lookup program
    f-o-r good (and bad) restaurants
    i-n Cape Town.
EOF
3
```

也可以 将 Here Document 用在脚本中，例如：

```sh
#!/bin/bash
cat << EOF
This is a simple lookup program
f-o-r good (and bad) restaurants
i-n Cape Town.
EOF
```

```
运行结果：
This is a simple lookup program
for good (and bad) restaurants
in Cape Town.
```

下面的脚本通过 vi 编辑器将 document 保存到 test.txt 文件：


```sh
#!/bin/sh
filename=test.txt
vi $filename <<EndOfCommands
i
This file was created automatically from
a shell script
^[
ZZ
EndOfCommands
```

运行脚本：

```sh
$ sh test.sh
Vim: Warning: Input is not from a terminal
```

打开 test.txt，可以看到下面的内容：

```sh
$ cat test.txt
This file was created automatically from
a shell script
```

### /dev/null 文件

如果希望执行某个命令，但又不希望在屏幕上显示输出结果，那么可以将输出重定向到 /dev/null：

```sh
command > /dev/null
```

/dev/null 是一个特殊的文件，写入到它的内容都会被丢弃；如果尝试从该文件读取内容，那么什么也读不到。

但是 /dev/null 文件非常有用，将命令的输出重定向到它，会起到”禁止输出“的效果。

如果希望屏蔽 stdout 和 stderr，可以这样写：

```sh
command > /dev/null 2>&1
```

## Shell文件包含

像其他语言一样，Shell 也可以包含外部脚本，将外部脚本的内容合并到当前脚本。

Shell 中包含脚本可以使用：

```sh
. filename
```

或

```sh
source filename
```

两种方式的效果相同，简单起见，一般使用点号(.)，但是注意点号(.)和文件名中间有一空格。

例如，创建两个脚本，一个是被调用脚本 `subscript.sh`，内容如下：

url=`http://OutOfMemory.CN/cpp/view/2738.html`

一个是主文件 main.sh，内容如下：

```sh
#!/bin/bash. ./subscript.sh
echo $url
```

```
执行脚本：
$chomd +x main.sh
./main.sh
http://OutOfMemory.CN/cpp/view/2738.html
```


## Shell echo命令

echo是Shell的一个内部指令，用于在屏幕上打印出指定的字符串。

命令格式：

```sh
echo arg
```

您可以使用echo实现更复杂的输出格式控制。

显示转义字符

```sh
echo "\"It is a test\""
```

```
结果将是：
"It is a test"
```

双引号也可以省略。

显示变量

```sh
name="OK"
echo "$name It is a test"
```

```
结果将是：
OK It is a test
```

同样双引号也可以省略。

如果变量与其它字符相连的话，需要使用大括号（{ }）：

```sh
mouth=8
echo "${mouth}-1-2009"
```

```sh
结果将是：
8-1-2009
```

显示换行

```sh
echo "OK!\n"
echo "It is a test"

输出：
OK!
It is a test
```

显示不换行

```sh
echo "OK!\c"
echo "It is a test"

输出：
OK!It si a test
```

显示结果重定向至文件

```sh
echo "It is a test" > myfile
```

原样输出字符串

若需要原样输出字符串（不进行转义），请使用单引号。例如：

```sh
echo '$name\"'
```

显示命令执行结果

```sh
echo `date`
```

结果将显示当前日期

从上面可看出，双引号可有可无，单引号主要用在原样输出中。


### shell printf命令：格式化输出语句

`printf` 命令用于格式化输出， 是`echo`命令的增强版。它是C语言`printf()`库函数的一个有限的变形，并且在语法上有些不同。

注意：printf 由 POSIX 标准所定义，移植性要比 echo 好。

如同 echo 命令，printf 命令也可以输出简单的字符串：

```sh
printf "Hello, Shell\n"Hello, Shell
```

printf 不像 echo 那样会自动换行，必须显式添加换行符(\n)。

printf 命令的语法：

```sh
printf  format-string  [arguments...]
```

format-string 为格式控制字符串，arguments 为参数列表。

printf()在C语言入门教程中已经讲到，功能和用法与 printf 命令类似，请查看：C语言格式输出函数printf()详解

这里仅说明与C语言printf()函数的不同：

* printf 命令不用加括号
* format-string 可以没有引号，但最好加上，单引号双引号均可。
* 参数多于格式控制符(%)时，format-string 可以重用，可以将所有参数都转换。
* arguments 使用空格分隔，不用逗号。

请看下面的例子：

```sh
# format-string为双引号
$ printf "%d %s\n" 1 "abc"1 abc
# 单引号与双引号效果一样
$ printf '%d %s\n' 1 "abc"
1 abc
# 没有引号也可以输出
$ printf %s abcdef
abcdef
# 格式只指定了一个参数，但多出的参数仍然会按照该格式输出，format-string 被重用
$ printf %s abc def
abcdef
$ printf "%s\n" abc def
abc
def
$ printf "%s %s %s\n" a b c d e f g h i j
a b c
d e f
g h i
j
```

如果没有 `arguments`，那么 `%s` 用 `NULL` 代替，`%d` 用 `0` 代替

```sh
printf "%s and %d \n"
and 0
# 如果以 %d 的格式来显示字符串，那么会有警告，提示无效的数字，此时默认置为 0
```

```sh
printf "The first program always prints'%s,%d\n'" Hello Shell-bash: printf: Shell: invalid number
The first program always prints 'Hello,0'
```

注意，根据POSIX标准，浮点格式%e、%E、%f、%g与%G是“不需要被支持”。
这是因为 `awk` 支持浮点预算，且有它自己的 `printf` 语句。
这样Shell程序中需要将浮点数值进行格式化的打印时，可使用小型的 `awk` 程序实现。
然而，内建于 `bash`、`ksh93` 和 `zsh` 中的 `printf` 命令都支持浮点格式。
