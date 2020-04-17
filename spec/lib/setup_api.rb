RSpec.shared_context 'setup NexusAPI::API' do
  let(:api) do
    NexusAPI::API.new(
      username: 'username',
      password: 'password',
      hostname: HOSTNAME,
      docker_pull_hostname: DOCKER_PULL_HOSTNAME,
      docker_push_hostname: DOCKER_PUSH_HOSTNAME,
    )
  end
end