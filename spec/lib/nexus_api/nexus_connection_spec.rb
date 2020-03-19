require 'nexus_api/nexus_connection'

RSpec.describe NexusAPI::NexusConnection do
  let(:endpoint) { 'endpoint' }
  let(:raw_endpoint) { "!#3?/9.9.9-${val}.%^P&*" }
  let(:escaped_endpoint) { URI.escape(raw_endpoint) }
  let(:custom_header) { {'header' => 'value'} }

  let(:connection) do
    NexusAPI::NexusConnection.new(
      username: 'username',
      password: 'password',
      hostname: 'hostname',
    )
  end

  describe '#get_response' do
    it 'sends :send_get with the specified endpoint' do
      expect(connection).to receive(:send_get).with(endpoint, boolean, instance_of(Hash)).and_return(nil)
      connection.get_response(endpoint: endpoint)
    end

    it 'does not use pagination by default' do
      expect(connection).to receive(:send_get).with(anything, false, any_args).and_return(nil)
      connection.get_response(endpoint: endpoint)
    end

    it 'uses pagination when specified' do
      expect(connection).to receive(:send_get).with(anything, true, any_args).and_return(nil)
      connection.get_response(endpoint: endpoint, paginate: true)
    end

    it 'uses JSON as a content type by default' do
      expect(connection).to receive(:send_get).with(anything, boolean, {'Content-Type' => 'application/json'}).and_return(nil)
      connection.get_response(endpoint: endpoint)
    end

    it 'uses headers when specified' do
      expect(connection).to receive(:send_get).with(anything, boolean, custom_header).and_return(nil)
      connection.get_response(endpoint: endpoint, headers: custom_header)
    end

    it 'returns an empty hash when the response is nil' do
      expect(connection).to receive(:send_get).and_return(nil)
      expect(connection.get_response(endpoint: endpoint)).to eq(Hash.new)
    end

    it 'returns a jsonized response' do
      body = 'body'
      expect(connection).to receive(:send_get).and_return(double)
      expect(connection).to receive(:jsonize).and_return(body)
      expect(connection.get_response(endpoint: endpoint)).to eq(body)
    end

    it 'safely escapes special characters in the URL' do
      arguments = nil
      expect(RestClient::Request).to receive(:execute) do |args|
        arguments = args
      end.and_return(nil)
      connection.get_response(endpoint: raw_endpoint)
      expect(arguments[:url]).to include(escaped_endpoint)
    end
  end

  describe '#get' do
    it 'sends :send_get with the specified endpoint' do
      expect(connection).to receive(:send_get).with(endpoint, boolean, instance_of(Hash))
      connection.get(endpoint: endpoint)
    end

    it 'does not use pagination by default' do
      expect(connection).to receive(:send_get).with(anything, false, any_args)
      connection.get(endpoint: endpoint)
    end

    it 'uses pagination when specified' do
      expect(connection).to receive(:send_get).with(anything, true, any_args)
      connection.get(endpoint: endpoint, paginate: true)
    end

    it 'uses JSON as a content type by default' do
      expect(connection).to receive(:send_get).with(anything, boolean, {'Content-Type' => 'application/json'})
      connection.get(endpoint: endpoint)
    end

    it 'uses headers when specified' do
      expect(connection).to receive(:send_get).with(anything, boolean, custom_header)
      connection.get(endpoint: endpoint, headers: custom_header)
    end

    it 'safely escapes special characters in the URL' do
      arguments = nil
      expect(RestClient::Request).to receive(:execute) do |args|
        arguments = args
      end.and_return(nil)
      connection.get(endpoint: raw_endpoint)
      expect(arguments[:url]).to include(escaped_endpoint)
    end
  end

  describe '#post' do
    it 'sends :send_request with post to the specified endpoint' do
      expect(connection).to receive(:send_request).with(:post, endpoint, parameters: anything, headers: anything)
      connection.post(endpoint: endpoint)
    end

    it 'uses a blank parameter by default' do
      expect(connection).to receive(:send_request).with(anything, anything, parameters: '', headers: anything)
      connection.post(endpoint: endpoint)
    end

    it 'uses the specified parameter list' do
      parameters = 'test_parameter'
      expect(connection).to receive(:send_request).with(anything, anything, parameters: parameters, headers: anything)
      connection.post(endpoint: endpoint, parameters: parameters)
    end

    it 'uses JSON as a content type by default' do
      expect(connection).to receive(:send_request).with(anything, anything, parameters: anything, headers: {'Content-Type' => 'application/json'})
      connection.post(endpoint: endpoint)
    end

    it 'uses headers when specified' do
      expect(connection).to receive(:send_request).with(anything, anything, parameters: anything, headers: custom_header)
      connection.post(endpoint: endpoint, headers: custom_header)
    end

    it 'safely escapes special characters in the URL' do
      arguments = nil
      expect(RestClient::Request).to receive(:execute) do |args|
        arguments = args
      end.and_return(nil)
      connection.post(endpoint: raw_endpoint)
      expect(arguments[:url]).to include(escaped_endpoint)
    end
  end

  describe '#put' do
    it 'sends :send_request with put to the specified endpoint' do
      expect(connection).to receive(:send_request).with(:put, endpoint, parameters: anything, headers: anything)
      connection.put(endpoint: endpoint)
    end

    it 'uses a blank parameter by default' do
      expect(connection).to receive(:send_request).with(anything, anything, parameters: '', headers: anything)
      connection.put(endpoint: endpoint)
    end

    it 'uses the specified parameter list' do
      parameters = 'test_parameter'
      expect(connection).to receive(:send_request).with(anything, anything, parameters: parameters, headers: anything)
      connection.put(endpoint: endpoint, parameters: parameters)
    end

    it 'uses JSON as a content type by default' do
      expect(connection).to receive(:send_request).with(anything, anything, parameters: anything, headers: {'Content-Type' => 'application/json'})
      connection.put(endpoint: endpoint)
    end

    it 'uses headers when specified' do
      expect(connection).to receive(:send_request).with(anything, anything, parameters: anything, headers: custom_header)
      connection.put(endpoint: endpoint, headers: custom_header)
    end

    it 'safely escapes special characters in the URL' do
      arguments = nil
      expect(RestClient::Request).to receive(:execute) do |args|
        arguments = args
      end.and_return(nil)
      connection.put(endpoint: raw_endpoint)
      expect(arguments[:url]).to include(escaped_endpoint)
    end
  end

  describe '#delete' do
    it 'sends :send_request with delete to the specified endpoint' do
      expect(connection).to receive(:send_request).with(:delete, endpoint, headers: anything)
      connection.delete(endpoint: endpoint)
    end

    it 'uses JSON as a content type by default' do
      expect(connection).to receive(:send_request).with(anything, anything, headers: {'Content-Type' => 'application/json'})
      connection.delete(endpoint: endpoint)
    end

    it 'uses headers when specified' do
      expect(connection).to receive(:send_request).with(anything, anything, headers: custom_header)
      connection.delete(endpoint: endpoint, headers: custom_header)
    end

    it 'safely escapes special characters in the URL' do
      arguments = nil
      expect(RestClient::Request).to receive(:execute) do |args|
        arguments = args
      end.and_return(nil)
      connection.delete(endpoint: raw_endpoint)
      expect(arguments[:url]).to include(escaped_endpoint)
    end
  end

  describe '#head' do
    it 'sends :head with asset url to RestClient' do
      expect(RestClient).to receive(:head).with(endpoint)
      connection.head(asset_url: endpoint)
    end

    it 'safely escapes special characters in the URL' do
      expect(RestClient).to receive(:head).with(escaped_endpoint)
      connection.head(asset_url: raw_endpoint)
    end
  end

  describe '#content_length' do
    it 'sends :head with an asset url to an instance of Nexus Connection' do
      expect(connection).to receive(:head).with(asset_url: endpoint)
      connection.content_length(asset_url: endpoint)
    end

    it 'returns -1 when response does not have headers' do
      expect(connection).to receive(:head).and_return(nil)
      expect(connection.content_length(asset_url: endpoint)).to eq(-1)
    end

    it 'returns content length header' do
      content_length = 9001
      response = double
      expect(response).to receive(:headers).and_return({content_length: content_length})
      expect(connection).to receive(:head).and_return(response)
      expect(connection.content_length(asset_url: endpoint)).to eq(content_length)
    end
  end

  describe '#download' do
    it 'sends :get with url and authorization header to RestClient' do
      expect(RestClient).to receive(:get).with(endpoint, instance_of(Hash))
      connection.download(url: endpoint)
    end

    it 'safely escapes special characters in the URL' do
      expect(RestClient).to receive(:get).with(escaped_endpoint, instance_of(Hash))
      connection.download(url: raw_endpoint)
    end
  end

  describe '#paginate?' do
    it 'returns false when continuation token is not set' do
      connection.continuation_token = nil
      expect(connection.paginate?).to be false
    end

    it 'returns true when continuation token is set' do
      connection.continuation_token = 'not_nil'
      expect(connection.paginate?).to be true
    end
  end
end
