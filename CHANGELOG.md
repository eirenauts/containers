# Changelog

**_Please follow the [keep a changelog conventions](https://keepachangelog.com/en/1.0.0/)_**

## 2.0.0 (14.05.2023)

**_Changed_**

- Updated the base image of ubuntu to 22.04, `jammy`. [eirenauts/containers#14]
- Updated multiple dependencies including a major version change
  for `nodejs`. [eirenauts/containers#14]

## 1.4.0 (28.12.2020)

**_Added_**

- Dependencies `yq` version 4.2.0. [eirenauts/containers#13]

[eirenauts/containers#13]: https://github.com/eirenauts/containers/pull/13

## 1.3.0 (23.12.2020)

**_Added_**

- Dependencies `ansible`, `jmespath`, `openshift` . [eirenauts/containers#12]

[eirenauts/containers#12]: https://github.com/eirenauts/containers/pull/12

## 1.2.0 (23.12.2020)

**_Added_**

- Dependency `venv` added for image `super-ops`. [eirenauts/containers#11]

[eirenauts/containers#11]: https://github.com/eirenauts/containers/pull/11

## 1.1.0 (14.12.2020)

**_Added_**

- Dependency `build-essential` added for access to make in image `super-ops`. [eirenauts/containers#9]

**_Fixed_**

- Fixed issue where git tag was erroneously picked up on git commits without tag resulting
  in overriding of the previously tagged image with latest untagged changes [eirenauts/containers#10]

[eirenauts/containers#9]: https://github.com/eirenauts/containers/pull/9
[eirenauts/containers#10]: https://github.com/eirenauts/containers/pull/10

## 1.0.0 (13.12.2020)

**_Added_**

- Images `1.0.0` and upwards will now be available from the `eirenauts` container
  registry. See [packages](https://github.com/orgs/eirenauts/packages/container/package/super-ops) [eirenauts/containers#6]

**_Removed_**

- Removed the old container registry `eirenauts-infra` due to difficulties making it
  public. [eirenauts/containers#6]

**_Deprecated_**

- Images `0.1.1` and `0.1.0` will no longer be available. [eirenauts/containers#6]

[eirenauts/containers#6]: https://github.com/eirenauts/containers/pull/6

**_Fixed_**

- Silent failure of shellcheck installation fixed [eirenauts/containers#5]

## 0.1.1 (13.12.2020)

**_Added_**

- Added Hadolint for linting Dockerfiles [eirenauts/containers#5]

[eirenauts/containers#5]: https://github.com/eirenauts/containers/pull/5

**_Fixed_**

- Silent failure of shellcheck installation fixed [eirenauts/containers#5]

[eirenauts/containers#5]: https://github.com/eirenauts/containers/pull/5

## 0.1.0 (13.12.2020)

This is the first release of `eirenauts/containers`

**_Added_**

- Scaffolding CI/CD and targets with bash and make [eirenauts/containers#1]
- Write Ops Dockerfile intended for use with infrastructure as code [eirenauts/containers#1]
- Only run build and lint on branches [eirenauts/containers#2]
- Avoid duplicate builds when having a pull request [eirenauts/containers#3]
- Only run the push step when a tag triggers the builds [eirenauts/containers#4]

[eirenauts/containers#1]: https://github.com/eirenauts/containers/pull/1
[eirenauts/containers#2]: https://github.com/eirenauts/containers/pull/2
[eirenauts/containers#3]: https://github.com/eirenauts/containers/pull/3
[eirenauts/containers#4]: https://github.com/eirenauts/containers/pull/4
