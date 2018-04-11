## GIT对象模型

### SHA

所有用来表示项目历史信息的文件,是通过一个40个字符的（40-digit）“对象名”来索引的，对象名看起来像这样:

> 6ff87c4664981e4397625791c8ea3bbb5f2279a3

在后边使用对象名时，只使用前面几个字符即可，但是最少需要4个。

你会在Git里到处看到这种“40个字符”字符串。每一个“对象名”都是对“对象”内容做SHA1哈希计算得来的，（SHA1是一种密码学的哈希算法）。这样就意味着两个不同内容的对象不可能有相同的“对象名”。

这样做会有几个好处：

Git只要比较对象名，就可以很快的判断两个对象是否相同。
因为在每个仓库（repository）的“对象名”的计算方法都完全一样，如果同样的内容存在两个不同的仓库中，就会存在相同的“对象名”下。
Git还可以通过检查对象内容的SHA1的哈希值和“对象名”是否相同，来判断对象内容是否正确。

### 对象

每个对象(object) 包括三个部分：类型，大小和内容。大小就是指内容的大小，内容取决于对象的类型，有四种类型的对象："blob"、"tree"、 "commit" 和"tag"。

几乎所有的Git功能都是使用这四个简单的对象类型来完成的。它就像是在你本机的文件系统之上构建一个小的文件系统。

#### blob (文件) 对象

“blob”用来存储文件数据，通常是一个文件。

![blob](images/object-blob.png)

#### tree (树) 对象

“tree”有点像一个目录，它管理一些“tree”或是 “blob”（就像文件和子目录）

![tree](images/object-tree.png)

#### commit (提交) 对象

一个“commit”只指向一个"tree"，它用来标记项目某一个特定时间点的状态。它包括一些关于时间点的元数据，如时间戳、最近一次提交的作者、指向上次提交（commits）的指针等等。

![tree](images/object-commit.png)

#### tag (标签) 对象

![tag](images/object-tag.png)

一个“tag”是来标记某一个提交(commit)的方法。

#### commit -> tree -> blob

![object-c-t-b](images/object-c-t-b.png)

### 与SVN的区别

Git与你熟悉的大部分版本控制系统的差别是很大的。

也许你熟悉Subversion、CVS、Perforce、Mercurial 等等，他们使用 “增量文件系统” （Delta Storage systems）, 就是说它们存储每次提交(commit)之间的差异。

Git正好与之相反，它会把你的每次提交的文件的全部内容（snapshot）都会记录下来。

这会是在使用Git时的一个很重要的理念。


## 一步一步了解Git在做什么

### 初始化仓库

初始化目录并创建一个Git仓库

```sh
➜  ~ mkdir git-obj-model
➜  ~ cd git-obj-model
➜  git-obj-model git init
Initialized empty Git repository in /home/liuyanjie/git-obj-model/.git/
```

看一下初始化的git仓库中到底有些什么内容。

```sh
➜  git-obj-model git:(master) ls .git/*/*
.git/hooks/applypatch-msg.sample  .git/hooks/post-update.sample     .git/hooks/pre-commit.sample          .git/hooks/pre-push.sample    .git/hooks/update.sample
.git/hooks/commit-msg.sample      .git/hooks/pre-applypatch.sample  .git/hooks/prepare-commit-msg.sample  .git/hooks/pre-rebase.sample  .git/info/exclude

.git/objects/info:

.git/objects/pack:

.git/refs/heads:

.git/refs/tags:
```

查看仓库状态

```sh
➜  git-obj-model git:(master) git status
On branch master

Initial commit

nothing to commit (create/copy files and use "git add" to track)
```

后面忽略`.git/hooks/`下的文件。

### 增加一个文件README.md

现在创建一个`README.md`，看下一`.git`目录，发现依然没有什么变化。

```sh
➜  git-obj-model git:(master) echo "# Readme" > README.md
➜  git-obj-model git:(master) ✗ ls .git/*/*
.git/objects/info:

.git/objects/pack:

.git/refs/heads:

.git/refs/tags:
```

查看当前状态

```sh
➜  git-test git:(master) ✗ git status
On branch master

Initial commit

Untracked files:
  (use "git add <file>..." to include in what will be committed)

  README.md

nothing added to commit but untracked files present (use "git add" to track)
```


执行`git add`命令，继续观察，发现增加了`.git/objects/f3/954314c1026028e77ea3a765aadefa67b45195`文件。

通过猜测，应该知道，这应该是一个`blob`类型的文件，里面存储文件内容。

```sh
➜  git-obj-model git:(master) ✗ git add README.md
➜  git-obj-model git:(master) ✗ ls .git/*/*
.git/objects/f3:
954314c1026028e77ea3a765aadefa67b45195

.git/objects/info:

.git/objects/pack:

.git/refs/heads:

.git/refs/tags:
```

查看当前状态

```sh
➜  git-test git:(master) ✗ git status
On branch master

Initial commit

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)

  new file:   README.md
```

查看暂存区

```sh
cat .git/index
# On branch master
#
# Initial commit
#
# Changes to be committed:
#   (use "git rm --cached <file>..." to unstage)
#
#       new file:   README.md
#
```

执行`git commit`命令，发现路径下又增加了两个文件：

* .git/objects/9d/978d59f2f22062c0382c859f4c3ef929026303
* .git/objects/c1/067ba0a7ba51f937518c9bc051ea744ca748fe

从上面的结构图，可以想到：

提交可定会产生一个提交对象，提交对象指向一个树对象，树对象包含上一步添加的`blob`对象。

下面将通过查看文件内容验证这一点。

```sh
➜  git-obj-model git:(master) ✗ git commit -m 'First commit!' README.md
[master (root-commit) 9d978d5] First commit!
 1 file changed, 1 insertion(+)
 create mode 100644 README.md
➜  git-obj-model git:(master) ls .git/*/*
.git/logs/refs:
heads

.git/objects/2f:
99fbf7472b248f4301fbf6383979c92c474245

.git/objects/c1:
067ba0a7ba51f937518c9bc051ea744ca748fe

.git/objects/f3:
954314c1026028e77ea3a765aadefa67b45195

.git/objects/info:

.git/objects/pack:

.git/refs/heads:
master

.git/refs/tags:
```

通过`git cat-file`查看文件内容。

发现`9d978d5`是一个提交对象，里面包含提交相关的信息，并指向一个树对象。

```sh
➜  git-obj-model git:(master) git cat-file commit 9d978d5
tree c1067ba0a7ba51f937518c9bc051ea744ca748fe
author liuyanjie <lyj88888888888@gmail.com> 1476109684 +0800
committer liuyanjie <lyj88888888888@gmail.com> 1476109684 +0800

First commit!
```

再看`.git/refs/heads/master`文件内容，发现只有一行，写着提交对象的文件名。

```sh
➜  git-obj-model git:(master) cat .git/refs/heads/master
2f99fbf7472b248f4301fbf6383979c92c474245
```

再看`c1067b`文件内容，是一个树对象，同样只有一行，记录刚添加的`README.md`的文件信息。

```sh
➜  git-obj-model git:(master) git cat-file -p c1067b
100644 blob f3954314c1026028e77ea3a765aadefa67b45195  README.md
```

再看`f39543`文件内容，发现是`README.md`的文件内容。

```sh
➜  git-obj-model git:(master) git cat-file -p f39543
# Readme
➜  git-obj-model git:(master) ls
README.md
```

再看下一下.git目录中新增加的`.git/logs/refs/heads/master`，发现是刚刚提交的文件记录，包含两个提交对象作者及注释等。

```sh
➜  git-obj-model git:(master) ✗ cat .git/logs/refs/heads/master
0000000000000000000000000000000000000000 2f99fbf7472b248f4301fbf6383979c92c474245 liuyanjie <lyj88888888888@gmail.com> 1476109684 +0800	commit (initial): First commit!
```

通过以上查看`.git`目录的变化过程，可以大致分析出Git是如何存储这些文件内容的。

上面只执行了`git add`和`git commit`两条操作。

### 继续添加文件

```sh
➜  git-obj-model git:(master) echo "# CHANGELOG" > CHANGELOG.md
➜  git-obj-model git:(master) ✗ echo "# CONTRIBUTING" > CONTRIBUTING.md
➜  git-obj-model git:(master) ✗ git status
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)

  CHANGELOG.md
  CONTRIBUTING.md

nothing added to commit but untracked files present (use "git add" to track)
➜  git-obj-model git:(master) ✗ ls
CHANGELOG.md  CONTRIBUTING.md  README.md
➜  git-obj-model git:(master) ✗ git add CHANGELOG.md CONTRIBUTING.md
➜  git-obj-model git:(master) ✗ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

  new file:   CHANGELOG.md
  new file:   CONTRIBUTING.md
```

可以看到又增加了，两个文件。

```sh
➜  git-obj-model git:(master) ✗ ls .git/*/*
.git/logs/refs:
heads

.git/objects/2f:
99fbf7472b248f4301fbf6383979c92c474245

.git/objects/a0:
cf709bc0991b5340080f944d02894dc1596d46

.git/objects/c1:
067ba0a7ba51f937518c9bc051ea744ca748fe

.git/objects/c6:
b9e95b39b8cd8ead8bbf4b118104741017de1b

.git/objects/f3:
954314c1026028e77ea3a765aadefa67b45195

.git/objects/info:

.git/objects/pack:

.git/refs/heads:
master

.git/refs/tags:
```

