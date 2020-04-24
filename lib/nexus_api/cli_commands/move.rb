module NexusAPI
  class Move < ::Thor
    attr_accessor :api

    include NexusAPI::CLIUtils

    desc 'components', 'Moves components with the provided tag to the provided destination'
    option :destination, :aliases => '-d', :desc => 'Destination to move components to', :required => true
    option :tag, :aliases => '-t', :desc => 'Tag to match', :required => true
    def components
      setup
      @api.move_components_to(destination: options[:destination], tag: options[:tag])
    end
  end
end
