
## Cryptography https://en.wikipedia.org/wiki/Cryptography

https://en.wikipedia.org/wiki/Public-key_cryptography

## PKCS https://en.wikipedia.org/wiki/PKCS

https://www.rsa.com/en-us

PKCS 全称是 Public-Key Cryptography Standards，是由 RSA 实验室与其它安全系统开发商为促进公钥密码的发展而制订的一系列标准，PKCS 目前共发布过 15 个标准。 常用的有：

PKCS 目前共发布过 15 个标准：

* （1）PKCS#1：RSA加密标准。PKCS#1定义了RSA公钥函数的基本格式标准，特别是数字签名。它定义了数字签名如何计算，包括待签名数据和签名本身的格式；它也定义了PSA公/私钥的语法。
* （2）PKCS#2：涉及了RSA的消息摘要加密，这已被并入PKCS#1中。
* （3）PKCS#3：Diffie-Hellman密钥协议标准。PKCS#3描述了一种实现Diffie- Hellman密钥协议的方法。
* （4）PKCS#4：最初是规定RSA密钥语法的，现已经被包含进PKCS#1中。
* （5）PKCS#5：基于口令的加密标准。PKCS#5描述了使用由口令生成的密钥来加密8位位组串并产生一个加密的8位位组串的方法。PKCS#5可以用于加密私钥，以便于密钥的安全传输（这在PKCS#8中描述）。
* （6）PKCS#6：扩展证书语法标准。PKCS#6定义了提供附加实体信息的X.509证书属性扩展的语法（当PKCS#6第一次发布时，X.509还不支持扩展。这些扩展因此被包括在X.509中）。
* （7）PKCS#7：密码消息语法标准。PKCS#7为使用密码算法的数据规定了通用语法，比如数字签名和数字信封。PKCS#7提供了许多格式选项，包括未加密或签名的格式化消息、已封装（加密）消息、已签名消息和既经过签名又经过加密* 的消息。
* （8）PKCS#8：私钥信息语法标准。PKCS#8定义了私钥信息语法和加密私钥语法，其中私钥加密使用了PKCS#5标准。
* （9）PKCS#9：可选属性类型。PKCS#9定义了PKCS#6扩展证书、PKCS#7数字签名消息、PKCS#8私钥信息和PKCS#10证书签名请求中要用到的可选属性类型。已定义的证书属性包括E-mail地址、无格式姓名、内容类型、消息摘要、签* 名时间、签名副本（counter signature）、质询口令字和扩展证书属性。
* （10）PKCS#10：证书请求语法标准。PKCS#10定义了证书请求的语法。证书请求包含了一个唯一识别名、公钥和可选的一组属性，它们一起被请求证书的实体签名（证书管理协议中的PKIX证书请求消息就是一个PKCS#10）。
* （11）PKCS#11：密码令牌接口标准。PKCS#11或“Cryptoki”为拥有密码信息（如加密密钥和证书）和执行密码学函数的单用户设备定义了一个应用程序接口（API）。智能卡就是实现Cryptoki的典型设备。注意：Cryptoki定义了* 密码函数接口，但并未指明设备具体如何实现这些函数。而且Cryptoki只说明了密码接口，并未定义对设备来说可能有用的其他接口，如访问设备的文件系统接口。
* （12）PKCS#12：个人信息交换语法标准。PKCS#12定义了个人身份信息（包括私钥、证书、各种秘密和扩展字段）的格式。PKCS#12有助于传输证书及对应的私钥，于是用户可以在不同设备间移动他们的个人身份信息。
* （13）PDCS#13：椭圆曲线密码标准。PKCS#13标准当前正在完善之中。它包括椭圆曲线参数的生成和验证、密钥生成和验证、数字签名和公钥加密，还有密钥协定，以及参数、密钥和方案标识的ASN.1语法。
* （14）PKCS#14：伪随机数产生标准。PKCS#14标准当前正在完善之中。为什么随机数生成也需要建立自己的标准呢？PKI中用到的许多基本的密码学函数，如密钥生成和Diffie-Hellman共享密钥协商，都需要使用随机数。然而，如* 果“随机数”不是随机的，而是取自一个可预测的取值集合，那么密码学函数就不再是绝对安全了，因为它的取值被限于一个缩小了的值域中。因此，安全伪随机数的生成对于PKI的安全极为关键。
* （15）PKCS#15：密码令牌信息语法标准。PKCS#15通过定义令牌上存储的密码对象的通用格式来增进密码令牌的互操作性。在实现PKCS#15的设备上存储的数据对于使用该设备的所有应用程序来说都是一样的，尽管实际上在内部实现* 时可能所用的格式不同。PKCS#15的实现扮演了翻译家的角色，它在卡的内部格式与应用程序支持的数据格式间进行转换。

