module NexusAPI
  class API
    # GET /service/rest/beta/security/privileges
    def list_privileges
      @connection.get_response(endpoint: 'security/privileges', api_version: 'beta')
    end

    # GET /service/rest/beta/security/privileges/{privilegeId}
    # DELETE /service/rest/beta/security/privileges/{privilegeId}
    # POST /service/rest/beta/security/privileges/application
    # PUT /service/rest/beta/security/privileges/application/{privilegeId}
    # POST /service/rest/beta/security/privileges/repository-admin
    # PUT /service/rest/beta/security/privileges/repository-admin/{privilegeId}
    # POST /service/rest/beta/security/privileges/repository-content-selector
    # PUT /service/rest/beta/security/privileges/repository-content-selector/{privilegeId}
    # POST /service/rest/beta/security/privileges/repository-view
    # PUT /service/rest/beta/security/privileges/repository-view/{privilegeId}
    # POST /service/rest/beta/security/privileges/script
    # PUT /service/rest/beta/security/privileges/script/{privilegeId}
    # POST /service/rest/beta/security/privileges/wildcard
    # PUT /service/rest/beta/security/privileges/wildcard/{privilegeId}
  end
end
