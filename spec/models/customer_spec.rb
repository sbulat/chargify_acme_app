require 'rails_helper'

RSpec.describe Customer do
  let(:shipping_info) do
    { client_name: 'John Doe', client_address: 'Oxford Street 1, London', client_zip_code: '12345' }
  end
  let(:customer) { described_class.new { |customer| customer.shipping_info = shipping_info } }

  describe '#shipping_info=' do
    it 'splits full name properly' do
      expect(customer.first_name).to eq('John')
      expect(customer.last_name).to eq('Doe')
    end

    it 'assigns client address' do
      expect(customer.address).to eq('Oxford Street 1, London')
    end

    it 'assigns client address' do
      expect(customer.shipping_zip_code).to eq('12345')
    end
  end

  context 'when all shipping info provided' do
    it 'should create a customer' do
      expect(customer.save).to eq(true)
      expect(customer.persisted?).to eq(true)
      expect(customer.id).to eq(1)
    end
  end

  context 'when some shipping info is missing' do
    context 'with empty client_name' do
      let(:shipping_info) { { client_name: '', client_address: 'Oxford Street 1, London', client_zip_code: '12345' } }

      it 'should not create a customer' do
        expect(customer.save).to eq(false)
        expect(customer.persisted?).to eq(false)
        expect(customer.id).to be_nil
      end
    end

    context 'with empty client_address' do
      let(:shipping_info) { { client_name: 'John Doe', client_address: '', client_zip_code: '12345' } }

      it 'should not create a customer' do
        expect(customer.save).to eq(false)
        expect(customer.persisted?).to eq(false)
        expect(customer.id).to be_nil
      end
    end

    context 'with empty client_zip_code' do
      let(:shipping_info) { { client_name: 'John Doe', client_address: 'Oxford Street 1, London', client_zip_code: '' } }

      it 'should not create a customer' do
        expect(customer.save).to eq(false)
        expect(customer.persisted?).to eq(false)
        expect(customer.id).to be_nil
      end
    end
  end
end
