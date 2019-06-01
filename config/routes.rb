require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  resources :attachments, only: %i[destroy]
  resources :subscriptions, only: %i[create destroy]
  resources :links, only: %i[destroy]
  resources :awards, only: %i[index]
  resources :votes, only: %i[create]
  resources :comments, only: %i[create]
  resources :oauth_email_confirmations, only: %i[new create]

  resources :searches, only: %i[index create] do
    get :result, on: :collection
  end

  resources :questions do
    resources :answers, shallow: true, except: %i[index show] do
      patch :pick_best, on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, except: %i[new, edit] do
        resources :answers, shallow: true, except: %i[new, edit]
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
