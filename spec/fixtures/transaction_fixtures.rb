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
end
