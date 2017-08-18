module Blockcypher
  module Ethereum
    module DynamicObjects
      def self.instantiate_object(name, definition, version)
        class_name = "Blockcypher::Ethereum::V#{version}::#{name.to_s.titleize}"

        # New class declaration w/ accessors
        eval <<-RUBY
          class #{class_name} < Blockcypher::Ethereum::DynamicObject
            attr_accessor #{definition[:initialization_params].keys.to_s[1..-2]}
          end
        RUBY

        # Injecting methods into the new class
        class_name.constantize.class_eval do

          # Define the methods specified in the class definition
          definition[:actions].each do |action_hash|
            method_name = action_hash.keys.first
            method_def = action_hash.values.first

            # The actual method definition. It simply boils down to determining the endpoint,
            # assembling the request data, and making the request.
            define_method method_name do |**args|
              url = action_endpoint(method_name)
              params = request_params(method_def[:params], args)
              Blockcypher::Ethereum::Request.new(url, params, method_def[:type]).call
            end

            # Helper method for asking the method if it can only be called in the testnet or not.
            define_method "#{method_name}_is_testnet_only?" do
              method_def[:testnet_only]
            end
          end

          private

          eval <<-RUBY
            def action_definitions
              #{definition[:actions]}
            end

            def action_endpoint(action)
              path_ext = action_definitions.first[action][:path_extension]
              super(path_ext, '#{name}')
            end
          RUBY
        end
      end
    end
  end
end
