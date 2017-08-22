module Blockcypher
  module Ethereum
    module APIDefinitions

      mattr_reader :loaded

      # Each API version and its definitions are defined in the
      # lib/blockcypher/ethereum/api_definitions directory as v*.json. A new
      # module is created for each version and the definitions stored in the
      # module's OBJECTS constant.
      #
      # Individual API objects are defined in json as follows:
      #
      # "address": {                                      // The name of the class. Underscores like "tx_skeleton" become TxSkeleton.
      #   "resource_name": "addr",                        // If the class name differes from the resource name in the URL, specify the URL version here.
      #   "attributes": [ ... ],                          // A list of the accessors that the class has.
      #   "return_only_attributes: [ ... ],               // Attributes that are returned from the API but not set by the user. These become readers.
      #   "actions": {                                    // A hash of method definitions that correspond to API enpoints/functions. The names will
      #                                                   // generally match those defined in the Blockcypher API docs but deviate when they collide with
      #                                                   // existing methods (`#new`) or the object has no actions/paths specified (`#add_wei` for Faucet).
      #     "balance: {                                   //
      #       path_extension: "$OBJS/$ADDRESS/$ACTION",   // A DSL that describes the path extension for the action's endpoint. $OBJ/$OBJS evaluates to
      #                                                   // the name of the object as either singular/plural, respectively. $ACTION evaluates to the name
      #                                                   // of the parent action, and any other $__ expression pulls the value from the parameter with
      #                                                   // the same name.
      #       uses_token: false,                          // Determines whether or not if the API token is added to the request params.
      #       type: "get",                                // The type of HTTP request used for the endpoint.
      #       testnet_only: false,                        // Used for the helper method `(action)_is_testnet_only?` to determine if the method is only
      #                                                   // used for testing, like faucets.
      #       params: [ ... ],                            // An list of input params that the function accepts. No distinction is made between required and
      #                                                   // optional params.
      #       return_type: 'address'                      // Specifies the return type of the API call. If the type is 'data', a hash will be returned. Otherwise
      #                                                   // the return type will try to evaluate to an API object class.
      #     }
      #   }

      def self.load
        raise AlreadyLoadedError if loaded?

        def_dir = File.expand_path File.dirname(__FILE__) + '/api_definitions'

        Dir.foreach(def_dir) do |file|
          if file.match /(\d*)\.json/

            versions << $1.to_i

            contents = File.read("#{def_dir}/#{file}")
            contents_as_hash = JSON.parse(contents).deep_symbolize_keys

            eval <<-RUBY
              module Blockcypher::Ethereum::V#{$1}
                OBJECTS = #{contents_as_hash}.freeze
              end
            RUBY

            "Blockcypher::Ethereum::V#{$1}::OBJECTS".constantize.each do |obj_name, obj_def|
              Blockcypher::Ethereum::DynamicObjects.instantiate_class(obj_name, obj_def, $1)
            end
          end
        end

        loaded!
      end

      def self.versions
        @@versions ||= []
      end

      def self.loaded?
        @@loaded
      end

      private

      def self.loaded!
        @@loaded = true
      end
    end
  end
end
