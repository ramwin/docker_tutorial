#!/bin/bash
# Xiang Wang(ramwin@qq.com)
#
registry_args=(
    run
    -d
    -p 5001:5000
    --name registry
    -e REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/mnt/nvme2/registry
    registry
)
docker "${echo_args[@]}"

docker run \
    -ti \
    --rm -p 5001:5000 --name registry \
    -e REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/mnt/nvme4/registry \
    registry

docker run \
    -d \
    --rm -p 5001:5000 --name registry \
    -e REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY=/images \
    -v /mnt/nvme4/registry:/images \
    registry
