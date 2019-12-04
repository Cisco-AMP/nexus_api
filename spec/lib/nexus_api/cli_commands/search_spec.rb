require 'nexus_api/cli_utils'
require 'nexus_api/cli_commands/search'
require 'lib/nexus_api/mock_cli_utils'

RSpec.describe NexusAPI::Search do
  before(:each) {
    @search = NexusAPI::Search.new
    @search.api = double
  }

  describe '#asset' do
    before(:each) do
      allow(@search.api).to receive(:paginate?).and_return(false)
      @search_results = [{ "path" => 'search_name' }]
    end

    it 'passes the flags set in Thor correctly to api' do
      name       = 'search_name'
      format     = 'search_format'
      repository = 'search_repo'
      sha1       = 'search_sha'
      version    = 'search_version'

      expect(@search.api).to receive(:search_asset).with(
        {
          :name       => name,
          :format     => format,
          :repository => repository,
          :sha1       => sha1,
          :version    => version,
          :paginate   => true,
        }
      ).and_return(@search_results)

      flags = {
        :name       => name,
        :type       => format,
        :repository => repository,
        :sha1       => sha1,
        :version    => version,
      }
      @search.options = flags
      @search.asset
    end

    it 'outputs only the asset names by default' do
      expect(@search.api).to receive(:search_asset).and_return(@search_results)
      flags = {
        :name => 'search_name',
      }
      @search.options = flags
      expect { @search.asset }.to output("search_name\n").to_stdout
    end

    it 'outputs full JSON content when the full flag is set' do
      expect(@search.api).to receive(:search_asset).and_return(@search_results)
      flags = {
        :name => 'search_name',
        :full => true,
      }
      @search.options = flags
      expect { @search.asset }.to output("{\"path\"=>\"search_name\"}\n").to_stdout
    end
  end
end
