#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

KUBE_VERSION=v1.9.1
KUBE_VERSION=v1.9.0
ETCD_VERSION=3.1.10
ETCD_VERSION=3.0.17
PAUSE_VERSION=3.1
PAUSE_VERSION=3.0
DNS_VERSION=1.14.7
KUBE_DASHBOARD_VERSION=v1.8.2

GCR_URL=gcr.io/google_containers
ALIYUN_k8s_gcr_URL=registry.cn-hangzhou.aliyuncs.com/k8s-gcr
ALIYUN_kube_containers_URL=registry.cn-hangzhou.aliyuncs.com/kube_containers
ALIYUN_kubernetes_containers_URL=registry.cn-hangzhou.aliyuncs.com/kubernetes-containers
ALIYUN_google_containers_URL=registry.cn-hangzhou.aliyuncs.com/google_containers

images=(
  $ALIYUN_kubernetes_containers_URL/kube-apiserver-amd64:${KUBE_VERSION}
  $ALIYUN_kubernetes_containers_URL/kube-controller-manager-amd64:${KUBE_VERSION}
  $ALIYUN_kubernetes_containers_URL/kube-scheduler-amd64:${KUBE_VERSION}
  $ALIYUN_kubernetes_containers_URL/kube-proxy-amd64:${KUBE_VERSION}

  ${ALIYUN_kube_containers_URL}/etcd-amd64:${ETCD_VERSION}
  ${ALIYUN_kube_containers_URL}/pause-amd64:${PAUSE_VERSION}

  $ALIYUN_kubernetes_containers_URL/k8s-dns-sidecar-amd64:${DNS_VERSION}
  $ALIYUN_kubernetes_containers_URL/k8s-dns-kube-dns-amd64:${DNS_VERSION}
  $ALIYUN_kubernetes_containers_URL/k8s-dns-dnsmasq-nanny-amd64:${DNS_VERSION}

  $ALIYUN_google_containers_URL/kubernetes-dashboard-amd64:${KUBE_DASHBOARD_VERSION}
)

for image in ${images[@]} ; do
  docker pull ${image}

  imagePath=${image/"registry.cn-hangzhou.aliyuncs.com"/""}
  
  imageName=${imagePath}
  imageName=${imageName/"/kubernetes-containers/"/""}
  imageName=${imageName/"/kube_containers/"/""}
  imageName=${imageName/"/google_containers/"/""}

  echo ${imageName}
  docker tag ${image} ${GCR_URL}/${imageName}
  docker tag ${image} ${ALIYUN_k8s_gcr_URL}/${imageName}

  docker login registry.cn-hangzhou.aliyuncs.com --username=469835132@qq.com --password=LYJ123@aliyun.com

  docker push $ALIYUN_k8s_gcr_URL/$imageName
  # docker rmi $ALIYUN_k8s_gcr_URL/$imageName
done
