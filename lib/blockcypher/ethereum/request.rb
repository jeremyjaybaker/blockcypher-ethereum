require 'faraday'

module Blockcypher
  module Ethereum
    class Request
      attr_accessor :url, :params, :conn

      def initialize(url, params, type)
        @url = url
        @params = params
        @type = type
      end

      def call
        byebug
        Faraday.new(url: url).send(:post, @params.to_json)
      end
    end
  end
end
