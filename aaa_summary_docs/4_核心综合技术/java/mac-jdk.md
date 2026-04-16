# 1.通过 sdk-man 来安装管理 jdk
## 1.1 下载配置 sdk-man
```
curl -s "https://get.sdkman.io" | bash

如果失败，则：
wget https://get.sdkman.io -O sdkman-install.sh
然后：
chmod +x sdkman-install.sh
然后：
./sdkman-install.sh
或者
/opt/homebrew/bin/bash sdkman-install.sh 


然后：
echo 'source "$HOME/.sdkman/bin/sdkman-init.sh"' >> ~/.bash_profile
然后
source ~/.bash_profile

验证是否安装成功
sdk version
如果显示类似 SDKMAN 5.22.4 的版本信息，说明安装成功。


```

## 1.2 下载安装 jdk
```
sdk list java

sdk install java 25.0.2-open
```
