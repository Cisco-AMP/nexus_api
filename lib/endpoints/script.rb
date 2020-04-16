module NexusAPI
  class API
    # GET /service/rest/v1/script
    def list_scripts
      @connection.get_response(endpoint: "script")
    end

    # POST /service/rest/v1/script
    def upload_script(filename:)
      puts_deprecated_notice
      file = File.read(filename)
      @connection.post(endpoint: "script", parameters: file)
    end

    # GET /service/rest/v1/script/{name}
    # PUT /service/rest/v1/script/{name}
    # DELETE /service/rest/v1/script/{name}
    def delete_script(name:)
      @connection.delete(endpoint: "script/#{name}")
    end

    # POST /service/rest/v1/script/{name}/run
    def run_script(name:)
      puts_deprecated_notice
      @connection.post(endpoint: "script/#{name}/run", headers: {'Content-Type' => 'text/plain'})
    end


    private

    def puts_deprecated_notice
      puts 'WARNING: This endpoint has been disabled in Nexus due to a vulnerability'
      puts '         and may not work as intended. An HTTP 410 is an indication of this'
      puts '         See https://issues.sonatype.org/browse/NEXUS-23205 for details'
    end
  end
end
