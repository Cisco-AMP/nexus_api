module NexusAPI
  class API
    # GET /service/rest/beta/security/privileges
    def list_privileges
      @connection.get_response(endpoint: 'security/privileges', api_version: 'beta')
    end

    # GET /service/rest/beta/security/privileges/{privilegeId}
    def list_privilege(privilege_id:)
      @connection.get_response(endpoint: "security/privileges/#{privilege_id}", api_version: 'beta')
    end

    # DELETE /service/rest/beta/security/privileges/{privilegeId}
    def delete_privilege(privilege_id:)
      @connection.delete(endpoint: "security/privileges/#{privilege_id}", api_version: 'beta')
    end

    # POST /service/rest/beta/security/privileges/application
    # PUT /service/rest/beta/security/privileges/application/{privilegeId}
    # POST /service/rest/beta/security/privileges/repository-admin
    # PUT /service/rest/beta/security/privileges/repository-admin/{privilegeId}
    # POST /service/rest/beta/security/privileges/repository-content-selector
    # PUT /service/rest/beta/security/privileges/repository-content-selector/{privilegeId}
    # POST /service/rest/beta/security/privileges/repository-view
    def create_privilege_repository_view(name:, description: nil, actions: ['READ'], format: '*', repository: '*')
      parameters = {
        # The name is also used as the privilege_id
        'name' => name,
        'description' => description,
        # READ, BROWSE, EDIT, ADD, DELETE, RUN, ASSOCIATE, DISASSOCIATE, ALL
        'actions' => actions,
        # The repository format (i.e 'nuget', 'npm') this privilege will grant access to (or * for all)
        'format' => format,
        # The name of the repository this privilege will grant access to (or * for all)
        'repository' => repository
      }
      @connection.post(endpoint: 'security/privileges/repository-view', parameters: parameters, api_version: 'beta')
    end

    # PUT /service/rest/beta/security/privileges/repository-view/{privilegeId}
    # POST /service/rest/beta/security/privileges/script
    # PUT /service/rest/beta/security/privileges/script/{privilegeId}
    # POST /service/rest/beta/security/privileges/wildcard
    # PUT /service/rest/beta/security/privileges/wildcard/{privilegeId}
  end
end
