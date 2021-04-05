FROM quay.io/qiot/ubi-multiarch:v1.0.0
LABEL "arch"="aarch64"
LABEL "multiarch"="true"
ARG GRAALVM_VERSION=21.0.0.2

RUN dnf -y upgrade
RUN dnf -y install gcc zlib-devel glibc-static java-11-openjdk maven
RUN dnf install -y http://mirror.centos.org/centos/8/PowerTools/aarch64/os/Packages/libstdc++-static-8.3.1-5.1.el8.aarch64.rpm
RUN dnf clean all
RUN mkdir -p  /opt/graalvm
WORKDIR /opt/graalvm
RUN curl -LJ https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-$GRAALVM_VERSION/graalvm-ce-java11-linux-aarch64-$GRAALVM_VERSION.tar.gz \
         -o /tmp/graalvm-ce-java11-linux-aarch64-$GRAALVM_VERSION.tar.gz && \
         tar -xzvf /tmp/graalvm-ce-java11-linux-aarch64-$GRAALVM_VERSION.tar.gz && \
         rm /tmp/graalvm-ce-java11-linux-aarch64-$GRAALVM_VERSION.tar.gz
ENV PATH=$PATH:/opt/graalvm/graalvm-ce-java11-$GRAALVM_VERSION/bin
ENV JAVA_HOME=/usr/lib/jvm/jre-11-openjdk
RUN gu install native-image