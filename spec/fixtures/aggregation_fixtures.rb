# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
module AggregationFixtures
  module_function

  def successful_create_aggregation_response_message
    {
      'grouped_data' => [
        {
          'count' => 6,
          'currency' => 'BYN',
          'gateway_type' => 'Bapb',
          'status' => 'successful',
          'type' => 'payment',
          'volume' => 5
        },{
          'count' => 9,
          'currency' => 'BYN',
          'gateway_type' => 'Bgpb',
          'status' => 'successful',
          'type' => 'p2p',
          'volume' => 29.23
        },{
          'count' => 1,
          'currency' => 'BYN',
          'gateway_type' => 'Bgpb',
          'status' => 'failed',
          'type' => 'payment',
          'volume' => 5
        },{
          'count' => 1,
          'currency' => 'USD',
          'gateway_type' => 'Bgpb',
          'status' => 'failed',
          'type' => 'payment',
          'volume' => 5.93
        },{
          'count' => 3,
          'currency' => 'BYN',
          'gateway_type' => 'Bgpb',
          'status' => 'incomplete',
          'type' => 'p2p',
          'volume' => 0.3
        },{
          'count' => 57,
          'currency' => 'BYN',
          'gateway_type' => 'Bgpb',
          'status' => 'failed',
          'type' => 'p2p',
          'volume' => 486.1
        }
      ],
      'total_count' => 46892
    }
  end

  def successful_create_aggregation_response
    %({"data":#{successful_create_aggregation_response_message.to_json}})
  end
end
# rubocop:enable Metrics/MethodLength
