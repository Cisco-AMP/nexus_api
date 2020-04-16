module NexusAPI
  class API
    # GET /service/rest/v1/status
    def status
      @connection.get(endpoint: 'status')
    end

    # GET /service/rest/v1/status/check

    # GET /service/rest/v1/status/writable
    def status_writable
      @connection.get(endpoint: 'status/writable')
    end
  end
end
