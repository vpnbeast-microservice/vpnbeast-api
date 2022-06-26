lint:
	golangci-lint run

vet:
	go vet ./...

ineffassign:
	go get -u github.com/gordonklaus/ineffassign
	ineffassign ./...

test:
	go test ./...

build:
	go build -o bin/main cmd/encryption-service/main.go

run:
	go run cmd/encryption-service/main.go

cross-compile:
	# 32-Bit Systems
	# FreeBDS
	GOOS=freebsd GOARCH=386 go build -o bin/main-freebsd-386 cmd/encryption-service/main.go
	# MacOS
	GOOS=darwin GOARCH=386 go build -o bin/main-darwin-386 cmd/encryption-service/main.go
	# Linux
	GOOS=linux GOARCH=386 go build -o bin/main-linux-386 cmd/encryption-service/main.go
	# Windows
	GOOS=windows GOARCH=386 go build -o bin/main-windows-386 cmd/encryption-service/main.go
        # 64-Bit
	# FreeBDS
	GOOS=freebsd GOARCH=amd64 go build -o bin/main-freebsd-amd64 cmd/encryption-service/main.go
	# MacOS
	GOOS=darwin GOARCH=amd64 go build -o bin/main-darwin-amd64 cmd/encryption-service/main.go
	# Linux
	GOOS=linux GOARCH=amd64 go build -o bin/main-linux-amd64 cmd/encryption-service/main.go
	# Windows
	GOOS=windows GOARCH=amd64 go build -o bin/main-windows-amd64 cmd/encryption-service/main.go

upgrade-direct-deps:
	for item in `grep -v 'indirect' go.mod | grep '/' | cut -d ' ' -f 1`; do \
		echo "trying to upgrade direct dependency $$item" ; \
		go get -u $$item ; \
  	done
	go mod tidy
	go mod vendor

compress:
	go get -v all
	GOOS=linux go build -o build/main cmd/vpnbeast-api/main.go
	zip -jrm build/main.zip build/main

all: test build run
