module NexusAPI
  class API
    # GET /service/rest/beta/security/roles
    def list_roles
      @connection.get_response(endpoint: 'security/roles', api_version: 'beta')
    end

    # POST /service/rest/beta/security/roles
    def create_role(id:, name:, description: nil, privileges: [], roles: [])
      parameters = {
        'id' => id,
        'name' => name,
        'description' => description,
        'privileges' => privileges,
        'roles' => roles
      }
      @connection.post(endpoint: 'security/roles', parameters: parameters, api_version: 'beta')
    end

    # GET /service/rest/beta/security/roles/{id}
    def list_role(id:)
      @connection.get_response(endpoint: "security/roles/#{id}?source=default", api_version: 'beta')
    end

    # PUT /service/rest/beta/security/roles/{id}
    # DELETE /service/rest/beta/security/roles/{id}
    def delete_role(id:)
      @connection.delete(endpoint: "security/roles/#{id}", api_version: 'beta')
    end
  end
end
