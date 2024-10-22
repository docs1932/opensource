#1.执行docker 或者 docker-compose 命令后, 发现端口没启动
```
1.排查命令是否正确
2.排查文件是否正确, 包括空格, 换行, 是否有中文符号, 同时删除所有注释, 文件末尾不要有回车换行符
3.
```

#2.容器启动了, 但是外界连接不上
## 2.1 排查宿主机与虚拟机网络连接是否正常

## 2.2 排查暴露的端口是否开放

## 2.3 排查是否是 ipv6
```
以 docker-compose 安装 mysql 为例, 假设映射端口是 3306, 容器启动后,
lsof -i:3306 是有进程在的, 同时发现 网络类型 type: ipv6,
那么此时用 navicat 可能是连接不上的.

简单处理:
1.修改宿主机配置文件: vi /etc/sysctl.conf
net.ipv4.ip_forward=1
2.修改另一项, vi /etc/sysconfig/network
FORWARD_IPV4=YES
3.重启网络服务
service network restart
4.移除容器
docker rm -f containId
5.重启启动容器即可

https://blog.csdn.net/whatday/article/details/106003836/
```

# 3.以 root 身份进入 docker

# 4.docker 容器内缺少相关命令
```
1.先执行
apt-get update

2.安装 vim 命令
apt-get install vim
```

# 5.ERROR: missing signature key
```
docker 版本过低，需要升级
```