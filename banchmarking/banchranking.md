# b

https://ruby-china.org/topics/26221
https://ruby-china.org/topics/27121

https://dearhwj.gitbooks.io/itbook/content/test/performance_test_qps_tps.html
http://colobu.com/2014/08/04/Apache-Bench-and-Gnuplot/
https://gist.github.com/garethrees/7356890
http://www.bradlanders.com/2013/04/15/apache-bench-and-gnuplot-youre-probably-doing-it-wrong/
http://www.xmeter.net/wordpress/?p=261
http://www.58maisui.com/2016/08/18/107/
https://docs.newrelic.com/docs/apm/new-relic-apm/apdex/apdex-measuring-user-satisfaction
https://jysperm.me/2016/12/qps-and-concurrent-connections/

http://www.cnblogs.com/zhengah/p/4334314.html
http://blog.liujiangbei.com/14843968184619.html

## 指标

一、吞吐率 QPS

我们一般使用单位时间内服务器处理的请求数来描述其并发处理能力。称之为吞吐率（Throughput），单位是 “req/s”。吞吐率特指Web服务器单位时间内处理的请求数。

另一种描述，吞吐率是，单位时间内网络上传输的数据量，也可以指单位时间内处理客户请求数量。它是衡量网络性能的重要指标。通常情况下，吞吐率“字节数/秒”来衡量。当然你也可以用“请求数/秒”和“页面数/秒”来衡量。其实不管一个请求还是一个页面，它的本质都是在网络上传输的数据，那么用来表述数据的单位就是字节数。

二、吞吐量

吞吐量，是指在一次性能测试过程中网络上传输的数据量的总和。

　　对于交互式应用来说，吞吐量指标反映的是服务器承受的压力，在容量规划的测试中，吞吐量是一个重点关注的指标，因为它能够说明系统级别的负载能力，另外，在性能调优过程中，吞吐量指标也有重要的价值。如一个大型工厂，他们的生产效率与生产速度很快，一天生产10W吨的货物，结果工厂的运输能力不行，就两辆小型三轮车一天拉2吨的货物，比喻有些夸张，但我想说明的是这个运输能力是整个系统的瓶颈。

　　提示，用吞吐量来衡量一个系统的输出能力是极其不准确的，用个最简单的例子说明，一个水龙头开一天一夜，流出10吨水；10个水龙头开1秒钟，流出0.1吨水。当然是一个水龙头的吞吐量大。你能说1个水龙头的出水能力是10个水龙头的强？所以，我们要加单位时间，看谁1秒钟的出水量大。这就是吞吐率。

三、事务，TPS(Transaction Per second)

就是用户某一步或几步操作的集合。不过，我们要保证它有一个完整意义。比如用户对某一个页面的一次请求，用户对某系统的一次登录，淘宝用户对商品的一次确认支付过程。这些我们都可以看作一个事务。那么如何衡量服务器对事务的处理能力。又引出一个概念----TPS

每秒钟系统能够处理事务或交易的数量，它是衡量系统处理能力的重要指标。

点击率可以看做是TPS的一种特定情况。点击率更能体现用户端对服务器的压力。TPS更能体现服务器对客户请求的处理能力。

每秒钟用户向web服务器提交的HTTP请求数。这个指标是web 应用特有的一个指标；web应用是“请求-响应”模式，用户发一个申请，服务器就要处理一次，所以点击是web应用能够处理的交易的最小单位。如果把每次点击定义为一个交易，点击率和TPS就是一个概念。容易看出，点击率越大。对服务器的压力也越大，点击率只是一个性能参考指标，重要的是分析点击时产生的影响。

需要注意的是，这里的点击不是指鼠标的一次“单击”操作，因为一次“单击”操作中，客户端可能向服务器发现多个HTTP请求。

四、吞吐量、吞吐率的意义

吞吐量的限制是性能瓶颈的一种重要表现形式，因此，有针对地对吞吐量设计测试，可以协助尽快定位到性能冰晶所在的位置
80%系统的性能瓶颈都是由吞吐量制约
并发用户和吞吐量瓶颈之间存在一定的关联
通过不断增加并发用户数和吞吐量观察系统的性能瓶颈。然后，从网络、数据库、应用服务器和代码本身4个环节确定系统的性能瓶颈。

五、吞吐率 和 压力测试

