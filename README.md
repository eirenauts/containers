# containers

[![Build Status](https://dev.azure.com/eirenauts/containers/_apis/build/status/eirenauts.containers?branchName=master)](https://dev.azure.com/eirenauts/containers/_build/latest?definitionId=1&branchName=master) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://choosealicense.com/licenses/apache-2.0/) ![Semver Version](https://img.shields.io/github/v/tag/eirenauts/containers?color=blue&sort=semver)

This repository is a collection of build files for disparate container images.

## List of Images

| Image                                                                                      | Version                                                                                                                                            | Base Image                               | Key Components                                                                                  | Purpose                                             |
| ------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------- | ----------------------------------------------------------------------------------------------- | --------------------------------------------------- |
| [super-ops](https://github.com/users/eirenauts-infra/packages/container/package/super-ops) | [![Docker Version](https://img.shields.io/badge/version-0.1.1-blue)](https://github.com/users/eirenauts-infra/packages/container/package/super-ops) | `ubuntu:focal-20201106` (`ubuntu:20.04`) | `azure-cli`, `jq`, `sops`, `yarn`, `go`, `shfmt`, `shellcheck`, `helm`, `terraform`, `hadolint` | CI/CD linting and infrastructure as code operations |

## Licence

[Apache 2.0](https://choosealicense.com/licenses/apache-2.0/)
