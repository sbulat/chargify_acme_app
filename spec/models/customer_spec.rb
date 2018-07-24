require 'rails_helper'

RSpec.describe Customer, type: :model do
  context 'when given all shipping data' do
    it 'should create a customer' do
      shipping_info = {
        client_name: 'John Doe',
        client_address: 'Oxford Street 1, London',
        client_zip_code: '12345'
      }
      customer = Customer.new
      customer.shipping_info = shipping_info
      customer.save

      expect(customer.persisted?).to eq(true)
    end
  end

  context 'when given no shipping info' do
    it 'should not create a customer' do
      shipping_info = {
        client_name: '',
        client_address: '',
        client_zip_code: ''
      }
      customer = Customer.new
      customer.shipping_info = shipping_info
      customer.save

      expect(customer.persisted?).to eq(false)
    end
  end
end
