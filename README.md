# Boapi

Ruby api client for boapi service.

## Installation

Install the gem and add to the application's Gemfile by executing:

```sh
$ bundle add boapi --git "git@github.com:begateway/boapi_client_rb.git"
```

or add to Gemfile manually

```
gem 'boapi', git: 'git@github.com:begateway/boapi_client_rb.git'
```

## Usage

Add config/initializers/boapi.rb

```ruby
Boapi.configure do |c|
  c.api_host = 'https://example.com' # required
  c.proxy = URI::HTTP.build(host: env['PROXY_HOST'], port: env['PROXY_PORT']).to_s # optional
  c.timeout = 5       # faraday timeout, default: 5
  c.open_timeout = 10 # faraday open_timeout, default: 10
  c.faraday_opts      # faraday connection opts, ex {ssl: {verify: false}}, default: {}
end
```

Create client

```ruby
client = Boapi::Client.new(account_id: boapi_account_id, account_secret: boapi_account_secret)
```

Make calls to boapi service

Health

```ruby
response = client.health
response.status   # 200
response.success? # true
response.data
# {"version"=>"1.0.16", "details"=>{"pg"=>true, "redis"=>true, "clickhouse"=>true, "rabbitmq"=>true}, "commit"=>"78dhdo8fd92v9499affw357dr8cd9g9vr71f84f4", "healthy"=>true}
```

Currencies

```ruby
response = client.currencies
response.status   # 200
response.success? # true
response.data     # ["BYN", "USD"]
```

Transactions count

```ruby
params = { filter: { date_from: '2023-01-20T00:00:00', date_to: '2023-03-22T00:00:00' } }
response = client.transactions_count(params)
response.status   # 200
response.success? # true
response.data     # {"count"=>1506}
```

Transactions list

```ruby
params = { filter: { date_from: '2023-01-20T00:00:00', date_to: '2023-03-22T00:00:00' }, options: { limit: 1 } }
response = client.transactions_list(params)
response.status   # 200
response.success? # true
response.data
# {"pagination"=>{"date_from"=>"2023-02-20T09:02:54.516000Z", "date_to"=>"2023-02-20T09:02:54.516000Z", "date_type"=>"created_at", "has_next_page"=>true, "next_date"=>"2023-02-20T09:36:15.175000Z"}, "transactions"=>[{"amount"=>123, "created_at"=>"2023-02-270T09:12:54.516000Z", "currency"=>"trx_cur", "merchant_id"=>123, "paid_at"=>"2023-02-12T09:02:59.669000Z", "shop_id"=>123, "status"=>"trx_status", "type"=>"trx_type", "uid"=>"xxxxxxx-fa21-xxxx-xxxx-xxxxeec8661f"}
```

Transactions list with response params

```ruby
params = { response_parameters: "query {transactions {uid shop_id provider_raw { ref_id } } }", filter: { date_from: '2023-01-20T00:00:00', date_to: '2023-03-22T00:00:00', date_type: 'paid_at' }, options: { limit: 1, time_zone: 'Europe/Berlin' } }
response = client.transactions_list(params)
response.status   # 200
response.success? # true
response.data
# {"pagination"=>{"date_from"=>"2023-02-20T09:02:59.669000Z", "date_to"=>"2023-02-20T09:02:59.669000Z", "date_type"=>"paid_at", "has_next_page"=>true, "next_date"=>"2023-02-20T09:36:15.994000Z"}, "transactions"=>[{"paid_at"=>"2023-02-20T09:12:34.567000Z", "provider_raw"=>{"ref_id"=>nil}, "shop_id"=>123, "uid"=>"e4800e1b-xxxx-xxxx-ae25-16f1xxxx661f"}]}
```

Transactions search with response params

