module NexusAPI
  class API
    # GET /service/rest/v1/components
    def list_components(repository: nil, paginate: false)
      repository ||= @team_config.components_repository
      @connection.get_response(endpoint: "components?repository=#{repository}", paginate: paginate)
    end

    # POST /service/rest/v1/components
    def upload_maven_component(filename:, group_id:, artifact_id:, version:, repository: nil, tag: nil)
      repository ||= @team_config.maven_repository
      parameters = {
        'maven2.groupId' => group_id,
        'maven2.artifactId' => artifact_id,
        'maven2.version' => version,
        'maven2.asset1' => File.open(filename, 'r'),
        'maven2.asset1.extension' => filename.split('.').last,
      }
      parameters['maven2.tag'] = tag if tag
      @connection.post(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
    end

    def upload_npm_component(filename:, repository: nil, tag: nil)
      repository ||= @team_config.npm_repository
      parameters = {
        'npm.asset' => File.open(filename, 'r'),
      }
      parameters['npm.tag'] = tag if tag
      @connection.post(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
    end

    def upload_pypi_component(filename:, repository: nil, tag: nil)
      repository ||= @team_config.pypi_repository
      parameters = {
        'pypi.asset' => File.open(filename, 'r'),
      }
      parameters['pypi.tag'] = tag if tag
      @connection.post(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
    end

    def upload_raw_component(filename:, directory:, repository: nil, tag: nil)
      repository ||= @team_config.raw_repository
      parameters = {
        'raw.directory' => directory,
        'raw.asset1' => File.open(filename, 'r'),
        'raw.asset1.filename' => filename.split('/').last,
      }
      parameters['raw.tag'] = tag if tag
      @connection.post(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
    end

    def upload_rubygems_component(filename:, repository: nil, tag: nil)
      repository ||= @team_config.rubygems_repository
      parameters = {
        'rubygems.asset' => File.open(filename, 'r'),
      }
      parameters['rubygems.tag'] = tag if tag
      @connection.post(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
    end

    def upload_yum_component(filename:, directory:, repository: nil, tag: nil)
      repository ||= @team_config.yum_repository
      parameters = {
        'yum.directory' => directory,
        'yum.asset' => File.open(filename, 'r'),
        'yum.asset.filename' => filename.split('/').last,
      }
      parameters['yum.tag'] = tag if tag
      @connection.post(endpoint: "components?repository=#{repository}", parameters: parameters, headers: {})
    end

    # GET /service/rest/v1/components/{id}
    def list_component(id:)
      @connection.get_response(endpoint: "components/#{id}")
    end

    # DELETE /service/rest/v1/components/{id}
  end
end
