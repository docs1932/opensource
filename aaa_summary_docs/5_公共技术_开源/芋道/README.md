# 芋道系统

# 1.概述
## 1.1 代码
```
1.单体服务端
https://gitee.com/zhijiantianya/ruoyi-vue-pro
2.微服务服务端
https://gitee.com/zhijiantianya/yudao-cloud
3.后台管理端前端
https://gitee.com/yudaocode/yudao-ui-admin-vue3
4.商城用户端前端
https://gitee.com/yudaocode/yudao-mall-uniapp

一般使用：
单体部署：1+3+4
微服务部署：2+3+4
```

## 1.2 文档
```
1.单体部署文档
https://doc.iocoder.cn
2.微服务部署文档
https://cloud.iocoder.cn/
```

## 1.3 IDE 内运行
### 1.3.1 运行服务端

```
===================== 环境准备 ===================== 
1.JDK 21
2.IDEA
3.MySQL 8.0
4.导入所有 SQL
5.启动 redis
6.放开父 pom 和 server 模块中关于各个模块的注释
===================== SQL 修改===================== 
DELETE FROM system_menu
WHERE NAME IN ('作者动态','Boot 开发文档','Cloud 开发文档');

===================== yml文件修改 ===================== 
1.[application.yaml]
spring.profiles.active: dev
aj.captcha.water-mark: psyscale
2.[application-dev.yaml]
spring.datasource.dynamic.datasource.master.url=改成自己的
spring.datasource.dynamic.datasource.slave.url=改成自己的
spring.redis.host=改成自己的
yudao.demo=false # 关闭演示模式


===================== IDEA 中修改启动类配置 ===================== 
Edit Configurations -> 
1.Active profiles: dev
2.Shorten command line: JAR manifest


```

https://blog.csdn.net/qq_46258463/article/details/126017142 (flowable报错)

```
查看 flowable-engine 版本, 
\org\flowable\flowable-engine\6.8.0\flowable-engine-6.8.0.jar!\org\flowable\db\create\flowable.mysql.create.engine.sql
insert into ACT_GE_PROPERTY
values ('schema.version', 'x.x.x.x', 1);


然后将数据库表 act_ge_property 及 act_id_property 中 schema.version 字段的 VALUE_ 改成与jar包对应版本即可成功运行！
记得所有旧的 value 都改成最新的 'x.x.x.x'
```

### 1.3.2 运行管理后台的前端

```
===================== 前端项目 YUDAO-UI-ADMIN-VUE3 修改 ===================== 
1.【.env文件】
VITE_APP_TITLE=章鱼管理系统
VITE_APP_DOCALERT_ENABLE=false
VITE_APP_DEFAULT_LOGIN_TENANT =
VITE_APP_DEFAULT_LOGIN_USERNAME =
VITE_APP_DEFAULT_LOGIN_PASSWORD =
2.【.env.local文件】
VITE_APP_CAPTCHA_ENABLE=true
3.【src/views/Home/Index.vue】
注释掉
<el-row class="mt-8px" :gutter="8" justify="space-between">
</el-row> 
4.【src/layout/components/UserInfo/src/UserInfo.vue】
注释掉 
common.document
5.【src/views/Login/components/LoginForm.vue】
注释掉
<el-divider content-position="center">{{ t('login.otherLogin') }}</el-divider>
到【外包咨询】之间内容
6.【src/views/Login/SocialLogin.vue】
【src/views/Login/components/LoginForm.vue】
【src/views/Login/components/MobileForm.vue】
将有关‘芋道源码’的tenant，username,password等都改为空
7.【src/components/DiyEditor/components/mobile/UserCard/index.vue】
将有关‘芋道源码’都改为 章鱼
8.【index.html】
去掉跟‘芋道’有关的内容
9.【src/locales/zh-CN.ts】
default.login.message 置空

99.安装并启动
# 安装 pnpm，提升依赖的安装速度
npm config set registry https://registry.npmmirror.com
npm install -g pnpm
# 安装依赖
pnpm install

# 启动服务
npm run dev

100.访问
启动完成后，浏览器会自动打开 http://localhost:80 (opens new window)地址，可以看到前端界面
默认的用户名密码是：admin/admin123
```


