require 'nexus_api'
require 'bundler/setup'
require 'pry'
require 'simplecov'
require 'thor'
require 'webmock/rspec'

HOSTNAME = 'nexus_hostname'
BASE_URL = "https://#{HOSTNAME}/service/rest"
DOCKER_PULL_HOSTNAME = 'docker_pull'
DOCKER_PUSH_HOSTNAME = 'docker_push'

SimpleCov.start

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  # config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
