# frozen_string_literal: true

module CurrencyResponseFixtures
  module_function

  def successful_currencies_response
    %({"data":#{successful_currencies_response_message.to_json}})
  end

  def successful_currencies_response_message
    %w[BYN USD]
  end
end
