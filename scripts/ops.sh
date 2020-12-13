#!/bin/bash

function set_env_variables_ops_dockerfile() {
    if [[ -e .env ]]; then
        rm .env &&
            touch .env
    fi

    {
        echo "SHORT_SHA=$(get_short_sha)"
        echo "VERSION=$(get_image_version)"
        echo "AZ_CLI_VERSION=${AZ_CLI_VERSION:-2.16.0}"
        echo "JQ_VERSION=${JQ_VERSION:-1.6}"
        echo "SOPS_VERSION=${SOPS_VERSION:-3.6.1}"
        echo "GOLANG_VERSION=${GOLANG_VERSION:-1.15.6}"
        echo "SHFMT_VERSION=${SHFMT_VERSION:-3.2.1}"
        echo "SHELLCHECK_VERSION=${SHELLCHECK_VERSION:-0.7.1}"
        echo "YAMLLINT_VERSION=${YAMLLINT_VERSION:-1.25.0}"
        echo "HELM_VERSION=${HELM_VERSION:-3.4.1}"
        echo "TERRAFORM_VERSION=${TERRAFORM_VERSION:-0.14.2}"
    } >>.env
}
