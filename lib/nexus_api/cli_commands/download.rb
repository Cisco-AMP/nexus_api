module NexusAPI
  class Download < ::Thor
    attr_accessor :api

    include NexusAPI::CLIUtils

    desc 'docker', 'Download a docker image'
    option :image,      :aliases => '-i', :desc => 'Docker image to download', :required => true
    option :docker_tag, :aliases => '-t', :desc => 'Docker tag', :required => true
    def docker
      setup
      @api.download_docker_component(image: options[:image], tag: options[:docker_tag])
    end

    desc 'file', 'Download a file'
    option :nexus_id, :aliases => '-i', :desc => 'Nexus ID of file to download', :required => true
    option :new_name, :aliases => '-n', :desc => 'Rename the file locally after downloading; can also be used to change the path'
    def file
      setup
      @api.download(id: options[:nexus_id], name: options[:new_name])
    end
  end
end
