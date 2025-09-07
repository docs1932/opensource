
# 1.下载安装 NVM
## 1.1 安装
```
第一次选择 NVM 安装的路径 (手动输入该路径)
D:\software\software_for_develop\nvm

第二次 Set Node.js Symbolink 的路径 (手动输入该路径)
D:\software\software_for_develop\nvm\nodejs
```

## 1.2 安装后环境变量配置
```
1.查看是否建立了环境变量
先在高级系统设置 -> 环境变量 -> 系统变量 -> 查看是否存在：
NVM_HOME --> D:\software\software_for_develop\nvm
NVM_SYMLINK --> D:\software\software_for_develop\nvm\nodejs
如果不存在上述两个系统变量，则新建并赋值即可
2.查看 PATH 中是否配置
在高级系统设置 -> 环境变量 -> 系统变量 -> PATH 中查看是否存在：
%NVM_HOME%
%NVM_SYMLINK%
如果不存在上述两个变量，则在PATH中新增这两个即可
```

## 1.3 设置淘宝镜像：修改安装目录下的 settings.txt
```
node mirror https://npmmirror.com/mirrors/node/
npm mirror https://npmmirror.com/mirrors/npm/
```

## 1.4 验证是否安装成功
```
nvm -v
```

## 1.5 常用命令 (以管理员身份打开 cmd)
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

# 2.安装 Node.js (以管理员身份打开 cmd)
## 2.1 查看已经安装的 Node.js
```
 (以管理员身份打开 cmd)
 nvm list
```
## 2.2 显示可以安装的所有node.js的版本
```
 (以管理员身份打开 cmd)
 nvm list available
```
## 2.3 安装指定版本的 Node.js
```
 (以管理员身份打开 cmd)
 nvm install 20.15.0
 安装完成后查看下述目录是否存在：
 D:\software\software_for_develop\nvm\v20.15.0
```
## 2.4 使用指定版本的 Node.js
```
 (以管理员身份打开 cmd)
 nvm use 20.15.0
 然后查看 Node.js 版本
 node -v
```

## 2.5 设置 node_global 和 node_cache
```
在 D:\software\software_for_develop\nvm\v20.15.0 目录下新建 node_global 和 node_cache 目录
执行以下命令：
npm config set prefix D:\software\software_for_develop\nvm\v20.15.0\node_global\ //全局包目录，就在node安装目录新建了个nodejs文件夹存放
npm config set cache D:\software\software_for_develop\nvm\v20.15.0\node_cache\  //全局包缓存目录，就在node安装目录新建了个nodejs文件夹存放
npm get prefix 查看全局安装的位置
```
 

# 99.参考资源
https://github.com/coreybutler/nvm-windows/releases
https://blog.csdn.net/sun2829191346/article/details/138999964
https://blog.csdn.net/qq_22182989/article/details/125387145
