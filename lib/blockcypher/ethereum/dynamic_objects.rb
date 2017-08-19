module Blockcypher
  module Ethereum
    module DynamicObjects

      # DynamicObjects is responsible for instantiating classes that represent objects
      # in the Ethereum API. A single class is defined for each API object and version.
      #
      # The object definitions themselves are location in the
      # Blockcypher::Ethereum::APIDefinitions::V_::OBJECTS series of modules where _ is
      # the API version number.

      def self.instantiate_object(name, definition, version)
        class_name = "Blockcypher::Ethereum::V#{version}::#{name.to_s.singularize.titleize}"

        # New class declaration w/ accessors
        eval <<-RUBY
          class #{class_name} < Blockcypher::Ethereum::DynamicObject
            attr_accessor #{definition[:attributes].to_s[1..-2]}
          end
        RUBY

        # Injecting methods into the new class
        class_name.constantize.class_eval do

          # Define the methods specified in the actions definition.
          definition[:actions].each do |method_name, method_def|
            # The actual method definition. It simply boils down to determining the endpoint,
            # assembling the request data, and making the request.
            define_method method_name do |**args|
              url = action_endpoint(method_name)
              params = default_action_params(method_def[:params]).merge(args)
              Blockcypher::Ethereum::Request.new(url, params, method_def[:type]).call
            end

            # Helper method for asking the method if it can only be called in the testnet or not.
            define_method "#{method_name}_is_testnet_only?" do
              method_def[:testnet_only]
            end
          end

          private

          define_method :action_definitions do
            definition[:actions]
          end

          # Determines this object's name and passes it to it's parent method.
          # Basically the same as it's parent method but with one input argument
          # automatically calculated.
          define_method :action_endpoint do |action|
            path_ext = definition[:actions][action][:path_extension]
            super(path_ext, name)
          end

          # Examines an object's parameters definition and evaluates
          # all Procs within this local context.
          # These can be overridden by values passed to the method during runtime.
          def default_action_params(hash)
            hash.each do |k,v|
              hash[k] = instance_exec(&v) if v.instance_of? Proc
            end
          end
        end
      end
    end
  end
end
