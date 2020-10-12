## Environment Setup

Go environment on Alpine:

```
$ docker run -it alpine sh
GO_VERSION=1.15.2
apk add --no-cache ca-certificates
echo 'hosts: files dns' > /etc/nsswitch.conf
apk add --no-cache --virtual .build-deps bash gcc musl-dev openssl go
go env GOROOT
GOROOT_BOOTSTRAP="$(go env GOROOT)"
GOOS="$(go env GOOS)"
GOARCH="$(go env GOARCH)"
GOHOSTOS="$(go env GOHOSTOS)"
GOHOSTARCH="$(go env GOHOSTARCH)"
apkArch="$(apk --print-arch)"
wget -O go.tgz "https://golang.org/dl/go$GO_VERSION.src.tar.gz"
tar -C /usr/local -xzf go.tgz
rm go.tgz
cd /usr/local/go/src
./make.bash
rm -rf /usr/local/go/pkg/bootstrap /usr/local/go/pkg/obj
apk del .build-deps
export PATH="/usr/local/go/bin:$PATH"
export GOPATH=/go
export PATH=$GOPATH/bin:/usr/local/go/bin:$PATH
mkdir -p "$GOPATH/src" "$GOPATH/bin"
cd $GOPATH
go version
```

To get a environment where you can download from git, append the following:

```
$ apk add --no-cache gcc musl-dev git
$ go get github.com/digitalocean/godo
$ ls $GOPATH/
bin  pkg  src

$ ls $GOPATH/src/github.com/digitalocean
godo
```

Test:

```
$ mkdir $GOPATH/src/github.com/ruanbekker/hello
$ cat $GOPATH/src/github.com/ruanbekker/hello/main.go
package main

import "fmt"

func main() {
    fmt.Println("Hello, World!")
}

$ go run $GOPATH/src/github.com/ruanbekker/hello
/main.go
Hello, World!

$cd $GOPATH/src/github.com/ruanbekker/hello

$ go install

$ which hello
/go/bin/hello
```

Use a dependency to test:

```
$ cat $GOPATH/src/github.com/ruanbekker/randomnumz/main.go
package main

import (
    "fmt"
    "github.com/bxcodec/faker"
)

func main() {
    randomDay := faker.DayOfWeek()
    fmt.Println("Hi:", randomDay)
}

$ go get -u github.com/bxcodec/faker
# or
cd $GOPATH/src/github.com/ruanbekker/randomnumz
$ go get

$ go run main.go
Hi: Sunday

$ which randomnumz
/go/bin/randomnumz

$ randomnumz
Hi: Wednesday

# or:

$ go build -o random -v main.go
./random
Hi: Thursday
```
