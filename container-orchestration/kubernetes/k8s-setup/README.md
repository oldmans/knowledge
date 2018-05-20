# k8s-setup

以下内容对应官方文档：[https://kubernetes.io/docs/setup/]，结构上尽量与官方文档保持一致。文档相当于对官方文档的注解。

## Picking the Right Solution

k8s 安装有多种方案可以选择，需要根据使用目的以及具备条件进行选择

### Local-machine Solutions

1. `Minikube is the recommended method for creating a local, single-node Kubernetes cluster for development and testing. Setup is completely automated and doesn’t require a cloud provider account.`

    `Minikube` 是创建一个本地的、单一节点的、用来开发和测试的集群的推荐方式，这种方式完全实现了安装部署的自动化进行，并且不需要云供应商账户。
    
    这种方式是 k8s 初学者必须首选的方式，他能快速的在本地搭建起 k8s 环境，轻量、便捷。极大的节省了配置部署时间，可以使初学者尽快开始学习使用 k8s，而不是如何配置部署 k8s，因为学习使用才是绝大部分学习 k8s  人员的第一目标。
    
    通过 minikube，可以快速的解除到 k8s，并在上面进行实验性质的应用部署，了解其应用编排的配置写法、各种概念，以及一部分工作原理，同时也了解到 k8s 的各种组成部分以及他们之间的关系，这为真正的自定义 k8s 集 群奠定了基础。

2. `Ubuntu on LXD supports a nine-instance deployment on localhost.`

    这种方式由 ubuntu 提供的部署方式，支持本地部署和常用公有云部署，它不仅提供自动化的部署流程，还提供了 k8s 应用管理工具的安装，可以快速部署 k8s 应用。值得注意的是，该方式使用 LXC 容器技术，而不是 Docker。
    该方式 通过 `snap` 和 `conjure-up` 快速安装部署 k8s。

3. `IBM Cloud private-ce (Community Edition) can use VirtualBox on your machine to deploy Kubernetes to one or more VMs for dev and test scenarios. Scales to full multi-node cluster. Free version of the enterprise solution.`

### Hosted Solutions

在云主机上部署，各个云服务供应商提供了方便的工具来自定义 k8s 集群

### Turnkey Cloud Solutions

立即可以使用的云服务方案，该方案仅需要简单的几个步骤即可部署 k8s 集群，免去相当多的麻烦。

### Custom Solutions

k8s 可以运行在许多供应商的云服务环境 或者 裸机环境中，并且支持很多基础的操作系统。

如果你想手动部署 k8s，除非 你有特殊的需求 或者 仅仅想理解 k8s 集群底层机制，否则建议使用 k8s 提供的部署方案。

建议仔细阅读了解各个部署方式，了解各方案采用的技术方案。如果需要手工部署 k8s 集群，将从这些方案中获得很多启发。

#### [Installing Kubernetes On-premises/Cloud Providers with Kubespray](https://kubernetes.io/docs/getting-started-guides/kubespray/)

Kubespray 是一个由 Ansible + Vagrant + kubeadm 实现的方案。

### Independent Solutions

#### Running Kubernetes Locally via Minikube

#### Bootstrapping Clusters with kubeadm

```sh
sysctl net.bridge.bridge-nf-call-iptables=1

apt install ebtables ethtool

apt-get update && apt-get install -y curl apt-transport-https
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/docker.list
deb https://download.docker.com/linux/$(lsb_release -si | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable
EOF
apt-get update && apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 17.03 | head -1 | awk '{print $3}')

apt-get update && apt-get install -y apt-transport-https
curl -s http://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
```

网络原因，无法访问google镜像库，安装过法进行

#### [Creating a Custom Cluster from Scratch](https://kubernetes.io/docs/getting-started-guides/scratch/)

https://kubernetes.io/docs/concepts/overview/components/

Master：

* etcd@docker
* kube-scheduler@docker
* kube-apiserver@docker
* kube-controller-manager@docker
* cloud-controller-manager@docker
* addons
* DNS
* Web UI (Dashboard)
* Container Resource Monitoring
* Cluster-level Logging

Node:

* kubelet
* kube-proxy
* docker || rkt
* supervisord
* fluentd

1. 下载kubernetes二进制文件

下载最新版本的二进制文件：https://github.com/kubernetes/kubernetes/releases/latest

```sh
wget https://github.com/kubernetes/kubernetes/releases/download/v1.8.0/kubernetes.tar.gz
tar -zxvf kubernetes.tar.gz
# 继续下载 ./kubernetes/server/kubernetes-server-linux-amd64.tar.gz 文件
./kubernetes/cluster/get-kube-binaries.sh
```

2. 安装docker

3. 安装etcd:3.0.17

```sh
ETCD_IMAGE=gcr.io/google_containers/etcd:3.0.17
ETCD_IMAGE=quay.io/coreos/etcd:3.0.17
docker pull ${ETCD_IMAGE}
```

docker run \
  -p 2379:2379 \
  -p 4001:4001 \
  --name etcd \
  -v /usr/share/ca-certificates/:/etc/ssl/certs \
  quay.io/coreos/etcd \
  -listen-client-urls http://0.0.0.0:2379,http://0.0.0.0:4001

4. load k8s docker images

```sh
find . -name "*.tar" | xargs -I {} -t docker load -i {}
```

Configuring and Installing Base Software on Nodes

配置

configure Docker for Kubernetes

```sh
iptables -t nat -F
ip link set docker0 down
ip link delete docker0
```

##### Configuring and Installing Base Software on Nodes

* kubelet

```sh
./kubelet --help
open https://kubernetes.io/docs/admin/kubelet/
```

```sh
export MASTER_IP=192.168.3.250
mkdir -p /var/lib/kubelet
mkdir -p /var/lib/kubelet/kubeconfig
mkdir -p /etc/kubernetes/manifests
hyperkube kubelet \
    # --api-servers=https://$MASTER_IP \
    --api-servers=http://${MASTER_IP} \
    --kubeconfig=/var/lib/kubelet/kubeconfig \
    --config=/etc/kubernetes/manifests \
    # --cluster-dns= \
    # --cluster-domain= \
    --root-dir=/var/lib/kubelet \
    --configure-cbr0=true \
    --register-node=true \
    --cloud-provider="" \
    --cloud-provider-gce-lb-src-cidrs="130.211.0.0/22,35.191.0.0/16,209.85.152.0/22,209.85.204.0/22"

hyperkube kubelet \
    --api-servers=http://${MASTER_IP} \
    --address=0.0.0.0 \
    --kubeconfig=/var/lib/kubelet/kubeconfig \
    --root-dir=/var/lib/kubelet \
    --register-node=true \
    --fail-swap-on=false \
    --cloud-provider="" 
```

http://www.cnblogs.com/chiwg/p/5009516.html

    误：KUBELET_PORT="--kubelet-port=10250"
    正：KUBELET_PORT="--kubelet_port=10250"
    误：KUBE_ETCD_SERVERS="--etcd-servers=http://centos-master:4001"
    正：KUBE_ETCD_SERVERS="--etcd_servers=http://centos-master:4001"
    误：KUBE_ALLOW_PRIV="--allow-privileged=false"
    正：KUBE_ALLOW_PRIV="--allow_privileged=false"
    误：KUBELET_HOSTNAME="--hostname-override=centos-minion172"
    正：KUBELET_HOSTNAME="--hostname_override=centos-minion172"
    误：KUBELET_API_SERVER="--api-servers=http://centos-master:8080"
    正：KUBELET_API_SERVER="--api_servers=http://centos-master:8080"


```sh
# configure-cbr0=false
ip link add name cbr0 type bridge
ip link set dev cbr0 mtu 1460
ip addr add $NODE_X_BRIDGE_ADDR dev cbr0
ip link set dev cbr0 up
```

* kube-proxy

```sh
kube-proxy \
    # --api-servers=https://$MASTER_IP \
    --api-servers=http://$MASTER_IP \
    --kubeconfig=/var/lib/kube-proxy/kubeconfig \
```

####
