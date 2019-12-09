module NexusAPI
  class Script < ::Thor
    attr_accessor :api

    include NexusAPI::CLIUtils

    desc 'delete', 'Delete the specified script from Nexus'
    option :name, :aliases => '-n', :desc => 'Name of script to delete', :required => true
    def delete
      setup
      @api.delete_script(name: options[:name])
    end

    # `run` is a reserved keyword in Thor, so we're using execute here instead
    desc 'execute', 'Run the specified script in Nexus'
    option :name, :aliases => '-n', :desc => 'Name of script to execute', :required => true
    def execute
      setup
      @api.run_script(name: options[:name])
    end

    desc 'list', 'Prints out a list of all scripts'
    option :full, :aliases => '-f', :desc => 'Print full JSON output'
    def list
      print_set(action: :list_scripts, filter: 'name')
    end

    desc 'upload', 'Upload the specified script to Nexus'
    option :filename, :aliases => '-f', :desc => 'Path of file', :required => true
    def upload
      setup
      options[:repository] = 'scripts'
      if_file_exists? do
        @api.upload_script(filename: options[:filename])
      end
    end
  end
end
