# minihpc: HPC login-node look-alikes in Docker, for testing agents and skills.
#   make build [PROFILE=expanse-like] [NPM_PACKAGES=opencode-ai@1.18.32]
#   make test | up [MOUNT=/abs/dir] | shell | down
PROFILE      ?= expanse-like
IMAGE        ?= minihpc-$(PROFILE)
NAME         ?= $(IMAGE)
UID          ?= $(shell id -u)
NPM_PACKAGES ?=
MOUNT        ?=

.PHONY: build test up shell down

build:
	docker build --build-arg UID=$(UID) --build-arg NPM_PACKAGES="$(NPM_PACKAGES)" \
	  -t $(IMAGE) profiles/$(PROFILE)

test:
	docker run --rm -i $(IMAGE) bash -l -s < profiles/$(PROFILE)/test.sh

# MOUNT is bind-mounted at the same absolute path inside (tools on the host can then share paths with it).
up:
	docker run -d --name $(NAME) $(if $(MOUNT),-v $(MOUNT):$(MOUNT)) $(IMAGE)

shell:
	docker exec -it $(NAME) bash -l

down:
	docker rm -f $(NAME)
