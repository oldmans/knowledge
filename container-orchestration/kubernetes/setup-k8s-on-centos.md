# Setup-k8s-on-centos

## install deps

yum install git gcc gettext autoconf libtool automake make cmake pcre-devel asciidoc xmlto c-ares-devel libev-devel libsodium-devel mbedtls-devel -y

## install shadowsocks-libev

yum install epel-release -y

curl https://copr.fedorainfracloud.org/coprs/librehat/shadowsocks/repo/epel-7/librehat-shadowsocks-epel-7.repo > /etc/yum.repos.d/librehat-shadowsocks-epel-7.repo

yum install shadowsocks-libev

yum install rng-tools
systemctl start rngd

yum install virtio-rng

ln -s /usr/lib64libmbedcrypto.so.1 /usr/lib64libmbedcrypto.so.0

ss-local -c

systemctl enable --now shadowsocks-libev-local
systemctl status shadowsocks-libev-local
journalctl -u shadowsocks-libev-local

```
error while loading shared libraries: libmbedcrypto.so.0
https://github.com/shadowsocks/shadowsocks-libev/issues/1966
```

start service

## install proxychain-ng

```sh
git clone https://github.com/rofl0r/proxychains-ng \
  && cd proxychains-ng \
  && ./configure --prefix=/usr --sysconfdir=/etc \
  && make && make install && make install-config \
  && cd .. && rm -rf proxychains-ng
```

echo "socks5 127.0.0.1 1080" >> /etc/proxychains.conf
echo "socks5 172.31.197.9 1080" >> /etc/proxychains.conf

proxychains4 curl goolge.com

or
yum install tsocks
yum install privoxy

[root@log ~]# nslookup github.global.ssl.fastly.Net
Server:		10.143.22.118
Address:	10.143.22.118#53

Non-authoritative answer:
Name:	github.global.ssl.fastly.Net
Address: 151.101.73.194

151.101.73.194 github.global.ssl.fastly.Net

## set proxy

http://www.linuxdiyf.com/linux/27927.html

vim ~/.bashrc

export http_proxy=http://127.0.0.1:1080/
export https_proxy=http://127.0.0.1:1080/
export all_proxy=socks5://127.0.0.1:1080/
export no_proxy=.aliyuncs.com,.docker.com,.fedoraproject.org

source ~/.bashrc

vim /etc/yum.conf
proxy=http://127.0.0.1:1080/

## install docker

sudo yum remove docker docker-common docker-selinux docker-engine

sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce

sudo systemctl start docker

systemctl enable docker.service

### config docker registry-mirrors and proxy

https://docs.docker.com/config/daemon/systemd/#httphttps-proxy
http://blog.yanzhe.tk/2017/11/09/docker-set-proxy/

sudo mkdir -p /etc/systemd/system/docker.service.d

sudo tee /etc/systemd/system/docker.service.d/http-proxy.conf <<-'EOF'
[Service]
Environment="HTTP_PROXY=http://172.31.197.9:1080/" "HTTPS_PROXY=https://172.31.197.9:1080/" "NO_PROXY=localhost,127.0.0.1,docker.io,*.aliyuncs.com,*.mirror.aliyuncs.com,registry.docker-cn.com,hub.c.163.com,hub-auth.c.163.com"
EOF

sudo mkdir -p /etc/docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "registry-mirrors": ["https://ytts598n.mirror.aliyuncs.com"]
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker

## install kubernetes

yum install -y socat

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
setenforce 0
yum install -y socat
yum install -y kubelet kubeadm kubectl

systemctl start kubelet
systemctl enable kubelet.service

cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

cat <<EOF > kubeadm-init-config.yml
apiVersion: kubeadm.k8s.io/v1alpha1
kind: MasterConfiguration
api:
  # advertiseAddress: 10.0.0.11
  # advertiseAddress: 192.168.3.101
  bindPort: 6443
etcd:
  image: registry.cn-hangzhou.aliyuncs.com/kubernetes-containers/etcd-amd64:latest
#   endpoints:
#   - <endpoint1|string>
#   - <endpoint2|string>
#   caFile: <path|string>
#   certFile: <path|string>
#   keyFile: <path|string>
#   dataDir: <path|string>
#   extraArgs:
#     <argument>: <value|string>
#     <argument>: <value|string>
networking:
#   dnsDomain: <string>
#   serviceSubnet: <cidr>
  podSubnet: "10.244.0.0/16"
kubernetesVersion: 1.9.0
# cloudProvider: <string>
# nodeName: k8s-master
# authorizationModes:
# - <authorizationMode1|string>
# - <authorizationMode2|string>
token: b9e6bb.6746bcc9f8ef8267
# tokenTTL: 0
# selfHosted: <bool>
# apiServerExtraArgs:
#   <argument>: <value|string>
#   <argument>: <value|string>
# controllerManagerExtraArgs:
#   <argument>: <value|string>
#   <argument>: <value|string>
# schedulerExtraArgs:
#   <argument>: <value|string>
#   <argument>: <value|string>
# apiServerExtraVolumes:
# - name: <value|string>
#   hostPath: <value|string>
#   mountPath: <value|string>
# controllerManagerExtraVolumes:
# - name: <value|string>
#   hostPath: <value|string>
#   mountPath: <value|string>
# schedulerExtraVolumes:
# - name: <value|string>
#   hostPath: <value|string>
#   mountPath: <value|string>
# apiServerCertSANs:
# - <name1|string>
# - <name2|string>
# certificatesDir: <string>
imageRepository: registry.cn-hangzhou.aliyuncs.com/kubernetes-containers
# unifiedControlPlaneImage: <string>
featureGates:
  SelfHosting: true
  StoreCertsInSecrets: true
  # CoreDNS: true
