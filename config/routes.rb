Rails.application.routes.draw do
  namespace :admin do
      resources :users
      resources :donations
      resources :projects

      root to: "users#index"
    end
  devise_for :users
  root 'home#index'
  resources :projects

    resources :projects do 
      resources :donations
    end

end
