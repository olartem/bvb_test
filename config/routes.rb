Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    

    
    root 'home#index'
    devise_for :users, skip: :omniauth_callbacks, controllers: { registrations: 'users/registrations' }
    resources :projects, only: :show do
      resources :donations, only: :create
    end
    resources :users, only: :donations do
      get '/donations', to: 'users#donations', as: :donations
    end
  end
  devise_for :users, skip: [:session, :password, :registration], controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
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
end
