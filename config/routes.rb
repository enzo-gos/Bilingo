require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :example, only: [:index, :show]
    end
  end

  devise_for :users,
  controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  available_locales = -> { I18n.available_locales.map(&:to_s).join('|') }
  scope "(:locale)", locale: Regexp.new(available_locales.call) do
    namespace :auth do
      get 'sign-in'
      get 'sign-up'
    end

    get 'share' => 'share#index'

    get 'profile' => 'profiles#index'

    namespace :writer do
      resources :stories do
        resources :chapters do
        end
      end
    end

    root 'home#index'
  end
end
