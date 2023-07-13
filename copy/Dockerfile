FROM ubuntu

# 可以都用绝对路径
# COPY run.sh /run.sh
# CMD /run.sh

# 可以都用相对路径, 会复制到根目录 /run.sh
# COPY run.sh ./run.sh
# CMD realpath ./run.sh && ./run.sh

# 可以都用相对路径, 会复制到根目录 /run.sh
COPY run.sh ./run.sh
CMD realpath /run.sh && /run.sh
