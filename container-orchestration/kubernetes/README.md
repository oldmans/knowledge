# Kubernetes

## Introduce

项目历史、状态、规划

入门过程

文档

Operator
Developor

## CNCF

云原生应用

## Requirements

systemd
PKI/X.509

## 文档结构

## Setup

安装部署方式、过程

minikube
kubeadm
Creating a Custom Cluster from Scratch

Environments

Vagrant
Aliyun

安装后的目录结构

## Kubernetes Architecture

### Master

### Nodes

## Ops

## Roles

Application Developer
Cluster Operator

## Hardware Resource

PAAS

容器 CRI

CPU计算资源
MEM内存资源
Storage存储资源 CSI
NetWork网络资源 CNI

## Kubernetes Api Overview

## Kubernetes Api Object

https://kubernetes.io/docs/reference/api-concepts/

REST Api 是 Kubernetes 的基本结构。组件之间的所有操作和通信都是由 API Server 处理的 REST API 调用，包括外部用户的命令。

因此，Kubernetes 平台中的所有内容都被视为 API object，并在API中具有相应的入口。

大多数操作都可以通过 `kubectl` 命令行接口或其他命令行工具如 `kubeadm` 执行。也可以直接通过 REST Api 直接访问，如 `curl`。

也有其他客户端库可以使用，如果想在应用程序中访问 Kubernetes Api。

* ApiVersions

    Kubernetes 支持多版本的 Api，这些 Api 在不同的路径上。如：

        /api/v1
        /apis/extensions/v1beta1

    版本是 Api 级别的版本，而不是资源或字段级别的版本，确保 Api 清晰且保持一致。

    不同的 Api 版本意味着不同级别的稳定性和支持

    * Alpha level，名称中包含 `alpha`, 如 `v1alpha1`，可能有很多Bugs，默认关闭，未来可能会被修改甚至移除，推荐只用在短声明周期的测试环境
    * Beta level，名称中包含 `beta`, 如 `v1beta1`，经过很全面的测试，默认开启，未来可能会进行一些小的改动，推荐用在不重要的商业逻辑中就，邀请测试提供反馈
    * Stable level，`vX`

* ApiGroups

    ApiGroups 使扩展 Kubernetes Api 变的更加容易。ApiGroup 在 `REST 路径中` 或 `序列化对象的 ApiVersion 字段` 中指定。当前，有多个 ApiGroup 正在使用。

    * Core Group，`/api/v1`
    * Named Group, `/apis/$GROUP_NAME/$VERSION`，`apiVersion: $GROUP_NAME/$VERSION（eg. batch/v1）`

    当前，有两种方式支持使用 自定义资源 扩展 Kubernetes Api：

    1. `CustomResourceDefinition` is for users with very basic CRUD needs
    2. Coming soon: users needing the full set of Kubernetes API semantics can implement their own apiserver and use the aggregator to make it seamless for clients.

    ApiGroups Example List:

    apiVersion: alpha/v1alpha1
    apiVersion: batch/v1beta1
    apiVersion: api
    apiVersion: apps/v1
    apiVersion: autoscaling/v1
    apiVersion: apiextensions.k8s.io/v1beta1
    apiVersion: rbac.authorization.k8s.io/v1

    同一资源 可能会同时存在不同的 `ApiGroup/ApiVersion` 内，不同路径下的 同一 资源的行为可能是不同的。

    更多 Kubernetes Api 内容见: https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.9/

    Enabling API groups

        --runtime-config=batch/v1=false,batch/v2alpha1

    Enabling resources in the groups

        --runtime-config=extensions/v1beta1/deployments=false,extensions/v1beta1/jobs=false

Resource Categories
Resource Objects
Resource Operations

## Working with Kubernetes Objects

https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.9

### Understanding Kubernetes Objects

https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/

```yaml
apiVersion:
kind:
metadata:

spec:
```

### Names

https://kubernetes.io/docs/concepts/overview/working-with-objects/names/

