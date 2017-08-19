module Blockcypher
  module Ethereum
    class Response
      def initialize(body)
        @body = JSON.parse(body).symbolize_keys
      end

      def object
        byebug
        Struct.new(object_name, object_attributes)
      end

      def object_name
        @body.keys.first
      end

      def object_attributes
        @body.values.first.keys
      end
    end
  end
end
