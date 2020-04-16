module NexusAPI
  class API
    # GET /service/rest/v1/tags
    def list_tags(paginate: false)
      @connection.get_response(endpoint: 'tags', paginate: paginate)
    end

    # POST /service/rest/v1/tags
    def create_tag(name:)
      parameters = JSON.dump({
        'name' => name,
      })
      @connection.post(endpoint: 'tags', parameters: parameters)
    end

    # GET /service/rest/v1/tags/{name}
    # PUT /service/rest/v1/tags/{name}
    # DELETE /service/rest/v1/tags/{name}
    def delete_tag(name:)
      @connection.delete(endpoint: "tags/#{name}")
    end

    # POST /service/rest/v1/tags/associate/{tagName}
    def associate_tag(name:, sha1:, repository: nil)
      repository ||= @team_config.tag_repository
      search_query =
        "?"\
        "wait=true&"\
        "repository=#{repository}&"\
        "sha1=#{sha1}"
      @connection.post(endpoint: "tags/associate/#{name}" + search_query)
    end

    # DELETE /service/rest/v1/tags/associate/{tagName}
    def delete_associated_tag(name:, sha1:, repository: nil)
      repository ||= @team_config.tag_repository
      search_query =
        "?"\
        "repository=#{repository}&"\
        "sha1=#{sha1}"
      @connection.delete(endpoint: "tags/associate/#{name}" + search_query)
    end
  end
end
