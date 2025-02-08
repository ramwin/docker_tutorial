# DockerFile
```
FROM ubuntu  # 从那个镜像复制
ADD test.sh /bin/test.sh  # 拷贝文件
ENTRYPOINT test.sh  # run的时候会执行哪个文件
```
