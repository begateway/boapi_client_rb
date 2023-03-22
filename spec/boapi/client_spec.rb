# frozen_string_literal: true

RSpec.describe 'Client' do
  let(:account_id) { 1 }
  let(:account_secret) { 'account_secret' }

  context 'without authentication' do
    let(:url) { "#{Boapi.configuration.api_host}/api/v1/currencies" }
    subject { Boapi::Client.new(account_id: account_id, account_secret: rand(10).to_s).currencies }

    before do
      stub_request(:get, url).to_return(status: 401,
                                        body: '{"error":{"code":"unauthorized","friendly_message":"You can\'t have access to this area","help":"https://doc.ecomcharge.com/codes/unauthorized","message":"Unauthorized"}}')
    end

    it 'returns error response' do
      expect(subject.status).to be 401

      expect(subject.success?).to be false
      expect(subject.error?).to be true
      expect(subject.error).to eq({ 'code' => 'unauthorized',
                                    'friendly_message' => "You can't have access to this area", 'help' => 'https://doc.ecomcharge.com/codes/unauthorized', 'message' => 'Unauthorized' })
    end
  end

  context '.health' do
    let(:url) { "#{Boapi.configuration.api_host}/api/health" }
    subject { Boapi::Client.new(account_id: account_id, account_secret: account_secret).health }

    before do
      stub_request(:get, url).to_return(status: 200,
                                        body: '{"data":{"click":true,"healthy":true,"pg":true,"rabbitmq":true,"redis":true,"version":"0.2.13"}}')
    end

    it 'returns successful response' do
      expect(subject.status).to be 200

      expect(subject.success?).to be true
      expect(subject.error?).to be false
      expect(subject.data).to eq({ 'click' => true, 'healthy' => true, 'pg' => true, 'rabbitmq' => true, 'redis' => true,
                                   'version' => '0.2.13' })
    end
  end

  context '.currencies' do
    let(:url) { "#{Boapi.configuration.api_host}/api/v1/currencies" }
    subject { Boapi::Client.new(account_id: account_id, account_secret: account_secret).currencies }

    before do
      stub_request(:get, url).to_return(status: 200,
                                        body: '{"data":["BYN", "USD"]}')
    end

    it 'returns successful response' do
      expect(subject.status).to be 200

      expect(subject.success?).to be true
      expect(subject.error?).to be false
      expect(subject.data).to eq(%w[BYN USD])
    end
  end

  context '.transactions_count' do
    let(:url) { "#{Boapi.configuration.api_host}/api/v2/transactions/count" }
    subject { Boapi::Client.new(account_id: account_id, account_secret: account_secret).transactions_count(params) }

    context 'when no params given' do
      let(:params) { {} }

      before do
        stub_request(:post, url).to_return(status: 422,
                                           body: '{"error":{"code":"unprocessable_entity", "friendly_message":"Filter is required.", "help":"https://doc.ecomcharge.com/codes/unprocessable_entity", "message":"Unprocessable entity"}}')
      end

      it 'returns error' do
        expect(subject.status).to be 422
        expect(subject.success?).to be false
        expect(subject.error?).to be true
        expect(subject.error).to eq({ 'code' => 'unprocessable_entity', 'friendly_message' => 'Filter is required.', 'help' => 'https://doc.ecomcharge.com/codes/unprocessable_entity', 'message' => 'Unprocessable entity' })
      end
    end

    context 'when params given' do
      let(:params) { { filter: { date_from: '2023-01-20T00:00:00', date_to: '2023-03-22T00:00:00' } } }

      before do
        stub_request(:post, url).to_return(status: 200,
                                           body: '{"data":{"count":1486}}')
      end

      it 'returns successful response' do
        expect(subject.status).to be 200

        expect(subject.success?).to be true
        expect(subject.error?).to be false
        expect(subject.data).to eq({ 'count' => 1486 })
      end
    end
  end

  context '.transactions_list' do
    let(:url) { "#{Boapi.configuration.api_host}/api/v2/transactions/list" }
    subject { Boapi::Client.new(account_id: account_id, account_secret: account_secret).transactions_list(params) }

    context 'when params given' do
      let(:params) { { filter: { date_from: '2023-01-20T00:00:00', date_to: '2023-03-22T00:00:00' }, options: { limit: 3 } } }

      before do
        stub_request(:post, url)
          .to_return(status: 200,
                     body: '{"data":{"pagination":{"date_from":"2023-02-20T09:02:54.516000Z", "date_to":"2023-02-20T11:13:43.748000Z", "date_type":"created_at", "has_next_page":true, "next_date":"2023-02-20T11:21:05.639000Z"},
                                     "transactions":[{"amount":200, "created_at":"2023-02-20T09:02:54.516000Z", "currency":"BYN", "merchant_id":55, "paid_at":"2023-02-20T09:02:59.669000Z", "shop_id":296, "status":"successful", "type":"p2p", "uid":"e4800e1b-fa21-4367-ae25-16f1eec8661f"},
                                                     {"amount":12346, "created_at":"2023-02-20T09:36:15.175000Z", "currency":"BYN", "merchant_id":1, "paid_at":"2023-02-20T09:36:15.994000Z", "shop_id":142, "status":"failed", "type":"payment", "uid":"5e499f43-74ca-4f95-a722-57dfc8e9adcc"},
                                                     {"amount":100, "created_at":"2023-02-20T11:13:43.748000Z", "currency":"BYN", "merchant_id":55, "paid_at":null, "shop_id":296, "status":"successful", "type":"tokenization", "uid":"a1b993aa-d340-4d52-a0ce-92e5a30ab6a6"}]}}')
      end

      it 'returns successful response' do
        expect(subject.status).to be 200

        expect(subject.success?).to be true
        expect(subject.error?).to be false
        expect(subject.data).to eq({ 'pagination' => { 'date_from' => '2023-02-20T09:02:54.516000Z', 'date_to' => '2023-02-20T11:13:43.748000Z', 'date_type' => 'created_at', 'has_next_page' => true, 'next_date' => '2023-02-20T11:21:05.639000Z' },
                                     'transactions' => [{ 'amount' => 200, 'created_at' => '2023-02-20T09:02:54.516000Z', 'currency' => 'BYN', 'merchant_id' => 55, 'paid_at' => '2023-02-20T09:02:59.669000Z', 'shop_id' => 296, 'status' => 'successful', 'type' => 'p2p', 'uid' => 'e4800e1b-fa21-4367-ae25-16f1eec8661f' },
                                                        { 'amount' => 12346, 'created_at' => '2023-02-20T09:36:15.175000Z', 'currency' => 'BYN', 'merchant_id' => 1, 'paid_at' => '2023-02-20T09:36:15.994000Z', 'shop_id' => 142, 'status' => 'failed', 'type' => 'payment', 'uid' => '5e499f43-74ca-4f95-a722-57dfc8e9adcc' },
                                                        { 'amount' => 100, 'created_at' => '2023-02-20T11:13:43.748000Z', 'currency' => 'BYN', 'merchant_id' => 55, 'paid_at' => nil, 'shop_id' => 296, 'status' => 'successful', 'type' => 'tokenization', 'uid' => 'a1b993aa-d340-4d52-a0ce-92e5a30ab6a6' }] })
      end
    end
  end
end
