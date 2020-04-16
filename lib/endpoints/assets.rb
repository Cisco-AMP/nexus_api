module NexusAPI
  class API
    # GET /service/rest/v1/assets
    def list_assets(repository: nil, paginate: false)
      repository ||= @team_config.assets_repository
      @connection.get_response(endpoint: "assets?repository=#{repository}", paginate: paginate)
    end

    # GET /service/rest/v1/assets/{id}
    def list_asset(id:)
      @connection.get_response(endpoint: "assets/#{id}")
    end

    # DELETE /service/rest/v1/assets/{id}
  end
end
