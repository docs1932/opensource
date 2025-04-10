# 基础镜像
FROM amazonlinux:2023

# 设置环境变量
ENV JAVA_HOME=/usr/lib/jvm/openjdk-21
ENV MAVEN_HOME=/usr/local/apache-maven-3.9.4
ENV PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

# 安装必要的工具和依赖
RUN yum update -y && \
    yum install -y wget tar gzip && \
    yum clean all

# 下载并安装 OpenJDK 21 (从 OpenJDK 官网)
RUN wget https://download.java.net/java/GA/jdk21/ke41dund6puh/7b55f6e87bb14a2c9d7faa7b0eb3f789/35/GPL/openjdk-21_linux-x64_bin.tar.gz -O /tmp/openjdk-21_linux-x64_bin.tar.gz && \
    mkdir -p /usr/lib/jvm && \
    tar -xzf /tmp/openjdk-21_linux-x64_bin.tar.gz -C /usr/lib/jvm && \
    mv /usr/lib/jvm/jdk-21 /usr/lib/jvm/openjdk-21 && \
    rm -f /tmp/openjdk-21_linux-x64_bin.tar.gz

# 下载并安装 Maven 3.9.4
RUN wget https://downloads.apache.org/maven/maven-3/3.9.4/binaries/apache-maven-3.9.4-bin.tar.gz -O /tmp/apache-maven-3.9.4-bin.tar.gz && \
    mkdir -p /usr/local && \
    tar -xzf /tmp/apache-maven-3.9.4-bin.tar.gz -C /usr/local && \
    rm -f /tmp/apache-maven-3.9.4-bin.tar.gz

# 验证安装
RUN java -version && mvn -version

# 设置默认工作目录
WORKDIR /app

# 默认命令
CMD ["bash"]