所有的 Kubernete Api Object 都有一个 Name 和 UID 标识。

对于不唯一的、用户提供的属性，Kubernetes 提供 了 `Labels` 和 `Annotations`

它是由客户端（用户）提供的用于在资源URL中引用一个资源对象的字符串，例如：`/api/v1/pods/some-name`

一个给定类型Kind的对象一次只能拥有一个名称Name，如果对象被删除，该名称可以用在新对象上。

按照惯例，Kubernetes资源的名字最长不应该超过253个字符，由小写 `字母、数字、-、.` 组成，但是某些资源有更多的具体限制。

Kubernete系统生成一个字符串来唯一标识一个 Objects，即 UID

在 Kubernetes 集群的整个生命周期中创建的每个对象都有一个不同的UID。它旨在时间尺度上区分类似实体。

### Namespaces

API：/apis/{ApiGroup}/{ApiVersion}/namespaces/{namespace}/objects/{object}
API：/apis/batch/v1beta1/namespaces/{namespace}/cronjobs/{name}/status

https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
https://kubernetes.io/docs/tasks/administer-cluster/namespaces/
https://kubernetes.io/docs/tasks/administer-cluster/namespaces-walkthrough/

Kubernetes 支持在同一集群之上虚拟多个集群。虚拟集群称为 `namespace`，也就是命名空间，对资源、权限等进行隔离。

Namespace 旨在用于多用户分散在多个组或多个项目的环境中。如果只有10个以内的用户时，可以不需要考虑 Namespace 相关的问题。只在需要 Namespace 提供的功能的时候才使用。

命名空间为名称提供了一个作用域。资源的名称在名称空间中需要是唯一的，但是在不同的命名空间可以相同。

命名空间是一种在多个用户之间划分群集资源的方法。

在将来的Kubernetes版本中，默认情况下，同一名称空间中的对象将具有相同的访问控制策略。

没有必要使用多个名称空间来分隔稍微不同的资源，例如相同软件的不同版本：使用标签区分同一名称空间内的资源。

kubectl get namespaces
kubectl get namespaces <name>
kubectl describe namespaces <name>

```yaml
# my-namespace.yml
apiVersion: v1
kind: Namespace
metadata:
  name: <insert-namespace-name-here>
```

kubectl create -f ./my-namespace.yaml

kubectl delete namespaces <insert-some-namespace-name>

操作某一 命名空间 下的资源

```sh
$ kubectl --namespace=<insert-namespace-name-here> run nginx --image=nginx
$ kubectl --namespace=<insert-namespace-name-here> get pods
```

设置上下文中的命名空间

```sh
$ kubectl config set-context $(kubectl config current-context) --namespace=<insert-namespace-name-here>
# Validate it
$ kubectl config view | grep namespace:
```

Namespaces and DNS

当创建一个 Service 的时候，会创建一个与之关联的 DNS entry，entry 的形式是：`<service-name>.<namespace-name>.svc.cluster.local`，所以这就意味着，一个容器仅仅是使用 `<service-name>`，将会被解析到 某一  namespace 下的 service，这对于使用相同配置 Development, Staging and Production 跨多个命名空间时非常有用。如果想要跨命名空间访问，需要使用 全限定域名FQDN（fully qualified domain name）。

Not All Objects are in a Namespace

大部分资源都在命名空间中，然后 Namespace 本身并不在命名空间中，低级的资源如 Nodes、persistentVolumes 也不在命名空间中。Events 是一个例外，它可能在也可能不在命名空间中，取决于是关于什么的 Events。

动机

单个集群应该能够满足多个用户或用户组（以下称为“用户社区”）的需求。

Kubernetes命名空间可以帮助不同的项目、团队或客户共享一个Kubernetes集群。

### Labels & Selectors

Labels 是 Objects 的属性，以 `key/value` 形式存在。

Labels 旨在用于指定 与用户相关的、有意义的 Objects 的标识属性，但并不直接暗示核心系统的语义。

