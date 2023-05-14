#!/bin/bash

function set_env_variables_ops_dockerfile() {
    if [[ -e .env ]]; then
        rm .env &&
            touch .env
    fi

    {
        echo "AZ_CLI_VERSION=${AZ_CLI_VERSION:-2.48.0}"
        echo "JQ_VERSION=${JQ_VERSION:-1.6}"
        echo "YQ_VERSION=${YQ_VERSION:-4.33.3}"
        echo "SOPS_VERSION=${SOPS_VERSION:-3.7.3}"
        echo "GOLANG_VERSION=${GOLANG_VERSION:-1.20.4}"
        echo "NODEJS_VERSION=${NODEJS_VERSION:-18.16.0}"
        echo "YARN_VERSION=${YARN_VERSION:-1.22.5}"
        echo "SHFMT_VERSION=${SHFMT_VERSION:-3.6.0}"
        echo "SHELLCHECK_VERSION=${SHELLCHECK_VERSION:-0.9.0}"
        echo "PIP_VERSION=${PIP_VERSION:-23.1.2}"
        echo "YAMLLINT_VERSION=${YAMLLINT_VERSION:-1.31.0}"
        echo "HADOLINT_VERSION=${HADOLINT_VERSION:-2.12.0}"
        echo "HELM_VERSION=${HELM_VERSION:-3.12.0}"
        echo "TERRAFORM_VERSION=${TERRAFORM_VERSION:-1.4.6}"
        echo "ANSIBLE_VERSION=${ANSIBLE_VERSION:-7.5.0}"
        echo "JMESPATH_VERSION=${JMESPATH_VERSION:-1.0.1}"
        echo "OPENSHIFT_VERSION=${OPENSHIFT_VERSION:-0.13.1}"
        echo "ANSIBLE_KUBERNETES_VERSION=${ANSIBLE_KUBERNETES_VERSION:-2.4.0}"
    } >>.env
}