EOF

### view

```sh
➜  ~ cat /etc/systemd/system/kubelet.service
[Unit]
Description=kubelet: The Kubernetes Node Agent
Documentation=http://kubernetes.io/docs/

[Service]
ExecStart=/usr/bin/kubelet
Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```sh
➜  ~ cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_SYSTEM_PODS_ARGS=--pod-manifest-path=/etc/kubernetes/manifests --allow-privileged=true"
Environment="KUBELET_NETWORK_ARGS=--network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin"
Environment="KUBELET_DNS_ARGS=--cluster-dns=10.96.0.10 --cluster-domain=cluster.local"
Environment="KUBELET_AUTHZ_ARGS=--authorization-mode=Webhook --client-ca-file=/etc/kubernetes/pki/ca.crt"
Environment="KUBELET_CADVISOR_ARGS=--cadvisor-port=0"
Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=systemd"
Environment="KUBELET_CERTIFICATE_ARGS=--rotate-certificates=true --cert-dir=/var/lib/kubelet/pki"
ExecStart=
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_SYSTEM_PODS_ARGS $KUBELET_NETWORK_ARGS $KUBELET_DNS_ARGS $KUBELET_AUTHZ_ARGS $KUBELET_CADVISOR_ARGS $KUBELET_CGROUP_ARGS $KUBELET_CERTIFICATE_ARGS $KUBELET_EXTRA_ARGS
```

```sh
➜  ~ systemctl cat kubelet
# /etc/systemd/system/kubelet.service
[Unit]
Description=kubelet: The Kubernetes Node Agent
Documentation=http://kubernetes.io/docs/

[Service]
ExecStart=/usr/bin/kubelet
Restart=always
StartLimitInterval=0
RestartSec=10

[Install]
WantedBy=multi-user.target

# /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_SYSTEM_PODS_ARGS=--pod-manifest-path=/etc/kubernetes/manifests --allow-privileged=true"
Environment="KUBELET_NETWORK_ARGS=--network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin"
Environment="KUBELET_DNS_ARGS=--cluster-dns=10.96.0.10 --cluster-domain=cluster.local"
Environment="KUBELET_AUTHZ_ARGS=--authorization-mode=Webhook --client-ca-file=/etc/kubernetes/pki/ca.crt"
Environment="KUBELET_CADVISOR_ARGS=--cadvisor-port=0"
Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=systemd"
Environment="KUBELET_CERTIFICATE_ARGS=--rotate-certificates=true --cert-dir=/var/lib/kubelet/pki"
ExecStart=
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_SYSTEM_PODS_ARGS $KUBELET_NETWORK_ARGS $KUBELET_DNS_ARGS $KUBELET_AUTHZ_ARGS $KUBELET_CADVISOR_ARGS $KUBELET_CGROUP_ARGS $KUBELET_CERTIFICATE_ARGS $KUBELET_EXTRA_ARGS
```

```sh
➜  ~ tree /etc/kubernetes
/etc/kubernetes
|-- admin.conf
|-- admin-user.yaml
|-- controller-manager.conf
|-- scheduler.conf
|-- kubelet.conf
|-- manifests
|   |-- etcd.yaml
|   |-- kube-apiserver.yaml
|   |-- kube-controller-manager.yaml
|   `-- kube-scheduler.yaml
|-- pki
|   |-- apiserver.crt
|   |-- apiserver.key
|   |-- apiserver-kubelet-client.crt
|   |-- apiserver-kubelet-client.key
|   |-- ca.crt
|   |-- ca.key
|   |-- front-proxy-ca.crt
|   |-- front-proxy-ca.key
|   |-- front-proxy-client.crt
|   |-- front-proxy-client.key
|   |-- sa.key
|   `-- sa.pub
```

```sh
➜  ~ systemctl status kubelet
● kubelet.service - kubelet: The Kubernetes Node Agent
   Loaded: loaded (/etc/systemd/system/kubelet.service; enabled; vendor preset: disabled)
  Drop-In: /etc/systemd/system/kubelet.service.d
           └─10-kubeadm.conf
   Active: active (running) since Tue 2018-02-27 11:15:22 CST; 5 days ago
     Docs: http://kubernetes.io/docs/
 Main PID: 13829 (kubelet)
   CGroup: /system.slice/kubelet.service
           └─13829 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --pod-manifest-path=/etc/kubernetes/manifests --allow-privileged=true --network-plugin=cni --cn...
```

## GCR镜像问题
