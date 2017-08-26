require 'spec_helper'

RSpec.describe Blockcypher::Ethereum::API do
  let(:test_api) { Blockcypher::Ethereum::API.new(use_testnet: true) }

  describe 'object method declaration' do
    it 'can create object methods dynamically' do
      expect(test_api.faucet).to be_instance_of Blockcypher::Ethereum::V1::Faucet
    end

    it 'can build parameters for the api call' do
      byebug
      test_api.faucet(amount: 1234)
    end
  end

  #TODO: how to write good test code for the dynamic object accessors
end
