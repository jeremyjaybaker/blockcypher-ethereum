require 'rails_helper'

RSpec.describe Blockcypher::API do
  let(:test_api) { Blockcypher::API.new(use_test_env: true) }

  describe 'object method declaration' do
    it 'can create object methods dynamically' do
      expect(test_api.faucet).to be_instance_of Blockcypher::Faucet
    end

    it 'raises an error if a testnet method is used on the mainnet' do
      expect{ subject.faucet }.to raise_exception Blockcypher::API::TestnetOnlyMethod
    end

    it 'can build parameters for the api call' do
      test_api.faucet(amount: 1234)
    end
  end
end
