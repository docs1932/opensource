# 1.回车换行符问题
```
在跨平台开发时，行结束符的问题，在Windows下是\r\n，在Linux下是\n，在Mac下是\r。
在Java中，可以使用System.getProperty("line.separator")来获取当前系统的行结束符。
但是，在 git 中，经常出问题，我们如果想要保持原有格式，可选的策略如下。

案例1：------------------
希望 hi.sh 文件，保持原有格式
方案1：
步骤1：
使用 notpad++ 打开 hi.sh 文件，
然后“编辑”--》“文档格式转换”
--》转为 Unix(LF)
--》保存
步骤2：
在工程跟目录下创建 .gitattributes 文件，并写入如下内容：
*.sh  text eol=lf
```