单从定义来看，吞吐率描述了服务器在实际运行期间单位时间内处理的请求数，然而，我们更加关心的是服务器并发处理能力的上限，也就是单位时间内服务器能够处理的最大请求数，即最大吞吐率。

所以我们普遍使用“压力测试”的方法，通过模拟足够多数目的并发用户，分别持续发送一定的HTTP请求，并统计测试持续的总时间，计算出基于这种“压力”下的吞吐率，即为一个平均计算值

六、压力测试的前提

吞吐率性能测试的前提

并发用户数
总请求数
请求资源描述

压力测试的描述一般包括两个部分，即 并发用户数 和 总请求数，也就是模拟多少用户同时向服务器发送多少请求。

请求性质则是对请求的URL所代表的资源的描述，比如1KB大小的静态文件，或者包含10次数据库查询的动态内容等。

1、 并发用户数

并发用户数就是指在某一时刻同时向服务器发送请求的用户总数。

假如100个用户同时向服务器分别进行10次请求，与1个用户向服务器连续进行1000次请求。两个的效果一样么？

一个用户向服务器连续进行1000次请求的过程中，任何时刻服务器的网卡接受缓存区中只有来自该用户的1个请求，而100个用户同时向服务器分别进行10次请求的过程中，服务器网卡接收缓冲区中最多有100个等待处理的请求，显然这时候服务器的压力更大。

经常有人说某个Web服务器能支持多少并发数，除此之外没有任何上下文，这让很多人摸不着头脑，人们常常把并发用户数和吞吐率混淆，他们并不是一回事。

一个服务器最多支持多少并发用户数呢？

可见，通常所讲的最大并发数是有一定利益前提的，那就是服务器和用户双方所期待的最大收益，服务器希望支持高并发数及高吞吐率，而用户不管那么多，只希望等待较少的时间，或者得到更快的下载速度。


## apdex

## 计算

QPS

单个进程每秒请求服务器成功的次数
req/sec = 总请求数 /（进程总数 * 请求时间）
一般使用http_load进行统计
每台服务器每天的PV

(QPS x 3600 x 6)或者乘以8小时
一天按照6或者8小时计算，晚上可能没人访问
服务器计算

ceil(每天总PV / 单台服务器每天总PV)
峰值时间

每天80%的访问集中在20%的时间里，这20%时间叫做峰值时间
峰值QPS

( 总PV数 x 80% ) / ( 每天秒数 x 20% )
服务器计算

ceil(峰值QPS / 单台机器的QPS)
问：每天300w PV 的在单台机器上，这台机器需要多少QPS？ 答：( 3000000 x 0.8 ) / (86400 x 0.2 ) = 139 (QPS)

问：如果一台机器的QPS是58，需要几台机器来支持？ 答：139 / 58 = 3

## 测试工具

https://github.com/gotwarlost/istanbul
https://software.microfocus.com/en-us/software/loadrunner
https://github.com/tsenart/vegeta
https://github.com/locustio/locust
https://github.com/apache/jmeter
https://github.com/loadimpact/k6
https://github.com/session-replay-tools/tcpcopy
https://github.com/buger/goreplay
https://github.com/gatling/gatling
https://github.com/newsapps/beeswithmachineguns
https://github.com/atinfo/awesome-test-automation
https://github.com/goadapp/goad
https://github.com/JoeDog/siege
https://github.com/rakyll/hey

https://github.com/wg/wrk
ab

http://tsung.erlang-projects.org/
http://wetest.qq.com/


```

```sh
➜  ~ ab -c 500 -n 5000 http://10.10.50.107:18080/hongbao/sprint/status\?now\=2018-01-15T11:29:50.000Z\&userId\=5990091d6336d05d55743173
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 10.10.50.107 (be patient)
Completed 500 requests
Completed 1000 requests
Completed 1500 requests
Completed 2000 requests
Completed 2500 requests
Completed 3000 requests
Completed 3500 requests
Completed 4000 requests
Completed 4500 requests
Completed 5000 requests
Finished 5000 requests


Server Software:        hb1.zs-13435
Server Hostname:        10.10.50.107
Server Port:            18080

Document Path:          /hongbao/sprint/status?now=2018-01-15T11:29:50.000Z&userId=5990091d6336d05d55743173
Document Length:        5744 bytes

