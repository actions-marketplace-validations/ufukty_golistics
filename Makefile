VERSION := $(shell git describe --tags --always --dirty)

.PHONY: build

build:
	mkdir -p "build/$(VERSION)"
	mkdir -p "build/$(VERSION)"
	GOOS=darwin  GOARCH=amd64 go build -trimpath -o build/$(VERSION)/golistics-$(VERSION)-darwin-amd64  .
	GOOS=darwin  GOARCH=arm64 go build -trimpath -o build/$(VERSION)/golistics-$(VERSION)-darwin-arm64  .
	GOOS=linux   GOARCH=amd64 go build -trimpath -o build/$(VERSION)/golistics-$(VERSION)-linux-amd64   .
	GOOS=linux   GOARCH=386   go build -trimpath -o build/$(VERSION)/golistics-$(VERSION)-linux-386     .
	GOOS=linux   GOARCH=arm   go build -trimpath -o build/$(VERSION)/golistics-$(VERSION)-linux-arm     .
	GOOS=linux   GOARCH=arm64 go build -trimpath -o build/$(VERSION)/golistics-$(VERSION)-linux-arm64   .
	GOOS=freebsd GOARCH=amd64 go build -trimpath -o build/$(VERSION)/golistics-$(VERSION)-freebsd-amd64 .
	GOOS=freebsd GOARCH=386   go build -trimpath -o build/$(VERSION)/golistics-$(VERSION)-freebsd-386   .
	GOOS=freebsd GOARCH=arm   go build -trimpath -o build/$(VERSION)/golistics-$(VERSION)-freebsd-arm   .
