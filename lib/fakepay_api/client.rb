module FakepayApi
  class Client
    attr_reader :card, :amount, :uri

    def initialize(card, amount)
      @card = card
      @amount = amount
      @uri = URI.parse('https://www.fakepay.io/purchase')
    end

    def send_request
      response = http_object.request(post_request)
      Response.new(response)
    end

    private

    def http_object
      Net::HTTP.new(uri.host, uri.port).tap do |http|
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    end

    def post_request
      Net::HTTP::Post.new(uri.request_uri, headers).tap do |req|
        req.body = json_body
      end
    end

    def headers
      {
        'Authorization' => "Token token=#{ENV['FAKEPAY_API_KEY']}",
        'Content-Type' => 'application/json'
      }
    end

    def json_body
      {
        amount: amount,
        card_number: card.number,
        cvv: card.cvv,
        expiration_month: card.exp_month,
        expiration_year: card.exp_year,
        zip_code: card.zip_code
      }.to_json
    end
  end
end
