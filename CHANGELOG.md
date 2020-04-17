# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [1.1.0](https://github.com/Cisco-AMP/nexus_api/compare/v1.0.4...v1.1.0) - 2020-04-20
### Changed
- `list_repositories` to use the new `beta` API version which returns richer content than the old `v1` version

### Added
- create methods for hosted `docker`, `maven`, `npm`, `pypi`, and `yum` repository types (`raw` and `rubygems` aren't supported yet)
- delete method for any repository type


## [1.0.4](https://github.com/Cisco-AMP/nexus_api/compare/v1.0.3...v1.0.4) - 2020-03-23
### Added
- URL escaping
- `simplecov` gem to report on code coverage


## [1.0.3](https://github.com/Cisco-AMP/nexus_api/compare/v1.0.2...v1.0.3) - 2020-02-27
### Added
- Filter on CLI search to ignore results that don't include the search name in the file path


## [1.0.2](https://github.com/Cisco-AMP/nexus_api/compare/v1.0.1...v1.0.2) - 2020-02-27
### Added
- Ability to print the gem version on the CLI with `version`, `--version`, or `-v`


## [1.0.1](https://github.com/Cisco-AMP/nexus_api/compare/v1.0.0...v1.0.1) - 2020-01-15
### Security
- Use `excon` version `0.71.1` to avoid a [low severity vulnerability](https://github.com/excon/excon/security/advisories/GHSA-q58g-455p-8vw9)


## [1.0.0](https://github.com/Cisco-AMP/nexus_api/compare/master...v1.0.0) - 2019-12-04
### Added
- Released open source version of this project
