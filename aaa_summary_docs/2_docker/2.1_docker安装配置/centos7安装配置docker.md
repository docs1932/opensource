
# 1.安装 docker
## 1.1 查看系统的版本和内核
```
cat /etc/issue
uname -r

#docker要求服务CentOS6以上且是64位，kernel 版本必须2.6.32-431或更高可以
执行："yum update" 升级内核，不然后边启动docker是会报错
```

## 1.2 安装 epel
```
yum install -y epel-release
```

## 1.3 安装 docker 
```
安装docker
```

## 1.4 之后的流程与步骤
```
# docker加入开机启动项
chkconfig docker on
```

## 1.5 配置阿里云镜像仓库
```
已有淘宝账号,可以直接搜索https://cr.console.aliyun.com/cn-hangzhou/mirrors,
登录后选择 --> 镜像加速器
即可，找到自己的加速地址

centos7 需要在 拿到 镜像加速器地址后依次执行下述命令：

sudo cp -n /lib/systemd/system/docker.service /etc/systemd/system/docker.service
sudo sed -i "s|ExecStart=/usr/bin/docker daemon|ExecStart=/usr/bin/docker daemon --registry-mirror=<your accelerate address>|g" /etc/systemd/system/docker.service
sudo sed -i "s|ExecStart=/usr/bin/dockerd|ExecStart=/usr/bin/dockerd --registry-mirror=<your accelerate address>|g" /etc/systemd/system/docker.service
sudo systemctl daemon-reload
sudo service docker restart
```

## 1.6 安装 docker-compose
```
# 1.安装docker-compose
curl -L https://github.com/docker/compose/releases/download/1.23.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose

# 2.给docker-compose安装文件赋予执行权限
chmod +x /usr/local/bin/docker-compose

# 3.查看docker-compose安装版本
docker-compose version
```

# 2.docker 安装各种软件工具
## 2.1 安装 docker 可视化管理界面 portainer
https://www.cnblogs.com/liuyuelinfighting/p/16013642.html
```
#下载镜像
docker pull docker.io/portainer/portainer

#启动镜像
docker run -d -p 9000:9000 --restart=always -v /var/run/docker.sock:/var/run/docker.sock --name portainer  docker.io/portainer/portainer

解释上面命令中的参数含义：
-d 后台运行
-p 9000:9000  将宿主机端口映射到容器端口
--restart always  容器退出时总是重新启动，若需退出手动运行 docker stop portainer
-v /var/run/docker.sock:/var/run/docker.sock  将宿主机 docker.sock(Docker API) 映射到容器
-v portainer_data:/data  映射宿主机数据卷到容器 /data 目录, 使用 docker volume create --name portainer_data 命令，单独创建数据卷也行, 命令中还是使用-v portainer_data:/data
--privileged-true 使用该参数，container内的 root 拥有真正的 root 权限，否则，container 内的 root 只是外部的一个普通用户权限。
portainer/portainer Portainer的镜像名称。


#输入url访问(首次登录需要设置密码, 比如: portainer123456)
http://ip:9000

#若是报错, 则
>>  编辑 vi /etc/docker/daemon.json
{
  "hosts": ["tcp://192.168.0.156:2375", "unix:///var/run/docker.sock"]
}
>> 重启 systemctl restart docker (切记2375的tcp端口要设置允许访问)
```

## 2.2 安装 httpbin.org
https://httpbin.org/
https://github.com/postmanlabs/httpbin
https://www.cnblogs.com/Neeo/articles/12168089.html
```
# 1.下载镜像
docker pull kennethreitz/httpbin

# 2.后台启动镜像
docker run -d -p 6001:80 --name httpbin --restart=always kennethreitz/httpbin

# 3.访问 6001 端口即可
http://192.168.13.131:6001/

# 4.使用方式
直接看 api 即可，里面有各种示例
```


# 99.常见问题
## 99.1 yum 死锁问题
```
问题：
Another app is currently holding the yum lock; waiting for it to exit...
  The other application is: PackageKit
  
解决方案：
rm -f /var/run/yum.pid
```


