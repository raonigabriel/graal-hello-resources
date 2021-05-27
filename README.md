# graal-hello-resources
A simple example to demonstrate how to [embed resources using GraalVM](https://www.graalvm.org/reference-manual/native-image/Resources/)

## Features
- External 3d party library ([commons-io](https://commons.apache.org/proper/commons-io/))
- System property evaluation during AOT "build-time"
- Simple detection if running on JVM or native
- Resource is [embedded into native](https://www.graalvm.org/reference-manual/native-image/Resources/)
- Docker [multi-stage build](https://docs.docker.com/develop/develop-images/multistage-build/)

## You have Docker installed? Easy! Just do as follows:
```
$ git clone https://github.com/raonigabriel/graal-hello-resources.git
$ cd graal-hello-resources
$ docker build . -t hello-resources
...
$ docker images
...
REPOSITORY          TAG         IMAGE ID        CREATED         SIZE
hello-resources     latest      e2cfee7b8ade    28 seconds ago  2.32MB
...
$ docker run --rm hello-resources
Hello Native World!
$
```
---
# Wow... After upx compression, it is a ~2MB Docker image! No JVM, no Alpine, just our native executable.
---

It uses Docker multi-stage builds (with Maven offline layered caching), which in turn will use the [graalvm-playground](https://hub.docker.com/r/raonigabriel/graalvm-playground/) 


## Manual usage
Using my docker [graalvm-playground](https://hub.docker.com/r/raonigabriel/graalvm-playground/), mount your home to /root then clone, build and run as follows:
```
$ docker run --rm  -v ~/:/root -it raonigabriel/graalvm-playground /bin/bash
root@be7deb9a56de:~# git clone https://github.com/raonigabriel/graal-hello-resources.git
root@be7deb9a56de:~# cd graal-hello-resources
root@be7deb9a56de:~# mvn clean package
root@be7deb9a56de:~# java -jar target/hello-resources.jar
Hello Java World!
root@be7deb9a56de:~# ./target/hello-resources
Hello Native World!
root@be7deb9a56de~#
```
## The outputs are inside ./target
hello-resources.jar     [standard jar]

hello-resources-fat.jar [shaded / uber / fat jar]

hello-resources         [native binary]

## Extras: use strip ( to further reduce size) and ldd (to confirm that every dep is indeed statically-linked) 
```
root@be7deb9a56de:~# ls -la ./target
root@be7deb9a56de:~# strip ./target/hello-resources
root@be7deb9a56de:~# ls -la ./target
root@be7deb9a56de:~# ldd ./target/hello-resources
        not a dynamic executable
```

## Source
https://github.com/raonigabriel/graal-hello-resources
