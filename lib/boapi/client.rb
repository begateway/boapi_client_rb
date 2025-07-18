# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

module Boapi
  # rubocop:disable Metrics/ClassLength
  class Client
    attr_reader :account_id, :account_secret

    def initialize(account_id: '', account_secret: '')
      @account_id = account_id
      @account_secret = account_secret
    end

    def health
      send_request(:get, '/api/health')
    end

    def currencies
      send_request(:get, '/api/v1/currencies')
    end

    def transactions_count(params)
      send_request(:post, '/api/v2/transactions/count', params)
    end

    def transactions_list(params)
      send_request(:post, '/api/v2/transactions/list', params)
    end

    def transactions_search(params)
      send_request(:post, '/api/v2/transactions/search', params)
    end

    def transactions_deep_search(params)
      send_request(:post, '/api/v2/transactions/deep_search', params)
    end

    def transactions_export(params)
      send_request(:post, '/api/v2/transactions/export', params)
    end

    def psp_balances(params)
      send_request(:post, '/api/v2/psp/balances', params)
    end

    def merchant_balances(merchant_id, params)
      send_request(:post, "/api/v2/merchants/#{merchant_id}/balances", params)
    end

    def create_balance_record(params)
      send_request(:post, '/api/v2/balance_records', params)
    end

    def preadjustments_surcharges_max(params)
      send_request(:post, '/api/v2/preadjustments/surcharges/max', params)
    end

    def create_rate(params)
      send_request(:post, rate_path, params)
    end

    def migrate_rate(params)
      send_request(:post, rate_path('migrate'), params)
    end

    def rates_list(params)
      send_request(:get, rate_path, params)
    end

    def get_rate(id)
      send_request(:get, rate_path(id))
    end

    def update_rate(id, params)
      send_request(:patch, rate_path(id), params)
    end

    def delete_rate(id)
      send_request(:delete, rate_path(id))
    end

    def create_report(params)
      send_request(:post, '/api/v2/reports', params)
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def send_request(method, path, params = nil)
      response =
        begin
          connection.public_send(method, path, params) do |request|
            request.headers['Content-Type'] = 'application/json' if %i[post put patch].include?(method)
          end
        rescue Faraday::ConnectionFailed => e
          Boapi.configuration.logger.error("BOAPI::CLIENT::FARADAY::ERROR::CONNECTION_FAILED :: #{e}")

          build_connection_error_body(e)
        rescue Faraday::TimeoutError => e
          Boapi.configuration.logger.error("BOAPI::CLIENT::FARADAY::ERROR::READ_TIMEOUT :: #{e}")

          build_read_timeout_error_body(e)
        rescue Faraday::Error => e
          Boapi.configuration.logger.error("BOAPI::CLIENT::FARADAY::ERROR :: #{e}")

          build_error_body(e)
        end

      Boapi::Response.new(response)
    end

    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength
    def connection
      @connection ||= build_connection
    end

    private

    def rate_path(id = nil)
      path = '/api/v2/rates'
      id.nil? ? path : "#{path}/#{id}"
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def build_connection
      Faraday.new(Boapi.configuration.api_host, Boapi.configuration.faraday_opts) do |conn|
        conn.response :logger
        conn.basic_auth(account_id, account_secret)
        conn.request :json
        conn.response :json
        conn.proxy Boapi.configuration.proxy if Boapi.configuration.proxy
        conn.headers['Accept'] = 'application/json'
        conn.adapter Boapi.configuration.adapter
        conn.options.timeout = Boapi.configuration.timeout
        conn.options.open_timeout = Boapi.configuration.open_timeout
      end
    end

    # rubocop:enable Metrics/AbcSize
    def build_error_body(error_message)
      Struct.new(:status, :success?, :body, keyword_init: true).new(
        status: 500,
        body: {
          'error' => {
            'code' => 'faraday_error',
            'friendly_message' => "We're sorry, but something went wrong",
            'message' => error_message.to_s
          }
        },
        success?: false
      )
    end

    def build_read_timeout_error_body(error_message)
      Struct.new(:status, :success?, :body, keyword_init: true).new(
        status: 504,
        body: {
          'error' => {
            'code' => 'gateway_timeout',
            'friendly_message' => 'ReadTimeout error occurred',
            'message' => error_message.to_s
          }
        },
        success?: false
      )
    end

    def build_connection_error_body(error_message)
      Struct.new(:status, :success?, :body, keyword_init: true).new(
        status: 502,
        body: {
          'error' => {
            'code' => 'bad_gateway',
            'friendly_message' => 'Connection error',
            'message' => error_message.to_s
          }
        },
        success?: false
      )
    end

    # rubocop:enable Metrics/MethodLength
  end
  # rubocop:enable Metrics/ClassLength
end
