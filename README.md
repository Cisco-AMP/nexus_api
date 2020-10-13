# Nexus API
A ruby gem that wraps the [Sonatype Nexus Repository Manager 3](https://help.sonatype.com/repomanager3)'s [REST API](https://help.sonatype.com/repomanager3/rest-and-integration-api), allowing users to interact with Nexus without having to write new connection code every time.


## Latest Version Tested
Title | Value
---|---
**Version** | `3.24.0-02`
**Edition** | `PRO`
**Build Revision** | `302d6f23f1414581162efaf0fa7b4d81dbf9b251`
**Build Timestamp** | `2020-06-03-2332-51567`


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'nexus_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nexus_api


## Usage
You can either use the [CLI](bin/nexus_api) to query Nexus directly or require the `nexus_api` gem in your code to interact with it programatically.


### Default Repositories
Both the CLI and the `NexusAPI::API` class support being passed a config which provides a default set of repositories for all commands that require one be specifed. You can look at the [template config](team_configs/template.yaml) for the list of supported methods, and create any number of configs for yourself or other users and teams. Global defaults can be set in the [default config](team_configs/default.yaml) which is used if no other config is specified.

*NOTE*: Not every config item needs to be set, just the ones you want to use. If no default repository is set and none is passed in, you will simply receive an error.


### Using the CLI
Copy `.env.template` from the root directory into `.env` and fill in the values. You can view the help by running the following:
```
bin/nexus_api
```


### Using the Class
Documentation is never perfect. Use this section as a reference, but [lib/nexus_api.rb](lib/nexus_api.rb) and [lib/endpoints](lib/endpoints) should be regarded as the source of truth.


```ruby
# Require the gem
require 'nexus_api'

# Create an instance of the API class
# Optionally, you can provide Docker push and pull endpoints
# (if configured in Nexus) or provide a team configuration file
api = NexusAPI::API.new(
  username: NEXUS_USERNAME,
  password: NEXUS_PASSWORD,
  hostname: NEXUS_HOSTNAME,
  docker_pull_hostname: DOCKER_PULL_HOSTNAME,  # Optional
  docker_push_hostname: DOCKER_PUSH_HOSTNAME,  # Optional
  config: "team_configs/#{CONFIG_NAME}",       # Optional
  protocol: "https",                           # Optional
)
# NOTE: All Docker commands will fail if the docker hostnames are not initialized


# You can create various types of repositories in different formats
api.create_repository_docker_group(
  name: REPOSITORY_NAME,
  members: REPOSITORY_MEMBERS,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)
api.create_repository_docker_hosted(
  name: REPOSITORY_NAME,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)
api.create_repository_docker_proxy(
  name: REPOSITORY_NAME,
  remote_url: URL_TO_PROXY,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)

api.create_repository_maven_group(
  name: REPOSITORY_NAME,
  members: REPOSITORY_MEMBERS,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)
api.create_repository_maven_hosted(
  name: REPOSITORY_NAME,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)
api.create_repository_maven_proxy(
  name: REPOSITORY_NAME,
  remote_url: URL_TO_PROXY,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)

api.create_repository_npm_group(
  name: REPOSITORY_NAME,
  members: REPOSITORY_MEMBERS,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)
api.create_repository_npm_hosted(
  name: REPOSITORY_NAME,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)
api.create_repository_npm_proxy(
  name: REPOSITORY_NAME,
  remote_url: URL_TO_PROXY,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)

api.create_repository_pypi_group(
  name: REPOSITORY_NAME,
  members: REPOSITORY_MEMBERS,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)
api.create_repository_pypi_hosted(
  name: REPOSITORY_NAME,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)
api.create_repository_pypi_proxy(
  name: REPOSITORY_NAME,
  remote_url: URL_TO_PROXY,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)

api.create_repository_raw_group(
  name: REPOSITORY_NAME,
  members: REPOSITORY_MEMBERS,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)
api.create_repository_raw_hosted(
  name: REPOSITORY_NAME,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)
api.create_repository_raw_proxy(
  name: REPOSITORY_NAME,
  remote_url: URL_TO_PROXY,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)

api.create_repository_rubygems_group(
  name: REPOSITORY_NAME,
  members: REPOSITORY_MEMBERS,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)
api.create_repository_rubygems_hosted(
  name: REPOSITORY_NAME,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)
api.create_repository_rubygems_proxy(
  name: REPOSITORY_NAME,
  remote_url: URL_TO_PROXY,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)

api.create_repository_yum_group(
  name: REPOSITORY_NAME,
  members: REPOSITORY_MEMBERS,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)
api.create_repository_yum_hosted(
  name: REPOSITORY_NAME,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)
api.create_repository_yum_proxy(
  name: REPOSITORY_NAME,
  remote_url: URL_TO_PROXY,
  options: HASH_OF_REPOSITORY_OPTIONS  # Optional
)


# You can query information through the list methods
api.list_all_assets(repository: REPOSITORY_NAME)
api.list_assets(repository: REPOSITORY_NAME, paginate: BOOLEAN)
api.list_asset(id: ASSET_ID)

api.list_all_components(repository: REPOSITORY_NAME)
api.list_components(repository: REPOSITORY_NAME, paginate: BOOLEAN)
api.list_component(id: ASSET_ID)

api.list_privileges
api.list_privilege(privilege_id: ID)

api.list_repositories
api.list_repository_names

api.list_roles
api.list_role(id: ROLE_ID)

api.list_scripts

api.list_all_tags
api.list_tags(paginate: BOOLEAN)

api.list_users


# You can search for an asset by its name
# Optionally, you can pass in additional fields to filter the results
api.search_all_assets(
  name: ASSET_NAME,
  format: REPOSITORY_FORMAT,    # Optional
  repository: REPOSITORY_NAME,  # Optional
  sha1: SHA1,                   # Optional
  version: VERSION,             # Optional
)
# You can also paginate through the results if you want to do some additional filtering
api.search_asset(
  name: ASSET_NAME,
  format: REPOSITORY_FORMAT,    # Optional
  repository: REPOSITORY_NAME,  # Optional
  sha1: SHA1,                   # Optional
  version: VERSION,             # Optional
  paginate: BOOLEAN             # Optional
)


# The following endpoints will paginate: 
#  - list_assets
#  - list_components
#  - list_tags
#  - search_asset
# Or you can use the following methods to automatically gather data from all pages for you:
#  - list_all_assets
#  - list_all_components
#  - list_all_tags
#  - search_all_assets
# Or you can use the following pattern to page through if additional processing is desired:
set = Array.new.tap do |set|
  loop do
    set.concat(api.METHOD_YOU_WANT(ARGUMENTS, paginate: true))
    break unless api.paginate?
  end
end


# You can move all components that are tagged to a new destination
api.move_components_to(destination: DESTINATION, tag: TAG)


# You can download an asset by using its asset_id
# Optionally, you can rename the file on download
api.download(
  id: ASSET_ID,
  name: NEW_FILE_NAME,  # Optional
)


# Different asset types require differing information to be uploaded
# Optionally, you can:
#   - tag the component provided the tag already exists
#   - indicate the name of the local file to be uploaded (when it is different from filename)
api.upload_maven_component(
  filename: MAVEN_FILENAME,
  group_id: GROUP_ID,
  artifact_id: ARTIFACT_ID,
  version: VERSION,
  repository: REPOSITORY_NAME,
  tag: TAG,                             # Optional
  upstream_filename: UPSTREAM_FILENAME, # Optional
)
api.upload_npm_component(
  filename: NPM_FILENAME,
  repository: REPOSITORY_NAME,
  tag: TAG,                             # Optional
  upstream_filename: UPSTREAM_FILENAME, # Optional
)
api.upload_pypi_component(
  filename: PYPI_FILENAME,
  repository: REPOSITORY_NAME,
  tag: TAG,                             # Optional
  upstream_filename: UPSTREAM_FILENAME, # Optional
)
api.upload_raw_component(
  filename: NPM_FILENAME,
  directory: PATH_IN_NEXUS,
  repository: REPOSITORY_NAME,
  tag: TAG,                             # Optional
  upstream_filename: UPSTREAM_FILENAME, # Optional
)
api.upload_rubygems_component(
  filename: RUBYGEMS_FILENAME,
  repository: REPOSITORY_NAME,
  tag: TAG,                             # Optional
  upstream_filename: UPSTREAM_FILENAME, # Optional
)
api.upload_yum_component(
  filename: YUM_FILENAME,
  directory: PATH_IN_NEXUS,
  repository: REPOSITORY_NAME,
  tag: TAG,                             # Optional
  upstream_filename: UPSTREAM_FILENAME, # Optional
)


# Docker is a special case and uses the local Docker daemon
# If this daemon is not installed and running these methods will fail
# NOTE: Docker login/logout is handled as part of the docker methods
api.download_docker_component(image: IMAGE_NAME, tag: DOCKER_TAG)
api.upload_docker_component(image: IMAGE_NAME, tag: DOCKER_TAG)


# You can create/delete tags and associate/disassociate them from components
# (we use the SHA1 rather than the file name because the Nexus search is inconsistent)
api.create_tag(name: TAG)
api.associate_tag(name: TAG, sha1: SHA1_SUM, repository: REPOSITORY_NAME)
api.delete_associated_tag(name: TAG, sha1: SHA1_SUM, repository: REPOSITORY_NAME)
api.delete_tag(name: TAG)


# You can query the Nexus status
api.status
api.status_writable


# Using an asset's URL you can gather its filesize as a String
api.get_asset_size(asset_url: URL)
```


## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/test` to run the tests.

To install this gem onto your local machine, run `bin/install`. To release a new version, update the version number in `version.rb`, and then run `bin/release`, which will create a git tag for the version, push git commits and tags.


## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/Cisco-AMP/nexus_api.


## License
This gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
