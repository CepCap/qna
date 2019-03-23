Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, except: %i[index show] do
      patch :pick_best, on: :member
    end
  end

  root to: 'questions#index'
end
