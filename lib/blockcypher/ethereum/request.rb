module Blockcypher
  class Request
    attr_accessor :url, :params, :conn

    def new(url, params, type)
      @url = url
      @params = params
      @type = type
    end

    def call
      Faraday.new(url: url).send(:post, @params.to_json)
    end
  end
end
