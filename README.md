# 网络
## 默认情况，iptables为True
无论是host还是bridge,都可以访问外部网络
* bridge: 需要端口映射， 哪怕防火墙没开，外部也能访问暴露的端口
* host: 直接用本机端口，所以无法启动redis容器，和本机的6379端口冲突
* none: 没网络，内外都无法访问

## 关闭iptables后
host可以访问外部网络，bridge不行
* host: 直接使用本机端口, ufw可以防住，但是端口无法自定义映射, 可以访问外部网络
* bridge: 需要使用端口映射，才能访问。ufw可以防住, 无法访问外部网络

## 解决方案
使用ufw-docker

# 自定义registry
`./start_registry.sh`
```{literalinclude} ./start_registry.sh
```

# 安装

```
curl -fsSL https://get.docker.com/ | sh
sudo usermod -aG docker $USER
```

## ubuntu
```
sudo apt-get -y install \
  apt-transport-https \
  ca-certificates \
  curl

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"

sudo apt-get update
sudo docker run hello-world
sudo apt install docker-ce
```


# Images
* pull
```
docker pull --platform linux/arm64 ubuntu:20.04
```

* save
```
docker image save <image> -o <local_path>
```

# Container

## 基础

```
docker run hello-world
docker run --name containername -i -t ubuntu:14.04 /bin/bash
# 本地跑了redis-server，想从container里面访问数据库
docker run 
    -ti  # 选择命令行交互模式
    --rm  # 命令结束后删除docker container
    --name redis  # 设置容器名称
    --net=host  # 容器要可以链接宿主机网络
    redis  # imgae 名称
    redis-cli  # 运行的口令
docker attach containername  # 访问某个容器
ctrl + P + Q  # 退出容器，不停止进程
```

* 暴露端口

把宿主机的19000端口绑定到容器的8000端口. 可以绑定多个
```
docker run -p 19000:8000 -p 19001:8001 <image>
```

# [Volume](https://docs.docker.com/storage/volumes/)
* 操作卷
```
docker volume create my-vol
docker volume rm my-vol
docker volume inspect my-vol
```

* 挂载卷
```
docker run -ti --rm --mount source=my-vol,target=/app  ubuntu /bin/sh
```

* 直接挂载本地文件夹
```
docker run -ti --rm -v /tmp:/tmp ubuntu /bin/sh
```
