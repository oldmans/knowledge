# Git配置管理

* 配置文件

Git 提供了一个叫做 git config 的工具，专门用来配置或读取相应的工作环境变量。而正是由这些环境变量，决定了 Git 在各个环节的具体工作方式和行为。

这些变量可以存放在以下三个不同的地方：

* `/etc/gitconfig` ：系统中对所有用户都普遍适用的配置。若使用 git config 时用 --system 选项，读写的就是这个文件。
* `~/.gitconfig`   ：用户目录下的配置文件只适用该用户。若使用 git config 时用 --global 选项，读写的就是这个文件。
* `.git/config`    ：当前项目的 Git 目录中的配置文件，这里的配置仅仅针对当前项目有效。

每一个级别的配置都会覆盖上层的相同配置，所以 `.git/config` 里的配置会覆盖 `/etc/gitconfig` 中的同名变量。

* 配置用户信息（必须配置）

修改全局用户信息

```sh
git config --global user.name "liuyanjie"
git config --global user.email "lyj8888888888@gmail.com"
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
$ git config --list

credential.helper=osxkeychain
core.excludesfile=/Users/liuyanjie/.gitignore_global
difftool.sourcetree.cmd=opendiff "$LOCAL" "$REMOTE"
difftool.sourcetree.path=
mergetool.sourcetree.cmd=/Applications/SourceTree.app/Contents/Resources/opendiff-w.sh "$LOCAL" "$REMOTE" -ancestor "$BASE" -merge "$MERGED"
mergetool.sourcetree.trustexitcode=true
user.name=liuyanjie
user.email=lyj8888888888@gmail.com
core.repositoryformatversion=0
core.filemode=true
core.bare=false
core.logallrefupdates=true
core.ignorecase=true
core.precomposeunicode=true
remote.origin.url=git@github.com:xxx/xxx.git
remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
branch.master.remote=origin
branch.master.merge=refs/heads/master
```

* 常用配置

```sh
git config --global user.name "xxx"
git config --global user.email "xxx@xxx.com"
git config --global color.ui true
git config --global color.status auto
git config --global color.diff auto
git config --global color.branch auto
git config --global color.interactive auto
```
