module NexusAPI
  class API
    # GET /service/rest/beta/security/users
    def list_users
      @connection.get_response(endpoint: 'security/users', api_version: 'beta')
    end

    # POST /service/rest/beta/security/users
    # PUT /service/rest/beta/security/users/{userId}
    # DELETE /service/rest/beta/security/users/{userId}
    # PUT /service/rest/beta/security/users/{userId}/change-password
    # DELETE /service/rest/beta/security/users/{userId}/user-token
  end
end
