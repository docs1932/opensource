
# 1.卸载旧版本的 openjdk
```
rpm -qa|grep jdk
yum -y remove copy-jdk-configs.noarch
```

# 2.输入 java -version 查看是否卸载成功

# 3.下载 linux 版本 jdk
https://www.oracle.com/java/technologies/downloads/#jdk17-linux

# 4.通过 sftp 上传至 centos 中
```
假设是 /opt 目录
```

# 5.解压缩
```
tar -zxvf jdk-17_linux-x64_bin.tar.gz
```

# 6.配置环境变量
```vi /etc/profile```
```
export JAVA_HOME=/opt/software/jdk-17.0.11
export JRE_HOME=$JAVA_HOME/jre
export CLASSPATH=$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH
export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH
```

```source一下，使得生效```
```
source /etc/profile
```

# 7.验证是否安装成功
```
java
javac
java -version
```


参考资料
https://blog.csdn.net/qq_41610957/article/details/125103549
