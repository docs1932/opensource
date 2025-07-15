
# 在 windows 上执行 mvn 命令时，如果传递一个变量，则会报错，此时可采用下述方案。

# 定义参数字符串
# $MVN_CLI_OPTS = "-s D:/software/software_for_develop/apache-maven-3.6.0/conf/settings.xml".Split()
# $MVN_CLI_OPTS_1 = "-s D:/software/software_for_develop/apache-maven-3.6.0/conf/settings.xml"
$MVN_CLI_OPTS_2 = @("-s D:/software/software_for_develop/apache-maven-3.6.0/conf/settings.xml".Split())

Set-Location "D:/0000_code/zx/reptile"

# 使用展开语法执行
# 方案1：@MVN_CLI_OPTS 等价于 $MVN_OPTS_ARRAY
# $MVN_OPTS_ARRAY = "-s", "settings.xml"
# mvn @MVN_CLI_OPTS clean
# 方案2：
# mvn @($MVN_CLI_OPTS_1.Split()) clean
# 方案3：
Write-Host "-----------> $($MVN_CLI_OPTS_2.count)"
mvn $MVN_CLI_OPTS_2 clean