分别查看一下各个文件的内容

```sh
➜  git-obj-model git:(master) ✗ git cat-file -p a0cf70
# CHANGELOG
➜  git-obj-model git:(master) ✗ git cat-file -p c6b9e9
# CONTRIBUTING
➜  git-obj-model git:(master) ✗ git cat-file -p f39543
# Readme
```

再查看一下树对象的内容，然而并没有任何变化

```sh
➜  git-obj-model git:(master) ✗ git cat-file -p c1067b
100644 blob f3954314c1026028e77ea3a765aadefa67b45195  README.md
```

下面提交这两个文件，可以通过日志方便的查看信息。

```sh
➜  git-obj-model git:(master) ✗ git commit --all -m "add CHANGELOG.md and CONTRIBUTING.md files"
[master 4576ab4] add CHANGELOG.md and CONTRIBUTING.md files
 2 files changed, 2 insertions(+)
 create mode 100644 CHANGELOG.md
 create mode 100644 CONTRIBUTING.md
```

同样再看一下`.git`目录下的内容

```sh
➜  git-obj-model git:(master) ls .git/*/*
.git/logs/refs:
heads

.git/objects/2c:
affd90cd736e58f516e3988e3af84f5fa42b4f

.git/objects/9d:
978d59f2f22062c0382c859f4c3ef929026303

.git/objects/a0:
cf709bc0991b5340080f944d02894dc1596d46

.git/objects/b5:
b1d930975db2ccee60faa0dfe9150edf5cbdde

.git/objects/c1:
067ba0a7ba51f937518c9bc051ea744ca748fe

.git/objects/c6:
b9e95b39b8cd8ead8bbf4b118104741017de1b

.git/objects/f3:
954314c1026028e77ea3a765aadefa67b45195

.git/objects/info:

.git/objects/pack:

.git/refs/heads:
master

.git/refs/tags:
```

查看一下master上的提交日志，刚刚提交内容在新的一行，与首次提交稍微有点差别，首次提交是commit (initial)。

还可以发现第二次提交的第一列和第一次提交的第二列一样，可以猜到，第一列指向上一次的提交对象。

```sh
➜  git-obj-model git:(master) cat .git/logs/refs/heads/master
0000000000000000000000000000000000000000 2f99fbf7472b248f4301fbf6383979c92c474245 liuyanjie <lyj88888888888@gmail.com> 1476109684 +0800	commit (initial): First commit!
2f99fbf7472b248f4301fbf6383979c92c474245 4576ab487b26945323a4db41c601f912d6f50808 liuyanjie <lyj88888888888@gmail.com> 1476110257 +0800	commit: add CHANGELOG.md and CONTRIBUTING.md files
```

查看log

```sh
➜  git-obj-model git:(master) git log
commit 4576ab487b26945323a4db41c601f912d6f50808
Author: liuyanjie <lyj88888888888@gmail.com>
Date:   Mon Oct 10 22:37:37 2016 +0800

    add CHANGELOG.md and CONTRIBUTING.md files

commit 2f99fbf7472b248f4301fbf6383979c92c474245
Author: liuyanjie <lyj88888888888@gmail.com>
Date:   Mon Oct 10 22:28:04 2016 +0800

    First commit!
```

master也指向了新的提交对象，和提交日志一致。

第一次产生的提交对象同样存在于目录当中。

```sh
➜  git-obj-model git:(master) cat .git/refs/heads/master
4576ab487b26945323a4db41c601f912d6f50808
```

看一下提交对象`4576ab`的内容，可以看到指向树对象`2caffd`。

此外，还发现一个parent，显然，这个指向上一次的提交对线，与提交日志保持一致，可以通过parent找到上一次提交。

```sh
➜  git-obj-model git:(master) git cat-file -p 4576ab
tree 2caffd90cd736e58f516e3988e3af84f5fa42b4f
parent 2f99fbf7472b248f4301fbf6383979c92c474245
author liuyanjie <lyj88888888888@gmail.com> 1476003224 -0700
committer liuyanjie <lyj88888888888@gmail.com> 1476003224 -0700

add CHANGELOG.md and CONTRIBUTING.md files
```

在看树对象`2caffd`，发现相比之前，多了两行，分别指向新增加的文件。

但是，这个对象和上一个树对象并不是同一个树对象。

```sh
➜  git-obj-model git:(master) git cat-file -p 2caffd
100644 blob a0cf709bc0991b5340080f944d02894dc1596d46  CHANGELOG.md
100644 blob c6b9e95b39b8cd8ead8bbf4b118104741017de1b  CONTRIBUTING.md
100644 blob f3954314c1026028e77ea3a765aadefa67b45195  README.md
```

