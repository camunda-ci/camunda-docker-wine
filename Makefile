# image settings for the docker image name, tags and
# container name while running
IMAGE_NAME=gcr.io/ci-30-162810/wine
TAGS=latest
NAME=wine

# parent image name
FROM=$(shell head -n1 Dockerfile | cut -d " " -f 2)
# the first tag and the remaining tags split up
FIRST_TAG=$(firstword $(TAGS))
ADDITIONAL_TAGS=$(wordlist 2, $(words $(TAGS)), $(TAGS))
# the image name which will be build
IMAGE=$(IMAGE_NAME):$(FIRST_TAG)
# options to use for running the image, can be extended by FLAGS variable
OPTS=--name $(NAME) -p 5900 -t $(FLAGS)
# the docker command which can be configured by the DOCKER_OPTS variable
DOCKER=docker $(DOCKER_OPTS)

# default build settings
REMOVE=true
FORCE_RM=true
NO_CACHE=false

# build the image for the first tag and tag it for additional tags
build:
	$(DOCKER) build --rm=$(REMOVE) --force-rm=$(FORCE_RM) --no-cache=$(NO_CACHE) -t $(IMAGE) .
	@for tag in $(ADDITIONAL_TAGS); do \
		$(DOCKER) tag -f $(IMAGE) $(IMAGE_NAME):$$tag; \
	done

# pull image from registry
pull:
	-$(DOCKER) pull $(IMAGE)

# pull parent image
pull-from:
	$(DOCKER) pull $(FROM)

# push container to registry
push:
	@for tag in $(TAGS); do \
		$(DOCKER) push $(IMAGE_NAME):$$tag; \
	done

# pull parent image, pull image, build image and push to repository
publish: pull-from pull build push

# run container
run: rmf
	$(DOCKER) run --rm $(OPTS) $(IMAGE)

# start container as daemon
daemon:
	$(DOCKER) run -d $(OPTS) $(IMAGE)

# start interactive container with bash
shell:
	$(DOCKER) run --rm --entrypoint=/bin/bash -i $(OPTS) $(IMAGE) --

# remove container by name
rmf:
	-$(DOCKER) rm -f $(NAME)

# remove image with all tags
rmi:
	@for tag in $(TAGS); do \
		$(DOCKER) rmi $(IMAGE_NAME):$$tag; \
	done

.PHONY: build pull pull-from push publish run daemon bash rmf rmi
