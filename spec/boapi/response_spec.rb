# frozen_string_literal: true

RSpec.describe 'Response' do
  let(:response) { Boapi::Response.new(raw_response) }

  context 'when successful' do
    let(:payload) { { 'count' => 100 } }
    let(:raw_response) do
      Struct.new(:status, :success?, :body, keyword_init: true).new(
        status: 200,
        success?: true,
        body: { 'data' => payload }
      )
    end

    it 'successful' do
      expect(response).to be_success
    end

    it 'not error' do
      expect(response).not_to be_error
    end

    it 'data returns payload' do
      expect(response.data).to eql payload
    end

    it 'there is no error' do
      expect(response.error).to be_nil
    end

    it 'returns raw' do
      expect(response.raw).to eql raw_response
    end
  end

  context 'when failed' do
    let(:payload) do
      {
        'code' => 'faraday_error',
        'friendly_message' => "We're sorry, but something went wrong",
        'message' => 'some internal error'
      }
    end
    let(:raw_response) do
      Struct.new(:status, :success?, :body, keyword_init: true).new(
        status: 500,
        success?: false,
        body: { 'error' => payload }
      )
    end

    it 'error' do
      expect(response).to be_error
    end

    it 'not successful' do
      expect(response).not_to be_success
    end

    it 'error returns payload' do
      expect(response.error).to eql payload
    end

    it 'there is no data' do
      expect(response.data).to be_nil
    end

    it 'returns raw' do
      expect(response.raw).to eql raw_response
    end
  end
end