到现在为止，整个目录下有3个文件，而.git目录下已经有多个文件，为了跟踪记录版本。

```sh
➜  git-obj-model git:(master) ls
CHANGELOG.md  CONTRIBUTING.md  README.md
```

通过以上.git目录变化，可以发现（猜）：

commit对象指向一个根树，根树下面再指向文件和目录，类似Linux文件系统结构，和上面的图一致。

每次提交都会产出一commmit对象，这些commit通过parent，形成一个由高版本到低版本的链表，追溯这个链表，可以回到任意版本。

每一个commit都指向一个完整的树，由根树开始，可以遍历到某一般版本下的所有文件。

在每一颗树下，因为都是使用类似指针的结构，所以每次修改都是将变化的文件，重新创建一个blob文件，并修改相应指针。与SVN不同的是，SVN将每个文件都复制了一份。

与实际的目录相比，（看起来）不同的是文件名和文件内容是分开的，但是和Linux系统是类型的，inode这种方式。可以看出来作者安装文件系统的思路实现的。

目录中的`.git/refs/heads/master`指向某一次提交，当由另外一个分支的时候，会有`.git/refs/heads/branch-xxx`文件指向另外一次提交，而初始时与父分支指向相同。


### 再添加一个带有目录文件

```sh
➜  git-obj-model git:(master) mkdir lib
➜  git-obj-model git:(master) echo "// Author: liuyanjie" > ./lib/index.js
➜  git-obj-model git:(master) ✗ git add lib/index.js
➜  git-obj-model git:(master) ✗ git commit -m "add lib/index.js" lib/index.js
[master 1ad0e58] add lib/index.js
 1 file changed, 1 insertion(+)
 create mode 100644 lib/index.js
```

```sh
 ➜  git-obj-model git:(master) git cat-file -p 1ad0e58
tree 9609811e44367d44f2915435f4454716e1e535fd
parent 4576ab487b26945323a4db41c601f912d6f50808
author liuyanjie <lyj88888888888@gmail.com> 1476003520 -0700
committer liuyanjie <lyj88888888888@gmail.com> 1476003520 -0700

add lib/index.js
```

```sh
➜  git-obj-model git:(master) git cat-file -p 960981
100644 blob a0cf709bc0991b5340080f944d02894dc1596d46  CHANGELOG.md
100644 blob c6b9e95b39b8cd8ead8bbf4b118104741017de1b  CONTRIBUTING.md
100644 blob f3954314c1026028e77ea3a765aadefa67b45195  README.md
040000 tree 2fb9045bb558889ea2bd8cc5d8fe45e7247706da  lib
```

```sh
➜  git-obj-model git:(master) git cat-file -p 2fb904
100644 blob 39a204af28de9b4f0411735e597e0da7416ca35a  index.js
```

上面连续几步和之前的效果一样，但是可以看到，在树对象`960981`中，包含了另一个树对象`2fb904`，这个对象的内容指向`index.js`文件。

```sh
➜  git-obj-model git:(master) cat .git/logs/refs/heads/master
0000000000000000000000000000000000000000 2f99fbf7472b248f4301fbf6383979c92c474245 liuyanjie <lyj88888888888@gmail.com> 1476109684 +0800	commit (initial): First commit!
2f99fbf7472b248f4301fbf6383979c92c474245 4576ab487b26945323a4db41c601f912d6f50808 liuyanjie <lyj88888888888@gmail.com> 1476110257 +0800	commit: add CHANGELOG.md and CONTRIBUTING.md files
4576ab487b26945323a4db41c601f912d6f50808 1ad0e58722bef17c2fb47f64e37d68e9990dd938 liuyanjie <lyj88888888888@gmail.com> 1476110760 +0800	commit: add lib/index.js
```

log

```sh
➜  git-obj-model git:(master) git log
commit 1ad0e58722bef17c2fb47f64e37d68e9990dd938
Author: liuyanjie <lyj88888888888@gmail.com>
Date:   Mon Oct 10 22:46:00 2016 +0800

    add lib/index.js

commit 4576ab487b26945323a4db41c601f912d6f50808
Author: liuyanjie <lyj88888888888@gmail.com>
Date:   Mon Oct 10 22:37:37 2016 +0800

    add CHANGELOG.md and CONTRIBUTING.md files

commit 2f99fbf7472b248f4301fbf6383979c92c474245
Author: liuyanjie <lyj88888888888@gmail.com>
Date:   Mon Oct 10 22:28:04 2016 +0800

    First commit!
```

### 开始创建分支

创建并切换到分支`feature-a`

