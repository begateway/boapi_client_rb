# frozen_string_literal: true

require 'boapi'
require 'webmock/rspec'

require 'fixtures/support_fixtures'
require 'fixtures/currency_fixtures'
require 'fixtures/rate_fixtures'
require 'fixtures/transaction_fixtures'
require 'fixtures/balance_fixtures'
require 'fixtures/balance_record_fixtures'
require 'fixtures/report_fixtures'

WebMock.disable_net_connect!(allow_localhost: false)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
