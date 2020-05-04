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
    def associate_tag(name:, sha1: nil, repository: nil, tag: nil)
      repository ||= @team_config.tag_repository
      if sha1.nil? && repository.nil? && tag.nil?
        puts_error(__method__)
        return false
      end

      search_query = "?wait=true"
      search_query += "&sha1=#{sha1}" unless sha1.nil?
      search_query += "&repository=#{repository}" unless repository.nil?
      search_query += "&tag=#{tag}" unless tag.nil?

      @connection.post(endpoint: "tags/associate/#{name}" + search_query)
    end

    # DELETE /service/rest/v1/tags/associate/{tagName}
    def delete_associated_tag(name:, sha1: nil, repository: nil, tag: nil)
      repository ||= @team_config.tag_repository
      parameters = {}
      parameters['sha1'] = sha1 unless sha1.nil?
      parameters['repository'] = repository unless repository.nil?
      parameters['tag'] = tag unless tag.nil?
      if parameters.empty?
        puts_error(__method__)
        return false
      end

      search_query = parameters.map do |parameter, value|
        "#{parameter}=#{value}"
      end.join("&")

      @connection.delete(endpoint: "tags/associate/#{name}?" + search_query)
    end


    private

    def puts_error(method)
      puts "ERROR: NexusAPI::API::#{method}() requires AT LEAST one optional parameter to"
      puts "       be set otherwise ALL assets in Nexus will be tagged. If this is desired"
      puts "       please open an issue or a PR to add a new method to handle this case."
    end
  end
end
