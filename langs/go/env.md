# GO

https://golang.org/doc/code.html

## $GOROOT

`GOROOT` 就是 `go` 的安装路径

```sh
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin
```

## $GOPATH

https://github.com/golang/go/wiki/GOPATH

```sh
export GOPATH=/Users/liuyanjie/go
export PATH=$PATH:$GOPATH/bin
```

```sh
$ tree -L 3 $GOPATH
/Users/liuyanjie/go
├── bin
│   ├── bee
│   ├── dep
│   ├── go-outline
│   ├── go-symbols
│   ├── gocode
│   ├── godef
│   ├── godoc
│   ├── golint
│   ├── gomodifytags
│   ├── gopkgs
│   ├── gorename
│   ├── goreturns
│   ├── gotests
│   ├── guru
│   ├── impl
│   ├── stringsvc1
│   └── stringsvc2
├── pkg
│   └── darwin_amd64
│       ├── github.com
│       ├── golang.org
│       └── gopkg.in
└── src
    ├── github.com
    │   ├── Go-zh
    │   ├── MichaelTJones
    │   ├── acroca
    │   ├── afex
    │   ├── astaxie
    │   ├── beego
    │   ├── beorn7
    │   ├── cweill
    │   ├── dgrijalva
    │   ├── fatih
    │   ├── fsnotify
    │   ├── go-kit
    │   ├── go-logfmt
    │   ├── go-stack
    │   ├── go-yaml
    │   ├── golang
    │   ├── gorilla
    │   ├── josharian
    │   ├── juju
    │   ├── labstack
    │   ├── mattn
    │   ├── matttproud
    │   ├── nsf
    │   ├── prometheus
    │   ├── ramya-rao-a
    │   ├── rogpeppe
    │   ├── sony
    │   ├── sqs
    │   ├── streadway
    │   ├── tockins
    │   ├── tpng
    │   ├── uudashr
    │   └── valyala
    ├── golang.org
    │   └── x
    ├── gopkg.in
    │   └── mgo.v2
    └── sourcegraph.com
        └── sqs
```

## GO15VENDOREXPERIMENT

`vendor` 目录设置

```sh
export GO15VENDOREXPERIMENT=1
```
