module FakepayApi
  class Response
    attr_reader :response_hash, :token, :error_code

    def initialize(http_response)
      @response_hash = JSON.parse(http_response.body)
      @token = @response_hash['token']
      @error_code = @response_hash['error_code']
    end

    def success?
      response_hash['success']
    end
  end
end
