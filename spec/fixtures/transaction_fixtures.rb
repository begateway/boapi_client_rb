# frozen_string_literal: true

module TransactionFixtures
  module_function

  def successful_transactions_count_response_message
    { 'count' => 1486 }
  end

  def successful_transactions_count_response
    %({"data":#{successful_transactions_count_response_message.to_json}})
  end

  def failed_transactions_count_response_message
    { 'code' => 'unprocessable_entity',
      'friendly_message' => 'Filter is required.',
      'help' => 'https://doc.ecomcharge.com/codes/unprocessable_entity',
      'message' => 'Unprocessable entity' }
  end

  def failed_transactions_count_response
    %({"error":#{failed_transactions_count_response_message.to_json}})
  end

  # rubocop:disable Metrics/MethodLength
  def successful_transactions_list_response_message
    { 'pagination' => {
        'date_from' => '2023-02-20T09:02:54.516000Z', 'date_to' => '2023-02-20T11:13:43.748000Z',
        'date_type' => 'created_at', 'has_next_page' => true, 'next_date' => '2023-02-20T11:21:05.639000Z'
      },
      'transactions' => [
        { 'amount' => 200, 'created_at' => '2023-02-20T09:02:54.516000Z', 'currency' => 'BYN',
          'merchant_id' => 55, 'paid_at' => '2023-02-20T09:02:59.669000Z', 'shop_id' => 296,
          'status' => 'successful', 'type' => 'p2p', 'uid' => 'e4800e1b-fa21-4367-ae25-16f1eec8661f' },
        { 'amount' => 12_346, 'created_at' => '2023-02-20T09:36:15.175000Z', 'currency' => 'BYN',
          'merchant_id' => 1, 'paid_at' => '2023-02-20T09:36:15.994000Z', 'shop_id' => 142,
          'status' => 'failed', 'type' => 'payment', 'uid' => '5e499f43-74ca-4f95-a722-57dfc8e9adcc' },
        { 'amount' => 100, 'created_at' => '2023-02-20T11:13:43.748000Z', 'currency' => 'BYN',
          'merchant_id' => 55, 'paid_at' => nil, 'shop_id' => 296, 'status' => 'successful',
          'type' => 'tokenization', 'uid' => 'a1b993aa-d340-4d52-a0ce-92e5a30ab6a6' }
      ] }
  end
  # rubocop:enable Metrics/MethodLength

  def successful_transactions_list_response
    %({"data":#{successful_transactions_list_response_message.to_json}})
  end

  # rubocop:disable Metrics/MethodLength
  def successful_transactions_export_response_message
    {
      'transactions' => [
        {
          'amount' => 100, 'closed_at' => nil, 'code' => 'S.0000', 'converted_amount' => nil,
          'converted_currency' => nil, 'created_at' => '2024-11-01T08:58:46.705000Z', 'currency' => 'BYN',
          'description' => 'Test transaction p2ps LAA', 'expired_at' => nil, 'fraud' => '',
          'friendly_message' => 'Транзакция проведена успешно.', 'language' => 'ru',
          'manually_corrected_at' => nil, 'merchant_id' => 55, 'message' => 'Successfully processed',
          'paid_at' => '2024-11-01T08:58:50.589000Z', 'parent_uid' => nil, 'product_id' => nil,
          'reason' => nil, 'recurring_type' => nil, 'settled_at' => nil, 'shop_id' => 1990,
          'status' => 'successful', 'subscription_id' => nil, 'test' => false,
          'tracking_id' => 'tracking_id_000', 'type' => 'p2p', 'uid' => '6ca3d635-6841-4ac9-b583-a3bf0eafc160',
          'updated_at' => '2024-11-01T08:58:50.644000Z'
        }
      ],
      'pagination' => {
        'date_type' => 'created_at', 'has_next_page' => false, 'date_from' => '2024-11-01T08:58:46.705000Z',
        'date_to' => '2024-11-01T08:58:46.705000Z', 'uid_from' => '6ca3d635-6841-4ac9-b583-a3bf0eafc160',
        'uid_to' => '6ca3d635-6841-4ac9-b583-a3bf0eafc160'
      }
    }
  end
  # rubocop:enable Metrics/MethodLength

  def successful_transactions_export_response
    %({"data":#{successful_transactions_export_response_message.to_json}})
  end
end
