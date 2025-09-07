# 使用官方完整 JDK 镜像（非 slim）
#FROM openjdk:21-jdk-alpine
FROM eclipse-temurin:21-jdk-alpine

LABEL maintainer="your.email@example.com"

# 设置工作目录
WORKDIR /root

# 安装基础工具（openjdk:21-jdk 已包含大部分依赖，可能不需要额外安装）
RUN apk update && \
    apt install -y --no-install-recommends \
        wget \
        curl \
        git \
        tar \
        gzip && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# 安装 Maven
ENV MAVEN_VERSION=3.8.6
ENV MAVEN_HOME=/opt/maven
ENV PATH=${MAVEN_HOME}/bin:${PATH}

RUN wget https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz  && \
    mkdir -p ${MAVEN_HOME} && \
    tar -xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C ${MAVEN_HOME} --strip-components=1 && \
    rm -f apache-maven-${MAVEN_VERSION}-bin.tar.gz

# 配置 Maven 国内镜像（阿里云）
RUN mkdir -p /root/.m2
COPY maven/settings.xml /root/.m2/settings.xml

# 验证 Maven 安装
RUN mvn -v

# 持久化工作目录
WORKDIR /workspace

# 默认命令
CMD ["bash"]