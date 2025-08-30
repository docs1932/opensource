# 使用 Amazon Linux 2023 作为基础镜像
FROM amazonlinux:2023

# 维护者标签（可选）
LABEL maintainer="your-email@example.com"

# 安装基础依赖
RUN yum update -y && \
    yum install -y \
        wget \
        tar \
        gzip \
        zip \
        unzip \
        libicu

# 设置工作目录
WORKDIR /opt

# —————————————————— 版本配置 ——————————————————
ENV JDK_VERSION=21
ENV MAVEN_VERSION=3.9.9
ENV NODE_VERSION=22.13.1

# —————————————————— 下载地址 ——————————————————
ENV JDK_URL=https://download.oracle.com/java/${JDK_VERSION}/latest/jdk-${JDK_VERSION}_linux-x64_bin.tar.gz

# Apache Maven
#ENV MAVEN_URL=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz
ENV MAVEN_URL=https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz
#ENV MAVEN_URL=https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz
# Node.js 22
ENV NODE_URL=https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz

# —————————————————— 安装 JDK 21 ——————————————————
RUN echo "📥 下载 OpenJDK ${JDK_VERSION}..." && \
    wget -q -O jdk21.tar.gz "$JDK_URL" && \
    echo "📦 解压 JDK..." && \
    tar -xzf jdk21.tar.gz && \
    rm jdk21.tar.gz && \
    mv jdk-* jdk-${JDK_VERSION}

# —————————————————— 安装 Maven ——————————————————
RUN echo "📥 下载 Apache Maven ${MAVEN_VERSION}..." && \
    wget -q -O maven.tar.gz "$MAVEN_URL" && \
    echo "📦 解压 Maven..." && \
    tar -xzf maven.tar.gz && \
    rm maven.tar.gz && \
    mv apache-maven-${MAVEN_VERSION} maven-${MAVEN_VERSION}

# —————————————————— 安装 Node.js ——————————————————
RUN echo "📥 下载 Node.js v${NODE_VERSION}..." && \
    wget -q -O node.tar.gz "$NODE_URL" && \
    echo "📦 解压 Node.js..." && \
    tar -xzf node.tar.gz && \
    rm node.tar.gz && \
    mv node-v${NODE_VERSION}-linux-x64 node-${NODE_VERSION}

# —————————————————— 设置环境变量 ——————————————————
ENV JAVA_HOME=/opt/jdk-21
ENV MAVEN_HOME=/opt/maven-3.9.9
ENV NODE_HOME=/opt/node-22.13.1
ENV PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$NODE_HOME/bin:$PATH

# 验证安装
RUN java -version && \
    javac -version && \
    mvn -v && \
    node --version && \
    npm --version

# 安装 cdxgen, 用于 sbom.
RUN npm install -g @cyclonedx/cdxgen

COPY maven/settings.xml ${MAVEN_HOME}/conf/settings.xml

# 默认 shell
CMD ["bash"]
