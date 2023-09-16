FROM golang:alpine

RUN apk --no-cache upgrade && apk --no-cache add rsync openssh-client git wget curl coreutils bash brotli ca-certificates
