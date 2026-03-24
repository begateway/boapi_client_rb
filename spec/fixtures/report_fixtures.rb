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

  def successful_get_report_message
    {
      'report' => {
        'id' => 'c3050350-358c-4336-9ba2-da187fc443f5',
        'status' => 'successful',
        'type' => 'balance_records',
        'format' => 'xlsx',
        'engine' => 'oban',
        'attempt' => 1,
        'updated_at' => '2025-12-15T12:22:38.821314Z',
        'language' => 'en',
        'user_id' => 1098,
        'created_at' => '2025-12-15T12:22:38.821314Z',
        'psp_id' => 1,
        'generated_at' => '2025-12-15T12:22:55.605715Z',
        'expiry_date' => '2025-12-18T12:22:55.618136Z',
        'file_url' => 'https://s3.eu-west-1.amazonaws.com/wlsexports-test/app/local_vol/reports/c3050350-358c-4136-9ba2-da187fc443f5/report_balance_records_202412312100_202511302059_c3050350.zip?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAJBYIPDD7GHCZUBWQ%2F20251215%2Feu-west-1%2Fs3%2Faws4_request&X-Amz-Date=20251215T122255Z&X-Amz-Expires=259200&X-Amz-SignedHeaders=host&X-Amz-Signature=77e5f4e97f8544e26f90c75877df81167871b09736524f3110eabea1aa270f17',
        'notification_email' => 'test@test.com',
        'request_params' => {
          'currency' => 'USD',
          'shop_id' => 1673,
          'date_from' => '2024-12-31T21:00:00.000000Z',
          'date_to' => '2025-11-30T20:59:59.999999Z'
        }
      }
    }
  end

  def successful_create_report_response
    %({"data":#{successful_create_report_response_message.to_json}})
  end

  def successful_get_report_response
    %({"data":#{successful_get_report_message.to_json}})
  end
end
# rubocop:enable Metrics/MethodLength
