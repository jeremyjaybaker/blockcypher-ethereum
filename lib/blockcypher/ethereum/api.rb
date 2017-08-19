module Blockcypher
  module Ethereum
    class API

      # The primary class through which most API interaction will occur through.
      # Each instance of this class has initializers for all defined API objects
      # which can then call the various actions associated with each object.

      attr_accessor :use_test_env, :api_token, :version, :my_address
      VERSION_LIST = [1].freeze
      DEFAULT_VERSION = 1.freeze

      VERSION_LIST.each do |number|
        # Instantiate classes for all defined API versions.
        object_hash = "Blockcypher::Ethereum::APIDefinitions::V#{number}::OBJECTS".constantize
        object_hash.each do |name, definition|

          Blockcypher::Ethereum::DynamicObjects.instantiate_object(name, definition, number)

          # Define an accessor method on this API class itself that initializes the
          # newly-defined object.
          define_method name do |**args|
            class_name = "Blockcypher::Ethereum::V#{@version}::#{name.to_s.titleize}"
            class_name.constantize.new(object_params(args))
          end
        end
      end

      def initialize(use_test_env: false,
                     api_token: ENV['BLOCKCYPHER_API_KEY'],
                     version: DEFAULT_VERSION,
                     my_address: nil)
        @use_test_env = use_test_env
        @api_token = api_token
        @version = version
        @my_address = my_address
      end

      private

      def object_params(input_params)
        input_params.merge({
          api_token: @api_token,
          use_test_env: @use_test_env,
          version: @version
        })
      end
    end
  end
end