Labels 可用于组织和选择对象的子集。

Labels 可以被绑定到对象上在创建的时候，也可以在之后任意时刻添加和修改。

Labels 的 Key 不能相同。

```json
"labels": {
  "key1" : "value1",
  "key2" : "value2"
}
```

我们最终将索引和反向索引标签用于高效的查询和监视，使用它们在UI和CLI中进行排序和分组等。

我们不想污染具有非识别性，尤其是大型和/或结构化数据的标签。非识别信息应使用 Annotations 记录。

1. Motivation

2. Syntax and character set

3. Label selectors

### Annotations

https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/

Annotations 可以将元数据附加到Kubernetes对象。

相比 Labels，Annotations不用于标识和选择对象。

Annotations 中的元数据可以是small或large，structured或unstructured，并且可以包括标签不允许使用的字符。

```json
"annotations": {
  "key1" : "value1",
  "key2" : "value2"
}
```

### Well-Known Labels, Annotations and Taints

https://kubernetes.io/docs/reference/labels-annotations-taints/

beta.kubernetes.io/arch=amd64
beta.kubernetes.io/os=linux
kubernetes.io/hostname=ip-172-20-114-199.ec2.internal
beta.kubernetes.io/instance-type=m3.medium
failure-domain.beta.kubernetes.io/region=us-east-1


## Object Management Using kubectl

https://kubernetes.io/docs/concepts/overview/object-management-kubectl/overview/

### Kubernetes Object Management

### Imperative commands

当使用 执行命令 的方式时，用户操作直接应用于集群中的在线对象。

用户提供 kubectl 执行相关操作需要的 参数 和 标识。这是最简单的执行命令的方式，运行一次性的命令，这种方式适合用在开发环境中。

```sh
kubectl run nginx --image nginx
kubectl create deployment nginx --image nginx
```

### Imperative object configuration

使用 执行对象配置 方式时，kubectl 命令 指定 操作 可选标识 至少 一个文件名，文件中包括对象完整的定义，文件格式：yaml、json。

```sh
kubectl create -f nginx.yaml
kubectl delete -f nginx.yaml -f redis.yaml
```

### Declarative object configuration

## Resource

### Workloads

#### Pods

https://jimmysong.io/kubernetes-handbook/cloud-native/kubernetes-and-cloud-native-app-overview.html

http://dockone.io/article/932

https://www.hi-linux.com/posts/3592.html

Understanding Pods

Pod是Kubernetes的最基本组成部分，是Kubernetes对象模型中最小的可创建的部署单元。Pod代表集群中一个运行的进程。

Pod封装了 应用程序容器（或者在某些情况下是多个容器），存储资源，一个唯一的网络IP，以及支配容器如何运行的选项。

Pod表示一个部署单元，Kubernetes中的应用程序的单个实例，可能由单个容器组成，也可能由少数 紧密耦合 且 共享资源 的容器组成。

Docker是最常见的容器运行时引擎，但是Pod也支持其他的容器引擎。

Kubernetes集群中的Pod可用于两种主要方式：

    * 运行一个容器的Pod
    * 运行多个需要协作的容器的Pod

每一Pod都意味着运行一个给定应用程序的实例。如果你需要水平扩展应用，那就需要使用多个Pods，每个实例一个。在Kubernetes中，这通常被称为 replication 。
Replicated Pods通常由一个称为Controller的抽象创建和管理。

Pod如何管理多个容器？

Pod的设计是为了支持多个相互协作的容器组成一个紧密结合的服务单元。Pod中的容器自动的协同定位或协同调度到同一台物理机或虚拟机上。他们能够共享资源和依赖，相互通信，并协调何时以及如何终止。

Note：组合多个容器到一个Pod中相对来说是一种高级的用例。应该仅在特定的机密耦合的实例使用这种模式。例如，你有一个容器用作文件服务的WebServer，一个分离的sidecar容器从上游的源更新文件。

Networking

