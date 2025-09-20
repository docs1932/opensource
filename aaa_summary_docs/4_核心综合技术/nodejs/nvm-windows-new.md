# 1.下载安装
## 1.1 清理旧环境
```
1.通过控制面板卸载 node.js

2.删除本地 nodejs 安装目录
默认是C:\Program Files\nodejs，也可能在其他盘，主要取决于安装时的选择。

3.查找.npmrc文件是否存在，有就删除
默认在C:\User\自己电脑用户名

4.逐一查看一下文件是否存在，存在就删除
C:\Program Files (x86)\Nodejs
C:\Program Files\Nodejs
C:\Users\自己电脑用户名\AppData\Roaming\npm
C:\Users\自己电脑用户名\AppData\Roaming\npm-cache

5.打开系统设置，检查系统环境变量，将node相关的环境变量都删掉，
>> NODE_PATH
>> PATH 中 nodejs 相关的配置

6.查看是否删除成功
win + R ，cmd ，回车，输入node -v，回车，显示：node不是内部或外部命令，也不是可运行的程序或批处理文件。
```

## 1.2 下载安装 nvm
```
1.下载地址：
https://github.com/coreybutler/nvm-windows/releases

2.一直点NEXT，需要注意的地方是：
>> 选择nvm的安装路径：
         D:\software\software_for_develop\nvm\nvm
>> 选择nodejs的快捷方式路径（这里一定得是空文件夹或者不创建这个文件夹，因为nvm会自动创建这个文件夹为快捷方式）：
        D:\software\software_for_develop\nvm\nodejs

3.检查系统变量
环境变量：检查是否有nvm环境变量，没有的话，加上；
>> NVM_HOME： D:\software\software_for_develop\nvm\nvm (nvm安装路径)
>> NVM_SYMLINK： D:\software\software_for_develop\nvm\nvm (nvm自动创建的nodejs文件夹的快捷方式路径)

4.检查 PATH 是否添加nvm环境变量，没有的话，加上；
%NVM_HOME%
%NVM_SYMLINK%

5.cmd验证
nvm -v，出现安装的nvm版本说明安装成功

6.修改 nvm 安装目录下的 settings.txt，配置镜像 D:\software\software_for_develop\nvm\nvm\settings.txt
node mirror https://npmmirror.com/mirrors/node/
npm mirror https://npmmirror.com/mirrors/npm/

7.在 nvm 安装目录下，创建 global 和 cache 目录
在 D:\software\software_for_develop\nvm\nvm\ 创建 npm 目录，
然后在 npm 目录下，创建 node_global 和 node_cache

8.进一步添加环境变量
>> NODE_PATH：D:\software\software_for_develop\nvm\nvm\npm\node_global\node_modules
>> PATH：D:\software\software_for_develop\nvm\nvm\npm\node_global  (这里十分关键，不能丢失！！！！！！！！)
>> PATH：%NODE_PATH%

9.安装 nodejs, 以管理员模式打开 powershell 或者 cmd
nvm install 24.8.0
nvm use 24.8.0
node -v
npm -v

10.配置 node global 和 node cache
npm config set prefix D:\software\software_for_develop\nvm\nvm\npm\node_global
npm config set cache D:\software\software_for_develop\nvm\nvm\npm\node_cache

检查配置
npm config get prefix
npm config get cache
```


## 1.3 常用命令 (以管理员身份打开 cmd)
```
nvm命令行操作命令
 (以管理员身份打开 cmd)
 (以管理员身份打开 cmd)
 (以管理员身份打开 cmd)
 
- nvm ls // 列出所有版本
- nvm list // 查看已经安装的版本
- nvm list installed // 查看已经安装的版本
- nvm list available // 查看网络可以安装的版本
- nvm install <version> // 安装node.js的命名 version是版本号 例如：nvm install 8.12.0
- nvm uninstall <version> // 卸载node.js是的命令，卸载指定版本的nodejs，当安装失败时卸载使用
- nvm reinstall-packages <version> // 在当前版本node环境下，重新全局安装指定版本号的npm包
- nvm use <version> // 切换使用指定的版本node
- nvm current // 显示当前版本
- nvm alias <name> <version> // 给不同的版本号添加别名
- nvm unalias <name> // 删除已定义的别名
 
- nvm on // 启用node.js版本管理
- nvm off // 禁用node.js版本管理(不卸载任何东西)
 
- nvm proxy // 查看设置与代理
- nvm use [version] [arch] // 切换制定的node版本和位数
 
- nvm root [path] // 设置和查看root路径
- nvm version // 查看当前的版本

// 也可以直接修改 nvm 安装目录下的 settings.txt 文件，记得在文件中追加即可，不要覆盖掉原来的内容。
- nvm node_mirror [url] 设置或者查看setting.txt中的node_mirror，如果不设置的默认是 https://nodejs.org/dist/
- nvm npm_mirror [url] 设置或者查看setting.txt中的npm_mirror,如果不设置的话默认的是： https://github.com/npm/npm/archive/.

```


# 2.项目
## 2.1 项目启动管理，以 angular 为例
```
# 这里指定了 host 为 0.0.0.0，即指定了 ip 为 0.0.0.0，端口为 4200,
# 然后通过 ipconfig 查看自己的 ip 地址，然后通过浏览器访问 http://ip:port
# 如果其他开发者 跟你在同一个局域网下，那么就可以通过 ip:port 访问项目了
# 前提是你要关闭自己防火墙设置，允许其他人访问
  "scripts": {
    "ng": "ng",
    "start": "ng serve --host 0.0.0.0 --port 4200",
    "build": "ng build",
    "watch": "ng build --watch --configuration development",
    "test": "ng test"
  }
```

# 99.参考资源
https://github.com/coreybutler/nvm-windows/releases
https://blog.csdn.net/sun2829191346/article/details/138999964
https://blog.csdn.net/qq_22182989/article/details/125387145
