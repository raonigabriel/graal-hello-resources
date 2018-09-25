# graal-hello-resources
A simple example to demonstrate how to embed resources using GraalVM

## Features
- External 3d party library (commons-io)
- System property evaluation during AOT
- Embedded resource into native

## Usage
Using my docker [graalvm-playground](https://hub.docker.com/r/raonigabriel/graalvm-playground/), mount your home to /root then clone, build and run as follows:
```
$ docker run --rm  -v ~/:/root -it raonigabriel/graalvm-playground /bin/bash
root@be7deb9a56de:~# git clone https://github.com/raonigabriel/graal-hello-resources.git
root@be7deb9a56de:~# cd graal-hello-resources
root@be7deb9a56de:~# mvn clean package
root@be7deb9a56de:~# java -jar target/hello-resources.jar
root@be7deb9a56de:~# native-image --static -H:IncludeResources=message.txt -jar target/hello-resources.jar
root@be7deb9a56de:~# ls -la
root@be7deb9a56de:~# strip hello-resources
root@be7deb9a56de:~# ls -la
root@be7deb9a56de:~# ./hello-resources
```