# Git Working Mechanism

## 仓库管理

Git是一个分布式的版本控制系统，这意味着在Git中版本库有 `本地版本库` 和 `远程版本库` 之分。
每个远程仓库可以有多个本地仓库，同时一个本地版本库可以同时对应多个远程版本库，多个远程版本库是从一个最原始的版本库 `Fork`（实际上也是`clone`）产生的，`Fork` 出来的版本库和本地 `Clone` 的仓库是类似的，他们有一个相同的 `上游仓库`（即原始仓库），这些版本库直接可以通过 `PullRequest` 或 `MergeRequest` 操作进行仓库的交互。
本地仓库对应的远程仓库记录在 `.git/config` 文件中。本地仓库可以于多个的远程仓库 `pull/push` 代码。

### [Init](https://git-scm.com/docs/git-init)

> 创建一个空的 Git 仓库，或者重新初始化一个已经存在的 Git 仓库。

```sh
git init
  [-q | --quiet]
  [--bare]
  [--template=<template_directory>]
  [--separate-git-dir <git dir>]
  [--shared[=<permissions>]]
  [directory]
```

常规方式创建一个仓库：

```sh
$ git init workspace
Initialized empty Git repository in /Users/liuyanjie/git-learn/workspace/.git/

$ tree -ar
.
└── workspace
    └── .git
        ├── refs
        │   ├── tags
        │   └── heads
        ├── objects
        │   ├── pack
        │   └── info
        ├── info
        │   └── exclude
        ├── hooks
        │   ├── update.sample
        │   ├── prepare-commit-msg.sample
        │   ├── pre-receive.sample
        │   ├── pre-rebase.sample
        │   ├── pre-push.sample
        │   ├── pre-commit.sample
        │   ├── pre-applypatch.sample
        │   ├── post-update.sample
        │   ├── fsmonitor-watchman.sample
        │   ├── commit-msg.sample
        │   └── applypatch-msg.sample
        ├── description
        ├── config
        └── HEAD

10 directories, 15 files
```

以上创建的仓库，仓库文件 存放在 工作区目录 `workspace` 的子目录 `.git` 下。

分离的方式创建一个仓库：

```sh
$ git init --separate-git-dir=.tig workspace
Initialized empty Git repository in /Users/liuyanjie/git-learn/.tig/

$ tree -ar
.
├── workspace
│   └── .git
└── .tig
    ├── refs
    │   ├── tags
    │   └── heads
    ├── objects
    │   ├── pack
    │   └── info
    ├── info
    │   └── exclude
    ├── hooks
    │   ├── update.sample
    │   ├── prepare-commit-msg.sample
    │   ├── pre-receive.sample
    │   ├── pre-rebase.sample
    │   ├── pre-push.sample
    │   ├── pre-commit.sample
    │   ├── pre-applypatch.sample
    │   ├── post-update.sample
    │   ├── fsmonitor-watchman.sample
    │   ├── commit-msg.sample
    │   └── applypatch-msg.sample
    ├── description
    ├── config
    └── HEAD

10 directories, 16 files

$ cat workspace/.git
gitdir: /Users/liuyanjie/git-learn/.tig
```

相比常规方式创建仓库，可以看到

1. 分离方式创建仓库 可以将 `仓库(.git)` 和 `工作区目录(workspace)` 分离，常规方式创建的仓库，`仓库(.git)` 就在 `工作区目录(workspace)` 下。
2. 分离方式创建的仓库，在 `工作区目录(workspace)` 下 `.git` 文件不再是仓库目录，而是包含指向仓库路径的一个文件。利用这一特性，可以创建多个工作区共享同一仓库。
3. 仓库文件的目录可以是除了 `.git` 之外的其他的合法的目录名称。

参考在创建的过程中，拷贝了一些的模版文件到 `仓库(.git)` 下，可以在运行的时候通过 `--template=` 或 `GIT_TEMPLATE_DIR` 环境变量 指定模版路径位置，模版示例如下：

```sh
$ tree /usr/local/Cellar/git/2.18.0/share/git-core/templates
/usr/local/Cellar/git/2.18.0/share/git-core/templates
├── description
├── hooks
│   ├── applypatch-msg.sample
│   ├── commit-msg.sample
│   ├── fsmonitor-watchman.sample
│   ├── post-update.sample
│   ├── pre-applypatch.sample
│   ├── pre-commit.sample
│   ├── pre-push.sample
│   ├── pre-rebase.sample
│   ├── pre-receive.sample
│   ├── prepare-commit-msg.sample
│   └── update.sample
└── info
    └── exclude

2 directories, 13 files
```

基于这一点，我们可以已一个参考作为模版，创建另一个仓库，Git 会把模板路径下的文件的复制到新的仓库下。

运行命令时，也可通过以下设置以下环境变量：

* `GIT_DIR=.git` GIT仓库路径
* `GIT_OBJECT_DIRECTORY=$GIT_DIR/objects` GIT对象存储路径
* `GIT_TEMPLATE_DIR=path/to/git-core/templates` 模版路径，命令行参数：`--template`，配置：`init.templateDir`

在一个已经存在的仓库目录中运行 `init` 命令是安全的，它不会覆盖原来已经存在的东西。重新运行 `init` 的主要原因是挑选新添加的模版，或者移动仓库到其他的地方，如果 `--separate-git-dir` 指定的话。

初始化仓库是Git工作流中的第一步，一般情况下，需要两个仓库，一个本地仓库，一个远程仓库。

Init后的 Git 配置：

```ini
[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
	ignorecase = true
	precomposeunicode = true
```

只有 `core` 相关的几个配置项

### [Clone](https://git-scm.com/docs/git-clone)

> 克隆仓库到一个新的目录，为每一个被克隆仓库中的分支创建对应的远程追踪分支。然后从克隆仓库的当前活动分支创建并检出初始分支到工作区目录。

