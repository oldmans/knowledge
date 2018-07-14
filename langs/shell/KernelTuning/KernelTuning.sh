#!/usr/bin/env bash
# 文件系统优化
# debain 不起作用
#echo "* - nofile 1048576" >> /etc/security/limits.conf
#echo "speng soft nofile 1048576" >> /etc/security/limits.conf
#echo "speng hard nofile 1048576" >> /etc/security/limits.conf
#echo "session required /lib/security/pam_limits.so" >> /etc/pam.d/login

# 修改用户进程可打开文件数限制
echo "ulimit -SHn 1024000" >> /etc/profile
source "/etc/profile"

# 系统所有进程一共可以打开的文件数量
echo "fs.file-max = 10485760" >> /etc/sysctl.conf

#echo "kernel.pid_max = 65536" >> /etc/sysctl.conf

# 关闭oom-killer
#echo "vm.oom-kill = 0" >> /etc/sysctl.conf
#echo "vm.min_free_kbytes = 65536" >> /etc/sysctl.conf

# 更大限度使用物理内存
echo "vm.swappiness = 10" >> /etc/sysctl.conf

# 设置系统中每一个端口最大的监听队列的长度
echo "net.core.somaxconn = 262144" >> /etc/sysctl.conf

# 已经完成三次握手、已经成功建立连接的套接字将要进入队列的长度
# 若设置的backlog值大于net.core.somaxconn值，将被置为net.core.somaxconn值大小
# 每个网络接口接收数据包的速率比内核处理这些包的速率快时，允许送到队列的数据包的最大数目，对重负载服务器而言，该值需要调高一点。
echo "net.core.netdev_max_backlog = 262144" >> /etc/sysctl.conf

# 默认的发送窗口大小（以字节为单位）
#echo "net.core.wmem_default = 129024" >> /etc/sysctl.conf
# 默认的接收窗口大小（以字节为单位）
#echo "net.core.rmem_default = 129024" >> /etc/sysctl.conf
# 最大的TCP数据接收缓冲
#echo "net.core.rmem_max = 873200" >> /etc/sysctl.conf
# 最大的TCP数据发送缓冲
#echo "net.core.wmem_max = 873200" >> /etc/sysctl.conf

######################################################################################
# 连接跟踪数据库的超时时间
#echo "net.ipv4.netfilter.ip_conntrack_tcp_timeout_established = 180" >> /etc/sysctl.conf
# 连接跟踪数据库的最大跟踪连接条目
#echo "net.ipv4.netfilter.ip_conntrack_max = 655360" >> /etc/sysctl.conf

#echo "net.ipv4.netfilter.ip_conntrack_tcp_timeout_time_wait = 120" >> /etc/sysctl.conf
#echo "net.ipv4.netfilter.ip_conntrack_tcp_timeout_close_wait = 60" >> /etc/sysctl.conf
#echo "net.ipv4.netfilter.ip_conntrack_tcp_timeout_fin_wait = 120" >> /etc/sysctl.conf

# 连接跟踪数据库的最大跟踪连接条目 需精打细算
echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.conf

# 反向路由过滤(rp_filter)
echo "net.ipv4.conf.all.rp_filter = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.rp_filter = 1" >> /etc/sysctl.conf

# 连接跟踪数据库的最大跟踪连接条目 需精打细算
echo "net.ipv4.ip_conntrack_max = 655360" >> /etc/sysctl.conf

# 本地端口范围
echo "net.ipv4.ip_local_port_range = 1024 65535" >> /etc/sysctl.conf

# TCP读写缓冲区设置
echo "net.ipv4.tcp_mem = 786432 512000 1024000" >> /etc/sysctl.conf
echo "net.ipv4.tcp_rmem = 4096 4096 16456252" >> /etc/sysctl.conf
echo "net.ipv4.tcp_wmem = 4096 4096 16456252" >> /etc/sysctl.conf

# 防范SYN DDOS攻击
# 只有在内核编译时选择了CONFIG_SYNCOOKIES时才会发生作用。当出现syn等候队列出现溢出时象对方发送syncookies。目的是为了防止syn flood攻击。
echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf

