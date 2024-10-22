# 0.Oracle JDK 也是同理的
```
下载地址
https://www.oracle.com/java/technologies/downloads
```

# 1.openjdk 下载
```
https://openjdk.java.net/
如果下载慢，就去国内公司下载，如
https://repo.huaweicloud.com/java/jdk/

# 下载, 可参考此 blog, 但后续环境变量就不要参考此 blog 了
https://blog.csdn.net/qq756684177/article/details/120259528
```

```
Download and install the latest open-source JDK.

Oracle’s free, GPL-licensed, production-ready OpenJDK JDK 18 binaries
for Linux, macOS, and Windows are available at
[下文这里是个超链接, 点击进去找到对应版本的下载即可]
jdk.java.net/18;

Oracle’s commercially-licensed JDK 18 binaries, based on the same code, are here.
```

# 2.解压: openjdk-11+28_windows-x64_bin.zip
```
比如放到 D:\opt 下
假设解压后, 目录是 D:\opt\openjdk-11+28_windows-x64_bin
```

# 3.设置环境变量

## 3.1 定义 JAVA_HOME
```
新建系统变量:
变量名是: JAVA_HOME
变量值是: D:\opt\openjdk-11+28_windows-x64_bin
```

## 3.2 定义 CLASSPATH
```
新建系统变量:
变量名是: CLASSPATH
变量值是: .;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar;
```

## 3.3 定义 PATH
```
编辑 PATH, 新增两个配置项
%JAVA_HOME%\bin
%JAVA_HOME%\jre\bin
```

https://www.runoob.com/w3cnote/windows10-java-setup.html

4.验证:
>> java
>> javac
>> java -version
```
!!! 只有上述 3 个命令都执行成功, 才表示 java 安装配置完成
!!! 只有上述 3 个命令都执行成功, 才表示 java 安装配置完成
!!! 只有上述 3 个命令都执行成功, 才表示 java 安装配置完成
```

# 5.常见问题
## 5.1 java.lang.RuntimeException: Unexpected error: java.security.InvalidAlgorithmParameterException: the trustAnchors parameter must be non-empty -> [Help 1]
可以 google 一下。
https://blog.csdn.net/wushengjun753/article/details/114883662(没啥用)