# GIT


## 整理内容

* [GIT对象模型](./git-object-model.md)
* [Git-Usage](./git-usage.md)


## 参考资源

* [Reference](https://git-scm.com/docs)
* [git-cheatsheet](http://ndpsoftware.com/git-cheatsheet.html)
* [learngitbranching](http://learngitbranching.js.org/)
* [ProGit](https://git-scm.com/book/zh/v2)
* [ProGit第一版（中文版）](http://www.kancloud.cn/thinkphp/pro-git)
* [git-recipes](https://github.com/geeeeeeeeek/git-recipes/wiki)
* [GitCommunity Book 中文版](http://gitbook.liuhui998.com/index.html)
* [GotGitHub](http://www.worldhello.net/gotgithub/)
* [git-简易指南](http://www.bootcss.com/p/git-guide/)
* [使用原理视角看 Git](https://blog.coding.net/blog/principle-of-Git)
* [git内部原理](https://www.bittiger.io/blog/post/ExHBZfCRtGwhoYk5f)
* [learn-git-with-bitbucket-cloud](https://www.atlassian.com/git/tutorials/learn-git-with-bitbucket-cloud)
* [git-flow-cheatsheet](http://danielkummer.github.io/git-flow-cheatsheet/)
* [a-successful-git-branching-model](http://nvie.com/posts/a-successful-git-branching-model/)
* [gitflow](https://github.com/nvie/gitflow)
* [常用Git命令清单](http://www.ruanyifeng.com/blog/2015/12/git-cheat-sheet.html)
* [Git使用规范流程](http://www.ruanyifeng.com/blog/2015/08/git-use-process.html)
* [Git分支管理策略](http://www.ruanyifeng.com/blog/2012/07/git.html)
* [what-are-the-differences-between-double-dot-and-triple-dot-in-git-com](http://stackoverflow.com/questions/462974/what-are-the-differences-between-double-dot-and-triple-dot-in-git-com#answer-24186641)
* [使用 Git & Gitflow 管理代码开发、发布流程](https://blog.laisky.com/p/gitflow/)
* [基于GIT的敏捷开发发布流程](http://hustnaive.github.io/scrum/2015/11/13/scrum-develop-process-with-git.html)
* [代码分支管理及发布流程 Code Branch Manage and Publish Work Flow](http://charlescui.github.io/blog/2014/05/01/code-branch-manage-and-publish-work-flow/)
* [GitCorp Flow - 安居客Git开发流程规范](http://erning.net/blog/2012/11/02/gitflow-at-anjuke-inc/)
* [团队使用Git和Git-Flow手记](https://www.toobug.net/article/git_and_gitflow.html)
* [xirong/my-git](https://github.com/xirong/my-git)
* [Git 参考手册](http://gitref.org/zh/index.html)
* [Commit message 和 Change log 编写指南](http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)
* [git 有用却易忘的知识与命令](https://www.zybuluo.com/yangfch3/note/159758)
* [跟我一起学Git (四) 提交](http://cs-cjl.com/2014/03/03/learn_git_with_me_04)
* [删除不存在对应远程分支的本地分支](http://blog.leanote.com/post/darker/%E5%88%A0%E9%99%A4%E4%B8%8D%E5%AD%98%E5%9C%A8%E5%AF%B9%E5%BA%94%E8%BF%9C%E7%A8%8B%E5%88%86%E6%94%AF%E7%9A%84%E6%9C%AC%E5%9C%B0%E5%88%86%E6%94%AF
)
## 实用技巧

* [更改GitCommit時間](http://blog.dm4.tw/blog/2015/04/19/modify-git-commit-time/)
* [在Git，怎么能更改一个旧的提交时间戳？](http://qa.helplib.com/93646)
* [Git 清理无效的远程追踪分支](http://www.jianshu.com/p/884ff6252be5)
* [如何删除已合并的所有git分支？](https://gxnotes.com/article/12889.html)

## GIT指令

* [Reference](https://git-scm.com/docs)


## GIT分布式

[分布式Git](https://git-scm.com/book/zh/v1/%E5%88%86%E5%B8%83%E5%BC%8F-Git)

[集成管理员工作流](https://git-scm.com/figures/18333fig0502-tn.png)

[司令官与副官工作流](https://git-scm.com/figures/18333fig0503-tn.png)


## GIT工作流

* [git-flow-cheatsheet](http://danielkummer.github.io/git-flow-cheatsheet/)
* [a-successful-git-branching-model](http://nvie.com/posts/a-successful-git-branching-model/)
* [gitflow](https://github.com/nvie/gitflow)
* [团队使用Git和Git-Flow手记](https://www.toobug.net/article/git_and_gitflow.html)
* [gitflow 和简单的 master & develop 有什么不同？](https://blog.laisky.com/p/gitflow/)

![a-successful-git-branching-model](images/git-model@2x.png)

其实一张图就可以展示出 gitflow 的全貌

可以看到除了 master 和 develop 外，gitflow 还引入了 feature、 hotfix 和 release，下面一一介绍。

做过大型项目的同学应该知道，一般软件的发布会分为 dev -> stag -> pre -> prod 四个流程，用来和 gitflow 对应就相当于 feature -> develop -> release -> master。

下面逐一介绍各个分支的意义：

* master
  * 线上正式服务器的版本，每一次在 master 上的提交或合并都应该伴随着版本号的变更。
* develop
  * 测试服务器上的版本，作为开发环境中的主分支使用，任务是收集各个 feature 分支。
* release
  * 预发布版本，当 develop 收集够了做一次版本发布所需的代码，就 checkout -b 出一个 release 分支，作为上线前的最后测试，除了 bugfix 外不接受任何提交。确认发布后分别 merge 到 master 和 develop。
* feature
  * 开发人员使用的分支，针对每一个功能点 issue 创建一个 feature，一般命名规范为 feature/<issue_number>-<feature_name>，该 feature 下的每次提交格式为 #<issue_number> <description>，当 feature 开发完毕后 merge 到 develop，并关闭 issue。
* hotfix
  * 紧急修复分支，当 master 上出现 bug 需要修复时，基于 master 创建 hotfix 分支，修复完成后分别 merge 到 master 和 develop。

概括一下就是，每个开发人员在各自的 feature branch 上开发功能代码，完成后合并到 develop 并解决冲突，版本发布前创建 release 分支作为发布前测试，
发布时就把 release merge 到 master 和 develop，如果线上有 bug 就靠 hotfix 分支，再复杂的流程管理起来都清晰明了。

## [git-pretty](http://justinhileman.info/article/git-pretty/git-pretty.png)
