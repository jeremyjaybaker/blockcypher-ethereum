module Blockcypher
  module Ethereum
    class API
      include APIState

      # The primary class through which most API interaction will occur through.
      # Each instance of this class has initializers for all defined API objects
      # which can then call the various actions associated with those objects.
      #
      # For example,
      # ```api = Blockcypher::Ethereum::API.new(use_testnet: true)
      # api.faucet.add_wei(amount: 100)```
      #
      # Will automatically configure the API class with your API key and version
      # and provide quick access to testnet API objects.

      DEFAULT_VERSION = 1.freeze

      def initialize(use_testnet: false,
                     api_token: ENV['BLOCKCYPHER_API_KEY'],
                     version: DEFAULT_VERSION)
        @use_testnet = use_testnet
        @api_token = api_token
        @version = version
      end

      Blockcypher::Ethereum::APIDefinitions.versions.each do |number|
        "Blockcypher::Ethereum::V#{number}::OBJECTS".constantize.each do |name, _|
          define_method name do |**args|
            class_name = "Blockcypher::Ethereum::V#{version}::#{name.to_s.titleize.gsub(' ','')}"
            class_name.constantize.new(args.merge(api_state))
          end
        end
      end
    end
  end
end
