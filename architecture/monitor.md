# Monitor

指标：系统吞吐量、TPS（QPS）、用户并发量、性能测试概念和公式

## Hardware

* 负载监控：1分钟、3分钟、5分钟
* CPU空闲使用率
* 剩余内存
* 可用内存
* 网络监控：网卡出入流量
* 系统盘使用监控
* 数据磁盘使用监控
* 总体监控数据
* 共享流量监控

## Software

* 服务器硬件监控
* 通用软件资源使用监控：网络连接数、文件描述符、进程数...

### 消息队列

* 处理速率
* 消息积压

### MySQL

* [MySQL 监控指标](https://jin-yang.github.io/post/mysql-monitor.html)
* [MySQL 性能监控4大指标——第一部分](http://blog.oneapm.com/apm-tech/754.html)
* [MySQL 性能监控4大指标——第二部分](http://blog.oneapm.com/apm-tech/755.html)
* [MySQL 监控指标](http://www.nathanyan.com/2016/06/03/MySQL-%E7%9B%91%E6%8E%A7%E6%8C%87%E6%A0%87/)

* 当前总连接数
* 正在运行的连接数
* QPS每秒查询数
* QPS_SELECT
* QPS_INSERT
* QPS_UPDATE
* QPS_REMOVE
* TPS每秒事务数
* 慢查询数量
* 主从同步延迟
* 事务：未提交事务数
* 事务：挂起事务数
* `InnoDB_Buffer_pool`使用率
* `InnoDB_Buffer_pool`命中率
* 临时表数量
* 磁盘临时表数量
* InnoDB打开文件数
* 当前打开表的数量
* 打开过的表的数量
* 立即释放的表锁数量
* 表级锁等待次数
* InnoDB行级锁等待次数
* InnoDB行级锁平均等待时间
* 接收字节数
* 发送字节数
* 主库端口监控
* 从库端口监控

