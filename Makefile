.PHONY: default all build image clean
THIS_FILE := $(lastword $(MAKEFILE_LIST))

PLATFORM ?= alpine
BUILD_ARTIFACT := tezos-api
BUILD_REPO := blockwatch.cc/$(BUILD_ARTIFACT)
BUILD_VERSION ?= $(shell git describe --always --dirty --tags)-$(PLATFORM)
BUILD_COMMIT := $(shell git rev-parse --short HEAD)
BUILD_DATE := $(shell date -u "+%Y-%m-%dT%H:%M:%SZ")
BUILD_ID ?= $(shell uuid)
BUILD_TAG ?= master

ifdef DOCKER_REGISTRY_ADDR
	REGISTRY := $(DOCKER_REGISTRY_ADDR)
endif
REGISTRY ?= hub.bwd.cx

TARGET_IMAGE := $(REGISTRY)/$(BUILD_ARTIFACT):$(BUILD_VERSION)

default: image

build:
	@echo $@
	@yarn build

image:
	@echo $@
	@echo "Building $(TARGET_IMAGE)"
	docker build --ssh default --pull --force-rm --build-arg BUILD_REPO=$(BUILD_REPO) --build-arg BUILD_TAG=$(BUILD_TAG) --build-arg BUILD_ARTIFACT=$(BUILD_ARTIFACT) --build-arg BUILD_DATE=$(BUILD_DATE) --build-arg BUILD_VERSION=$(BUILD_VERSION) --build-arg BUILD_COMMIT=$(BUILD_COMMIT) --build-arg BUILD_ID=$(BUILD_ID) -t $(TARGET_IMAGE) -f Dockerfile.$(PLATFORM) .
	@echo
	@echo "Container image complete. Continue with "
	@echo " List:         docker images"
	@echo " Push:         docker push $(TARGET_IMAGE)"
	@echo " Inspect:      docker inspect $(TARGET_IMAGE)"
	@echo " Run:          docker run --rm --name $(BUILD_ARTIFACT) $(TARGET_IMAGE)"
	@echo

release: image
	@echo $@
	@echo "Publishing image..."
	docker push $(TARGET_IMAGE)

clean:
	@echo $@
	rm -rf build/*
