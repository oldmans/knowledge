# Secrets

[Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
[Secrets design document](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/auth/secrets.md)
[Kubernetes中Secret使用详解](http://blog.csdn.net/yan234280533/article/details/77018640)

## Overview of Secrets

Secrets 目的是用来存放敏感信息，例如：password，OAuthTokens，and SSH keys。相比把这些信息放到Pod中，把这些信息放到 Secret 中更加安全灵活。

Secret解决了密码、token、密钥等敏感数据的配置问题，而不需要把这些敏感数据暴露到镜像或者Pod Spec中。Secret可以以Volume或者环境变量的方式使用。

用户和系统都可以创建Secret对象

为了使用Secret，Pod实例需要引用Secret，有两种使用方式：挂载一个文件到容器当中，或者当kubelet pull image是使用。


## Built-in Secrets

### Service Accounts Automatically Create and Attach Secrets with API Credentials

## Creating your own Secrets

### Creating a Secret Using kubectl create secret

```sh
# Create files needed for rest of example.
echo -n "admin" > ./username.txt
echo -n "1f2d1e2e67df" > ./password.txt
kubectl create secret generic db-user-pass --from-file=./username.txt --from-file=./password.txt
secret "db-user-pass" created

kubectl create secret --help

# List secrets
[root@k8s secrets]# kubectl get secrets
NAME                  TYPE                                  DATA      AGE
db-user-pass          Opaque                                2         46s
default-token-vmsbg   kubernetes.io/service-account-token   3         20h

# Describe secrets
[root@k8s secrets]# kubectl describe secrets/db-user-pass
Name:         db-user-pass
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
password.txt:  12 bytes
username.txt:  5 bytes
```

### Creating a Secret Manually

```sh
$ echo -n "admin" | base64
YWRtaW4=
$ echo -n "1f2d1e2e67df" | base64
MWYyZDFlMmU2N2Rm
```

```sh
[root@k8s secrets]# cat secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  username: YWRtaW4=
  password: MWYyZDFlMmU2N2Rm
```

$ kubectl create -f ./secret.yaml
secret "mysecret" created

### Decoding a Secret

```sh
$ kubectl get secret mysecret -o yaml
apiVersion: v1
data:
  username: YWRtaW4=
  password: MWYyZDFlMmU2N2Rm
kind: Secret
metadata:
  creationTimestamp: 2016-01-22T18:41:56Z
  name: mysecret
  namespace: default
  resourceVersion: "164619"
  selfLink: /api/v1/namespaces/default/secrets/mysecret
  uid: cfee02d6-c137-11e5-8d73-42010af00002
type: Opaque

$ echo "MWYyZDFlMmU2N2Rm" | base64 --decode
1f2d1e2e67df
```

## Using Secrets

### mounts a secret in a volume

spec.volumes[]
spec.volumes[].secret.secretName

spec.containers[].volumeMounts[]
spec.containers[].volumeMounts[].readOnly = true
spec.containers[].volumeMounts[].readOnly = true

```sh
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: mypod
    image: redis
    volumeMounts:
    - name: foo
      mountPath: "/etc/foo"
      readOnly: true
  volumes:
  - name: foo
    secret:
      secretName: mysecret
```

### Projection of secret keys to specific paths

spec.volumes[].secret.items

```sh
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: mypod
    image: redis
    volumeMounts:
    - name: foo
      mountPath: "/etc/foo"
      readOnly: true
  volumes:
  - name: foo
    secret:
      secretName: mysecret
      items:
      - key: username
        path: my-group/my-username
```

### Secret files permissions

spec.volumes[].secret.defaultMode

```sh
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: mypod
    image: redis
    volumeMounts:
    - name: foo
      mountPath: "/etc/foo"
  volumes:
  - name: foo
    secret:
      secretName: mysecret
      defaultMode: 256
```

spec.volumes[].secret.items[].mode

```sh
apiVersion: v1
kind: Pod
metadata:
  name: mypod
spec:
  containers:
  - name: mypod
    image: redis
    volumeMounts:
    - name: foo
      mountPath: "/etc/foo"
  volumes:
  - name: foo
    secret:
      secretName: mysecret
      items:
      - key: username
        path: my-group/my-username
        mode: 511
```

### Consuming Secret Values from Volumes

```sh
$ ls /etc/foo/
username
password
$ cat /etc/foo/username
admin
$ cat /etc/foo/password
1f2d1e2e67df
```

### Mounted Secrets are updated automatically


### Using Secrets as Environment Variables

spec.containers[].env[].valueFrom.secretKeyRef

```sh
apiVersion: v1
kind: Pod
metadata:
  name: secret-env-pod
spec:
  containers:
  - name: mycontainer
    image: redis
    env:
      - name: SECRET_USERNAME
        valueFrom:
          secretKeyRef:
            name: mysecret
            key: username
      - name: SECRET_PASSWORD
        valueFrom:
          secretKeyRef:
            name: mysecret
            key: password
  restartPolicy: Never
```

### Consuming Secret Values from Environment Variables

```sh
$ echo $SECRET_USERNAME
admin
$ echo $SECRET_PASSWORD
1f2d1e2e67df
```

### Using imagePullSecrets

Use of imagePullSecrets is described in the images documentation

https://kubernetes.io/docs/concepts/containers/images/#specifying-imagepullsecrets-on-a-pod


## Use cases

kubectl create secret generic --help

Use-Case: Pod with ssh keys

$ kubectl create secret generic ssh-key-secret --from-file=ssh-privatekey=/path/to/.ssh/id_rsa --from-file=ssh-publickey=/path/to/.ssh/id_rsa.pub

Use-Case: Pods with prod / test credentials

$ kubectl create secret generic prod-db-secret --from-literal=username=produser --from-literal=password=Y4nys7f11
secret "prod-db-secret" created
$ kubectl create secret generic test-db-secret --from-literal=username=testuser --from-literal=password=iluvtests
secret "test-db-secret" created

Use-case: Dotfiles in secret volume

Use-case: Secret visible to one container in a pod
