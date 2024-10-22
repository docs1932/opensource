#1.概述
```
Dockerfile 是一个用来构建镜像的文本文件，
文本内容包含了一条条构建镜像所需的指令和说明。

通过Dockerfile我们能够将项目构建成一个镜像，
这样的好处是可以将一个复杂的项目直接打包成一个镜像存储和运行。

了解概念之前，需要先知晓的几个概念：

Repository --> Image --> Container
可以类比成：
Windows 中央仓库 --> win 11.iso 镜像 --> 安装到 各个计算机上的 win 11 操作系统
```

## 1.1 Repository
https://hub.docker.com/

## 1.2 Image

## 1.3 Container

#2.常用的命令
```
Dockerfile提供了非常多的指令供我们操作，下面例举一些常用的命令：

指令                 作用
FROM                指定当前镜像是基于哪个镜像的
RUN                 构建镜像时需要运行的指令
EXPOSE              当前容器对外暴露的端口号
WORKDIR             指定在创建容器后终端默认登录进来的工作目录
ENV                 用于在构建镜像过程中设置环境变量
ADD                 将宿主机目录下的文件拷贝到镜像
COPY                拷贝文件和目录到镜像
VOLUME              容器数据卷，用于数据持久化
CMD                 指定一个容器启动时要运行的命令
ENTRYPOINT          指定一个容器启动时要运行的命令
```

##2.1 FROM
```
#1.概述
该指令用于指定当前镜像是基于哪个镜像进行构建的，因为镜像的构建是一层一层进行的，
Docker Server会先基于某个基础镜像将项目打包成一个新镜像，
再基于这个新镜像继续打包，以此类推，不断打包构建，最终生成一个处理完成的镜像。

Dockerfile文件中的第一条指令必须是 FROM !!!
Dockerfile文件中的第一条指令必须是 FROM !!!
Dockerfile文件中的第一条指令必须是 FROM !!!
Dockerfile文件中的第一条指令必须是 FROM !!!

#2.示例
下面就来简单地使用一下FROM指令，
>> 在/opt目录下新建一个test目录，
>> 在/opt/test/目录下创建Dockerfile文件
>> 在刚才建立的Dockerfile文件中编写如下内容：
FROM centos
>> 文件内容非常简单，此时我们就可以根据Dockerfile进行镜像构建了，执行指令：
docker build -t mycentos_test01 .

这里我们指定FROM为centos，Docker Server将基于centos镜像进行构建，
当Docker中没有该镜像时，还会先将centos镜像拉取下来再进行构建， 
. 表示Dockerfile文件所在的位置为当前目录：

当指令执行成功后，就会生成一个新的镜像，可以使用 docker images 指令进行查看：
[root@localhost test]# docker images
REPOSITORY        TAG            IMAGE ID       CREATED        SIZE
centos            latest         300e315adb2f   7 months ago   209MB
mycentos_test01   latest         300e315adb2f   7 months ago   209MB

此时我们就可以启动这个镜像，同时进入交互终端：
docker run -it mycentos_test01

可以看到这就是一个新的centos，这是因为我们只使用了FROM指令基于centos镜像构建，
所以得到的镜像仍然还是一个基础的centos镜像。
```

##2.2 RUN
```
#1.概述
该指令会将在当前镜像之上的新层中执行任何命令并提交结果，生成的镜像将用于下一步。
RUN指令还支持以数组的方式传递需要执行的命令:
RUN ["yum","install","-y","vim"]

#2.示例程序
修改Dockerfile文件：
FROM centos
RUN yum install -y vim

我们知道在没加RUN命令之前构建出来的镜像就是一个centos，
但现在，构建出来的镜像就是一个包含vim编辑器的centos系统，马上来构建它：
docker build -t mycentos_test02 .

构建成功后就可以进行启动：
docker run -it mycentos_test02

可以检查一下镜像中是否真的已经包含了vim编辑器：
rpm -qa|grep vim
```

