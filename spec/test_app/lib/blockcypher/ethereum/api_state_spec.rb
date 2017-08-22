require 'spec_helper'

class MyDummyClass
  include Blockcypher::Ethereum::APIState

  def initailize
    @api_token = 'mytoken'
    @use_testnet = false
    @version = 1
  end
end

RSpec.describe Blockcypher::Ethereum::APIState do
  subject{ MyDummyClass.new }
  let(:new_state) do
    { version: 2 }
  end

  describe 'the API state' do
    it 'can return the state hash' do
      expect(subject.api_state).to be_instance_of Hash
    end

    it 'can set the state hash' do
      subject.set_api_state(new_state)
      expect(subject.version).to eq 2
    end
  end
end
