# Commands

## 用户相关

相关文件

* /etc/passwd - 账户信息
* /etc/shadow - 密码信息
* /etc/group - 组信息
* /etc/default/useradd
* /etc/login.defs
* /etc/skel

用户管理

* adduser - 创建用户
* useradd - 它会添加这个用户名，并创建和用户名相同的组名，但它并不在/home目录下创建基于用户名的目录,也不提示创建新的密码
* usermod - 修改用户的基本信息
* userdel - 删除用户

组管理

* groupadd - 创建组
* groupmod - 修改组
* groupdel - 删除组
* groups - 输出指定用户所在组的组成员
* groupmems - 更改和查看组成员
* gpasswd - 管理组，将用户从组中添加、删除

账密

* passwd - 设置用户的认证信息，包括用户密码、密码过期时间等
* chage - 用来修改帐号和密码的有效期限
* chpasswd - 批量更新用户口令

登入登出

* login - 登入
* logout - 登出
* newgrp - 指令类似login指令，当它是以相同的帐号，另一个群组名称，再次登入系统

切换用户

* su - 在已登录的会话中切换到另外一个用户。
* sudo - sudo 命令需要输入当前用户的密码，su 命令需要输入 root 用户的密码。就安全而言，sudo 命令更好。

登录信息

* logname - 查看登录名
* whoami - 查看当前登录到系统的用户的名字
* users - 查看当前登录到系统的所有用户的名字
* who - 查看当前谁登录到系统
* w - 查看当前的登录用户以及在做什么
* ac - 统计的用户登录时间

登录记录

* id - 打印真实和有效的UID和GID信息
* last - 显示系统用户最近的登录信息
* lastb - 显示错误的尝试登录信息
* lastlog - 显示系统所有的用户最近的登录信息


账密系统管理

* pwck - 命令用来验证系统认证文件 `/etc/passwd` 和 `/etc/shadow` 的内容和格式的完整性
* pwconv - 命令用来开启用户的投影密码
* pwunconv - 命令与 `pwconv` 功能相反，用来关闭用户的投影密码，它会把密码从 `shadow` 文件内，重回存到 `passwd` 文件里

* grpck - 命令用于验证组文件的完整性，在验证之前，需要先锁定（lock）组文件 `/etc/group` 和 `/etc/shadow`
* grpconv - 命令用来开启群组的投影密码
* grpunconv - 命令用来关闭群组的投影密码，它会把密码从 `gshadow` 文件内，回存到 `group` 文件里

用户配置信息

* umask - 设置权限掩码
* chsh - change shell
* chfn - change finger
* chacl - 更改文件或目录的访问控制列表的命令，其和chmod功能很像。但是比chmod更为强大，更为精细。


## 目录及文件

目录栈

* dirs - 显示目录栈
* pushd - 将当前目录加入目录栈
* popd - 删除目录栈中的记录

目录

* ls - 显示目录内容列表
* tree - 树状图列出目录的内容
* cd - 切换用户当前工作目录
* pwd - 绝对路径方式显示用户当前工作目录
* mkdir - 用来创建目录
* rmdir - 用来删除目录
* touch - 创建新的空文件
* rm - 用于删除给定的文件和目录
* rename - 用字符串替换的方式批量改变文件名
* dd - 复制文件并对原文件的内容进行转换和格式化处理

* dirname 去除文件名中的非目录部分
* basename 打印目录或者文件的基本名称

符号链接

* ln - 用来为文件创件连接
* unlink - 系统调用函数unlink去删除指定的文件

ACL权限控制

* getfacl - 查看文件或目录的访问控制列表
* setfacl - 设置文件或目录的访问控制列表

文件属性（元信息）

* stat 用于显示文件的状态信息
* chown - change owner
* chgrp - change group
* chmod - change mode
* chcon - 修改对象（文件）的安全上下文，比如：用户、角色、类型、安全级别。
* chattr - 改变文件属性
* lsattr - 查看文件的第二扩展文件系统属性

文件拷贝

* cp - 用来将一个或多个源文件或者目录复制到指定的目的文件或目录
* scp - 加密的方式在本地主机和远程主机之间复制文件
* rcp - 使在两台Linux主机之间的文件复制操作更简单

文件查找

* find - 在指定目录下查找文件
* locate/slocate - 查找文件或目录
* updatedb - 创建或更新slocate命令所必需的数据库文件
* whereis - 命令只能用于程序名的搜索，而且只搜索二进制文件（参数-b）、man说明文件（参数-m）和源代码文件（参数-s）。
* which - 命令的作用是，在PATH变量指定的路径中，搜索某个系统命令的位置，并且返回第一个搜索结果。

文件内容信息

* file 用来探测给定文件的类型

文件内容查看

* cat - 连接文件并打印到标准输出设备上
* head - 在屏幕上显示指定文件的开头若干行
* tail - 在屏幕上显示指定文件的末尾若干行
* more - 显示文件内容，每次显示一屏
* less - 分屏上下翻页浏览文件内容

文件内容查看

* expand - 将文件的制表符转换为空白字符
* unexpand - 将文件的空白字符转换为制表符
* strings - 在对象文件或二进制文件中查找可打印的字符串
* hexdump - 显示文件十六进制格式
* od - 输出文件的八进制、十六进制等格式编码的字节
* nl - 带行号显示文件内容
* tac - 将文件已行为单位的反序输出
* rev - 将文件内容以字符为单位反序输出
* sort - 将文件进行排序并输出

文件内容转换

* iconv - 转换文件的编码方式
* tr - 转换或者删除一段文字

文件内容过滤

* col - 过滤控制字符
* colrm - 删除文件中的指定列

