module Blockcypher
  module Ethereum
    class InvalidRequest < StandardError
      def initialize(response)
        message = <<-MSG
          #{response.status.to_s} #{response.body}
              #{response.env.url.to_s}
        MSG
        Rails.logger.info message
        super(message)
      end
    end
  end
end
