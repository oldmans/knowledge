# Docker

## A brief explanation of containers

### Image

镜像 是一个 包含运行一个软件所需要的所有内容的 一个 轻量的、独立的、可执行的包，包括如代码、运行时的库、环境变量和配置文件等。

相当于 程序

### Container

容器是镜像 加载到内存当中并且实际运行的一个实例，默认情况下与宿主机器完全隔离，只能在配置的情况向访问宿主机器的文件和端口。

相当于 进程


## Containers vs. virtual machines

## 构建镜像

### 编写代码

...

### 编写 Dockerfile 描述镜像构建过程

如：
```Dockerfile
# Use an official Python runtime as a parent image
FROM python:2.7-slim

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]
```

### 构建镜像

docker build -t friendlyhello .


### 运行镜像 

docker run -p 4000:80 friendlyhello


### 分享镜像

共享镜像需要一个镜像仓库，共享并非仅仅是与他人分享，而是在各个环境中分享

#### 登录

docker login

#### 标记镜像

docker tag image username/repository:tag

docker tag friendlyhello john/get-started:part1

#### 推送/发布镜像

docker push username/repository:tag

#### 拉取/运行镜像

docker run -p 4000:80 username/repository:tag


