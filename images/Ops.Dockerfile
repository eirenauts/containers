FROM ubuntu:jammy-20230425

ARG SHORT_SHA
ARG VERSION
ARG AZ_CLI_VERSION=${AZ_CLI_VERSION:-2.48.0}
ARG JQ_VERSION=${JQ_VERSION:-1.6}
ARG YQ_VERSION=${YQ_VERSION:-4.33.3}
ARG SOPS_VERSION=${SOPS_VERSION:-3.7.3}
ARG GOLANG_VERSION=${GOLANG_VERSION:-1.20.4}
ARG NODEJS_VERSION=${NODEJS_VERSION:-18.16.0}
ARG YARN_VERSION=${YARN_VERSION:-1.22.5}
ARG SHFMT_VERSION=${SHFMT_VERSION:-3.6.0}
ARG SHELLCHECK_VERSION=${SHELLCHECK_VERSION:-0.9.0}
ARG PIP_VERSION=${PIP_VERSION:-23.1.2}
ARG YAMLLINT_VERSION=${YAMLLINT_VERSION:-1.31.0}
ARG HADOLINT_VERSION=${HADOLINT_VERSION:-2.12.0}
ARG HELM_VERSION=${HELM_VERSION:-3.12.0}
ARG TERRAFORM_VERSION=${TERRAFORM_VERSION:-1.4.6}
ARG ANSIBLE_VERSION=${ANSIBLE_VERSION:-7.5.0}
ARG JMESPATH_VERSION=${JMESPATH_VERSION:-1.0.1}
ARG OPENSHIFT_VERSION=${OPENSHIFT_VERSION:-0.13.1}
ARG ANSIBLE_KUBERNETES_VERSION=${ANSIBLE_KUBERNETES_VERSION:-2.4.0}

LABEL \
    \
    \
    org.opencontainers.image.title="super-ops"                                       \
    org.opencontainers.image.description="A bundle docker image for CI/CD ops"       \
    org.opencontainers.image.url="ghcr.io/eirnauts-infra/super-ops:${VERSION}"       \
    org.opencontainers.image.source="https://github.com/eirenauts/containers"        \
    org.opencontainers.image.revision="${SHORT_SHA}"                                 \
    org.opencontainers.image.version="${VERSION}"                                    \
    org.opencontainers.image.authors="Eirenauts (https://github.com/eirenauts)"      \
    org.opencontainers.image.licenses="Apache 2.0"

ENV \
    \
    \
    AZ_CLI_VERSION="${AZ_CLI_VERSION}" \
    JQ_VERSION="${JQ_VERSION}" \
    YQ_VERSION="${YQ_VERSION}" \
    SOPS_VERSION="${SOPS_VERSION}" \
    GOLANG_VERSION="${GOLANG_VERSION}" \
    NODEJS_VERSION="${NODEJS_VERSION}" \
    YARN_VERSION="${YARN_VERSION}" \
    SHFMT_VERSION="${SHFMT_VERSION}" \
    SHELLCHECK_VERSION="${SHELLCHECK_VERSION}" \
    PIP_VERSION="${PIP_VERSION}" \
    YAMLLINT_VERSION="${YAMLLINT_VERSION}" \
    HADOLINT_VERSION="${HADOLINT_VERSION}" \
    HELM_VERSION="${HELM_VERSION}" \
    TERRAFORM_VERSION="${TERRAFORM_VERSION}" \
    ANSIBLE_VERSION="${ANSIBLE_VERSION}" \
    JMESPATH_VERSION="${JMESPATH_VERSION}" \
    OPENSHIFT_VERSION="${OPENSHIFT_VERSION}" \
    ANSIBLE_KUBERNETES_VERSION="${ANSIBLE_KUBERNETES_VERSION}" \
    SOPS_DOWNLOAD_URL=https://github.com/mozilla/sops/releases/download \
    SHELLCHECK_DOWNLOAD_URL=https://github.com/koalaman/shellcheck/releases/download \
    HADOLINT_DOWNLOAD_URL=https://github.com/hadolint/hadolint/releases/download \
    TERRAFORM_DOWNLOAD_URL=https://releases.hashicorp.com/terraform \
    PATH=$PATH:/usr/local/go/bin \
    GOROOT=/usr/local/go \
    GOPATH=/.go \
    LANG=en_US.utf8 \
    REGION=en_US \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC

