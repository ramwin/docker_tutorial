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
