#1.先部署好 mysql 服务, 建立名为 nacos 的数据库
#2.从 nacos 官网的包中, 找到 nacos-mysql.sql, 导入到 mysql 中的 naocs 数据库中
#3.执行命令:
docker-compose -f docker-compose-nacos-mysql.yml -p nacos up -d
#4.在浏览器中访问下述地址, 默认用户名/密码: nacos/nacos
http://192.168.1.155:8848/nacos