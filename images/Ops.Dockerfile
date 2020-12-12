FROM ubuntu:20.04

ARG SHORT_SHA
ARG VERSION
ARG AZ_CLI_VERSION=${AZ_CLI_VERSION:-2.16.0}
ARG JQ_VERSION=${JQ_VERSION:-1.6}
ARG SOPS_VERSION=${SOPS_VERSION:-3.6.1}
ARG GOLANG_VERSION=${GOLANG_VERSION:-1.15.6}
ARG SHFMT_VERSION=${SHFMT_VERSION:-3.2.1}
ARG SHELLCHECK_VERSION=${SHELLCHECK_VERSION:-0.7.1}
ARG YAMLLINT_VERSION=${YAMLLINT_VERSION:-1.25.0}
ARG HELM_VERSION=${HELM_VERSION:-3.4.1}
ARG TERRAFORM_VERSION=${TERRAFORM_VERSION:-0.14.2}

LABEL \
    \
    \
    org.opencontainers.image.title="eirenauts/super-ops"                             \
    org.opencontainers.image.description="A bundle docker image for CI/CD ops"       \
    org.opencontainers.image.url=""                                                  \
    org.opencontainers.image.source="https://github.com/eirenauts/containers"        \
    org.opencontainers.image.revision="${SHORT_SHA}"                                 \
    org.opencontainers.image.version="${VERSION}"                                    \
    org.opencontainers.image.authors="Eirenauts (https://github.com/eirenauts)"      \
    org.opencontainers.image.licenses="Apache 2.0"

ENV \
    \
    \
    SOPS_DOWNLOAD_URL=https://github.com/mozilla/sops/releases/download \
    SHELLCHECK_DOWNLOAD_URL=https://github.com/koalaman/shellcheck/releases/download \
    TERRAFORM_DOWNLOAD_URL=https://releases.hashicorp.com/terraform \
    PATH=$PATH:/usr/local/go/bin \
    GOROOT=/usr/local/go \
    GOPATH=/.go \
    LANG=en_US.utf8 \
    REGION=en_US \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC

RUN \
    \
    \
    echo "Commencing install of the locales" && \
    apt-get update -y -qq && \
    apt-get install -y -qq locales && \
    localedef -i ${REGION} -c -f UTF-8 -A /usr/share/locale/locale.alias ${LANG} && \
    echo "Finishing install of the locales" && \
    \
    \
    echo "Commencing install of the azure cli" && \
    apt-get install -y -qq \
        lsb-release \
        ca-certificates \
        curl \
        apt-transport-https \
        gnupg && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
        gpg --dearmor | \
            tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg >/dev/null && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
        tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update -y && \
    az_cli_version="$( \
      apt-cache madison azure-cli | grep "${AZ_CLI_VERSION}" | awk 'NR==1 {print $3}' \
    )" && \
    echo "Installaing azure cli version ${az_cli_version}" && \
    apt-get install -y -qq "azure-cli=${az_cli_version}" && \
    echo "Finished installation of the azure cli" && \
    \
    \
    echo "Commencing installation of jq" && \
    apt-get install -y -qq wget && \
    wget --quiet "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" && \
    chmod +x jq-linux64 && \
    mv jq-linux64 /usr/local/bin/jq && \
    echo "Finished installation of the azure cli" && \
    \
    \
    echo "Commencing installation of sops" && \
    wget --quiet "${SOPS_DOWNLOAD_URL}/v${SOPS_VERSION}/sops_${SOPS_VERSION}_amd64.deb" && \
    dpkg --install sops_*.deb && \
    echo "Finished installation of the sops" && \
    \
    \
    echo "Commencing installation of yarn" && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
        tee /etc/apt/sources.list.d/yarn.list && \
    apt update -y -qq && apt install -y -qq yarn && \
    echo "Finished installation of the yarn" && \
    \
    \
    echo "Commencing installation of golang" && \
    mkdir -p "${GOPATH}" && \
    wget --quiet "https://dl.google.com/go/go${GOLANG_VERSION}.linux-amd64.tar.gz" && \
    tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz && \
    echo "Finished installation of golang" && \
    \
    \
    echo "Commencing installation of shfmt" && \
    apt-get install -y -qq git && \
    GOOS="$(go env GOOS)" \
    GOARCH="$(go env GOARCH)" \
    GO111MODULE=on go get "mvdan.cc/sh/v3/cmd/shfmt@v${SHFMT_VERSION}" && \
    mv /.go/bin/shfmt /usr/local/bin/shfmt && \
    echo "Finished installation of shfmt" && \
    \
    \
    echo "Commencing installation of shellcheck" && \
    wget --quiet "${SHELLCHECK_DOWNLOAD_URL}/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz" && \
    tar \
        -C /usr/local/bin \
        -xf shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz && \
    mv \
        /usr/local/bin/shellcheck-v${SHELLCHECK_VERSION}/shellcheck \
        /usr/local/bin/shellcheck && \
    chmod +x /usr/local/bin/shellcheck && \
    echo "Finished installation of shellcheck" && \
    \
    \
    echo "Commencing installation of yamllint" && \
    apt-get install -y -qq python3-pip && \
    pip3 install "yamllint==${YAMLLINT_VERSION}" && \
    echo "Finished installation of yamllint" && \
    \
    \
    echo "Commencing installation of helm" && \
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh --version "v${HELM_VERSION}" && \
    echo "Finished installation of helm" && \
    \
    \
    echo "Commencing installation of terraform" && \
    wget --quiet "${TERRAFORM_DOWNLOAD_URL}/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    apt-get install -y -qq unzip && \
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    chmod +x terraform && \
    mv terraform /usr/local/bin/terraform && \
    echo "Finished installation of terraform"

RUN \
    \
    \
    az --version && \
    jq --version && \
    sops --version && \
    yarn --version && \
    go version && \
    shfmt --version && \
    shellcheck --version && \
    helm version --short && \
    terraform version
