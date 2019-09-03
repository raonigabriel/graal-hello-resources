FROM raonigabriel/graalvm-playground as builder
WORKDIR /graal-hello-resources

# First, just copy the pom.xml and go-offline. It will generate a cache layer with all maven deps. 
COPY pom.xml pom.xml
RUN mvn dependency:go-offline

# After that, we copy the actual project file and build it using offline mode.
COPY . .
RUN mvn -o clean package && \
    native-image --initialize-at-build-time  -jar ./target/hello-resources.jar && \
    strip ./hello-resources

# We generate a four-layer image, with the binary generated on the "builder" stage
FROM frolvlad/alpine-glibc
COPY --from=builder /graal-hello-resources/hello-resources /bin/hello-resources
ENTRYPOINT ["/bin/hello-resources"]
CMD ["hello-resources"]
