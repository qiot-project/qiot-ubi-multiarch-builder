FROM qiot-ubi-multiarch:1.0
RUN dnf -y install gcc zlib-devel glibc-static java-11-openjdk maven
RUN dnf clean all
RUN mkdir -p  /opt/graalvm
WORKDIR /opt/graalvm
RUN curl -LJ https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-20.2.0/graalvm-ce-java11-linux-aarch64-20.2.0.tar.gz -o /tmp/graalvm-ce-java11-linux-aarch64-20.2.0.tar.gz && tar -xzvf /tmp/graalvm-ce-java11-linux-aarch64-20.2.0.tar.gz
ENV PATH=$PATH:/opt/graalvm/graalvm-ce-java11-20.2.0/bin
ENV JAVA_HOME=/usr/lib/jvm/jre-11-openjdk
RUN gu install native-image