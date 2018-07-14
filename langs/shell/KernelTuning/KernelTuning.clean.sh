#文件系统优化
echo "* - nofile 1048576" >> /etc/security/limits.conf
echo "speng soft nofile 1048576" >> /etc/security/limits.conf
echo "speng hard nofile 1048576" >> /etc/security/limits.conf
echo "session required /lib/security/pam_limits.so" >> /etc/pam.d/login

echo "kernel.pid_max = 65536" >> /etc/sysctl.conf

echo "fs.file-max = 1048576" >> /etc/sysctl.conf

echo "vm.min_free_kbytes = 65536" >> /etc/sysctl.conf
echo "vm.swappiness = 10" >> /etc/sysctl.conf

echo "net.core.somaxconn = 262144" >> /etc/sysctl.conf
echo "net.core.netdev_max_backlog = 262144" >> /etc/sysctl.conf
echo "net.ipv4.netfilter.ip_conntrack_tcp_timeout_established = 180" >> /etc/sysctl.conf
echo "net.ipv4.ip_conntrack_max = 655360" >> /etc/sysctl.conf
echo "net.ipv4.ip_local_port_range = 1024 65535" >> /etc/sysctl.conf

echo "net.ipv4.tcp_mem = 786432 512000 1024000" >> /etc/sysctl.conf
echo "net.ipv4.tcp_rmem = 4096 4096 33554432" >> /etc/sysctl.conf
echo "net.ipv4.tcp_wmem = 4096 4096 33554432" >> /etc/sysctl.conf

echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf

echo "net.ipv4.tcp_fin_timeout = 30" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_time = 1200" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_probes = 5" >> /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_intvl = 15" >> /etc/sysctl.conf

echo "net.ipv4.tcp_max_syn_backlog = 8192" >> /etc/sysctl.conf
echo "net.ipv4.tcp_max_tw_buckets = 819200" >> /etc/sysctl.conf

echo "net.ipv4.tcp_max_orphans = 262144" >> /etc/sysctl.conf
echo "net.ipv4.tcp_orphan_retries = 3" >> /etc/sysctl.conf
echo "net.ipv4.tcp_timestamps = 0" >> /etc/sysctl.conf
echo "net.ipv4.tcp_synack_retries = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_syn_retries = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_retries1 = 3" >> /etc/sysctl.conf
echo "net.ipv4.tcp_retries2 = 15" >> /etc/sysctl.conf
echo "net.ipv4.tcp_sack = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_fack = 1" >> /etc/sysctl.conf
echo "net.ipv4.tcp_window_scaling = 1" >> /etc/sysctl.conf

sysctl -p