# 以一种比重发超时更精确的方法（请参阅 RFC 1323）来启用对 RTT 的计算；为了实现更好的性能应该启用这个选项。
# Timestamps 用在其它一些东西中﹐可以防范那些伪造的 sequence 号码。
echo "net.ipv4.tcp_timestamps = 0" >> /etc/sysctl.conf

# tw_reuse，tw_recycle 必须在客户端和服务端timestamps开启时才管用（默认打开）
# 表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0。
# 只对客户端起作用，开启后客户端在1s内回收
echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf

# 表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0。
# 对客户端和服务器同时起作用，开启后在 3.5*RTO 内回收，RTO 200ms~ 120s 具体时间视网络状况。
# 线上环境 tw_recycle 不要打开
# 请不要随意修改这个值
echo "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf

# 对于本端断开的socket连接,TCP保持在FIN-WAIT-2状态的时间。
# 对方可能会断开连接或一直不结束连接或不可预料的进程死亡。默认值为 60 秒。
echo "net.ipv4.tcp_fin_timeout = 30" >> /etc/sysctl.conf

# 当keepalive打开的情况下,TCP发送keepalive消息的频率。
# 用于确认TCP连接是否有效。防止两边建立连接但不发送数据的攻击。
echo "net.ipv4.tcp_keepalive_time = 1200" >> /etc/sysctl.conf

# TCP发送keepalive探测以确定该连接已经断开的次数。
# 在认定连接失效之前，发送多少个TCP的keepalive探测包。
# 缺省值是9，这个值乘以tcp_keepalive_intvl之后决定了，一个连接发送了keepalive之后可以有多少时间没有回应。
echo "net.ipv4.tcp_keepalive_probes = 5" >> /etc/sysctl.conf

# 探测消息未获得响应时，重发该消息的间隔时间（秒）。
# 默认值为75秒。 (对于普通应用来说,这个值有一些偏大,可以根据需要改小.特别是web类服务器需要改小该值,15是个比较合适的值)
echo "net.ipv4.tcp_keepalive_intvl = 15" >> /etc/sysctl.conf

# 对于那些依然还未获得客户端确认的连接请求队列的长度。
echo "net.ipv4.tcp_max_syn_backlog = 8192" >> /etc/sysctl.conf

# 系统在同时所处理的最大 TIME_WAIT sockets 数目。
# 如果超过此数的话﹐time-wait socket 会被立即砍除并且显示警告信息。
# 之所以要设定这个限制﹐纯粹为了抵御那些简单的 DoS 攻击﹐不过﹐如果网络条件需要比默认值更多﹐则可以提高它(或许还要增加内存)。
# (事实上做NAT的时候最好可以适当地增加该值)
echo "net.ipv4.tcp_max_tw_buckets = 819200" >> /etc/sysctl.conf

# 系统所能处理的不属于任何TCP socket的最大数量 不要轻易修改默认值
# 系统所能处理不属于任何进程的TCP sockets最大数量。
# 假如超过这个数量﹐那么不属于任何进程的连接会被立即reset，并同时显示警告信息。
# 之所以要设定这个限制﹐纯粹为了抵御那些简单的 DoS 攻击﹐千万不要依赖这个或是人为的降低这个限制。
# 如果内存大更应该增加这个值。(这个值Redhat AS版本中设置为32768,但是很多防火墙修改的时候,建议该值修改为2000)
echo "net.ipv4.tcp_max_orphans = 262144" >> /etc/sysctl.conf

# 在近端丢弃TCP连接之前的重试次数
# 默认值是7个﹐相当于 50秒 - 16分钟﹐视 RTO 而定。
# 如果您的系统是负载很大的web服务器﹐那么也许需要降低该值﹐这类sockets可能会耗费大量的资源。
# 另外参的考tcp_max_orphans。
# (事实上做NAT的时候,降低该值也是好处显著的,我本人的网络环境中降低该值为3)
# 主要是针对孤立的socket(也就是已经从进程上下文中删除了，可是还有一些清理工作没有完成).对于这种socket，我们重试的最大的次数就是它。
# http://bbs.chinaunix.net/forum.php?mod=viewthread&action=printable&tid=4096588
echo "net.ipv4.tcp_orphan_retries = 3" >> /etc/sysctl.conf

