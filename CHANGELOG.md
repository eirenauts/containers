# Changelog

**_Note:_**
Follow the [keep a changelog conventions](https://keepachangelog.com/en/1.0.0/)

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