每个Pod都被分配一个唯一的IP地址，Pod中的容器共享同一个网络命名空间，包括IP地址和端口号。Pod中的容器可以通过 `localhost` 进行通信。当Pod中的容器需要与外部的容器需要相互通信的时候，他们必须协调如何使用共享网络资源，如端口号。

Storage

Pod可以指定一组共享存储卷，Pod中的所有容器都可以访问共享卷，允许这些容器共享数据。数据卷允许持久化数据在容器需要重启的情况下保持存在。可以查看Volumes有关的内容了解更多信息。

Working with Pods

很少直接在Kubernetes中创建Pod，即使是单实例的Pod也是如此。这是因为Pod设计为相对短暂的一次性实体。在创建Pod时（直接由您或由Controller间接创建），它将被调度到集群中的某个节点上运行。Pod保持在该节点上运行，直到进程终止，Pod对象被删除，Pod由于缺乏资源而被驱逐，或者Node失败。

Note：重新启动Pod中的容器不应与重新启动Pod混淆。 Pod本身不运行，但它是容器运行的环境，并一直存在直到它被删除。

Pod Templates
定义：[Pod](./pod.yaml)

---

Pod 构成

Pod由一个或多个容器组成，这些容器共享存储和网络，以及如何运行容器的规范。

Pod中的容器总是共同定位和共同调度，并且共享相同的上下文。

Pod构建了一个特定于应用程序的“逻辑主机”模型 - 它包含一个或多个相对紧密耦合的应用程序容器 - 在容器之前的世界中，它们将在相同的物理或虚拟机器上执行。

Kubernetes支持多个容器运行时，Docker是最广为人知的运行时。

Pod的共享上下文是一组 Linux 命名空间，

Pod 由一个叫 `pause` 的根容器，加上一个或多个用户自定义的容器构造。
pause的状态带便了这一组容器的状态，pod里多个业务容器共享pod的Ip和数据卷。

在Kubernetes中，Pod是容器的载体，所有的容器都在Pod中被管理，一个容器或多个容器放在一个Pod中作为一个单元的整体。

同时，Pod也作为一层中间层存在，方便支持其他容器引擎的容器管理。而Kubernetes管理好Pod即可，无需关系底层容易细节。

