module Blockcypher
  module Ethereum
    class DynamicObject

      # A DynamicObject provides the foundation for all objects that are
      # created via the DynamicObjects module. It's not meant to be instantiated
      # on it's own.

      attr_accessor :api_token, :use_test_env, :version

      # All dynamic objects should know the state of the API that they're representing like
      # version, api key, etc. Additional arguments usually need to be provided via the double
      # splat.
      def initialize(api_token: ENV['BLOCKCYPHER_API_KEY'],
                     use_test_env: false,
                     version: Blockcypher::Ethereum::API::DEFAULT_VERSION,
                     **args)
        @api_token = api_token
        @use_test_env = use_test_env
        @version = version

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
    end
  end
end
