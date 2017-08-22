require 'spec_helper'

# For testing different version numbers
module Blockcypher::Ethereum::V2
end

RSpec.describe Blockcypher::Ethereum::Endpoint do
  let(:test_state_v1){ { api_token: 'foobar', use_testnet: true, version: 1 } }
  let(:test_state_v2){ { api_token: 'foobar', use_testnet: true, version: 2 } }
  let(:main_state){ { api_token: 'foobar', use_testnet: true, version: 1 } }
  let(:faucet_params) { { amount: 100 } }
  let(:tx_params) { { hash: 'mytxhash' } }
  let(:tx) { Blockcypher::Ethereum::V1::Tx.new(test_state_v1) }

  describe 'url generation' do
    it 'can generate with the correct network' do
      url = Blockcypher::Ethereum::Endpoint.new(test_state_v1, :faucet, :add_wei, faucet_params).url
      expect(url).to match /\/test\//
    end

    it 'can generate with the correct version number' do
      allow_any_instance_of(Blockcypher::Ethereum::Endpoint).to receive(:all_definitions)
        .and_return(Blockcypher::Ethereum::V1::OBJECTS)
      url = Blockcypher::Ethereum::Endpoint.new(test_state_v2, :faucet, :add_wei, faucet_params).url
      expect(url).to match /\/v2\//
    end

    it 'can generate with the api token included' do
      url = Blockcypher::Ethereum::Endpoint.new(test_state_v1, :faucet, :add_wei, faucet_params).url
      expect(url).to match /\=foobar$/
    end

    it 'can generate with the pluralized object name' do
      url = Blockcypher::Ethereum::Endpoint.new(test_state_v1, :tx, :retrieve, tx_params).url
      expect(url).to match /\/txs\//
    end

    context 'with a path extension' do
      it 'can generate with the correct extension' do
        url = Blockcypher::Ethereum::Endpoint.new(test_state_v1, :tx, :build, { tx: tx }).url
        expect(url).to match /\/txs\/new\?/
      end
    end

    context 'without a path extension' do
      it 'can generate without the extension' do
        url = Blockcypher::Ethereum::Endpoint.new(test_state_v1, :faucet, :add_wei, faucet_params).url
        expect(url).to match /\/faucet\?/
      end
    end
  end
end
