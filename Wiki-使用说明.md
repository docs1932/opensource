# Wiki 使用说明

## 本地调试

## 0.1 本地启动

在项目根目录执行：

```bash
uv run python -m http.server 3000
```

然后打开 <http://localhost:3000>。

按 `Ctrl+C` 可停止服务。

> Docsify 本质上是静态站点。这里通过 uv 管理并运行 Python 的静态服务器，因此不依赖 Node 或 Docsify CLI，也不会在项目中创建前端依赖。

当前本机的 Node.js 24 与 `docsify-cli` 的间接依赖存在兼容问题；如需继续使用 `docsify serve`，请切换到 Node.js 22 LTS 后重新安装：

```bash
nvm install 22
nvm use 22
npm install --global docsify-cli
docsify serve .
```



# 1. Publish to github

## 1.1 source code

https://github.com/docs1932/opensource.git

## 1.2 publish to github pages

```
在此仓库下，
Settings 
--> Pages 
--> Branch 
选择：master/root
```

## 1.3 visit link

https://docs1932.github.io/opensource/


# 2. Publish to vps
## 2.1 upload all the files to your node
```
such as:
/work/projects/opensource-wiki
```

## 2.2 nginx.conf
```
这里默认使用了 https 的方式，如果不想使用 https，可以注释掉 https 配置，即所有 ssl 相关的配置
```

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
        listen       12345 ssl;
        server_name  192.168.12.34; ## 重要！！！修改成你的 域名/外网IP【nginx所在机器的ip】

        ssl_certificate      /usr/local/nginx/conf/nginx-ssl/cert.pem;  # ssl证书文件位置
        ssl_certificate_key  /usr/local/nginx/conf/nginx-ssl/cert.key;  # ssl证书key的位置
        ssl_protocols TLSv1.1 TLSv1.2 SSLv2 SSLv3; # 支持的 TLS/SSL 协议
        #数字签名
        ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
        ssl_prefer_server_ciphers on;

        location / { ## 前端项目
            root   /work/projects/opensource-wiki;
            index index.html;
        }
    }

}
```

## 2.3 配置端口，以阿里云为例
```
由于上一步监听的端口是：12345，所以：
1.防火墙开放该端口，并刷新
1.1 添加端口
firewall-cmd --zone=public --add-port=12345/tcp --permanent
1.2 重新加载防火墙配置
firewall-cmd --reload

2.阿里云该机器对应的实例的安全组配置中，允许该端口开放
【入方向】新增：
授权策略	    优先级	    协议类型	        端口范围	              授权对象
允许	        1	        自定义 TCP	    目的: 12345/12345     源: 0.0.0.0/0
```

## 2.4 访问该 wiki
https://192.168.12.34:12345


# 100.参考资料

https://docsify.js.org/#/zh-cn/
