# Git命令

本文件包含常用命令

## 查看帮助

```sh
git help
```


## 配置管理

* 配置文件

Git 提供了一个叫做 git config 的工具，专门用来配置或读取相应的工作环境变量。而正是由这些环境变量，决定了 Git 在各个环节的具体工作方式和行为。

这些变量可以存放在以下三个不同的地方：

* /etc/gitconfig ：系统中对所有用户都普遍适用的配置。若使用 git config 时用 --system 选项，读写的就是这个文件。
* ~/.gitconfig   ：用户目录下的配置文件只适用该用户。若使用 git config 时用 --global 选项，读写的就是这个文件。
* .git/config    ：当前项目的 Git 目录中的配置文件，这里的配置仅仅针对当前项目有效。

每一个级别的配置都会覆盖上层的相同配置，所以 .git/config 里的配置会覆盖 /etc/gitconfig 中的同名变量。

* 配置用户信息（必须配置）

修改全局用户信息

```sh
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
```

* 配置文本编辑器

```sh
git config --global core.editor vim
```

* 配置差异分析工具

```sh
git config --global merge.tool vimdiff
```

Git 可以理解 kdiff3，tkdiff，meld，xxdiff，emerge，vimdiff，gvimdiff，ecmerge，和 opendiff 等合并工具的输出信息。

* 查看配置信息

```sh
git config --list
user.name=Scott Chacon
user.email=schacon@gmail.com
color.status=auto
color.branch=auto
color.interactive=auto
color.diff=auto
...
```

* 常用配置

```sh
git config --global user.name "xxx"                       # 配置用户名
git config --global user.email "xxx@xxx.com"              # 配置邮件
git config --global color.ui true
git config --global color.status auto
git config --global color.diff auto
git config --global color.branch auto
git config --global color.interactive auto
```


## 基础概念

### [Refspec](https://git-scm.com/book/zh/v1/Git-%E5%86%85%E9%83%A8%E5%8E%9F%E7%90%86-The-Refspec)

refspec主要用来表示本地版本库和远程版本库之间的分支标签等数据的对应关系。

指定获取哪些`远程refs`更新`本地refs`，当没有在命令行显示指明`refspec`，会按照下面的默认策略执行。

Refspec 的格式是一个可选的 + 号，接着是 <src>:<dst> 的格式，这里 <src> 是远端上的引用格式， <dst> 是将要记录在本地的引用格式。可选的 + 号告诉 Git 在即使不能快速演进的情况下，也去强制更新它。

从远程获取指定数据到本地，如：

```
branch master 	<==> +refs/heads/master:+refs/heads/master
branch A:a 		<==> +refs/heads/A:+refs/heads/a
tag <tag> 		<==> +refs/tags/<tag>:refs/tags/<tag> 
```

`refspec`一般不会出现在命令行中，而是由命令自动写在配置文件中，但是可以在命令行中直接使用。

### GIT-URLS

一般来说，URL中含有**协议、远程主机名、版本库路径**等信息。依赖于不同协议，有些信息可以省略。GIT支持**HTTP、HTTPS、SSH、GIT**协议。

以下是相关协议的语法:

* ssh://[user@]host.xz[:port]/path/to/repo.git/
* git://host.xz[:port]/path/to/repo.git/
* http[s]://host.xz[:port]/path/to/repo.git/
* ftp[s]://host.xz[:port]/path/to/repo.git/

扩展了用户名之后的:

* ssh://[user@]host.xz[:port]/~[user]/path/to/repo.git/
* git://host.xz[:port]/~[user]/path/to/repo.git/
* [user@]host.xz:/~[user]/path/to/repo.git/

GIT同时也支持本地版本库，URL如下：

* /path/to/repo.git/
* file:///path/to/repo.git/

### 远程仓库REMOTES

远程仓库配置主要包含的就是一系列`GIT-URLS`及`refspec`等数据，并赋予一个名字`<repository>`。

可以使用以下当中的任意一个来替代`<repository>`参数，`<repository>`即表示一个仓库。

