
#安装
docker-compose -f docker-compose-solr.yml up -d

#访问
http://10.102.224.206:8983/solr/#/

#以 root 身份进入容器，5cc257e31f81 是刚才启动的 solr 实例的 容器id
#在容器里root用户的默认ID是0，所以指定root用户的ID即有root权限
docker exec -u 0 -it 5cc257e31f81 bash

#创建 solr core
pwd (此时应当跟 solr 的 bin在同一目录)
cd server/solr
mkdir c1
cp -r configsets/_default/conf/ c1/
cp -r c1/conf/ /var/solr/data/c1/
在 solr admin 管理界面 --> 点击 core admin --> 点击 add core --> 在 name 和 instanceDir 中输入 c1 即可

#添加字段
vi /var/solr/data/c1/conf/managed-schema.xml
<field name="name_cn" type="string" indexed="true" stored="true" multiValued="false" />
<field name="name_en" type="string" indexed="true" stored="true" multiValued="false" />

参考资料
https://www.jianshu.com/p/7c4d9d7dcd94?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation
