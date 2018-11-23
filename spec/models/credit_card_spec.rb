require 'rails_helper'

RSpec.describe 'CreditCard' do
  let(:billing_info) do
    {
      card_number: card_number,
      exp_month: exp_month,
      exp_year: exp_year,
      cvv: cvv,
      zip_code: zip_code
    }
  end
  let(:card_number) { '4242424242424242' }
  let(:exp_month) { '01' }
  let(:exp_year) { '2024' }
  let(:cvv) { '123' }
  let(:zip_code) { '12345' }
  let(:credit_card) { CreditCard.new(billing_info) }

  describe '#new' do
    it 'assigns all parameters from billing info hash' do
      expect(credit_card.number).to eq('4242424242424242')
      expect(credit_card.exp_month).to eq('01')
      expect(credit_card.exp_year).to eq('2024')
      expect(credit_card.cvv).to eq('123')
      expect(credit_card.zip_code).to eq('12345')
    end
  end

  describe 'valid?' do
    context 'with all parameters valid' do
      it 'returns true' do
        expect(credit_card.valid?).to be_truthy
      end
    end

    context 'with card number not present' do
      let(:card_number) { '' }

      it 'returns false' do
        expect(credit_card.valid?).to be_falsey
      end
    end

    context 'with expiration month not present' do
      let(:exp_month) { '' }

      it 'returns false' do
        expect(credit_card.valid?).to be_falsey
      end
    end

    context 'with expiration year not present' do
      let(:exp_year) { '' }

      it 'returns false' do
        expect(credit_card.valid?).to be_falsey
      end
    end

    context 'with cvv not present' do
      let(:cvv) { '' }

      it 'returns false' do
        expect(credit_card.valid?).to be_falsey
      end
    end

    context 'with zip code not present' do
      let(:zip_code) { '' }

      it 'returns false' do
        expect(credit_card.valid?).to be_falsey
      end
    end
  end
end
