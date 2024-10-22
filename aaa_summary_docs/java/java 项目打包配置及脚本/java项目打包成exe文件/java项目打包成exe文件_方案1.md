
# JPackage指令将可执行Jar包打包成EXE运行程序和MSI安装程序

# 1.前置工作
## 1.1 环境要求
```
JPackage指令是JAVA 14新增的，所以安装的JAVA版本必须14+；
Windows系统下使用Jpackage指令需要先下载并安装 WiX.exe 软件，版本3.11及以上，并配置好环境变量；
jar包打包成EXE的前提是jar包可以用java -jar XXX.jar的方式直接运行。
```

## 1.2 基本现象
```
使用Jpackage指令但未安装WiX时的提示：
[18:01:09.359] 找不到 WiX 工具 (light.exe, candle.exe)
[18:01:09.359] 从 https://wixtoolset.org 下载 WiX 3.0 或更高版本，然后将其添加到 PATH。
错误：类型 [msi] 无效或不受支持
```

## 1.3 WiX.exe
```
WiX.exe的下载地址：https://wixtoolset.org/docs/wix3/
它的默认安装位置：C:\Program Files (x86)\WiX Toolset v3.11
配置环境变量：在Path中增加C:\Program Files (x86)\WiX Toolset v3.11\bin;。
```

## 1.4 .Net Framework
```
安装WiX.exe之前需要先安装".Net Framework 3.5.1"

安装步骤：
1、找到在Windows-控制面板-程序-启用和关闭Windows功能；
2、勾选.Net Framework 3.5.1（包括 .Net 2.0 和 3.0），点击确定，再点击同意下载；
3、等待自动下载并安装完成；
4、最后重新启动计算机。
```

# 2.打包指令
```
下述的中括号[]的内容表示要依据实际情况填写的参数：
1.生成运行程序：
jpackage --type app-image --input [Jar包所在文件夹] --runtime-image [Jre文件夹] --name [应用名称] --main-jar [可执行Jar包] --icon [程序图标的路径] --app-version [版本号] --vendor [程序供应商的名称] --copyright [版权信息] --description [应用描述] --dest [输出目录]

2.生成安装程序：
jpackage --type msi --win-dir-chooser --name [安装程序的名称] --app-image [运行程序的文件夹] --dest [输出目录]

解释说明如下：
1、完成步骤1即生成了可执行exe。
2、步骤1中的[可执行Jar包]参数直接写"文件名.jar"即可，不需要写路径，但该Jar包必须存在于[Jar包所在文件夹]中。
3、步骤1中的--runtime-image [Jre文件夹]是选填，可以去掉。若去掉，则运行EXE的电脑上必须有JAVA环境并且配置了环境变量。
[Jre文件夹]可以填写安装java时的Jre环境的目录，或自己精简后的Jre环境的目录。
4、步骤2中的[运行程序的文件夹]是步骤1中的[输出目录]。
```

## 2.1 使用示例
```
# step1 生成对应的目录
jpackage --type app-image --input /0000_code/zx/demo/target --runtime-image /software/software_for_develop/jdk-17.0.6 --name zx-cat --main-jar zx.jar --icon /tmp/img/cat.ico --app-version 1.0 --vendor zx --copyright cr --description desc

# step2 生成 msi 文件
jpackage --type msi --win-dir-chooser --name gl-zx-cat --app-image /zx-cat --dest /tmp
```

