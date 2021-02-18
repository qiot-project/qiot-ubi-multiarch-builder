![Build](https://github.com/qiot-project/qiot-ubi-multiarch-builder/workflows/CI/badge.svg?branch=main)


# qiot-ubi-multiarch-builder
A project to create a quarkus native builder based on qiot-ubi-multiarch. This allows you to compile a native quarkus image for different target architectures than the host.


## Using the builder image to build a native quarkus binary

1. Create a dockerfile for your project to do a chained build (eg. src/main/docker/Dockerfile.multiarch):

```
FROM qiot-ubi-multiarch-builder:1.0 AS builder
RUN mkdir -p /usr/src/app
COPY pom.xml /usr/src/app/
RUN mvn -f /usr/src/app/pom.xml -B de.qaware.maven:go-offline-maven-plugin:1.2.5:resolve-dependencies
COPY src /usr/src/app/src
RUN mvn -f /usr/src/app/pom.xml -Pnative clean package


FROM qiot-ubi-multiarch:1.0
WORKDIR /work/
COPY --from=builder /usr/src/app/target/*-runner /work/application

# set up permissions for user `1001`
RUN chmod 775 /work /work/application \
  && chown -R 1001 /work \
  && chmod -R "g+rwX" /work \
  && chown -R 1001:root /work

EXPOSE 8080
USER 1001

CMD ["./application", "-Dquarkus.http.host=0.0.0.0"]
```

2. Configure docker to be able to run multiarch containers (the build script outputs details from the built container). This is not required when using docker for mac as the build environment.
```
docker run --rm --privileged multiarch/qemu-user-static:register --reset
```

3. Run a docker build from your application root directory
```
docker build -t <imagename>:<tag> -f src/main/docker/Dockerfile.multiarch
```

