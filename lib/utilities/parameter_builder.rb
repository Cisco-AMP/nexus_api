module NexusAPI
  class ParameterBuilder
    # Write Policies
    ALLOW = 'ALLOW'
    ALLOW_ONCE = 'ALLOW_ONCE'
    DENY = 'DENY'

    # Version Policy
    RELEASE = 'RELEASE'
    SNAPSHOT = 'SNAPSHOT'
    MIXED = 'MIXED'

    # Layout or Deploy Policy
    STRICT = 'STRICT'
    PERMISSIVE = 'PERMISSIVE'

    def self.docker_hosted(name, port, write_policy: ALLOW_ONCE)
      {
        'name' => name,
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true,
          'writePolicy' => write_policy
        },
        'docker' => {
          'v1Enabled' => false,
          'forceBasicAuth' => true,
          'httpPort' => port
        }
      }
    end

    def self.maven_hosted(name, write_policy: ALLOW_ONCE, version_policy: RELEASE, layout_policy: STRICT)
      {
        'name' => name,
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true,
          'writePolicy' => write_policy
        },
        'maven' => {
          'versionPolicy' => version_policy,
          'layoutPolicy' => layout_policy
        }
      }
    end

    def self.npm_hosted(name, write_policy: ALLOW_ONCE)
      {
        'name' => name,
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true,
          'writePolicy' => write_policy
        }
      }
    end

    def self.pypi_hosted(name, write_policy: ALLOW_ONCE)
      {
        'name' => name,
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true,
          'writePolicy' => write_policy
        }
      }
    end

    def self.raw_hosted(name, write_policy: ALLOW_ONCE)
      {
        'name' => name,
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true,
          'writePolicy' => write_policy
        }
      }
    end

    def self.rubygems_hosted(name, write_policy: ALLOW_ONCE)
      {
        'name' => name,
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true,
          'writePolicy' => write_policy
        }
      }
    end

    def self.yum_hosted(name, depth, write_policy: ALLOW_ONCE, deploy_policy: STRICT)
      {
        'name' => name,
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true,
          'writePolicy' => write_policy
        },
        'yum' => {
          'repodataDepth' => depth,
          'deployPolicy' => deploy_policy
        }
      }
    end
  end
end
