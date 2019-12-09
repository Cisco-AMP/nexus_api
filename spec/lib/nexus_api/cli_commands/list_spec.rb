require 'nexus_api/cli_utils'
require 'nexus_api/cli_commands/list'
require 'lib/nexus_api/mock_cli_utils'

RSpec.describe NexusAPI::List do
  before(:each) {
    @list = NexusAPI::List.new
    @list.api = double
  }

  describe '#asset' do
    describe 'with mock asset' do
      let(:asset) { {'path' => 'path1'} }
      before(:each) {
        expect(@list.api).to receive(:list_asset).and_return(asset)
      }

      it 'sends the list_asset method to api' do
        flags = {:id => 'test_id'}
        @list.options = flags
        @list.asset
      end

      it 'prints the asset\'s path, specified by id, by default' do
        flags = {:id => 'test_id'}
        @list.options = flags
        expect { @list.asset }.to output("path1\n").to_stdout
      end

      it 'prints full asset details when the full option is set' do
        flags = {
          :id => 'test_id',
          :full => true,
        }
        @list.options = flags
        expect { @list.asset }.to output("{\"path\"=>\"path1\"}\n").to_stdout
      end
    end

    it 'passes the flags set in Thor correctly to api' do
      id = 'list_id'
      expect(@list.api).to receive(:list_asset).with({ :id => id })
      flags = { 
        :full => true,
        :id   => id,
      }
      @list.options = flags
      @list.asset
    end
  end

  describe '#asset_size' do
    it 'sends the setup method from CLIUtils' do
      expect(@list).to receive(:setup)
      expect(@list.api).to receive(:get_asset_size)
      @list.asset_size
    end

    it 'sends the get_asset_size method to api' do
      expect(@list.api).to receive(:get_asset_size)
      @list.asset_size
    end

    it 'prints the output of get_asset_size' do
      size = 20
      expect(@list.api).to receive(:get_asset_size).and_return(size)
      expect { @list.asset_size }.to output("#{size}\n").to_stdout
    end

    it 'passes the flags set in Thor correctly to api' do
      url = 'list_url'
      expect(@list.api).to receive(:get_asset_size).with({ :asset_url => url })
      flags = { 
        :url => url,
      }
      @list.options = flags
      @list.asset_size
    end
  end

  describe '#assets' do
    describe 'with mock assets' do
      let(:assets) {
        [
          {'path' => 'path1'},
          {'path' => 'path2'},
        ]
      }
      before(:each) {
        expect(@list.api).to receive(:paginate?).and_return(false)
        expect(@list.api).to receive(:list_assets).and_return(assets)
      }

      it 'sends the list_assets method to api' do
        flags = {:repository => 'test_repository'}
        @list.options = flags
        @list.assets
      end

      it 'prints only the path of each asset in a repo by default' do
        flags = {:repository => 'test_repository'}
        @list.options = flags
        expect { @list.assets }.to output("path1\npath2\n").to_stdout
      end

      it 'prints full details for each asset in a repo when the full option is set' do
        flags = {
          :repository => 'test_repository',
          :full => true,
        }
        @list.options = flags
        expect { @list.assets }.to output("{\"path\"=>\"path1\"}\n{\"path\"=>\"path2\"}\n").to_stdout
      end
    end

    it 'returns false when :repository_set? returns false' do
      expect(@list).to receive(:repository_set?).and_return(false)
      expect(@list.assets).to be(false)
    end

    it 'passes the flags set in Thor correctly to api' do
      repository = 'list_repository'
      expect(@list.api).to receive(:paginate?).and_return(false)
      expect(@list.api).to receive(:list_assets).with({:repository=>"list_repository", :paginate=>true})
      flags = {
        :full       => true,
        :repository => repository,
      }
      @list.options = flags
      @list.assets
    end
  end

  describe '#component' do
    describe 'with mock component' do
      let(:component) { {'name' => 'name1'} }
      before(:each) {
        expect(@list.api).to receive(:list_component).and_return(component)
      }

      it 'sends the list_component method to api' do
        flags = {:id => 'test_id'}
        @list.options = flags
        @list.component
      end

      it 'prints the component\'s name by default' do
        flags = {:id => 'test_id'}
        @list.options = flags
        expect { @list.component }.to output("name1\n").to_stdout
      end

      it 'prints full component details when the full option is set' do
        flags = {
          :id => 'test_id',
          :full => true,
        }
        @list.options = flags
        expect { @list.component }.to output("{\"name\"=>\"name1\"}\n").to_stdout
      end
    end

    it 'passes the flags set in Thor correctly to api' do
      id = 'list_id'
      expect(@list.api).to receive(:list_component).with({ :id => id })
      flags = { 
        :full => true,
        :id   => id,
      }
      @list.options = flags
      @list.component
    end
  end

  describe '#components' do
    describe 'with mock components' do
      let(:components) {
        [
          {'name'=>'name1', 'version'=>'version1', 'assets'=>[{'path'=>'asset1'}]},
          {'name'=>'name2', 'version'=>'version1', 'assets'=>[{'path'=>'asset2'}]},
        ]
      }
      before(:each) {
        expect(@list.api).to receive(:paginate?).and_return(false)
        expect(@list.api).to receive(:list_components).and_return(components)
      }

      it 'sends the list_components method to api' do
        flags = {:repository => 'test_repository'}
        @list.options = flags
        @list.components
      end

      it 'prints the name and version of each component in a repo by default' do
        flags = {:repository => 'test_repository'}
        @list.options = flags
        expect { @list.components }.to output("name1 (version1)\nname2 (version1)\n").to_stdout
      end

      it 'prints the name, version and assets of each component in a repo when the asset option is set' do
        flags = {
          :repository => 'test_repository',
          :assets => true,
        }
        @list.options = flags
        expect { @list.components }.to output("name1 (version1)\n  asset1\nname2 (version1)\n  asset2\n").to_stdout
      end

      it 'prints full details for each component in a repo when the full option is set' do
        flags = {
          :repository => 'test_repository',
          :full => true,
        }
        @list.options = flags
        components_list = "{\"name\"=>\"name1\", \"version\"=>\"version1\", \"assets\"=>[{\"path\"=>\"asset1\"}]}\n"\
          "{\"name\"=>\"name2\", \"version\"=>\"version1\", \"assets\"=>[{\"path\"=>\"asset2\"}]}\n"
        expect { @list.components }.to output(components_list).to_stdout
      end

      it 'prints full details for each component in a repo when the full and asset options are set' do
        flags = {
          :repository => 'test_repository',
          :full => true,
          :assets => true,
        }
        @list.options = flags
        components_list = "{\"name\"=>\"name1\", \"version\"=>\"version1\", \"assets\"=>[{\"path\"=>\"asset1\"}]}\n"\
          "{\"name\"=>\"name2\", \"version\"=>\"version1\", \"assets\"=>[{\"path\"=>\"asset2\"}]}\n"
        expect { @list.components }.to output(components_list).to_stdout
      end
    end

    it 'returns false when :repository_set? returns false' do
      expect(@list).to receive(:repository_set?).and_return(false)
      expect(@list.components).to be(false)
    end

    it 'passes the flags set in Thor correctly to api' do
      repository = 'list_repository'
      expect(@list.api).to receive(:paginate?).and_return(false)
      expect(@list.api).to receive(:list_components).with({:repository=>"list_repository", :paginate=>true})
      flags = { 
        :full       => true,
        :repository => repository,
      }
      @list.options = flags
      @list.components
    end
  end

  describe '#repositories' do
    describe 'with mock repositories' do
      let(:repositories) { [{'name' => 'repository1'}] }
      before(:each) {
        expect(@list.api).to receive(:list_repositories).and_return(repositories)
      }

      it 'sends the list_repositories method to api' do
        @list.repositories
      end

      it 'prints the name of each repository by default' do
        expect { @list.repositories }.to output("repository1\n").to_stdout
      end

      it 'prints the full details of each repository when the full option is set' do
        flags = { :full => true }
        @list.options = flags
        expect { @list.repositories }.to output("{\"name\"=>\"repository1\"}\n").to_stdout
      end
    end

    it 'passes the flags set in Thor correctly to api' do
      expect(@list.api).to receive(:list_repositories).with(no_args)
      flags = { :full => true }
      @list.options = flags
      @list.repositories
    end
  end

  describe '#status' do
    it 'sends the status and status_writable methods to api' do
      expect(@list.api).to receive(:status).and_return(true)
      expect(@list.api).to receive(:status_writable).and_return(true)
      message = "Nexus can respond to read requests:  true\nNexus can respond to write requests: true\n"
      expect { @list.status }.to output(message).to_stdout
    end

    it 'passes the flags set in Thor correctly to api' do
      expect(@list.api).to receive(:status).with(no_args)
      expect(@list.api).to receive(:status_writable).with(no_args)
      flags = { :full => true }
      @list.options = flags
      @list.status
    end
  end
end
