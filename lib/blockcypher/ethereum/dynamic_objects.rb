module Blockcypher
  module Ethereum
    module DynamicObjects

      # DynamicObjects is responsible for instantiating classes that represent objects
      # in the Ethereum API. A single class is defined for each API object and version.
      #
      # The object object_defs themselves are location in the
      # Blockcypher::Ethereum::APIDefinitions::V_::OBJECTS series of modules where _ is
      # the API version number.

      def self.instantiate_class(object_name, object_def, version)
        class_name = "Blockcypher::Ethereum::V#{version}::#{object_name.to_s.titleize.gsub(' ','')}"

        # New class declaration w/ accessors
        eval <<-RUBY
          class #{class_name} < Blockcypher::Ethereum::DynamicObject
            attr_accessor #{object_def[:attributes].to_s[1..-2]}
            attr_reader #{object_def[:return_only_attributes].to_s[1..-2]}
          end
        RUBY

        # Injecting methods into the new class
        class_name.constantize.class_eval do

          # Define the methods specified in the actions object_def.
          object_def[:actions].each do |method_name, method_def|
            define_method method_name do |**args|
              send_request(method_name, attributes.merge(args))
            end

            # Helper method for asking the method if it can only be called in the testnet or not.
            define_method "#{method_name}_is_testnet_only?" do
              method_def[:testnet_only]
            end
          end

          private

          define_method(:version)     { version }
          define_method(:object_def)  { object_def }
          define_method(:object_name) { object_name }
        end
      end
    end
  end
end
