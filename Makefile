SHELL := /bin/bash

.PHONY: \
	init_yarn \
	init_go \
	init_shfmt \
	init_shellcheck \
	init_docker \
	init_docker_compose \
	init_all \
	format_all \
	lint_all

## Dependency installation targets

init_yarn:
	if [ -z "$$(command -v yarn)" ]; then ./scripts/make.sh install_yarn; fi
	if [ -z "$$(command -v ./node_modules/.bin/prettier)" ]; then ./scripts/make.sh install_yarn; fi
	if [ -z "$$(command -v ./node_modules/.bin/markdownlint)" ]; then ./scripts/make.sh install_yarn; fi

init_go:
	if [[ -z "$$(command -v go)" ]]; then ./scripts/make.sh install_golang "${GO_LANG_VERSION}"; fi

init_shfmt:
	if [ -z "$$(command -v shfmt)" ]; then ./scripts/make.sh install_shfmt "${SHFMT_VERSION}"; fi

init_shellcheck:
	if [ -z "$$(command -v shellcheck)" ]; then ./scripts/make.sh install_shellcheck "${SHELLCHECK_VERSION}"; fi

init_docker:
	if [ -z "$$(command -v docker)" ]; then ./scripts/make.sh install_docker "${DOCKER_VERSION}"; fi
	if [[ ! "$$(docker version | awk NR==2)" =~ "${DOCKER_VERSION}" ]]; then \
		./scripts/make.sh install_docker "${DOCKER_VERSION}"; \
	fi

init_docker_compose:
	if [ -z "$$(command -v docker)" ]; then ./scripts/make.sh install_docker_compose "${DOCKER_COMPOSE_VERSION}"; fi
	if [[ ! "$$(docker-compose version | awk NR==1)" =~ "${DOCKER_COMPOSE_VERSION}" ]]; then \
		./scripts/make.sh install_docker_compose "${DOCKER_COMPOSE_VERSION}"; \
	fi

init_all: \
	init_yarn \
	init_go \
	init_shfmt \
	init_docker \
	init_docker_compose \
	init_shellcheck

## Code consistency/quality targets

format_all: init_all
	./scripts/make.sh format_yaml
	./scripts/make.sh format_shell
	./scripts/make.sh format_markdown

lint_all: init_all
	./scripts/make.sh lint_yaml
	./scripts/make.sh lint_shell
	./scripts/make.sh lint_markdown

build_super_ops:
	if [[ -e .env ]]; then rm .env && touch .env; fi
	./scripts/make.sh set_env_variables
	docker-compose build super_ops
	docker run --rm containers_super_ops /bin/bash -c 'echo "build ok"' || \
		(echo "docker image is broken"; exit 1;)
	rm .env

push_super_ops: build_super_ops
	# docker tag here to ghcr registry
	# docker tag project_service
	# docker push here to ghcr registry
