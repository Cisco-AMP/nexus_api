# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [2.1.0](https://github.com/Cisco-AMP/nexus_api/compare/v2.0.1...v2.1.0) - 2020-10-13
### Added
- The ability to override HTTPS as the connection protocol for testing purposes
- The ability to specify a component name during upload that differs from the local file on disk


## [2.0.1](https://github.com/Cisco-AMP/nexus_api/compare/v2.0.0...v2.0.1) - 2020-09-08
### Security
- Use `rake` version `12.3.3` or later to avoid an [OS Command Injection](https://github.com/advisories/GHSA-jppv-gw3r-w3q8)


## [2.0.0](https://github.com/Cisco-AMP/nexus_api/compare/v1.6.1...v2.0.0) - 2020-07-27
### Added
- Fully implemented create methods for group, hosted, and proxy type repository in the following formats:
  - docker
  - maven
  - npm
  - pypi
  - raw
  - rubygems
  - yum


### Changed
- Method signature for `NexusAPI::API.create_repository_docker_hosted()`
- Method signature for `NexusAPI::API.create_repository_maven_hosted()`
- Method signature for `NexusAPI::API.create_repository_npm_hosted()`
- Method signature for `NexusAPI::API.create_repository_pypi_hosted()`
- Method signature for `NexusAPI::API.create_repository_raw_hosted()`
- Method signature for `NexusAPI::API.create_repository_rubygems_hosted()`
- Method signature for `NexusAPI::API.create_repository_yum_hosted()`


## [1.6.1](https://github.com/Cisco-AMP/nexus_api/compare/v1.6.0...v1.6.1) - 2020-07-20
### Fixed
- Parameters for tag creation were being JSON encoded twice resulting in data Nexus could not parse


## [1.6.0](https://github.com/Cisco-AMP/nexus_api/compare/v1.5.0...v1.6.0) - 2020-07-20
### Added
- `create_repository_raw_hosted()`
- `create_repository_rubygems_hosted()`


## [1.5.0](https://github.com/Cisco-AMP/nexus_api/compare/v1.4.1...v1.5.0) - 2020-06-10
### Added
- New methods around the `privileges` endpoint
- New methods around the `roles` endpoint
- New methods around the `users` endpoint
- New `list_all_*` methods for endpoints that paginate so the user doesn't have to page through results themselves if they just want all the raw data


## [1.4.1](https://github.com/Cisco-AMP/nexus_api/compare/v1.4.0...v1.4.1) - 2020-05-08
### Changed
- Error reporting to be more descriptive


## [1.4.0](https://github.com/Cisco-AMP/nexus_api/compare/v1.3.0...v1.4.0) - 2020-05-05
### Added
- Optional `tag` parameter to `associate_tag()` and `delete_associated_tag()` methods

### Changed 
- Made `sha1` parameter optional for `associate_tag()` and `delete_associated_tag()` methods


## [1.3.0](https://github.com/Cisco-AMP/nexus_api/compare/v1.2.1...v1.3.0) - 2020-04-30
### Added
- Optional source and general keyword match into staging endpoint method (`move_components_to()`)


## [1.2.1](https://github.com/Cisco-AMP/nexus_api/compare/v1.2.0...v1.2.1) - 2020-04-29
### Fixed
- Correctly building request URLs when pagination is the only argument
- `bin/nexus_api tag list` now using pagination


## [1.2.0](https://github.com/Cisco-AMP/nexus_api/compare/v1.1.0...v1.2.0) - 2020-04-24
### Added
- `move_components_to` method for moving all components that match a given tag into a new destination
- `bin/nexus_api move` to the CLI for moving components


## [1.1.0](https://github.com/Cisco-AMP/nexus_api/compare/v1.0.4...v1.1.0) - 2020-04-17
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
