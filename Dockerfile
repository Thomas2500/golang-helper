FROM golang:alpine
LABEL AUTHOR="Thomas Bella <thomas+docker@bella.network>"

RUN apk --no-cache upgrade && apk --no-cache add rsync openssh-client git wget curl coreutils bash brotli
