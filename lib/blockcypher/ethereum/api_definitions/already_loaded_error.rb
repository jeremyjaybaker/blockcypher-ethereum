module Blockcypher
  module Ethereum
    module APIDefinitions
      class AlreadyLoadedError < StandardError
        def initialize
          super('API Definitions have already been loaded and cannot be loaded again.')
        end
      end
    end
  end
end
