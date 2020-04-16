require 'endpoints'
require 'nexus_api/version'
require 'nexus_api/docker_shell'
require 'nexus_api/docker_manager'
require 'nexus_api/nexus_connection'
require 'nexus_api/config_manager'
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
