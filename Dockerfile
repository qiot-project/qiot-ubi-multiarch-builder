FROM quay.io/qiotproject/ubi-multiarch:v1.0.2
LABEL "architecture"="aarch64"
LABEL "multiarch"="true"
ARG GRAALVM_VERSION=21.2.0

RUN dnf -y upgrade
RUN dnf -y install gcc zlib-devel glibc-static java-11-openjdk-devel maven
RUN dnf install -y http://mirror.centos.org/centos/8/PowerTools/aarch64/os/Packages/libstdc++-static-8.4.1-1.el8.aarch64.rpm
RUN dnf clean all
RUN mkdir -p  /opt/graalvm
WORKDIR /opt/graalvm
RUN curl -LJ https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-$GRAALVM_VERSION/graalvm-ce-java11-linux-aarch64-$GRAALVM_VERSION.tar.gz \
         -o /tmp/graalvm-ce-java11-linux-aarch64-$GRAALVM_VERSION.tar.gz && \
         tar -xzvf /tmp/graalvm-ce-java11-linux-aarch64-$GRAALVM_VERSION.tar.gz && \
         rm /tmp/graalvm-ce-java11-linux-aarch64-$GRAALVM_VERSION.tar.gz
ENV PATH=$PATH:/opt/graalvm/graalvm-ce-java11-$GRAALVM_VERSION/bin
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk
RUN gu install native-image