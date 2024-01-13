# golang-helper

This is a general helper image for CI/CD pipelines. It's based on the official golang image and contains some additional packages and tools.
Every two weeks this image is automatically rebuild to provide up-to-date packages and tools.

This image is available on [Docker Hub](https://hub.docker.com/r/thomas2500/golang-helper).

The following tags are available:
  - **latest** - latest Go version
  - **1.21** - Go 1.21.X
  - **1.20** - Go 1.20.X

This replository only keeps supported versions of Go.

## Tools
### Linux Tools

The following linux tools are installed:
  - **rsync** - syncing files with remote target
  - **openssh-client** - deploy files to remote target using SSH
  - **git** - repository management
  - **wget** - download files
  - **curl** - perform extended HTTP requests, addition to wget
  - **coreutils** - basic linux tools
  - **bash** - shell for executing scripts
  - **brotli** - compression tool to precompress files to be served by nginx
  - **ca-certificates** - certificates for HTTPS requests
  - **dpkg** - package management for debian based systems
  - **sed** - text manipulation
  - **grep** - text manipulation
  - **findutils** - directory searching utilities
  - **tar** - archive utility
  - **gzip** - compression tool
  - **bzip2** - compression tool
  - **xz-utils** - compression tool
  - **python3** - python interpreter for additional scripts

Additionally, the following packages are locally installed:
  - **git-tools** - assorted git-related scripts and tools
  - **golangci-lint** - linter for Go source code

## Example usage

Please feel free to contribute your examples of how this image can be used in your CI/CD pipeline.

### GitLab CI

Generate a coverage report and upload it to GitLab. The coverage report is also available as artifact.\
Compatible with SonarQube analysis.
```yaml
go test:
  image: thomas2500/golang-helper:latest
  stage: test
  script:
    - env CGO_ENABLED=0 go fmt $(go list ./...)
    - env CGO_ENABLED=0 go vet $(go list ./...) || true
    - env CGO_ENABLED=0 go test -v -cover -coverprofile=coverage.out -covermode=atomic $(go list ./...); mkdir coverage; go tool cover -html=coverage.out -o coverage/index.html
    - env CGO_ENABLED=0 go test -json $(go list ./...) > test-report.out
  artifacts:
    expire_in: 1 hour
    untracked: true
    paths:
      - coverage/
      - coverage.out
      - test-report.out
  allow_failure: true
```

Build project and create artifacts.
```yaml
build:
  image: thomas2500/golang-helper:latest
  stage: build
  script:
    # Print current Go version for later reference
    - go version
    # Set environment variables
    - export VERSION=$(date "+%Y%m%d%H%I%S")
    # Use last tag as version
    # - export VERSION=$(git describe --tags --always --dirty)
    - export COMMIT_HASH=$(git rev-parse --short=8 HEAD 2>/dev/null || true)
    - export COMPLETECOMMIT_HASH=$(git rev-parse 2>/dev/null || true)
    - export BUILD_DATE=$(date "+%Y-%m-%d")
    # Create build directory
    - mkdir build || true
    # Build program
    - GOARCH=amd64 GOOS=linux CGO_ENABLED=0 go build -a -installsuffix cgo -ldflags -s -w -X main.completeCommitHash=${COMPLETECOMMIT_HASH} -X main.commitHash=${COMMIT_HASH} -X main.programVersion=${VERSION} -X main.buildDate=${BUILD_DATE} -o build/program ./cmd/program
  artifacts:
    expire_in: 2 hour
    paths:
      - build/
```