```ruby
params = { response_parameters: "query {transactions {uid shop_id provider_raw { ref_id } } }", filter: { date_from: '2023-01-20T00:00:00', date_to: '2023-03-22T00:00:00', date_type: 'paid_at' }, options: { limit: 1, time_zone: 'Europe/Berlin' } }
response = client.transactions_search(params)
response.status   # 200
response.success? # true
response.data
# {"pagination"=>{"date_from"=>"2023-02-20T09:02:59.669000Z", "date_to"=>"2023-02-20T09:02:59.669000Z", "date_type"=>"paid_at", "has_next_page"=>true, "next_date"=>"2023-02-20T09:36:15.994000Z"}, "transactions"=>[{"paid_at"=>"2023-02-20T09:12:34.567000Z", "provider_raw"=>{"ref_id"=>nil}, "shop_id"=>123, "uid"=>"e4800e1b-xxxx-xxxx-ae25-16f1xxxx661f"}]}
```

Transactions deep search with response params

```ruby
params = { response_parameters: "query {transactions {uid shop_id provider_raw { ref_id } } }", filter: { date_from: '2023-01-20T00:00:00', date_to: '2023-03-22T00:00:00', date_type: 'paid_at' }, options: { limit: 1, time_zone: 'Europe/Berlin' } }
response = client.transactions_deep_search(params)
response.status   # 200
response.success? # true
response.data
# {"pagination"=>{"date_from"=>"2023-02-20T09:02:59.669000Z", "date_to"=>"2023-02-20T09:02:59.669000Z", "date_type"=>"paid_at", "has_next_page"=>true, "next_date"=>"2023-02-20T09:36:15.994000Z"}, "transactions"=>[{"paid_at"=>"2023-02-20T09:12:34.567000Z", "provider_raw"=>{"ref_id"=>nil}, "shop_id"=>123, "uid"=>"e4800e1b-xxxx-xxxx-ae25-16f1xxxx661f"}]}
```

Transactions export with response params

```ruby
params = { response_parameters: "main", filter: { date_from: '2024-11-01T00:00:00.000000', date_to: '2024-11-02T00:00:00.000000', date_type: 'created_at', type: 'p2p' }, options: { limit: 1, sort_direction: 'desc' } }
response = client.transactions_export(params)
response.status   # 200
response.success? # true
response.data
# {"data":{"pagination":{"date_type":"created_at","has_next_page":false,"date_from":"2024-11-01T08:58:46.705000Z","date_to":"2024-11-01T08:58:46.705000Z","uid_from":"6ca3d635-6841-4ac9-b583-a3bf0eafc160","uid_to":"6ca3d635-6841-4ac9-b583-a3bf0eafc160"},"transactions":[{"amount":100,"closed_at":null,"code":"S.0000","converted_amount":null,"converted_currency":null,"created_at":"2024-11-01T08:58:46.705000Z","currency":"BYN","description":"Testtransactionp2psLAA","expired_at":null,"fraud":"","friendly_message":"Транзакцияпроведенауспешно.","language":"ru","manually_corrected_at":null,"merchant_id":55,"message":"Successfullyprocessed","paid_at":"2024-11-01T08:58:50.589000Z","parent_uid":null,"product_id":null,"reason":null,"recurring_type":null,"settled_at":null,"shop_id":1990,"status":"successful","subscription_id":null,"test":false,"tracking_id":"tracking_id_000","type":"p2p","uid":"6ca3d635-6841-4ac9-b583-a3bf0eafc160","updated_at":"2024-11-01T08:58:50.644000Z"}]}}
```

Create rate

```ruby
params = { rate: { currency: "USD", created_at: "2023-05-29T17:12:10+03:00", apply_from: "2023-05-28T16:00:00+03:00", gateway_id: 1, rolling_reserve_days: 3 } }
response = client.create_rate(params)
response.data
# {"id"=>"53huht87-reh8-448t-8v78-b10f45hh672a", "currency"=>"USD", "created_at"=>"2023-05-29T14:12:10.000000Z", "gateway_id"=>1, "apply_from"=>"2023-05-28T13:00:00.000000Z", "rolling_reserve_days"=>3, "psp_capture_declined_fee"=>0 ...
```

