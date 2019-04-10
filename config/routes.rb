Rails.application.routes.draw do
  devise_for :users

  resources :attachments, only: %i[destroy]
  resources :links, only: %i[destroy]

  resources :questions do

    resources :answers, shallow: true, except: %i[index show] do
      patch :pick_best, on: :member
    end
  end

  root to: 'questions#index'
end