##2.3 EXPOSE
```
#1.概述
该指令用于指定构建的镜像在运行时为对外暴露的端口，只有向外暴露了端口，
外部才能够访问到这个进镜像提供的服务。

#2.示例
修改Dockerfile文件：
FROM centos
RUN ["yum","install","-y","vim"]
EXPOSE 80

但事实上centos镜像添加端口并没有作用，因为它不像tomcat、mysql、redis那样会向外部主机提供某项服务
所以可以将基础镜像指定为tomcat：
FROM tomcat:8.0

此时构建镜像然后启动：
docker run -p 80:80 mytomcat_test01
```

##2.4 CMD
```
#1.概述
该指令用于为启动的容器指定需要执行的命令

Dockerfile中只能有一条CMD命令，如果写出了多条CMD，则以最后一条的内容为准!!!
Dockerfile中只能有一条CMD命令，如果写出了多条CMD，则以最后一条的内容为准!!!
Dockerfile中只能有一条CMD命令，如果写出了多条CMD，则以最后一条的内容为准!!!
Dockerfile中只能有一条CMD命令，如果写出了多条CMD，则以最后一条的内容为准!!!
Dockerfile中只能有一条CMD命令，如果写出了多条CMD，则以最后一条的内容为准!!!


#2.示例
修改Dockerfile：
FROM centos
RUN ["yum","install","-y","vim"]
EXPOSE 80
CMD ["echo","hello"]

构建镜像：
docker build -t mycentos_test03

此时启动镜像：
docker run -it mycentos_test03

因为CMD指令的作用，所以在启动这个镜像的时候就会立马执行CMD中的命令，从而输出 hello 字符串：
[root@localhost test]# docker run -it mycentos_test03
hello
```

##2.5 ENTRYPOINT
```
#1.概述
该指令与CMD类似，也是用于指定容器启动时需要执行的命令


#2.示例
修改Dockerfile文件：
FROM centos
RUN ["yum","install","-y","vim"]
EXPOSE 80
ENTRYPOINT ["echo","hello"]

构建镜像：
docker build -t mycentos_test04 .

启动镜像：
[root@localhost test]# docker run -it mycentos_test04
hello

#3.与 CMD 的区别
可以看到ENTRYPOINT和CMD两个指令的效果是一样的，那么它俩有什么区别呢？
其区别在于命令的覆盖方式，对于CMD指令，我们可以在启动镜像的时候直接拼写命令来覆盖它，比如：
[root@localhost test]# docker run -it mycentos_test03 echo hello centos
hello centos

然而对于ENTRYPOINT，它是无法通过直接追加命令来覆盖的，而是需要用到一个参数：
[root@localhost test]# docker run --entrypoint="echo hello centos" mycentos_test04
hello centos

#4.方案
由此可见，ENTRYPOINT指令对于命令的覆盖是比CMD指令更加复杂的，为此，
可以将那些基本固定不变的命令配置到ENTRYPOINT中，
而将需要修改的命令配置到CMD中，比如：
FROM centos
RUN ["yum","install","-y","vim"]
EXPOSE 80
ENTRYPOINT ["echo"]
CMD ["hello centos"]
```

##2.6 WORKDIR
```
#1.概述
该指令用于指定镜像的落脚点，即：启动镜像后初始进入的目录，若是没有配置，则默认是 / 

注意:
只要配置了WORKDIR，无论你有没有在后续的指令中使用到它，
WORKDIR配置的目录是一定会在镜像中被创建的。

#2.示例
[root@localhost test]# docker run -it mycentos_test02
[root@9c958bd3830f /]#
启动镜像后首先进入的便是 / 目录，

但如果配置了WORKDIR：
FROM centos
WORKDIR /opt/work

构建镜像：
docker build -t mycentos_test05 .

启动镜像：
[root@localhost test]# docker run -it mycentos_test05
[root@37f177c1e546 work]# pwd
/opt/work
```

