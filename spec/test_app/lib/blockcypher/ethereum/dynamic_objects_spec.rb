require 'spec_helper'

RSpec.describe Blockcypher::Ethereum::DynamicObjects do
  let(:api_key) { Rails.application.secrets['BLOCKCYPHER_API_KEY'] }
  let(:test_api) { Blockcypher::Ethereum::API.new(use_testnet: true, api_token: api_key) }

  describe 'initialization/declaration' do
    it 'can define dynamic object classes' do
      expect(test_api.faucet).to be_instance_of Blockcypher::Ethereum::V1::Faucet
    end

    it 'can create initialization args' do
      faucet = test_api.faucet(address: 'myadd')
      expect(faucet.address).to eq 'myadd'
    end

    it 'sets accessors based on the initialization variables' do
      faucet = test_api.faucet(address: 'myaddress')
      expect(faucet.address).to be_instance_of String
    end
  end

  describe 'custom actions' do
    let(:faucet) { test_api.faucet(address: 'eb4e8bdecc1e10c98b80bb2a5d582196a554713f') }

    it 'can define methods from the action definitions' do
      res = faucet.add_wei(amount: 100)
      expect(res.success?).to be true
    end

    it 'can determine if an action can only be run in the testnet' do
      expect(faucet.add_wei_is_testnet_only?).to be true
    end
  end

  describe 'action info helpers' do
    let(:faucet) { test_api.faucet(address: 'eb4e8bdecc1e10c98b80bb2a5d582196a554713f') }

    it 'can print action descriptions as a hash' do
      expect(faucet.actions_info).to be_instance_of Hash
    end

    it 'can print action descriptions in a human-readable format' do
      expect_any_instance_of(Blockcypher::Ethereum::V1::Faucet).to receive(:puts)
      faucet.pretty_print_actions_info
    end
  end
end
