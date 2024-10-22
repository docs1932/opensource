
# 1.下载安装
```
1.下载地址
https://services.gradle.org/distributions/
本文下载的是： gradle-8.2-rc-2-bin.zip

2.解压
解压完成后 路径是：
D:\software\software_for_develop\gradle-8.2-rc-2

3.配置环境变量
3.1 新增环境变量
变量名： GRADLE_HOME
变量值： D:\software\software_for_develop\gradle-8.2-rc-2
3.2 配置 Path:
在 Path 变量中添加 %GRADLE_HOME%\bin

4.指定本地仓库
【可以使用 Maven 的本地仓库】
gradle 与 maven 本地仓库在配置文件 settings.xml 指定的不同，
gradle 环境变量是 环境变量 中指定的。

gradle 既可以单独创建本地仓库，也可以使用 maven 的本地仓库。
此处 maven 的本地仓库是：
D:\software\software_for_develop\repository

配置环境变量，指向本地仓库地址。
变量名： GRADLE_USER_HOME
变量值： D:\software\software_for_develop\repository

5.测试 gradle
在window cmd 中 输入 gradle -v
```

# 2.Idea 中配置使用 gradle
## 2.1 基本配置
```
New Projects SetUp -->
Settings for New Projects --> 
Build, Exetuion, Deployment --> 
Build Tools --> 
Gradle --> 
Gradle user home: D:/software/software_for_develop/repository	(配置为 maven 本地仓库的地址)	
```

## 2.2 打开项目后的配置
```
Settings --> 
Build, Exetuion, Deployment --> 
Build Tools --> 
Gradle --> 
设置：Gradle user home: D:/software/software_for_develop/repository	(配置为 maven 本地仓库的地址)	
设置：Use Gradle from: 【specification location】【D:\software\software_for_develop\gradle-8.2-rc-2】
```

# 3.gradle 常用命令
```
1、查看所有可用的task
gradle task

2、编译（编译过程中会进行单元测试）
gradle build

3、单元测试
gradle test

4、编译时跳过单元测试
gradle build -x test

5、直接运行项目
gradle run

6、清空build目录
gradle clean

7、生成mybatis的model、mapper、xml映射文件
gradle mybatisGenerate

8、生成可运行的jar包
gradle installApp

9、打包源代码，打包后的源代码，在build/libs目录下
gradle sourcesJar

10、安装到本机maven仓库
gradle install

11、生成pom.xml文件，用于转成maven项目
gradle createPom

12、查看版本号
gradle -v
```

# 参考资料
https://blog.csdn.net/xiaojin21cen/article/details/107227432


