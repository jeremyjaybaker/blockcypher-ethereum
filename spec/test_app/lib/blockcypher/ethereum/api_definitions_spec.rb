require 'spec_helper'

RSpec.describe Blockcypher::Ethereum::APIDefinitions do
  describe 'loading from json' do
    it 'can define a module for the version' do
      expect( Blockcypher::Ethereum::V1 ).to be_instance_of Module
    end

    it 'loads the json into the modules OBJECTS constant' do
      expect(Blockcypher::Ethereum::V1::OBJECTS).to be_instance_of Hash
    end

    it 'symbolizes the hash\s keys' do
      expect(Blockcypher::Ethereum::V1::OBJECTS[:faucet]).to be_present
    end

    it 'keeps a list of each loaded version number' do
      expect(Blockcypher::Ethereum::APIDefinitions.versions).to include 1
    end
  end

  it 'raises an error if loading is attempted more than once' do
    expect{
      Blockcypher::Ethereum::APIDefinitions.load
    }.to raise_exception Blockcypher::Ethereum::APIDefinitions::AlreadyLoadedError
  end
end
