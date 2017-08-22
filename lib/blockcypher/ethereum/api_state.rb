module Blockcypher
  module Ethereum
    module APIState
      extend ActiveSupport::Concern

      # Most objects in this library need basic API state data to function
      # properly. APIState is simply a wrapper around this state data that
      # can be passed around and modified on a object level instead
      # of a higher or global level.

      included{ attr_accessor :api_token, :use_testnet, :version }

      def api_state
        { api_token: @api_token, use_testnet: @use_testnet, version: @version }
      end

      def set_api_state(state)
        state.each{ |k,v| send("#{k}=",v) }
      end

      def using_testnet?
        @use_testnet
      end
    end
  end
end
