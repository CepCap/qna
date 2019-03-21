Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, except: %i[index]
  end

  root to: 'questions#index'
end
