
# 1.下载对应操作系统的版本，以 windows 为例

# 2.修改
```
1.修改 image 存储位置：
默认的 image 存储位置是：
Settings --> Resources --> Advanced
C:\Users\{your machine user}\AppData\Local\Docker\wsl
修改到其他盘即可

2.注意 你是 windows 还是 linux 环境，这个在
settings --> builders 里面可以看到当前 的环境是 windows 还是 linux
如果想要切换，可以在右下角的 icon 里，找到 swtich to linux builder / swtich to windows builder

3.添加镜像加速地址
Settings --> Docker Engine
    "registry-mirrors": [
        "https://registry.docker-cn.com",
        "https://docker.mirrors.ustc.edu.cn",
        "https://hub-mirror.c.163.com",
        "https://mirror.baidubce.com",
        "https://ccr.ccs.tencentyun.com",
        "https://docker.rainbond.cc",
        "https://dockerproxy.cn",
        "https://docker.rainbond.cc",
        "https://docker.udayun.com",
        "https://docker.211678.top"
    ],
```