#!/bin/bash
# shellcheck shell=bash disable=SC1090

function install_yarn() {
    sudo apt update -y -qq && sudo apt install -y -qq curl gnupg &&
        curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - &&
        echo "deb https://dl.yarnpkg.com/debian/ stable main" |
        sudo tee /etc/apt/sources.list.d/yarn.list &&
        sudo apt update -y -qq && sudo apt install -y -qq yarn &&
        yarn --version &&
        yarn install --frozen-lockfile
}

function install_golang() {
    local release=$1

    if [[ -z "${release}" ]]; then
        release=1.15.6
    fi

    if [ -z "$(command -v wget)" ]; then
        sudo apt-get install -y -qq wget
    fi

    wget --quiet "https://dl.google.com/go/go${release}.linux-amd64.tar.gz"

    if [[ -d /usr/local/go ]]; then
        sudo rm -R /usr/local/go
    fi

    sudo tar -C /usr/local -xzf go${release}.linux-amd64.tar.gz &&
        echo "export PATH=$PATH:/usr/local/go/bin" >>"${HOME}/.bash_profile" &&
        echo "export GOPATH=${HOME}/go" >>"${HOME}/.bash_profile" &&
        echo "export GOROOT=/usr/local/go" >>"${HOME}/.bash_profile" &&
        source "${HOME}/.bash_profile" &&
        go version
}

function install_shfmt() {
    local release=$1
    local goos
    local goarch

    goarch="$(go env GOARCH)"
    goos="$(go env GOOS)"

    if [[ -z "${release}" ]]; then
        release=3.2.1
    fi

    if [ -z "$(command -v git)" ]; then
        sudo apt-get install -y -qq git
    fi

    GOPATH=${GOPATH:-${HOME}/go} &&
        GOOS="${goos}" GOARCH="${goarch}" \
            GO111MODULE=on go get "mvdan.cc/sh/v3/cmd/shfmt@v${release}" &&
        sudo mv "${GOPATH}/bin/shfmt" /usr/local/bin/shfmt &&
        shfmt --version
}

function install_shellcheck() {
    local release=$1
    local shellcheck_url
    shellcheck_url=https://github.com/koalaman/shellcheck/releases/download

    if [[ -z "${release}" ]]; then
        release=0.7.1
    fi

    if [ -z "$(command -v wget)" ]; then
        sudo apt-get install -y -qq wget
    fi

    wget --quiet "${shellcheck_url}/v${release}/shellcheck-v${release}.linux.x86_64.tar.xz" &&
        tar \
            -C ./ \
            -xf shellcheck-v${release}.linux.x86_64.tar.xz &&
        sudo mv \
            ./shellcheck-v${release}/shellcheck \
            /usr/local/bin/shellcheck &&
        sudo chmod +x /usr/local/bin/shellcheck &&
        sudo rm -R ./shellcheck-v${release} &&
        shellcheck --version
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

function install_hadolint() {
    local release="${1}"
    local download_url
    download_url=https://github.com/hadolint/hadolint/releases/download

    if [[ -z "${release}" ]]; then
        release=1.19.0
    fi

    wget --quiet "${download_url}/v${release}/hadolint-Linux-x86_64" &&
        chmod +x hadolint-Linux-x86_64 &&
        sudo mv hadolint-Linux-x86_64 /usr/local/bin/hadolint &&
        hadolint --version
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

function lint_dockerfiles() {
    hadolint \
        --config .hadolint.yaml \
        --ignore DL3009 \
        --ignore DL4001 \
        images/Ops.Dockerfile
}

function get_image() {
    local filter="${1}"

    docker image ls --filter reference="*_${filter}" | awk 'NR==2{print $1}'
}

function get_branch_from_azure_devops_ci() {
    if [[ -n "${SYSTEM_PULLREQUEST_SOURCEBRANCH}" ]]; then
        sed --regexp-extended 's|refs/heads/||g' <<<"${SYSTEM_PULLREQUEST_SOURCEBRANCH}"
    elif [[ -n "${BUILD_SOURCEBRANCH}" ]]; then
        sed --regexp-extended 's|refs/heads/||g' <<<"${BUILD_SOURCEBRANCH}"
    fi
}

function get_git_branch() {
    if [[ -z "$(get_branch_from_azure_devops_ci)" ]]; then
        git branch --show-current
    else
        get_branch_from_azure_devops_ci
    fi
}

function get_redacted_git_branch() {
    sed --regexp-extended 's|\W|-|g' <<<"$(get_git_branch)"
}

function get_short_sha() {
    git rev-parse --short --quiet HEAD
}

function get_git_tag() {
    git describe --abbrev=0 --tags 2>/dev/null || echo ""
}

function get_image_version() {
    local branch
    local short_sha
    local git_tag

    branch="$(get_redacted_git_branch)"
    short_sha="$(get_short_sha)"
    git_tag="$(get_git_tag)"

    if [[ -z "${git_tag}" ]]; then
        echo "${branch}-${short_sha}"
    else
        echo "${git_tag}"
    fi
}
