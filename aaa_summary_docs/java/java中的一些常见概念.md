
# 1.classpath
```
classpath 下找的是 .class 文件，不是 .java 文件！！！
```

## 1.1 什么是 classpath
```
classpath是JVM用到的一个环境变量，它用来指示JVM如何搜索class。

因为Java是编译型语言，源码文件是.java，而编译后的.class文件才是真正可以被JVM执行的字节码。
因此，JVM需要知道，如果要加载一个abc.xyz.Hello的类，应该去哪搜索对应的Hello.class文件。
所以，classpath就是一组目录的集合，它设置的搜索路径与操作系统相关。
例如，
在Windows系统上，用;分隔，带空格的目录用""括起来，可能长这样：
C:\work\project1\bin;C:\shared;"D:\My Documents\project1\bin"
在Linux系统上，用:分隔，可能长这样：
/usr/shared:/usr/local/bin:/home/liaoxuefeng/bin

现在我们假设classpath是.;C:\work\project1\bin;C:\shared，
当JVM在加载abc.xyz.Hello这个类时，会依次查找：
<当前目录>\abc\xyz\Hello.class
C:\work\project1\bin\abc\xyz\Hello.class
C:\shared\abc\xyz\Hello.class
注意到.代表当前目录。
如果JVM在某个路径下找到了对应的class文件，就不再往后继续搜索。
如果所有路径下都没有找到，就报错。
```

## 1.2 classpath 的设置方式
```
classpath 的设定方法有两种：
1.在系统环境变量中设置classpath环境变量，不推荐；
2.在启动JVM时设置classpath变量，推荐。

我们强烈不推荐在系统环境变量中设置classpath，那样会污染整个系统环境。
在启动JVM时设置classpath才是推荐的做法。
实际上就是给java命令传入 -classpath 或 -cp 参数：
java -classpath .;C:\work\project1\bin;C:\shared abc.xyz.Hello
或者
java -cp .;C:\work\project1\bin;C:\shared abc.xyz.Hello

如果没有设置系统环境变量，也没有传入-cp参数，那么JVM默认的classpath为.，即当前目录：
java abc.xyz.Hello (该命令告诉JVM只在当前目录搜索Hello.class。)

```

## 1.3 最原始的使用 java -cp 运行 class 文件的方式
```
假设我们有一个 D:\0000_code\zx\my_leetcode\src\main\java\com\zy\java\jol\JolTest1.java 文件，里面内容是：

package com.zy.java.jol;

public class JolTest1 {

    public static void main(String[] args) {
        f1();
    }

    private static void f1() {
        System.out.println("-----------------");
    }
}

1.首先进入 D:\0000_code\zx\my_leetcode\src\main\java\ 目录，执行命令编译生成 class 文件
javac com\zy\java\jol\JolTest1.java

执行该命令后，会生成一个 D:\0000_code\zx\my_leetcode\src\main\java\com\zy\java\jol\JolTest1.class 文件

2.其次，在 D:\0000_code\zx\my_leetcode\src\main\java\ 目录，执行 java 命令运行该文件
java -cp .;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar; com.zy.java.jol.JolTest1

执行该命令后，会在控制台看到输出了一行对应的结果
```

## 1.4 jar 包中的 classpath
```
如果有很多.class文件，散落在各层目录中，肯定不便于管理。如果能把目录打一个包，变成一个文件，就方便多了。

jar包就是用来干这个事的，它可以把package组织的目录层级，
以及各个目录下的所有文件（包括.class文件和其他文件）都打成一个jar文件，
这样一来，无论是备份，还是发给客户，就简单多了。

jar包实际上就是一个zip格式的压缩文件，而jar包相当于目录。
如果我们要执行一个jar包的class，就可以把jar包放到classpath中：
java -cp ./hello.jar abc.xyz.Hello
这样JVM会自动在hello.jar文件里去搜索某个类。

jar包还可以包含一个特殊的/META-INF/MANIFEST.MF文件，
MANIFEST.MF是纯文本，可以指定Main-Class和其它信息。
JVM会自动读取这个MANIFEST.MF文件，如果存在Main-Class，
我们就不必在命令行指定启动的类名，而是用更方便的命令：
java -jar hello.jar

在大型项目中，不可能手动编写 MANIFEST.MF 文件，再手动创建zip包。
Java 社区提供了大量的开源构建工具，例如 Maven，可以非常方便地创建jar包。
```

## 1.5 运行jar包时的classpath
```
Jvm寻找class的顺序：

1. Bootstrap classes
属于Java 平台核心的class,比如java.lang.String等.及rt.jar等重要的核心级别的class.
这是由JVM Bootstrap class loader来载入的.一般是放置在{java_home}\jre\lib目录下

2. Extension classes
基于Java扩展机制,用来扩展Java核心功能模块.
比如Java串口通讯模块comm.jar.一般放置在{Java_home}\jre\lib\ext目录下

3. User classes
开发人员或其他第三方开发的Java程序包.
通过命令行的-classpath或-cp,或者通过设置CLASSPATH环境变量来引用.
JVM通过放置在{java_home}\lib\tools.jar来寻找和调用用户级的class.
常用的javac也是通过调用tools.jar来寻找用户指定的路径来编译Java源程序.
这样就引出了User class路径搜索的顺序或优先级别的问题.

3.1 缺省值:调用Java或javawa的当前路径(.),是开发的class所存在的当前目录

3.2 CLASSPATH环境变量设置的路径.如果设置了CLASSPATH,则CLASSPATH的值会覆盖缺省值

3.3 执行Java的命令行-classpath或-cp的值,如果指定了这两个命令行参数之一,它的值会覆盖环境变量CLASSPATH的值

3.4 -jar 选项:如果通过java -jar 来运行一个可执行的jar包,这当前jar包会覆盖上面所有的值.
换句话说,-jar 后面所跟的jar包的优先级别最高,
如果指定了-jar选项,所有环境变量和命令行制定的搜索路径都将被忽略.
JVM APPClassloader将只会以jar包为搜索范围.

有关可执行jar有许多相关的安全方面的描述,可以参考http://java.sun.com/docs/books/tutorial/jar/ 来全面了解.

这也是为什么应用程序打包成可执行的jar包后,不管你怎么设置classpath都不能引用到第三方jar包的东西了.

也就是说，在运行jar包时，classpath为：jre相关包+自己打的jar包中的(自己的class和第三方jar
```

# 2.值传递和引用传递



# 参考资料
https://www.liaoxuefeng.com/wiki/1252599548343744/1260466914339296#0 (classpath 概念)
https://www.cnblogs.com/zhenjingcool/p/16530567.html (classpath 概念)
https://www.cnblogs.com/liftsail/p/16473349.html (值传递和引用传递)