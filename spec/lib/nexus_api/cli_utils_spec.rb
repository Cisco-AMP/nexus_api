require 'nexus_api/cli_utils'

include NexusAPI::CLIUtils

RSpec.describe NexusAPI::CLIUtils do
  let(:options) { {} }
  let(:action) { 'action' }
  let(:params) { { params: 'params' } }
  let(:filter) { 'filter' }
  let(:value) { 'value' }
  let(:filtered_output) { "value\n" }
  let(:unfiltered_output) { "{\"filter\"=>\"value\"}\n" }
  let(:team_config) { double }

  before(:each) do
    @api = double
    allow(@api).to receive(:team_config).and_return(team_config)
  end

  describe '#setup' do
    # Unfortunately because we're overwriting #setup in some tests we can
    # wind up running these tests on an overriden version of the method
    # TODO: Dynamically reload the correct method version somehow

    it 'loads the specified envionment' do
      config = 'config'
      options[:nexus_config] = config
      allow(Dotenv).to receive(:load).with(config) # TODO: Change allow to expect when the above is done
      allow(NexusAPI::API).to receive(:new)
      setup
    end

    it 'creates a new instance of NexusAPI with the required parameters' do
      ENV['NEXUS_USERNAME'] = 'username'
      ENV['NEXUS_PASSWORD'] = 'password'
      ENV['NEXUS_HOSTNAME'] = 'hostname'
      ENV['DOCKER_PULL_HOSTNAME'] = 'docker_pull'
      ENV['DOCKER_PUSH_HOSTNAME'] = 'docker_push'

      team_config = 'team_config'
      options[:team_config] = team_config

      allow(Dotenv).to receive(:load)
      allow(NexusAPI::API).to receive(:new).with( # TODO: Change allow to expect when the above is done
        username: ENV['NEXUS_USERNAME'],
        password: ENV['NEXUS_PASSWORD'],
        hostname: ENV['NEXUS_HOSTNAME'],
        docker_pull_hostname: ENV['DOCKER_PULL_HOSTNAME'],
        docker_push_hostname: ENV['DOCKER_PUSH_HOSTNAME'],
        team_config: options[:team_config]
      )
      setup
    end
  end

  describe 'with mock setup' do
    def setup; end

    describe 'and single element' do
      let(:element) { {'filter' => value} }
      before(:each) do
        allow(@api).to receive(:action).and_return(element)
      end

      describe '#print_element' do
        it 'sends the :setup method' do
          expect(self).to receive(:setup)
          print_element(action: action, params: params, filter: filter)
        end

        it 'sends the action to api with params' do
          expect(@api).to receive(:action).with(params).and_return(element)
          print_element(action: action, params: params, filter: filter)
        end

        it 'prints the filtered output by default' do
          expect { 
            print_element(action: action, params: params, filter: filter) 
          }.to output(filtered_output).to_stdout
        end

        it 'prints the full output when specified' do
          options[:full] = true
          expect { 
            print_element(action: action, params: params, filter: filter) 
          }.to output(unfiltered_output).to_stdout
        end
      end
    end

    describe 'and element set' do
      let(:element_set) { [{'filter' => value}] }
      before(:each) do
        allow(@api).to receive(:paginate?).and_return(false)
        allow(@api).to receive(:action).and_return(element_set)
      end

      describe '#print_paginating_set' do
        it 'sends the :setup method' do
          expect(self).to receive(:setup)
          print_paginating_set(action: action, params: params, filter: filter)
        end

        it 'sets the paginate params option' do
          expect(params).not_to include(paginate: true)
          print_paginating_set(action: action, params: params, filter: filter)
          expect(params).to include(paginate: true)
        end

        it 'sends the action to api with params' do
          expect(@api).to receive(:action).with(params).and_return(element_set)
          print_paginating_set(action: action, params: params, filter: filter)
        end

        it 'sends the action to api with params until pagination completes' do
          expect(@api).to receive(:paginate?).and_return(true).once
          expect(@api).to receive(:paginate?).and_return(false).once
          expect(@api).to receive(:action).with(params).and_return(element_set).twice
          print_paginating_set(action: action, params: params, filter: filter)
        end

        it 'prints the filtered output by default' do
          expect { 
            print_paginating_set(action: action, params: params, filter: filter) 
          }.to output(filtered_output).to_stdout
        end

        it 'prints the full output when specified' do
          options[:full] = true
          expect { 
            print_paginating_set(action: action, params: params, filter: filter) 
          }.to output(unfiltered_output).to_stdout
        end

        it 'prints the output of the proc when specified' do
          message = 'I am a proc!'
          proc = Proc.new { message }
          expect { 
            print_paginating_set(action: action, params: params, filter: filter, proc: proc) 
          }.to output("#{message}\n").to_stdout
        end
      end

      describe '#print_set' do
        it 'sends the :setup method' do
          expect(self).to receive(:setup)
          print_set(action: action, filter: filter)
        end

        it 'sends the action to api' do
          expect(@api).to receive(:action).and_return(element_set)
          print_set(action: action, filter: filter)
        end

        it 'prints the filtered output set by default' do
          expect { 
            print_set(action: action, filter: filter) 
          }.to output(filtered_output).to_stdout
        end

        it 'prints the full output set when specified' do
          options[:full] = true
          expect { 
            print_set(action: action, filter: filter) 
          }.to output(unfiltered_output).to_stdout
        end
      end
    end

    describe 'and repositories' do
      let(:repository_method) { :repository }
      let(:repository) { 'repository' }
      let(:team_repository) { 'team_repository' }

      describe '#repository_set?' do
        it 'returns true when the repository option is set' do
          options[:repository] = repository
          options[:team_config] = nil
          expect(repository_set?).to eq(true)
        end

        it 'returns true when the team_config option is set' do
          options[:repository] = nil
          options[:team_config] = team_repository
          expect(repository_set?).to eq(true)
        end

        it 'returns true when both the repository and team_config options are set' do
          options[:repository] = repository
          options[:team_config] = team_repository
          expect(repository_set?).to eq(true)
        end

        it 'returns false when both the repository and team_config options are not set' do
          options[:repository] = nil
          options[:team_config] = nil
          expect(repository_set?).to eq(false)
        end

        it 'prints an error when both the repository and team_config options are not set' do
          error = "No value provided for required option '--repository' or '--team_config' (only need 1)\n"
          options[:repository] = nil
          options[:team_config] = nil
          expect { repository_set? }.to output(error).to_stdout
        end
      end

      describe '#set' do
        it 'sends the :setup method' do
          expect(self).to receive(:setup)
          options[:repository] = repository
          set(repository: repository_method)
        end

        it 'uses the provided repository' do
          options[:repository] = repository
          set(repository: repository_method)
          expect(options[:repository]).to eq(repository)
        end

        it 'uses the team repository when no repository is set' do
          expect(team_config).to receive(:send).with(repository_method).and_return(team_repository)
          set(repository: repository_method)
          expect(options[:repository]).to eq(team_repository)
        end
      end

      describe '#if_file_exists?' do
        it 'prints what file is being sent to what Nexus repository' do
          file = 'file'
          repository = 'repository'
          message = "Sending 'file' to the 'repository' repository in Nexus!\n"
          expect { if_file_exists?(file: file, repository: repository) {} }.to output(message).to_stdout
        end

        it 'uses the filename option by default' do
          options[:filename] = 'file'
          message = "Sending 'file' to the '' repository in Nexus!\n"
          expect { if_file_exists? {} }.to output(message).to_stdout
        end

        it 'uses the repository option by default' do
          options[:repository] = 'repository'
          message = "Sending '' to the 'repository' repository in Nexus!\n"
          expect { if_file_exists? {} }.to output(message).to_stdout
        end

        it 'uses the specified filename when supplied' do
          options[:filename] = 'file'
          new_file = 'new_file'
          message = "Sending 'new_file' to the '' repository in Nexus!\n"
          expect { if_file_exists?(file: new_file) {} }.to output(message).to_stdout
        end

        it 'uses the specified repository when supplied' do
          options[:repository] = 'repository'
          new_repository = 'new_repository'
          message = "Sending '' to the 'new_repository' repository in Nexus!\n"
          expect { if_file_exists?(repository: new_repository) {} }.to output(message).to_stdout
        end

        it 'rescues Errno::ENOENT and print an error' do
          options[:filename] = 'file'
          options[:repository] = 'repository'
          error = "Sending 'file' to the 'repository' repository in Nexus!\n'file' does not exist locally.\n"
          expect { if_file_exists? { raise Errno::ENOENT } }.to output(error).to_stdout
        end
      end
    end
  end
end