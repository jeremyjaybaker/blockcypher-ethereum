require 'spec_helper'

RSpec.describe Blockcypher::Ethereum::Request do
  let(:api_key){ Rails.application.secrets['BLOCKCYPHER_API_KEY'] }
  let(:url) do
    "https://api.blockcypher.com/v1/beth/test/addrs?token=#{api_key}"
  end
  let(:incorrect_url) do
    "https://api.blockcypher.com/v1/beth/test/"
  end
  let(:params) { { amount: 100, address: 'eb4e8bdecc1e10c98b80bb2a5d582196a554713f' } }
  let(:request) { Blockcypher::Ethereum::Request.new(url, params, :post) }
  let(:bad_request) { Blockcypher::Ethereum::Request.new(incorrect_url, params, :post) }

  describe 'a successful request/response' do
    it 'returns a successful Faraday response object' do
      expect(request.call.success?).to be true
    end

    it 'logs the response' do
      expect(Rails.logger).to receive(:info).once
      request.call
    end
  end

  describe 'a 4xx response' do
    it 'raises an exception' do
      expect{bad_request.call}.to raise_exception Blockcypher::Ethereum::InvalidRequest
    end

    it 'logs the response' do
      expect(Rails.logger).to receive(:info).once
      expect{bad_request.call}.to raise_exception Blockcypher::Ethereum::InvalidRequest
    end
  end

  describe 'a 5xx response' do
    before :each do
      allow_any_instance_of(Faraday::Response).to receive(:status).and_return 500
    end

    it 'raises an exception' do
      expect{bad_request.call}.to raise_exception Blockcypher::Ethereum::InvalidRequest
    end

    it 'logs the response' do
      expect(Rails.logger).to receive(:info).once
      expect{bad_request.call}.to raise_exception Blockcypher::Ethereum::InvalidRequest
    end
  end
end
