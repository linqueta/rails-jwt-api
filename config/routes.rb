# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index update]
      post '/auth/login', to: 'authentication#login'
      delete '/auth/logout', to: 'authentication#logout'
    end
  end
end
