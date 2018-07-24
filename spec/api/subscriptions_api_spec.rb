require 'rails_helper'

RSpec.describe Api::SubscriptionsController, :type => :request do
  before(:all) do
    @form_data = {
      product: 1,
      shipping: {
        client_name: 'John Doe',
        client_address: 'Oxford Street 1, London',
        client_zip_code: '12345'
      },
      billing: {
        card_number: '4242424242424242',
        exp_month: '01',
        exp_year: '2024',
        cvv: '123',
        zip_code: '12345'
      }
    }
  end

  it 'should contain form with fields for subscription' do
    get '/'
    assert_select 'form.subscribe' do
      assert_select 'select[name=?]', 'product'
      assert_select 'input[name=?]', 'shipping[client_name]'
      assert_select 'input[name=?]', 'shipping[client_address]'
      assert_select 'input[name=?]', 'shipping[client_zip_code]'
      assert_select 'input[name=?]', 'billing[card_number]'
      assert_select 'input[name=?]', 'billing[exp_month]'
      assert_select 'input[name=?]', 'billing[exp_year]'
      assert_select 'input[name=?]', 'billing[cvv]'
      assert_select 'input[name=?]', 'billing[zip_code]'
    end
  end

  it 'should show success when valid data provided' do
    get '/'
    post '/api/subscriptions', params: @form_data
    assert_select 'p', text: 'Successfully created subscription!'
  end

  context 'with invalid credit card data' do
    it 'should show invalid credit card number' do
      get '/'
      local_data = @form_data.deep_dup
      local_data[:billing][:card_number] = '4242424242424241'

      post '/api/subscriptions', params: local_data
      assert_select 'p', text: 'Error occured: Invalid credit card number (1000001)'
    end

    it 'should show insufficient funds' do
      get '/'
      local_data = @form_data.deep_dup
      local_data[:billing][:card_number] = '4242424242420089'

      post '/api/subscriptions', params: local_data
      assert_select 'p', text: 'Error occured: Insufficient funds (1000002)'
    end

    it 'should show invalid cvv number' do
      get '/'
      local_data = @form_data.deep_dup
      local_data[:billing][:cvv] = '000'

      post '/api/subscriptions', params: local_data
      assert_select 'p', text: 'Error occured: CVV failure (1000003)'
    end

    it 'should show expired card' do
      get '/'
      local_data = @form_data.deep_dup
      local_data[:billing][:exp_year] = Date.current.year - 1

      post '/api/subscriptions', params: local_data
      assert_select 'p', text: 'Error occured: Expired card (1000004)'
    end

    it 'should show invalid zip code' do
      get '/'
      local_data = @form_data.deep_dup
      local_data[:billing][:zip_code] = '43-5000'

      post '/api/subscriptions', params: local_data
      assert_select 'p', text: 'Error occured: Invalid zip code (1000005)'
    end
  end
end
