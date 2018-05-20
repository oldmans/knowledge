# K8S

## Vagrant + Ansible

wget https://github.com/kubernetes/kubernetes/releases/download/v1.8.0/kubernetes.tar.gz

https://github.com/shadowsocks/shadowsocks-libev

http://www.sundabao.com/ubuntu使用shadowsocks/

[配置 APT-GET 使用 SOCKS 代理](http://www.huangwenchao.com.cn/2015/08/tsocks-apt-get-agent.html)

https://github.com/haad/proxychains
https://github.com/rofl0r/proxychains-ng


[使用kubeadm安装Kubernetes 1.8](https://blog.frognew.com/2017/09/kubeadm-install-kubernetes-1.8.html)


```sh
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:max-c-lv/shadowsocks-libev -y
sudo apt-get update
sudo apt install shadowsocks-libev

sudo add-apt-repository ppa:hda-me/proxychains-ng
sudo apt-get update
apt-get install proxychains-ng
# apt install proxychains
apt-get install tsocks
apt-get install privoxy

export DOCKER_CE_REPO=mirrors.ustc.edu.cn/docker-ce
apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL ${DOCKER_CE_REPO}/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
   "deb ${DOCKER_CE_REPO}/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable"
apt-get update && apt-get install -y docker-ce=$(apt-cache madison docker-ce | grep 17.03 | head -1 | awk '{print $3}')

sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://ytts598n.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl kubernetes-cni

apt install golang-go
go get github.com/kubernetes-incubator/cri-tools/cmd/crictl
```

systemctl enable docker.service
systemctl enable kubelet.service

hostname ubuntu-xenial
hostname k8s-master

Environment="HTTP_PROXY=socks5://127.0.0.1:1080/" "HTTPS_PROXY=socks5://127.0.0.1:1080/" "NO_PROXY=localhost,127.0.0.1,docker.io,*.aliyuncs.com,*.mirror.aliyuncs.com,registry.docker-cn.com,hub.c.163.com,hub-auth.c.163.com,"

# [kube-dns ContainerCreating /run/flannel/subnet.env no such file #36575](https://github.com/kubernetes/kubernetes/issues/36575)

export KUBE_IP="$(ip -4 addr show enp0s8 | grep "inet" | head -1 |awk '{print $2}' | cut -d/ -f1)"
sudo sed -e "s/^.*master.*/${KUBE_IP} master master.local/" -i /etc/hosts
sudo sed -e '/^.*ubuntu-xenial.*/d' -i /etc/hosts
# sudo sed -i -e 's/AUTHZ_ARGS=.*/AUTHZ_ARGS="/' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

kubelet fails with error "misconfiguration: kubelet cgroup driver: "cgroupfs" is different from docker cgroup driver: "systemd" #43805

systemctl enable docker.service

sudo systemctl daemon-reload

sudo kubeadm init --apiserver-advertise-address=${KUBE_IP} --token=b9e6bb.6746bcc9f8ef8267

kubeadm init --config=kubeadm-init-config.yml
kubeadm init --kubernetes-version=1.9.0 --pod-network-cidr=10.244.0.0/16

# Unable to update cni config: No networks found in /etc/cni/net.d
kubectl apply -f kube-flannel.yml

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl taint nodes --all node-role.kubernetes.io/master-

kubectl get pods --all-namespaces -o wide

kubectl drain ubuntu-xenial --force --ignore-daemonsets --delete-local-data
kubectl delete nodes --all
kubeadm reset

kubectl proxy --accept-hosts='^*$' --address='0.0.0.0' --port=58080
kubectl proxy --accept-hosts='^*$' --address='0.0.0.0' --port=8001

[Kubernetes Dashboard中的身份认证详解](https://jimmysong.io/posts/kubernetes-dashboard-upgrade/)

kubeadm join --token fec452.d2b6633476b1e94a 10.0.2.15:6443 --discovery-file cluster-info.yaml

kubeadm join --token b9e6bb.6746bcc9f8ef8267 10.0.0.11:6443 --discovery-token-ca-cert-hash sha256:05f6e866b62193a209a70184746f4861db6b2873f5f035e81155a356322e55d3 --node-name=k8s-node-1

kubeadm join --token b9e6bb.6746bcc9f8ef8267 10.0.0.11:6443 --discovery-token-ca-cert-hash sha256:a262821f8136bf927d31f8bc9117f1f55a57d8926736f1715a0e0c24245953ba --node-name=k8s-node-1 10.0.1.1

kubectl expose pod kube-apiserver-ubuntu-xenial --port=56443 --name=kube-apiserver-expose-service

[root@k8s k8s]# kubeadm token create --print-join-command
kubeadm join --token fcac69.4cb58df26e2413bc 172.31.197.9:6443 --discovery-token-ca-cert-hash sha256:dffc4dc69fa22820e874a5c597900b0d67ac0c1fce796f2128da173fed6ae75f

kubectl config --kubeconfig=kubecfg.yml set-cluster kubernetes --server=https://47.104.74.122:6443 --certificate-authority=fake-ca-file
kubectl config --kubeconfig=kubecfg.yml set-credentials kubernetes-admin@kubernetes --client-certificate=fake-cert-file --client-key=fake-key-seefile
kubectl config --kubeconfig=kubecfg.yml set-context kubernetes-admin --cluster=kubernetes --user=kubernetes-admin@kubernetes --namespace=kubernetes-system 
kubectl config --kubeconfig=kubecfg.yml view
kubectl config --kubeconfig=kubecfg.yml use-context kubernetes-admin

kubectl expose service kubernetes-dashboard --port=443 --target-port=8443 --name=kubernetes-dashboard-expose

### CLI

#### container

kubectl run
kubectl run-container

### Apply

kubectl apply -f FILENAME

#### config

kubectl convert -f FILENAME
kubectl set SUBCOMMAND

#### resource

kubectl get
kubectl create -f FILENAME
kubectl delete ([-f FILENAME] | TYPE [(NAME | -l label | --all)])
kubectl edit (RESOURCE/NAME | -f FILENAME)
kubectl patch (-f FILENAME | TYPE NAME) -p PATCH
kubectl replace -f FILENAME
kubectl annotate

kubectl rolling-update OLD_CONTROLLER_NAME ([NEW_CONTROLLER_NAME] --image=NEW_CONTAINER_IMAGE | -f NEW_CONTROLLER_SPEC)

kubectl rollout SUBCOMMAND

kubectl scale [--resource-version=version] [--current-replicas=count] --replicas=COUNT (-f FILENAME | TYPE NAME)
kubectl autoscale (-f FILENAME | TYPE NAME | TYPE/NAME) [--min=MINPODS] --max=MAXPODS [--cpu-percent=CPU] [flags]

kubectl label [--overwrite] (-f FILENAME | TYPE NAME) KEY_1=VAL_1 ... KEY_N=VAL_N [--resource-version=version]

kubectl describe (-f FILENAME | TYPE [NAME_PREFIX | -l label] | TYPE/NAME)

#### service

kubectl expose

#### WORKING WITH APPS

kubectl auth

kubectl attach (POD | TYPE/NAME) -c CONTAINER
kubectl cp <file-spec-src> <file-spec-dest>
kubectl exec POD [-c CONTAINER] -- COMMAND [args...]
kubectl logs [-f] [-p] (POD | TYPE/NAME) [-c CONTAINER]
kubectl port-forward POD [LOCAL_PORT:]REMOTE_PORT [...[LOCAL_PORT_N:]REMOTE_PORT_N]
kubectl top


### Kube Cluster Manage

kubectl proxy [--port=PORT] [--www=static-dir] [--www-prefix=prefix] [--api-prefix=prefix]

kubectl api-versions
kubectl certificate SUBCOMMAND
kubectl cluster-info
kubectl cordon NODE
kubectl uncordon NODE
kubectl drain NODE
kubectl taint NODE NAME KEY_1=VAL_1:TAINT_EFFECT_1 ... KEY_N=VAL_N:TAINT_EFFECT_N

### kubectl

kubectl alpha
kubectl version
kubectl explain
kubectl options
kubectl completion SHELL
kubectl config SUBCOMMAND
kubectl plugin NAME



http://cizixs.com/2017/06/16/kubernetes-authentication-and-authorization

https://ieevee.com/tech/2017/01/20/k8s-service.html
https://ieevee.com/tech/2017/09/18/k8s-svc-src.html
https://ieevee.com/tech/2017/11/04/k8s-flannel-src.html
https://ieevee.com/tech/2017/10/19/ssh-over-socks5.html


https://en.wikipedia.org/wiki/IP_Virtual_Server


https://www.cnblogs.com/zhenyuyaodidiao/p/6500720.html

