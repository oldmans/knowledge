# docker container

## CLI

* docker container attach
* docker container commit
* docker container cp
* docker container create
* docker container diff
* docker container exec
* docker container export
* docker container inspect
* docker container kill
* docker container logs
* docker container ls
* docker container pause
* docker container port
* docker container prune
* docker container rename
* docker container restart
* docker container rm
* docker container run
* docker container start
* docker container stats
* docker container stop
* docker container top
* docker container unpause
* docker container update
* docker container wait

### docker run

```sh
docker run \
    --name redis \
    -p 127.0.0.1:6379:6379
    --expose 80 \
    -e MYVAR1 \
    --env MYVAR2=foo \
    --env-file ./env.list
    -l my-label \
    --label com.example.foo=bar \
    --label-file ./labels \
    --cidfile /tmp/docker_redis.cid \
    --privileged \
    --read-only \
    -v `pwd`:`pwd`
    -w /path/to/dir/ \
    --storage-opt size=120G \
    --tmpfs /run:rw,noexec,nosuid,size=65536k \
    --network=my-net \
    --ip=10.10.9.75 \
    --volumes-from 777f7dc92da7 \
    --volumes-from ba8c0c54f0f2:ro \
    --device=/dev/sdc:/dev/xvdc \
    --device=/dev/sdd \
    --device=/dev/zero:/dev/nulo \
    --add-host=docker:10.180.0.1 \
    --add-host=docker:10.180.0.1 \
    --ulimit nofile=1024:1024 \
    --sysctl net.ipv4.ip_forward=1
    -a stdin \
    -a stdout \
    -a stderr \
    -it \
    redis
```

docker run --cidfile /tmp/docker_redis.cid redis
