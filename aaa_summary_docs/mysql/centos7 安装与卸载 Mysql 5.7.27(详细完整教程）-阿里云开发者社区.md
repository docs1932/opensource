

https://developer.aliyun.com/article/1153952

**简介：** centos7 安装与卸载 Mysql 5.7.27(详细完整教程）

## 卸载

**1、关闭MySQL服务**

**2、使用 rpm 命令查看已安装的安装包**

```
rpm -qa|grep mysql
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_13cc443ef0d74266a5861838997d7d28.png "image.png")

**3、使用yum卸载安装的mysql**

```
sudo yum remove  mysql mysql-server mysql-libs mysql-server
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_56832f18ccb94a5caa84b06fdbd29632.png "image.png")

**4、查询剩余的安装包**

```
rpm -qa|grep mysql
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_703076a7258544978adfce5e47d05ba1.png "image.png")

**5、移除掉这些安装包**

```
rpm -ev mysql-community-release-el7-5.noarch
rpm -ev mysql-community-common-5.6.51-2.el7.x86_64
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_ca19d7c0135b45d188b0363d3cc4586b.png "image.png")

**6、检查残余安装包**(在mysql下载目录下执行)

```
ls
```

**7、删除残余的安装包**

```
rm -rf mysql*
```



**8、继续查找是否还有残留文件**

```
find / -name mysql
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_2ba5741ace99485bb9607263c532fab3.png "image.png")

**9、移除这些残留文件** (文件以上一步查询出来的为准)

```
rm -rf /etc/selinux/targeted/active/modules/100/mysql
rm -rf /usr/share/mysql
rm -rf /var/lib/mysql
rm -rf /var/lib/mysql/mysql
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_21424678574849d38ad17b95ebc006ca.png "image.png")

**10.最后检查** 

```
rpm -qa|grep mysql
find / -name mysql
ls
```

## 安装

**1\. 下载 MySQL yum包**

```
wget http://repo.mysql.com/mysql57-community-release-el7-10.noarch.rpm
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_052907d2bca546c1a9d0b24b51124120.png "image.png")

**2.安装MySQL源**

```
rpm -Uvh mysql57-community-release-el7-10.noarch.rpm
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_db4cdae59d414772a0660812662da1d0.png "image.png")

**3.安装MySQL服务端,需要等待一些时间**

```
yum -y install mysql-community-server --nogpgcheck
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_237bd36c4c8a4603812305bd6c1e58e0.png "image.png")

**4.启动MySQL**

```
systemctl start mysqld.service
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_7a4abfb419314c6b9960291619c91fb3.png "image.png")

**5.检查是否启动成功**

```
systemctl status mysqld.service
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_e1fcb322dbb240aaa851798e5b403614.png "image.png")

**6.获取临时密码，MySQL5.7为root用户随机生成了一个密码**

```
grep 'temporary password' /var/log/mysqld.log
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_8724c231c6144c76b6364a9254dc0b8e.png "image.png")

**7.通过临时密码登录MySQL，进行修改密码操作**

```
mysql -uroot -p
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_b322ac2d7edc470db48515f18c79d132.png "image.png")

**8.因为MySQL的密码规则需要很复杂，我们一般自己设置的不会设置成这样，所以我们全局修改一下**

```
mysql> set global validate_password_policy=0;
mysql> set global validate_password_length=1;
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_885af2d8690a4612848064bc2d9d778d.png "image.png")

这时候我们就可以自己设置想要的密码了

```
mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'yourpassword';
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_c4bbdce6451544eba58a6c4f9a24cbb6.png "image.png")

```
注意：yourpassword 改成自己上一步设置的密码
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'yourpassword' WITH GRANT OPTION;
mysql> FLUSH PRIVILEGES;

然后可以执行 exit 退出：
mysql> exit
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_ffb95aaf1ceb452cac2e2597a67dd678.png "image.png")

**10.开启开机自启动**

先退出mysql命令行，然后输入以下命令

```
systemctl enable mysqld
systemctl daemon-reload
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_2180c520e07b452db2287e9a2530b48e.png "image.png")

**11.设置MySQL的字符集为UTF-8，令其支持中文**

```
sudo vim /etc/my.cnf
```

**改成如下,然后保存**

```
[mysql]
default-character-set=utf8

[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
default-storage-engine=INNODB
character_set_server=utf8
symbolic-links=0
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
```

**12.重启一下MySQL,令配置生效**

```
service mysqld restart
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_f70c286b366846cab42e16b30b6fb82a.png "image.png")

**13.确保你在终端命令行可以输入中文**

```
env |grep LANG
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_f9bd1539518d49f389c93d01ef680cb8.png "image.png")

**14.数据库的操作**

```
（1）查看mysql是否启动：service mysqld status
启动mysql：service mysqld start
停止mysql：service mysqld stop
重启mysql：service mysqld restart
（2）查看临时密码：
grep password /var/log/mysqld.log
```

查看数据库是否服务起来

```
ps ajx | grep mysql</span></span>
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_f5e4325aabd54949a828f1de1c97f545.png "image.png")

```
netstat -nltp
```

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_4e9d33bc38234361a22c58abe577fc12.png "image.png")

客户端和服务端对应的路径

![image.png](https://ucc.alicdn.com/pic/developer-ecology/4pdnrrpfa3xdq_20168a5b4e874126b29ac1d8506a0add.png "image.png")

到这里就安装成功啦!!!赶快开始数据库的学习吧。

