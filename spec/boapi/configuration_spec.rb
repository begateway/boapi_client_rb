# frozen_string_literal: true

RSpec.describe 'Configuration' do
  subject { Boapi.configuration }

  context 'api_host' do
    let(:user_defined_api_host) { 'https://example.com:8080' }
    before { Boapi.configure { |c| c.api_host = user_defined_api_host } }
    it 'sets properly' do
      expect(subject.api_host).to eql user_defined_api_host
    end
  end

  context 'proxy' do
    let(:user_defined_proxy) { '192.168.0.1:1234' }
    before { Boapi.configure { |c| c.proxy = user_defined_proxy } }
    it 'sets properly' do
      expect(subject.proxy).to eql user_defined_proxy
    end
  end

  context 'adapter' do
    let(:user_defined_adapter) { :test }
    before { Boapi.configure { |c| c.adapter = user_defined_adapter } }
    it 'sets properly' do
      expect(subject.adapter).to eql user_defined_adapter
    end
  end
end
