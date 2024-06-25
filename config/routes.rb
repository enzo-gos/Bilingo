require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :example, only: [:index, :show]
      namespace :meta_data do
        get 'tags'
      end
    end
  end

  devise_for :users,
  controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  available_locales = -> { I18n.available_locales.map(&:to_s).join('|') }
  scope '(:locale)', locale: Regexp.new(available_locales.call) do
    namespace :auth do
      get 'sign-in'
      get 'sign-up'
    end

    get 'share/:id' => 'share#index', as: :share

    get 'profile' => 'profiles#index'

    namespace :writer do
      namespace :stories do
        get 'all'
      end
      resources :stories, except: [:show] do
        member do
          patch :order
          patch :unpublish_all
        end
        resources :chapters, except: [:new, :show] do
          member do
            patch :order
            patch :publish
            patch :unpublish
          end
        end
      end
    end

    resources :stories, only: [:index, :show] do
      resources :chapters, only: [:show] do
        member do
          get :rephrase
        end
      end
    end

    root 'home#index'
  end
end
