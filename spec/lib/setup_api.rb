RSpec.shared_context 'setup NexusAPI::API' do
  let(:api) do
    NexusAPI::API.new(
      username: 'username',
      password: 'password',
      hostname: 'nexus_hostname',
      docker_pull_hostname: 'docker_pull',
      docker_push_hostname: 'docker_push',
    )
  end
end