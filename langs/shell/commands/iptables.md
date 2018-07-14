Iptables
========

## 表(table)

包含4个表：

  4个表的优先级由高到低：raw-->mangle-->nat-->filter

  * raw---RAW表只使用在PREROUTING链和OUTPUT链上,因为优先级最高，从而可以对收到的数据包在连接跟踪前进行处理。一但用户使用了RAW表,在某个链上,RAW表处理完后,将跳过NAT表和ip_conntrack处理,即不再做地址转换和数据包的链接跟踪处理了.
  * filter---这个规则表是预设规则表，拥有 INPUT、FORWARD 和 OUTPUT 三个规则链，这个规则表顾名思义是用来进行封包过滤的理动作
  * net----此规则表拥有prerouting和postrouting两个规则链， 主要功能为进行一对一、一对多、多对多等网址转译工作（SNATDNAT）
  * mangle--此规则表拥有prerouting、FORWARD、postrouting三个规则链，除了进行网址转译工作会改写封包外，在某些特殊应用可能也必须去改写封包(ITL、TOS)或者是设定MARK(将封包作记号，以进行后续的过滤)这时就必须将这些工作定义在mangles规则表中

常用命令：

  * -A 追加规则-->iptables -A INPUT
  * -D 删除规则-->iptables -D INPUT 1(编号)
  * -R 修改规则-->iptables -R INPUT 1 -s 192.168.12.0 -j DROP 取代现行规则，顺序不变(1是位置)
  * -I 插入规则-->iptables -I INPUT 1 --dport 80 -j ACCEPT 插入一条规则，原本位置上的规则将会往后移动一个顺位
  * -L 查看规则-->iptables -L INPUT 列出规则链中的所有规则
  * -N 新的规则-->iptables -N allowed 定义新的规则

通用参数：

  * -p 协议       例：iptables -A INPUT -p tcp
  * -s源地址      例：iptables -A INPUT -s 192.168.1.1
  * -d目的地址    例：iptables -A INPUT -d 192.168.12.1
  * -sport源端口  例:iptables -A INPUT -p tcp --sport 22
  * -dport目的端口 例:iptables -A INPUT -p tcp --dport 22
  * -i指定入口网卡 例:iptables -A INPUT -i eth0
  * -o指定出口网卡 例:iptables -A FORWARD -o eth0
  * -j 指定要进行的处理动作 常用的ACTION：
    * DROP：丢弃
    * REJECT：明示拒绝
    * ACCEPT：接受
    * SNAT基于原地址的转换
    * source--指定原地址

比如我们现在要将所有192.168.10.0网段的IP在经过的时候全都转换成172.16.100.1这个假设出来的外网地址：

> iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j SNAT --to-source 172.16.100.1(外网有效ip)

