Rails.application.routes.draw do
  post '/api/subscriptions', to: 'api/subscriptions#create', as: 'api_create_subscriptions'
  # get '/response', to: 'application#response', as: 'response'

  root to: 'application#index'
end
