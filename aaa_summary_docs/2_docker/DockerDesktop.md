https://github.com/tech-shrimp/docker_installer

# 1.下载对应操作系统的版本，以 windows 为例
## 1.1 前置准备工作
```
1.任务栏搜索功能，启用:
1) "适用于Linux的Windows子系统" 
2) "虚拟机平台"

2.管理员权限打开命令提示符，安装wsl2
wsl --set-default-version 2
wsl --update --web-download

3.下载Windows版本安装包，进入此项目的Release
https://www.docker.com/products/docker-desktop/

4.安装
直接点击安装即可

可选: 如果想自己指定安装目录，可以使用命令行的方式 参数 --installation-dir=D:\Docker可以指定安装位置
start /w "" "Docker Desktop Installer.exe" install --installation-dir=D:\Docker
```

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