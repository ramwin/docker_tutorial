#!/bin/bash
# Xiang Wang(ramwin@qq.com)


set -ex

name=redis_without_save
docker run --name $name -d -p 6401:6379 redis --save ""
redis-cli -p 6401 SET FOO BAR
redis-cli -p 6401 GET FOO
docker stop $name
docker start $name
redis-cli -p 6401 GET FOO
echo "因为不save, 所以上面不是BAR,是nil"
docker stop $name
docker rm $name
