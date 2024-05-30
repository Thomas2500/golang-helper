# Based on environment variable, use different base image. Default is latest based on alpine
ARG GO_VERSION=alpine
FROM golang:${GO_VERSION}

RUN apk --no-cache upgrade && apk --no-cache add rsync openssh-client git wget curl coreutils bash brotli ca-certificates dpkg sed grep findutils tar gzip bzip2 python3 zstd

# Provide git-tools package from upstream
RUN git clone https://github.com/MestreLion/git-tools.git /opt/git-tools
ENV PATH="${PATH}:/opt/git-tools"

# Install golangci-lint
RUN wget -O- -nv https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s && \
	golangci-lint --version
