require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  get 'up' => 'rails/health#show', as: :rails_health_check

  devise_for :users,
  controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  namespace :auth do
    get 'sign-in'
    get 'sign-up'
  end

  get 'profile' => 'profiles#index'

  namespace :api do
    namespace :v1 do
      resources :example, only: [:index, :show]
    end
  end

  root 'home#index'
end