# 对于一个新建连接,内核要发送多少个 SYN 连接请求才决定放弃。
# 不应该大于255，默认值是5，对应于180秒左右时间。
# 对于大负载而物理通信良好的网络而言,这个值偏高,可修改为2.
# 这个值仅仅是针对对外的连接,对进来的连接,是由tcp_retries1决定的
echo "net.ipv4.tcp_syn_retries = 1" >> /etc/sysctl.conf

# 对于一个新建连接,内核要发送多少个 SYNACK 连接请求才决定放弃。
# 对于远端的连接请求SYN，内核会发送SYN ＋ ACK数据报，以确认收到上一个 SYN连接请求包。
# 这是所谓的三次握手( threeway handshake)机制的第二个步骤。
# 这里决定内核在放弃连接之前所送出的 SYN+ACK 数目。
# 不应该大于255，默认值是5，对应于180秒左右时间。
echo "net.ipv4.tcp_synack_retries = 1" >> /etc/sysctl.conf

# 放弃回应一个TCP连接请求前﹐需要进行多少次重试.RFC 规定最低的数值是3
echo "net.ipv4.tcp_retries1 = 3" >> /etc/sysctl.conf

# 在丢弃激活(已建立通讯状况)的TCP连接之前﹐需要进行多少次重试。
# 默认值为15，根据RTO的值来决定，相当于13-30分钟(RFC1122规定，必须大于100秒).
# 这个值根据目前的网络设置,可以适当地改小,我的网络内修改为了5
echo "net.ipv4.tcp_retries2 = 15" >> /etc/sysctl.conf


# 启用有选择的应答（Selective Acknowledgment），
# 这可以通过有选择地应答乱序接收到的报文来提高性能（这样可以让发送者只发送丢失的报文段）；
# （对于广域网通信来说）这个选项应该启用，但是这会增加对 CPU 的占用。
echo "net.ipv4.tcp_sack = 1" >> /etc/sysctl.conf

# 启用转发应答（Forward Acknowledgment），这可以进行有选择应答（SACK）从而减少拥塞情况的发生；这个选项也应该启用。
# 打开FACK拥塞避免和快速重传功能。(注意，当tcp_sack设置为0的时候，这个值即使设置为1也无效)[这个是TCP连接靠谱的核心功能]
echo "net.ipv4.tcp_fack = 1" >> /etc/sysctl.conf

# 允许TCP发送"两个完全相同"的SACK。
echo "net.ipv4.tcp_dsack = 1" >> /etc/sysctl.conf

# TCP的直接拥塞通告功能。
echo "net.ipv4.tcp_ecn = 1" >> /etc/sysctl.conf

# TCP流中重排序的数据报最大数量。 (一般有看到推荐把这个数值略微调整大一些,比如5)
echo "net.ipv4.tcp_reordering = 1" >> /etc/sysctl.conf


# TCP滑动窗口大小是否可变
# 该文件表示设置tcp/ip会话的滑动窗口大小是否可变。参数值为布尔值，为1时表示可变，为0时表示不可变。
# tcp/ip通常使用的窗口最大可达到 65535 字节，对于高速网络，该值可能太小，
# 这时候如果启用了该功能，可以使tcp/ip滑动窗口大小增大数个数量级，从而提高数据传输的能力(RFC 1323)。
#（对普通地百M网络而言，关闭会降低开销，所以如果不是高速网络，可以考虑设置为0）
echo "net.ipv4.tcp_window_scaling = 1" >> /etc/sysctl.conf

# 当守护进程太忙而不能接受新的连接，就象对方发送reset消息，默认值是false。
# 这意味着当溢出的原因是因为一个偶然的猝发，那么连接将恢复状态。
# 只有在你确信守护进程真的不能完成连接请求时才打开该选项，该选项会影响客户的使用。
# (对待已经满载的sendmail,apache这类服务的时候,这个可以很快让客户端终止连接,可以给予服务程序处理已有连接的缓冲机会,
# 所以很多防火墙上推荐打开它)
echo "net.ipv4.tcp_abort_on_overflow = 1" >> /etc/sysctl.conf


sysctl -p
