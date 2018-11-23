require 'rails_helper'

RSpec.describe Api::SubscriptionsController do
  let(:params) do
    {
      product: 1,
      shipping: {
        client_name: client_name,
        client_address: 'Oxford Street 1, London',
        client_zip_code: '12345'
      },
      billing: {
        card_number: card_number,
        exp_month: '01',
        exp_year: exp_year,
        cvv: cvv,
        zip_code: zip_code
      }
    }
  end
  let(:client_name) { 'John Doe' }
  let(:card_number) { '4242424242424242' }
  let(:exp_year) { '2024' }
  let(:cvv) { '123' }
  let(:zip_code) { '12345' }

  context 'with valid data', :vcr do
    it 'sets customer and payments status variables' do
      post '/api/subscriptions', params: params

      expect(assigns[:customer].id).to eq(1)
      expect(assigns[:customer].first_name).to eq('John')
      expect(assigns[:customer].last_name).to eq('Doe')
      expect(assigns[:payment_status][:subscription]).to be_present
      expect(assigns[:payment_status][:code]).to be_nil
    end

    it 'renders create page' do
      post '/api/subscriptions', params: params

      expect(response).to have_http_status(:success)
      expect(response).to render_template('create')
    end
  end

  context 'with no card data provided' do
    let(:card_number) { '' }

    it 'returns card invalid error' do
      post '/api/subscriptions', params: params

      expect(response).to redirect_to(root_url)
      expect(flash[:alert]).to eq('Credit card data not provided')
    end
  end

  context 'with no customer data provided' do
    let(:client_name) { '' }

    it 'returns card invalid error' do
      post '/api/subscriptions', params: params

      expect(response).to redirect_to(root_url)
      expect(flash[:alert]).to eq('Customer data not provided')
    end
  end

  context 'error', :vcr do
    context 'with invalid credit card number' do
      let(:card_number) { '4242424242424241' }

      it 'returns appropriate status code' do
        post '/api/subscriptions', params: params

        expect(assigns[:payment_status][:subscription]).not_to be_present
        expect(assigns[:payment_status][:code]).to eq(1000001)
      end
    end

    context 'with insufficient funds on card' do
      let(:card_number) { '4242424242420089' }

      it 'returns appropriate status code' do
        post '/api/subscriptions', params: params

        expect(assigns[:payment_status][:subscription]).not_to be_present
        expect(assigns[:payment_status][:code]).to eq(1000002)
      end
    end

    context 'with invalid cvv number' do
      let(:cvv) { '000' }

      it 'returns appropriate status code' do
        post '/api/subscriptions', params: params

        expect(assigns[:payment_status][:subscription]).not_to be_present
        expect(assigns[:payment_status][:code]).to eq(1000003)
      end
    end

    context 'with expired card' do
      let(:exp_year) { 2017 }

      it 'returns appropriate status code' do
        post '/api/subscriptions', params: params

        expect(assigns[:payment_status][:subscription]).not_to be_present
        expect(assigns[:payment_status][:code]).to eq(1000004)
      end
    end

    context 'with invalid zip code' do
      let(:zip_code) { '43-5000' }

      it 'returns appropriate status code' do
        post '/api/subscriptions', params: params

        expect(assigns[:payment_status][:subscription]).not_to be_present
        expect(assigns[:payment_status][:code]).to eq(1000005)
      end
    end
  end
end