## X.509

https://en.wikipedia.org/wiki/Public_key_infrastructure
https://en.wikipedia.org/wiki/X.509
https://en.wikipedia.org/wiki/X.690
https://en.wikipedia.org/wiki/Abstract_Syntax_Notation_One

X.509是常见通用的证书格式。所有的证书都符合为 Public Key Infrastructure (PKI) 制定的 ITU-T X509 国际标准。
X.509是国际电信联盟-电信（ITU-T）部分标准和国际标准化组织（ISO）的证书格式标准。
作为ITU-ISO目录服务系列标准的一部分，X.509是定义了公钥证书结构的基本标准。
1988年首次发布，1993年和1996年两次修订。
当前使用的版本是 X.509 V3，它加入了扩展字段支持，这极大地增进了证书的灵活性。
X.509 V3证书包括一组按预定义顺序排列的强制字段，还有可选扩展字段，即使在强制字段中，X.509证书也允许很大的灵活性，因为它为大多数字段提供了多种编码方案。

证书编码：

X.509 DER 编码(ASCII )的后缀是： .der
X.509 PAM 编码(Base64)的后缀是： .pem

两种编码格式的证书文件的后缀也可能是 .cer .crt，取自certificate，编码就需要根据内容判断了，pem文件内部包含数据类型信息。

PEM - Privacy Enhanced Mail， Openssl 使用 PEM 格式来存放各种信息，它是 openssl 默认采用的信息存放方式，内容是BASE64编码。

PEM文件还可以用来存放私钥等其他类型的数据，pem如果只含私钥的话，一般用.key扩展名，而且可以有密码保护

> Apache和*NIX服务器偏向于使用这种编码格式。

```
—–BEGIN CERTIFICATE—– 
—–END CERTIFICATE—–
```
```
—–BEGIN RSA PRIVATE KEY—– 
—–END RSA PRIVATE KEY—–
```

DER - Distinguished Encoding Rules，打开看是二进制格式，不可读。

> Java和Windows服务器偏向于使用这种编码格式。

证书编码的转换

PEM转为DER openssl x509 -in cert.crt -outform der -out cert.der
DER转为PEM openssl x509 -in cert.crt -inform der -outform pem -out cert.pem

—–BEGIN CERTIFICATE—–
—–END CERTIFICATE—–
—–BEGIN RSA PRIVATE KEY—–
—–END RSA PRIVATE KEY—–

PEM - Privacy Enhanced Mail，文本格式，以 `"-----BEGIN..."` 开头, `"-----END..."` 结尾，内容是BASE64编码.
查看PEM格式证书的信息：`openssl x509 -in certificate.pem -text -noout`
Apache和*NIX服务器偏向于使用这种编码格式.

DER - Distinguished Encoding Rules，二进制格式，不可读。
查看DER格式证书的信息：`openssl x509 -in certificate.der -inform der -text -noout`
Java和Windows服务器偏向于使用这种编码格式.


文件类型：

密钥 KEY - 通常用来存放一个公钥或者私钥，并非X.509证书，编码可能是PEM，也可能是DER。

```sh
openssl rsa -in mykey.key -text -noout
openssl rsa -in mykey.key -text -noout -inform der
```

证书签名请求 CSR - Certificate Signing Request，即证书签名请求，这个并不是证书，而是向权威证书颁发机构获得签名证书的申请，其核心内容是一个公钥(当然还附带了一些别的信息)，在生成这个申请的时候，同时也会生成一个私钥，私钥要自己保管好。

