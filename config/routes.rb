Rails.application.routes.draw do
  namespace :admin do
    resources :users do
      delete :avatar, on: :member, action: :destroy_avatar
    end
    resources :donations
    resources :projects do
      delete :images, on: :member, action: :destroy_avatar
    end

    root to: 'users#index'
  end

  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'home#index'

  resources :projects, only: :show do
    resources :donations, only: :create
  end
  resources :users, only: :donations do
    get '/donations', to: 'users#donations', as: :donations
  end

end