```sh
➜  git-obj-model git:(master) git branch
* master
➜  git-obj-model git:(master) git checkout -b feature-a
Switched to a new branch 'feature-a'
➜  git-obj-model git:(feature-a) git branch
* feature-a
  master
➜  git-obj-model git:(feature-a) ls
CHANGELOG.md  CONTRIBUTING.md  lib  README.md
```

看一下`.git`文件内容，可以看到`.git/refs/heads`目录下多了个`feature-a`

```sh
.git/logs/refs:
heads

.git/objects/1a:
d0e58722bef17c2fb47f64e37d68e9990dd938

.git/objects/2c:
affd90cd736e58f516e3988e3af84f5fa42b4f

.git/objects/2f:
99fbf7472b248f4301fbf6383979c92c474245  b9045bb558889ea2bd8cc5d8fe45e7247706da

.git/objects/39:
a204af28de9b4f0411735e597e0da7416ca35a

.git/objects/45:
76ab487b26945323a4db41c601f912d6f50808

.git/objects/96:
09811e44367d44f2915435f4454716e1e535fd

.git/objects/a0:
cf709bc0991b5340080f944d02894dc1596d46

.git/objects/c1:
067ba0a7ba51f937518c9bc051ea744ca748fe

.git/objects/c6:
b9e95b39b8cd8ead8bbf4b118104741017de1b

.git/objects/f3:
954314c1026028e77ea3a765aadefa67b45195

.git/objects/info:

.git/objects/pack:

.git/refs/heads:
feature-a  master

.git/refs/tags:
```

查看一下`feature-a`的相关内容，指向的提交对象和`master`一样，并指明`Created from HEAD`。

从内容中可以看出，两个分支指向同一个提交对象`1ad0e5`，但是两个分支的日志不同。

日志记录了分之的历史，而提交对象记录了分支的数据内容和所有分支的历史。

```sh
➜  git-obj-model git:(feature-a) cat .git/logs/refs/heads/feature-a
0000000000000000000000000000000000000000 1ad0e58722bef17c2fb47f64e37d68e9990dd938 liuyanjie <lyj88888888888@gmail.com> 1476111038 +0800	branch: Created from HEAD
➜  git-obj-model git:(feature-a) cat .git/logs/refs/heads/master
0000000000000000000000000000000000000000 2f99fbf7472b248f4301fbf6383979c92c474245 liuyanjie <lyj88888888888@gmail.com> 1476109684 +0800	commit (initial): First commit!
2f99fbf7472b248f4301fbf6383979c92c474245 4576ab487b26945323a4db41c601f912d6f50808 liuyanjie <lyj88888888888@gmail.com> 1476110257 +0800	commit: add CHANGELOG.md and CONTRIBUTING.md files
4576ab487b26945323a4db41c601f912d6f50808 1ad0e58722bef17c2fb47f64e37d68e9990dd938 liuyanjie <lyj88888888888@gmail.com> 1476110760 +0800	commit: add lib/index.js
➜  git-obj-model git:(feature-a) cat .git/refs/heads/feature-a
1ad0e58722bef17c2fb47f64e37d68e9990dd938
➜  git-obj-model git:(feature-a) cat .git/refs/heads/master
1ad0e58722bef17c2fb47f64e37d68e9990dd938
```

初始化`package.json`

```sh
➜  git-obj-model git:(feature-a) npm init
# This utility will walk you through creating a package.json file.
# It only covers the most common items, and tries to guess sensible defaults.
# See `npm help json` for definitive documentation on these fields
# and exactly what they do.
# Use `npm install <pkg> --save` afterwards to install a package and
# save it as a dependency in the package.json file.
# Press ^C at any time to quit.
# name: (git-obj-model)
# version: (1.0.0) 0.0.1
# description: git-obj-model
# entry point: (index.js)
# test command: test
# git repository:
# keywords: git object-model
# author: liuyanjie
# license: (ISC) MIT
# About to write to /home/liuyanjie/git-obj-model/package.json:
# {
#   "name": "git-obj-model",
#   "version": "0.0.1",
#   "description": "git-obj-model",
#   "main": "index.js",
#   "scripts": {
#     "test": "test"
#   },
#   "keywords": [
#     "git",
#     "object-model"
#   ],
#   "author": "liuyanjie",
#   "license": "MIT"
# }
# Is this ok? (yes) yes
```

安装`bluebird`

```sh
➜  git-obj-model git:(feature-a) ✗ ls
CHANGELOG.md  CONTRIBUTING.md  lib  package.json  README.md
➜  git-obj-model git:(feature-a) ✗ npm install bluebird --save
git-obj-model@0.0.1 /home/liuyanjie/workspace/git-obj-model
└── bluebird@3.4.6
```

添加文件到版本库，并查看变化。

