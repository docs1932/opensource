
# 1.下载与破解
## 1.1 破解方案1(暂时可用 2024-08-17)
https://blog.csdn.net/weixin_50670076/article/details/136444408
https://3.jetbra.in/


# 3.常用插件
## 3.1 MarsCode
```
豆包旗下
https://www.marscode.cn/dashboard
```
## 3.2 uml 插件
```
1.搜索插件并下载，然后重启 IDEA
PlantUML Integration

2.在 IDEA 中 ->
New -> PlantUML File -> Sequence
便可以创建 Sequence 的 demo 文件

https://plantuml.com/zh/sequence-diagram
https://plantuml.com/sequence-diagram
语法参考这里即可
```

## 3.n 其他插件
```
#热加载插件：JRebel and XRebel
#jclasslib (查看字节码文件: view --> show bytecode with jclasslib)
#Alibaba Java Coding Guidelines
# BashSupport
# FindBugs-IDEA-1.0.1
# junitGenerator V2.0插件
# lombok-plugin-0.19-2018.EAP
# markdown-182.2371
# mavenHelper
# VisualVMLauncher
# Git
# jclasslib bytecode viewer(可视化的字节码查看插件, jvm指令查看)
# Stack trace to UML
# sequencediagram (时序图插件, 解读源码必备)
#IdeaJad (反编译神器)
#GrepConsole(日志查看神器)
#TranslationPlugin(翻译)
#free-idea-mybatis
#MybatisCodeHelperNew
```



# 99.常见问题
## 99.1 Error running Application. Command line is too long.
```
IDEA --> 
靠近右侧上方偏左的 启动类上 --> 
Edit Configurations -->
Shorten command line --> 
选择：JAR manifest 或者classpath file
```