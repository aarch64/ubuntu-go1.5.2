FROM aarch64/ubuntu:trusty

RUN apt-get update && apt-get install -y \
	curl \
	gcc

# Install go1.5.2
COPY ./go-linux-arm64-bootstrap.tbz /
RUN tar -xf /go-linux-arm64-bootstrap.tbz \
	&& mkdir -p /opt/go \
	&& curl -k https://storage.googleapis.com/golang/go1.5.2.src.tar.gz | tar -v -C /opt/go -xz --strip-components=1
# There might be testing failture, so the `./all.bash` would return non-zero code,
# which would stop Docker building. We run them in separate commands and hack it
# with `exit 0` to work around it. See testing failture details from:
# https://github.com/golang/go/issues/11936
WORKDIR /opt/go/src
RUN GOOS=linux GOARCH=arm64 GOROOT_BOOTSTRAP=/go-linux-arm64-bootstrap ./all.bash; exit 0
RUN rm -f /go-linux-arm64-bootstrap.tbz

ENV PATH /opt/go/bin:$PATH
