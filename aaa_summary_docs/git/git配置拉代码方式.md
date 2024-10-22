# 1.TortoiseGit 安装配置
## 1.1 下载安装
```
https://tortoisegit.org/download/

点击下一步安装即可。

安装之后配置如下：
配置名称为 Adam Zhang
配置邮箱为 xxxx@yyy.zzz
```

## 1.2 配置 ssh
```
在配置好下文所示的 ssh 后 -->
TortoiseGit --> Settings --> 
Network --> SSH --> SSH client -->
选择 git 的 ssh 路径，此处是：
D:\software\software_for_develop\git\Git\usr\bin\ssh.exe
--> 应用 --> 确定
```

# 2.配置拉代码的方式
## 2.1 ssh方式
```
1.生成密钥
cmd 窗口下执行：
ssh-keygen -t rsa -b 4096 -C "psy_zhangxin@outlook.com"
这一步可以选择输入保存密钥的路径和密码，也可以不输入，直接回车跳过即可。

默认会在 C:\Users\zx\.ssh 目录下生成公钥和私钥
其中 id_rsa 是私钥，id_rsa.pub 是公钥
```

### 2.1.1 以 github 为例
```
添加公钥到 github
将 id_rsa.pub 中的内容用 notepad++ 打开，复制内容到 github的：
settings --> ssh and gpg keys --> new ssh keys
--> 然后添加公钥
```

### 2.1.99 TortoiseGit 配置 ssh
```
见上文 【1.2】
```

### 2.1.100 IntelliJ 配置 ssh
```
Settgings --> Version Control --> Subversion --> 
SSH --> Private Key --> Path , 选择生成的 ssh 私钥的位置，此处是：
C:\Users\zx\.ssh\id_rsa
```

## 2.2 https 方式

## 2.3 access_token 方式