```前端相关配置```
```
1.修改页面布局，菜单展示等
src/store/modules/app.ts
2.关掉 <Setting> 按钮
删除 Layout.vue 中的代码
<Setting></Setting>
3.修改默认配置为白色
src/App.vue 中
setDefaultTheme --》 appStore.setIsDark(false)
```


### 1.3.3 运行 mall 商城前端

```
① 克隆 https://github.com/yudaocode/yudao-mall-uniapp (opens new window)项目，并 Star 关注下该项目。

② 下载 HBuilder (opens new window)工具，并进行安装。

③ 点击 HBuilder 的 [文件 -> 导入 -> 从本地项目导入...] 菜单，选择克隆的 yudao-mall-uniapp 目录

④ 执行如下命令，安装 npm 依赖：
npm i

⑤ 点击 HBuilder 的 [运行 -> 运行到浏览器 -> Chrome] 菜单，使用 H5 的方式运行。成功后，界面如下图所示：
```





# 2.部署

## 2.1 服务端部署 (假定服务器ip: 192.168.24.133)

```
0.请先登录将要部署服务端 jar 包的服务器，安装 font
yum install -y fontconfig
# 安装宋体
yum install wqy-zenhei-fonts
yum install wqy-microhei-fonts

否则，可能在访问首页时可能会报错，Fontconfig head is null, check your fonts or fonts configuration.

# 1.安装字体库（已存在的跳过）
yum -y install fontconfig

# 2.新建存储中文字体的目录
mkdir /usr/share/fonts/chinese

# 3.利用FTP或其他工具将windows字体上传
将 C:\Windows\Fonts 整个目录压缩，然后打包上传至 linux

# 4.安装ttmkfdir用于搜索目录中所有的字体信息并汇总生成fonts.scale文件
yum -y install ttmkfdir
ttmkfdir -e /usr/share/X11/fonts/encodings/encodings.dir

# 5.添加中文字体路径
#vi /etc/fonts/fonts.conf
<!-- Font directory list -->
<dir>/usr/share/fonts/chinese</dir>

# 6.刷新缓存
fc-cache

# 7.验证
fc-list

# 8.重启系统使得修改生效!!!!

https://blog.51cto.com/u_16099244/12371136
https://www.cnblogs.com/cpw6/p/13639428.html


1.放开 主 pom 和 yudao-server 下 pom 的关于 module 的注释
pom.xml
yudao-server/pom.xml

2.修改 application-dev.yaml 中
关于 mysql, redis 的配置
同时添加 下述配置暂时忽略验证码并且把‘演示模式’改为 false
yudao:
  captcha:
    enable: false
  demo: false

3.激活 application.yaml 文件配置
spring:
  profiles:
    active: dev

4.执行 mvn clean package -DskipTests=true 打包
生成的包在 
yudao-server/target/yudao-server.jar

5.上传 jar 包到服务器的 /work/projects/yudao-server 目录

6.在同目录下 vi deploy.sh，并复制以下内容：
参见下文

7.修改文件权限
chmod 777 deploy.sh

8.启动程序 (请提前安装好 jdk 17)
sh deploy.sh

9.在 centos7 上使用 firewall-cmd 命令开启对应的端口并重新加载防火墙配置

10.在阿里云安全组上配置该端口的安全策略
```



```deploy.sh```

