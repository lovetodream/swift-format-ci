FROM --platform=linux/amd64 swift:5.10-jammy

WORKDIR /swift-format
RUN env DEBIAN_FRONTEND=noninteractive apt-get update
RUN env DEBIAN_FRONTEND=noninteractive apt-get install wget
RUN wget --quiet --output-document=- https://github.com/apple/swift-format/archive/510.1.0.tar.gz | tar zxf - --strip-components 1
RUN swift build --product swift-format --configuration release -Xswiftc -static-stdlib

FROM --platform=linux/amd64 ubuntu:jammy
COPY --from=0 /swift-format/.build/*/release/swift-format /usr/bin

RUN env DEBIAN_FRONTEND=noninteractive apt-get update && \
env DEBIAN_FRONTEND=noninteractive apt-get install -y git && \
env DEBIAN_FRONTEND=noninteractive apt-get clean && \
rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/swift-format"]