# 3.JPackage 指令含义
```
用法: jpackage <options>

简单示例:
--------------
    生成适合主机系统的应用程序包:
        对于模块化应用程序:
            jpackage -n name -p modulePath -m moduleName/className
        对于非模块化应用程序:
            jpackage -i inputDir -n name --main-class className --main-jar myJar.jar
        来自预构建的应用程序映像:
            jpackage -n name --app-image appImageDir
    
    生成预构建的应用程序映像:
        对于模块化应用程序:
            jpackage --type app-image -n name -p modulePath -m moduleName/className
        对于非模块化应用程序:
            jpackage --type app-image -i inputDir -n name --main-class className --main-jar myJar.jar
        要为jlink提供自己的选项，请单独运行jlink:
            jlink --output appRuntimeImage -p modulePath --add-modules moduleName --no-header-files [<additional jlink options>...]
            jpackage --type app-image -n name -m moduleName/className --runtime-image appRuntimeImage

    生成Java运行时包:
        jpackage -n name --runtime-image <runtime-image>

通用选项:
  @<filename> 
          从文件中读取选项和(或)模式;
          此选项可多次使用.
  --type -t <type> 
          要创建的包的类型;
          有效值为: {"app-image", "exe", "msi"};
          如果未指定此选项，将创建一个依赖于平台的默认类型.
  --app-version <version>
          应用程序和(或)包的版本
  --copyright <copyright string>
          应用程序的版权
  --description <description string>
          应用描述
  --help -h 
          将包含当前平台每个有效选项的列表和描述的使用文本打印到输出流中，然后退出.
  --icon <file path>
          应用程序包图标的路径(绝对路径或相对于当前目录).
  --name -n <name>
          应用程序和(或)包的名称
  --dest -d <destination path>
          生成的输出文件所在的路径(绝对路径或相对于当前目录);
          默认为当前工作目录.
  --temp <directory path>
          用于创建临时文件的新目录或空目录的路径(绝对路径或相对于当前目录);
          如果指定，临时目录将不会在任务完成时删除，必须手动删除;
          如果没有指定，将在任务完成时创建并删除一个临时目录.
  --vendor <vendor string>
          应用程序的供应商.
  --verbose
          启用详细输出
  --version
          将产品版本打印到输出流并退出.

用于创建运行时映像的选项:
  --add-modules <module name>[,<module name>...]
          要添加的模块列表，以英文逗号(",")分隔
          这个模块列表连同主模块(如果指定)将作为--add-module参数传递给jlink.
          如果没有指定，则只使用主模块(如果指定了--module)，或者使用默认的模块集(如果指定了--main-jar).
          此选项可多次使用.
  --module-path -p <module path>...
          一个英文分号(";")分隔的路径列表
          每个路径必须是模块的目录，或者是模块jar文件的路径(每个路径都是绝对或相对于当前目录).
          此选项可多次使用.
  --jlink-options <jlink options> 
          一个以空格分隔的传递给jlink的选项列表 
          If not specified, defaults to "--strip-native-commands --strip-debug --no-man-pages --no-header-files". 
          此选项可多次使用.
  --runtime-image <directory path>
          将复制到应用程序映像中的预定义运行时映像的路径(绝对路径或相对于当前目录)
          如果没有指定--runtime-image，jpackage将运行jlink来使用选项创建运行时映像：--strip-debug、--no-header-files、--no-man-pages和--strip-native-commands.

用于创建应用程序映像的选项:
  --input -i <directory path>
          包含要打包的jar文件的输入目录的路径(绝对路径或相对于当前目录)
          输入目录中的所有文件都将打包到应用程序映像中.

用于创建应用程序启动器的选项:
  --add-launcher <launcher name>=<file path>
          启动器的名称，以及包含键、值对列表的Properties文件的路径(绝对路径或相对于当前目录)
          可用的键：“module”、“main-jar”、“main-class”、“arguments”、“java-options”、“app-version”、“icon”和“win-console”.
          这些选项被添加到或用于覆盖原始命令行选项，以构建额外的替代启动程序.
          主应用程序启动器将从命令行选项构建。使用这个选项可以建造额外的替代启动器，并且这个选项可以多次使用来建造多个额外的启动器. 
  --arguments <main class arguments>
          如果没有给启动程序提供命令行参数，则要传递给主类的命令行参数
          此选项可多次使用.
  --java-options <java options>
          要传递给Java运行时的选项
          此选项可多次使用.
  --main-class <class name>
          要执行的应用程序主类的限定名称。
          这个选项只能在指定--main-jar时使用.
  --main-jar <main jar file>
          应用程序的主JAR;
          包含主类(指定为相对于输入路径的路径);
          --module或--main-jar选项可以指定，但不能同时指定.
  --module -m <module name>[/<main class>]
          应用程序的主模块(可选的主类);
          此模块必须位于模块路径上;
          指定此选项时，将在Java运行时映像中链接主模块。--module或--main-jar选项可以指定，但不能同时指定.

用来创建应用程序启动程序的与平台相关的选项：
  --win-console
          为应用程序创建控制台启动程序，应当为
          需要控制台交互的应用程序指定

用于创建应用程序包的选项:
  --about-url <url>
          应用程序主页的URL
  --app-image <directory path>
          用于构建可安装包的预定义应用程序映像的位置(绝对路径或相对于当前目录)。
  --file-associations <file path>
          包含键值对的列表的属性文件的路径(绝对路径或相对于当前目录)
          “extension”、“mime-type”、“icon”和“description”可用于描述该关联。
          此选项可多次使用。.
  --install-dir <directory path>
          默认安装位置下面的相对子路径
  --license-file <file path>
          license文件的路径(绝对路径或相对于当前目录)
  --resource-dir <directory path>
          覆盖jpackage资源的路径.
          通过向这个目录添加替换资源，可以覆盖jpackage的图标、模板文件和其他资源(绝对路径或相对于当前目录).
  --runtime-image <directory path>
          要安装的预定义运行时映像的路径(绝对路径或相对于当前目录)
          本选项在创建运行时包时是必需的！

Platform dependent options for creating the application package:
  --win-dir-chooser
          添加一个对话框，使用户能够选择产品的安装位置.
  --win-help-url <url>
          用户获取进一步信息或技术支持的网址.
  --win-menu
          请求为此应用程序添加开始菜单快捷方式
  --win-menu-group <menu group name>
          应用程序所在的开始菜单组
  --win-per-user-install
          请求在每个用户的基础上执行安装
  --win-shortcut
          请求为此应用程序添加桌面快捷方式
  --win-shortcut-prompt
          添加一个对话框，允许用户选择安装程序是否创建快捷方式.
  --win-update-url <url>
          可用的应用程序更新信息的URL
  --win-upgrade-uuid <id string>
          与此包的升级相关联的UUID
```

# 4.使用 maven 来实现打包


# 参考资料
https://blog.csdn.net/Mr_Door/article/details/128319594
https://akman.github.io/jpackage-maven-plugin/
https://wixtoolset.org/
