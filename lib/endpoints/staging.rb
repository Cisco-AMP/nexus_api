module NexusAPI
  class API
    # POST /service/rest/v1/staging/delete
    # POST /service/rest/v1/staging/move/{destination}
    def move_assets_to(destination:, tag:)
      @connection.post(endpoint: "staging/move/#{destination}?tag=#{tag}")
    end
  end
end
