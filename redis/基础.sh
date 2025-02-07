#!/bin/bash
# Xiang Wang(ramwin@qq.com)


set -ex

name=redis
docker run --name $name -d -p 6401:6379 redis
redis-cli -p 6401 SET FOO BAR
redis-cli -p 6401 GET FOO
docker stop $name
docker start $name
redis-cli -p 6401 GET FOO
echo "因为默认有save, 所以上面还是BAR"
docker stop $name
docker rm $name
