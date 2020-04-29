module NexusAPI
  class Tag < ::Thor
    attr_accessor :api

    include NexusAPI::CLIUtils

    desc 'add', 'Adds an existing tag to an asset'
    option :name,       :aliases => '-n', :desc => 'Tag name', :required => true
    option :sha1,       :aliases => '-s', :desc => 'SHA1 of asset', :required => true
    option :repository, :aliases => '-r', :desc => 'Repository containing asset; Overrides -e/--team-config; Required if -e not provided'
    def add
      return false unless repository_set?
      setup
      @api.associate_tag(name: options[:name], sha1: options[:sha1], repository: options[:repository])
    end

    desc 'create', 'Creates a new tag in Nexus'
    option :name, :aliases => '-n', :desc => 'Tag name', :required => true
    def create
      setup
      @api.create_tag(name: options[:name])
    end

    desc 'delete', 'Deletes a tag from Nexus'
    option :name, :aliases => '-n', :desc => 'Tag name', :required => true
    def delete
      setup
      @api.delete_tag(name: options[:name])
    end

    desc 'list', 'Prints out a list of all tags'
    option :full, :aliases => '-f', :desc => 'Print full JSON output'
    def list
      print_paginating_set(action: :list_tags, params: {}, filter: 'name')
    end

    desc 'remove', 'Removes a tag from an asset'
    option :name,       :aliases => '-n', :desc => 'Tag name', :required => true
    option :sha1,       :aliases => '-s', :desc => 'SHA1 of asset', :required => true
    option :repository, :aliases => '-r', :desc => 'Repository containing asset; Overrides -e/--team-config; Required if -e not provided'
    def remove
      return false unless repository_set?
      setup
      @api.delete_associated_tag(name: options[:name], sha1: options[:sha1], repository: options[:repository])
    end
  end
end
