@echo off
setlocal enabledelayedexpansion

rem 这个可以放到 assembly 中, 打包时, 直接打到 lib 同级即可
rem 基本使用方式是: 在 lib 文件夹同级目录下, 双击 bat 脚本, 然后根据提示输入 带有main方法的类的全限定名
rem eg: com.zy.hello.world.PlayWrightDemo01

set JAVA_OPTS=%JAVA_OPTS% -classpath lib\*;

echo pls input your PackageName.ClassName
set /p task_name=

echo begin to execute your task: %task_name%

%JAVA_HOME%\bin\java %JAVA_OPTS% %task_name%

echo end to execute your task: %task_name%

rem pause