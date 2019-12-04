require 'nexus_api/version'
require 'nexus_api/docker_shell'
require 'nexus_api/docker_manager'
require 'nexus_api/nexus_connection'
require 'nexus_api/config_manager'
require 'json'
require 'pry'

# Nexus API docs: 
# https://help.sonatype.com/repomanager3/rest-and-integration-api#app
# https://[NEXUS_URL]/#admin/system/api
module NexusAPI
  class API
    attr_accessor :connection
    attr_accessor :docker
    attr_accessor :team_config

    TEAM_CONFIG = File.join(File.dirname(__dir__), 'team_configs/default.yaml').freeze

    def initialize(username:, password:, hostname:, docker_pull_hostname: nil, docker_push_hostname: nil, team_config: nil)
      @connection = NexusAPI::NexusConnection.new(
        username: username,
        password: password,
        hostname: hostname,
      )
      if docker_pull_hostname.nil? || docker_push_hostname.nil?
        @docker = nil
      else
        @docker = NexusAPI::DockerManager.new(
          docker: NexusAPI::DockerShell.new,
          options: {
            'username' => username,
            'password' => password,
            'pull_host' => docker_pull_hostname,
            'push_host' => docker_push_hostname,
          }
        )
      end
      team_config ||= TEAM_CONFIG
      @team_config = NexusAPI::ConfigManager.new(config_path: team_config)
    end


    # ---ASSETS---
    # GET /service/rest/v1/assets
    def list_assets(repository: nil, paginate: false)
      repository ||= @team_config.assets_repository
      @connection.get_response(endpoint: "assets?repository=#{repository}", paginate: paginate)
    end

    # GET /service/rest/v1/assets/{id}
    def list_asset(id:)
      @connection.get_response(endpoint: "assets/#{id}")
    end

    # DELETE /service/rest/v1/assets/{id}


    # ---BLOB STORE---
    # GET /service/rest/v1/blobstores/{id}/quota-status


    # ---COMPONENTS---
    # GET /service/rest/v1/components
    def list_components(repository: nil, paginate: false)
      repository ||= @team_config.components_repository
      @connection.get_response(endpoint: "components?repository=#{repository}", paginate: paginate)
    end

    # POST /service/rest/v1/components
    def upload_maven_component(filename:, group_id:, artifact_id:, version:, repository: nil, tag: nil)
      repository ||= @team_config.maven_repository
      parameters = {
        'maven2.groupId' => group_id,
        'maven2.artifactId' => artifact_id,
        'maven2.version' => version,
        'maven2.asset1' => File.open(filename, 'r'),
        'maven2.asset1.extension' => filename.split('.').last,
      }
      parameters['maven2.tag'] = tag if tag
      @connection.post(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
    end

    def upload_npm_component(filename:, repository: nil, tag: nil)
      repository ||= @team_config.npm_repository
      parameters = {
        'npm.asset' => File.open(filename, 'r'),
      }
      parameters['npm.tag'] = tag if tag
      @connection.post(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
    end

    def upload_pypi_component(filename:, repository: nil, tag: nil)
      repository ||= @team_config.pypi_repository
      parameters = {
        'pypi.asset' => File.open(filename, 'r'),
      }
      parameters['pypi.tag'] = tag if tag
      @connection.post(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
    end

    def upload_raw_component(filename:, directory:, repository: nil, tag: nil)
      repository ||= @team_config.raw_repository
      parameters = {
        'raw.directory' => directory,
        'raw.asset1' => File.open(filename, 'r'),
        'raw.asset1.filename' => filename.split('/').last,
      }
      parameters['raw.tag'] = tag if tag
      @connection.post(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
    end

    def upload_rubygems_component(filename:, repository: nil, tag: nil)
      repository ||= @team_config.rubygems_repository
      parameters = {
        'rubygems.asset' => File.open(filename, 'r'),
      }
      parameters['rubygems.tag'] = tag if tag
      @connection.post(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
    end

    def upload_yum_component(filename:, directory:, repository: nil, tag: nil)
      repository ||= @team_config.yum_repository
      parameters = {
        'yum.directory' => directory,
        'yum.asset' => File.open(filename, 'r'),
        'yum.asset.filename' => filename.split('/').last,
      }
      parameters['yum.tag'] = tag if tag
      @connection.post(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
    end

    # GET /service/rest/v1/components/{id}
    def list_component(id:)
      @connection.get_response(endpoint: "components/#{id}")
    end

    # DELETE /service/rest/v1/components/{id}


    # ---FORMATS---
    # GET /service/rest/v1/formats/{format}/upload-specs
    # GET /service/rest/v1/formats/upload-specs


    # ---LIFECYCLE---
    # PUT /service/rest/v1/lifecycle/bounce
    # GET /service/rest/v1/lifecycle/phase
    # PUT /service/rest/v1/lifecycle/phase


    # ---MAINTENANCE---
    # PUT /service/rest/v1/maintenance/{databaseName}/check
    # PUT /service/rest/v1/maintenance/{databaseName}/reinstall
    # PUT /service/rest/v1/maintenance/{databaseName}/repair
    # GET /service/rest/v1/maintenance/{databaseName}/role
    # PUT /service/rest/v1/maintenance/{databaseName}/role
    # GET /service/rest/v1/maintenance/{databaseName}/status
    # PUT /service/rest/v1/maintenance/{databaseName}/status


    # ---NODES---
    # GET /service/rest/v1/nodes
    # PUT /service/rest/v1/nodes
    # GET /service/rest/v1/nodes/supportzipdownload
    # POST /service/rest/v1/nodes/supportzips

    
    # ---READ-ONLY---
    # GET /service/rest/v1/read-only
    # POST /service/rest/v1/read-only/force-release
    # POST /service/rest/v1/read-only/freeze
    # POST /service/rest/v1/read-only/release


    # ---REPOSITORIES--- (This endpoint does not paginate)
    # GET /service/rest/v1/repositories
    def list_repositories
      @connection.get_response(endpoint: 'repositories')
    end

    def list_repository_names
      list_repositories.map { |repo| repo['name'] }
    end


    # ---ROUTING-RULES--- 
    # GET /service/rest/v1/beta/routing-rules
    # POST /service/rest/v1/beta/routing-rules
    # GET /service/rest/v1/beta/routing-rules/{name}
    # PUT /service/rest/v1/beta/routing-rules/{name}
    # DELETE /service/rest/v1/beta/routing-rules/{name}


    # ---SCRIPT---
    # GET /service/rest/v1/script
    def list_scripts
      @connection.get_response(endpoint: "script")
    end

    # POST /service/rest/v1/script
    def upload_script(filename:)
      file = File.read(filename)
      @connection.post(endpoint: "script", parameters: file)
    end

    # GET /service/rest/v1/script/{name}
    # PUT /service/rest/v1/script/{name}
    # DELETE /service/rest/v1/script/{name}
    def delete_script(name:)
      @connection.delete(endpoint: "script/#{name}")
    end

    # POST /service/rest/v1/script/{name}/run
    def run_script(name:)
      @connection.post(endpoint: "script/#{name}/run", headers: {'Content-Type' => 'text/plain'})
    end


    # ---SEARCH---
    # GET /service/rest/v1/search

    # GET /service/rest/v1/search/assets
    def search_asset(name:, format: nil, repository: nil, sha1: nil, version: nil, paginate: false)
      repository ||= @team_config.search_repository
      endpoint = "search/assets?q=#{name}"
      endpoint += "&format=#{format}" unless format.nil?
      endpoint += "&repository=#{repository}" unless repository.nil?
      endpoint += "&sha1=#{sha1}" unless sha1.nil?
      endpoint += "&version=#{version}" unless version.nil?
      @connection.get_response(endpoint: endpoint, paginate: paginate)
    end

    # GET /service/rest/v1/search/assets/download


    # ---SECURITY MANAGEMENT---
    # GET /service/rest/v1/beta/security/user-sources


    # ---SECURITY MANAGEMENT: USER TOKENS---
    # DELETE /service/rest/v1/beta/security/user-tokens


    # ---SECURITY MANAGEMENT: USERS---
    # GET /service/rest/v1/beta/security/users
    # POST /service/rest/v1/beta/security/users
    # PUT /service/rest/v1/beta/security/users/{userId}
    # DELETE /service/rest/v1/beta/security/users/{userId}
    # PUT /service/rest/v1/beta/security/users/{userId}/change-password
    # DELETE /service/rest/v1/beta/security/users/{userId}/user-token


    # ---STAGING---
    # POST /service/rest/v1/staging/delete
    # POST /service/rest/v1/staging/move/{destination}


    # ---STATUS---
    # GET /service/rest/v1/status
    def status
      @connection.get(endpoint: 'status')
    end

    # GET /service/rest/v1/status/writable
    def status_writable
      @connection.get(endpoint: 'status/writable')
    end


    # ---SUPPORT---
    # POST /service/rest/v1/support/supportzip


    # ---TAGS---
    # GET /service/rest/v1/tags
    def list_tags(paginate: false)
      @connection.get_response(endpoint: 'tags', paginate: paginate)
    end

    # POST /service/rest/v1/tags
    def create_tag(name:)
      parameters = JSON.dump({
        'name' => name,
      })
      @connection.post(endpoint: 'tags', parameters: parameters)
    end
    
    # GET /service/rest/v1/tags/{name}
    # PUT /service/rest/v1/tags/{name}
    # DELETE /service/rest/v1/tags/{name}
    def delete_tag(name:)
      @connection.delete(endpoint: "tags/#{name}")
    end

    # POST /service/rest/v1/tags/associate/{tagName}
    def associate_tag(name:, sha1:, repository: nil)
      repository ||= @team_config.tag_repository
      search_query = 
        "?"\
        "wait=true&"\
        "repository=#{repository}&"\
        "sha1=#{sha1}"
      @connection.post(endpoint: "tags/associate/#{name}" + search_query)
    end

    # DELETE /service/rest/v1/tags/associate/{tagName}
    def delete_associated_tag(name:, sha1:, repository: nil)
      repository ||= @team_config.tag_repository
      search_query =
        "?"\
        "repository=#{repository}&"\
        "sha1=#{sha1}"
      @connection.delete(endpoint: "tags/associate/#{name}" + search_query)
    end


    # ---TASKS---
    # GET /service/rest/v1/tasks
    # GET /service/rest/v1/tasks/{id}
    # POST /service/rest/v1/tasks/{id}/run
    # POST /service/rest/v1/tasks/{id}/stop


    # ---CUSTOM FUNCTIONS---
    def get_asset_size(asset_url:)
      @connection.content_length(asset_url: asset_url)
    end

    def docker_ready?
      if @docker.nil?
        raise 'Docker push and pull endpoints not initialized!'
        return false
      end
      true
    end

    def download_docker_component(image:, tag:)
      @docker.download(image_name: image, tag: tag) if docker_ready?
    end

    def upload_docker_component(image:, tag:)
      @docker.upload(image_name: image, tag: tag) if docker_ready?
    end

    def local_docker_image_exists?(image:, tag:)
      @docker.exists?(image_name: image, tag: tag) if docker_ready?
    end

    def delete_local_docker_image(image:, tag:)
      @docker.delete(image_name: image, tag: tag) if docker_ready?
    end

    def download(id:, name: nil)
      asset = list_asset(id: id)
      return false if asset == '' || asset.empty?
      return false if asset["downloadUrl"].nil?
      url = asset["downloadUrl"]
      response = @connection.download(url: url)
      if name
        File.write(name, response.body)
      else
        File.write(url.split('/').last, response.body)
      end
      true
    end

    def paginate?
      @connection.paginate?
    end
  end
end
