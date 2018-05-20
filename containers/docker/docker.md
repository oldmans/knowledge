# Docker

## CLI

### Docker

docker info
docker version

### Container

docker create
docker rm [OPTIONS] CONTAINER [CONTAINER...]
docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
docker start [OPTIONS] CONTAINER [CONTAINER...]
docker restart [OPTIONS] CONTAINER [CONTAINER...]
docker stop [OPTIONS] CONTAINER [CONTAINER...]
docker pause CONTAINER [CONTAINER...]
docker unpause CONTAINER [CONTAINER...]
docker rename CONTAINER NEW_NAME
docker update [OPTIONS] CONTAINER [CONTAINER...]
docker wait CONTAINER [CONTAINER...]
docker stats [OPTIONS] [CONTAINER...]
docker logs [OPTIONS] CONTAINER
docker top CONTAINER [ps OPTIONS]
docker ps [OPTIONS]
docker kill
docker attach
docker cp
docker exec
docker diff

### Persistence

docker export
docker import
docker save [OPTIONS] IMAGE [IMAGE...]
docker load

### Image

docker build
docker commit
docker rmi [OPTIONS] IMAGE [IMAGE...]
docker tag
docker history

### Info

docker inspect
docker events

### Deploy 

docker deploy

### Hub

docker login [OPTIONS] [SERVER]
docker logout [SERVER]
docker push
docker pull
docker search [OPTIONS] TERM

## Docker Machine

* http://blog.daocloud.io/how-to-master-docker-image/
* http://blog.daocloud.io/daocloud-mirror-free/
* http://blog.daocloud.io/docker-china-community-update/
