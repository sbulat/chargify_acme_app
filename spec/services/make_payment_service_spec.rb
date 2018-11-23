require 'rails_helper'

RSpec.describe MakePaymentService, '#perform' do
  subject do
    described_class.new(card, product_id, customer_id)
  end

  let(:api_client) { double(FakepayApi::Client) }
  let(:card) { double(CreditCard) }
  let(:amount) { 1999 }
  let(:product_id) { 1 }
  let(:customer_id) { 1 }

  context 'success' do
    let(:token) { 'valid_token' }
    let(:api_response) { double(FakepayApi::Response, success?: true, token: token) }
    let(:subscription) { double(Subscription, product_id: 1, customer_id: 1, payment_token: token, billing_date: Date.current.next_month) }

    it 'returns hash with subscription' do
      allow(FakepayApi::Client).to receive(:new).with(
        card, amount
      ).and_return(api_client)
      allow(api_client).to receive(:send_request).and_return(api_response)
      allow(subject).to receive(:create_subscription).with(
        api_response.token
      ).and_return(subscription)

      result = subject.perform

      expect(result).to include(subscription: subscription)
      expect(result).not_to include(:code)
    end
  end

  context 'failure' do
    let(:api_response) { double(FakepayApi::Response, success?: false, error_code: 1000001) }

    it 'returns hash with error code' do
      allow(FakepayApi::Client).to receive(:new).with(
        card, amount
      ).and_return(api_client)
      allow(api_client).to receive(:send_request).and_return(api_response)

      result = subject.perform

      expect(result).not_to include(:subscription)
      expect(result).to include(code: 1000001)
    end
  end
end
