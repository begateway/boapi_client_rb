# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
module ReportFixtures
  module_function

  def successful_create_report_response_message
    {
      'report' => {
        'id' => '961c3be2-c7b0-44ab-9f79-48cabd30c519',
        'status' => 'pending',
        'type' => 'balance_records_report',
        'format' => 'csv',
        'engine' => 'oban',
        'user_id' => 1,
        'language' => 'en',
        'updated_at' => '2025-06-25T13:41:38.976093Z',
        'created_at' => '2025-06-25T13:41:38.976093Z',
        'psp_id' => 1,
        'generated_at' => nil,
        'expiry_date' => nil,
        'file_url' => nil,
        'notification_email' => nil,
        'request_params' => {
          'currency' => 'USD',
          'merchant_id' => 12,
          'shop_id' => 12,
          'gateway_id' => 12,
          'date_from' => '2025-01-01T00:00:00+00:00',
          'date_to' => '2025-03-16T23:59:59+00:00'
        }
      }
    }
  end

  def successful_create_report_response
    %({"data":#{successful_create_report_response_message.to_json}})
  end
end
# rubocop:enable Metrics/MethodLength
