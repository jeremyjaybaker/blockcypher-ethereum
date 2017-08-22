module Blockcypher
  module Ethereum
    class Response
      include APIState

      # A response wrapper than includes Faraday methods like `status` and `body`. It also
      # includes a struct that wraps the resposne data in whatever object class the API
      # defines the return type as.

      attr_reader :response, :return_type

      def initialize(api_state, response, return_type)
        set_api_state(api_state)
        @response = response
        @return_type = return_type
      end

      def status
        @response.status
      end

      def success?
        @response.success?
      end

      def body
        JSON.parse(@response.body).symbolize_keys
      end

      def object
        if return_type == :data
          body
        else
          "Blockcypher::Ethereum::V#{version}::#{struct_name}".constantize.new(api_state, body)
        end
        # struct.new(*body.values)
      end

      private

      def struct_name
        return_type.to_s.singularize.titleize
      end

      def struct
        @struct ||= Struct.new(struct_name, *body.keys)
      end
    end
  end
end