Migrate rate

```ruby
params = { rate: { currency: "USD", created_at: "2023-05-29T17:12:10+03:00", apply_from: "2023-05-28T16:00:00+03:00", gateway_id: 1, rolling_reserve_days: 3 } }
response = client.migrate_rate(params)
response.data
# {"id"=>"53huht87-reh8-448t-8v78-b10f45hh672a", "currency"=>"USD", "created_at"=>"2023-05-29T14:12:10.000000Z", "gateway_id"=>1, "apply_from"=>"2023-05-28T13:00:00.000000Z", "rolling_reserve_days"=>3, "psp_capture_declined_fee"=>0 ...
```

Get rate

```ruby
id = '53huht87-reh8-448t-8v78-b10f45hh672a'
response = client.get_rate(id)
response.data
# {"id"=>"53huht87-reh8-448t-8v78-b10f45hh672a", "currency"=>"USD", "psp_capture_declined_fee"=>0, "psp_capture_max_commission"=>0, "psp_capture_min_commission"=>0, "psp_capture_successful_fee"=>0, "psp_void_declined_fee"=>0, "psp_void_max_commission"=>0, "psp_void_min_commission"=>0, "psp_void_successful_fee"=>0} ...
```

Rates list

```ruby
params = { currency: 'USD', gateway_id: 1 }
response = client.rates_list(params)
response.data
# {"rates"=>[{"id"=>"53huht87-reh8-448t-8v78-b10f45hh672a", "currency"=>"USD", "apply_from"=>"2023-05-28T13:00:00.000000Z"}, {"id"=>"7712h4sa-wl89-5i7i-96dy-e780921cra73", "currency"=>"USD", "apply_from"=>"2023-05-28T13:00:00.000000Z"}]}
```

Update rate

```ruby
id = "157fadb4-4122-4b9a-a6d3-ed13e074ca25"
params = { rate: { id: id, currency: "USD", created_at: "2023-05-29T17:12:10+03:00", apply_from: "2023-05-28T16:00:00+03:00", gateway_id: 1, rolling_reserve_days: 3 } }
client.create_rate(params)
updated_params = { rate: { currency: "EUR", rolling_reserve_days: 4, bank_capture_successful_rate: 1.75, bank_capture_declined_fee: 7 } }
response = client.update_rate(id, updated_params)
response.data
# {"id"=>"157fadb4-4122-4b9a-a6d3-ed13e074ca25", "currency"=>"EUR", "rolling_reserve_days"=>4, "bank_capture_successful_rate"=>"1.75",
"bank_capture_declined_fee"=>7 ...
```

Delete rate

```ruby
id = "c1e7595a-1af7-4d5f-9c0c-206542466859"
params = { rate: { id: id, currency: "USD", created_at: "2023-05-29T17:12:10+03:00", apply_from: "2023-05-28T16:00:00+03:00", gateway_id: 1, rolling_reserve_days: 3 } }
client.create_rate(params)
client.get_rate(id).data['id']
# c1e7595a-1af7-4d5f-9c0c-206542466859

response = client.delete_rate(id)
response.status
# 204
```

Preadjustments surcharge max with response params

```ruby
params = { transaction_type: 'payment', initial_amount: 1000, currency: 'BYN', gateway_ids: ['123', '12345'] }
response = client.preadjustments_surcharges_max(params)
response.status   # 200
response.success? # true
response.data
# {'code' => 'S.0000', 'message' => 'Success.', 'friendly_message' => 'Request is successsfully processed.', 'data' => { 'id' => 'rt4t45-345tgrg-4tgrgrgb', 'created_at' => '2024-05-24T23:23:23.456789', 'type' => 'surcharge_max', 'transaction_type' => 'payment', 'currency' => 'BYN', 'initial_amount' => 1000, 'amount' => 50, 'info' => {'surchant_max_amount' => 50, 'raw_calculations' => [{ 'gateway_id' => 123, 'rate_id' => 50, 'calculated_value' => 45, 'error' => nil }, { 'gateway_id' => 12345, 'rate_id' => nil, 'calculated_value' => nil, 'error' => 'rate_not_found' }]}}}
```

