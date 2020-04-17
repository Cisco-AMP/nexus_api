lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nexus_api/version"

Gem::Specification.new do |spec|
  spec.name          = 'nexus_api'
  spec.version       = NexusAPI::VERSION
  spec.date          = %q{2019-12-04}
  spec.authors       = ['Francis Levesque', 'Gavin Miller']
  spec.email         = ['francis.d.levesque@gmail.com', 'me@gavinmiller.io']

  spec.summary       = %q{Provides API access to Sonatype Nexus through ruby!}
  spec.homepage      = "https://github.com/Cisco-AMP/nexus_api"
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = ['nexus_api']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'bundler', "~> 2"
  spec.add_runtime_dependency 'docker-api', "~> 1.34.2"
  spec.add_runtime_dependency 'dotenv', "~> 2.7.5"
  spec.add_runtime_dependency 'pry', "~> 0.12.2"
  spec.add_runtime_dependency 'rake', "~> 10.0"
  spec.add_runtime_dependency 'rest-client', "~> 2.1.0"
  spec.add_runtime_dependency 'thor', "~> 0.20.3"

  spec.add_development_dependency 'rspec', "~> 3.0"
  spec.add_development_dependency 'simplecov', "~> 0.18"
  spec.add_development_dependency 'webmock', "~> 3.8"
end
