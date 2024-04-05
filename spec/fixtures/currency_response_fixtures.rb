# frozen_string_literal: true

module CurrencyResponseFixtures
  module_function

  def successful_currencies_response
    %({"data":["BYN", "USD"]})
  end

  def successful_currencies_response_message
    %w[BYN USD]
  end
end