```sh
git clone
  [-q] [--quiet]
  [-v] [--verbose]
  [--progress]
  
  [-l] [-s] [--no-hardlinks]
  [-n] [--no-checkout]
  
  [--template=<template_directory>]
  [--separate-git-dir <git-dir>]
  [--bare]
  [--mirror]

  [-c <key>=<value>] [--config <key>=<value>]

  [-o <origin-name>] [--origin <origin-name>]
  [-b <branch-name>] [--branch <branch-name>]
  [--no-tags]
  [-u <upload-pack>]

  [--depth <depth>]
  [--shallow-since=<date>]
  [--shallow-exclude=<revision>]

  [--[no-]single-branch]

  [--reference <repository>]
  [--dissociate]
  
  [--recurse-submodules[=<pathspec>]]
  [--[no-]shallow-submodules]
  [-j <n>] [--jobs <n>]
  [--] <repository> [<directory>]
```

克隆一个远程仓库需要存在一个远程仓库，并且有一个可以访问的远程仓库的地址，对应 `<repository>` 参数，Git支持多种访问协议，最常见的如 `git://`。详见：[GIT-URLS](https://git-scm.com/docs/git-clone#_git_urls_a_id_urls_a)

```sh
$ git clone git@github.com:liuyanjie/spec.git
Cloning into 'spec'...
remote: Counting objects: 49, done.
remote: Total 49 (delta 0), reused 0 (delta 0), pack-reused 49
Receiving objects: 100% (49/49), 49.83 KiB | 25.00 KiB/s, done.
Resolving deltas: 100% (15/15), done.

$ cat spec/.git/config
[remote "origin"]
	url = git@github.com:liuyanjie/spec.git
	fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
	remote = origin
	merge = refs/heads/master
```

相比 `git init`，`git clone` 之后的仓库配置文件中，增加了以上内容，配置 `本地分支` 和 `远程分支` 间的追踪关系，该配置为 Git 默认配置，一般不需要修改。

`git clone` 工作流程（猜测）：

`INIT` -> `REMOTE-TRACKING` -> `FETCH` -> `CHECKOUT HEAD`

`git init` -> `git remote set-url origin git://...` -> `git fetch` -> [`git merge`] -> `git checkout HEAD`

Clone过程可以进行哪些控制：

1. `--bare`：同 `Init` 相同，可以 `Clone` 一个 `Bare` 仓库到本地。
2. `--mirror`：可以进行镜像 `Clone`，制作镜像仓库。
3. `--template=`：同 `Init` 相同，可以指定模版。
4. `--separate-git-dir=<git dir>`：分离仓库和工作区目录。
5. `--reference[-if-able] <repository>`：可以通过该参数指定一个已存在的仓库进行加速，通常用在频繁的完整的 `Clone` 上。
6. `--depth`：可以指定克隆的 Commit 数量。

克隆本地仓库

```sh
git clone path/to/local/git/repository
```

克隆远程仓库

```sh
$ git clone git@github.com:liuyanjie/knowledge.git --depth=1
Cloning into 'knowledge'...
remote: Counting objects: 300, done.
remote: Compressing objects: 100% (247/247), done.

$ git clone git@github.com:liuyanjie/knowledge.git
Cloning into 'knowledge'...
remote: Counting objects: 495, done.
remote: Compressing objects: 100% (141/141), done.

$ git clone \
  --depth=1 \
  --reference-if-able=/Volumes/Data/Data/ws/knowledge \
  git@github.com:liuyanjie/knowledge.git
Cloning into 'knowledge'...
remote: Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
```

在 `Clone` 的过程中，通过一些参数可以有效的减少 `Clone` 的等待时间，如在 CI 的构建流程中，可以提高构建时间。

## 仓库维护

仓库维护包括维护 `本地仓库` 和 `远程仓库`，在 Git 中，很多时候，同一个 `远程仓库` 可以同时存在多个 `本地仓库`，偶尔，同一个 `本地仓库` 可以同时对应多个 `远程仓库`。

一旦 建立了 `本地仓库` 和 `远程仓库` 的对应关系，就需要频繁进行 `远程仓库` 和 `本地仓库` 之间的分支、标签等数据同步，对应操作有 `push、fetch、pull` 等。

同步的内容主要有：

* 分支同步：分支的 `创建、修改、删除`，本地向远程同步，远程向本地同步
* 标签同步：标签的 `创建、修改、删除`，本地向远程同步，远程向本地同步
* 数据同步

同步数据的基础在于 `本地仓库` 和 `远程仓库` 间存在的对应关系，这一关系 使用 `RefSpec` 进行描述。

### [RefSpec](https://git-scm.com/book/zh/v1/Git-内部原理-The-Refspec)

[Git 内部原理 - The Refspec](https://git-scm.com/book/zh/v1/Git-内部原理-The-Refspec)

下面示例中 `+refs/heads/*:refs/remotes/origin/*` 即为 `RefSpec`。

```sh
$ cat .git/config
[core]
        ...
[remote "origin"]
        url = git@github.com:liuyanjie/knowledge.git
        fetch = +refs/heads/*:refs/remotes/origin/*
```

RefSpec 示例：

```txt
+refs/heads/*:refs/remotes/origin/*
+refs/heads/master:master
+master:refs/remotes/origin/master
master:master
:master
master:
```

`RefSpec` 主要用来表示 `本地版本库` 和 `远程版本库` 之间的 `分支`、`标签` 等数据的对应关系。

指定获取哪些 `remote-refs` 更新 `local-refs`，当没有在命令行显示指明 `RefSpec`，会按照下面的默认策略执行。

`RefSpec` 的格式是一个可选的 `+` 号，接着是 `<src>:<dst>` 的格式，这里 `<src>` 是远端上的引用格式，`<dst>` 是将要记录在本地的引用格式。可选的 `+` 号告诉 Git 在即使不能快速演进的情况下，也去强制更新它。

所以上面示例中的 `RefSpec`，远程仓库中所有分支 `refs/heads/*`，对应到本地仓库下所有分支 `refs/remotes/origin/*`，分支名称不变。如果需要改变分支名称，则需要配置特定的 `RefSpec`。

从远程获取指定数据到本地，如：

```txt
branch master <==> +refs/heads/master:+refs/remotes/origin/master
branch    A:a <==> +refs/heads/A:+refs/remotes/origin/a
tag     <tag> <==> +refs/tags/<tag>:refs/tags/<tag>
```

示例：

```sh
$ cat .git/config
[core]
        ...
[remote "origin"]
        url = git@github.com:liuyanjie/knowledge.git
        fetch = +refs/heads/*:refs/remotes/origin/*

$ tree .git/refs
.git/refs
├── heads
│   ├── feature
│   │   └── travis-ci
│   └── master
├── remotes
│   └── origin
│       ├── feature
│       │   └── travis-ci
│       └── master
└── tags
    └── v0.0.0
```

以上对应关系很明显：

  head@local                     |  remote@local                             | remote@remote
---------------------------------|-------------------------------------------|---------------------------------
`master`                         | `origin/master`                           | `master`
`feature/travis-ci`              | `origin/feature/travis-ci`                | `feature/travis-ci`
`refs/heads/feature/travis-ci`   | `refs/remotes/origin/feature/travis-ci`   | `refs/heads/feature/travis-ci`

注意：`RefSpec` 描述了 `remote@local` 和 `remote@remote` 之间的对应关系，但是不包含 `head@local` 和 `remote@local` 之间的关系，它们之间的存在的追踪关系在其他配置项中描述。

`head@local` 下的 分支，是在本地存在的分支，可能从远程某个分支 `checkout`，也可能是本地新建的。

`RefSpec` 一般不会出现在命令行中，而是由命令自动写在配置文件中，但是可以在命令行中直接使用。

例如：`git remote add remote-name`，Git 会获取远端上 `refs/heads/` 下面的所有引用，并将它写入到本地的 `refs/remotes/remote-name`。

```sh
git remote add liuyanjie git@github.com:liuyanjie/knowledge.git

$ cat .git/config
[remote "origin"]
        url = git@github.com:liuyanjie/knowledge.git
        fetch = +refs/heads/*:refs/remotes/origin/*

[remote "liuyanjie"]
        url = git@github.com:liuyanjie/knowledge.git
        fetch = +refs/heads/*:refs/remotes/liuyanjie/*
```

以下几种方式是等价的：

```sh
git log master
git log heads/master
git log refs/heads/master

git log origin/master
git log remotes/origin/master
git log refs/remotes/origin/master
```

通常都是使用省略 `refs/heads/` 和 `refs/remotes/` 的形式。

以上示例中 `RefSpec` 中包含 `*` 会使 Git 拉取所有远程分支到本地，如果想让Git只拉取固定的分支，可以将 `*` 修改为指定的分支名。

也可以在命令行上指定多个 `RefSpec`，如：

```sh
git fetch origin master:refs/remotes/origin/master topic:refs/remotes/origin/topic
```

同样，也可以将以上命令行中的 `RefSpec` 写入配置中：

```ini
[remote "origin"]
       url = git@github.com:liuyanjie/knowledge.git
       fetch = +refs/heads/master:refs/remotes/origin/master
       fetch = +refs/heads/develop:refs/remotes/origin/develop
       fetch = +refs/heads/feature/*:refs/remotes/origin/feature/*
```

以上，`feature` 可以看做是命名空间，划分不同的分支类型。

上面描述都是拉取时 `RefSpec` 的作用，同样推送是也需要 `RefSpec`

```sh
git push origin master:refs/heads/qa/master
```

推送一个空分支可以删除远程分支

```sh
git push origin :refs/heads/qa/master
```

`RefSpec` 描述了本地仓库分支和远程仓库分支的对应关系。很多时候可以省略，因为 Git 包含了很多默认行为。

远程仓库 `refs/heads/*` 中 的分支大都是 其他 `本地仓库` 同步到远程的。

远程仓库 `refs/heads/*` 中 `创建` 的新分支，在同步数据的时候默认会被拉到本地，`删除` 的分支默认不会在本地进行同步删除，`修改` 的分支会被更新，并与本地追踪的开发分支进行合并。


以上，通过 `RefSpec` 描述的 本地仓库 和 远程仓库 中 分支 是如何对应的，了解了 本地仓库 和 远程仓库 之间的对应关系。


### [git remote](https://git-scm.com/docs/git-remote)

> 管理本地仓库对应的一组远程仓库，包括 查看、更新、添加、删除、重命名、设置 等一系列操作

```sh
git remote [-v | --verbose]
git remote [-v | --verbose] show [-n] <name>…​
git remote [-v | --verbose] update [-p | --prune] [(<group> | <remote>)…​]

git remote add [-t <branch>] [-m <master>] [-f] [--[no-]tags] [--mirror=<fetch|push>] <name> <url>
git remote remove   <name>
git remote rename <old> <new>

git remote set-head <name> (-a | --auto | -d | --delete | <branch>)
git remote set-branches  [--add] <name> <branch>…​

git remote get-url       [--push] [--all] <name>
git remote set-url       [--push] <name> <new-url> [<old-url>]
git remote set-url --add [--push] <name> <new-url>
git remote set-url --delete [--push] <name> <url>

git remote [-v | --verbose] show [-n] <name>…​

git remote prune [-n | --dry-run] <name>…​

git remote [-v | --verbose] update [-p | --prune] [(<group> | <remote>)…​]
```

```sh
git remote                                                  # 列出已经存在的远程分支
git remote -v                                               # 查看远程主机的地址
git remote show   remote_name                               # 查看该远程主机的详细信息
git remote add    remote_name remote_url                    # 添加远程主机
git remote remove remote_name                               # 删除远程主机
git remote rename remote_name new_remote_name               # 重命名远程主机

git remote set-head remote_name branch_name --auto          # 查询远程获得默认分支
git remote set-head remote_name branch_name --delete        # 删除默认分支

git remote set-branches [--add] remote_name branch_name     # 设置 RefSpec， [remote "remote_name"].fetch

git remote get-url remote_name                              # 查看远程主机地址 [remote "remote_name"].url
git remote set-url remote_name git://new.url.here           # 设置远程主机地址
git remote set-url remote_name --push   git://new.url.here  # 修改远程主机地址
git remote set-url remote_name --add    git://new.url.here  # 修改远程主机地址
git remote set-url remote_name --delete git://new.url.here  # 删除远程主机地址

git remote prune [-n | --dry-run] <remote_name>…​            # 删除某个远程名下过期（即不存在）的分支

# see http://stackoverflow.com/questions/1856499/differences-between-git-remote-update-and-fetch
git remote [-v | --verbose] update [-p | --prune] [(<group> | <remote>)…​]
```

```sh
$ git remote show origin
* remote origin
  Fetch URL: git@github.com:liuyanjie/knowledge.git
  Push  URL: git@github.com:liuyanjie/knowledge.git
  HEAD branch: master
  Remote branches:
    feature/travis-ci tracked
    master            tracked
  Local branches configured for 'git pull':
    feature/travis-ci merges with remote feature/travis-ci
    master            merges with remote master
  Local refs configured for 'git push':
    feature/travis-ci pushes to feature/travis-ci (up to date)
    master            pushes to master            (up to date)
```

### [git fetch](https://git-scm.com/docs/git-fetch)

> 下载 Refs 从另外一个仓库，以及完成他们的变更历史所需要的 Objects。追踪的远程分支将会被更新。

`git fetch` 的主要工作就是和远程同步 `Refs`，而 `Refs` 可以 被 `创建、修改、删除`，所以 `fetch` 操作必然应该能够同步这些变化。

* [REMOTES](https://git-scm.com/docs/git-fetch#_remotes_a_id_remotes_a)
* [CONFIGURED REMOTE-TRACKING BRANCHES](https://git-scm.com/docs/git-fetch#_configured_remote_tracking_branches_a_id_crtb_a)

```sh
git fetch [<options>] [<repository> [<refspec>…​]]
git fetch [<options>] <group>
git fetch --multiple [<options>] [(<repository> | <group>)…​]
git fetch --all [<options>]
```

`.git/FETCH_HEAD`：是一个版本链接，记录在本地的一个文件中，指向着目前已经从远程仓库取下来的分支的末端版本。

执行过 `fetch` 操作的项目都会存在一个 `FETCH_HEAD` 列表，其中每一行对应于远程服务器的一个分支。

当前分支指向的 `FETCH_HEAD`，就是这个文件第一行对应的那个分支。

从本质上来说，唯一能从服务器下拉取数据的只有 `fetch`，其他命令的下拉数据的操作都是基于 `fetch` 的，所以 `fetch` 必然需要能够尽可能处理所有下拉数据时可能出现的情况。

Options:

* [shallow] 限制下拉指定的提交数：

  * `--depth=<depth>`
  * `--deepen=<depth>`

* [shallow]限制下拉指定的提交时间：

  * `--shallow-since=<date>`
  * `--shallow-exclude=<revision>`

* [deep]

  * `--unshallow`，`deep clone`
  * `--update-shallow`

* [prune] 剪枝操作

  远程仓库可能对已有的分支标签进行删除，而本地仓库并未删除，需要同步删除操作

  * `-p` `--prune`
  * `-p` `--prune-tags`

* [tags] 默认情况下，`git fetch` 会下拉 `tag`

  * `-t` `--tags` 【默认】下拉标签
  * `-n` `--no-tags` 不下拉标签

* 子模块

  * `--recurse-submodules-default=[yes|on-demand]`
  * `--recurse-submodules[=yes|on-demand|no]`
  * `--no-recurse-submodules`
  * `--submodule-prefix=<path>`

```sh
git fetch                                         # 获取 所有远程仓库 上的所有分支，将其记录到 .git/FETCH_HEAD 文件中
git fetch -all                                    # 获取 所有远程仓库 上的所有分支
git fetch remote                                  # 获取 remote 上的所有分支
git fetch remote branch-name                      # 获取 remote 上的分支：branch-name
git fetch remote branch-name:local-branch-name    # 获取 remote 上的分支：branch-name，并在本地创建对应分支
git fetch remote branch-name:local-branch-name -f # 获取 remote 上的分支：branch-name，并在本地创建对应分支，[强制]
git fetch -f | --force                            # 当使用 refspec(<branch>:<branch>) 时，跳过亲子关系检查，强制更新本地分支
git fetch -p | --prune                            # 获取所有远程分支并清除服务器上已删掉的分支
git fetch -t | --tags                             # 从远程获取数据时获取tags
git fetch -n | --no-tags                          # 从远程获取数据时去除tags
git fetch --progress --verbose                    # 显示进度及冗长日志
git fetch --dry-run                               # 显示做了什么，但是并不实际修改
```

```sh
git fetch --depth=3 --no-tags --progress origin +refs/heads/master:refs/remotes/origin/master  +refs/heads/release/*:refs/remotes/origin/release/*
git fetch --depth=3 --no-tags --progress git@github.com:liuyanjie/knowledge.git +refs/heads/master:refs/remotes/origin/master  +refs/heads/release/*:refs/remotes/origin/release/*
```

示例：

```sh
$ git fetch --prune --progress --verbose --dry-run
From github.com:remote-name/branch-name
 - [deleted]             (none)     -> origin/feature/abcd
 - [deleted]             (none)     -> origin/feature/efg
remote: Counting objects: 34, done.
remote: Compressing objects: 100% (18/18), done.
remote: Total 34 (delta 18), reused 24 (delta 16), pack-reused 0
Unpacking objects: 100% (34/34), done.
   f4e75b13a..6a338066c  master              -> origin/master
 + c29324269...641076244 develop             -> origin/develop  (forced update)
 = [up to date]          release/1.0.0       -> origin/release/1.0.0
 * [new branch]          release/1.1.0       -> origin/release/1.1.0
 * [new tag]             v1.1.0              -> v1.1.0
```

`--prune` 只能清理 `.git/refs/remotes/remote-name` 目录下的远程追踪分支，而不会删除 `.git/refs/heads` 下的本地分支，即使这些分支已经合并，这些分支的清理需要特定的命令：

```sh
git branch --merged | egrep -v "(^\*|master|develop|release)" # 查看确认
git branch --merged | egrep -v "(^\*|master|develop|release)" | xargs git branch -d
```

```sh
$ git branch --merged | egrep -v "(^\*|master|develop|release)" | xargs git branch -d
Deleted branch feature/auto-tag-ci (was 98147f0e3).
Deleted branch feature/build-optimize (was d359f4179).
Deleted branch feature/contract (was c0c4bdaa8).
Deleted branch feature/cross-domain (was 2e9b25c82).
Deleted branch feature/deploy (was 3650db271).
Deleted branch feature/nvmrc (was 1d174fcd8).
Deleted branch feature/winston-logstash (was f13700c66).
```

同样远程仓库也有一些已经合并了，但是未删除的分支需要删除：

```sh
git branch -r --merged | egrep -v "(^\*|master|develop|release)" | sed 's/origin\//:/' # 查看确认
git branch -r --merged | egrep -v "(^\*|master|develop|release)" | sed 's/origin\//:/' | xargs -n 1 git push origin
```

```sh
$ git branch -r --merged | egrep -v "(^\*|master|develop|release)" | sed 's/origin\//:/' | xargs -n 1 git push origin
To github.com:liuyanjie/knowledge.git
 - [deleted]             feature/xxxx
```


```sh
$ git fetch origin master:refs/remotes/origin/master topic:refs/remotes/origin/topic
From git@github.com:schacon/simple
 ! [rejected]        master     -> origin/master  (non fast forward)
 * [new branch]      topic      -> origin/topic
```

在上面这个例子中， `master` 分支因为不是一个可以 `快速演进` 的引用而拉取操作被拒绝。你可以在 `RefSpec` 之前使用一个 `+` 号来重载这种行为。

输出格式：

```txt
<flag> <summary> <from> -> <to> [<reason>]
```

输出格式详细介绍见：[OUTPUT](https://git-scm.com/docs/git-fetch#_output)

`fetch` 负责将 远程仓库 更新到 远程仓库在本地的对应部分，其他工作又其他 命令 负责。

在实际使用中，大多数时候都是使用 `pull` 间接的使用 `fetch`。


### [git pull](https://git-scm.com/docs/git-pull)

> 将来自远程存储库的更改合并到当前分支中

```sh
git pull [options] [<repository> [<refspec>…​]]
```

```sh
git pull origin master  # 获取远程分支 master 并 merge 到当前分支
```

默认模式下，`git pull` 等价于以下两步:

```sh
git fetch
git merge FETCH_HEAD
```

特例：

```sh
git fetch
git checkout master
git merge origin/master
```

更确切的说，`git pull` 已指定的参数运行 `git fetch`，然后 调用 `git merge` 合并 检索到的分支头到当前分支，通过 `--rebase` 参数，`git merge` 也可以被替换成 `git rebase`。

假定有如下的历史，并且当前分支是 `master`：

```txt
              master on origin
              ↓
      A---B---C
     /
D---E---F---G ← master
    ↑
    origin/master in your repository
```

调用 `git pull` 时，首先需要 `fetch` 变更从远处分支，下拉之后的仓库状态：

```txt
              master on origin
              ↓
      A---B---C ← origin/master in your repository
     /
D---E---F---G ← master
```

因为 远程分支 master (C) 已经和 本地分支 master (G) 已经处于分离状态，此时，`git merge` 合并 `origin/master` 到 `master`。

```txt
              master on origin
              ↓
      A---B---C ← origin/master
     /         \
D---E---F---G---H ← master
```

以上过程发生了一次 `远程` 合并到 `本地` 的情形，git 会自动生成类似下面的 `commit message`：

```txt
Merge branch 'master' of github.com:liuyanjie/knowledge into master
```

出现 `远程` 合并到 `本地` 的情形 在 Git 中是一种不良好的实践，应该极力避免甚至是禁止出现，这种情形在多个人同时在同一个分支上开发的时候非常容易出现。

在实际开发过程中，所有的合并操作都应该发生在远程服务器上，保持所有的分支有清晰的历史。同样，也应该避免不必要的合并，甚至是禁止合并。

> 一般情况下，创建了分支必然需要通过合并来将分支上的内容整合到分支的基上，但是也有不合并的其他方法

合并产生的 `Commit` 并未给版本库带来新的改变，但是却使版本历史不够清晰了。

如何避免 本地合并？

1. 在 `commit` 之前先 `pull`，避免分叉。
2. 在 `commit` 之后立即 `push`，使其他人的本地仓库能及时获取到最新的 `commit`。

知道一定会 发生本地 合并时如何处理？

1. `git pull --ff-only` or `git fetch`
2. `git rebase origin/master`

已经出现 本地合并 如何解决？

1. `git reset C` 重置当前分支到 `C`，`F` `G` 会重新回到暂存区。
2. `git commit -am "commit message"` 重新提交。
3. `git push`

解决之后的分支图：

```txt
              master on origin
              ↓
              origin/master
              ↓
      A---B---C---F---G ← master
     /
D---E
```

假设版本库当前的状态如下：

```txt
              master on origin
              ↓
      A---B---C
     /
D---E ← master
    ↑
    origin/master in your repository
```

以上版本库库满足快速合并的条件，可以进行快速合并 `--ff`：

```txt
              master on origin
              ↓
      A---B---C ← master
     /        ↑
D---E         origin/master in your repository
```

以上版本库满足快速前进的条件，可以进行快速前进 `--ff`：

```txt
              master on origin
              ↓
      A---B---C
     /
D---E ← master
    ↑
    origin/master in your repository
```

快速合并不产生新的 `Commit`，效果上只移动分支头即可，默认情况下进行就是快速合并

在能够进行快速合并的情况下，也可以强制进行合并，如下：

```txt
              master on origin
              ↓
      A---B---C ← origin/master
     /         \
D---E-----------H ← master
```

所以 `git pull` 的参数主要由 `git fetch` 和 `git merge` 的参数组成。

`git pull` 的运行过程：

1. 首先，基于本地的 `FETCH_HEAD` 记录，比对本地的 `FETCH_HEAD` 记录与远程仓库的版本号
2. 然后通过 `git fetch` 获得当前指向的远程分支的后续版本的数据
3. 最后通过 `git merge` 将其与本地的当前分支合并

若有多个 remote，git pull remote_name 所做的事情是：

* 获取 `[remote_name]` 下的所有分支
* 寻找本地分支有没有 `tracking` 这些分支的，若有则 `merge` 这些分支，若没有则 `merge` 当前分支

另外，若只有一个 remote，假设叫 origin，那么 git pull 等价于 git pull origin；平时养成好习惯，没谱的时候都把【来源】带上。

怎么知道 `tracking` 了没有？

* 如果你曾经这么推过：`git push -u origin master`，那么你执行这条命令时所在的分支就已经 `tracking to origin/master` 了
* 如果你记不清了：`cat .git/config`，由此可见，`tracking` 的本质就是指明 `pull` 的 `merge` 动作来源

总结:

* `git pull = git fetch + git merge`
* `git fetch` 拿到了远程所有分支的更新，`cat .git/FETCH_HEAD` 可以看到其状态，若是 `not-for-merge` 则不会有接下来的 `merge` 动作
* `merge` 动作的默认目标是当前分支，若要切换目标，可以直接切换分支
* `merge` 动作的来源则取决于你是否有 `tracking`，若有则读取配置自动完成，若无则请指明【来源】

需要提及的一点是：

`pull` 操作，不应该涉及 `合并` 或 `变基` 操作，即 `pull` 应该总是 快速前进 的。


### [git push](https://git-scm.com/docs/git-push)

> 使用本地引用更新远程引用，同时发送完成给定引用所必需的对象。

`git push` 是与 `git fetch` 相对应的推送操作，同样需要能够推送本地的多种情形的变更到远程仓库。git 向远程仓库推送的操作只有 `push`。

```sh
git push
     [--all | --mirror | --tags]
     [--follow-tags]
     [--atomic]
     [-n | --dry-run]
     [--receive-pack=<git-receive-pack>]
     [--repo=<repository>]
     [-f | --force]
     [-d | --delete]
     [--prune]
     [-v | --verbose]
     [-u | --set-upstream]
     [--push-option=<string>]
     [--[no-]signed|--sign=(true|false|if-asked)]
     [--force-with-lease[=<ref-name>[:<expect>]]]
     [--no-verify]
     [<repository> [<refspec>…​]]
```

```sh
git push                                 # 如果当前分支只有一个追踪分支，那么主机名都可以省略
git push origin HEAD                     # 将 当前 分支 推送 到远程 master 分支
git push origin master                   # 将 master 分支 推送 到远程 master 分支
git push origin master -u                # 将 master 分支 推送 到远程 master 分支，并建立追踪关系
git push origin master --set-upstream    # 同上
git push origin --all                    # 将所有本地分支都推送到origin主机
git push origin --force                  # 强制推送更新远程分支

git push origin :hotfix/xxxx             # 删除远程仓库的 hotfix/xxxx 分支
git push origin :master                  # 删除远程仓库的 master 分支
git push origin --delete master          # 删除远程仓库的 master 分支

git push origin --prune                  # 删除在本地没有对应分支的远程分支

git push --tags                          # 把所有tag推送到远程仓库
```

推送模式：

* simple  模式: 不带任何参数的git push，默认只推送当前分支。2.0以上版本，默认此方式。
* matching模式: 会推送所有有对应的远程分支的本地分支。


```sh
git config --global push.default matching
git config --global push.default simple
```

```sh
$ git push
Enumerating objects: 9, done.
Counting objects: 100% (9/9), done.
Delta compression using up to 8 threads.
Compressing objects: 100% (6/6), done.
Writing objects: 100% (6/6), 1.25 KiB | 1.25 MiB/s, done.
Total 6 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To github.com:liuyanjie/knowledge.git
   d26f671..e081fb3  master -> master
```

### submodule

```sh
git submodule [--quiet] add [-b <branch>] [-f|--force] [--name <name>]
        [--reference <repository>] [--depth <depth>] [--] <repository> [<path>]
git submodule [--quiet] status [--cached] [--recursive] [--] [<path>…​]
git submodule [--quiet] init [--] [<path>…​]
git submodule [--quiet] deinit [-f|--force] (--all|[--] <path>…​)
git submodule [--quiet] update [--init] [--remote] [-N|--no-fetch]
        [--[no-]recommend-shallow] [-f|--force] [--rebase|--merge]
        [--reference <repository>] [--depth <depth>] [--recursive]
        [--jobs <n>] [--] [<path>…​]
git submodule [--quiet] summary [--cached|--files] [(-n|--summary-limit) <n>]
        [commit] [--] [<path>…​]
git submodule [--quiet] foreach [--recursive] <command>
git submodule [--quiet] sync [--recursive] [--] [<path>…​]
```

## 分支管理

Git 是一个分布式的结构，有本地版本库和远程版本库，便有了本地分支和远程分支的区别了。

本地分支和远程分支在 `git push` 的时候可以随意指定，交错对应，只要不出现版本从图即可。

### [git-branch](https://git-scm.com/docs/git-branch)

> 创建、删除、查看分支

```sh
git branch
  [-q | --quiet]
  [-a | --all]
  [-r | --remotes]
  [-v | -vv | --verbose]
  [-t | --track | --no-track]
  [--color[=<when>] |--no-color]
  [--abbrev=<length> | --no-abbrev]
  [--column[=<options>] | --no-column]
  [--sort=<key>]
  [--points-at <object>]
  [--format=<format>]
  [--contains [<commit]]
  [--no-contains [<commit>]]
  [--merged [<commit>]]
  [--no-merged [<commit>]]
  [--list] [<pattern>…​]

git branch [--track | --no-track] [-l] [-f] <branchname> [<start-point>]

git branch [-u | --set-upstream-to=] <upstream> [<branchname>]
git branch --unset-upstream [<branchname>]

git branch (-m --move | -M) [<old-branch>] <new-branch>
git branch (-c --copy | -C) [<old-branch>] <new-branch>

# 删除分支
git branch (-d --delete | -D) [-r] <branchname>…​

git branch --edit-description [<branchname>]
```

git branch -f --force <branchname> <start-point>


分支关系：

* 上游分支，upstream，即指父分支。
* 追踪分支，本地分支和远程分支绑定，在 `pull/push` 时可以自动关联分支。

在 Git 进行本地和远程交互时，Git 需要知道本地分支和对应的远程分支，但是通常不需要指定，因为 Git 自动推断出对应关系并进行分支追踪，这也是为什么书写命令时可以省略很多参数。

如果你从这里克隆，Git 的 clone 命令会为你自动将其命名为 origin，拉取它的所有数据，创建一个指向它的 master 分支的指针，并且在本地将其命名为 origin/master。
Git 也会给你一个与 origin 的 master 分支在指向同一个地方的本地 master 分支，这样你就有工作的基础。


* 追踪分支

```sh
# git branch --track local_branch_name remote_branch_name
git branch --track develop origin/develop
```

远程跟踪分支是远程分支状态的引用。它们是你不能移动的本地引用，当你做任何网络通信操作时，它们会自动移动。远程跟踪分支像是你上次连接到远程仓库时，那些分支所处状态的书签。

它们以 (remote)/(branch) 形式命名。

从一个远程跟踪分支检出一个本地分支会自动创建一个叫做 “跟踪分支”（有时候也叫做 “上游分支”）。 跟踪分支是与远程分支有直接关系的本地分支。 如果在一个跟踪分支上输入 git pull，Git 能自动地识别去哪个服务器上抓取、合并到哪个分支。

当克隆一个仓库时，它通常会自动地创建一个跟踪 origin/master 的 master 分支。

上游快捷方式:当设置好跟踪分支后，可以通过 @{upstream} 或 @{u} 快捷方式来引用它。 所以在 master 分支时并且它正在跟踪 origin/master 时，如果愿意的话可以使用 git merge @{u} 来取代 git merge origin/master。

* 查看分支

```sh
git branch                  # 显示本地分支
git branch -a               # 显示所有分支
git branch -r               # 显示所有原创分支
git branch --contains 50089 # 显示包含提交50089的分支
git branch --merged         # 显示所有已合并到当前分支的分支
git branch --no-merged      # 显示所有未合并到当前分支的分支
git branch -vv              # 将所有的本地分支列出来并且包含更多的信息
```

* 创建分支

```sh
git branch develop
```

* 合并分支

```sh
git merge origin/master                 # 合并远程master分支至当前分支
```

```sh
git rebase
```

* 删除分支

删除一个分支的前提是：该分支完全合并到其上游分支，或者无上游分支。

```sh
git branch -d hotfix/BJVEP933     # 删除分支（本分支修改已合并到其他分支）
git branch -D hotfix/BJVEP933     # 强制删除分支 git branch --delete --force hotfix/BJVEP933
git branch -d -r branch           # 删除远程 branch 分支
```

* 删除远程分支

```sh
git push origin --delete develop
```

* 重命名分支

```sh
git branch -m master master_copy        # 本地分支改名
git branch -M old new                   # 重命名分支，使用-M强制重命名
```

* 分支追踪

git clone时只在本地创建与远程同名的默认分支，并建立追踪关系

工作区新建的分支需要与远程分支建立关系时：

```sh
git branch --set-upstream [branch] [origin]/[branch] # 将本地分支与远程某分支建立追踪关系（并没有要求名字必须相同）
```

```sh
git branch --track [origin]/[branch] # 将自己当前工作分支与某远程分支建立联系
git branch --set-upstream-to [origin]/[branch]
```

```sh
git push -u [origin] [branch]:[branch] # 追踪对应关系，再把本地更新推上去 省略[branchName]则代表是当前工作分支 -u 参数是 upstream 的意思
```

```sh
git pull -u [origin] [branch]:[branch] # 只负责拉下某个远程分支的更新到本地某分支，但是 无法建立追踪关系
```

```sh
git push、git pull、git push --all # 这些缺省指定分支和参数的命令最好在已经指定了追踪关系后使用 
```

查看追踪分支

```sh
git branch -vv
cat .git/config
git config --list
```

情景1：本地有分支，把分支更新推送到远程版本库（远程版本库还没有对应的分支）

情景2：远程有分支，本地还没有创建对应的分支

情景3：本地和远程都没分支 ===> 划归到情景 1 或 2

情景4：本地和远程有相同数量的分支 ===> 建立分支追踪即可

### [git-checkout](https://git-scm.com/docs/git-checkout)

* 检出/切换/创建分支

```sh
git checkout -b `master_copy`            # 从当前分支创建新分支 `master_copy` 并检出
git checkout -b master master_copy       # 从当前分支创建新分支 `master_copy` 并检出
git checkout -b develop origin/develop   # 从远程分支 develop 创建新本地分支 develop 并检出，但是不建立对应的追踪关系
git checkout features/performance        # 检出已存在的 features/performance 分支
git checkout --track hotfix/BJVEP933     # 检出远程分支 hotfix/BJVEP933 并创建本地跟踪分支
git checkout -- README                   # 检出 head 版本的 README 文件（可用于修改错误回退）
git checkout v2.0                        # 检出版本v2.0
```

```sh
git checkout --orphan gh-pages
```

### [git-merge](https://git-scm.com/docs/git-merge)

```sh
git merge
  [-q --quiet]
  [-v --verbose]
  [--[no-]progress]
  [--commit] [--no-commit]
  [-e | --edit] [--no-edit]
  [-ff] [--no-ff] [--ff-only]
  [--log[=<n>]] [--no-log]
  [-n] [--stat] [--no-stat]
  [--[no-]squash]
  [--[no-]signoff]
  [-s <strategy>] [--strategy=<strategy>]
  [-X <strategy-option>] [--strategy-option=<option>]
  [-S[<keyid>]] --gpg-sign[=<keyid>]
  [--[no-]verify-signatures]
  [--[no-]summary]
  [--[no-]allow-unrelated-histories]
  [--[no-]rerere-autoupdate]
  [-m <msg>]
  [<commit>…​]

https://stackoverflow.com/questions/11646107/you-have-not-concluded-your-merge-merge-head-exists

# git merge --abort is equivalent to git reset --merge when MERGE_HEAD is present.
git merge --abort

git merge --continue
```


## 文件管理

* reset

### git add

> 添加文件到索引中，为下一次提交准备内容。

此命令使用在工作树中找到的最新内容更新索引，以准备为下次提交暂存的内容。

```sh
git add
    [--verbose | -v]
    [--dry-run | -n]
    [--force | -f]
    [--interactive | -i]
    [--patch | -p]
    [--edit | -e]
    [--[no-]all | --[no-]ignore-removal | [--update | -u]]
    [--intent-to-add | -N]
    [--refresh]
    [--ignore-errors]
    [--ignore-missing]
    [--chmod=(+|-)x]
    [--]
    [<pathspec>…​]
```

```sh
git add Documentation/\*.txt       # 添加文件
git add node_modules/bluebird  -f  # 强制添加文件，跳过忽略列表
```

### git commit

[Commit message 和 Change log 编写指南](http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)

```sh
git commit
     [-a | --interactive | --patch]
     [-s]
     [-v]
     [-u<mode>]
     [--amend]
     [--dry-run]
     [(-c | -C | --fixup | --squash) <commit>]
     [-F <file> | -m <msg>]
     [--reset-author]
     [--allow-empty]
     [--allow-empty-message]
     [--no-verify]
     [-e]
     [--author=<author>]
     [--date=<date>]
     [--cleanup=<mode>]
     [--[no-]status]
     [-i | -o] [-S[<key-id>]]
     [--]
     [<file>…​]
```

```sh
git commit                          # 提交的是暂存区里面的内容，也就是 Changes to be committed 中的文件。
git commit -a                       # 除了将暂存区里的文件提交外，还提交 Changes bu not updated 中的文件。
git commit -a -m 'commit info'      # 注释，如果没有 -m，会默认会使用vi编辑注释。
git commit -am "This is a commit"   # 同上，合并提交，将 add 和 commit 合为一步
git commit --amend                  # 对上一次提交进行修改，合并上一次提交（用于反复修改）
git commit --amend -a               # 提交时忘记使用 -a 选项，导致 Changes bu not updated 中的内容没有被提交
```

### git rm

```sh
git rm [-f | --force] [-n] [-r] [--cached] [--ignore-unmatch] [--quiet] [--] <file>…​
```

```sh
git rm Documentation/\*.txt
git rm -f git-*.sh
```

### git mv

```sh
git mv <options>…​ <args>…​
git mv [-v] [-f] [-n] [-k] <source> <destination>
git mv [-v] [-f] [-n] [-k] <source> ... <destination directory>
```

```sh
git mv old_name new_name            # 重命名
git mv -f old_name new_name         # 强制重命名，即时目标名称已经存在
git mv -k old_name new_name         # 跳过会导致错误的动作
git mv -v old_name new_name         # 报告被移动文件
git mv --dry-run old_name new_name  # 只显示将会发生什么
```

### git status

```sh
git status [<options>…​] [--] [<pathspec>…​]
```

```sh
git status     # 显示状态
git status -s  # 显示简短信息
git status -b  # 显示分支状态
```

### git diff

```sh
git diff [options] [<commit>] [--] [<path>…​]
git diff [options] --cached [<commit>] [--] [<path>…​]
git diff [options] <commit> <commit> [--] [<path>…​]
git diff [options] <blob> <blob>
git diff [options] [--no-index] [--] <path> <path>
```

[Diff_utility](https://en.wikipedia.org/wiki/Diff_utility)

```sh
git diff                # 查看尚未暂存的文件更新了哪些部分，不加参数直接输入。
git diff --cached       # 查看已经暂存起来的文件(staged)和上次提交时的快照之间(HEAD)的差异
git diff --staged       # 显示的是下一次 commit 时会提交到HEAD的内容(不带-a情况下)
git diff HEAD           # 显示工作版本(Working tree)和HEAD的差别
git diff topic master   # 直接将两个分支上最新的提交做diff
git diff topic...master # 输出自 topic 和 master 分别开发以来，master 分支上的 changed。
git diff --stat         # 查看简单的diff结果，可以加上--stat参数
git diff test           # 查看当前目录和另外一个分支的差别 显示当前目录和另一个叫 test 分支的差别
git diff HEAD -- ./lib  # 显示当前目录下的lib目录和上次提交之间的差别（更准确的说是在当前分支下）
git diff HEAD^ HEAD     # 比较上次提交commit和上上次提交
git diff SHA1 SHA2      # 比较两个历史版本之间的差异
```

### git reset

```sh
git reset [-q] [<tree-ish>] [--] <paths>…​
git reset (--patch | -p) [<tree-ish>] [--] [<paths>…​]
git reset [--soft | --mixed [-N] | --hard | --merge | --keep] [-q] [<commit>]
```

```sh
git reset --mixed id   # (默认) 将 git 的 HEAD 变了(也就是提交记录变了)，但文件并没有改变， 取消了 commit 和 add 的内容
git reset --soft  id   # 实际上，是 git reset –mixed id 后，又做了一次git add。即取消了commit的内容。
git reset --hard  id   # 是将 git 的 HEAD 变了，文件也变了
```

按改动影响范围排序如下: `soft (commit) < mixed (commit + add) < hard (commit + add + local working)`


### 暂存区

```sh
git stash                       # 暂存当前修改，将所有至为HEAD状态
git stash list                  # 查看所有暂存
git stash show -p stash@{0}     # 参考第一次暂存
git stash apply stash@{0}       # 应用第一次暂存
```

