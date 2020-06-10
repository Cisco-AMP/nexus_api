module NexusAPI
  class API
    # GET /service/rest/beta/security/users
    def list_users
      @connection.get_response(endpoint: 'security/users', api_version: 'beta')
    end

    # POST /service/rest/beta/security/users
    def create_user(user_id:, first_name:, last_name:, email:, password:, roles:)
      parameters = {
        'userId' => user_id,
        'firstName' => first_name,
        'lastName' => last_name,
        'emailAddress' => email,
        'password' => password,
        'status' => 'active',
        'roles' => roles,
      }
      @connection.post(endpoint: 'security/users', parameters: parameters, api_version: 'beta')
    end

    # PUT /service/rest/beta/security/users/{userId}
    # DELETE /service/rest/beta/security/users/{userId}
    def delete_user(user_id:)
      @connection.delete(endpoint: "security/users/#{user_id}", api_version: 'beta')
    end

    # PUT /service/rest/beta/security/users/{userId}/change-password
    # DELETE /service/rest/beta/security/users/{userId}/user-token
  end
end
