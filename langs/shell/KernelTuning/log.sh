

➜  hongbao-svc-sprint git:(feature/sprint) ✗ cat /proc/sys/net/core/somaxconn
128

echo 1024 > /proc/sys/net/core/somaxconn


➜  ~ cat /proc/sys/net/core/netdev_max_backlog
1000

echo 3000 > /proc/sys/net/core/netdev_max_backlog

➜  ~ cat /proc/sys/net/ipv4/tcp_max_syn_backlog
512
➜  ~ echo 5120 > /proc/sys/net/ipv4/tcp_max_syn_backlog

