# frozen_string_literal: true

RSpec.describe 'Response' do
  subject { Boapi::Response.new(raw_response) }

  context 'when successful' do
    let(:payload) { { 'count' => 100 } }
    let(:raw_response) {
      OpenStruct.new(
        status: 200,
        success?: true,
        body: { 'data' => payload }
      )
    }

    it 'successful' do
      expect(subject.success?).to be_truthy
    end
    it 'not error' do
      expect(subject.error?).to be_falsey
    end
    it 'data returns payload' do
      expect(subject.data).to eql payload
    end

    it 'there is no error' do
      expect(subject.error).to be_nil
    end

    it 'returns raw' do
      expect(subject.raw).to eql raw_response
    end
  end

  context 'when failed' do
    let(:payload) {
      {
        'code' => 'faraday_error',
        'friendly_message' => "We're sorry, but something went wrong",
        'message' => 'some internal error'
      }
    }
    let(:raw_response) {
      OpenStruct.new(
        status: 500,
        success?: false,
        body: { 'error' => payload }
      )
    }

    it 'error' do
      expect(subject.error?).to be_truthy
    end

    it 'not successful' do
      expect(subject.success?).to be_falsey
    end

    it 'error returns payload' do
      expect(subject.error).to eql payload
    end

    it 'there is no data' do
      expect(subject.data).to be_nil
    end

    it 'returns raw' do
      expect(subject.raw).to eql raw_response
    end
  end
end
