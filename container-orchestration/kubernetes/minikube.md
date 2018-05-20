# Kubernetes

## Minikube

Minikube is a tool that makes it easy to run Kubernetes locally. Minikube runs a single-node Kubernetes cluster inside a VM on your laptop for users looking to try out Kubernetes or develop with it day-to-day.

### Install Minikube

### Usage

* minikube start
* minikube stop
* minikube delete
* minikube status
* minikube dashboard
* minikube ip
* minikube service
* minikube service list
* minikube docker-env
* minikube get-k8s-versions

Global Flags:
      --alsologtostderr                  log to standard error as well as files
      --log_backtrace_at traceLocation   when logging hits line file:N, emit a stack trace (default :0)
      --log_dir string                   If non-empty, write log files in this directory
      --logtostderr                      log to standard error instead of files
  -p, --profile string                   The name of the minikube VM being used.
	This can be modified to allow for multiple minikube instances to be run independently (default "minikube")
      --show-libmachine-logs             Deprecated: To enable libmachine logs, set --v=3 or higher
      --stderrthreshold severity         logs at or above this threshold go to stderr (default 2)
      --use-vendored-driver              Use the vendored in drivers instead of RPC
  -v, --v Level                          log level for V logs
      --vmodule moduleSpec               comma-separated list of pattern=N settings for file-filtered logging

```sh
minikube start \
    --kubernetes-version=v1.7.5 \
    --vm-driver=virtualbox \
    --container-runtime=docker \
    --cpus=2 \
    --extra-config=kubelet.MaxPods=5 \
    --extra-config=scheduler.LeaderElection.LeaderElect=true \
    --extra-config=apiserver.AuthorizationMode=RBAC \
    --docker-env HTTP_PROXY=http://$YOURPROXY:PORT \
    --docker-env HTTPS_PROXY=https://$YOURPROXY:PORT
```

### Kubectl Context

* kubectl config use-context minikube
* kubectl config use-context minikube
