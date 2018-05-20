# Api

## Kubernetes API Overview

https://kubernetes.io/docs/reference/api-overview/

## Client Libraries

## Accessing the API

![](https://d33wubrfki0l68.cloudfront.net/673dbafd771491a080c02c6de3fdd41b09623c90/50100/images/docs/admin/access-control-overview.svg)

### Controlling Access to the Kubernetes API

1. Transport Security

典型的Kubernetes集群监听443端口。ApiServer提供了证书，这个证书通常是自签证书，所以 在用户机器上的 `$USER/.kube/config` 文件下，通常有 ApiServer 证书的根证书，用来替换系统根证书。这个证书写入 `$USER/.kube/config` 当使用 `kube-up.sh` 创建集群时。如果这个集群有多个用户，那么创建者需要将根证书分发给其他用户，使其他用户能够访问ApiServer。

2. Authentication

https://kubernetes.io/docs/admin/authentication/

一旦TLS连接建立成功，HTTP请求进入到认证阶段。

集群的 创建脚本 或者 集群管理 配置 ApiServer 运行一个或多个认证模块

认证模块包括：`Client Certificates`, `Password`, `Plain Tokens`, `Bootstrap Tokens`, `JWT Tokens` (used for service accounts).

认证模块可以同时制定多个，在这种情况下，按顺序逐个验证，直到有一个验证通过。

如果请求认证不通过，将会拒绝请求，并返回401状态码。否则，这个用户被认证为 特定的 `username`，并且这个 `username` 被用于后续的决策使用。有些认证模块还提供了用户的 `group` 成员信息，用于后续决策使用。

While Kubernetes uses “usernames” for access control decisions and in request logging, it does not have a user object nor does it store usernames or other information about users in its object store.

3. Authorization

https://kubernetes.io/docs/admin/authorization/

当请求被鉴定为某个特定的用户之后，请求必须被授权。

一个请求必须包含请求者的用户名，请求的动作，动作影响的主体对象。请求会被授权执行，如果存在一个策略(`Policy`)声明这个用户有权限执行这个动作。

For example, if Bob has the policy below, then he can read pods only in the namespace projectCaribou:

```json
{
    "apiVersion": "abac.authorization.kubernetes.io/v1beta1",
    "kind": "Policy",
    "spec": {
        "namespace": "projectCaribou",
        "user": "bob",
        "resource": "pods",
        "readonly": true
    }
}
```

If Bob makes the following request, the request is authorized because he is allowed to read objects in the projectCaribou namespace:

```json
{
  "apiVersion": "authorization.k8s.io/v1beta1",
  "kind": "SubjectAccessReview",
  "spec": {
    "resourceAttributes": {
      "namespace": "projectCaribou",
      "verb": "get",
      "group": "unicorn.example.org",
      "resource": "pods"
    }
  }
}
```

If Bob makes a request to write (create or update) to the objects in the projectCaribou namespace, his authorization is denied. If Bob makes a request to read (get) objects in a different namespace such as projectFish, then his authorization is denied.

Kubernetes支持多种授权模块, 如：`ABAC Mode`, `RBAC Mode`, `Webhook Mode`。当创建一个Kubernetes集群，需要配置相应的授权模块。当配置多个授权模块时，任意一个模块授权这个请求，这个请求就可以被执行。如果所有模块都拒绝对这个请求授权，请求将被拒绝，并返回`403`。

4. Admission Control

https://kubernetes.io/docs/admin/admission-controllers/

准入控制模块是可以修改请求或拒绝请求的软件模块。除了授权模块可以访问的属性之外，准入控制模块还可以访问将要创建或更新的对象的内容。
准入控制被用做于创建、更新、删除、链接上，但是不用于读取上。

准入控制模块同样支持配置多个，他们将会被依次调用。与授权和认证模块不同，任意一个模块拒绝，请求将会被立刻拒绝执行。

除了拒绝请求之外，准入控制模块将会为对象内容设置复杂的默认值。

5. API Server Ports and IPs

实际上ApiServer监听两个端口

1. Localhost Port

    - is intended for testing and bootstrap, and for other components of the master node
      (scheduler, controller-manager) to talk to the API
    - no TLS
    - default is port 8080, change with `--insecure-port` flag.
    - default IP is localhost, change with `--insecure-bind-address` flag.
    - request **bypasses** authentication and authorization modules.
    - request handled by admission control module(s).
    - protected by need to have host access

2. Secure Port

    - use whenever possible
    - uses TLS.  Set cert with `--tls-cert-file` and key with `--tls-private-key-file` flag.
    - default is port 6443, change with `--secure-port` flag.
    - default IP is first non-localhost network interface, change with `--bind-address` flag.
    - request handled by authentication and authorization modules.
    - request handled by admission control module(s).
    - authentication and authorization modules run. 

## Authenticating

### Users in Kubernetes

Kubernetes集群有两种类别的用户：由kubernetes管理的`serviceaccount`，和普通用户。

普通用户由外部独立的服务管理。
“An admin distributing private keys, a user store like Keystone or Google Accounts, even a file with a list of usernames and passwords.”
在这种情况下，Kubernetes没有表示普通用户账户的对象存在。普通用户不能通过Api调用添加到集群当中。

相比之下，`serviceaccount`可以通过ServerApi管理，他们绑定到特定的 `namespace` 下，由 Kubernetes 自动创建，也可以通过Api调用手动创建。

`serviceaccount` 绑定一组证书并存储到 `Secrets` 中，`Secrets` 会被挂载到 Pods 中允许集群中的进程调用 ServerApi。

Api请求会被绑定到一个 普通用户，或者 `serviceaccount`，或者被视为匿名的请求。这就意味着不论是在集群的内部或外部，不论从哪里发出的请求，都需要被认证，或者被当做一个匿名用户。

### Authentication strategies

1. X509 Client Certs `--client-ca-file=SOMEFILE`

ApiServer在启动的时候可以通过 `--client-ca-file=SOMEFILE` 参数传入 CA 证书文件。引用的文件必须包含一个或多个 CA 用来验证客户端提供的 客户端证书文件，客户端如果提供证书并且被验证通过，证书中 `common name` 将会被用作请求的 `username`，Kubernetes 1.4，客户端证书中的 `organization` 指示出组关系。

```sh
# username: jibeda
# group: app1,app2
openssl req -new -key jbeda.pem -out jbeda-csr.pem -subj "/CN=jbeda/O=app1/O=app2"
```

see: [certificates](https://kubernetes.io/docs/concepts/cluster-administration/certificates/)

2. Static Token File `--token-auth-file=SOMEFILE`

ApiServer在启动的时候可以通过 `--token-auth-file=SOMEFILE` 参数传入 bearer tokens 文件。

tokens文件是一个CSV格式的文件，最少有3列，`token, user name, user uid`，后面接一个可选的 `group name`

```
token1,user1,uid1,"group1,group2,group3"
token2,user2,uid2,"group1,group2,group3"
```

在HTTP请求的头部加入 `Authorization: Bearer THETOKEN`

```
Authorization: Bearer 31ada4fd-adec-460c-809a-9e56ceb75269
```

3. Bootstrap Tokens [beta] `--enable-bootstrap-token-auth`

Bootstrap tokens 是一个简单的 bearer token，用于创建一个新的集群或者在集群中加入新的节点。主要是为 kubeadm 设计的，但是也可以用在其他的上下文中。

Bootstrap tokens用一个特定的Secret类型（`bootstrap.kubernetes.io/token`）定义，存在于 `kube-system` 命名空间。Secret之后会被ApiServer的Bootstrap Authenticator读取，过期的token会被TokenCleaner controller移除。

4. Static Password File `--basic-auth-file=SOMEFILE`

```
password,user,uid,"group1,group2,group3"
```

```
Authorization: Basic BASE64ENCODED(USER:PASSWORD)
```

5. Service Account Tokens

服务帐户是一个自动启用的身份验证器，它使用 被签名的 `bearer tokens` 来验证请求，有两个可选的参数：

```
--service-account-key-file A file containing a PEM encoded key for signing bearer tokens. If unspecified, the API server’s TLS private key will be used.
--service-account-lookup If enabled, tokens which are deleted from the API will be revoked.
```

服务帐户通常由ApiServer自动创建，并且通过 Admission Controller 与运行中的pods关联。

Bearer tokens are mounted into pods at well-known locations, and allow in-cluster processes to talk to the API server. Accounts may be explicitly associated with pods using the serviceAccountName field of a PodSpec.

手动创建 serviceaccount

```sh
$ kubectl create serviceaccount jenkins
serviceaccount "jenkins" created
$ kubectl get serviceaccounts jenkins -o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  # ...
secrets:
- name: jenkins-token-1yvwg

$ kubectl get secret jenkins-token-1yvwg -o yaml
apiVersion: v1
data:
  ca.crt: (APISERVERS CA BASE64 ENCODED)
  namespace: ZGVmYXVsdA==
  token: (BEARER TOKEN BASE64 ENCODED)
kind: Secret
metadata:
  # ...
type: kubernetes.io/service-account-token
```

http://tonybai.com/2017/03/03/access-api-server-from-a-pod-through-serviceaccount/
http://tonybai.com/2016/11/25/the-security-settings-for-kubernetes-cluster/

service account token 存储在 secret 中，任何有权限读取 这些 secret 的用户都能够用 service account 认证，所以需要很小心的授予 权限。

6. OpenID Connect Tokens

在ApiServer中需要配置如下参数：

```
--oidc-issuer-url=https://accounts.google.com，允许 API server 发现公共签名密钥的提供者的 URL。如 https://accounts.google.com
--oidc-client-id=kubernetes，所有的 token 必须为其颁发的客户端 ID
--oidc-username-claim=sub，JWT声明使用的用户名。
--oidc-groups-claim=groups，JWT声明使用的用户组。
--oidc-ca-file=/etc/kubernetes/ssl/kc-ca.pem，用来签名您的身份提供商的网络 CA 证书的路径。 如 /etc/kubernetes/ssl/kc-ca.pem
```

kubectl使用

方式1

```sh
kubectl config set-credentials USER_NAME \
   --auth-provider=oidc \
   --auth-provider-arg=idp-issuer-url=( issuer url ) \
   --auth-provider-arg=client-id=( your client id ) \
   --auth-provider-arg=client-secret=( your client secret ) \
   --auth-provider-arg=refresh-token=( your refresh token ) \
   --auth-provider-arg=idp-certificate-authority=( path to your ca certificate ) \
   --auth-provider-arg=id-token=( your id_token ) \
   --auth-provider-arg=extra-scopes=( comma separated list of scopes to add to "openid email profile", optional )
```

```sh
kubectl config set-credentials mmosley  \
        --auth-provider=oidc  \
        --auth-provider-arg=idp-issuer-url=https://oidcidp.tremolo.lan:8443/auth/idp/OidcIdP  \
        --auth-provider-arg=client-id=kubernetes  \
        --auth-provider-arg=client-secret=1db158f6-177d-4d9c-8a8b-d36869918ec5  \
        --auth-provider-arg=refresh-token=q1bKLFOyUiosTfawzA93TzZIDzH2TNa2SMm0zEiPKTUwME6BkEo6Sql5yUWVBSWpKUGphaWpxSVAfekBOZbBhaEW+VlFUeVRGcluyVF5JT4+haZmPsluFoFu5XkpXk5BXqHega4GAXlF+ma+vmYpFcHe5eZR+slBFpZKtQA= \
        --auth-provider-arg=idp-certificate-authority=/root/ca.pem \
        --auth-provider-arg=extra-scopes=groups \
        --auth-provider-arg=id-token=eyJraWQiOiJDTj1vaWRjaWRwLnRyZW1vbG8ubGFuLCBPVT1EZW1vLCBPPVRybWVvbG8gU2VjdXJpdHksIEw9QXJsaW5ndG9uLCBTVD1WaXJnaW5pYSwgQz1VUy1DTj1rdWJlLWNhLTEyMDIxNDc5MjEwMzYwNzMyMTUyIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL29pZGNpZHAudHJlbW9sby5sYW46ODQ0My9hdXRoL2lkcC9PaWRjSWRQIiwiYXVkIjoia3ViZXJuZXRlcyIsImV4cCI6MTQ4MzU0OTUxMSwianRpIjoiMm96US15TXdFcHV4WDlHZUhQdy1hZyIsImlhdCI6MTQ4MzU0OTQ1MSwibmJmIjoxNDgzNTQ5MzMxLCJzdWIiOiI0YWViMzdiYS1iNjQ1LTQ4ZmQtYWIzMC0xYTAxZWU0MWUyMTgifQ.w6p4J_6qQ1HzTG9nrEOrubxIMb9K5hzcMPxc9IxPx2K4xO9l-oFiUw93daH3m5pluP6K7eOE6txBuRVfEcpJSwlelsOsW8gb8VJcnzMS9EnZpeA0tW_p-mnkFc3VcfyXuhe5R3G7aa5d8uHv70yJ9Y3-UhjiN9EhpMdfPAoEB9fYKKkJRzF7utTTIPGrSaSU6d2pcpfYKaxIwePzEkT4DfcQthoZdy9ucNvvLoi1DIC-UocFD8HLs8LYKEqSxQvOcvnThbObJ9af71EwmuE21fO5KzMW20KtAeget1gnldOosPtz1G5EwvaQ401-RPQzPGMVBld0_zMCAwZttJ4knw
```

方式2

```
kubectl --token=eyJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJodHRwczovL21sYi50cmVtb2xvLmxhbjo4MDQzL2F1dGgvaWRwL29pZGMiLCJhdWQiOiJrdWJlcm5ldGVzIiwiZXhwIjoxNDc0NTk2NjY5LCJqdGkiOiI2RDUzNXoxUEpFNjJOR3QxaWVyYm9RIiwiaWF0IjoxNDc0NTk2MzY5LCJuYmYiOjE0NzQ1OTYyNDksInN1YiI6Im13aW5kdSIsInVzZXJfcm9sZSI6WyJ1c2VycyIsIm5ldy1uYW1lc3BhY2Utdmlld2VyIl0sImVtYWlsIjoibXdpbmR1QG5vbW9yZWplZGkuY29tIn0.f2As579n9VNoaKzoF-dOQGmXkFKf1FMyNV0-va_B63jn-_n9LGSCca_6IVMP8pO-Zb4KvRqGyTP0r3HkHxYy5c81AnIh8ijarruczl-TK_yF5akjSTHFZD-0gRzlevBDiH8Q79NAr-ky0P4iIXS8lY9Vnjch5MF74Zx0c3alKJHJUnnpjIACByfF2SCaYzbWFMUNat-K1PaUk5-ujMBG7yYnr95xD-63n8CO8teGUAAEMx6zRjzfhnhbzX-ajwZLGwGUBT4WqjMs70-6a7_8gZmLZb2az1cZynkFRj2BaCkVT3A2RrjeEwZEtGXlMqKJ1_I2ulrOVsYx01_yD35-rw get nodes
```

7. Webhook Token Authentication

--authentication-token-webhook-config-file a kubeconfig file describing how to access the remote webhook service.
--authentication-token-webhook-cache-ttl how long to cache authentication decisions. Defaults to two minutes.

authentication-token-webhook-config-file:

```sh
# clusters refers to the remote service.
clusters:
  - name: name-of-remote-authn-service
    cluster:
      certificate-authority: /path/to/ca.pem         # CA for verifying the remote service.
      server: https://authn.example.com/authenticate # URL of remote service to query. Must use 'https'.

# users refers to the API server's webhook configuration.
users:
  - name: name-of-api-server
    user:
      client-certificate: /path/to/cert.pem # cert for the webhook plugin to use
      client-key: /path/to/key.pem          # key matching the cert

# kubeconfig files require a context. Provide one for the API server.
current-context: webhook
contexts:
- context:
    cluster: name-of-remote-authn-service
    user: name-of-api-sever
  name: webhook
```

```json
request:
{
  "apiVersion": "authentication.k8s.io/v1beta1",
  "kind": "TokenReview",
  "spec": {
    "token": "(BEARERTOKEN)"
  }
}
response:
{
  "apiVersion": "authentication.k8s.io/v1beta1",
  "kind": "TokenReview",
  "status": {
    "authenticated": true,
    "user": {
      "username": "janedoe@example.com",
      "uid": "42",
      "groups": [
        "developers",
        "qa"
      ],
      "extra": {
        "extrafield1": [
          "extravalue1",
          "extravalue2"
        ]
      }
    }
  }
}
{
  "apiVersion": "authentication.k8s.io/v1beta1",
  "kind": "TokenReview",
  "status": {
    "authenticated": false
  }
}
```

8. Authenticating Proxy

--requestheader-username-headers=X-Remote-User
--requestheader-group-headers=X-Remote-Group
--requestheader-extra-headers-prefix=X-Remote-Extra-

```
GET / HTTP/1.1
X-Remote-User: fido
X-Remote-Group: dogs
X-Remote-Group: dachshunds
X-Remote-Extra-Scopes: openid
X-Remote-Extra-Scopes: profile

name: fido
groups:
- dogs
- dachshunds
extra:
  scopes:
  - openid
  - profile
```

--requestheader-client-ca-file
--requestheader-allowed-names

9. Keystone Password

--experimental-keystone-url=<AuthURL>
--experimental-keystone-ca-file=SOMEFILE

### Anonymous requests


### User impersonation

```
Impersonate-User: jane.doe@example.com
Impersonate-Group: developers
Impersonate-Group: admins
Impersonate-Extra-dn: cn=jane,ou=engineers,dc=example,dc=com
Impersonate-Extra-scopes: view
Impersonate-Extra-scopes: development
```

kubectl drain mynode --as=superman --as-group=system:masters

## Authorization

在Kubernetes中，你必须被认证之后才能被授权。

Kubernetes期望通用的属性。

### Determine Whether a Request is Allowed or Denied

Kubernetes通过ApiServer对请求进行授权。它根据所有策略评估请求的所有属性，允许或拒绝请求。

一个API请求的所有部分都必须被一些策略所允许才能继续。这意味着权限被默认拒绝。

当配置多个授权模块时，授权模块将会被按顺序逐个检查，如果任何一个授权模块批准或拒绝，决策将会立即返回，其他授权模块不会被考虑。

### Review Your Request Attributes

* user - The user string provided during authentication.
* group - The list of group names to which the authenticated user belongs.
* “extra” - A map of arbitrary string keys to string values, provided by the authentication layer.
* API - Indicates whether the request is for an API resource.
* Request path - Path to miscellaneous non-resource endpoints like /api or /healthz.
* API request verb - API verbs get, list, create, update, patch, watch, proxy, redirect, delete, and deletecollection are used for resource requests. To * determine the request verb for a resource API endpoint, see Determine the request verb below.
* HTTP request verb - HTTP verbs get, post, put, and delete are used for non-resource requests.
* Resource - The ID or name of the resource that is being accessed (for resource requests only) – For resource requests using get, update, patch, and delete verbs, you must provide the resource name.
* Subresource - The subresource that is being accessed (for resource requests only).
* Namespace - The namespace of the object that is being accessed (for namespaced resource requests only).
* API group - The API group being accessed (for resource requests only). An empty string designates the core API group.

### Determine the Request Verb

### Authorization Modules

* Node - 一种特殊用途授权者，根据他们pod被调度授予kubelets权限。
* ABAC - 基于角色的访问控制，ABAC被一些人称为是权限系统设计的未来，用户属性（如用户年龄），环境属性（如当前时间），操作属性（如读取）和对象属性（如一篇文章，又称资源属性），所以理论上能够实现非常灵活的权限控制，几乎能满足所有类型的需求。

--authorization-mode=ABAC
--authorization-policy-file=SOME_FILENAME

* RBAC - 基于属性的访问控制，用户，组，角色，资源|对象，权限。

--authorization-mode=RBAC

* Webhook - A WebHook is an HTTP callback

#### Checking API Access

```
$ kubectl auth can-i create deployments --namespace dev
yes
$ kubectl auth can-i create deployments --namespace prod
no

$ kubectl auth can-i list secrets --namespace dev --as dave
no
```

`authorization.k8s.io` ApiGroup 中的资源包括:

* SubjectAccessReview: 任意用户的访问权限审查，而不仅仅是当前用户
* LocalSubjectAccessReview: 如同`SubjectAccessReview`，但仅限于特定的命名空间
* SelfSubjectRulesReview: 审查用户能在指定的命名空间内执行的一组操作

可以通过创建一个普通的资源对权限进行查询：

```
$ kubectl create -f - -o yaml << EOF
apiVersion: authorization.k8s.io/v1
kind: SelfSubjectAccessReview
spec:
  resourceAttributes:
    group: apps
    name: deployments
    verb: create
    namespace: dev
EOF

apiVersion: authorization.k8s.io/v1
kind: SelfSubjectAccessReview
metadata:
  creationTimestamp: null
spec:
  resourceAttributes:
    group: apps
    name: deployments
    namespace: dev
    verb: create
status:
  allowed: true
  denied: false
```

### Using Flags for Your Authorization Module

--authorization-mode=ABAC
--authorization-mode=RBAC
--authorization-mode=Webhook
--authorization-mode=Node
--authorization-mode=AlwaysDeny
--authorization-mode=AlwaysAllow

### ABAC Mode

### Using RBAC Authorization

apiGroup：rbac.authorization.k8s.io

该模式允许管理员通过Api动态的配置访问策略

#### API Overview

1. Role and ClusterRole

定义角色，并为角色分配对相应资源进行相关操作的权限

Role 和 ClusterRole 包含代表一组权限的规则。

Role：命名空间范围内的权限，并且只能指定一个命名空间。

```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""] # "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```

ClusterRole：集群范围内的权限

```yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  # "namespace" omitted since ClusterRoles are not namespaced
  name: secret-reader
rules:
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "watch", "list"]
```

2. RoleBinding and ClusterRoleBinding

将一组用户和角色绑定在一起，从而授予用户该角色所具有的权限。`subjects` 和 `roleRef`

```yaml
# This role binding allows "jane" to read pods in the "default" namespace.
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-pods
  namespace: default
subjects:
- kind: User
  name: jane
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

```yaml
# This role binding allows "dave" to read secrets in the "development" namespace.
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-secrets
  namespace: development # This only grants permissions within the "development" namespace.
subjects:
- kind: User
  name: dave
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: secret-reader
  apiGroup: rbac.authorization.k8s.io
```

```yaml
# This cluster role binding allows anyone in the "manager" group to read secrets in any namespace.
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: read-secrets-global
subjects:
- kind: Group
  name: manager
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: secret-reader
  apiGroup: rbac.authorization.k8s.io
```

3. Referring to Resources

大多数资源都可以以其名称的字符串表示形式表示，如“pods”，就像它出现在相关API端点的URL中一样。

然而，一些KubernetesApi涉及子资源，例如Pod的log：

```
GET /api/v1/namespaces/{namespace}/pods/{name}/log
```

```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: pod-and-pod-logs-reader
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "list"]
```

资源也可以通过 `resourceNames` 名称引用，当指定`resourceNames`时，相关的操作权限只会被授予到单独的实例上。

```yaml
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: configmap-updater
rules:
- apiGroups: [""]
  resources: ["configmaps"]
  resourceNames: ["my-configmap"]
  verbs: ["update", "get"]
```

4. Aggregated ClusterRoles

```yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: monitoring
aggregationRule:
  clusterRoleSelectors:
  - matchLabels:
      rbac.example.com/aggregate-to-monitoring: "true"
rules: [] # Rules are automatically filled in by the controller manager.
```

```yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: monitoring-endpoints
  labels:
    rbac.example.com/aggregate-to-monitoring: "true"
# These rules will be added to the "monitoring" role.
rules:
- apiGroups: [""]
  Resources: ["services", "endpoints", "pods"]
  verbs: ["get", "list", "watch"]
```

```yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: aggregate-cron-tabs-edit
  labels:
    # Add these permissions to the "admin" and "edit" default roles.
    rbac.authorization.k8s.io/aggregate-to-admin: "true"
    rbac.authorization.k8s.io/aggregate-to-edit: "true"
rules:
- apiGroups: ["stable.example.com"]
  resources: ["crontabs"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
---
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: aggregate-cron-tabs-view
  labels:
    # Add these permissions to the "view" default role.
    rbac.authorization.k8s.io/aggregate-to-view: "true"
rules:
- apiGroups: ["stable.example.com"]
  resources: ["crontabs"]
  verbs: ["get", "list", "watch"]
```

5. Role Examples