```sh
➜  git-obj-model git:(feature-a) ✗ git add package.json
➜  git-obj-model git:(feature-a) ✗ cat .git/refs/heads/feature-a
1ad0e58722bef17c2fb47f64e37d68e9990dd938
➜  git-obj-model git:(feature-a) ✗ cat .git/refs/heads/master
1ad0e58722bef17c2fb47f64e37d68e9990dd938
```

提交文件到版本库，并查看变化，提交指针已经指向新的提交对象，分支的版本超前于master，因为parent指向`1ad0e5`

```sh
➜  git-obj-model git:(feature-a) ✗ git commit package.json -m 'add package.js'
[feature-a 0cb2147] add package.js
 1 file changed, 18 insertions(+)
 create mode 100644 package.json
➜  git-obj-model git:(feature-a) ✗ cat .git/refs/heads/master
1ad0e58722bef17c2fb47f64e37d68e9990dd938
➜  git-obj-model git:(feature-a) ✗ cat .git/refs/heads/feature-a
0cb214741c044af3fb4677fe72e3ae175f3e0358
➜  git-obj-model git:(feature-a) ✗ git cat-file -p 0cb214
tree f0cc543f39be5f635bea5bf8420d1cf5669999a9
parent 1ad0e58722bef17c2fb47f64e37d68e9990dd938
author liuyanjie <lyj88888888888@gmail.com> 1476111582 +0800
committer liuyanjie <lyj88888888888@gmail.com> 1476111582 +0800

add package.js
```

```sh
➜  git-obj-model git:(feature-a) ✗ git cat-file -p f0cc54
100644 blob a0cf709bc0991b5340080f944d02894dc1596d46  CHANGELOG.md
100644 blob c6b9e95b39b8cd8ead8bbf4b118104741017de1b  CONTRIBUTING.md
100644 blob f3954314c1026028e77ea3a765aadefa67b45195  README.md
040000 tree 2fb9045bb558889ea2bd8cc5d8fe45e7247706da  lib
100644 blob 25ce01b36287fc8a43ac3eac6e526b4c1c6935d6  package.json
```

合并分支`feature-a`到`master`分支，可以看到`master`分支跟上了`feature-a`，只改指针既可，非常快。

```sh
➜  git-obj-model git:(feature-a) git checkout master
➜  git-obj-model git:(master) ✗ git merge feature-a
Updating 1ad0e58..0cb2147
Fast-forward
 package.json | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 package.json
➜  git-obj-model git:(master) ✗ cat .git/refs/heads/master
0cb214741c044af3fb4677fe72e3ae175f3e0358
➜  git-obj-model git:(master) ✗ cat .git/refs/heads/feature-a
0cb214741c044af3fb4677fe72e3ae175f3e0358
```

修改`master`分支

```sh
# 编辑文件并提交
➜  git-obj-model git:(master) ✗ git checkout master
Already on 'master'
➜  git-obj-model git:(feature-a) git checkout master
➜  git-obj-model git:(master) ✗ echo -e "\n\n## About" >> README.md
➜  git-obj-model git:(master) ✗ cat README.md
# Readme


## About
➜  git-obj-model git:(master) ✗ git commit README.md -m "add About"
[master ef6834c] add About
 1 file changed, 3 insertions(+)
```

修改`feature-a`分支

```sh
➜  git-obj-model git:(master) ✗ git checkout feature-a
Switched to branch 'feature-a'
➜  git-obj-model git:(feature-a) ✗ git commit README.md -m "add About Me"
[feature-a da24911] add About Me
 1 file changed, 3 insertions(+)
➜  git-obj-model git:(feature-a) ✗ cat README.md
# Readme


## About Me
# 编辑文件，使之产生冲突，然后提交
➜  git-obj-model git:(feature-a) git commit package.json -m 'add keyword'
```

查看分支头和历史记录，可以看到分支头指向不同的提交对象，而提交对象，又来源于同一个提交对象`0cb214741c044af3fb4677fe72e3ae175f3e0358`，两个分支之间存在交叉。

