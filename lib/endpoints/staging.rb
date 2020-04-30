module NexusAPI
  class API
    # POST /service/rest/v1/staging/delete
    # POST /service/rest/v1/staging/move/{destination}
    def move_components_to(destination:, tag:, source: nil, keyword: nil)
      endpoint = "staging/move/#{destination}?tag=#{tag}"
      endpoint += "&repository=#{source}" unless source.nil?
      endpoint += "&q=#{keyword}" unless keyword.nil?
      @connection.post(endpoint: endpoint)
    end
  end
end
