module NexusAPI
  class API
    # GET /service/rest/v1/assets
    def list_assets(repository: nil, paginate: false)
      repository ||= @team_config.assets_repository
      @connection.get_response(endpoint: "assets?repository=#{repository}", paginate: paginate)
    end

    def list_all_assets(repository: nil)
      assets = Array.new.tap do |assets|
        loop do
          assets.concat(list_assets(repository: repository, paginate: true))
          break unless paginate?
        end
      end
    end

    # GET /service/rest/v1/assets/{id}
    def list_asset(id:)
      @connection.get_response(endpoint: "assets/#{id}")
    end

    # DELETE /service/rest/v1/assets/{id}
  end
end
