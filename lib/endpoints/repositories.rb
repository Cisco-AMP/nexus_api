module NexusAPI
  class API
    # GET /service/rest/v1/repositories (This endpoint does not paginate)
    def list_repositories
      @connection.get_response(endpoint: 'repositories')
    end

    def list_repository_names
      list_repositories.map { |repo| repo['name'] }
    end

    # GET /service/rest/beta/repositories
    # DELETE /service/rest/beta/repositories/{repositoryName}
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
    # POST /service/rest/beta/repositories/conan/proxy
    # PUT /service/rest/beta/repositories/conan/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/docker/group
    # PUT /service/rest/beta/repositories/docker/group/{repositoryName}
    # POST /service/rest/beta/repositories/docker/hosted
    # PUT /service/rest/beta/repositories/docker/hosted/{repositoryName}
    # POST /service/rest/beta/repositories/docker/proxy
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
    # POST /service/rest/beta/repositories/maven/hosted
    # PUT /service/rest/beta/repositories/maven/hosted/{repositoryName}
    # POST /service/rest/beta/repositories/maven/proxy
    # PUT /service/rest/beta/repositories/maven/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/npm/group
    # PUT /service/rest/beta/repositories/npm/group/{repositoryName}
    # POST /service/rest/beta/repositories/npm/hosted
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
    # PUT /service/rest/beta/repositories/pypi/hosted/{repositoryName}
    # POST /service/rest/beta/repositories/pypi/proxy
    # PUT /service/rest/beta/repositories/pypi/proxy/{repositoryName}
    # POST /service/rest/beta/repositories/yum/hosted
    # PUT /service/rest/beta/repositories/yum/hosted/{repositoryName}
  end
end
