# Logstash

## Config file

1. Pipeline Config File

path: /etc/logstash/conf.d/

logstash-simple.conf

```
input { 
    stdin { }
}
output {
  elasticsearch { hosts => ["localhost:9200"] }
  stdout { codec => rubydebug }
}
```

```sh
bin/logstash -f logstash-simple.conf
```

2. Setting Config File

* [logstash.yml](https://www.elastic.co/guide/en/logstash/current/logstash-settings-file.html)
* [pipelines.yml](https://www.elastic.co/guide/en/logstash/current/multiple-pipelines.html)
* jvm.options
* log4j2.properties
* startup.options (Linux)

