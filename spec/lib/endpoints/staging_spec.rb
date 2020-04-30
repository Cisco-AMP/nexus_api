require 'lib/setup_api'

RSpec.describe NexusAPI do
  let(:destination) { 'destination' }
  let(:tag) { 'tag' }
  let(:source) { 'source' }
  let(:keyword) { 'keyword' }

  describe 'Staging Endpoint' do
    include_context 'setup NexusAPI::API'

    describe '#move_components_to' do
      it 'sends a post to v1/staging/move with a destination and tag by default' do
        url = "#{BASE_URL}/v1/staging/move/#{destination}?tag=#{tag}"
        stub_request(:post, url)
          .with(headers: { 'Content-Type'=>'application/json' })
        api.move_components_to(destination: 'destination', tag: tag)
        expect(a_request(:post, url)).to have_been_made
      end

      it 'sends a post to v1/staging/move with a destination, tag, and source' do
        url = "#{BASE_URL}/v1/staging/move/#{destination}?tag=#{tag}&repository=#{source}"
        stub_request(:post, url)
          .with(headers: { 'Content-Type'=>'application/json' })
        api.move_components_to(destination: 'destination', tag: tag, source: source)
        expect(a_request(:post, url)).to have_been_made
      end

      it 'sends a post to v1/staging/move with a destination, tag, and source' do
        url = "#{BASE_URL}/v1/staging/move/#{destination}?tag=#{tag}&q=#{keyword}"
        stub_request(:post, url)
          .with(headers: { 'Content-Type'=>'application/json' })
        api.move_components_to(destination: 'destination', tag: tag, keyword: keyword)
        expect(a_request(:post, url)).to have_been_made
      end

      it 'sends a post to v1/staging/move with a destination, tag, and source' do
        url = "#{BASE_URL}/v1/staging/move/#{destination}?tag=#{tag}&repository=#{source}&q=#{keyword}"
        stub_request(:post, url)
          .with(headers: { 'Content-Type'=>'application/json' })
        api.move_components_to(destination: 'destination', tag: tag, source: source, keyword: keyword)
        expect(a_request(:post, url)).to have_been_made
      end
    end
  end
end