这样，只要是来自本地网络的试图通过网卡访问网络的，都会被统统转换成172.16.100.1这个IP.
MASQUERADE(动态伪装）--家用带宽获取的外网ip，就是用到了动态伪装

> iptables -t nat -A POSTROUTING -s 192.168.10.0/24 -j MASQUERADE

DNAT目标地址转换
--to-destination-指定目标地址 10.18访问80端口转换到100.2上

> iptables -t nat -A PREROUTING -d 192.168.10.18 -p tcp --dport 80 -j DNAT --to-destination 172.16.100.2

MASQUERADE：源地址伪装，(动态伪装）--家用带宽获取的外网ip，就是用到了动态伪装
REDIRECT：重定向：主要用于实现端口重定向
MARK：打防火墙标记的
RETURN：返回 在自定义链执行完毕后使用返回，来返回原规则链。

## 链(chain)

每个表都有自己的一组内置链，可以对链进行自定义，这样就可以建立一组规则，

filter表中的input、output和forward链

## 匹配(match)
每个iptables规则都包含一组匹配以及一个目标，iptables匹配指的是数据包必须匹配的条件，只有当
数据包满足所有的匹配条件时，iptables才能根据由该规则的目标所指定的动作来处理该数据包
匹配都在iptable的命令行中指定
source--匹配源ip地址或网络
destination (-d)--匹配目标ip地址或网络
protocol (-p)--匹配ip值
in-interface (-i)--流入接口(例如，eth0)
out-interface (-o)--流出接口
state--匹配一组连接状态
string--匹配应用层数据字节序列
comment--在内核内存中为一个规则关联多达256个字节的注释数据

## 目标(target)

iptables支持一组目标，用于数据包匹配一条规则时触发一个动作

  * ACCEPT--允许数据包通过
  * DROP--丢弃数据包，不对该数据包做进一步的处理，对接收栈而言，就好像该数据包从来没有被接收一样
  * LOG--将数据包信息记录到syslog
  * REJECT--丢弃数据包，同时发送适当的响应报文(针对TCP连接的TCP重要数据包或针对UDP数据包的ICMP端口不可达消息)
  * RETURN--在调用链中继续处理数据包

vi /etc/sysconfig/iptables 策略文件
vi /etc/sysconfig/iptables-config  配置文件

iptables缺省具有5条规则链
prerouting(内到外) forward(转发) postrouting(外到内) input(输入) output(输出)

### 1.链管理命令（这都是立即生效的）

* -P :设置默认策略的（设定默认门是关着的还是开着的）
    默认策略一般只有两种(DROP|ACCEPT)

```sh
iptables -P INPUT ACCEPT
iptables -P INPUT DROP
```

这就把默认规则给拒绝了。并且没有定义哪个动作，所以关于外界连接的所有规则包括Xshell连接之类的，远程连接都被拒绝了

* -F: flash，清空规则链的(注意每个链的管理权限)

```sh
iptables -t nat -F PREROUTING
iptables -t nat -F 清空nat表的所有链
iptables -N inbound_tcp_web 表示附在tcp表上用于检查web的。 -N:NEW 支持用户新建一个链
```

* -X: 用于删除用户自定义的空链

    使用方法跟-N相同，但是在删除之前必须要将里面的链给清空昂了

* -E：用来Rename chain主要是用来给用户自定义的链重命名

    -E oldname newname

* -Z：清空链，及链中默认规则的计数器的（有两个计数器，被匹配到多少个数据包，多少个字节）

    iptables -Z :清空

### 2.规则管理命令

* -A：追加，在当前链的最后新增一个规则
* -I num : 插入，把当前规则插入为第几条。-I 3 :插入为第三条
* -R num：Replays替换/修改第几条规则 格式：iptables -R 3 …………
* -D num：删除，明确指定删除第几条规则
        
### 3.查看管理命令 “-L”

附加子命令:

* -n：以数字的方式显示ip，它会将ip直接显示出来，如果不加-n，则会将ip反向解析成主机名。
* -v：显示详细信息
* -vv
* -vvv :越多越详细
* -x：在计数器上显示精确值，不做单位换算
* --line-numbers : 显示规则的行号
* -t nat：显示所有的关卡的信息
 
### 4.：详解匹配标准

#### 2.扩展匹配

2.1 隐含扩展：对协议的扩展

#### -p tcp :TCP协议的扩展。一般有三种扩展：

* --dport XX-XX：指定目标端口,不能指定多个非连续端口,只能指定单个端口，比如
* --dport 21  或者 --dport 21-23 (此时表示21,22,23)
* --sport：指定源端口
* --tcp-fiags：TCP的标志位（SYN,ACKFIN,PSHRST,URG）
    
    对于它，一般要跟两个参数：
    1.检查的标志位
    2.必须为1的标志位
    --tcpflags syn,ack,fin,rst syn   =    --syn
    表示检查这4个位，这4个位中syn必须为1，其他的必须为0。所以这个意思就是用于检测三次握手的第一次包的。对于这种专门匹配第一包的SYN为1的包，还有一种简写方式，叫做--syn

-p udp：UDP协议的扩展
    --dport
    --sport

-p icmp：icmp数据报文的扩展
    --icmp-type：
    echo-request(请求回显)，一般用8 来表示
    所以 --icmp-type 8 匹配请求回显数据包
    echo-reply （响应的数据包）一般用0来表示
 
#### 2.2显式扩展（-m）
扩展各种模块
  -m multiport：表示启用多端口扩展
  之后我们就可以启用比如 --dports 21,23,80

策略需求：
域名系统(DNS)查询
文件传输协议(FTP)传输
网络时间协议(NTP)查询
安全Shell(SSH)会话
简单邮件传输协议(SMTP)会话
通过HTTP/HTTPS进行web会话
whois查询

外网扫描-------                (192.168.10.1(eth1))    (192.168.10.0/24)-------局域网客户机(10.50)
外网web--------因特网----------iptables防火墙----------局域网---------------内网扫描者(10.200)
外网dns--------                (主机名:iptables)                ----------------web服务器(20.3)
                            (71.157.X.X(eth0))                ----------------dns服务器(10.4)
脚本:

```sh
### iptables.sh
IPTABLES=/sbin/iptables
MODPROBE=/sbin/modprobe
INT_NET=192.168.10.0/24
#### flush existing rules and set chain policy setting to drop(重置现有规则和链策略设置)
echo "[+] Flushing existing iptables rules..."
$IPTABLES -F-----------------------------(清空规则链)
$IPTABLES -F -t nat----------------------(清空nat表)
$IPTABLES -X-----------------------------(删除用户的空链)
$IPTABLES -p INPUT DROP------------------(关闭input端口)
$IPTABLES -p OUTPUT DROP-----------------(关闭output端口)
$IPTABLES -p FORWARD DROP----------------(关闭forward端口)
### load connection-tracking modules------(负载连接模块)
$MODPROBE ip_conntrack-------------------(加载ip_conntrack模块)
$MODPROBE iptables_nat-------------------(加载iptables_nat模块)
$MODPROBE ip_conntrack_ftp---------------(加载ip_conntrack_ftp模块)
$MODPROBE ip_nat_ftp---------------------(加载ip_nat_ftp模块)
```

INPUT链
INPUT链作为iptables的构建快，作用是控制目标为本地系统的数据包是否可以和本地套接字通信，如果INPUT链中的第一条规则要求IPtables丢弃所以得数据包(或者INPUT链的策略设置为DROP)，那么所有试图通过任何ip通信方式(如TCP、UDP或ICMP)与系统直接通信的努力都将失败。ARP工作在数据链路层而不是网络层，而iptables只过滤ip及其之上协议的数据包，所以iptables不能过滤arp协议的报文。

####INPUT chain ########
echo "[+] Setting up INPUT chain ..."
####state tracking rules####
$IPTABLES -A INPUT -m state --state INVALID -j LOG --log-prefix "DROP INVALID" --log-ip-OPTIONS --log-tcp-options
$IPTABLES -A INPUT -m state --state INVALID -j DROP
$IPTABLES -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
##anti-spoofing rules
$IPTABLES -A INPUT -i eth1 -s ! $INI_NET -j LOG --log-prefix "SPOOFED PKT"
$IPTABLES -A INPUT -i eth1 -s ! $INT_NET -j DROP

##ACCEPT rules
$IPTABLES -A INPUT -i eth1 -p tcp -s $INT_NET --dport 22 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

##default INPUT LOG rule
$IPTABLES -A INPUT -i ! lo -j LOG --log-prefix "DROP" --log-ip-options --log-tcp-options

建立OUTPUT链规则集的命令如下所示：
#####OUTPUT chain ####
echo "[+] setting up OUTPUT chain..."
###state tracking rules
$IPTABLES -A OUTPUT -m state --state INVALID -j LOG --log-prefix "DROP INVALID" --log-ip-options --log-tcp-options
$IPTABLES -A OUTPUT -m state --state INVALID -j DROP
$IPTABLES -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

###ACCEPT RULES rules for allowing connections out-interface
$IPTABLES -A OUTPUT -p tcp --dport 21 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --dport 22 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --dport 25 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --dport 43 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --dport 80 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --dport 443 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --dport 4321 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -p tcp --dport 53 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT

#### default OUTPUT LOG RULES
$IPTABLES -A OUTPUT -o ! lo -j LOG --log-prefix "DROP" --log-ip-options --log-tcp-options

FORWARD 链
filter表中的forward链提供了对通过防火墙接口转发数据包进行访问控制的能力：
###FORWARD chain####
echo "[+]Setting up FORWARD chain..."
###state tracking rules
$IPTABLES -A FORWARD -m state --state INVALID -j LOG --log-prefix "DROP INVALID" -- log-ip-options --log-tcp-options
$IPTABLES -A FORWARD -m state --state INVALID -j DROP
$IPTABLES -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

###anti-spoofing rules
$IPTABLES -A FORWARD -i eth1 -s ! $INT_NET -j LOG --log-prefix "SPOOFED PKT"
$IPTABLES -A FORWARD -i eth1 -s ! $INT_NET -j DROP

###ACCEPT rules
$IPTABLES -A FORWARD -p tcp -i eth1 -s $INT_NET --dport 21 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A FORWARD -p tcp -i eth1 -s $INT_NET --dport 22 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A FORWARD -p tcp -i eth1 -s $INT_NET --dport 25 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A FORWARD -p tcp -i eth1 -s $INT_NET --dport 43 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A FORWARD -p tcp --dport 80 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A FORWARD -p tcp --dport 443 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A FORWARD -p tcp -i eth1 -s $INT_NET --DPORT 4321 --syn -m state --state NEW -j ACCEPT
$IPTABLES -A FORWARD -p tcp -p udp --dport 53 -m state --state NEW -j ACCEPT
$IPTABLES -A FORWARD -p tcp icmp --icmp-type echo-request -j ACCEPT
允许通过防火墙发起ftp、ssh、smtp和whois连接，但这类必须是从子网接口(eth1)上的内部子网发起的，允许来自任何源地址的http、https和dns通信通过防火墙
####default log rule
$IPTABLES -A FORWARD -i ! lo -j LOG --log-prefix "DROP" --log-ip-options --log-tcp-options

网络地址转换
iptables的nat表专用于定义所有的NAT规则，在这个表中有两个链：PREROUTING和POSTROUTING，利用PREROUTING链将nat表中的规则应用到还没有通过内核中路由算法确定应从哪个接口传输的数据包，在这个链中处理的数据包也尚未经过filter表中的INPUT或PREROUTING链的处理
POSTROUTING链负责处理经过内核中的路由算法确定传输的物理接口并即将从该接口出去的数据包，由这个链处理的数据包已通过filter表中的output或forward链的检查
### NAT rules
echo "[+]Setting up NAT rules..."
$IPTABLES -t nat -A PREROUTING -p tcp --dport 80 -i eth0 -j DNAT --to 192.168.10.3:80
$IPTABLES -t nat -A PREROUTING -p tcp --dport 443 -i eth0 -j DNAT --to 192.168.10.3:443
$IPTABLES -t nat -A PREROUTING -p tcp --dport 53 -i eth0 -j DNAT --to 192.168.10.4:53
$IPTABLES -t nat -A POSTROUTING -是￥INT_NET -o eth0 -j MASQUERAD
内网的web服务器和DNS服务器的ip地址分别为192.168.10.3、4，用于提供NAT功能的iptables命令，3个PREROUTING规则允许外网的web服务和DNS请求被发送给合适的内网服务器，在POSTROUTING规则允许来自内部不可路由网络并指向外部因特网的连接看起来就像他们来自IP地址71.157.X.X

构建iptable策略的最后一步实在linux内核中启用ip转发
###forwarding###
echo "[+] Enabling Ip forwarding..."
echo 1 > /proc/sys/net/ipv4/ip_forward

测试用到的命令 
hping
nc


iptables -A INPUT -s 127.0.0.1 -d 127.0.0.1 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -p tcp --dport 20 -j ACCEPT
iptables -A INPUT -p tcp --dport 3306 -j ACCEPT
iptables -A INPUT -p tcp --dport 5013 -j ACCEPT
iptables -A INPUT -p tcp --dport 34158 -j ACCEPT
#开启ping
iptables -A INPUT -p icmp --icmp-type 0 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 3 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 11 -j ACCEPT

#禁止其他未允许的规则访问
iptables -A INPUT -j REJECT
iptables -A FORWARD -j REJECT
#禁止IP段
iptables -I INPUT -s 1.202.0.0/16 -j DROP
iptables -I INPUT -s 111.13.0.0/16 -j DROP
iptables -I INPUT -s 65.52.0.0/16 -j DROP 
iptables -I INPUT -s 115.172.120.115 -j DROP
iptables -I INPUT -s 207.46.0.0/16 -j DROP 
iptables -I INPUT -s 157.55.0.0/16 -j DROP 
iptables -I INPUT -s 224.0.0.0/16 -j DROP