```sh
openssl req -noout -text -in my.csr -inform der
```

证书 certificate，CRT/CER

CRT常见于*NIX系统，可能是PEM编码，也有可能是DER编码，大多数应该是PEM编码。
CER常见于Windows系统，可能是PEM编码，也可能是DER编码，大多数应该是DER编码。

PFX/P12 - predecessor of PKCS#12,对*nix服务器来说,一般CRT和KEY是分开存放在不同文件中的,但Windows的IIS则将它们存在一个PFX文件中,(因此这个文件包含了证书及私钥)这样会不会不安全？应该不会,PFX通常会有一个"提取密码",你想把里面的东西读取出来的话,它就要求你提供提取密码,PFX使用的时DER编码,如何把PFX转换为PEM编码？
openssl pkcs12 -in for-iis.pfx -out for-iis.pem -nodes
这个时候会提示你输入提取代码. for-iis.pem就是可读的文本.
生成pfx的命令类似这样:openssl pkcs12 -export -in certificate.crt -inkey privateKey.key -out certificate.pfx -certfile CACert.crt

其中CACert.crt是CA(权威证书颁发机构)的根证书,有的话也通过-certfile参数一起带进去.这么看来,PFX其实是个证书密钥库.

## SSL/TLS & OpenSSL

https://en.wikipedia.org/wiki/Transport_Layer_Security
https://tools.ietf.org/html/rfc5246
http://www.ruanyifeng.com/blog/2014/02/ssl_tls.html

SSL/TLS 采用 PKCS公钥密码标准 和 X.509证书标准

SSL：（Secure Socket Layer，安全套接字层），位于可靠的面向连接的网络层协议和应用层协议之间的一种协议层。SSL通过互相认证、使用数字签名确保完整性、使用加密确保私密性，以实现客户端和服务器之间的安全通讯。该协议由两层组成：SSL记录协议和SSL握手协议。

TLS：(Transport Layer Security，传输层安全协议)，用于两个应用程序之间提供保密性和数据完整性。该协议由两层组成：TLS记录协议和TLS握手协议。

SSL是Netscape开发的专门用户保护Web通讯的，目前版本为3.0。最新版本的TLS 1.0是IETF(工程任务组)制定的一种新的协议，它建立在SSL 3.0协议规范之上，是SSL 3.0的后续版本。两者差别极小，可以理解为SSL 3.1，它是写入了RFC的。 

OpenSSL - 简单地说,OpenSSL是SSL的一个实现,SSL只是一种规范.理论上来说,SSL这种规范是安全的,目前的技术水平很难破解,但SSL的实现就可能有些漏洞,如著名的"心脏出血".OpenSSL还提供了一大堆强大的工具软件,强大到90%我们都用不到

## SSH & OpenSSH

OpenSSH(SSH) = SH + (OpenSSL|LibreSSL|...SSL|...TLS)(SSL)

OpenSSH 是 SSH （Secure SHell） 协议的免费开源实现。SSH协议族可以用来进行远程控制， 或在计算机之间传送文件。而实现此功能的传统方式，如telnet(终端仿真协议)、 rcp ftp、 rlogin、rsh都是极为不安全的，并且会使用明文传送密码。OpenSSH提供了服务端后台程序和客户端工具，用来加密远程控件和文件传输过程中的数据，并由此来代替原来的类似服务。
OpenSSH是使用SSH透过计算机网络加密通讯的实现。它是取代由SSH Communications Security所提供的商用版本的开放源代码方案。目前OpenSSH是OpenBSD的子计划。
OpenSSH常常被误认以为与OpenSSL有关联，但实际上这两个计划的有不同的目的，不同的发展团队，名称相近只是因为两者有同样的软件发展目标──提供开放源代码的加密通讯软件。.

openssl req -out lyj.csr -newkey rsa:2048 -nodes -keyout lyj.key

http://www.cnblogs.com/yangxiaolan/p/6256838.html
http://www.178linux.com/48764

## Ref

http://www.cnblogs.com/guogangj/p/4118605.html
