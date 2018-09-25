FROM raonigabriel/graalvm-playground as builder
WORKDIR /graal-hello-resources
# First, just copy the pom.xml and go-offline. It will generate a cache layer with all maven deps. 
COPY pom.xml pom.xml
RUN mvn dependency:go-offline
# After that, we copy the actual project file and build it using offline mode.
COPY . .
RUN mvn -o clean package && \
    native-image --static -H:IncludeResources=message.txt -jar target/hello-resources.jar && \
    strip hello-resources && \
    pwd && ls -la

# We generate a two-layer image, with just our binary. No Alpine, no bash, nothing else!
FROM scratch
COPY --from=builder /graal-hello-resources/hello-resources /hello-resources
CMD ["./hello-resources"]  
