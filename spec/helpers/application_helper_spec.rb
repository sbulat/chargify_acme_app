require 'rails_helper'

RSpec.describe 'ApplicationHelper' do
  describe '#error_message' do
    it 'returns corresponding message when status code is given' do
      aggregate_failures do
        expect(helper.error_message(1000001)).to eq('Invalid credit card number')
        expect(helper.error_message(1000002)).to eq('Insufficient funds')
        expect(helper.error_message(1000003)).to eq('CVV failure')
        expect(helper.error_message(1000004)).to eq('Expired card')
        expect(helper.error_message(1000005)).to eq('Invalid zip code')
        expect(helper.error_message(1000006)).to eq('Invalid purchase amount')
      end
    end
  end
end
