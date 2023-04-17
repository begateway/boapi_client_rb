# Boapi

Ruby api client for boapi service

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add boapi --git "git@github.com:begateway/boapi_client_rb.git"

or add to Gemfile manually

```
gem 'boapi', git: 'git@github.com:begateway/boapi_client_rb.git'
```

## Usage

Add config/initializers/boapi.rb

```
Boapi.configure do |c|
  c.api_host = 'https://example.com' # required
  c.proxy = URI::HTTP.build(host: env['PROXY_HOST'], port: env['PROXY_PORT']).to_s # optional
  c.timeout = 5 #faraday timeout, default: 5
  c.open_timeout = 10 #faraday open_timeout, default: 10
  c.faraday_options #faraday connection opts, ex {ssl: {verify: false}} # default: {}
end
```

Create client

`client = Boapi::Client.new(account_id: boapi_account_id, account_secret: boapi_account_secret)`

Make calls to boapi service

Health

```
> response = client.health
> response.status 
> 200
> response.success?
> true
> response.data
> {"click"=>true, "healthy"=>true, "pg"=>true, "rabbitmq"=>true, "redis"=>true, "version"=>"1.2.34"}
```

Currencies

```
> response = client.currencies
> response.status 
> 200
> response.success?
> true
> response.data
> ["BYN", "USD"]
```

Transactions count

```
> params = { filter: { date_from: '2023-01-20T00:00:00', date_to: '2023-03-22T00:00:00' } }
> response = client.transactions_count(params)
> response.status 
> 200
> response.success?
> true
> response.data
> {"count"=>1506}
```

Transactions list

```
> params = { filter: { date_from: '2023-01-20T00:00:00', date_to: '2023-03-22T00:00:00' }, options: { limit: 1 } }
> response = client.transactions_list(params)
> response.status 
> 200
> response.success?
> true
> response.data
> {"pagination"=>{"date_from"=>"2023-02-20T09:02:54.516000Z", "date_to"=>"2023-02-20T09:02:54.516000Z", "date_type"=>"created_at", "has_next_page"=>true, "next_date"=>"2023-02-20T09:36:15.175000Z"}, "transactions"=>[{"amount"=>123, "created_at"=>"2023-02-270T09:12:54.516000Z", "currency"=>"trx_cur", "merchant_id"=>123, "paid_at"=>"2023-02-12T09:02:59.669000Z", "shop_id"=>123, "status"=>"trx_status", "type"=>"trx_type", "uid"=>"xxxxxxx-fa21-xxxx-xxxx-xxxxeec8661f"}]}
```

Transactions list with response params

```
> params = params = { response_parameters: "query {transactions {uid shop_id provider_raw { ref_id } } }", filter: { date_from: '2023-01-20T00:00:00', date_to: '2023-03-22T00:00:00', date_type: 'paid_at' }, options: { limit: 1, time_zone: 'Europe/Berlin' } }
> response = client.transactions_list(params)
> response.status 
> 200
> response.success?
> true
> response.data
> {"pagination"=>{"date_from"=>"2023-02-20T09:02:59.669000Z", "date_to"=>"2023-02-20T09:02:59.669000Z", "date_type"=>"paid_at", "has_next_page"=>true, "next_date"=>"2023-02-20T09:36:15.994000Z"}, "transactions"=>[{"paid_at"=>"2023-02-20T09:12:34.567000Z", "provider_raw"=>{"ref_id"=>nil}, "shop_id"=>123, "uid"=>"e4800e1b-xxxx-xxxx-ae25-16f1xxxx661f"}]}
```

Errors

Unauthorized

```
> client = Boapi::Client.new(account_id: boapi_account_id, account_secret: wrong_boapi_account_secret)
> response = client.currencies
> response.success?
> false
> response.error?
> true
> response.status
> 401
> response.error
> {"code"=>"unauthorized", "friendly_message"=>"You can't have access to this area", "help"=>"https://doc.ecomcharge.com/codes/unauthorized", "message"=>"Unauthorized"}
```

Invalid params

```
> params = { filter: {date_to: '2023-03-22T00:00:00' }, options: { limit: 1 } }
> response = client.transactions_list(params)
> response.status 
> 422
> response.success?
> false
> response.error
> {"code"=>"unprocessable_entity", "friendly_message"=>"Date_from is required.", "help"=>"https://doc.ecomcharge.com/codes/unprocessable_entity", "message"=>"Unprocessable entity"}
```

Connection errors

```
> response = client.health
> response.status 
> 500
> response.success?
> false
> response.error
> {"code"=>"faraday_error", "friendly_message"=>"We're sorry, but something went wrong", "message"=>"Failed to open TCP connection to https://example.com (getaddrinfo: nodename nor servname provided, or not known)"}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/begateway/boapi_client_rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
