# 芋道系统

# 1.文档

https://doc.iocoder.cn/intro/





# 2.部署

## 2.1 服务端部署 (假定服务器ip: 192.168.24.133)

```
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



## 2.2 部署前端 yudao-ui-admin-vue3

```
1.修改 .env.dev 文件
1.1 请求路径
将 VITE_BASE_URL 改为 nginx 中配置的管理后台页面的 server 监听地址，比如下文 nginx 中的 
192.168.24.56:8081
1.2 上传路径
VITE_UPLOAD_URL，同 1.1
1.3 验证码的开关
VITE_APP_CAPTCHA_ENABLE=false

2.打包
npm run build:dev
会生成一个 dist 目录

3.将 dist 目录下的内容上传到 nginx 所在的机器(是dist下的内容，不是 dist)，比如 
/work/projects/yudao-ui-admin-vue3
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



# 3.微信公众平台

## 3.1 微信公众平台测试账号

[微信公众平台 (qq.com)](https://mp.weixin.qq.com/debug/cgi-bin/sandbox?t=sandbox/login)





# 99 相关信息

## 99.1 后台管理系统

```
localhost:80
admin/admin123
```



## 99.2 移动端商城代码

https://gitee.com/yudaocode/yudao-mall-uniapp







# 100.代码解锁

https://www.iocoder.cn/coke/

