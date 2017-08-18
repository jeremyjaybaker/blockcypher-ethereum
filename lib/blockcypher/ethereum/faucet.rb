module Blockcypher
  class Faucet
    attr_accessor :address

    def initialize(address = nil)
      @address = address || ENV['BLOCKCYPHER_TEST_ADDRESS']
    end

    def add_wei(amount)
      params = { 'address': @address, 'amount': amount }
      #Blockcypher::Request.new(:faucet, test: true).post
    end

    def add_eth(amount)
      add_wei(amount * (10**18))
    end
  end
end
