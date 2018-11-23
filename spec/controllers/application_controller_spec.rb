require 'rails_helper'

RSpec.describe ApplicationController do
  describe '#index' do
    it 'renders index page' do
      get :index

      expect(response).to have_http_status(:success)
      expect(response).to render_template('index')
    end
  end
end
