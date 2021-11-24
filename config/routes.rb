Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :projects

    resources :projects do 
      resources :donations
    end

end
