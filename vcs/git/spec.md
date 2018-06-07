# Spec

* [GitHub Flow](https://guides.github.com/introduction/flow/)
* [GitLab Flow](https://docs.gitlab.com/ee/workflow/gitlab_flow.html)

## ...

无论如何，开发总是从一个需求开始的 ...

1. 需求

首先，需要有一个需求，明确需要做什么，可能来自产品的一个完整的功能需求或已有功能微调，可能来自于技术上的需求如Bug修复、重构、优化代码、补充文档、补充测试用例等

针对于不同的需求，采用不同的Github工作流。

对于需要详细说明，进行一定讨论的功能，需要创建GitHubIssues。并提供相关需求文档或需求文档链接。进行相关的功能讨论，实现思路的说明确认。此处可实现设计审核。

对于简单的修改，可以省略创建GitHubIssues

TODO: 总结开发中常见的情形，明确哪些类型的需求一定要创建GitHubIssues

2. 开发

开发流程采用基于分支的开发策略，即通过分支进行功能开发，完成开发后通过PR并入主干分支，保持主干分支稳定且随时可发布状态。


## a-successful-git-branching-model

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

## Refs

* [基于GIT的敏捷开发发布流程](http://hustnaive.github.io/scrum/2015/11/13/scrum-develop-process-with-git.html)
* [代码分支管理及发布流程](http://charlescui.github.io/blog/2014/05/01/code-branch-manage-and-publish-work-flow/)
* [GitCorp Flow - 安居客Git开发流程规范](http://erning.net/blog/2012/11/02/gitflow-at-anjuke-inc/)
* [团队使用Git和Git-Flow手记](https://www.toobug.net/article/git_and_gitflow.html)
