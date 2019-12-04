require 'yaml'

module NexusAPI
  class ConfigManager
    def initialize(config_path:)
      if File.exist?(config_path)
        @config = YAML.safe_load(File.read(config_path)) || {}
      else
        raise "ERROR: Specified config '#{config_path}' does not exist."
      end
    end

    def assets_repository
      @config['assets']
    end

    def components_repository
      @config['components']
    end

    def search_repository
      @config['search']
    end

    def tag_repository
      @config['tag']
    end

    def maven_repository
      @config['maven']
    end

    def npm_repository
      @config['npm']
    end

    def pypi_repository
      @config['pypi']
    end

    def raw_repository
      @config['raw']
    end

    def rubygems_repository
      @config['rubygems']
    end

    def yum_repository
      @config['yum']
    end
  end
end