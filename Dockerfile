FROM aarch64/ubuntu:trusty

# gcc for cgo
RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
		make \
		curl \
	&& rm -rf /var/lib/apt/lists/* && apt-get clean

# Install go1.5.2
ENV ENV GO_VERSION 1.5.2
ADD ./go-linux-arm64-bootstrap.tbz /

# Here we build without testing
RUN  mkdir -p /opt/go \
	&& curl -sSlk https://storage.googleapis.com/golang/go1.5.2.src.tar.gz | tar -C /opt/go -xz --strip-components=1 \
	&& cd 	/opt/go/src && GOOS=linux GOARCH=arm64 GOROOT_BOOTSTRAP=/go-linux-arm64-bootstrap  ./make.bash

ENV PATH /opt/go/bin:$PATH
