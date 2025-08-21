FROM alpine:2025.03

WORKDIR /opt


# Install openjdk.


# Install maven.


# Install nodejs.


ENV JAVA_HOME=/usr/local/openjdk-21
ENV MAVEN_HOME=/usr/local/maven
ENV NODEJS_HOME=/usr/local/nodejs
ENV PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$NODEJS_HOME/bin:$PATH

# Install cdxgen.
RUN npm install -g @cyclonedx/cdxgen

COPY maven/settings.xml ${MAVEN_HOME}/conf/settings.xml
