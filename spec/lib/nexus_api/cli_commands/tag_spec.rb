require 'nexus_api/cli_utils'
require 'nexus_api/cli_commands/tag'
require 'lib/nexus_api/mock_cli_utils'

RSpec.describe NexusAPI::Tag do
  before(:each) {
    @tag = NexusAPI::Tag.new
    @tag.api = double
  }

  describe '#add' do
    it 'returns false when :repository_set? returns false' do
      expect(@tag).to receive(:repository_set?).and_return(false)
      expect(@tag.add).to be(false)
    end

    it 'sends the setup method from CLIUtils' do
      expect(@tag).to receive(:repository_set?).and_return(true)
      expect(@tag).to receive(:setup)
      expect(@tag.api).to receive(:associate_tag)
      @tag.add
    end

    it 'sends the associate_tag method to api' do
      expect(@tag).to receive(:repository_set?).and_return(true)
      expect(@tag.api).to receive(:associate_tag)
      @tag.add
    end

    it 'passes the flags set in Thor correctly to api' do
      expect(@tag).to receive(:repository_set?).and_return(true)

      name       = 'tag_name'
      sha1       = 'tag_sha1'
      repository = 'tag_repo'

      expect(@tag.api).to receive(:associate_tag).with({
        :name       => name,
        :sha1       => sha1,
        :repository => repository,
      })

      flags = {
        :name       => name,
        :sha1       => sha1,
        :repository => repository,
      }
      @tag.options = flags
      @tag.add
    end
  end

  describe '#create' do
    it 'sends the setup method from CLIUtils' do
      expect(@tag).to receive(:setup)
      expect(@tag.api).to receive(:create_tag)
      @tag.create
    end

    it 'sends the create_tag method to api' do
      expect(@tag.api).to receive(:create_tag)
      @tag.create
    end

    it 'passes the flags set in Thor correctly to api' do
      name = 'tag_name'
      expect(@tag.api).to receive(:create_tag).with(
        { :name => name }
      )
      flags = { :name => name }
      @tag.options = flags
      @tag.create
    end
  end

  describe '#delete' do
    it 'sends the setup method from CLIUtils' do
      expect(@tag).to receive(:setup)
      expect(@tag.api).to receive(:delete_tag)
      @tag.delete
    end
    
    it 'sends the delete_tag method to api' do
      expect(@tag.api).to receive(:delete_tag)
      @tag.delete
    end

    it 'passes the flags set in Thor correctly to api' do
      name = 'tag_name'
      expect(@tag.api).to receive(:delete_tag).with(
        { :name => name }
      )
      flags = { :name => name }
      @tag.options = flags
      @tag.delete
    end
  end

  describe '#list' do
    describe 'with mock tags' do
      let(:tags) { [{'name' => 'tag1'}] }
      before(:each) {
        expect(@tag.api).to receive(:list_tags).and_return(tags)
      }

      it 'sends the list_tags method to api' do
        @tag.list
      end

      it 'prints the name of each tag by default' do
        expect { @tag.list }.to output("tag1\n").to_stdout
      end

      it 'prints the full details of each tag when the full option is set' do
        flags = {:full => true}
        @tag.options = flags
        expect { @tag.list }.to output("{\"name\"=>\"tag1\"}\n").to_stdout
      end
    end

    it 'passes the flags set in Thor correctly to api' do
      expect(@tag.api).to receive(:list_tags).with(no_args)
      flags = { :full => true }
      @tag.options = flags
      @tag.list
    end
  end

  describe '#remove' do
    it 'returns false when :repository_set? returns false' do
      expect(@tag).to receive(:repository_set?).and_return(false)
      expect(@tag.remove).to be(false)
    end

    it 'sends the setup method from CLIUtils' do
      expect(@tag).to receive(:repository_set?).and_return(true)
      expect(@tag).to receive(:setup)
      expect(@tag.api).to receive(:delete_associated_tag)
      @tag.remove
    end

    it 'sends the delete_associated_tag method to api' do
      expect(@tag).to receive(:repository_set?).and_return(true)
      expect(@tag.api).to receive(:delete_associated_tag)
      @tag.remove
    end

    it 'passes the flags set in Thor correctly to api' do
      expect(@tag).to receive(:repository_set?).and_return(true)

      name       = 'tag_name'
      sha1       = 'tag_sha1'
      repository = 'tag_repo'

      expect(@tag.api).to receive(:delete_associated_tag).with({
        :name       => name,
        :sha1       => sha1,
        :repository => repository,
      })

      flags = {
        :name       => name,
        :sha1       => sha1,
        :repository => repository,
      }
      @tag.options = flags
      @tag.remove
    end
  end
end
