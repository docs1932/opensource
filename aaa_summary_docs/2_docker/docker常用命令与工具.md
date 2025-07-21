# 0.文档 & 资源
https://docs.docker.com/
https://docker.github.net.cn/
https://yeasy.gitbook.io/docker_practice

 
# 1.基础命令
```
# 关闭 docker
systemctl stop docker.socket
systemctl stop docker.service

# 启动 docker
systemctl start docker

# 重启 docker
systemctl restart docker

# 查看docker版本
docker version

# 查看docker更多信息
docker info （如果此处报错，那么可能是centos内核版本问题，可以升级内核）

# 下载docker镜像
docker pull centos:latest (这里的latest是centos的版本，可以直接改为版本号如centos：6.5)

# 查看镜像
docker images (查看所有镜像)

# 查看 docker 中容器的进程
docker ps

# 查看 docker 容器日志
docker logs 容器id
```

# 2.镜像命令
```
#查看已有镜像
docker images　　查看已有镜像
docker images -a　　查看本地所有镜像(含中间层镜像)
docker images -q　　只显示镜像ID
docker iamges -qa　　查看本地所有镜像ID
docker iamges --digests　　显示镜像的摘要信息
docker iamges --no-trunc　　不截取镜像信息,完整信息信息

#docker search xxx从dockerhub中搜索镜像, 如:docker search tomcat
docker search -s 30 tomcat　　点赞数超过30的tomcat
docker search --no-trunc tomcat　　显示完整的镜像描述

#下载镜像
docker pull tomcat　　默认下载最新版
docker pull tomcat:7.0.47　　下载指定版本

#删除镜像
docker rmi hello-world　　删除该镜像
docker rmi -f hello-world 　　强制删除该镜像,无论其是否运行
docker rmi -f a b c 　　　　强制删除a,b,c镜像
docker rmi -f $(docker images -qa)　　删除本地所有docker 镜像

#根据运行中的容器生成镜像
#提交容器副本, 使之成为一个新的镜像
docker commit
#具体命令
docker commit -m="提交的描述信息"  -a="作者"  容器ID  要创建的目标镜像名:[标签名]
```

# 3.容器命令
```
#新建并启动容器
docker run [options] image [command] [args...]

# 数据持久化
docker run -d -v /宿主机绝对路径目录:/容器绝对路径目录 镜像名[:标签]

# 容器互联指令 --link


#列出当前所有正在运行的容器
docker ps [options]
docker ps -l　　(上一次运行的容器)
docker ps -n 3 　　(上3次运行的容器)

#退出容器
方法1: exit　　(容器停止,并退出)
方法2: ctrl+p+q　　(容器不停止,退出)

#启动容器
docker start [容器ID或者容器名]

#重启容器
docker restart [容器ID或者容器名]

#停止容器
docker stop [容器ID或者容器名]

#停止所有的container
docker stop $(docker ps -a -q)

#强制停止容器
docker kill [容器ID或者容器名]

#删除已停止的容器
docker rm [容器ID或者容器名]
docker rm -f [容器ID或者容器名](强制删除容器)
docker rm -f $(docker ps -qa)(删除所有容器)

#查看容器日志
docker logs -f -t --tail [容器ID]
#其中-f是跟随最新的日志打印,-t是加入时间戳,--tail跟随数字,显示最后多少条

#查看容器内运行的进程
docker top [容器ID]

#从容器内拷贝文件到主机上
docker cp 容器ID:容器内的路径 目的主机路径

#查看docker容器卷与宿主机之间的绑定关系
docker inspect 容器ID

#进入某个容器内部
docker attach 容器ID

# 进入某个容器
docker exec -it 容器ID /bin/bash
```

# 4. docker 网络
```
========= docker 网络模式 ===========
1. bridge 模式
docker 网络默认是 bridge 模式。该模式下，每个容器都会分配一个内部 IP 地址，一般是 172.17.x.x 开头的。
容器直接可以通过 IP 互相访问，但是容器网络和宿主机网络是隔离的。
2.host 模式
容器直接使用宿主机的 ip 地址，无须 -p 参数进行端口映射。容器内的服务直接运行在宿主机的端口上。
3.None 模式
就是不使用任何网络，容器之间无法互相访问。

默认情况下，docker 已经存在上述 3 种网络模式，可以使用 docker network ls 命令查看。

========= docker 子网络模式 ===========
可以使用 docker network create 创建子网
同一个子网的容器可以通信，同一个子网内部，容器可以通过名字通信，不用 直接输入 IP。
不同子网的容器不可以通信。
========= docker 网络命令 ===========
1.查看当前 docker 网络
docker network list
(host 模式，bridge 模式， none 模式) (--> 默认的 3 个网络是无法删除的，自己创建的子网络是可以删除的)
2.删除 docker 网络
docker network rm [网络名称]
3.创建子网络 (默认是 bridge 模式)
docker network create [子网名称]
创建 2 个容器，位于同一个子网内
docker run -d --name nginx -v /home/nginx/html:/usr/share/nginx/html --network network1 -p 9091:80
docker run -d --name tomcat --network network1 -p 9092:8080
进入一个容器
docker exec -it nginx /bin/sh
然后执行
ping tomcat 即可看到 tomcat 内部网络的 ip 地址，其原理是 docker 内部的 DNS 机制
4.以host 模式启动容器
docker run -d --name nginx -v /home/nginx/html:/usr/share/nginx/html -p 9091:80 --network host
```


# 2.常用工具
```
# 日志平台
https://dozzle.dev/
https://github.com/amir20/dozzle

# web 界面
portal
```