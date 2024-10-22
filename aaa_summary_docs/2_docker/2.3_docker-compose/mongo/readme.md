#说明
```
1.运行 mongodb
docker-compose -f docker-compose-mongo.yml up -d

2.进入 mongo
docker exec -it mongo /bin/bash

3.添加用户
mongo
use admin
db.createUser({user:"root",pwd:"root",roles:[{role:'root',db:'admin'}]})
exit
exit
```