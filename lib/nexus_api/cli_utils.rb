require 'dotenv'

module NexusAPI
  module CLIUtils
    def setup
      Dotenv.load(options[:nexus_config])
      @api = NexusAPI::API.new(
        username: ENV['NEXUS_USERNAME'],
        password: ENV['NEXUS_PASSWORD'],
        hostname: ENV['NEXUS_HOSTNAME'],
        docker_pull_hostname: ENV['DOCKER_PULL_HOSTNAME'],
        docker_push_hostname: ENV['DOCKER_PUSH_HOSTNAME'],
        team_config: options[:team_config]
      )
    end

    def print_element(action:, params:, filter:)
      setup
      element = @api.send(action, params)
      puts options[:full] ? element : element[filter]
    end

    def print_paginating_set(action:, params:, filter:, proc: nil)
      setup
      set = Array.new.tap do |set|
        loop do
          params[:paginate] = true
          set.concat(Array(@api.send(action, params)))
          break unless @api.paginate?
        end
      end
      proc = proc { set.map{ |element| element[filter] } } if proc.nil?
      puts options[:full] ? set : proc.call(set)
    end

    def print_set(action:, filter:)
      setup
      set = @api.send(action)
      puts options[:full] ? set : set.map{ |element| element[filter] }
    end

    def repository_set?
      if options[:repository].nil? && options[:team_config].nil?
        puts "No value provided for required option '--repository' or '--team_config' (only need 1)"
        return false
      end
      true
    end

    def set(repository:)
      setup
      options[:repository] = @api.team_config.send(repository) if options[:repository].nil?
    end

    def if_file_exists?(file: options[:filename], repository: options[:repository])
      begin
        puts "Sending '#{file}' to the '#{repository}' repository in Nexus!"
        yield
      rescue Errno::ENOENT
        puts "'#{file}' does not exist locally."
      end
    end
  end
end
