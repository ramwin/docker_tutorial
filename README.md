# Docker

## 配置
```json
// /etc/docker/daemon.json
{
  "ip-tables": false,  // 下次部署手动确认一次
  "log-opts": {
    "max-size": "100m"  // 不然你的docker跑久了会把服务器磁盘占满
  }
}
```

## 运行
```bash
sudo docker run \
    --restart always \
    -p 81:80 \
    --name containername \
    -d \
    --log-opt max-size=10m \
    --log-opt max-file=5 \
    httpd
```

## 网络
### 默认情况，iptables为True
无论是host还是bridge,都可以访问外部网络
* bridge: 需要端口映射， 哪怕防火墙没开，外部也能访问暴露的端口
* host: 直接用本机端口，所以无法启动redis容器，和本机的6379端口冲突
* none: 没网络，内外都无法访问

### 关闭iptables后
host可以访问外部网络，bridge不行
* host: 直接使用本机端口, ufw可以防住，但是端口无法自定义映射, 可以访问外部网络
* bridge: 需要使用端口映射，才能访问。ufw可以防住, 无法访问外部网络

### 解决方案
使用ufw-docker

1. 容器运行
```
docker run -p 81:80 --name httpd_81 -d httpd
# docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -q) 查看容器ip为172.17.0.6
DOCKER_IP=172.17.0.6
curl localhost:81  // 内网可以访问
docker run --name tmp --rm alpine/curl http://ramwin.com/  # docker内可以访问外网
docker run --name tmp --rm alpine/curl http://172.17.0.6:80/  # docker内可以用docker的IP访问
其他服务器 curl http://ip:81  # 外部其他服务器无法访问
```

2. ufwdocker全部放开
```
sudo ufw-docker allow httpd_81  # 允许外部访问
其他服务器 curl http://<宿主机ip>:81/  # 外部其他服务器可以访问
```

3. 容器销毁后重启
```
docker stop httpd_81 && docker start httpd_81
docker run -p 83:80 --name httpd_82 -d httpd
此时的IP还是 172.17.0.6, 所以外网还是能访问 <宿主机ip>:83

docker run -p 81:80 --name httpd_81 -d httpd
此时httpd_81的ip变成了172.17.0.7所以外网无法访问了 
```

4. 结论, 启动容器时要指定ip
```
docker run -p 81:80 --name httpd_81 -d httpd --ip="172.17.0.6"
docker run -p 81:80 --name httpd_81 -d --ip 172.17.0.6 httpd  # 报错,因为default的网络不支持自定义IP. 所以要创建一个网络
```

5. 创建网络
```
docker network create httpd_network  # 创建一个网络, 比如网关172.19.0.1, 没指定subnet后面会报错
docker network create httpd_network --subnet=172.19.0.0/16  # 创建一个网络, 比如网关172.19.0.1, 没指定subnet后面会报错
docker run -p 81:80 --name httpd_81 -d --ip 172.19.0.6 --network httpd_network httpd
sudo ufw-docker allow httpd_81  # ufw-docker是改防火墙,所以要sudo, docker用户不行哦
```

6. 如何指定只有部分IP访问, 好像不太行 https://github.com/chaifeng/ufw-docker/issues/127
```
sudo ufw-docker delete allow httpd_81  # 删除权限
sudo ufw-docker allow proto tcp from 47.100.203.184 to httpd_81 
```

7. 使用ufw route
```
sudo ufw route allow proto tcp from 47.100.203.184 to 172.19.0.6 port 80
```


## 自定义registry
`./start_registry.sh`
```{literalinclude} ./start_registry.sh
```

## 安装

```
curl -fsSL https://get.docker.com/ | sh
sudo usermod -aG docker $USER
```

### ubuntu
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


## Images
* pull
```
docker pull --platform linux/arm64 ubuntu:20.04
```

* save
```
docker image save <image> -o <local_path>
```

## Container

### 基础

```
docker run hello-world
docker run --name containername -i -t ubuntu:14.04 /bin/bash
## 本地跑了redis-server，想从container里面访问数据库
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

## [Volume](https://docs.docker.com/storage/volumes/)
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
