# frozen_string_literal: true

RSpec.describe 'Client' do
  let(:account_id) { 1 }
  let(:account_secret) { 'account_secret' }

  context 'without authentication' do
    let(:response) { Boapi::Client.new(account_id: account_id, account_secret: rand(10).to_s).currencies }

    let(:url) { "#{Boapi.configuration.api_host}/api/v1/currencies" }

    before do
      stub_request(:get, url)
        .to_return(status: 401, body: SupportResponseFixtures.error_without_authentification_response)
    end

    it 'returns error response' do
      expect(response.status).to be 401

      expect(response.success?).to be false
      expect(response.error?).to be true
      expect(response.error).to eq(SupportResponseFixtures.error_without_authentification_response_message)
    end
  end

  describe '.health' do
    let(:response) { Boapi::Client.new(account_id: account_id, account_secret: account_secret).health }

    let(:url) { "#{Boapi.configuration.api_host}/api/health" }

    before do
      stub_request(:get, url)
        .to_return(status: 200, body: SupportResponseFixtures.health_response)
    end

    it 'returns successful response' do
      expect(response.status).to be 200

      expect(response.success?).to be true
      expect(response.error?).to be false
      expect(response.data).to eq(SupportResponseFixtures.health_response_message)
    end
  end

  describe '.currencies' do
    let(:response) { Boapi::Client.new(account_id: account_id, account_secret: account_secret).currencies }

    let(:url) { "#{Boapi.configuration.api_host}/api/v1/currencies" }

    before do
      stub_request(:get, url)
        .to_return(status: 200, body: CurrencyResponseFixtures.successful_currencies_response)
    end

    it 'returns successful response' do
      expect(response.status).to be 200

      expect(response.success?).to be true
      expect(response.error?).to be false
      expect(response.data).to eq(CurrencyResponseFixtures.successful_currencies_response_message)
    end
  end

  describe '.transactions_count' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).transactions_count(params)
    end

    let(:url) { "#{Boapi.configuration.api_host}/api/v2/transactions/count" }

    context 'when no params given' do
      let(:params) { {} }

      before do
        stub_request(:post, url).to_return(status: 422, body: TransactionResponseFixtures.error_transactions_count_response)
      end

      it 'returns error' do
        expect(response.status).to be 422
        expect(response.success?).to be false
        expect(response.error?).to be true
        expect(response.error).to eq(TransactionResponseFixtures.error_transactions_count_response_message)
      end
    end

    context 'when valid params given' do
      let(:params) { { filter: { date_from: '2023-01-20T00:00:00', date_to: '2023-03-22T00:00:00' } } }

      before do
        stub_request(:post, url)
          .to_return(status: 200, body: TransactionResponseFixtures.successful_transactions_count_response)
      end

      it 'returns successful response' do
        expect(response.status).to be 200

        expect(response.success?).to be true
        expect(response.error?).to be false
        expect(response.data).to eq(TransactionResponseFixtures.successful_transactions_count_response_message)
      end
    end
  end

  describe '.transactions_list' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).transactions_list(params)
    end

    let(:url) { "#{Boapi.configuration.api_host}/api/v2/transactions/list" }

    context 'when valid params given' do
      let(:params) do
        { filter: { date_from: '2023-01-20T00:00:00', date_to: '2023-03-22T00:00:00' }, options: { limit: 3 } }
      end

      before do
        stub_request(:post, url)
          .to_return(status: 200, body: TransactionResponseFixtures.successful_transactions_list_response)
      end

      it 'returns successful response' do
        expect(response.status).to be 200

        expect(response.success?).to be true
        expect(response.error?).to be false
        expect(response.data).to eq(TransactionResponseFixtures.successful_transactions_list_response_message)
      end
    end
  end

  describe '.get_rate' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).get_rate(uid)
    end

    let(:uid) { '961c3be2-c7b0-44ab-9f79-48cabd30c519' }
    let(:url) { "#{Boapi.configuration.api_host}/api/v2/rates/#{uid}" }

    context 'when valid params given' do
      before do
        stub_request(:get, url)
          .to_return(status: 200, body: RateResponseFixtures.successful_get_rate_response)
      end

      it 'returns successful response' do
        expect(response.status).to be 200

        expect(response.success?).to be true
        expect(response.error?).to be false
        expect(response.data).to eq(RateResponseFixtures.successful_get_rate_response_message)
      end
    end
  end

  describe '.rates_list' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).rates_list(params)
    end

    let(:url) { "#{Boapi.configuration.api_host}/api/v2/rates" }

    context 'when valid params given' do
      let(:params) { { currency: 'GBP', gateway_id: 123 } }

      before do
        stub_request(:get, url).with(query: params)
          .to_return(status: 200, body: RateResponseFixtures.successful_rates_list_response)
      end

      it 'returns successful response' do
        expect(response.status).to be 200

        expect(response.success?).to be true
        expect(response.error?).to be false
        expect(response.data).to eq(RateResponseFixtures.successful_rates_list_response_message)
      end
    end
  end

  describe '.create rate' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).create_rate(params)
    end

    let(:url) { "#{Boapi.configuration.api_host}/api/v2/rates" }
    let(:gateway_id) { 123 }
    let(:params) do
      {
        rate: {
          currency: 'EUR',
          apply_from: '2021-06-08T00:00:00.000Z',
          created_at: '2021-06-08T00:00:00.000Z',
          gateway_id: gateway_id
        }
      }
    end

    before do
      stub_request(:post, url).with(body: params.to_json)
        .to_return(status: 201, body: RateResponseFixtures.successful_create_rate_response)
    end

    it 'returns successful response' do
      expect(response.status).to be 201

      expect(response.success?).to be true
      expect(response.error?).to be false
      expect(response.data).to eq(RateResponseFixtures.successful_create_rate_response_message)
    end
  end
end
