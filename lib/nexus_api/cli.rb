require 'thor'
require 'nexus_api/cli_utils'
require 'nexus_api/cli_commands/commands'
require 'nexus_api/version'

module NexusAPI
  class CLI < ::Thor
    # WARNING: If any sub-commands use any of the aliases defined here they will not work
    class_option :nexus_config, :aliases => '-c', :default => '.env', :desc => 'Relative path to Nexus config file'
    class_option :team_config, :aliases => '-e', :desc => 'Relative path to team config file'

    desc 'download FORMAT', 'Download a FORMAT type file'
    subcommand 'download', Download

    desc 'list TYPE', 'Print a list of every item in Nexus that matches TYPE'
    subcommand 'list', List

    desc 'move TYPE', 'Move items to new location in Nexus'
    subcommand 'move', Move

    desc 'script COMMAND', 'Manipulate scripts in Nexus'
    subcommand 'script', Script

    desc 'search TYPE', 'Print a list of every TYPE item in Nexus that matches the search'
    subcommand 'search', Search

    desc 'tag COMMAND', 'Manipulate tags in Nexus'
    subcommand 'tag', Tag

    desc 'upload FORMAT', 'Upload a FORMAT type file'
    subcommand 'upload', Upload

    map %w[--version -v] => :version
    desc 'version, --version, -v', 'Prints out current gem version'
    def version
      puts NexusAPI::VERSION
    end

    def self.exit_on_failure?
      true
    end
  end
end
