#!/bin/bash

# 这个可以放到 assembly 中, 打包时, 直接打到 lib 同级即可
# 基本使用方式是: 在 lib 文件夹同级目录下, 执行下述命令, 其中: param 是: 带有main方法的类的全限定名
# sh start.sh [param]
# eg: sh start.sh com.zy.hello.world.PlayWrightDemo01

LIB=$(dirname ${0})
echo "LIB [$LIB].."

JARS=`find -L "$LIB" -name '*.jar' -printf '%p:'`
echo "JARS [$JARS].."

$JAVA_HOME/bin/java -cp ${JARS} $*