```
#!/bin/bash
set -e

DATE=$(date +%Y%m%d%H%M)
# 基础路径
BASE_PATH=/work/projects/yudao-server
# 服务名称。同时约定部署服务的 jar 包名字也为它。
SERVER_NAME=yudao-server
# 环境
PROFILES_ACTIVE=dev

# heapError 存放路径
HEAP_ERROR_PATH=$BASE_PATH/heapError
# JVM 参数
JAVA_OPS="-Xms512m -Xmx512m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$HEAP_ERROR_PATH"

# SkyWalking Agent 配置
#export SW_AGENT_NAME=$SERVER_NAME
#export SW_AGENT_COLLECTOR_BACKEND_SERVICES=192.168.0.84:11800
#export SW_GRPC_LOG_SERVER_HOST=192.168.0.84
#export SW_AGENT_TRACE_IGNORE_PATH="Redisson/PING,/actuator/**,/admin/**"
#export JAVA_AGENT=-javaagent:/work/skywalking/apache-skywalking-apm-bin/agent/skywalking-agent.jar

# 停止：优雅关闭之前已经启动的服务
function stop() {
    echo "[stop] 开始停止 $BASE_PATH/$SERVER_NAME"
    PID=$(ps -ef | grep $BASE_PATH/$SERVER_NAME | grep -v "grep" | awk '{print $2}')
    # 如果 Java 服务启动中，则进行关闭
    if [ -n "$PID" ]; then
        # 正常关闭
        echo "[stop] $BASE_PATH/$SERVER_NAME 运行中，开始 kill [$PID]"
        kill -15 $PID
        # 等待最大 120 秒，直到关闭完成。
        for ((i = 0; i < 120; i++))
            do
                sleep 1
                PID=$(ps -ef | grep $BASE_PATH/$SERVER_NAME | grep -v "grep" | awk '{print $2}')
                if [ -n "$PID" ]; then
                    echo -e ".\c"
                else
                    echo '[stop] 停止 $BASE_PATH/$SERVER_NAME 成功'
                    break
                fi
                    done

        # 如果正常关闭失败，那么进行强制 kill -9 进行关闭
        if [ -n "$PID" ]; then
            echo "[stop] $BASE_PATH/$SERVER_NAME 失败，强制 kill -9 $PID"
            kill -9 $PID
        fi
    # 如果 Java 服务未启动，则无需关闭
    else
        echo "[stop] $BASE_PATH/$SERVER_NAME 未启动，无需停止"
    fi
}

# 启动：启动后端项目
function start() {
    # 开启启动前，打印启动参数
    echo "[start] 开始启动 $BASE_PATH/$SERVER_NAME"
    echo "[start] JAVA_OPS: $JAVA_OPS"
    echo "[start] JAVA_AGENT: $JAVA_AGENT"
    echo "[start] PROFILES: $PROFILES_ACTIVE"

    # 开始启动
    nohup java -server $JAVA_OPS $JAVA_AGENT -jar $BASE_PATH/$SERVER_NAME.jar --spring.profiles.active=$PROFILES_ACTIVE > nohup.out 2>&1 &
    echo "[start] 启动 $BASE_PATH/$SERVER_NAME 完成"
}

# 部署
function deploy() {
    cd $BASE_PATH
    # 第一步：停止 Java 服务
    stop
    # 第二步：启动 Java 服务
    start
}

deploy
```



## 2.2 部署管理台前端 yudao-ui-admin-vue3

