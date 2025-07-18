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

  context 'when connection error' do
    let(:response) { Boapi::Client.new(account_id: account_id, account_secret: account_secret).health }
    let(:url) { "#{Boapi.configuration.api_host}/api/health" }

    before do
      stub_request(:get, url)
        .to_raise(Faraday::ConnectionFailed.new('Failed to connect'))
    end

    it 'returns connection_failed response' do
      expect(response.status).to be 502

      expect(response.success?).to be false
      expect(response.error?).to be true
      expect(response.error).to eq SupportFixtures.bad_gateway_response
    end
  end

  context 'when timeout error' do
    let(:response) { Boapi::Client.new(account_id: account_id, account_secret: account_secret).health }
    let(:url) { "#{Boapi.configuration.api_host}/api/health" }

    before do
      stub_request(:get, url)
        .to_raise(Faraday::TimeoutError.new('Timeout'))
    end

    it 'returns connection_failed response' do
      expect(response.status).to be 504

      expect(response.success?).to be false
      expect(response.error?).to be true
      expect(response.error).to eq SupportFixtures.gateway_timeout_response
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

  describe '.transactions_deep_search' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).transactions_deep_search(params)
    end

    let(:url) { "#{Boapi.configuration.api_host}/api/v2/transactions/deep_search" }

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

  describe '.transactions_export' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).transactions_export(params)
    end

    let(:url) { "#{Boapi.configuration.api_host}/api/v2/transactions/export" }

    context 'when valid params given' do
      let(:params) do
        {
          filter: {
            status: 'successful',
            date_from: '2024-11-01T00:00:00.000000',
            date_to: '2024-11-02T00:00:00.000000',
            type: 'p2p'
          },
          options: { limit: 1 }
        }
      end
      let(:http_status) { 200 }

      before do
        stub_request(:post, url)
          .to_return(status: http_status, body: TransactionFixtures.successful_transactions_export_response)
      end

      it 'returns successful response' do
        expect(response.status).to be http_status

        expect(response.success?).to be true
        expect(response.error?).to be false
        expect(response.data).to eq(TransactionFixtures.successful_transactions_export_response_message)
      end
    end
  end

  describe '.psp_balances' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).psp_balances(params)
    end

    let(:http_status) { 200 }
    let(:url) { "#{Boapi.configuration.api_host}/api/v2/psp/balances" }

    context 'when valid params given' do
      let(:params) { { merchant_id: 47, currency: 'BYN', as_of_date: '2024-09-13T00:00:00.145823Z' } }

      before do
        stub_request(:post, url)
          .to_return(status: http_status, body: BalancesFixtures.successful_psp_balances_response)
      end

      it 'returns successful response' do
        expect(response.status).to be http_status

        expect(response.success?).to be true
        expect(response.error?).to be false
        expect(response.data).to eq(BalancesFixtures.successful_psp_balances_response_message)
      end
    end
  end

  describe '.merchant_balances' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).merchant_balances(merchant_id, params)
    end
    let(:http_status) { 200 }

    let(:merchant_id) { '47' }
    let(:url) { "#{Boapi.configuration.api_host}/api/v2/merchants/#{merchant_id}/balances" }

    context 'when valid params given' do
      let(:params) { { currency: 'BYN', as_of_date: '2024-09-13T00:00:00.145823Z' } }

      before do
        stub_request(:post, url)
          .to_return(status: http_status, body: BalancesFixtures.successful_merchant_balances_response)
      end

      it 'returns successful response' do
        expect(response.status).to be http_status

        expect(response.success?).to be true
        expect(response.error?).to be false
        expect(response.data).to eq(BalancesFixtures.successful_merchant_balances_response_message)
      end
    end
  end

  describe '.create balance_record' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).create_balance_record(params)
    end
    let(:http_status) { 201 }

    let(:url) { "#{Boapi.configuration.api_host}/api/v2/balance_records" }
    let(:params) do
      {
        balance_record: {
          merchant_id: 12,
          shop_id: 23,
          gateway_id: 34,
          type: 'adjustment',
          amount: 1000,
          currency: 'EUR',
          description: 'Balance debit',
          user_id: 45
        }
      }
    end

    before do
      stub_request(:post, url).with(body: params.to_json)
                              .to_return(
                                status: http_status,
                                body: BalanceRecordFixtures.successful_create_balance_record_response
                              )
    end

    it 'returns successful response' do
      expect(response.status).to be http_status

      expect(response.success?).to be true
      expect(response.error?).to be false
      expect(response.data).to eq(BalanceRecordFixtures.successful_create_balance_record_response_message)
    end
  end

  describe '.preadjustments_surcharges_max' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).preadjustments_surcharges_max(params)
    end

    let(:url) { "#{Boapi.configuration.api_host}/api/v2/preadjustments/surcharges/max" }

    context 'when valid params given' do
      let(:params) do
        {
          transaction_type: 'payment',
          initial_amount: 1000,
          currency: 'BYN',
          gateway_ids: %w[123 12345]
        }
      end
      let(:http_status) { 200 }

      before do
        stub_request(:post, url)
          .to_return(status: http_status, body: TransactionFixtures.successful_preadjustments_surcharges_max_response)
      end

      it 'returns successful response' do
        expect(response.status).to be http_status

        expect(response.success?).to be true
        expect(response.error?).to be false
        expect(response.data).to eq(TransactionFixtures.successful_preadjustments_surcharges_max_response_message)
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

  describe '.migrate rate' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).migrate_rate(params)
    end
    let(:http_status) { 201 }

    let(:url) { "#{Boapi.configuration.api_host}/api/v2/rates/migrate" }
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

  describe '.create_report' do
    let(:response) do
      Boapi::Client.new(account_id: account_id, account_secret: account_secret).create_report(params)
    end
    let(:http_status) { 201 }

    let(:url) { "#{Boapi.configuration.api_host}/api/v2/reports" }
    let(:report_request_params) do
      {
        date_from: '2025-01-01T00:00:00+00:00',
        date_to: '2025-03-16T23:59:59+00:00',
        currency: 'USD',
        merchant_id: 12,
        shop_id: 12,
        gateway_id: 12
      }
    end
    let(:params) do
      {
        id: '961c3be2-c7b0-44ab-9f79-48cabd30c519',
        user_id: 1,
        type: 'balance_records_report',
        format: 'csv',
        request_params: report_request_params
      }
    end

    before do
      stub_request(:post, url).with(body: params.to_json)
                              .to_return(status: http_status, body: ReportFixtures.successful_create_report_response)
    end

    it 'returns successful response' do
      expect(response.status).to be http_status

      expect(response.success?).to be true
      expect(response.error?).to be false
      expect(response.data).to eq(ReportFixtures.successful_create_report_response_message)
    end
  end
end
