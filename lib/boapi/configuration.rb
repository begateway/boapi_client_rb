# frozen_string_literal: true

require 'logger'

module Boapi
  def self.configure
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  class Configuration
    DEFAULT_API_HOST = 'http://localhost:4001'

    attr_accessor :api_host, :proxy, :adapter, :logger, :timeout, :open_timeout, :faraday_opts

    def initialize
      @api_host = DEFAULT_API_HOST
      @proxy = nil
      @adapter = Faraday.default_adapter
      @logger = Logger.new($stdout)
      @timeout = 5
      @open_timeout = 10
      @faraday_opts = {}
    end
  end
end
