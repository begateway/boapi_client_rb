# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
module BalanceRecordFixtures
  module_function

  def successful_create_balance_record_response_message
    {
      'balance_record' => {
        'merchant_id' => 12,
        'shop_id' => 23,
        'gateway_id' => 34,
        'amount' => 1000,
        'currency' => 'EUR',
        'description' => '[UserID:45] Balance debit',
        'type' => 'adjustment'
      }
    }
  end

  def successful_create_balance_record_response
    %({"data":#{successful_create_balance_record_response_message.to_json}})
  end
end
# rubocop:enable Metrics/MethodLength
