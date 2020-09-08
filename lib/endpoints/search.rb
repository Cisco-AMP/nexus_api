module NexusAPI
  class API
    # GET /service/rest/v1/search

    # GET /service/rest/v1/search/assets
    def search_asset(name:, format: nil, repository: nil, sha1: nil, version: nil, paginate: false)
      repository ||= @team_config.search_repository
      endpoint = "search/assets?q=#{name}"
      endpoint += "&format=#{format}" unless format.nil?
      endpoint += "&repository=#{repository}" unless repository.nil?
      endpoint += "&sha1=#{sha1}" unless sha1.nil?
      endpoint += "&version=#{version}" unless version.nil?
      @connection.get_response(endpoint: endpoint, paginate: paginate)
    end

    def search_all_assets(name:, format: nil, repository: nil, sha1: nil, version: nil)
      Array.new.tap do |results|
        loop do
          results.concat(
            search_asset(
              name: name,
              format: format,
              repository: repository,
              sha1: sha1,
              version: version,
              paginate: true
            ))
          break unless paginate?
        end
      end
    end

    # GET /service/rest/v1/search/assets/download
  end
end
