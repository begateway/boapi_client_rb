# frozen_string_literal: true

module SupportFixtures
  module_function

  def health_response_message
    { 'click' => true, 'healthy' => true, 'pg' => true, 'rabbitmq' => true, 'redis' => true, 'version' => '0.2.13' }
  end

  def health_response
    %({"data":#{health_response_message.to_json}})
  end

  def failed_without_authentification_response_message
    { 'code' => 'unauthorized',
      'friendly_message' => "You can't have access to this area",
      'help' => 'https://doc.ecomcharge.com/codes/unauthorized',
      'message' => 'Unauthorized' }
  end

  def failed_without_authentification_response
    %({"error":#{failed_without_authentification_response_message.to_json}})
  end
end
