class MakePaymentService
  def initialize(card, product_id, customer_id)
    @card = card
    @amount = Product.find(product_id).price
    @product_id = product_id
    @customer_id = customer_id
  end

  def perform
    api_client = FakepayApi::Client.new(@card, @amount)
    api_response = api_client.send_request

    if api_response.success?
      { subscription: create_subscription(api_response.token) }
    else
      { code: api_response.error_code }
    end
  end

  private

  attr_reader :product_id, :customer_id

  def create_subscription(token)
    subscription = Subscription.new(
      product_id: product_id,
      customer_id: customer_id,
      payment_token: token,
      billing_date: Date.current.next_month
    )

    subscription.save
    subscription
  end
end
