require 'thor/group'

module Blockcypher
  module Ethereum
    class CLI < Thor
      class Install < Thor::Group
        include Thor::Actions

        def self.source_root
          File.expand_path("../install", __FILE__)
        end

        def create_configuration
          copy_file("load_api_definitions.rb", 'config/initializers/load_api_definitions.rb')
        end
      end
    end
  end
end
