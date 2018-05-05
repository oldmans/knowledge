# HTTP

## HTTP认证方式

* Basic Authorization
* Digest Authorization
* WSSE(WS-Security) HTTP Authorization
* API Key Authenticator
* HMAC
* JWT
* Cookie-Session
* token　Authentication
* OAuth1.0 Authentication
* OAuth2.0 Authentication
* Kerberos
* NTLM
* Hawk Authentication
* AWS Signature
* https

## Authorization

HTTP认证基于 质询/回应(challenge/response) 的认证模式。

* HTTP请求报头： `Authorization`
* HTTP响应报头： `WWW-Authenticate`

基本认证和摘要认证的交互流程是一样的，基本认证是明文的认证方式，摘要认证在基本认证的基础增加了加密机制。

### 基本认证（Basic Authorization）

HTTP1.0提出的认证方法
客户端对于每一个realm，通过提供用户名和密码来进行认证的方式
包含密码的明文传递

Authorization

```
Authorization: 认证方式 认证信息
Authorization: Basic Base64.encode("username:password")
```

WWW-authenticate

```
WWW-authenticate: Basic Realm="Authorization Required"
```

基本认证步骤：

1. 客户端访问一个受http基本认证保护的资源。
2. 服务器返回`401`状态，要求客户端提供用户名和密码进行认证。

    ```
    401 Unauthorized
    WWW-Authenticate: Basic Realm="Authorization Required"
    ```

3. 客户端将输入的用户名密码用Base64进行编码后，采用非加密的明文方式传送给服务器。

    ```
    Authorization: Basic Base64.encode("username:password")
    ```

4. 如果认证成功，则返回相应的资源。如果认证失败，则仍返回401状态，要求重新进行认证。

注意事项：

1. Http是无状态的，同一个客户端对同一个realm内资源的每一个访问会被要求进行认证。
2. 客户端通常会缓存 `Username、Password、Authentication Realm`，所以，一般不需要你重新输入用户名和密码。
3. 以非加密的明文方式传输，虽然转换成了不易被人直接识别的字符串，但是无法防止用户名密码被恶意盗用。

HTTP Basic Authentication虽然十分简单，但仍有一些需要注意的地方：

* 用户名和密码在每次请求时都会被带上，即使请求是通过安全连接发送的，这也是潜在的可能暴露它们的地方。
* 如果网站使用的加密方法十分弱，或者被破解，那么用户名和密码将会马上泄露。
* 用户通过这种方式进行验证时，并没有登出的办法
* 同样，登陆超时也是没有办法做到的，你只能通过修改用户的密码来模拟。

### 摘要认证 Digest Authorization

HTTP1.1提出的基本认证的替代方法
服务器端以nonce进行质询，客户端以 Username、Password、nonce、HTTP方法，请求的URI等信息为基础产生的response信息进行认证的方式。
不包含密码的明文传递

虽然MD5是可逆的，被认为是不安全的，但是在HTTP摘要认证过程中使用MD5算法中引入了一些随机数，使得数据的可逆性的难度大大提高，所以使用MD5是安全的。

摘要认证步骤：

1. 客户端访问一个受http摘要认证保护的资源。
2. 服务器返回401状态以及nonce等信息，要求客户端进行认证。

    ```
    HTTP/1.1 401 Unauthorized
    WWW-Authenticate: Digest
        realm="testrealm@host.com",
        qop="auth,auth-int",
        nonce="dcd98b7102dd2f0e8b11d0f600bfb0c093",
        opaque="5ccc069c403ebaf9f0171e9517f40e41"
    ```

3. 客户端将以 Username、Password、nonce、HTTP方法和被请求的URI为校验值基础而加密（默认为MD5算法）的摘要信息返回给服务器。

    认证必须的五个情报：

    * realm： 响应中包含信息
    * nonce： 响应中包含信息
    * username： 用户名
    * digest-uri： 请求的URI
    * response： 以上面四个信息加上密码信息，使用MD5算法得出的字符串。

    ```
    Authorization: Digest 
        realm="testrealm@host.com",                     <-　服务器端质询响应信息
        qop=auth,                                       <-　服务器端质询响应信息
        nonce="dcd98b7102dd2f0e8b11d0f600bfb0c093",     <-　服务器端质询响应信息
        opaque="5ccc069c403ebaf9f0171e9517f40e41"       <-　服务器端质询响应信息
        username="Mufasa",                              <-　客户端已知信息
        uri="/dir/index.html",                          <-　客户端已知信息
        nc=00000001,                                    <-　客户端计算出的信息
        cnonce="0a4f113b",                              <-　客户端计算出的客户端nonce
        response="6629fae49393a05397450978507c4ef1",    <-　最终的摘要信息 hash3
    ```

4. 如果认证成功，则返回相应的资源。如果认证失败，则仍返回401状态，要求重新进行认证。

特记事项：

1. 避免将密码作为明文在网络上传递，相对提高了HTTP认证的安全性。
2. 当用户为某个realm首次设置密码时，服务器保存的是以username，realm，password为基础计算出的哈希值（hash1），而非密码本身。
3. 如果qop=auth-int，在计算hash2时，除了包括HTTP方法，URI路径外，还包括请求实体主体，从而防止PUT和POST请求表示被人篡改。
4. 但是因为nonce本身可以被用来进行摘要认证，所以也无法确保认证后传递过来的数据的安全性。

    * nonce： 随机字符串，每次返回401响应的时候都会返回一个不同的nonce。 
    * nounce：随机字符串，每个请求都得到一个不同的nounce。 
    * MD5(Message Digest Algorithm 5)
         1. hash1 = MD5(username:realm:password)
         2. hash2 = MD5(HTTP-Method:URI)
         3. hash3 = MD5(hash1:nonce:nc:cnonce:qop:hash2)


### WS-Security Authorization

* [WS Security 认证方式详解](http://www.cnblogs.com/mikevictor07/p/3678535.html)

WS-Security 所涉及的三个方面：身份验证、签名和加密

WSSE UsernameToken


 WSSE UsernameToken 
服务器端以nonce进行质询，客户端以用户名，密码，nonce，HTTP方法，请求的URI等信息为基础产生的response信息进行认证的方式。
不包含密码的明文传递 

认证步骤：

1. 客户端访问一个受WSSE认证保护的资源。 
2. 服务器返回401状态，要求客户端进行认证。

    ```
    HTTP/1.1 401 Unauthorized
    WWW-Authenticate: WSSE
        realm="testrealm@host.com",
        profile="UsernameToken"     <- 服务器期望你用UsernameToken规则生成回应
    ```

    UsernameToken规则：客户端生成一个nonce，然后根据该nonce，Password，Date来算出哈希值。 

3. 客户端将生成一个nonce值，并以该nonce值，密码，当前日时为基础，算出哈希值返回给服务器。 

    ```
    Authorization: WSSE
        profile="UsernameToken"
        X-WSSE:UsernameToken
        Username="Mufasa",
        PasswordDigest="Z2Y......",
        Nonce="dcd98b7102dd2f0e8b11d0f600bfb0c093",
        Created="2010-01-01T09:00:00Z"
    ```

4. 如果认证成功，则返回相应的资源。如果认证失败，则仍返回401状态，要求重新进行认证。