```
1.修改 .env.dev 文件
1.1 请求路径
将 VITE_BASE_URL 改为 nginx 中配置的管理后台页面的 server 监听地址，比如下文 nginx 中的 
192.168.24.56:8081
1.2 上传路径
VITE_UPLOAD_URL，同 1.1
1.3 商城H5会员端域名
VITE_MALL_H5_DOMAIN
1.4 验证码的开关
VITE_APP_CAPTCHA_ENABLE=true

2.打包
清理缓存：
npm cache clean --force
删除 node_modules 文件夹和 package-lock.json 文件：
rm -rf node_modules
rm package-lock.json
重新安装依赖：
npm install
打包
npm run build:dev (部署到 dev 环境, 会生成一个 dist 目录)或者
npm run build:prod (部署到生产环境, 会生成一个 dist-prod 目录)


【重要：请全文搜索并检查 VITE_BASE_URL 和 VITE_UPLOAD_URL，确保它们都指向了 nginx 的配置。】
【重要：请全文搜索并检查 VITE_BASE_URL 和 VITE_UPLOAD_URL，确保它们都指向了 nginx 的配置。】
【重要：请全文搜索并检查 VITE_BASE_URL 和 VITE_UPLOAD_URL，确保它们都指向了 nginx 的配置。】
【例如：在 .env.dev 文件中，VITE_BASE_URL 和 VITE_UPLOAD_URL 不应该再是 localhost】

3.将 dist 目录下的内容上传到 nginx 所在的机器(是dist下的内容，不是 dist)，比如 
/work/projects/yudao-ui-admin-vue3

4.nginx
    server {
        listen       37269 ssl;
        server_name  192.168.24.56; ## 重要！！！修改成你的外网 IP/域名

        ssl_certificate      /etc/letsencrypt/live/zy.com/fullchain.pem;  # ssl证书文件位置
        ssl_certificate_key  /etc/letsencrypt/live/zy.com/privkey.pem;  # ssl证书key的位置
        ssl_protocols TLSv1.1 TLSv1.2 SSLv2 SSLv3; # 支持的 TLS/SSL 协议
        #数字签名
        ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
        ssl_prefer_server_ciphers on;

        location / { ## 前端项目
            root   /work/projects/yudao-ui-admin-vue3;
            index  index.html index.htm;
            try_files $uri $uri/ /index.html;
        }

        location /admin-api/ { ## 后端项目 - 管理后台
            proxy_pass http://192.168.24.133:48080/admin-api/; ## 重要！！！proxy_pass 需要设置为后端项目所在服务器的 IP
            # 如果是域名解析到香港 ip 且未备案, 而后端服务器是境内的，则可以注释掉本行
            # 如果是域名解析到香港 ip 且未备案, 而后端服务器是境内的，则可以注释掉本行
            # 如果是域名解析到香港 ip 且未备案, 而后端服务器是境内的，则可以注释掉本行
            #proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header REMOTE-HOST $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

    }

```



## 2.3  部署用户侧前端 yudao-mall-uniapp
### 2.3.1 部署到微信小程序

https://blog.csdn.net/2301_76481677/article/details/139056582

### 2.3.2 部署到 PC
```
1.代码下载
https://github.com/yudaocode/yudao-mall-uniapp
https://gitee.com/yudaocode/yudao-mall-uniapp

2.修改 .env 文件中的
SHOPRO_BASE_URL 为你自己的域名

3.修改 manifest.json：
uni-app 应用表示(AppID) --> 点击重新获取

4.打包：
如果没有 node_modules 文件夹，则执行 npm install 安装依赖
然后在 HBuild 中 -> 发行 -> 网站 PC Web或手机H5 
打的包会在 yudao-mall-uniapp\unpackage\dist\build\web，
然后 zip 所有文件及文件夹到 web.zip 文件

5.将打包好的内容 web.zip 上传到 nginx 所在的机器
/work/projects/yudao-mall-uniapp
并解压 web.zip 

6.配置 nginx
    server {
        listen       443 ssl;
        server_name  192.168.24.56; ## 重要！！！修改成你的外网 IP/域名

        ssl_certificate      /etc/letsencrypt/live/zy.com/fullchain.pem;  # ssl证书文件位置
        ssl_certificate_key  /etc/letsencrypt/live/zy.com/privkey.pem;  # ssl证书key的位置
        ssl_protocols TLSv1.1 TLSv1.2 SSLv2 SSLv3; # 支持的 TLS/SSL 协议
        #数字签名
        ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
        ssl_prefer_server_ciphers on;

        location / { ## 前端项目
            root   /work/projects/yudao-mall-uniapp;
            index  index.html index.htm;
            try_files $uri $uri/ /index.html;
        }

        location /app-api/ { ## 后端项目 - 用户 App
            proxy_pass http://192.168.24.133:48080/app-api/; ## 重要！！！proxy_pass 需要设置为后端项目所在服务器的 IP
            # 如果是域名解析到香港 ip 且未备案, 而后端服务器是境内的，则可以注释掉本行
            # 如果是域名解析到香港 ip 且未备案, 而后端服务器是境内的，则可以注释掉本行
            # 如果是域名解析到香港 ip 且未备案, 而后端服务器是境内的，则可以注释掉本行
            #proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header REMOTE-HOST $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

    }
    
7.重启 nginx    

8.用 pad 访问即可
https://192.168.24.56
```



## 2.3 配置 nginx (假定 nginx 机器所在ip:192.168.24.56)

