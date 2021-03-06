COMMIT=$(shell git rev-parse HEAD)
TAG_COMMIT=$(shell git rev-list --tags --max-count=1)
TAG_NAME=$(shell git describe --tags $(TAG_COMMIT))

VERSION=
ifeq ($(COMMIT),$(TAG_COMMIT))
	VERSION=$(TAG_NAME)
else
	VERSION=$(shell git rev-parse --short HEAD)
endif


.PHONY: docker-build-all docker-push-all


docker-build-amd64:
	docker buildx build --load \
		--platform linux/amd64 \
		--build-arg BASEIMAGE_TAG=alpine-3.9.6 \
		--tag ameyuuno/unifi-led-light-switch:$(VERSION) \
		--tag ameyuuno/unifi-led-light-switch:$(VERSION)-amd64 \
		.


docker-build-arm64:
	docker buildx build --load \
		--platform linux/arm64 \
		--build-arg BASEIMAGE_TAG=alpine-3.9.6-arm64 \
		--tag ameyuuno/unifi-led-light-switch:$(VERSION)-arm64 \
		.


docker-build-all: docker-build-amd64 docker-build-arm64


docker-push-all:
	docker tag ameyuuno/unifi-led-light-switch:$(VERSION)-amd64 ameyuuno/unifi-led-light-switch:latest
	docker push ameyuuno/unifi-led-light-switch