Create balance_record (adjustment type only)

```ruby
params = { balance_record: { merchant_id: 12, shop_id: 23, gateway_id: 34, type: 'adjustment', amount: 1000, currency: 'EUR', description: 'Balance debit', user_id: 45 } }
client.create_balance_record(params)
response.data
# {"balance_record"=>{"merchant_id"=>12, "shop_id"=>23, "gateway_id"=>34, "amount"=>1000, "currency"=>"EUR", "description"=>"[UserID:45] Balance debit", "type"=>"adjustment"}}
```

Get psp balances

```ruby
params = { merchant_id: 47, currency: 'BYN', as_of_date: '2024-09-13T00:00:00.145823Z' }
client.psp_balances(params)
response.data
# {"balances"=>{"generated_at"=>"2024-08-30T13:02:00Z", "as_of_date"=>"2024-09-13T00:00:00.145823Z", "currencies"=>[{"currency"=>"BYN", "merchants"=>[{"id"=>47, "company_name"=>"John Deere LTD", "available_balance"=>100, "shops"=>[{"id"=>10, "name"=>"Best shop", "available_balance"=>50, "gateways"=>[{ ...
```

Get merchant balances

```ruby
id = 47
params = { currency: 'BYN', as_of_date: '2024-09-13T00:00:00.145823Z' }
client.merchant_balances(id, params)
response.data
# {"balances"=>{"generated_at"=>"2024-08-30T13:02:00Z", "as_of_date"=>"2024-09-13T00:00:00.145823Z", "currencies"=>[{"currency"=>"BYN", "merchants"=>[{"id"=>47, "company_name"=>"John Deere LTD", "available_balance"=>100, "shops"=>[{ ...
```

Create report
```ruby
params = { user_id: 1, type: 'balance_records_report', format: 'csv', 
           request_params: { currency: 'USD', merchant_id: 12, date_from: '2025-01-01T00:00:00', date_to: '2025-03-16T23:59:59' } }
client.create_report(params)
response.data
# "{\"data\":{\"report\":{\"id\":\"961c3be2-c7b0-44ab-9f79-48cabd30c519\",\"status\":\"pending\",\"type\":\"balance_records_report\",\"format\":\"csv\",\"engine\":\"oban\",\"user_id\":1,\"language\":\"en\",\"updated_at\":\"2025-06-25T13:41:38.976093Z\",\"created_at\":\"2025-06-25T13:41:38.976093Z\",\"psp_id\":1,\"generated_at\":null,\"expiry_date\":null,\"file_url\":null,\"notification_email\":null,\"request_params\":{...}}}}"
```

## Errors

Unauthorized

```ruby
client = Boapi::Client.new(account_id: boapi_account_id, account_secret: wrong_boapi_account_secret)
response = client.currencies
response.success? # false
response.error?   # true
response.status   # 401
response.error
# {"code"=>"unauthorized", "friendly_message"=>"You can't have access to this area", "help"=>"https://doc.ecomcharge.com/codes/unauthorized", "message"=>"Unauthorized"}
```

Invalid params

```ruby
params = { filter: {date_to: '2023-03-22T00:00:00' }, options: { limit: 1 } }
response = client.transactions_list(params)
response.status   # 422
response.success? # false
response.error
# {"code"=>"unprocessable_entity", "friendly_message"=>"Date_from is required.", "help"=>"https://doc.ecomcharge.com/codes/unprocessable_entity", "message"=>"Unprocessable entity"}
```

Connection errors

```ruby
response = client.health
response.status   # 500
response.success? # false
response.error
# {"code"=>"faraday_error", "friendly_message"=>"We're sorry, but something went wrong", "message"=>"Failed to open TCP connection to https://example.com (getaddrinfo: nodename nor servname provided, or not known)"}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/begateway/boapi_client_rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
