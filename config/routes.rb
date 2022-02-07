Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    namespace :admin do
      resources :users do
        get 'export_table', on: :collection
        delete :avatar, on: :member, action: :destroy_avatar
      end
      resources :donations do
        get 'export_table', on: :collection
      end
      resources :projects do
        get 'export_table', on: :collection
        delete :images, on: :member, action: :destroy_avatar
      end

      root to: 'users#index'
    end
    
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
  
end
