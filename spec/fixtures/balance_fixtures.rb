# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
module BalancesFixtures
  module_function

  def successful_merchant_balances_for_psp_response_message
    {
      'balances' => {
        'generated_at' => '2024-08-30T13:02:00Z',
        'as_of_date' => '2024-09-13T00:00:00.145823Z',
        'currency' => 'BYN',
        'merchant' => {
          'id' => 47,
          'company_name' => 'John Deere LTD',
          'available_balance' => 300,
          'shops' => [
            {
              'id' => 1,
              'name' => 'Demo Shop 1',
              'available_balance' => 200,
              'gateways' => [
                { 'id' => 2, 'type' => 'AlternativeBank', 'available_balance' => 100 },
                { 'id' => 1, 'type' => 'MTVBank', 'available_balance' => 100 }
              ]
            },
            {
              'id' => 2,
              'name' => 'Demo Shop 2',
              'available_balance' => 100,
              'gateways' => [
                { 'id' => 2, 'type' => 'AlternativeBank', 'available_balance' => 100 }
              ]
            }
          ]
        }
      }
    }
  end

  def successful_merchant_balances_for_psp_response
    %({"data":#{successful_merchant_balances_for_psp_response_message.to_json}})
  end

  def successful_merchant_balances_response_message
    {
      'balances' => {
        'generated_at' => '2024-08-30T13:02:00Z',
        'as_of_date' => '2024-09-13T00:00:00.145823Z',
        'currency' => 'BYN',
        'merchant' => {
          'id' => 47,
          'company_name' => 'John Deere LTD',
          'available_balance' => 300,
          'shops' => [
            { 'id' => 1, 'name' => 'Demo Shop 1', 'available_balance' => 200 },
            { 'id' => 2, 'name' => 'Demo Shop 2', 'available_balance' => 100 }
          ]
        }
      }
    }
  end

  def successful_merchant_balances_response
    %({"data":#{successful_merchant_balances_response_message.to_json}})
  end
end
# rubocop:enable Metrics/MethodLength
