Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :awards, only: %i[index]
  resources :votes, only: %i[create]
  resources :comments, only: %i[create]
  resources :oauth_email_confirmations, only: %i[new create]

  resources :questions do
    resources :answers, shallow: true, except: %i[index show] do
      patch :pick_best, on: :member
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