##2.7 ENV
```
#1.概述
该指令用于为镜像设置环境变量

#2.示例
FROM centos
ENV name centos
WORKDIR /$name

在这里配置了一个环境变量name，值为centos，并在WORKDIR指令中引用了该变量，
所以通过该文件构建出来的镜像在启动时就会直接进入/centos目录，验证一下：

构建镜像：
docker build -t mycentos_test06 .

启动镜像：
docker run -it mycentos_test06

[root@0a505138f024 centos]# pwd
/centos
```

##2.8 VOLUME
```
#1.概述
该指令用于定义容器运行时可以挂载到宿主机的目录

#2.示例
修改一下Dockerfile
FROM centos
ENV name centos
WORKDIR /$name
VOLUME /$name

此时配置了VOLUME，值为 /$name ，则容器中的/centos目录就允许被外部挂载。

构建镜像：
docker build -t mycentos_test07 .

然后在启动镜像的同时挂载一下数据卷：
docker run -it -v /opt/centos:/centos mycentos_test07

这样两个目录就实现了共享，此时在/opt/centos目录下的操作都会被同步到容器中的/centos目录：
[root@localhost test]# cd /opt/centos/
[root@localhost centos]# touch test
[root@localhost centos]# docker run -it -v /opt/centos:/centos mycentos_test07
[root@37450c713b08 centos]# ls
test
```

##2.9 ADD
```
#1.概述
该指令用于将context目录中指定的文件复制到镜像的指令目录中去，
那么首先我们就要知道何为context目录。
context目录意为上下文目录，指的是Dockerfile文件所在的目录。

#2.解释
[root@localhost opt]# ll
total 262144
drwx--x--x. 4 root  root         28 Jun 18 11:27 containerd
-rw-r--r--. 1 root  root  268435456 Jun 23 15:46 disk.bin
-rw-r--r--. 1 root  root          0 Jul 23 07:08 Dockerfile
drwxr-xr-x. 3 root  root         25 Jul 22 12:45 javaproject
drwxr-xr-x. 8 10143 10143       273 Apr  7 19:26 jdk1.8.0_291
drwxr-xr-x. 2 root  root         24 Jul 23 07:04 test
drwxr-xr-x. 8 root  root        160 Jul  5 12:52 zookeeper-3.5.7

若是此时Dockerfile文件处在/opt目录下，则context目录则为/opt目录，
因为DockerServer会将context目录中的所有文件，包括子目录及其子文件进行打包构建，
所以这也是为什么我们一开始创建一个空的文件夹，并将Dockerfile放在其中，
因为文件过多会导致构建速度变慢。

#3.示例
修改Dockerfile：
FROM centos
ENV name centos
WORKDIR /$name
VOLUME /$name
ADD test.txt /

在Dockerfile所在目录下有一个test.txt，现在要将其复制到容器中的 / 目录下，

构建镜像：
docker build -t mycentos_test08 .

启动镜像：
docker run -it mycentos_test08

[root@184a8824b583 centos]# cd /
[root@184a8824b583 /]# ls -l | grep test
-rw-r--r--.  1 root root   0 Jul 23 07:25 test.txt

若是想修改添加到容器后的文件名，则直接指定名字即可：
ADD test.txt /ntest.txt

ADD不仅能够添加文件、目录，还能够添加一个url，比如：
ADD http://www.baidu.com /test.html

则启动构建后的镜像时，便会在 / 目录下创建test.html文件，
并将访问http://www.baidu.com所得到的响应结果写入该文件。
```


```参考资料```
https://mp.weixin.qq.com/s?__biz=Mzg5NDM1ODk4Mw==&mid=2247542462&idx=3&sn=c39ad8448f77744bb353f8a5dac3a10d&chksm=c022a216f7552b000508f323d5c1698a1aabca0f3ca62d0353a1e31de5de1474177ce4623567&mpshare=1&scene=24&srcid=0713yFs8VJ71Rjm8XS1ldVBu&sharer_sharetime=1657708208465&sharer_shareid=9b286cadc70f5998699efc52a3cf3724#rd
