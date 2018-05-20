# ConfigMap

kubectl create configmap <map-name> <data-source>

## Create ConfigMaps

### Create ConfigMaps from directories

```sh
kubectl create configmap game-config --from-file=docs/user-guide/configmap/kubectl
```

### Create ConfigMaps from directories

```sh
kubectl create configmap game-config-2 --from-file=docs/user-guide/configmap/kubectl/game.properties
```

### Create ConfigMaps from literal values

```sh
kubectl create configmap special-config --from-literal=special.how=very --from-literal=special.type=charm
```

```sh
[root@k8s ~]# kubectl describe configmaps -n kube-public cluster-info
Name:         cluster-info
Namespace:    kube-public
Labels:       <none>
Annotations:  <none>

Data
====
kubeconfig:
----
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWJDZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRFNE1ESXdOVEV5TWpBMU5sb1hEVEk0TURJd016RXlNakExTmxvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTUdyCnpuOFpBYXFXcEVKa1pUazVubnNQWlE4L245WUhpTmxYOURzTHM5MGZZbGZFcStRam1TQjQ2Q2w4amlUVmRTWjYKY1Rod0s2Q3kyaVI1NUtVUUw4enN0VWVDb2x3UXBXZ3ZvY2kzeTZtSVlTWUVBVXZXMkcxZ2VpUiswYmMvOEx5ZQpZMHFGTVJBRlpiMzVjVm8yR0RHd0JvSGVYdU96cE5tbkphd1o1dldIMzVDZTIwVW1IN0FQdU5CUGU5UDVIWHR4CllNOWc1YmYvNmhndndaelNRa3VPRWRzUkdmZmQ4d0ZjQ0Q1VTlGZkIxcmRwT3BNMWRSck9DNmJIOE5La09CL1kKeFQyR0Y5QXE3a0E4YXVEcFhVVmhtZXNUT3RCTFV0VW1zN3pCWUQ5cUxPU0xUcGVoRnlCczdvVDE5RDB4U1FXUQpWNzNwT0pZdWFwUzhnNFVaVE4wQ0F3RUFBYU1qTUNFd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFDWXFTZ3FmNHpuS1EzK2cyZU9tNEVEdTVvZ0oKSjJwVnFvSEZLNzJSUVN0MSt5NTIwaEhyb1ZmdDQ1SldtQWp1T0ZRbTI5WU1ZU25oTEhYUUFwOVhhTnhWN2U4YgpVd1lZRTVKLzMwcVl3M05UTVJqQWNCeFlpbkIvSjUwZmZ1QndJNk9MUUVRYmZ6YmVvZjZMbVg1Q1NZa2NwaTVLCnllNi93dVlkMVdFalFZUVRZS2F2dnNQMlpiNFFaVjJNNmJ0OHVndlFPeVJNVzlPRk1SUGIrbVkzWnJPSlRaN3oKWGRhWGw1dEpxMWt4NXVCYmZDVEZyVDNjcVROcFlpdkQrRmovWnRvOWx1d2s5STBiQlpabEFGbHczMjJlcnFPWgpQc2RqNlo1WmJPaU5TNzFSRXU1TEMvR2ozS3l4VngzV25nL1oxVFBhVXYvRFVncFA1VG9McElROEx2Yz0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    server: https://172.31.197.9:6443
  name: ""
contexts: []
current-context: ""
kind: Config
preferences: {}
users: []

Events:  <none>
```

## Define Pod environment variables using ConfigMap data

### Define a Pod environment variable with data from a single ConfigMap

1. kubectl create configmap special-config --from-literal=special.how=very 

spec.containers[].env[].valueFrom.configMapKeyRef

```sh
apiVersion: v1
kind: Pod
metadata:
  name: dapi-test-pod
spec:
  containers:
    - name: test-container
      image: k8s.gcr.io/busybox
      command: [ "/bin/sh", "-c", "env" ]
      env:
        # Define the environment variable
        - name: SPECIAL_LEVEL_KEY
          valueFrom:
            configMapKeyRef:
              # The ConfigMap containing the value you want to assign to SPECIAL_LEVEL_KEY
              name: special-config
              # Specify the key associated with the value
              key: special.how
  restartPolicy: Never
```

2. Define Pod environment variables with data from multiple ConfigMaps

kube create -f 

```sh
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: special-config-1
  namespace: default
data:
  special.how: very

---
apiVersion: v1
kind: ConfigMap
metadata:
  name: env-config
  namespace: default
data:
  log_level: INFO

---
apiVersion: v1
kind: Pod
metadata:
  name: dapi-test-pod
spec:
  containers:
    - name: test-container
      image: k8s.gcr.io/busybox
      command: [ "/bin/sh", "-c", "env" ]
      env:
        - name: SPECIAL_LEVEL_KEY
          valueFrom:
            configMapKeyRef:
              name: special-config
              key: special.how
        - name: LOG_LEVEL
          valueFrom:
            configMapKeyRef:
              name: env-config
              key: log_level
  restartPolicy: Never
```

### Configure all key-value pairs in a ConfigMap as Pod environment variables

spec.containers[].env[].envFrom.configMapKeyRef

```sh
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: special-config
  namespace: default
data:
  SPECIAL_LEVEL: very
  SPECIAL_TYPE: charm

---
apiVersion: v1
kind: Pod
metadata:
  name: dapi-test-pod
spec:
  containers:
    - name: test-container
      image: k8s.gcr.io/busybox
      command: [ "/bin/sh", "-c", "env" ]
      envFrom:
      - configMapRef:
          name: special-config
  restartPolicy: Never
```


### Use ConfigMap-defined environment variables in Pod commands

```sh
apiVersion: v1
kind: Pod
metadata:
  name: dapi-test-pod
spec:
  containers:
    - name: test-container
      image: k8s.gcr.io/busybox
      command: [ "/bin/sh", "-c", "echo $(SPECIAL_LEVEL_KEY) $(SPECIAL_TYPE_KEY)" ]
      env:
        - name: SPECIAL_LEVEL_KEY
          valueFrom:
            configMapKeyRef:
              name: special-config
              key: SPECIAL_LEVEL
        - name: SPECIAL_TYPE_KEY
          valueFrom:
            configMapKeyRef:
              name: special-config
              key: SPECIAL_TYPE
  restartPolicy: Never
```

### Add ConfigMap data to a Volume

spec.containers[].containers[].volumeMounts.mountPath
spec.containers[].volumes[].configMap


1. Populate a Volume with data stored in a ConfigMap

```sh
apiVersion: v1
kind: Pod
metadata:
  name: dapi-test-pod
spec:
  containers:
    - name: test-container
      image: k8s.gcr.io/busybox
      command: [ "/bin/sh", "-c", "ls /etc/config/" ]
      volumeMounts:
      - name: config-volume
        mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        # Provide the name of the ConfigMap containing the files you want
        # to add to the container
        name: special-config
  restartPolicy: Never
```

2. Add ConfigMap data to a specific path in the Volume

```sh
apiVersion: v1
kind: Pod
metadata:
  name: dapi-test-pod
spec:
  containers:
    - name: test-container
      image: k8s.gcr.io/busybox
      command: [ "/bin/sh","-c","cat /etc/config/keys" ]
      volumeMounts:
      - name: config-volume
        mountPath: /etc/config
  volumes:
    - name: config-volume
      configMap:
        name: special-config
        items:
        - key: special.level
          path: keys
  restartPolicy: Never
```


Project keys to specific paths and file permissions

Mounted ConfigMaps are updated automatically



