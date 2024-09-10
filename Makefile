-include env.mk

TAG ?= latest

ALPINE_VER ?= 3.20

PLATFORM ?= linux/arm64

ifeq ($(BASE_IMAGE_STABILITY_TAG),)
    BASE_IMAGE_TAG := $(ALPINE_VER)
else
    BASE_IMAGE_TAG := $(ALPINE_VER)-$(BASE_IMAGE_STABILITY_TAG)
endif

REPO = wodby/sshd
NAME = sshd

ifneq ($(STABILITY_TAG),)
    ifneq ($(TAG),latest)
        override TAG := $(TAG)-$(STABILITY_TAG)
    endif
endif

.PHONY: build buildx-build buildx-push buildx-build-amd64 test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) \
		--build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) ./

# --load doesn't work with multiple platforms https://github.com/docker/buildx/issues/59
# we need to save cache to run tests first.
buildx-build-amd64:
	docker buildx build --platform linux/amd64 -t $(REPO):$(TAG) \
	    --build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
		--load \
	    ./

buildx-build:
	docker buildx build --platform $(PLATFORM) -t $(REPO):$(TAG) \
	    --build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
	    ./

buildx-push:
	docker buildx build --push --platform $(PLATFORM) -t $(REPO):$(TAG) \
	    --build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
	    ./

test:
	echo "no tests :("

push:
	docker push $(REPO):$(TAG)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

run:
	docker run --rm --name $(NAME) $(LINKS) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) $(CMD)

start:
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)

release: build push
