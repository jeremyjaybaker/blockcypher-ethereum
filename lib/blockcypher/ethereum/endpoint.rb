module Blockcypher
  module Ethereum
    class Endpoint
      include APIState

      attr_reader :object_name, :method_name, :params

      def initialize(api_state, object_name, method_name, params = {})
        set_api_state(api_state)
        @object_name = object_name
        @method_name = method_name
        @params = params.delete_if{ |_,v| v.nil? }
      end

      def url
        network = using_testnet? ? 'test' : 'main'
        base_url = "https://api.blockcypher.com/v#{version}/beth/#{network}/"

        "#{base_url}#{path_ext}#{token_param}"
      end

      private

      def token_param
        method_def[:uses_token] ? "?token=#{api_token}" : ''
      end

      def all_definitions
        "Blockcypher::Ethereum::V#{version}::OBJECTS".constantize
      end

      def object_def
        all_definitions[object_name]
      end

      def method_def
        object_def[:actions][method_name]
      end

      def resource_name
        object_def[:resource_name] || object_name
      end

      def path_ext
        base = method_def[:path_extension].present? ? "#{method_def[:path_extension]}" : ''
        return unless base.present?

        path_map.each{ |k,v| base.gsub!(k, v) }
        base.scan(/\$(\w+)/).flatten.map{ |a| base.gsub!("$#{a}", params[a.downcase.to_sym]) }
        base
      end

      def path_map
        {
          '$OBJS'    => resource_name.to_s.pluralize,
          '$OBJ'     => resource_name.to_s.singularize,
          '$ACTION'  => method_name.to_s
        }
      end
    end
  end
end
