# Dockerfile

## build

```sh
docker build -t shykes/myapp:1.0.2 -t shykes/myapp:latest -f /path/to/a/Dockerfile .
```

## Format

```Dockerfile
INSTRUCTION arguments
```

## Example

```sh
# 在Dockerfile中第一条非注释INSTRUCTION一定是FROM
FROM ubuntu

# 镜像MetaData
LABEL <key>=<value> <key>=<value> <key>=<value> ...

# 为运行镜像时或者任何接下来的RUN指令指定运行用户名或UID：
USER <user>[:<group>] or
USER <UID>[:<GID>]

# WORKDIR指令用于设置Dockerfile中的RUN、CMD和ENTRYPOINT指令执行命令的工作目录(默认为/目录)
# 该指令在Dockerfile文件中可以出现多次，如果使用相对路径则为相对于WORKDIR上一次的值，例如WORKDIR /a，WORKDIR b，RUN pwd最终输出的当前目录是/a/b
WORKDIR /path/to/workdir

# 构建参数和 ENV 的效果一样，都是设置环境变量。所不同的是，ARG 所设置的构建环境的环境变量，在将来容器运行时是不会存在这些环境变量的。
ARG <name>[=<default value>]

# COPY的语法与功能与ADD相同，只是不支持上面讲到的<src>是远程URL、自动解压这两个特性，
# 建议尽量使用COPY，并使用RUN与COPY的组合来代替ADD，这是因为虽然COPY只支持本地文件拷贝到container，但它的处理比ADD更加透明，建议只在复制tar文件时使用ADD，如ADD trusty-core-amd64.tar.gz /。
COPY home* /mydir/

# 将文件<src>拷贝到container的文件系统对应的路径<dest>下。
# <src>可以是文件、文件夹、URL，对于文件和文件夹<src>必须是在Dockerfile的相对路径下（build context path），即只能是相对路径且不能包含../path/。
# <dest>只能是容器中的绝对路径。如果路径不存在则会自动级联创建，根据你的需要是<dest>里是否需要反斜杠/，习惯使用/结尾从而避免被当成文件。
ADD requirements.txt /tmp/

# RUN 指令通常用于安装应用和软件包。
# RUN 执行命令并创建新的镜像层，RUN 经常用于安装软件包。
RUN apt-get install vim -y
RUN pip install /tmp/requirements.txt
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server && \
  rm -rf /var/lib/apt/lists/* && \
  sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf && \
  sed -i 's/^\(log_error\s.*\)/# \1/' /etc/mysql/my.cnf && \
  echo "mysqld_safe &" > /tmp/config && \
  echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config && \
  echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;'" >> /tmp/config && \
  bash /tmp/config && \
  rm -f /tmp/config

# The ONBUILD instruction adds to the image a trigger instruction to be executed at a later time, when the image is used as the base for another build. 
ONBUILD ADD . /app/src
ONBUILD RUN /usr/local/bin/python-build --dir /app/src

# ############################################################################################################################################################

# The STOPSIGNAL instruction sets the system call signal that will be sent to the container to exit.
STOPSIGNAL signal

# 用于设置环境变量
ENV <key> <value>
ENV <key>=<value> ...

# The SHELL instruction allows the default shell used for the shell form of commands to be overridden. 
SHELL ["/bin/sh", "-c"]

# CMD 指令允许用户指定容器的默认执行的命令。
# CMD 设置容器启动后默认执行的命令及其参数，但 CMD 能够被 docker run 后面跟的命令行参数替换。
# CMD 只能有一个，如果有多个，只有最后一个生效。
CMD echo "This is a test." | wc -

# 健康检查
HEALTHCHECK --interval=5m --timeout=3s  CMD curl -f http://localhost/ || exit 1

# ENTRYPOINT 指令可让容器以应用程序或者服务的形式运行。
# ENTRYPOINT 配置容器启动时运行的命令。
# ENTRYPOINT 命令设置在容器启动时执行命令，如果有多个ENTRYPOINT指令，那只有最后一个生效。
ENTRYPOINT command param1 param2

# VOLUME指令用来在容器中设置一个挂载点，可以用来让其他容器挂载以实现数据共享或对容器数据的备份、恢复或迁移。
VOLUME ["/data"]

# EXPOSE指令告诉容器在运行时要监听的端口，但是这个端口是用于多个容器之间通信用的（links），外面的host是访问不到的。
EXPOSE 11211 11212
```
