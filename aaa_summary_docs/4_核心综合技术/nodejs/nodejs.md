
# 0.库
https://www.npmjs.com/ (类似于 maven 中央仓库)


# 1.安装使用
```
1.在指定目录下 D:\software\software_for_develop\nodejs 

2.下载 msi/exe 文件，并安装 nodejs 到 D:\software\software_for_develop\nodejs\nodejs

3.在 D:\software\software_for_develop\nodejs 创建两个文件夹 
node_global
node_cache
 
3.设置：【以管理员身份运行！！！！！！！】
npm config set prefix D:\software\software_for_develop\nodejs\nodejs\node_global
npm config set cache D:\software\software_for_develop\nodejs\nodejs\node_cache

验证：
npm config get prefix
npm config get cache

4.修改环境变量‌： 
在“系统变量”中新建 
NODE_PATH=D:\software\software_for_develop\nodejs\nodejs\node_global\node_modules
编辑“Path”变量，添加：
%NODE_PATH% 
D:\software\software_for_develop\nodejs\nodejs\node_global

5.更换淘宝镜像‌：执行以下命令加速npm下载
npm config set registry https://registry.npm.taobao.org/
验证配置：npm config get registry

============== 此时可以在 C:\Users\zx 目录下看到 .npmrc 文件 ============
prefix=D:\software\software_for_develop\nodejs\nodejs\node_global
cache=D:\software\software_for_develop\nodejs\nodejs\node_cache
registry=https://registry.npm.taobao.org/
========================================================
 
6.安装 cnpm
npm install -g cnpm --registry=https://registry.npm.taobao.org
```

https://cloud.tencent.com/developer/article/2408561


# 2.常用命令
```
# 安装依赖
npm install
# 更新依赖
npm  update
# 删除依赖
npm uninstall
# 运行项目
npm run dev
# 构建项目
npm run build
# 启动项目
npm start
 
#清理缓存
npm cache clean --force
#验证缓存状态
npm cache verify
```

## 2.1 启动时指定 ip 和 port (适用于前后端联调时)
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