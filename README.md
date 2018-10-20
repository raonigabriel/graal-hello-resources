# graal-hello-resources
A simple example to demonstrate how to embed resources using GraalVM

## Features
- External 3d party library ([commons-io](https://commons.apache.org/proper/commons-io/))
- System property evaluation during AOT
- Simple detection if running on JVM or native
- Resource is embedded into native
- Docker [multi-stage build](https://docs.docker.com/develop/develop-images/multistage-build/)
## Usage
Using my docker [graalvm-playground](https://hub.docker.com/r/raonigabriel/graalvm-playground/), mount your home to /root then clone, build and run as follows:
```
$ docker run --rm  -v ~/:/root -it raonigabriel/graalvm-playground /bin/bash
root@be7deb9a56de:~# git clone https://github.com/raonigabriel/graal-hello-resources.git
root@be7deb9a56de:~# cd graal-hello-resources
root@be7deb9a56de:~# mvn clean package
root@be7deb9a56de:~# java -jar target/hello-resources.jar
root@be7deb9a56de:~# native-image --static -H:Name=hello-resources -H:IncludeResources=message.txt -H:NumberOfThreads=8
root@be7deb9a56de:~# ls -la
root@be7deb9a56de:~# strip hello-resources
root@be7deb9a56de:~# ls -la
root@be7deb9a56de:~# ./hello-resources
```
## Official 'native-image-maven-plugin', bound to 'package' phase calls native-image to generate "native binary"
```
<groupId>com.oracle.substratevm</groupId>
<artifactId>native-image-maven-plugin</artifactId>
<version>1.0.0-rc8</version>
```

```
$ mvn clean package
```
hello-resources.jar     [standard jar]
hello-resources-fat.jar [shaded / uber / fat jar]
hello-resources         [native binary]



## Multi-stage builds (with Maven layered caching)
You can also build it directly, which in turn will use the [graalvm-playground](https://hub.docker.com/r/raonigabriel/graalvm-playground/) [>= 1.0.0-rc8] image, as follows:
```
$ git clone https://github.com/raonigabriel/graal-hello-resources.git
$ cd graal-hello-resources
$ docker build . -t hello-resources
...
$ docker images
...
REPOSITORY          TAG         IMAGE ID        CREATED         SIZE
hello-resources     latest      7cd2feaaa084    11 minutes ago  5.85MB
...
$ docker run --rm hello-resources
Hello Native World!
$
```
## Source
https://github.com/raonigabriel/graalvm-playground
