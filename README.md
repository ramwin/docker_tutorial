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
