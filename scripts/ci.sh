#!/bin/bash

function install_yarn() {
    sudo apt update -y -qq && sudo apt install -y -qq curl gnupg &&
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - &&
        echo "deb https://dl.yarnpkg.com/debian/ stable main" |
        sudo tee /etc/apt/sources.list.d/yarn.list &&
        sudo apt update -y -qq && sudo apt install -y -qq yarn &&
        yarn --version &&
        yarn install --frozen-lockfile
}

function install_docker() {
    local release="${1}"

    if [[ -z "${release}" ]]; then
        release=20.10.0
    fi

    sudo apt update -y -qq &&
        sudo apt install -y -qq apt-transport-https ca-certificates curl software-properties-common &&
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" &&
        sudo apt update -y -qq &&
        docker_version="$(sudo apt-cache madison docker-ce | grep "${release}" | head -1 | awk '{print $3}')" &&
        sudo apt-get install -y -qq --allow-downgrades docker-ce="${docker_version}" &&
        sudo usermod -aG docker "${USER}"
}

function install_docker_compose() {
    local release="${1}"

    if [[ -z "${release}" ]]; then
        release=1.27.4
    fi

    sudo curl \
        -L "https://github.com/docker/compose/releases/download/${release}/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose &&
        sudo chmod +x /usr/local/bin/docker-compose &&
        docker-compose --version
}

function format_yaml() {
    yarn prettier --write ./**/*.y*ml
}

function format_markdown() {
    yarn prettier --write ./**/*.md
}

function format_shell() {
    find . -type f -name "*.sh" -exec shfmt -l -w {} +
}

function lint_yaml() {
    yarn prettier --check ./**/*.y*ml &&
        yamllint --strict ./
}

function lint_shell() {
    find . -type f -name "*.sh" -exec shellcheck -x {} +
}

function lint_markdown() {
    yarn markdownlint ./**/*.md
}

function build_image() {
    local args="${1}"

    docker build ${args} ./
}

function set_env_variables() {
    echo "SHORT_SHA=$(git rev-parse --short --quiet HEAD || echo "master")" >>.env
    echo "VERSION=$(git describe --abbrev=0 --tags 2>/dev/null || echo "latest")" >>.env
    echo "AZ_CLI_VERSION=${AZ_CLI_VERSION:-2.16.0}" >>.env
    echo "JQ_VERSION=${JQ_VERSION:-1.6}" >>.env
    echo "SOPS_VERSION=${SOPS_VERSION:-3.6.1}" >>.env
    echo "GOLANG_VERSION=${GOLANG_VERSION:-1.15.6}" >>.env
    echo "SHFMT_VERSION=${SHFMT_VERSION:-3.2.1}" >>.env
    echo "SHELLCHECK_VERSION=${SHELLCHECK_VERSION:-0.7.1}" >>.env
    echo "YAMLLINT_VERSION=${YAMLLINT_VERSION:-1.25.0}" >>.env
    echo "HELM_VERSION=${HELM_VERSION:-3.4.1}" >>.env
    echo "TERRAFORM_VERSION=${TERRAFORM_VERSION:-0.14.2}" >>.env
}