Concurrency Level:      500
Time taken for tests:   22.010 seconds
Complete requests:      5000
Failed requests:        0
Write errors:           0
Total transferred:      30903879 bytes
HTML transferred:       28720000 bytes
Requests per second:    227.17 [#/sec] (mean)
Time per request:       2200.964 [ms] (mean)
Time per request:       4.402 [ms] (mean, across all concurrent requests)
Transfer rate:          1371.20 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0  324 1119.9      1    7017
Processing:    27 1820 436.7   1977    2801
Waiting:        5 1755 443.7   1918    2688
Total:         28 2144 1191.2   2004    9148

Percentage of the requests served within a certain time (ms)
  50%   2004
  66%   2126
  75%   2170
  80%   2174
  90%   2515
  95%   4341
  98%   5159
  99%   9136
 100%   9148 (longest request)
```

```sh
➜  ~ ab -c 500 -n 10000 http://10.10.50.107:18080/hongbao/sprint/status\?now\=2018-01-15T11:29:50.000Z\&userId\=5990091d6336d05d55743173
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 10.10.50.107 (be patient)
Completed 1000 requests
Completed 2000 requests
Completed 3000 requests
Completed 4000 requests
Completed 5000 requests
Completed 6000 requests
Completed 7000 requests
Completed 8000 requests
Completed 9000 requests
Completed 10000 requests
Finished 10000 requests


Server Software:        hb1.zs-13435
Server Hostname:        10.10.50.107
Server Port:            18080

Document Path:          /hongbao/sprint/status?now=2018-01-15T11:29:50.000Z&userId=5990091d6336d05d55743173
Document Length:        5744 bytes

Concurrency Level:      500
Time taken for tests:   46.981 seconds
Complete requests:      10000
Failed requests:        0
Write errors:           0
Total transferred:      61809903 bytes
HTML transferred:       57440000 bytes
Requests per second:    212.85 [#/sec] (mean)
Time per request:       2349.037 [ms] (mean)
Time per request:       4.698 [ms] (mean, across all concurrent requests)
Transfer rate:          1284.81 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   60 289.6      1    3008
Processing:    27 2265 308.1   2303    2815
Waiting:       12 2198 311.5   2241    2789
Total:         28 2325 350.7   2322    5238

Percentage of the requests served within a certain time (ms)
  50%   2322
  66%   2415
  75%   2472
  80%   2516
  90%   2624
  95%   2729
  98%   2957
  99%   3031
 100%   5238 (longest request)
```

```sh
➜  ~ ab -c 500 -n 10000 http://10.10.50.107:18080/hongbao/sprint/status\?now\=2018-01-15T11:29:50.000Z\&userId\=5990091d6336d05d55743173
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 10.10.50.107 (be patient)
Completed 1000 requests
Completed 2000 requests
Completed 3000 requests
Completed 4000 requests
Completed 5000 requests
Completed 6000 requests
Completed 7000 requests
Completed 8000 requests
Completed 9000 requests
Completed 10000 requests
Finished 10000 requests


Server Software:        hb1.zs-24098
Server Hostname:        10.10.50.107
Server Port:            18080

Document Path:          /hongbao/sprint/status?now=2018-01-15T11:29:50.000Z&userId=5990091d6336d05d55743173
Document Length:        5744 bytes

Concurrency Level:      500
Time taken for tests:   41.611 seconds
Complete requests:      10000
Failed requests:        0
Write errors:           0
Total transferred:      61809915 bytes
HTML transferred:       57440000 bytes
Requests per second:    240.32 [#/sec] (mean)
Time per request:       2080.567 [ms] (mean)
Time per request:       4.161 [ms] (mean, across all concurrent requests)
Transfer rate:          1450.60 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   68 329.2      1    3009
Processing:    34 1992 150.5   2007    2367
Waiting:       18 1940 155.9   1964    2320
Total:         35 2059 362.7   2018    5075

Percentage of the requests served within a certain time (ms)
  50%   2018
  66%   2062
  75%   2095
  80%   2104
  90%   2173
  95%   2739
  98%   3098
  99%   3369
 100%   5075 (longest request)
```


```sh
➜  ~ ab -c 1000 -n 10000 http://10.10.50.107:18080/hongbao/sprint/status\?now\=2018-01-15T11:29:50.000Z\&userId\=5990091d6336d05d55743173
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 10.10.50.107 (be patient)
Completed 1000 requests
Completed 2000 requests
Completed 3000 requests
Completed 4000 requests
Completed 5000 requests
Completed 6000 requests
Completed 7000 requests
Completed 8000 requests
Completed 9000 requests
Completed 10000 requests
Finished 10000 requests


Server Software:        hb1.zs-24098
Server Hostname:        10.10.50.107
Server Port:            18080

Document Path:          /hongbao/sprint/status?now=2018-01-15T11:29:50.000Z&userId=5990091d6336d05d55743173
Document Length:        5744 bytes

Concurrency Level:      1000
Time taken for tests:   40.808 seconds
Complete requests:      10000
Failed requests:        0
Write errors:           0
Total transferred:      61808529 bytes
HTML transferred:       57440000 bytes
Requests per second:    245.05 [#/sec] (mean)
Time per request:       4080.813 [ms] (mean)
Time per request:       4.081 [ms] (mean, across all concurrent requests)
Transfer rate:          1479.11 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0  698 2794.8      2   31052
Processing:    40 2569 787.7   2943    3932
Waiting:        5 2494 767.9   2882    3822
Total:         41 3267 2957.3   3104   34804

Percentage of the requests served within a certain time (ms)
  50%   3104
  66%   3203
  75%   3256
  80%   3395
  90%   3655
  95%   8987
  98%  17912
  99%  18506
 100%  34804 (longest request)
```

Node * 8

```
➜  ~ ab -c 100 -n 1000 http://10.10.50.107:18080/hongbao/sprint/status\?now\=2018-01-15T11:29:50.000Z\&userId\=5990091d6336d05d55743173
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 10.10.50.107 (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Completed 600 requests
Completed 700 requests
Completed 800 requests
Completed 900 requests
Completed 1000 requests
Finished 1000 requests


Server Software:        hb1.zs-5078
Server Hostname:        10.10.50.107
Server Port:            18080

Document Path:          /hongbao/sprint/status?now=2018-01-15T11:29:50.000Z&userId=5990091d6336d05d55743173
Document Length:        5744 bytes

Concurrency Level:      100
Time taken for tests:   1.853 seconds
Complete requests:      1000
Failed requests:        0
Write errors:           0
Total transferred:      6178045 bytes
HTML transferred:       5744000 bytes
Requests per second:    539.60 [#/sec] (mean)
Time per request:       185.324 [ms] (mean)
Time per request:       1.853 [ms] (mean, across all concurrent requests)
Transfer rate:          3255.51 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    1   1.7      0      10
Processing:    23  173  52.6    164     452
Waiting:       20  171  52.4    163     451
Total:         24  173  52.4    165     452

Percentage of the requests served within a certain time (ms)
  50%    165
  66%    182
  75%    194
  80%    202
  90%    237
  95%    276
  98%    327
  99%    371
 100%    452 (longest request)
```

```sh
➜  ~ ab -c 100 -n 10000 http://10.10.50.107:18080/hongbao/sprint/status\?now\=2018-01-15T11:29:50.000Z\&userId\=5990091d6336d05d55743173
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 10.10.50.107 (be patient)
Completed 1000 requests
Completed 2000 requests
Completed 3000 requests
Completed 4000 requests
Completed 5000 requests
Completed 6000 requests
Completed 7000 requests
Completed 8000 requests
Completed 9000 requests
Completed 10000 requests
Finished 10000 requests


Server Software:        hb1.zs-5054
Server Hostname:        10.10.50.107
Server Port:            18080

Document Path:          /hongbao/sprint/status?now=2018-01-15T11:29:50.000Z&userId=5990091d6336d05d55743173
Document Length:        5744 bytes

Concurrency Level:      100
Time taken for tests:   11.936 seconds
Complete requests:      10000
Failed requests:        0
Write errors:           0
Total transferred:      61777662 bytes
HTML transferred:       57440000 bytes
Requests per second:    837.82 [#/sec] (mean)
Time per request:       119.357 [ms] (mean)
Time per request:       1.194 [ms] (mean, across all concurrent requests)
Transfer rate:          5054.55 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.4      0      12
Processing:     7  118  32.5    111     398
Waiting:        7  117  32.3    110     396
Total:         11  119  32.5    111     398

Percentage of the requests served within a certain time (ms)
  50%    111
  66%    122
  75%    130
  80%    136
  90%    158
  95%    183
  98%    213
  99%    231
 100%    398 (longest request)
```


```sh
➜  ~ ab -c 500 -n 10000 http://10.10.50.107:18080/hongbao/sprint/status\?now\=2018-01-15T11:29:50.000Z\&userId\=5990091d6336d05d55743173
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 10.10.50.107 (be patient)
Completed 1000 requests
Completed 2000 requests
Completed 3000 requests
Completed 4000 requests
Completed 5000 requests
Completed 6000 requests
Completed 7000 requests
Completed 8000 requests
Completed 9000 requests
Completed 10000 requests
Finished 10000 requests


Server Software:        hb1.zs-5012
Server Hostname:        10.10.50.107
Server Port:            18080

Document Path:          /hongbao/sprint/status?now=2018-01-15T11:29:50.000Z&userId=5990091d6336d05d55743173
Document Length:        5744 bytes

Concurrency Level:      500
Time taken for tests:   12.391 seconds
Complete requests:      10000
Failed requests:        0
Write errors:           0
Total transferred:      61778843 bytes
HTML transferred:       57440000 bytes
Requests per second:    807.03 [#/sec] (mean)
Time per request:       619.552 [ms] (mean)
Time per request:       1.239 [ms] (mean, across all concurrent requests)
Transfer rate:          4868.91 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    3  41.3      0    1002
Processing:    22  602  91.1    610     910
Waiting:        6  602  91.1    609     909
Total:         22  605  99.8    610    1736

Percentage of the requests served within a certain time (ms)
  50%    610
  66%    637
  75%    652
  80%    662
  90%    687
  95%    706
  98%    738
  99%    767
 100%   1736 (longest request)
```

```sh
➜  ~ ab -c 1000 -n 10000 http://10.10.50.107:18080/hongbao/sprint/status\?now\=2018-01-15T11:29:50.000Z\&userId\=5990091d6336d05d55743173
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 10.10.50.107 (be patient)
Completed 1000 requests
Completed 2000 requests
Completed 3000 requests
Completed 4000 requests
Completed 5000 requests
Completed 6000 requests
Completed 7000 requests
Completed 8000 requests
Completed 9000 requests
Completed 10000 requests
Finished 10000 requests


Server Software:        hb1.zs-5078
Server Hostname:        10.10.50.107
Server Port:            18080

Document Path:          /hongbao/sprint/status?now=2018-01-15T11:29:50.000Z&userId=5990091d6336d05d55743173
Document Length:        5744 bytes

Concurrency Level:      1000
Time taken for tests:   10.240 seconds
Complete requests:      10000
Failed requests:        0
Write errors:           0
Total transferred:      61777759 bytes
HTML transferred:       57440000 bytes
Requests per second:    976.52 [#/sec] (mean)
Time per request:       1024.049 [ms] (mean)
Time per request:       1.024 [ms] (mean, across all concurrent requests)
Transfer rate:          5891.30 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    2   6.8      0      29
Processing:    42  975 175.2    995    1459
Waiting:       16  974 175.3    994    1459
Total:         46  977 171.1    996    1477

Percentage of the requests served within a certain time (ms)
  50%    996
  66%   1020
  75%   1039
  80%   1056
  90%   1141
  95%   1231
  98%   1279
  99%   1313
 100%   1477 (longest request)
```

```sh
➜  ~ ab -c 2000 -n 10000 http://10.10.50.107:18080/hongbao/sprint/status\?now\=2018-01-15T11:29:50.000Z\&userId\=5990091d6336d05d55743173
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 10.10.50.107 (be patient)
Completed 1000 requests
Completed 2000 requests
Completed 3000 requests
Completed 4000 requests
Completed 5000 requests
Completed 6000 requests
Completed 7000 requests
Completed 8000 requests
Completed 9000 requests
Completed 10000 requests
Finished 10000 requests


Server Software:        hb1.zs-5078
Server Hostname:        10.10.50.107
Server Port:            18080

Document Path:          /hongbao/sprint/status?now=2018-01-15T11:29:50.000Z&userId=5990091d6336d05d55743173
Document Length:        5744 bytes

Concurrency Level:      2000
Time taken for tests:   11.245 seconds
Complete requests:      10000
Failed requests:        0
Write errors:           0
Total transferred:      61777619 bytes
HTML transferred:       57440000 bytes
Requests per second:    889.30 [#/sec] (mean)
Time per request:       2248.963 [ms] (mean)
Time per request:       1.124 [ms] (mean, across all concurrent requests)
Transfer rate:          5365.11 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   16  83.9      0    1004
Processing:    54 1953 575.7   2100    2818
Waiting:        5 1952 575.7   2099    2818
Total:         69 1970 563.7   2102    2985

Percentage of the requests served within a certain time (ms)
  50%   2102
  66%   2143
  75%   2244
  80%   2271
  90%   2632
  95%   2700
  98%   2722
  99%   2750
 100%   2985 (longest request)
```

```sh
➜  ~ ab -c 3000 -n 20000 http://10.10.50.107:18080/hongbao/sprint/status\?now\=2018-01-15T11:29:50.000Z\&userId\=5990091d6336d05d55743173
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 10.10.50.107 (be patient)
Completed 2000 requests
Completed 4000 requests
Completed 6000 requests
Completed 8000 requests
Completed 10000 requests
Completed 12000 requests
Completed 14000 requests
Completed 16000 requests
Completed 18000 requests
Completed 20000 requests
Finished 20000 requests


Server Software:        hb1.zs-5012
Server Hostname:        10.10.50.107
Server Port:            18080

Document Path:          /hongbao/sprint/status?now=2018-01-15T11:29:50.000Z&userId=5990091d6336d05d55743173
Document Length:        5744 bytes

Concurrency Level:      3000
Time taken for tests:   25.852 seconds
Complete requests:      20000
Failed requests:        0
Write errors:           0
Total transferred:      123557215 bytes
HTML transferred:       114880000 bytes
Requests per second:    773.63 [#/sec] (mean)
Time per request:       3877.822 [ms] (mean)
Time per request:       1.293 [ms] (mean, across all concurrent requests)
Transfer rate:          4667.36 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   19  77.1      0    1003
Processing:    89 3532 859.2   3661    4681
Waiting:        6 3531 859.2   3660    4681
Total:        122 3551 837.5   3664    5063

Percentage of the requests served within a certain time (ms)
  50%   3664
  66%   3874
  75%   4097
  80%   4236
  90%   4312
  95%   4359
  98%   4470
  99%   4513
 100%   5063 (longest request)
```


2018-01-25

```sh
➜  ~ ab -c 1000 -n 100000 http://10.10.50.107:18080/hongbao/sprint/status\?userId\=58c91992018cfb74438af20b
This is ApacheBench, Version 2.3 <$Revision: 1430300 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 10.10.50.107 (be patient)
Completed 10000 requests
Completed 20000 requests
Completed 30000 requests
Completed 40000 requests
Completed 50000 requests
Completed 60000 requests
Completed 70000 requests
Completed 80000 requests
Completed 90000 requests
Completed 100000 requests
Finished 100000 requests


Server Software:        hb1.zs-26050
Server Hostname:        10.10.50.107
Server Port:            18080

Document Path:          /hongbao/sprint/status?userId=58c91992018cfb74438af20b
Document Length:        119 bytes

Concurrency Level:      1000
Time taken for tests:   30.825 seconds
Complete requests:      100000
Failed requests:        0
Write errors:           0
Total transferred:      55001132 bytes
HTML transferred:       11900000 bytes
Requests per second:    3244.07 [#/sec] (mean)
Time per request:       308.255 [ms] (mean)
Time per request:       0.308 [ms] (mean, across all concurrent requests)
Transfer rate:          1742.46 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0   10  88.1      0    3015
Processing:    13  296  77.5    277    1136
Waiting:        4  295  76.8    276    1135
Total:         40  307 123.2    281    3368

Percentage of the requests served within a certain time (ms)
  50%    281
  66%    308
  75%    328
  80%    344
  90%    422
  95%    452
  98%    496
  99%    549
 100%   3368 (longest request)
```

分布式版Redis的QPS限制是多少？
基准测试数据（非批量请求）：

key大小为128B，value大小为100B，并发连接数为1000；

1G: 读QPS可以达到3000，写QPS可以达到3000；

20G: 读QPS可以达到60000，写QPS可以达到20000；

内存实例性能和内存容量成线性关系，单个IP最高支持6万QPS，高于此值需要同时两个或多个IP。



```

