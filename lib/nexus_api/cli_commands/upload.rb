module NexusAPI
  class Upload < ::Thor
    attr_accessor :api

    include NexusAPI::CLIUtils

    desc 'docker', 'Upload a docker image'
    option :image,      :aliases => '-i', :desc => 'Docker image to upload', :required => true
    option :docker_tag, :aliases => '-t', :desc => 'Docker tag', :required => true
    def docker
      setup
      if_file_exists?(file: options[:image].to_s + ':' + options[:docker_tag].to_s, repository: ENV['DOCKER_PUSH_HOSTNAME']) do
        @api.upload_docker_component(
          image: options[:image],
          tag: options[:docker_tag]
        )
      end
    end

    desc 'maven', 'Upload a maven file'
    option :filename,    :aliases => '-f', :desc => 'Path of file', :required => true
    option :group_id,    :aliases => '-g', :desc => 'Maven groupId for file', :required => true
    option :artifact_id, :aliases => '-a', :desc => 'Maven artifactId for file', :required => true
    option :version,     :aliases => '-v', :desc => 'File version', :required => true
    option :repository,  :aliases => '-r', :desc => 'Repository name to upload file to; Overrides -e/--team-config; Required if -e not provided'
    option :tag,         :aliases => '-t', :desc => 'Tag to add to file (tag MUST already exist!)'
    def maven
      return false unless repository_set?
      set(repository: :maven_repository)
      if_file_exists? do
        @api.upload_maven_component(
          filename: options[:filename],
          group_id: options[:group_id],
          artifact_id: options[:artifact_id],
          version: options[:version],
          repository: options[:repository],
          tag: options[:tag],
        )
      end
    end

    desc 'npm', 'Upload a npm file'
    option :filename,   :aliases => '-f', :desc => 'Path of file', :required => true
    option :repository, :aliases => '-r', :desc => 'Repository name to upload file to; Overrides -e/--team-config; Required if -e not provided'
    option :tag,        :aliases => '-t', :desc => 'Tag to add to file (tag MUST already exist!)'
    def npm
      return false unless repository_set?
      set(repository: :npm_repository)
      if_file_exists? do
        @api.upload_npm_component(
          filename: options[:filename],
          repository: options[:repository],
          tag: options[:tag],
        )
      end
    end

    desc 'pypi', 'Upload a pypi file'
    option :filename,   :aliases => '-f', :desc => 'Path of file', :required => true
    option :repository, :aliases => '-r', :desc => 'Repository name to upload file to; Overrides -e/--team-config; Required if -e not provided'
    option :tag,        :aliases => '-t', :desc => 'Tag to add to file (tag MUST already exist!)'
    def pypi
      return false unless repository_set?
      set(repository: :pypi_repository)
      if_file_exists? do
        @api.upload_pypi_component(
          filename: options[:filename],
          repository: options[:repository],
          tag: options[:tag],
        )
      end
    end

    desc 'raw', 'Upload a raw file'
    option :filename,   :aliases => '-f', :desc => 'Filename', :required => true
    option :directory,  :aliases => '-d', :desc => 'Path to file', :required => true
    option :repository, :aliases => '-r', :desc => 'Repository name to upload file to; Overrides -e/--team-config; Required if -e not provided'
    option :tag,        :aliases => '-t', :desc => 'Tag to add to file (tag MUST already exist!)'
    def raw
      return false unless repository_set?
      set(repository: :raw_repository)
      if_file_exists? do
        @api.upload_raw_component(
          filename: options[:filename],
          directory: options[:directory],
          repository: options[:repository],
          tag: options[:tag],
        )
      end
    end

    desc 'rubygems', 'Upload a rubygems file'
    option :filename,   :aliases => '-f', :desc => 'Path of file', :required => true
    option :repository, :aliases => '-r', :desc => 'Repository name to upload file to; Overrides -e/--team-config; Required if -e not provided'
    option :tag,        :aliases => '-t', :desc => 'Tag to add to file (tag MUST already exist!)'
    def rubygems
      return false unless repository_set?
      set(repository: :rubygems_repository)
      if_file_exists? do
        @api.upload_rubygems_component(
          filename: options[:filename],
          repository: options[:repository],
          tag: options[:tag],
        )
      end
    end

    desc 'yum', 'Upload a yum file'
    option :filename,   :aliases => '-f', :desc => 'Filename', :required => true
    option :directory,  :aliases => '-d', :desc => 'Path to file', :required => true
    option :repository, :aliases => '-r', :desc => 'Repository name to upload file to; Overrides -e/--team-config; Required if -e not provided'
    option :tag,        :aliases => '-t', :desc => 'Tag to add to file (tag MUST already exist!)'
    def yum
      return false unless repository_set?
      set(repository: :yum_repository)
      if_file_exists? do
        @api.upload_yum_component(
          filename: options[:filename],
          directory: options[:directory],
          repository: options[:repository],
          tag: options[:tag],
        )
      end
    end
  end
end
