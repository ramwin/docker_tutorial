#### Xiang Wang @ 2017-03-10 13:13:22

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