SHELL ["/bin/bash", "-e", "-o", "pipefail", "-c"]
RUN \
    \
    \
    echo "Commencing install of the build essential" && \
    apt-get update -y -qq && \
    apt-get install -y -qq --no-install-recommends build-essential=12.9ubuntu3 && \
    echo "Finishing install of the build essential" && \
    \
    \
    echo "Commencing install of the locales" && \
    apt-get update -y -qq && \
    apt-get install -y -qq --no-install-recommends locales=2.35-0ubuntu3.1 && \
    localedef -i ${REGION} -c -f UTF-8 -A /usr/share/locale/locale.alias ${LANG} && \
    echo "Finishing install of the locales"; \
    \
    \
    echo "Commencing install of the azure cli" && \
    apt-get install -y -qq --no-install-recommends \
        lsb-release=11.1.0ubuntu4 \
        ca-certificates=20211016ubuntu0.22.04.1 \
        curl=7.81.0-1ubuntu1.10 \
        apt-transport-https=2.4.9 \
        gnupg=2.2.27-3ubuntu2.1 && \
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
    apt-get install -y -qq --no-install-recommends "azure-cli=${az_cli_version}" && \
    echo "Finished installation of the azure cli" && \
    \
    \
    echo "Commencing installation of jq" && \
    apt-get update -y -qq && \
    apt-get install -y --no-install-recommends wget=1.21.2-2ubuntu1 && \
    wget --quiet "https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64" && \
    chmod +x jq-linux64 && \
    mv jq-linux64 /usr/local/bin/jq && \
    echo "Finished installation of jq" && \
    \
    \
    echo "Commencing installation of yq" && \
    wget --quiet "https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64" && \
    chmod +x yq_linux_amd64 && \
    mv yq_linux_amd64 /usr/local/bin/yq && \
    echo "Finished installation of yq" && \
    \
    \
    echo "Commencing installation of sops" && \
    wget --quiet "${SOPS_DOWNLOAD_URL}/v${SOPS_VERSION}/sops_${SOPS_VERSION}_amd64.deb" && \
    dpkg --install sops_*.deb && \
    echo "Finished installation of the sops" && \
    \
    \
    echo "Commencing installation of yarn" && \
    nodejs_ppa_source=https://deb.nodesource.com/setup_$(echo "${NODEJS_VERSION}" | cut -d"." -f1).x && \
    curl -sL "${nodejs_ppa_source}" -o nodesource_setup.sh && \
    chmod +x ./nodesource_setup.sh && \
    ./nodesource_setup.sh && \
    apt-get update -y -qq && \
    nodejs_version="$( \
      apt-cache madison nodejs | grep "${NODEJS_VERSION}" | awk 'NR==1 {print $3}' \
    )" && \
    apt-get install -y -qq --no-install-recommends nodejs="${nodejs_version}" && \
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | \
        gpg --dearmor | \
        tee /usr/share/keyrings/yarnkey.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | \
        tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -y -qq && \
    yarn_version="$( \
      apt-cache madison yarn | grep "${YARN_VERSION}" | awk 'NR==1 {print $3}' \
    )" && \
    apt-get install -y -qq --no-install-recommends yarn="${yarn_version}" && \
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
    apt-get install -y -qq --no-install-recommends git=1:2.34.1-1ubuntu1.9 && \
    GOOS="$(go env GOOS)" \
    GOARCH="$(go env GOARCH)" \
    GO111MODULE=on go install "mvdan.cc/sh/v3/cmd/shfmt@v${SHFMT_VERSION}" && \
    mv /.go/bin/shfmt /usr/local/bin/shfmt && \
    echo "Finished installation of shfmt" && \
    \
    \
    echo "Commencing installation of shellcheck" && \
    apt-get install -y -qq --no-install-recommends xz-utils=5.2.5-2ubuntu1 && \
    wget --quiet \
        "${SHELLCHECK_DOWNLOAD_URL}/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz" && \
    tar \
        -C ./ \
        -xf shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz && \
    mv \
        ./shellcheck-v${SHELLCHECK_VERSION}/shellcheck \
        /usr/local/bin/shellcheck && \
    chmod +x /usr/local/bin/shellcheck && \
    echo "Finished installation of shellcheck" && \
    \
    \
    echo "Commencing installation of python3-venv and pip" && \
    apt-get install -y -qq --no-install-recommends \
        python3-venv=3.10.6-1~22.04 \
        python3-pip=22.0.2+dfsg-1ubuntu0.2 && \
    pip install --no-cache-dir "pip==${PIP_VERSION}" && \
    echo "Finished installation of python3-venv and pip" && \
    \
    \
    echo "Commencing installation of yamllint" && \
    pip install --no-cache-dir "yamllint==${YAMLLINT_VERSION}" && \
    echo "Finished installation of yamllint" && \
    \
    \
    echo "Commencing installation of hadolint" && \
    wget --quiet "${HADOLINT_DOWNLOAD_URL}/v${HADOLINT_VERSION}/hadolint-Linux-x86_64" && \
    chmod +x hadolint-Linux-x86_64 && \
    mv hadolint-Linux-x86_64 /usr/local/bin/hadolint && \
    echo "Finished installation of hadonlint" && \
    \
    \
    echo "Commencing installation of helm" && \
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh --version "v${HELM_VERSION}" && \
    echo "Finished installation of helm"; \
    \
    \
    echo "Commencing installation of terraform" && \
    wget --quiet "${TERRAFORM_DOWNLOAD_URL}/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    apt-get install -y -qq --no-install-recommends unzip=6.0-26ubuntu3.1 && \
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    chmod +x terraform && \
    mv terraform /usr/local/bin/terraform && \
    echo "Finished installation of terraform" && \
    \
    \
    echo "Commencing installation of ansible and ansible k8s dependencies" && \
    pip install --no-cache-dir ansible=="${ANSIBLE_VERSION}" && \
    pip install --no-cache-dir jmespath=="${JMESPATH_VERSION}" && \
    pip install --no-cache-dir openshift=="${OPENSHIFT_VERSION}" && \
    ansible-galaxy collection install kubernetes.core:=="${ANSIBLE_KUBERNETES_VERSION}" && \
    echo "Finished installation of ansible and ansible k8s dependencies"

RUN \
    \
    \
    az --version && \
    jq --version && \
    sops --version && \
    node --version && \
    yarn --version && \
    go version && \
    shfmt --version && \
    shellcheck --version && \
    helm version --short && \
    terraform version