```sh
➜  git-obj-model git:(feature-a) ✗ cat .git/refs/heads/feature-a
da2491150e0d66928e485ff1289abf6055069f54
➜  git-obj-model git:(feature-a) ✗ cat .git/refs/heads/master
ef6834c89de31b3d553082392853da00f3d6b452
➜  git-obj-model git:(feature-a) ✗ cat .git/logs/refs/heads/master
0000000000000000000000000000000000000000 2f99fbf7472b248f4301fbf6383979c92c474245 liuyanjie <lyj88888888888@gmail.com> 1476109684 +0800	commit (initial): First commit!
2f99fbf7472b248f4301fbf6383979c92c474245 4576ab487b26945323a4db41c601f912d6f50808 liuyanjie <lyj88888888888@gmail.com> 1476110257 +0800	commit: add CHANGELOG.md and CONTRIBUTING.md files
4576ab487b26945323a4db41c601f912d6f50808 1ad0e58722bef17c2fb47f64e37d68e9990dd938 liuyanjie <lyj88888888888@gmail.com> 1476110760 +0800	commit: add lib/index.js
1ad0e58722bef17c2fb47f64e37d68e9990dd938 0cb214741c044af3fb4677fe72e3ae175f3e0358 liuyanjie <lyj88888888888@gmail.com> 1476111812 +0800	merge feature-a: Fast-forward
0cb214741c044af3fb4677fe72e3ae175f3e0358 ef6834c89de31b3d553082392853da00f3d6b452 liuyanjie <lyj88888888888@gmail.com> 1476112210 +0800	commit: add About
➜  git-obj-model git:(feature-a) ✗ cat .git/logs/refs/heads/feature-a
0000000000000000000000000000000000000000 1ad0e58722bef17c2fb47f64e37d68e9990dd938 liuyanjie <lyj88888888888@gmail.com> 1476111038 +0800	branch: Created from HEAD
1ad0e58722bef17c2fb47f64e37d68e9990dd938 0cb214741c044af3fb4677fe72e3ae175f3e0358 liuyanjie <lyj88888888888@gmail.com> 1476111582 +0800	commit: add package.js
0cb214741c044af3fb4677fe72e3ae175f3e0358 da2491150e0d66928e485ff1289abf6055069f54 liuyanjie <lyj88888888888@gmail.com> 1476112277 +0800	commit: add About Me
```

切换到`master`分支，再次合并`feature-a`到`master`

```sh
➜  git-obj-model git:(feature-a) ✗ git checkout master
Switched to branch 'master'
➜  git-obj-model git:(master) ✗ git merge feature-a
Auto-merging README.md
CONFLICT (content): Merge conflict in README.md
Automatic merge failed; fix conflicts and then commit the result.
➜  git-obj-model git:(master) ✗ cat README.md
# Readme


<<<<<<< HEAD
## About
=======
## About Me
>>>>>>> feature-a
```

解决冲突之后的文件

```sh
➜  git-obj-model git:(master) ✗ cat README.md
# Readme


## About

➜  git-obj-model git:(master) ✗
```

```sh
➜  git-obj-model git:(master) ✗ git commit README.md -m 'fix conflict'
fatal: cannot do a partial commit during a merge.
➜  git-obj-model git:(master) ✗ git commit -a
[master 69d1d1d] Merge branch 'feature-a'
```

```sh
➜  git-obj-model git:(master) ✗ git status
On branch master
Untracked files:
  (use "git add <file>..." to include in what will be committed)

  node_modules/

nothing added to commit but untracked files present (use "git add" to track)
```

```sh
➜  git-obj-model git:(master) ✗ cat .git/refs/heads/feature-a
fa521b1842700be40c3d7f4aef388435b86cdcb6
➜  git-obj-model git:(master) ✗ cat .git/refs/heads/master
34d8c2fc6b06a8aae7967a8f25f0a4cdd84876a8
```

```sh
➜  git-obj-model git:(master) ✗ cat .git/logs/refs/heads/master
0000000000000000000000000000000000000000 2f99fbf7472b248f4301fbf6383979c92c474245 liuyanjie <lyj88888888888@gmail.com> 1476109684 +0800	commit (initial): First commit!
2f99fbf7472b248f4301fbf6383979c92c474245 4576ab487b26945323a4db41c601f912d6f50808 liuyanjie <lyj88888888888@gmail.com> 1476110257 +0800	commit: add CHANGELOG.md and CONTRIBUTING.md files
4576ab487b26945323a4db41c601f912d6f50808 1ad0e58722bef17c2fb47f64e37d68e9990dd938 liuyanjie <lyj88888888888@gmail.com> 1476110760 +0800	commit: add lib/index.js
1ad0e58722bef17c2fb47f64e37d68e9990dd938 0cb214741c044af3fb4677fe72e3ae175f3e0358 liuyanjie <lyj88888888888@gmail.com> 1476111812 +0800	merge feature-a: Fast-forward
0cb214741c044af3fb4677fe72e3ae175f3e0358 ef6834c89de31b3d553082392853da00f3d6b452 liuyanjie <lyj88888888888@gmail.com> 1476112210 +0800	commit: add About
ef6834c89de31b3d553082392853da00f3d6b452 69d1d1d381ebbe27585079bf3deaf4ca13ba2fde liuyanjie <lyj88888888888@gmail.com> 1476112974 +0800	commit (merge): Merge branch 'feature-a'
```

