Rails.application.routes.draw do
  devise_for :users
  get 'pages/home', to: 'pages#home', as: 'pages_home'
  root to: 'users#index'

  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    resources :bookings, only: [:index]
  end

  resources :psychologists do
    member do
      patch 'update_availabilities'
    end
    resources :availabilities, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    resources :reviews, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    resources :clientes, only: [:index]
  end

  resources :bookings, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :services, only: [:new, :create, :edit, :update] do
    member do
      patch :publish
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