```
1.修改 nginx.conf 如下文

2.重启 nginx
/usr/local/nginx/sbin/nginx -s reload
```



```nginx.conf```

```
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;

    gzip on;
    gzip_min_length 1k;     # 设置允许压缩的页面最小字节数
    gzip_buffers 4 16k;     # 用来存储 gzip 的压缩结果
    gzip_http_version 1.1;  # 识别 HTTP 协议版本
    gzip_comp_level 2;      # 设置 gzip 的压缩比 1-9。1 压缩比最小但最快，而 9 相反
    gzip_types gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript; # 指定压缩类型
    gzip_proxied any;       # 无论后端服务器的 headers 头返回什么信息，都无条件启用压缩

    server {
        listen       8081;
        server_name  192.168.24.56; ## 重要！！！修改成你的外网 IP/域名

        location / { ## 前端项目
            root   /work/projects/yudao-ui-admin-vue3;
            index  index.html index.htm;
            try_files $uri $uri/ /index.html;
        }

        location /admin-api/ { ## 后端项目 - 管理后台
            proxy_pass http://192.168.24.133:48080/admin-api/; ## 重要！！！proxy_pass 需要设置为后端项目所在服务器的 IP
            # 如果是域名解析到香港 ip 且未备案, 而后端服务器是境内的，则可以注释掉本行
            # 如果是域名解析到香港 ip 且未备案, 而后端服务器是境内的，则可以注释掉本行
            # 如果是域名解析到香港 ip 且未备案, 而后端服务器是境内的，则可以注释掉本行
            #proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header REMOTE-HOST $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

    }

    server {
        listen       8082;
        server_name  192.168.24.56; ## 重要！！！修改成你的外网 IP/域名

        location / { ## 前端项目
            root   /work/projects/yudao-mall-uniapp;
            index  index.html index.htm;
            try_files $uri $uri/ /index.html;
        }

        location /app-api/ { ## 后端项目 - 用户 App
            proxy_pass http://192.168.24.133:48080/app-api/; ## 重要！！！proxy_pass 需要设置为后端项目所在服务器的 IP
            # 如果是域名解析到香港 ip 且未备案, 而后端服务器是境内的，则可以注释掉本行
            # 如果是域名解析到香港 ip 且未备案, 而后端服务器是境内的，则可以注释掉本行
            # 如果是域名解析到香港 ip 且未备案, 而后端服务器是境内的，则可以注释掉本行
            #proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header REMOTE-HOST $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }

    }

}
```


# 3.其他细节
## 3.1 代码生成
### 3.1.1 请参考代码生成的逻辑------这是首选方案

### 3.1.2 如果是手动创建，则几个关键点
```
1.如果某张表不希望有 tenant_id，则需要配置：
yudao.tenant.ignore-tables

2.新建的模块的 biz 模块需要在 yudao-server 的 pom.xml 中引入
        <dependency>
            <groupId>cn.iocoder.boot</groupId>
            <artifactId>yudao-module-pay-biz</artifactId>
            <version>${revision}</version>
        </dependency>

3.注意配置 swagger 相关的类
```

## 3.2 想要一个接口完全对外开放: @PermitAll
```
@PermitAll
@GetMapping("/get")
public CommonResult<ScaleRespVO> getScale(@RequestParam("id") Long id) {
    ScaleDO scale = scaleService.getScale(id);
    return success(BeanUtils.toBean(scale, ScaleRespVO.class));
}
```

## 3.3 想要一个接口不走 tenant_id 的逻辑
```
在 application.yml 的 yudao.tenant.ignore-urls 中添加该接口
```

## 3.4 想要一张表不走tenant_id 的逻辑
```
1.表中不设计 tenant_id 字段
2.在 application.yml 的 yudao.tenant.ignore-tables 配置中添加该表名称
```

## 3.5 想要在开发环境看 sql 的日志
```
在 application-dev.yml 中配置如下：
# 开发环境日志级别是 debug
mybatis-plus:
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
```

# 99 相关信息

## 99.1 后台管理系统

```
localhost:80
admin/admin123
```




# 100.代码解锁

https://www.iocoder.cn/coke/