以下内容指明了Git如何确定 `<repository>:<branch>`。

#### Named remote in configuration file `$GIT_DIR/config`

在之前使用`git-remote`、`git-config`时可以选择为远程版本库提供一个名字，也可以手动编辑`$GIT_DIR/config`文件。这个名字可以用来访问版本库。
在命令行上，会默认使用这个名字下的远程路径`refspec`。

查看`config`文件应该会看到这样一个结构：

```
[remote "<name>"]
	url = <url>
	pushurl = <pushurl>
	push = <refspec>
	fetch = <refspec>
```

`pushurl`只能用于push，默认使用`url`

这个结构记录了REMOTES信息。

#### Named file in　`$GIT_DIR/remotes`

也可以选择提供一个特定名称的文件放到`$GIT_DIR/remotes`目录下，文件中URL将被用于访问版本库。

在命令行没有提供`refspec`时文件中`refspec`将会被使用。

文件会是如下格式：

```
URL: one of the above URL format
Push: <refspec>
Pull: <refspec>
```	

* Push:用于`git push`
* Pull:用于`git pull`

#### Named file in `$GIT_DIR/branches`

也可以选择提供一个特定名称的文件放到`$GIT_DIR/branches`目录下，文件中URL将被用于访问版本库。

文件会是如下格式：

```
<url>#<head>
```

<url> 必须的; #<head> 可选的.

配置文件中并没有指明`refspecs`，所以Git需要按照某种策略执行。

根据不同操作，如果你没有在命令行提供，Git将会使用以下`refspecs`中的一种：

`<branch>` 是 `$GIT_DIR/branches` 目录下的文件名，`<head>` 默认值是 `master`.

git fetch uses:

```
refs/heads/<head>:refs/heads/<branch>
```

git push uses:

```
HEAD:refs/heads/<head>
```

#### CONFIGURED REMOTE-TRACKING BRANCHES

你经常定期的重复的获取和远程版本库往来，为了保持跟踪远程版本库进展，`git fetch`允许你配置`remote.<repository>.fetch`变量。

变量形式如下：

```
[remote "origin"]
	fetch = +refs/heads/*:refs/remotes/origin/*
```

This configuration is used in two ways:

