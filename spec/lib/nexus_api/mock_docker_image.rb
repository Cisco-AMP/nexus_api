module NexusAPI
  class MockDockerImage
    def initialize(tags)
      @tags = tags
    end

    def info
      { 'RepoTags' => @tags }
    end

    def tag(info)
      @tags << "#{info['repo']}:#{info['tag']}"
    end
  end
end