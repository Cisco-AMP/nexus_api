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


    def self.docker_group(name, members, http_port, https_port)
      parameters = {
        'name' => name,
        'online' => true,
        'storage' => {
          'blobStoreName' => 'default',
          'strictContentTypeValidation' => true
        },
        'group' => {},
        'docker' => {
          'v1Enabled' => false,
          'forceBasicAuth' => true
        }
      }
      parameters['group']['memberNames'] = members unless members.empty?
      parameters['docker']['httpPort'] = http_port unless http_port.nil?
      parameters['docker']['httpsPort'] = https_port unless https_port.nil?
    end

    def self.docker_hosted(name, write_policy, cleanup_policies, http_port, https_port)
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
          'forceBasicAuth' => true
        }
      }
      parameters['cleanup']['policyNames'] = cleanup_policies unless cleanup_policies.empty?
      parameters['docker']['httpPort'] = http_port unless http_port.nil?
      parameters['docker']['httpsPort'] = https_port unless https_port.nil?
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
      options = deep_merge(default_options, options)
      options['name'] = name
      options['proxy']['remoteUrl'] = remote_url
      return options
    end

    def self.maven_group()
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true
#   },
#   "group": {
#     "memberNames": [
#       "string"
#     ]
#   }
# }
    end

    def self.maven_hosted(name, write_policy: ALLOW_ONCE, version_policy: RELEASE, layout_policy: STRICT)
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true,
#     "writePolicy": "allow_once"
#   },
#   "cleanup": {
#     "policyNames": [
#       "string"
#     ]
#   },
#   "maven": {
#     "versionPolicy": "MIXED",
#     "layoutPolicy": "STRICT"
#   }
# }
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

    def self.maven_proxy()
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true
#   },
#   "cleanup": {
#     "policyNames": [
#       "string"
#     ]
#   },
#   "proxy": {
#     "remoteUrl": "https://remote.repository.com",
#     "contentMaxAge": 1440,
#     "metadataMaxAge": 1440
#   },
#   "negativeCache": {
#     "enabled": true,
#     "timeToLive": 1440
#   },
#   "httpClient": {
#     "blocked": false,
#     "autoBlock": true,
#     "connection": {
#       "retries": 0,
#       "userAgentSuffix": "string",
#       "timeout": 60,
#       "enableCircularRedirects": false,
#       "enableCookies": false
#     },
#     "authentication": {
#       "type": "username",
#       "username": "string",
#       "ntlmHost": "string",
#       "ntlmDomain": "string"
#     }
#   },
#   "routingRule": "string",
#   "maven": {
#     "versionPolicy": "MIXED",
#     "layoutPolicy": "STRICT"
#   }
# }
    end

    def self.npm_group()
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true
#   },
#   "group": {
#     "memberNames": [
#       "string"
#     ]
#   }
# }
    end

    def self.npm_hosted(name, write_policy: ALLOW_ONCE)
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true,
#     "writePolicy": "allow_once"
#   },
#   "cleanup": {
#     "policyNames": [
#       "string"
#     ]
#   }
# }
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

    def self.npm_proxy()
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true
#   },
#   "cleanup": {
#     "policyNames": [
#       "string"
#     ]
#   },
#   "proxy": {
#     "remoteUrl": "https://remote.repository.com",
#     "contentMaxAge": 1440,
#     "metadataMaxAge": 1440
#   },
#   "negativeCache": {
#     "enabled": true,
#     "timeToLive": 1440
#   },
#   "httpClient": {
#     "blocked": false,
#     "autoBlock": true,
#     "connection": {
#       "retries": 0,
#       "userAgentSuffix": "string",
#       "timeout": 60,
#       "enableCircularRedirects": false,
#       "enableCookies": false
#     },
#     "authentication": {
#       "type": "username",
#       "username": "string",
#       "ntlmHost": "string",
#       "ntlmDomain": "string"
#     }
#   },
#   "routingRule": "string"
# }
    end

    def self.pypi_group()
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true
#   },
#   "group": {
#     "memberNames": [
#       "string"
#     ]
#   }
# }
    end

    def self.pypi_hosted(name, write_policy: ALLOW_ONCE)
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true,
#     "writePolicy": "allow_once"
#   },
#   "cleanup": {
#     "policyNames": [
#       "string"
#     ]
#   }
# }
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

    def self.pypi_proxy()
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true
#   },
#   "cleanup": {
#     "policyNames": [
#       "string"
#     ]
#   },
#   "proxy": {
#     "remoteUrl": "https://remote.repository.com",
#     "contentMaxAge": 1440,
#     "metadataMaxAge": 1440
#   },
#   "negativeCache": {
#     "enabled": true,
#     "timeToLive": 1440
#   },
#   "httpClient": {
#     "blocked": false,
#     "autoBlock": true,
#     "connection": {
#       "retries": 0,
#       "userAgentSuffix": "string",
#       "timeout": 60,
#       "enableCircularRedirects": false,
#       "enableCookies": false
#     },
#     "authentication": {
#       "type": "username",
#       "username": "string",
#       "ntlmHost": "string",
#       "ntlmDomain": "string"
#     }
#   },
#   "routingRule": "string"
# }
    end

    def self.raw_group()
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true
#   },
#   "group": {
#     "memberNames": [
#       "string"
#     ]
#   }
# }
    end

    def self.raw_hosted(name, write_policy: ALLOW_ONCE)
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true,
#     "writePolicy": "allow_once"
#   },
#   "cleanup": {
#     "policyNames": [
#       "string"
#     ]
#   }
# }
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

    def self.raw_proxy()
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true
#   },
#   "cleanup": {
#     "policyNames": [
#       "string"
#     ]
#   },
#   "proxy": {
#     "remoteUrl": "https://remote.repository.com",
#     "contentMaxAge": 1440,
#     "metadataMaxAge": 1440
#   },
#   "negativeCache": {
#     "enabled": true,
#     "timeToLive": 1440
#   },
#   "httpClient": {
#     "blocked": false,
#     "autoBlock": true,
#     "connection": {
#       "retries": 0,
#       "userAgentSuffix": "string",
#       "timeout": 60,
#       "enableCircularRedirects": false,
#       "enableCookies": false
#     },
#     "authentication": {
#       "type": "username",
#       "username": "string",
#       "ntlmHost": "string",
#       "ntlmDomain": "string"
#     }
#   },
#   "routingRule": "string"
# }
    end

    def self.rubygems_group()
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true
#   },
#   "group": {
#     "memberNames": [
#       "string"
#     ]
#   }
# }
    end

    def self.rubygems_hosted(name, write_policy: ALLOW_ONCE)
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true,
#     "writePolicy": "allow_once"
#   },
#   "cleanup": {
#     "policyNames": [
#       "string"
#     ]
#   }
# }
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

    def self.rubygems_proxy()
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true
#   },
#   "cleanup": {
#     "policyNames": [
#       "string"
#     ]
#   },
#   "proxy": {
#     "remoteUrl": "https://remote.repository.com",
#     "contentMaxAge": 1440,
#     "metadataMaxAge": 1440
#   },
#   "negativeCache": {
#     "enabled": true,
#     "timeToLive": 1440
#   },
#   "httpClient": {
#     "blocked": false,
#     "autoBlock": true,
#     "connection": {
#       "retries": 0,
#       "userAgentSuffix": "string",
#       "timeout": 60,
#       "enableCircularRedirects": false,
#       "enableCookies": false
#     },
#     "authentication": {
#       "type": "username",
#       "username": "string",
#       "ntlmHost": "string",
#       "ntlmDomain": "string"
#     }
#   },
#   "routingRule": "string"
# }
    end

    def self.yum_group()
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true
#   },
#   "group": {
#     "memberNames": [
#       "string"
#     ]
#   }
# }
    end

    def self.yum_hosted(name, depth, write_policy: ALLOW_ONCE, deploy_policy: STRICT)
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true,
#     "writePolicy": "allow_once"
#   },
#   "cleanup": {
#     "policyNames": [
#       "string"
#     ]
#   },
#   "yum": {
#     "repodataDepth": 5,
#     "deployPolicy": "STRICT"
#   }
# }
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

    def self.yum_proxy()
# {
#   "name": "internal",
#   "online": true,
#   "storage": {
#     "blobStoreName": "default",
#     "strictContentTypeValidation": true
#   },
#   "cleanup": {
#     "policyNames": [
#       "string"
#     ]
#   },
#   "proxy": {
#     "remoteUrl": "https://remote.repository.com",
#     "contentMaxAge": 1440,
#     "metadataMaxAge": 1440
#   },
#   "negativeCache": {
#     "enabled": true,
#     "timeToLive": 1440
#   },
#   "httpClient": {
#     "blocked": false,
#     "autoBlock": true,
#     "connection": {
#       "retries": 0,
#       "userAgentSuffix": "string",
#       "timeout": 60,
#       "enableCircularRedirects": false,
#       "enableCookies": false
#     },
#     "authentication": {
#       "type": "username",
#       "username": "string",
#       "ntlmHost": "string",
#       "ntlmDomain": "string"
#     }
#   },
#   "routingRule": "string"
# }
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
  end
end
