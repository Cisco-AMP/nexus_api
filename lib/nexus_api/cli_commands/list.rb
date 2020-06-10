module NexusAPI
  class List < ::Thor
    attr_accessor :api

    include NexusAPI::CLIUtils
    class_option :full, :aliases => '-f', :desc => 'Print full JSON output'

    desc 'asset', 'Prints out details for an asset that matches the supplied ID'
    option :id, :aliases => '-i', :desc => 'Asset ID to look for', :required => true
    def asset
      print_element(action: :list_asset, params: {id: options[:id]}, filter: 'path')
    end

    desc 'asset_size', 'Prints out the size for an asset using its download URL'
    option :url, :aliases => '-u', :desc => 'Asset URL', :required => true
    def asset_size
      setup
      puts @api.get_asset_size(asset_url: options[:url])
    end

    desc 'assets', 'Prints out a list of all assets in a repository'
    option :repository, :aliases => '-r', :desc => 'Name of repository to list assets from; Overrides -e/--team-config; Required if -e not provided'
    def assets
      return false unless repository_set?
      print_paginating_set(action: :list_assets, params: {repository: options[:repository]}, filter: 'path')
    end

    desc 'component', 'Prints out details for an component that matches the supplied ID'
    option :id, :aliases => '-i', :desc => 'Asset ID to look for', :required => true
    def component
      print_element(action: :list_component, params: {id: options[:id]}, filter: 'name')
    end

    desc 'components', 'Prints out a list of all components in a repository'
    option :assets, :aliases => '-a', :desc => 'List assets for each component'
    option :repository, :aliases => '-r', :desc => 'Name of repository to list components from; Overrides -e/--team-config; Required if -e not provided'
    def components
      return false unless repository_set?
      proc = Proc.new do |components|
        components.map do |component|
          version = component['version'].nil? ? 'version is nil' : component['version']
          line = "#{component['name']} (#{version})\n"
          if options[:assets]
            component['assets'].each do |asset|
              line += "  #{asset['path']}\n"
            end
          end
          line
        end
      end
      print_paginating_set(action: :list_components, params: {repository: options[:repository]}, filter: 'name', proc: proc)
    end

    desc 'privileges', 'Prints out a list of all privileges'
    def privileges
      print_set(action: :list_privileges, filter: 'name')
    end

    desc 'repositories', 'Prints out a list of all repositories'
    def repositories
      print_set(action: :list_repositories, filter: 'name')
    end

    desc 'roles', 'Prints out a list of all roles'
    def roles
      print_set(action: :list_roles, filter: 'name')
    end

    desc 'status', 'Prints out if the Nexus server can respond to read and write requests'
    def status
      setup
      puts "Nexus can respond to read requests:  #{@api.status}"
      puts "Nexus can respond to write requests: #{@api.status_writable}"
    end

    desc 'users', 'Prints out a list of all users'
    def users
      print_set(action: :list_users, filter: 'emailAddress')
    end
  end
end
