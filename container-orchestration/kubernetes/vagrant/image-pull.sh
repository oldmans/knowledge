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

images=(
  kube-apiserver-amd64:${KUBE_VERSION}
  kube-controller-manager-amd64:${KUBE_VERSION}
  kube-scheduler-amd64:${KUBE_VERSION}
  kube-proxy-amd64:${KUBE_VERSION}

  etcd-amd64:${ETCD_VERSION}
  pause-amd64:${PAUSE_VERSION}

  k8s-dns-sidecar-amd64:${DNS_VERSION}
  k8s-dns-kube-dns-amd64:${DNS_VERSION}
  k8s-dns-dnsmasq-nanny-amd64:${DNS_VERSION}

  kubernetes-dashboard-amd64:${KUBE_DASHBOARD_VERSION}
)

for image in ${images[@]} ; do
  docker pull ${ALIYUN_k8s_gcr_URL}/${image}

  docker tag ${ALIYUN_k8s_gcr_URL}/${image} ${GCR_URL}/${image}
done
