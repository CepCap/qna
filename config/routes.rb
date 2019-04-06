Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    patch :delete_file, on: :member
    
    resources :answers, shallow: true, except: %i[index show] do
      patch :pick_best, on: :member
      patch :delete_file, on: :member
    end
  end

  root to: 'questions#index'
end
