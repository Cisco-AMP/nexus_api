module NexusAPI
  class API
    # GET /service/rest/beta/security/roles
    def list_roles
      @connection.get_response(endpoint: 'security/roles', api_version: 'beta')
    end

    # POST /service/rest/beta/security/roles
    # GET /service/rest/beta/security/roles/{id}
    # PUT /service/rest/beta/security/roles/{id}
    # DELETE /service/rest/beta/security/roles/{id}
  end
end