```sh
➜  git-obj-model git:(master) ✗ git merge --stat feature-a
Already up-to-date.
➜  git-obj-model git:(master) ✗ git branch -d feature-a
Deleted branch feature-a (was da24911).
➜  git-obj-model git:(master) ✗ git cat-file -p da24911
tree 33ab49e5d62dac2e273f2dc25a8d3d1c08164fd8
parent 0cb214741c044af3fb4677fe72e3ae175f3e0358
author liuyanjie <lyj88888888888@gmail.com> 1476112277 +0800
committer liuyanjie <lyj88888888888@gmail.com> 1476112277 +0800

add About Me
➜  git-obj-model git:(master) ✗ git cat-file -p 69d1d1
tree 75779b8d5612e7e92d21e24eb93c98a78bef9880
parent ef6834c89de31b3d553082392853da00f3d6b452
parent da2491150e0d66928e485ff1289abf6055069f54
author liuyanjie <lyj88888888888@gmail.com> 1476112974 +0800
committer liuyanjie <lyj88888888888@gmail.com> 1476112974 +0800

Merge branch 'feature-a'
➜  git-obj-model git:(master) ✗ git branch
* master
```

```sh
git log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
*   69d1d1d - (HEAD -> master) Merge branch 'feature-a' (13 minutes ago) <liuyanjie>
|\
| * da24911 - add About Me (25 minutes ago) <liuyanjie>
* | ef6834c - add About (26 minutes ago) <liuyanjie>
|/
* 0cb2147 - add package.js (36 minutes ago) <liuyanjie>
* 1ad0e58 - add lib/index.js (50 minutes ago) <liuyanjie>
* 4576ab4 - add CHANGELOG.md and CONTRIBUTING.md files (58 minutes ago) <liuyanjie>
* 2f99fbf - First commit! (68 minutes ago) <liuyanjie>
```

配置命令别名

```sh
git config --global alias.lg "log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
git lg
```

### 打标签

```sh
➜  git-obj-model git:(master) ✗ git tag
➜  git-obj-model git:(master) ✗ git tag -a v0.0.1 -m "version 0.0.1"
➜  git-obj-model git:(master) ✗ git tag
v0.0.1
➜  git-obj-model git:(master) ✗ cat .git/refs/tags/v0.0.1
3cb5a0d0b86e5d80005d7df9acdfbd0e81e73680
➜  git-obj-model git:(master) ✗ git cat-file -p 3cb5a0
object 34d8c2fc6b06a8aae7967a8f25f0a4cdd84876a8
type commit
tag v0.0.1
tagger ubuntu-16.04-64 <liuyanjie> 1476157130 -0700

version 0.0.1
➜  git-obj-model git:(master) ✗ cat .git/logs/refs/heads/master
0000000000000000000000000000000000000000 9d978d59f2f22062c0382c859f4c3ef929026303 ubuntu-16.04-64 <liuyanjie> 1476002050 -0700  commit (initial): First commit!
9d978d59f2f22062c0382c859f4c3ef929026303 b5b1d930975db2ccee60faa0dfe9150edf5cbdde ubuntu-16.04-64 <liuyanjie> 1476003224 -0700  commit: add CHANGELOG.md and CONTRIBUTING.md files
b5b1d930975db2ccee60faa0dfe9150edf5cbdde 3bf6d4e4f4f8d7f8892b2a33623a65511f34d35a ubuntu-16.04-64 <liuyanjie> 1476003520 -0700  commit: add lib/index.js
3bf6d4e4f4f8d7f8892b2a33623a65511f34d35a 67e9ab4ffbdde212fdf3f640674c742028585c10 ubuntu-16.04-64 <liuyanjie> 1476006305 -0700  merge feature-a: Fast-forward
67e9ab4ffbdde212fdf3f640674c742028585c10 496e60e1943637c66adf87b13e09b04920d97b98 ubuntu-16.04-64 <liuyanjie> 1476006843 -0700  commit: add keyword
496e60e1943637c66adf87b13e09b04920d97b98 34d8c2fc6b06a8aae7967a8f25f0a4cdd84876a8 ubuntu-16.04-64 <liuyanjie> 1476009515 -0700  commit (merge): Merge branch 'feature-a'
➜  git-obj-model git:(master) ✗ git cat-file -p 34d8c2
tree 950ba459cbd53d9741165b849f6dcb2d799c8841
parent 496e60e1943637c66adf87b13e09b04920d97b98
parent fa521b1842700be40c3d7f4aef388435b86cdcb6
author ubuntu-16.04-64 <liuyanjie> 1476009515 -0700
committer ubuntu-16.04-64 <liuyanjie> 1476009515 -0700

Merge branch 'feature-a'
```

[svg版](images/git-obj-model.svg)

![git-obj-model](images/git-obj-model.png)
