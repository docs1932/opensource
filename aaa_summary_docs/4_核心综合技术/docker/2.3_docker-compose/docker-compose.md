#示例命令
docker-compose -f docker-compose.yml up -d

#启动后, 进入容器
docker exec -it pid /bin/bash

#查看活着的容器进程
docker ps

#参考资源
https://gitee.com/zhengqingya/docker-compose