# 使用官方 Python 基础镜像
FROM docker-0.unsee.tech/debian:bullseye

# 设置工作目录
WORKDIR /app

# 把 Flask 应用程序复制到工作目录
COPY silk /app/silk
COPY app.py requirements.txt ./

# 安装系统工具和 Silk Decoder
RUN rm -rf /etc/apt/sources.list.d/* && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian bullseye main contrib non-free" > /etc/apt/sources.list && \
    echo "deb-src http://mirrors.tuna.tsinghua.edu.cn/debian bullseye main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.tuna.tsinghua.edu.cn/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb-src http://mirrors.tuna.tsinghua.edu.cn/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y python3 python3-pip ffmpeg wget gcc make unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    cd /app/silk && \
    make && \
    cp decoder /usr/local/bin/silk-decoder && \
    cd .. && rm -rf silk && \
    pip install --no-cache-dir -r requirements.txt -i https://mirrors.ustc.edu.cn/pypi/simple/

# 暴露 Flask 默认端口
EXPOSE 5500

# 启动 Flask 应用
CMD ["python3", "app.py"]