文件内容统计

* wc - 统计文件的字节数、字数、行数
* uniq - 报告或忽略文件中的重复行

文件内容查找

* grep
* fgrep
* egrep - 在文件内查找指定的字符串
* look - 显示文件中以指定字符串开头的任意行

文件内容检查

* spell - 对文件进行拼写检查
* ispell - 检查文件中出现的拼写错误

文件内容分割

* split - 分割任意大小的文件
* csplit - 将一个大文件分割成小的碎片文件

文件内容拼接

* join - 两个文件中指定栏位内容相同的行连接起来

文件比较

* cmp - 比较两个文件是否有差异
* comm - 两个文件之间的比较
* diff - 比较给定的两个文件的不同
* diff3 - 用于比较3个文件，将3个文件的不同的地方显示到标准输出
* diffstat - 显示diff命令输出信息的柱状图

文本分析工具

* awk - 强大的文本分析工具
* nawk
* gawk

文件内容编辑（流式）

* sed - 功能强大的流式文本编辑器

文件内容编辑（交互式）

* vi - 功能强大的纯文本编辑器
* ex - 启动vim编辑器的ex编辑模式
* ed - 单行纯文本编辑器
* joe - 强大的纯文本编辑器
* jed - 主要用于编辑代码的编辑器
* nano - 字符终端文本编辑器
* pico - 功能强大全屏幕的文本编辑器
* emacs - 功能强大的全屏文本编辑器

文件打包解包压缩解压

* tar
* pack - 打包
* unpack - 解包
* pcat - 输出包内容

文件压缩解压

* compress
* uncompress

文件压缩解压（zip）

* zip
* zipsplit
* zipinfo
* zipcloak
* zipgrep
* zipnote
* unzip

文件压缩解压（gzip）

* gzip - 用来压缩文件。文件经它压缩过后，其名称后面会多处“.gz”扩展名
* gunzip - 用来解压缩文件
* zcat - 用于不真正解压缩文件，就能显示压缩包中文件的内容的场合
* zfore - 强制为gzip格式的压缩文件添加“.gz”后缀
* znew - 用于将使用compress命令压缩的“.Z”压缩包重新转化为使用gzip命令压缩的“.gz”压缩包
* gzexe - 用来压缩可执行文件，压缩后的文件仍然为可执行文件，在执行时进行自动解压缩

文件压缩解压（bzip）

* bzip2
* bzip2recover
* bunzip2

文件压缩解压（bz）

* bzcat
* bzdiff
* bzcmp
* bzgrep
* bzmore
* bzless
* bzr_prompt_info

文件压缩解压（xz）

* xz - xz 是一个使用LZMA压缩算法的无损数据压缩文件格式

文件压缩解压（7z）

* 7z - LZMA and LZMA2 https://www.7-zip.org/


## 网络相关

URL

* curl
* wget

IP

* ipcalc - 简单的ip地址计算器，可以完成简单的IP地址计算任务

远程登录

* ssh
* telnet
* rlogin - 从当前终端登录到远程Linux主机
* rexec - 用于在指定的远程Linux系统主机上执行命令，向远程rexec服务器发出执行命令的请求
* rsh - 用于连接到远程的指定主机并执行指定的命令

IPtables

* iptstate
* iptables
* iptables-save
* iptables-restore

Network Diagnostic Tool

* ping
* mtr - [Linux网络诊断工具：MTR](https://www.zhukun.net/archives/7636)
* tracert
* traceroute
* tracepath
* hping3 - 用于生成和解析TCPIP协议数据包的开源工具，是安全审计、防火墙测试等工作的标配工具。
* tcpdump - 对网络上的数据包进行截获的包分析工具
* nc/netcat - netcat(简写是nc)是linux上非常有用的网络工具，它能通过TCP和UDP在网络中读写数据
* lnstat
* nstat/rtacct
* ss
* netstat
* iperf
* iptraf
* ifstat
* iftop
* atop
* htop
* iotop

```
[Linux 下大家喜欢用什么命令查看流量？](https://www.zhihu.com/question/19862245)
监控总体带宽使用――nload、bmon、slurm、bwm-ng、cbm、speedometer和netload
监控总体带宽使用（批量式输出）――vnstat、ifstat、dstat和collectl
每个套接字连接的带宽使用――iftop、iptraf、tcptrack、pktstat、netwatch和trafshow
每个进程的带宽使用――nethogs
```

Network Manager

* nmap - 网络探测和安全审核，用于在远程机器上探测网络，执行安全扫描，网络审计和搜寻开放端口。
* nmcli - 地址配置工具

DomainName

* nisdomainname
* dnsdomainname
* ypdomainname
* domainname

NIS (Network Information Services)

* hostname
* route
* ip

WHOIS

* whois

DNS

* host
* dig
* nslookup

[IW](https://hewlettpackard.github.io/wireless-tools/Tools.html)

* iwconfig
* iwlist
* iwspy
* iwpriv

IF

* ifrename - 网络接口重命名脚本。如果您有十块网卡，您应该开启它
* ifconfig
* ifcfg
* ifdown
* ifup
* ifplugstatus@ifplugd

[DHCP](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol)

* dhclient
* dhcpd
* dhcrelay

[ARP/RARP](https://en.wikipedia.org/wiki/Address_Resolution_Protocol)

* arp
* arping
* arpwatch
* arptables
* arpd
* rarp
* ethtool

FTP

* ftp
* tftp
* lftp
* lftpget
* ftpwho
* ftptop
* ftpcount
* ftpshut

MAIL

* mail
* mailstat
* mailq
* sendmail
* elm

SMB

* smbclient
* smbpassword
