require 'utilities/parameter_builder'

module NexusAPI
  class API
    # GET /service/rest/v1/repositories (This endpoint does not paginate)
    # GET /service/rest/beta/repositories
    def list_repositories
      @connection.get_response(endpoint: 'repositories', api_version: 'beta')
    end

    def list_repository_names
      list_repositories.map { |repo| repo['name'] }
    end

    # DELETE /service/rest/beta/repositories/{repositoryName}
    def delete_repository(name:)
      @connection.delete(endpoint: "repositories/#{name}", api_version: 'beta')
    end

    # POST /service/rest/beta/repositories/{repositoryName}/health-check
    # DELETE /service/rest/beta/repositories/{repositoryName}/health-check
    # POST /service/rest/beta/repositories/{repositoryName}/invalidate-cache
    # POST /service/rest/beta/repositories/{repositoryName}/rebuild-index
    # POST /service/rest/beta/repositories/apt/hosted
    # PUT /service/rest/beta/repositories/apt/hosted/{repositoryName}
    # POST /service/rest/beta/repositories/apt/proxy
    # PUT /service/rest/beta/repositories/apt/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/bower/group
    # PUT /service/rest/beta/repositories/bower/group/{repositoryName}
    # POST /service/rest/beta/repositories/bower/hosted
    # PUT /service/rest/beta/repositories/bower/hosted/{repositoryName}
    # POST /service/rest/beta/repositories/bower/proxy
    # PUT /service/rest/beta/repositories/bower/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/cocoapods/proxy
    # PUT /service/rest/beta/repositories/cocoapods/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/conan/proxy
    # PUT /service/rest/beta/repositories/conan/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/docker/group
    def create_repository_docker_group(name:, group_members: [], http_port: nil, https_port: nil)
      parameters = ParameterBuilder.docker_group(name, group_members, http_port, https_port)
      create('repositories/docker/group', parameters)
    end

    # PUT /service/rest/beta/repositories/docker/group/{repositoryName}
    # POST /service/rest/beta/repositories/docker/hosted
    def create_repository_docker_hosted(name:, write_policy: ParameterBuilder::ALLOW_ONCE, cleanup_policies: [], http_port: nil, https_port: nil)
      parameters = ParameterBuilder.docker_hosted(name, write_policy, port)
      create('repositories/docker/hosted', parameters)
    end

    # PUT /service/rest/beta/repositories/docker/hosted/{repositoryName}
    # POST /service/rest/beta/repositories/docker/proxy
    def create_repository_docker_proxy(name:, remote_url:, options: {})
      parameters = ParameterBuilder.docker_proxy(name, remote_url, options)
      create('repositories/docker/proxy', parameters)
    end

    # PUT /service/rest/beta/repositories/docker/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/gitlfs/hosted
    # PUT /service/rest/beta/repositories/gitlfs/hosted/{repositoryName}
    # POST /service/rest/beta/repositories/go/group
    # PUT /service/rest/beta/repositories/go/group/{repositoryName}
    # POST /service/rest/beta/repositories/go/proxy
    # PUT /service/rest/beta/repositories/go/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/helm/hosted
    # PUT /service/rest/beta/repositories/helm/hosted/{repositoryName}
    # POST /service/rest/beta/repositories/helm/proxy
    # PUT /service/rest/beta/repositories/helm/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/maven/group
    # PUT /service/rest/beta/repositories/maven/group/{repositoryName}
    # POST /service/rest/beta/repositories/maven/hosted
    def create_repository_maven_hosted(name:)
      parameters = ParameterBuilder.maven_hosted(name)
      create('repositories/maven/hosted', parameters)
    end

    # PUT /service/rest/beta/repositories/maven/hosted/{repositoryName}
    # POST /service/rest/beta/repositories/maven/proxy
    # PUT /service/rest/beta/repositories/maven/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/npm/group
    # PUT /service/rest/beta/repositories/npm/group/{repositoryName}
    # POST /service/rest/beta/repositories/npm/hosted
    def create_repository_npm_hosted(name:)
      parameters = ParameterBuilder.npm_hosted(name)
      create('repositories/npm/hosted', parameters)
    end

    # PUT /service/rest/beta/repositories/npm/hosted/{repositoryName}
    # POST /service/rest/beta/repositories/npm/proxy
    # PUT /service/rest/beta/repositories/npm/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/nuget/group
    # PUT /service/rest/beta/repositories/nuget/group/{repositoryName}
    # POST /service/rest/beta/repositories/nuget/hosted
    # PUT /service/rest/beta/repositories/nuget/hosted/{repositoryName}
    # POST /service/rest/beta/repositories/nuget/proxy
    # PUT /service/rest/beta/repositories/nuget/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/p2/proxy
    # PUT /service/rest/beta/repositories/p2/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/pypi/group
    # PUT /service/rest/beta/repositories/pypi/group/{repositoryName}
    # POST /service/rest/beta/repositories/pypi/hosted
    def create_repository_pypi_hosted(name:)
      parameters = ParameterBuilder.pypi_hosted(name)
      create('repositories/pypi/hosted', parameters)
    end

    # PUT /service/rest/beta/repositories/pypi/hosted/{repositoryName}
    # POST /service/rest/beta/repositories/pypi/proxy
    # PUT /service/rest/beta/repositories/pypi/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/r/group
    # PUT /service/rest/beta/repositories/r/group/{repositoryName}
    # POST /service/rest/beta/repositories/r/hosted
    # PUT /service/rest/beta/repositories/r/hosted/{repositoryName}
    # POST /service/rest/beta/repositories/r/proxy
    # PUT /service/rest/beta/repositories/r/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/raw/group
    # PUT /service/rest/beta/repositories/raw/group/{repositoryName}
    # POST /service/rest/beta/repositories/raw/hosted
    def create_repository_raw_hosted(name:)
      parameters = ParameterBuilder.raw_hosted(name)
      create('repositories/raw/hosted', parameters)
    end

    # PUT /service/rest/beta/repositories/raw/hosted/{repositoryName}
    # POST /service/rest/beta/repositories/raw/proxy
    # PUT /service/rest/beta/repositories/raw/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/rubygems/group
    # PUT /service/rest/beta/repositories/rubygems/group/{repositoryName}
    # POST /service/rest/beta/repositories/rubygems/hosted
    def create_repository_rubygems_hosted(name:)
      parameters = ParameterBuilder.rubygems_hosted(name)
      create('repositories/rubygems/hosted', parameters)
    end

    # PUT /service/rest/beta/repositories/rubygems/hosted/{repositoryName}
    # POST /service/rest/beta/repositories/rubygems/proxy
    # PUT /service/rest/beta/repositories/rubygems/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/yum/group
    # PUT /service/rest/beta/repositories/yum/group/{repositoryName}
    # POST /service/rest/beta/repositories/yum/hosted
    def create_repository_yum_hosted(name:, depth:)
      parameters = ParameterBuilder.yum_hosted(name, depth)
      create('repositories/yum/hosted', parameters)
    end

    # PUT /service/rest/beta/repositories/yum/hosted/{repositoryName}
    # POST /service/rest/beta/repositories/yum/proxy
    # PUT /service/rest/beta/repositories/yum/proxy/{repositoryName}

    private

    def create(endpoint, parameters)
      @connection.post(
        endpoint: endpoint,
        parameters: parameters,
        api_version: 'beta'
      )
    end
  end
end