When git fetch is run without specifying what branches and/or tags to fetch on the command line, e.g. git fetch origin or git fetch, remote.<repository>.fetch values are used as the refspecs—​they specify which refs to fetch and which local refs to update. The example above will fetch all branches that exist in the origin (i.e. any ref that matches the left-hand side of the value, refs/heads/*) and update the corresponding remote-tracking branches in the refs/remotes/origin/* hierarchy.

When git fetch is run with explicit branches and/or tags to fetch on the command line, e.g. git fetch origin master, the <refspec>s given on the command line determine what are to be fetched (e.g. master in the example, which is a short-hand for master:, which in turn means "fetch the master branch but I do not explicitly say what remote-tracking branch to update with it from the command line"), and the example command will fetch only the master branch. The remote.<repository>.fetch values determine which remote-tracking branch, if any, is updated. When used in this way, the remote.<repository>.fetch values do not have any effect in deciding what gets fetched (i.e. the values are not used as refspecs when the command-line lists refspecs); they are only used to decide where the refs that are fetched are stored by acting as a mapping.

The latter use of the remote.<repository>.fetch values can be overridden by giving the --refmap=<refspec> parameter(s) on the command line.

#### 输出

```
 <flag> <summary> <from> -> <to> [<reason>]
```

flags A single character indicating the status of the ref:

* `(space)` for a successfully fetched fast-forward;
* `+`       for a successful forced update;
* `-`       for a successfully pruned ref;
* `t`       for a successful tag update;
* `*`       for a successfully fetched new ref;
* `!`       for a ref that was rejected or failed to update; and
* `=`       for a ref that was up to date and did not need fetching.

summary

For a successfully fetched ref, the summary shows the old and new values of the ref in a form suitable for using as an argument to git log 

(this is <old>..<new> in most cases, and <old>...<new> for forced non-fast-forward updates).

from
The name of the remote ref being fetched from, minus its refs/<type>/ prefix. In the case of deletion, the name of the remote ref is "(none)".

to
The name of the local ref being updated, minus its refs/<type>/ prefix.

reason
A human-readable explanation. In the case of successfully fetched refs, no explanation is needed. For a failed ref, the reason for failure is described.


## 版本库管理

Git是一个分布式的版本控制系统，这意味着在Git中版本库有**本地版本库**和**远程版本库**之分。
每个远程仓库可以有多个本地仓库，同时一个本地版本库可以同时对应多个远程版本库，多个远程版本库是从一个最原始的版本库Fork产生的，本质上就是以一个版本库为基础，创建了另外一个新的版本库，这些版本库直接可以通过`PullRequest`操作进行仓库的交互。
本地仓库对应的远程仓库记录在`.git/config`文件中。本地仓库可以于多个的远程仓库`pull/push`代码。

### 初始化仓库

```sh
mkdir repo
cd repo
git init                                                  # 初始化本地git仓库
```

```sh
git clone git+ssh://git@192.168.53.168/VT.git             # clone远程仓库
```

### 仓库维护

#### git remote

```
git remote [-v | --verbose]
git remote [-v | --verbose] show [-n] <name>…​
git remote [-v | --verbose] update [-p | --prune] [(<group> | <remote>)…​]
git remote add [-t <branch>] [-m <master>] [-f] [--[no-]tags] [--mirror=<fetch|push>] <name> <url>
git remote rename <old> <new>
git remote remove <name>
git remote set-head <name> (-a | --auto | -d | --delete | <branch>)
git remote set-branches [--add] <name> <branch>…​
git remote get-url 			[--push] [--all] <name>
git remote set-url 			[--push] <name> <newurl> [<oldurl>]
git remote set-url --add 	[--push] <name> <newurl>
git remote set-url --delete [--push] <name> <url>
git remote prune [-n | --dry-run] <name>…​
```

```sh
git remote                                          		# 列出已经存在的远程分支
git remote -v                                       		# 查看远程主机的地址
git remote show   remote_name                       		# 查看该远程主机的详细信息
git remote add    remote_name remote_url            		# 添加远程主机
git remote remove remote_name                       		# 删除远程主机
git remote rename remote_name new_remote_name       		# 重命名远程主机

git remote get-url remote_name                      		# 查看远程主机地址
git remote set-url remote_name git://new.url.here   		# 修改远程主机地址
git remote set-url remote_name --add 	git://new.url.here  # 修改远程主机地址
git remote set-url remote_name --delete git://new.url.here  # 删除远程主机地址

git remote prune [-n | --dry-run] <name>…​           # 删除某个远程名下过期的分支，即在远程删除本地存在的分支

# see http://stackoverflow.com/questions/1856499/differences-between-git-remote-update-and-fetch
git remote [-v | --verbose] update [-p | --prune] [(<group> | <remote>)…​]

git remote set-head 		# 可以 设置（增加、修改、删除） 默认分支
git remote set-branches
```

添加一个远程仓库的时候，除了指定仓库地址，可以对与仓库交互时的一些行为等进行设置，具体参见[官方文档](https://git-scm.com/docs/git-remote)。


#### git fetch

```sh
git fetch [<options>] [<repository> [<refspec>…​]]
git fetch [<options>] <group>
git fetch --multiple [<options>] [(<repository> | <group>)…​]
git fetch --all [<options>]
```

```sh
git fetch                                                  	# 更新git remote中所有的远程repo 所包含分支的最新commit-id，将其记录到.git/FETCH_HEAD文件中（不更新本地分支，另需merge）
git fetch -all                  							# 获取所有远程分支
git fetch remote-repo                                      	# 更新名称为 remote-repo 的远程repo上的所有分支的最新commit-id，将其记录。
git fetch remote-repo remote-branch-name                   	# 更新名称为 remote-repo 的远程repo上的分支：remote-branch-name，可以用来测试远程主机的远程分支是否存在，如果存在，返回0，如果不存在，返回128，抛出一个异常.
git fetch remote-repo remote-branch-name:local-branch-name 	# 更新名称为 remote-repo 的远程repo上的分支：remote-branch-name，并在本地创建 local-branch-name 本地分支保存远端分支的所有数据。
git fetch --dry-run 										# Show what would be done, without making any changes.
git fetch -f | --force 										# 当使用refspec(<rbranch>:<lbranch>)时，跳过亲子关系检查，强制更新本地分支。
git fetch -p | --prune                                    	# 获取所有原创分支并清除服务器上已删掉的分支
git fetch -t | --tags 										# 从远程获取数据时获取tags，默认
git fetch -n | --no-tags 									# 从远程获取数据时去除tags
git fetch --progress --verbose 								# 显示进度及冗长日志
```

FETCH_HEAD：是一个版本链接，记录在本地的一个文件中，指向着目前已经从远程仓库取下来的分支的末端版本。

执行过fetch操作的项目都会存在一个`FETCH_HEAD`列表，这个列表保存在，其中每一行对应于远程服务器的一个分支.

当前分支指向的`FETCH_HEAD`，就是这个文件第一行对应的那个分支。

一般来说，存在两种情况:

  * 如果没指定远程分支，`FETCH_HEAD` 为 `master`
  * 如果指定了远程分支，`FETCH_HEAD` 为 指定的 `远程分支`，在这种情况下，不会在本地创建本地远程分支，因为:这个操作是`git pull origin branch-name`的第一步，而对应的pull操作，并不会在本地创建新的branch.


例如：

```sh
# git fetch origin :branch-local 等价于: git fetch origin master:branch-local
git fetch origin branch-remote:branch-local
```

* 首先执行上面的fetch操作
* 使用远程branch-remote分支在本地创建branch-local(但不会切换到该分支)
* 如果本地不存在branch-local分支，则会自动创建一个新的branch-local分支
* 如果本地已存在branch-local分支，并且是`fast forward'模式，则自动合并两个分支，否则，会阻止以上操作

fetch 用法与三处分支关系图

三处分支关系图 

git fetch 用于取回更新 
取回远程所有分支的更新

```sh
git fetch [originName]：参数是远程源名
```

用于取回该远程源所有的更新 
注意：取回的更新是是放在.git\refs\remotes\origin目录下，打开该目录可看到远程源的所有分支 

---dev 
---master 
---...

取回远程特定分支的更新

```sh
git fetch [originName] [branchName]
```

注意：虽然我们取回了更新，fetch取回的之后的更新的保存位置保存在`.git\refs\remotes\origin`目录下，那么如何恢复这些更新到工作区呢？

同步工作区与`.git`仓库

工作区为空，以fetch回来的某分支的更新在工作区新建分支，并自动与该远程分支建立追踪关系

```sh
git checkout -b [newBranch] [originName]/[remoteBranchName]
```

上面命令表示，在originName/remoteBranchName的基础上，创建一个新分支，并建立追踪关系。

```sh
git merge [originName]/[branchName]
```

合并远程分支的更新到当前工作分支（但不建立追踪关系） 


#### git pull

```sh
git pull [options] [<repository> [<refspec>…​]]
```

```sh
git pull origin master  # 获取远程分支master并merge到当前分支
```

在默认模式下，`git pull`等价于以下两步:

```sh
git fetch ...
git merge FETCH_HEAD
```

所以`git pull`的参数主要由`git fetch`和`git merge`的参数组成。

git pull 的运行过程：

* 首先，基于本地的`FETCH_HEAD`记录，比对本地的`FETCH_HEAD`记录与远程仓库的版本号，
* 然后`git fetch`获得当前指向的远程分支的后续版本的数据，
* 然后再利用`git merge`将其与本地的当前分支合并。


若有多个 remote，git pull [remote name] 所做的事情是：

* fetch [remote name] 的所有分支
* 寻找本地分支有没有 tracking 这些分支的，若有则 merge 这些分支，若没有则 merge 当前分支

另外，若只有一个 remote，假设叫 origin，那么 git pull 等价于 git pull origin；平时养成好习惯，没谱的时候都把 【来源】带上。

怎么知道 tracking 了没有？

* 如果你曾经这么推过：`git push -u origin master`，那么你执行这条命令时所在的分支就已经 `tracking to origin/master` 了，-u 的用处就在这里
* 如果你记不清了：`cat .git/config`，由此可见，tracking 的本质就是指明 pull 的 merge 动作来源。别忘了：pull = fetch + merge。

总结:

* `git pull = git fetch + merge`
* `git fetch` 拿到了远程所有分支的更新，`cat .git/FETCH_HEAD` 可以看到其状态，若是 not-for-merge 则不会有接下来的 merge 动作
* merge 动作的默认目标是当前分支，若要切换目标，可以直接切换分支
* merge 动作的来源则取决于你是否有 tracking，若有则读取配置自动完成，若无则请指明【来源】

需要提及的一点是:

pull操作, 不应该涉及三方合并 或 衍合操作
换个说法: pull 应该总是 fast forward 的。 为了达到这样一个效果, 在真正push操作之前, 我倾向于使用衍合, 在本地对代码执行合并操作。


#### git push

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
	   [--force-with-lease[=<refname>[:<expect>]]]
	   [--no-verify] 
	   [<repository> [<refspec>…​]]
```

```sh
git push 													# 如果当前分支只有一个追踪分支，那么主机名都可以省略
git push origin HEAD 										# 将当前分支push到远程master分支
git push origin master                                      # 将master分支push到远程master分支
git push -u origin master 									# 如果当前分支与多个主机存在追踪关系，则可以使用-u选项指定一个默认主机，这样后面就可以不加任何参数使用git push
git push --set-upstream origin master 						# 同上
git push --all origin  										# 将所有本地分支都推送到origin主机。
git push --force origin 									# 如果远程主机的版本比本地版本更新，推送时Git会报错，如果你一定要推送，可以使用–force选项。

git push --prune 											# 删除在本地没有对应分支的远程分支
git push origin :hotfixes/BJVEP933                          # 删除远程仓库的hotfixes/BJVEP933分支
git push origin :master 									# 删除origin主机的master分支，相当于推送空分支到远程
git push origin --delete master 							# 删除origin主机的master分支
git push --tags                                             # 把所有tag推送到远程仓库
```

* simple  模式: 不带任何参数的git push，默认只推送当前分支。2.0以上版本，默认此方式。
* matching模式: 会推送所有有对应的远程分支的本地分支。

配置模式
```sh
$ git config --global push.default matching
$ git config --global push.default simple
```

#### submodule

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

## 文件管理

Git作为一个版本控制系统，主要就是对文件的修改历史进行追踪，自然而然对应一系列文件管理操作。

文件管理可以当作是文件状态管理，一般仓库中的文件可能存在于这三种状态：

1. Untracked files → 文件未被跟踪；
1. Changes to be committed → 文件已暂存，这是下次提交的内容；
1. Changes bu not updated → 文件被修改，但并没有添加到暂存区。如果 commit 时没有带 -a 选项，这个状态下的文件不会被提交。

```sh
git status
# On branch master
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#    new file:   file2
#
# Changed but not updated:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#    modified:   file
#
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#    file3
```

* status
* diff
* reset

### git add

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
git add Documentation/\*.txt   		# 添加文件
git add -f node_modules/bluebird 	# 强制添加文件，跳过忽略列表
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
	   [-i | -o] [-S[<keyid>]]
	   [--]
	   [<file>…​]
```

```sh
git commit 							# 提交的是暂存区里面的内容，也就是 Changes to be committed 中的文件。
git commit -a  						# 除了将暂存区里的文件提交外，还提交 Changes bu not updated 中的文件。
git commit -a -m 'commit info' 		# 注释，如果没有 -m，会默认会使用vi编辑注释。
git commit -am "This is a commit"   # 同上，合并提交，将add和commit合为一步
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
git diff 				# 查看尚未暂存的文件更新了哪些部分，不加参数直接输入。此命令比较的是工作目录(Working tree)和暂存区域快照(index)之间的差异，也就是修改之后还没有暂存起来的变化内容。
git diff --cached 		# 查看已经暂存起来的文件(staged)和上次提交时的快照之间(HEAD)的差异
git diff --staged 		# 显示的是下一次commit时会提交到HEAD的内容(不带-a情况下)
git diff HEAD 			# 显示工作版本(Working tree)和HEAD的差别
git diff topic master 	# 直接将两个分支上最新的提交做diff
git diff topic...master # 输出自topic和master分别开发以来，master分支上的changed。
git diff --stat 		# 查看简单的diff结果，可以加上--stat参数
git diff test 			# 查看当前目录和另外一个分支的差别 显示当前目录和另一个叫'test'分支的差别
git diff HEAD -- ./lib 	# 显示当前目录下的lib目录和上次提交之间的差别（更准确的说是在当前分支下）
git diff HEAD^ HEAD 	# 比较上次提交commit和上上次提交
git diff SHA1 SHA2 		# 比较两个历史版本之间的差异
```

### git reset

```sh
git reset [-q] [<tree-ish>] [--] <paths>…​
git reset (--patch | -p) [<tree-ish>] [--] [<paths>…​]
git reset [--soft | --mixed [-N] | --hard | --merge | --keep] [-q] [<commit>]
```

```sh
git reset --mixed id   # (默认)是将git的HEAD变了(也就是提交记录变了),但文件并没有改变，(也就是working tree并没有改变). 取消了commit和add的内容.
git reset --soft  id   # 实际上，是git reset –mixed id 后,又做了一次git add.即取消了commit的内容.
git reset --hard  id   # 是将git的HEAD变了,文件也变了.
```

按改动影响范围排序如下: soft (commit) < mixed (commit + add) < hard (commit + add + local working)


### 暂存区

```sh
git stash                       # 暂存当前修改，将所有至为HEAD状态
git stash list                  # 查看所有暂存
git stash show -p stash@{0}     # 参考第一次暂存
git stash apply stash@{0}       # 应用第一次暂存
```

## 历史管理

特殊符号:
     ^ 代表父提交,当一个提交有多个父提交时,可以通过在^后面跟上一个数字,表示第几个父提交: ^相当于^1.
     ~ <n>相当于连续的<n>个^.

```sh
git reset --hard HEAD                                     # 将当前版本重置为HEAD（通常用于merge失败回退）
git revert dfb02e6e4f2f7b573337763e5c0013802e392818       # 撤销提交dfb02e6e4f2f7b573337763e5c0013802e392818
```

## 分支管理

GIT是一个分布式的结构，有本地版本库和远程版本库，便有了本地分支和远程分支的区别了。

本地分支和远程分支在`git push`的时候可以随意指定，交错对应，只要不出现版本从图即可。

分支关系：

  * 上游分支，upstream，即指父分支。
  * 追踪分支，本地分支和远程分支绑定，在`pull/push`时可以自动关联分支。

在git进行本地和远程交互时，git需要知道本地分支和对应的远程分支，但是通常不需要指定，因为git自动推断出对应关系并进行分支追踪，这也是为什么书写命令时可以省略很多参数。

如果你从这里克隆，Git 的 clone 命令会为你自动将其命名为 origin，拉取它的所有数据，创建一个指向它的 master 分支的指针，并且在本地将其命名为 origin/master。 
Git 也会给你一个与 origin 的 master 分支在指向同一个地方的本地 master 分支，这样你就有工作的基础。


* 追踪分支

```sh
# git branch --track local_branch_name remote_branch_name
git branch --track expermental origin/expermental
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
git branch -vv 				# 将所有的本地分支列出来并且包含更多的信息
```

* 创建分支

```sh
git branch test             # 创建test分支
```

* 检出/切换/创建分支

```sh
git checkout -b `master_copy`            # 从当前分支创建新分支`master_copy`并检出
git checkout -b master master_copy       # 从当前分支创建新分支`master_copy`并检出
git checkout -b devel origin/develop     # 从远程分支develop创建新本地分支devel并检出，但是不建立对应的追踪关系
git checkout features/performance        # 检出已存在的features/performance分支
git checkout --track hotfixes/BJVEP933   # 检出远程分支hotfixes/BJVEP933并创建本地跟踪分支
git checkout -- README                   # 检出head版本的README文件（可用于修改错误回退）
git checkout v2.0                        # 检出版本v2.0
```

```sh
git checkout --orphan gh-pages
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
git branch -d hotfixes/BJVEP933     # 删除分支（本分支修改已合并到其他分支）
git branch -D hotfixes/BJVEP933     # 强制删除分支  ===>  git branch --delete --force hotfixes/BJVEP933
git branch -d -r branchname         # 删除远程branchname分支
```

* 删除远程分支

```sh
git push origin --delete serverfix
```

* 重命名分支

```sh
git branch -m master master_copy        # 本地分支改名
git branch -M oldbranch newbranch       # 重命名分支，使用-M强制重命名。
```

* 分支追踪

git clone时只在本地创建与远程同名的默认分支，并建立追踪关系

工作区新建的分支需要与远程分支建立关系时：

```sh
git branch --set-upstream [branchName] [originName]/[remoteBranchName] # 将本地分支与远程某分支建立追踪关系（并没有要求名字必须相同） 
```

```sh
git branch --track [originName]/[remoteBranchName] # 将自己当前工作分支与某远程分支建立联系 
git branch --set-upstream-to [originName]/[remoteBranchName] 
```

```sh
git push -u [originName] [branchName]:[remoteBranchName] 是先建立[branchName]:[remoteBranchName] # 追踪对应关系，再把本地更新推上去 省略[branchName]则代表是当前工作分支 -u参数是upstream的意思
```

```sh
git pull -u [originName] [branchName]:[remoteBranchName] # 只负责拉下某个远程分支的更新到本地某分支，但是 无法建立追踪关系
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
git push -u origin newbranch
-u参数的作用：本地新建分支，远程仓库并没有该新分支，-u代表的意思：1.在远程仓库创建新版本库：newbranch；2.将本地新分支与新建的远程分支建立联系；3.push新分支上的文件上远程新分支去

情景2：远程有分支，本地还没有创建对应的分支

方案一：

本地新建分支 
在现有分支的基础上新建分支：见上方创建分支
创建一个新的空分支 
git symbolic-ref HEAD refs/heads/newbranch 
rm .git/index 
git clean -fdx 

取回远程分支的代码 
git pull [originName] [remoteBranchNaem] 

这样就能在本地创建一个全新的分支且与远程同步并不发生冲突了
情景3：本地和远程都没分支 ===> 划归到情景 1 或 2

情景4：本地和远程有相同数量的分支 ===> 建立分支追踪即可

删除本地分支和远程分支

删除本地分支： 
$ git branch -D mybranch1 


删除远程分支： 
git push [originName] --delete [branchName] 

* 分支同步

如何在本地删除分支后，使远程的该分支也得到删除？

再使用下面的命令删除远程分支，相当于把一个空的分支推送到远程分支上，达到删除的目的，注意：不能删除设置的默认分值，删除时会报错
```sh
git push origin :mybranch1 
```

如何在删除远程分支后，使本地分支也得到删除？

远程主机删除了某个分支，默认情况下，git pull 不会在拉取远程分支的时候，删除对应的本地分支。这是为了防止，由于其他人操作了远程主机，导致git pull不知不觉删除了本地分支。 

```sh
git pull -p [origin] 
```

## 标签管理

```sh
git tag                                 # 显示已存在的tag
git tag -r 								# 查看远程版本
git tag v2.0   							# 创建标签
git tag -a v2.0 -m 'xxx'                # 增加v2.0的tag，带有注释
git tag -d v2.0                         # 删除标签
```

```sh
git pull origin --tags 					# 合并远程仓库的tag到本地
git push origin --tags 					# 上传本地tag到远程仓库
```

## 日志

```
git log --pretty=short | git shortlog [<options>]
git shortlog [<options>] [<revision range>] [[\--] <path>…​]
```

```sh
git log                                                   # 显示提交日志
git log -3                                                # 显示3行日志 -n为n行
git log --stat                                            # 显示提交日志及相关变动文件
git log -p -m
git log v2.0                                              # 显示v2.0的日志
git log --pretty=format:'%h %s' --graph                   # 图示提交日志
git log --oneline --number 							      # : 每条log只显示一行,显示number条.
git log --oneline --graph                                 # :可以图形化地表示出分支合并历史.
git log branchname                                        # 可以显示特定分支的log.
git log --oneline branch1 ^branch2                        # 可以查看在分支1,却不在分支2中的提交.^表示排除这个分支(Window下可能要给^branch2加上引号).
git log --decorate                                        # 会显示出tag信息.
git log --author=[author name]                            # 可以指定作者的提交历史.
git log --since --before --until --after                  # 根据提交时间筛选log.
git log --no-merges                                       # 可以将merge的commits排除在外.
git log --grep=keywords                                   # 根据commit信息过滤log
git log -p:                                               # 每一个提交都是一个快照(snapshot),Git会把每次提交的diff计算出来,作为一个patch显示给你看.另一种方法是git show [SHA].
git log --stat:                                           # 同样是用来看改动的相对信息的,--stat比-p的输出更简单一些.
git log -SmethodName                                      # (注意S和后面的词之间没有等号分隔).
git log --grep --author                                   # 是OR的关系,即满足一条即被返回,如果你想让它们是AND的关系,可以加上--all-match的option.
git reflog                                                # 显示所有提交，包括孤立节点
```

```sh
git reflog [show] [log-options] [<ref>]
git reflog expire [--expire=<time>] [--expire-unreachable=<time>]
	[--rewrite] [--updateref] [--stale-fix]
	[--dry-run] [--verbose] [--all | <refs>…​]
git reflog delete [--rewrite] [--updateref]
	[--dry-run] [--verbose] ref@{specifier}…​
git reflog exists <ref>
```

## show

Shows one or more objects (blobs, trees, tags and commits).

```sh
git show [options] <object>…​
```

```sh
git show dfb02e6e4f2f7b573337763e5c0013802e392818         # 显示某个提交的详细内容
git show dfb02                                            # 可只用commitid的前几位
git show HEAD                                             # 显示HEAD提交日志
git show HEAD^                                            # 显示HEAD的父（上一个版本）的提交日志 ^^为上两个版本 ^5为上5个版本
git show HEAD@{5}
git show HEAD~3
git show v2.0                                             # 显示v2.0的日志及详细内容
git show master@{yesterday}                               # 显示master分支昨天的状态
git show -s --pretty=raw 2be7fcb476
git show-branch                                           # 图示当前分支历史
git show-branch --all                                     # 图示所有分支历史
```

## 搜索

```sh
git grep "delete from"                                    # 文件中搜索文本“delete from”
git grep -e '#define' --and -e SORT_DIRENT
```

## Other

* git gc
* git fsck
* git cherry-pick ff44785404a8e                             # 合并提交ff44785404a8e的修改
* git whatchanged                                           # 显示提交历史对应的文件修改

## 内部命令

* cat-file
* commit-tree
* count-objects
* diff-index
* for-each-ref
* hash-object
* ls-files
* merge-base
* read-tree
* rev-list
* rev-parse
* show-ref
* symbolic-ref
* update-index
* update-ref
* verify-pack
* write-tree

* git ls-files                                              # 列出git index包含的文件
* git ls-tree HEAD                                          # 内部命令：显示某个git对象
* git rev-parse v2.0                                        # 内部命令：显示某个ref对于的SHA1 HASH
