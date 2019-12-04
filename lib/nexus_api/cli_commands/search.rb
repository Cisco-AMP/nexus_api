module NexusAPI
  class Search < ::Thor
    attr_accessor :api

    include NexusAPI::CLIUtils

    desc 'asset', 'Print names of any assets that match the search'
    option :name,       :aliases => '-n', :desc => 'Name of asset to search for', :required => true
    option :type,       :aliases => '-t', :desc => 'Searches assets within all repositories of this type'
    option :repository, :aliases => '-r', :desc => 'Searches assets within this repository'
    option :sha1,       :aliases => '-s', :desc => 'Searches assets for a matching SHA1'
    option :version,    :aliases => '-v', :desc => 'Searches assets for a matching version'
    option :full,       :aliases => '-f', :desc => 'Print full JSON output'
    def asset
      setup
      results = Array.new.tap do |results|
        loop do
          results.concat(
            @api.search_asset(
              name:       options[:name],
              format:     options[:type],
              repository: options[:repository],
              sha1:       options[:sha1],
              version:    options[:version],
              paginate:   true,
            )
          )
          break unless @api.paginate?
        end
      end
      puts options[:full] ? results : results.map { |result| result['path'] }
    end
  end
end
