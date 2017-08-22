require 'faraday'

module Blockcypher
  module Ethereum
    class DynamicObject
      include APIState

      def initialize(state, **args)
        set_api_state(state)
        args.each{ |k,v| send("#{k}=", v) }
      end

      private

      def request_params(method_name, args)
        object_def[:actions][method_name][:param_type] == :path ? {} : attributes.merge(args).to_json
      end

      def send_request(method_name, params)
        url = endpoint(method_name, params)
        res = Faraday.new.send(request_type(method_name), url, request_params(method_name, params))
        raise InvalidRequest.new(res) if res.status.to_s =~ /[45]\d{2}/

        Blockcypher::Ethereum::Response.new(api_state, res, return_type(method_name))
      end

      def return_type(method_name)
        object_def[:actions][method_name][:return_type]
      end

      def request_type(method_name)
        object_def[:actions][method_name][:type]
      end

      def endpoint(method_name, params)
        Blockcypher::Ethereum::Endpoint.new(api_state, object_name, method_name, params).url
      end

      def attributes
        object_def[:attributes].map do |attr|
          { attr => instance_variable_get("@#{attr}") }
        end.reduce(:merge)
      end

      def version
        raise 'This class must be overridden in it\'s child class.'
      end

      def object_def
        raise 'This class must be overridden in it\'s child class.'
      end

      def object_name
        raise 'This class must be overridden in it\'s child class.'
      end
    end
  end
end
