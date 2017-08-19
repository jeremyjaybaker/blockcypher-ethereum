require 'faraday'

module Blockcypher
  module Ethereum
    class Request

      # A simple wrapper around Faraday that automatically converts params to
      # json and raises exceptions on 4xx codes.

      attr_accessor :url, :params, :type

      def initialize(url, params, type)
        @url = url
        @params = params
        @type = type
      end

      def call
        res = Faraday.new.send(type.to_sym, url, params.to_json)
        raise InvalidRequest.new(res.status, res.body) if res.status.to_s =~ /[45]\d{2}/
        Rails.logger.info "Successful response: #{res.body}"
        Blockcypher::Ethereum::Response.new(res.body).object
      end
    end

    class InvalidRequest < StandardError
      def initialize(status, body)
        message = "#{status.to_s} #{body}"
        Rails.logger.info message
        super(message)
      end
    end
  end
end
