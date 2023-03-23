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

    attr_accessor :api_host, :proxy, :adapter, :logger

    def initialize
      @api_host = DEFAULT_API_HOST
      @proxy = nil
      @adapter = Faraday.default_adapter
      @logger = Logger.new($stdout)
    end
  end
end
