# frozen_string_literal: true

RSpec.describe 'Client' do
  let(:account_id) { 1 }
  let(:account_secret) { 'account_secret' }

  context 'without authentication' do
    let(:response) { Boapi::Client.new(account_id: account_id, account_secret: rand(10).to_s).currencies }
    let(:http_status) { 401 }

    let(:url) { "#{Boapi.configuration.api_host}/api/v1/currencies" }

    before do
      stub_request(:get, url)
        .to_return(status: http_status, body: SupportFixtures.failed_without_authentification_response)
    end

    it 'returns error response' do
      expect(response.status).to be http_status

      expect(response.success?).to be false
      expect(response.error?).to be true
      expect(response.error).to eq(SupportFixtures.failed_without_authentification_response_message)
    end
  end

  describe '.health' do
    let(:response) { Boapi::Client.new(account_id: account_id, account_secret: account_secret).health }
    let(:http_status) { 200 }

    let(:url) { "#{Boapi.configuration.api_host}/api/health" }

    # subject { client.health }

    before do
      stub_request(:get, url)
        .to_return(status: http_status, body: SupportFixtures.health_response)
    end

    it 'returns successful response' do
      expect(response.status).to be http_status

      expect(response.success?).to be true
      expect(response.error?).to be false
      expect(response.data).to eq(SupportFixtures.health_response_message)
    end
  end

  describe '.currencies' do
    let(:response) { Boapi::Client.new(account_id: account_id, account_secret: account_secret).currencies }
    let(:http_status) { 200 }

    let(:url) { "#{Boapi.configuration.api_host}/api/v1/currencies" }

    before do
      stub_request(:get, url)
        .to_return(status: http_status, body: CurrencyFixtures.successful_currencies_response)
    end

    it 'returns successful response' do
      expect(response.status).to be http_status

      expect(response.success?).to be true
      expect(response.error?).to be false
      expect(response.data).to eq(CurrencyFixtures.successful_currencies_response_message)
    end
  end

  describe '.transactions_count' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).transactions_count(params)
    end
    let(:http_status) { 422 }

    let(:url) { "#{Boapi.configuration.api_host}/api/v2/transactions/count" }

    context 'when no params given' do
      let(:params) { {} }

      before do
        stub_request(:post, url)
          .to_return(status: http_status, body: TransactionFixtures.failed_transactions_count_response)
      end

      it 'returns error' do
        expect(response.status).to be http_status
        expect(response.success?).to be false
        expect(response.error?).to be true
        expect(response.error).to eq(TransactionFixtures.failed_transactions_count_response_message)
      end
    end

    context 'when valid params given' do
      let(:params) { { filter: { date_from: '2023-01-20T00:00:00', date_to: '2023-03-22T00:00:00' } } }
      let(:http_status) { 200 }

      before do
        stub_request(:post, url)
          .to_return(status: http_status, body: TransactionFixtures.successful_transactions_count_response)
      end

      it 'returns successful response' do
        expect(response.status).to be http_status

        expect(response.success?).to be true
        expect(response.error?).to be false
        expect(response.data).to eq(TransactionFixtures.successful_transactions_count_response_message)
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
      let(:http_status) { 200 }

      before do
        stub_request(:post, url)
          .to_return(status: http_status, body: TransactionFixtures.successful_transactions_list_response)
      end

      it 'returns successful response' do
        expect(response.status).to be http_status

        expect(response.success?).to be true
        expect(response.error?).to be false
        expect(response.data).to eq(TransactionFixtures.successful_transactions_list_response_message)
      end
    end
  end

  describe '.transactions_search' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).transactions_search(params)
    end

    let(:url) { "#{Boapi.configuration.api_host}/api/v2/transactions/search" }

    context 'when valid params given' do
      let(:params) do
        { filter: { date_from: '2023-01-20T00:00:00', date_to: '2023-03-22T00:00:00' }, options: { limit: 3 } }
      end
      let(:http_status) { 200 }

      before do
        stub_request(:post, url)
          .to_return(status: http_status, body: TransactionFixtures.successful_transactions_list_response)
      end

      it 'returns successful response' do
        expect(response.status).to be http_status

        expect(response.success?).to be true
        expect(response.error?).to be false
        expect(response.data).to eq(TransactionFixtures.successful_transactions_list_response_message)
      end
    end
  end

  describe '.get_rate' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).get_rate(uid)
    end
    let(:http_status) { 200 }

    let(:uid) { '961c3be2-c7b0-44ab-9f79-48cabd30c519' }
    let(:url) { "#{Boapi.configuration.api_host}/api/v2/rates/#{uid}" }

    context 'when valid params given' do
      before do
        stub_request(:get, url)
          .to_return(status: http_status, body: RateFixtures.successful_get_rate_response)
      end

      it 'returns successful response' do
        expect(response.status).to be http_status

        expect(response.success?).to be true
        expect(response.error?).to be false
        expect(response.data).to eq(RateFixtures.successful_get_rate_response_message)
      end
    end
  end

  describe '.rates_list' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).rates_list(params)
    end
    let(:http_status) { 200 }

    let(:url) { "#{Boapi.configuration.api_host}/api/v2/rates" }

    context 'when valid params given' do
      let(:params) { { currency: 'GBP', gateway_id: 123 } }

      before do
        stub_request(:get, url).with(query: params)
                               .to_return(status: http_status, body: RateFixtures.successful_rates_list_response)
      end

      it 'returns successful response' do
        expect(response.status).to be http_status

        expect(response.success?).to be true
        expect(response.error?).to be false
        expect(response.data).to eq(RateFixtures.successful_rates_list_response_message)
      end
    end
  end

  describe '.create rate' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).create_rate(params)
    end
    let(:http_status) { 201 }

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
                              .to_return(status: http_status, body: RateFixtures.successful_create_rate_response)
    end

    it 'returns successful response' do
      expect(response.status).to be http_status

      expect(response.success?).to be true
      expect(response.error?).to be false
      expect(response.data).to eq(RateFixtures.successful_create_rate_response_message)
    end
  end

  describe '.update rate' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).update_rate(uid, params)
    end
    let(:http_status) { 200 }

    let(:uid) { '961c3be2-c7b0-44ab-9f79-48cabd30c519' }
    let(:url) { "#{Boapi.configuration.api_host}/api/v2/rates/#{uid}" }
    let(:params) do
      {
        rate: {
          currency: 'BYN',
          rolling_reserve_days: 1,
          rolling_reserve_rate: 1.1,
          psp_authorization_declined_fee: 75,
          psp_capture_declined_fee: 120
        }
      }
    end

    before do
      stub_request(:patch, url).with(body: params.to_json)
                               .to_return(status: http_status, body: RateFixtures.successful_update_rate_response)
    end

    it 'returns successful response' do
      expect(response.status).to be http_status

      expect(response.success?).to be true
      expect(response.error?).to be false
      expect(response.data).to eq(RateFixtures.successful_update_rate_response_message)
    end
  end

  describe '.delete_rate' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).delete_rate(uid)
    end
    let(:http_status) { 204 }

    let(:uid) { '961c3be2-c7b0-44ab-9f79-48cabd30c519' }
    let(:url) { "#{Boapi.configuration.api_host}/api/v2/rates/#{uid}" }

    context 'when valid params given' do
      before do
        stub_request(:delete, url)
          .to_return(status: http_status, body: nil)
      end

      it 'returns successful response' do
        expect(response.status).to be http_status

        expect(response.success?).to be true
        expect(response.error?).to be false
      end
    end
  end
end
