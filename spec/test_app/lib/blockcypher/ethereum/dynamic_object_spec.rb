require 'spec_helper'

class DynamicChild < Blockcypher::Ethereum::DynamicObject
  attr_accessor :foobar
end

RSpec.describe Blockcypher::Ethereum::DynamicObject do
  describe 'the inheriting class' do
    it 'can accept new accessors as initialization params' do
      obj = DynamicChild.new(foobar: 'mystring')
      expect(obj.foobar).to eq 'mystring'
    end
  end
end
