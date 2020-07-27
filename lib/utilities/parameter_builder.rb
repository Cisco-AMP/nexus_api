module NexusAPI
  class ParameterBuilder
    def self.docker_group(name, members, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true
        },
        'docker' => {
          'v1Enabled' => false,
          'forceBasicAuth' => true
        },
        'group' => {}
      }
      apply_changes(default: default_options, override: options, name: name, members: members)
    end

    def self.docker_hosted(name, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true,
          'writePolicy' => 'allow_once'
        },
        'cleanup' => {
          'policyNames' => []
        },
        'docker' => {
          'v1Enabled' => false,
          'forceBasicAuth' => true
        }
      }
      apply_changes(default: default_options, override: options, name: name)
    end

    def self.docker_proxy(name, remote_url, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true
        },
        'proxy' => {
          'contentMaxAge' => 1440,
          'metadataMaxAge' => 1440
        },
        'negativeCache' => {
          'enabled' => true,
          'timeToLive' => 1440
        },
        'httpClient' => {
          'blocked' => false,
          'autoBlock' => true
        },
        'docker' => {
          'v1Enabled' => false,
          'forceBasicAuth' => true
        },
        'dockerProxy' => {
          'indexType' => 'REGISTRY'
        }
      }
      apply_changes(default: default_options, override: options, name: name, url: remote_url)
    end

    def self.maven_group(name, members, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true
        },
        'group' => {}
      }
      apply_changes(default: default_options, override: options, name: name, members: members)
    end

    def self.maven_hosted(name, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true,
          'writePolicy' => 'allow_once'
        },
        'cleanup' => {
          'policyNames' => []
        },
        'maven' => {
          'versionPolicy' => 'RELEASE',
          'layoutPolicy' => 'STRICT'
        }
      }
      apply_changes(default: default_options, override: options, name: name)
    end

    def self.maven_proxy(name, remote_url, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true
        },
        'cleanup' => {
          'policyNames' => []
        },
        'proxy' => {
          'contentMaxAge' => 1440,
          'metadataMaxAge' => 1440
        },
        'negativeCache' => {
          'enabled' => true,
          'timeToLive' => 1440
        },
        'httpClient' => {
          'blocked' => false,
          'autoBlock' => true,
        },
        'maven' => {
          'versionPolicy' => 'RELEASE',
          'layoutPolicy' => 'STRICT'
        }
      }
      apply_changes(default: default_options, override: options, name: name, url: remote_url)
    end

    def self.npm_group(name, members, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true
        },
        'group' => {}
      }
      apply_changes(default: default_options, override: options, name: name, members: members)
    end

    def self.npm_hosted(name, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true,
          'writePolicy' => 'allow_once'
        },
        'cleanup' => {
          'policyNames' => []
        }
      }
      apply_changes(default: default_options, override: options, name: name)
    end

    def self.npm_proxy(name, remote_url, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true
        },
        'cleanup' => {
          'policyNames' => []
        },
        'proxy' => {
          'contentMaxAge' => 1440,
          'metadataMaxAge' => 1440
        },
        'negativeCache' => {
          'enabled' => true,
          'timeToLive' => 1440
        },
        'httpClient' => {
          'blocked' => false,
          'autoBlock' => true,
        },
      }
      apply_changes(default: default_options, override: options, name: name, url: remote_url)
    end

    def self.pypi_group(name, members, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true
        },
        'group' => {}
      }
      apply_changes(default: default_options, override: options, name: name, members: members)
    end

    def self.pypi_hosted(name, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true,
          'writePolicy' => 'allow_once'
        },
        'cleanup' => {
          'policyNames' => []
        }
      }
      apply_changes(default: default_options, override: options, name: name)
    end

    def self.pypi_proxy(name, remote_url, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true
        },
        'cleanup' => {
          'policyNames' => []
        },
        'proxy' => {
          'contentMaxAge' => 1440,
          'metadataMaxAge' => 1440
        },
        'negativeCache' => {
          'enabled' => true,
          'timeToLive' => 1440
        },
        'httpClient' => {
          'blocked' => false,
          'autoBlock' => true,
        },
      }
      apply_changes(default: default_options, override: options, name: name, url: remote_url)
    end

    def self.raw_group(name, members, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true
        },
        'group' => {}
      }
      apply_changes(default: default_options, override: options, name: name, members: members)
    end

    def self.raw_hosted(name, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true,
          'writePolicy' => 'allow_once'
        },
        'cleanup' => {
          'policyNames' => []
        }
      }
      apply_changes(default: default_options, override: options, name: name)
    end

    def self.raw_proxy(name, remote_url, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true
        },
        'cleanup' => {
          'policyNames' => []
        },
        'proxy' => {
          'contentMaxAge' => 1440,
          'metadataMaxAge' => 1440
        },
        'negativeCache' => {
          'enabled' => true,
          'timeToLive' => 1440
        },
        'httpClient' => {
          'blocked' => false,
          'autoBlock' => true,
        }
      }
      apply_changes(default: default_options, override: options, name: name, url: remote_url)
    end

    def self.rubygems_group(name, members, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true
        },
        'group' => {}
      }
      apply_changes(default: default_options, override: options, name: name, members: members)
    end

    def self.rubygems_hosted(name, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true,
          'writePolicy' => 'allow_once'
        },
        'cleanup' => {
          'policyNames' => []
        }
      }
      apply_changes(default: default_options, override: options, name: name)
    end

    def self.rubygems_proxy(name, remote_url, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true
        },
        'cleanup' => {
          'policyNames' => []
        },
        'proxy' => {
          'contentMaxAge' => 1440,
          'metadataMaxAge' => 1440
        },
        'negativeCache' => {
          'enabled' => true,
          'timeToLive' => 1440
        },
        'httpClient' => {
          'blocked' => false,
          'autoBlock' => true,
        },
      }
      apply_changes(default: default_options, override: options, name: name, url: remote_url)
    end

    def self.yum_group(name, members, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true
        },
        'group' => {}
      }
      apply_changes(default: default_options, override: options, name: name, members: members)
    end

    def self.yum_hosted(name, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true,
          'writePolicy' => 'allow_once'
        },
        'cleanup' => {
          'policyNames' => []
        },
        'yum' => {
          'repodataDepth' => 3,
          'deployPolicy' => 'STRICT'
        }
      }
      apply_changes(default: default_options, override: options, name: name)
    end

    def self.yum_proxy(name, remote_url, options)
      default_options = {
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true
        },
        'cleanup' => {
          'policyNames' => []
        },
        'proxy' => {
          'contentMaxAge' => 1440,
          'metadataMaxAge' => 1440
        },
        'negativeCache' => {
          'enabled' => true,
          'timeToLive' => 1440
        },
        'httpClient' => {
          'blocked' => false,
          'autoBlock' => true,
        },
      }
      apply_changes(default: default_options, override: options, name: name, url: remote_url)
    end


    private

    def self.deep_merge(default_hash, hash)
      full_hash = {}

      default_hash.each do |key, value|
        if hash[key].nil?
          full_hash[key] = value
        else
          if value.is_a?(Hash)
            full_hash[key] = deep_merge(value, hash[key])
          else
            full_hash[key] = hash[key]
          end
          hash.delete(key)
        end
      end

      hash.each do |key, value|
        full_hash[key] = value
      end

      return full_hash
    end

    def self.apply_changes(default:, override:, name:, url: nil, members: nil)
      options = deep_merge(default, override)
      options['name'] = name
      options['proxy']['remoteUrl'] = url unless url.nil?
      options['group']['memberNames'] = members unless members.nil?
      return options
    end
  end
end
