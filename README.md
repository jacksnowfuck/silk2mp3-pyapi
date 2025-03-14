# silk2mp3-pyapi
把微信语音的silk格式转化成mp3的api服务

#### PS. 由于所在环境到debian的镜像源比较慢，所以底层镜像用的是debian:bullseye，打包后镜像会有点大，网络环境好的，可以调整DockerFile内容，用轻量的python镜像

#### 操作步骤：
1. docker-compose build
2. docker-compose up -d

#### 使用方式
接口地址是`/convert`
```bash
curl -F "file=@41303466633830346164336265393300501151031425e5b20233072102.silk" \
-X POST "http://localhost:5500/convert" --output output.mp3
```
