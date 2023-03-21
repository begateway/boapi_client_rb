# frozen_string_literal: true

module Boapi
  class Response
    attr_reader :raw_response

    def initialize(response)
      @raw_response = response
    end

    def data
      raw_response.body['data']
    end

    def error
      raw_response.body['error']
    end

    def success?
      raw_response.success?
    end

    def error?
      !success?
    end

    def status
      raw_response.status
    end

    def raw
      raw_response
    end
  end
end
