# docker swarm

## CLI

### swarm

* docker swarm init [OPTIONS]
* docker swarm join [OPTIONS] HOST:PORT
* docker swarm join-token [OPTIONS] (worker|manager)
* docker swarm leave [OPTIONS]
* docker swarm unlock
* docker swarm unlock-key [OPTIONS]
* docker swarm update [OPTIONS]
* docker swarm ca [OPTIONS]

### node

* docker node promote
* docker node demote
* docker node inspect
* docker node ls
* docker node ps
* docker node rm
* docker node update

docker node update --availability drain
docker node update --label-add foo --label-add bar=baz node-1
docker node update --label-rm foo --label-add bar=baz node-1
docker node update --role worker|manager
docker node promote node-3 node-2
docker node demote node-3 node-2

### service

* docker service create
* docker service rm
* docker service inspect
* docker service scale
* docker service update
* docker service logs
* docker service ls
* docker service ps

### stack

* docker stack deploy
* docker stack rm
* docker stack services
* docker stack ls
* docker stack ps

### config

* docker config create
* docker config rm
* docker config inspect
* docker config ls

### secret

* docker secret create
* docker secret rm
* docker secret inspect
* docker secret ls

### network

* docker network create
* docker network rm
* docker network inspect
* docker network ls
* docker network prune
* docker network connect
* docker network disconnect

docker network ls
docker network disconnect bridge networktest
docker network connect my-bridge-network web
docker network create -d bridge my-bridge-network
docker run -d --net=my-bridge-network --name db training/postgres

### volume

* docker volume ls
* docker volume create
* docker volume inspect
* docker volume rm
* docker volume prune

```sh
$ docker volume create --driver local \
    --opt type=tmpfs \
    --opt device=tmpfs \
    --opt o=size=100m,uid=1000 \
    foo

$ docker volume create --driver local \
    --opt type=btrfs \
    --opt device=/dev/sda2 \
    foo

$ docker volume create --driver local \
    --opt type=nfs \
    --opt o=addr=192.168.1.1,rw \
    --opt device=:/path/to/dir \
    foo
```

## Run Docker Engine in swarm mode

### Swarm Mode

Swarm 模式默认是未开启的，有两种方式使 Docker Engine 运行在 Swarm 模式下：

* 创建一个新的 Swarm
* 加入已存在的 Swarm

### docker swarm init

* switches the current node into swarm mode.
* creates a swarm named default.
* designates the current node as a leader manager node for the swarm.
* names the node with the machine hostname.
* configures the manager to listen on an active network interface on port 2377.
* sets the current node to Active availability, meaning it can receive tasks from the scheduler.
* starts an internal distributed data store for Engines participating in the swarm to maintain a consistent view of the swarm and all services running on it.
* by default, generates a self-signed root CA for the swarm.
* by default, generates tokens for worker and manager nodes to join the swarm.
* creates an overlay network named ingress for publishing service ports external to the swarm.

```sh
$ docker swarm init
Swarm initialized: current node (dxn1zf6l61qsb1josjja83ngz) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \
    192.168.99.100:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

### Configure the advertise address

### View the join command or update a swarm join token
