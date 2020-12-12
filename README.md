# containers

[![Build Status](https://dev.azure.com/eirenauts/containers/_apis/build/status/eirenauts.containers?branchName=master)](https://dev.azure.com/eirenauts/containers/_build/latest?definitionId=1&branchName=master)

This repository is a collection of build files for disparate container images.

## List of Images

| Image Name | Base Image   | Purpose                                  | Key Dependencies                                                  |
| ---------- | ------------ | ---------------------------------------- | ----------------------------------------------------------------- |
| super-ops  | ubuntu:20.04 | An infrastructure as code focussed image | azure-cli, jq, sops, yarn, go, shfmt, shellcheck, helm, terraform |

## Image pull commands

| Image Name | Docker pull command                                  |
| ---------- | ---------------------------------------------------- |
| super-ops  | docker pull ghcr.io/eirenauts-infra/super-ops:latest |

## Licence

[Apache 2.0](https://choosealicense.com/licenses/apache-2.0/)
