FROM raonigabriel/graalvm-playground:java11 as builder
RUN mkdir -p /home/graalvm/graal-hello-resources
WORKDIR /home/graalvm/graal-hello-resources

# First, just copy the pom.xml and go-offline. It will generate a cache layer with all maven deps. 
COPY pom.xml pom.xml
RUN mvn dependency:go-offline

# After that, we copy the actual project file and build it using offline mode.
COPY . .
RUN mvn -o clean package && \
    native-image --initialize-at-build-time --static --libc=musl  --no-fallback --no-server -H:Name=hello-resources -H:NumberOfThreads=8 -jar ./target/hello-resources.jar && \
    strip ./hello-resources && \
    upx --ultra-brute ./hello-resources

# We generate a four-layer image, with the binary generated on the "builder" stage
FROM scratch
COPY --from=builder /home/graalvm/graal-hello-resources/hello-resources /bin/hello-resources
#ENTRYPOINT ["/bin/hello-resources"]
CMD ["hello-resources"]
