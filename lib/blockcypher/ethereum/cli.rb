require 'thor'

module Blockcypher
  module Ethereum
    class CLI < Thor
      desc 'install', 'Install Blockcypher-Ethereum'
      def install
        require 'blockcypher/ethereum/cli/install'
        Install.start
      end
    end
  end
end