[Kubernetes之Pause容器](https://o-my-chenjian.com/2017/10/17/The-Pause-Container-Of-Kubernetes/)
[Kubernetes之“暂停”容器](http://dockone.io/article/2785)
[The Almighty Pause Container](https://www.ianlewis.org/en/almighty-pause-container)
[docker 容器的网络模式](http://cizixs.com/2016/06/12/docker-network-modes-explained)
[man pause](https://linux.die.net/man/2/pause)
[image pause.c](https://github.com/kubernetes/kubernetes/blob/master/build/pause/pause.c)

Pod调度

Pod特征

Pod增删改查

静态Pod

生命周期

pod一共有四种状态

Status|Description
------|------------
Pending| APIserver已经创建该server,但pod内有一个或多个容器的镜像还未创建，可能在下载中。
Running| Pod内所有的容器已创建，且至少有一个容器处于运行状态，正在启动或重启状态
Failed | Pod内所有容器都已退出，其中至少有一个容器退出失败
Unknown| 由于某种原因无法获取Pod的状态比如网络不通。

重启策略

Pod的重启策略应用于Pod内的所有容器，由Pod所在Node节点上的Kubelet进行判断和重启操作。

重启策略 | 描述
--------|-----
Always      | 容器失效时，即重启
OnFailure   | 容器终止运行，且退出码不为0 时重启
Never       | 不重启

探测

Kubernetes内部通过2种探针，实现了对Pod健康的检查

    * LivenessProbe探针：判断容器是否存活（running）
    * ReadinessProbe探针： 用于判断容器是否启动完成（ready）

LivenessProbe探针通过三种方式来检查容器是否健康

（1）ExecAction:在容器内部执行一个命令，如果返回码为0，则表示健康
（2）TcpAction:通过IP 和port ,如果能够和容器建立连接则表示容器健康
（3）HttpGetAction:发送一个http Get请求（ip+port+请求路径）如果返回状态吗在200-400之间则表示健康

PodStatus
ContainerStatus

InitContainers

Pod可以有多个运行的容器，也可以有一个或多个在 AppContainers 之前运行的 InitContainers

InitContainers和普通容器一样，除了：

    总是运行到完成
    每一个都必须在下一个开始之前成功完成

如果Pod的 InitContainer 失败，则Kubernetes会反复重新启动Pod，直到Init Container成功。但是，如果Pod具有Never的restartPolicy，则不会重新启动。

```
spec.initContainers
status.initContainerStatuses
```

与AppContainer区别：

InjectDataIntoPod

PodPreset

https://kubernetes.io/docs/tasks/inject-data-application/podpreset/

调度策略

扩容和缩容

滚动升级

Stateless Applications Example
Stateful Applications Example

ReplicationController & ReplicationSet

CURD

Controllers

    ReplicationController
    ReplicaSet
    Deploments
    StatefulSets
    DaemonSet
    GarbageCollection
    Jobs
    CronJob

ConfigMaps

Secrets

### Services & LB & Networking

Services

Defining a service

Virtual IPs and service proxies

Proxy-mode: userspace

kube-proxy 监视 Service and Endpoints 的创建和移除，对于每一个 Service，他都会在 本地Node 上打开一个端口（随机选择），任何访问这个端口的请求都会被代理到 Service 后面的 Pod。哪个Pod被选择依据 Service 的 SessionAffinity。最后，它安装iptables规则，该规则捕获服务的clusterIP（虚拟的）和Port的流量转发到 kube-proxy 在本地打开的端口上，由 kube-proxy 将该流量重定向到代理后端Pod的代理端口。

Proxy-mode: iptables

kube-proxy 监视 Service and Endpoints 的创建和移除，对于每一个 Service，他都会安装 iptables 规则，该规则捕获服务的clusterIP（虚拟的）和Port的流量然后直接转发到对应的Service 后面的 Pod，默认情况下，Pod是随机选择的。

显然，iptables不需要在用户空间和内核空间切换，它应该比用户空间代理更快，更可靠。但是，与用户空间代理不同，iptables不能自动重试另一个Pod连接如果iptables最初选择的Pod不响应，因此它依赖于正在工作的 准备就绪探测器。

Proxy-mode: ipvs

kube-proxy 监视 Service and Endpoints，调用 netlink 接口来相应地创建ipvs规则，并定期与Kubernetes Services和Endpoints同步ipvs规则，以确保ipvs状态符合预期。当访问服务时，流量将被重定向到其中一个后端Pod。
与iptables类似，Ipvs基于netfilter钩子函数，但使用散列表作为基础数据结构并在内核空间中工作。这意味着ipvs可以更快地重定向流量，并且在同步代理规则时具有更好的性能。此外，ipvs为负载平衡算法提供了更多选项。

Note：在运行kube-proxy之前，ipvs模式假定在节点上安装了IPVS内核模块。当kube-proxy以ipvs代理模式启动时，kube-proxy会验证节点上是否安装了IPVS模块，如果未安装，kube-proxy将回退到iptables代理模式。

在任何这些代理模型中，服务的IP:PORT绑定的任何流量都会代理到适当的后端，而客户端不知道任何关于Kubernetes或服务或Pod的信息。

Multi-Port Services

许多服务支持暴露多个端口，Kubernetes支持在Service中定义多个端口

Choosing your own IP address

可以自定义一个ClusterIP

Discovering services

Headless services

Publishing services - service types

### Storage

http://cdn.opensourcecloud.cn/zt/k8s/03.pdf

Valumes
Persistent Volumes
Storage Classes
Dynamic Volume Provisioning

### Configuration

ConfigMap
Secrets

## kubectl

JSONPath XPath


http://shiyanjun.cn/archives/1671.html
