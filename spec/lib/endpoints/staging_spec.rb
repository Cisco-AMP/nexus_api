require 'lib/setup_api'

RSpec.describe NexusAPI do
  let(:destination) { 'destination' }
  let(:tag) { 'tag' }

  describe 'Staging Endpoint' do
    include_context 'setup NexusAPI::API'

    describe '#move_components_to' do
      it 'send a post to v1/staging/move with a destination and tag' do
        url = "#{BASE_URL}/v1/staging/move/#{destination}?tag=#{tag}"
        stub_request(:post, url)
          .with(headers: { 'Content-Type'=>'application/json' })
        api.move_components_to(destination: 'destination', tag: tag)
        expect(a_request(:post, url)).to have_been_made
      end
    end
  end
end
