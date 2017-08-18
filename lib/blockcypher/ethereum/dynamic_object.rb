module Blockcypher
  module Ethereum
    class DynamicObject
      attr_accessor :api_token, :use_test_env, :version

      def initialize(api_token: ENV['BLOCKCYPHER_API_KEY'],
                     use_test_env: false,
                     version: Blockcypher::Ethereum::API::DEFAULT_VERSION,
                     **args)
        @api_token = api_token
        @use_test_env = use_test_env
        @version = version

        # Any child arguments given are sent directly to the child's accessors. This will
        # almost definitely break if not called within a child class.
        args.each{ |k,v| send("#{k}=", v) }
      end

      private

      # Determines the API endpoint for both the object and the given action. If the
      # object has no action/path extension, that part is left out.
      def action_endpoint(path_ext, obj_name)
        path_ext.present? ? "/#{path_ext}" : ''
        network = @use_test_env ? 'test' : 'main'
        base_url = "https://api.blockcypher.com/v#{@version}/beth/#{network}/"

        "#{base_url}#{obj_name.to_s}#{path_ext}?token=#{@api_token}"
      end

      # The data that gets sent in the API request.
      def request_params(required_params, given_params)
        required_params.merge(given_params)
      end
    end
  end
end
