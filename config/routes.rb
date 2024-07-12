Rails.application.routes.draw do
  devise_for :users

  root to: 'pages#home'

  get 'pages/home', to: 'pages#home', as: 'pages_home'
  get 'pages/update_dates', to: 'pages#update_dates', as: 'pages_update_dates'

  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    member do
      get 'medical_record'
      patch 'update_medical_record'
    end
    resources :bookings, only: [:index]
  end

  resources :psychologists, only: [:new, :create, :show, :edit, :update, :destroy] do
    member do
      patch 'update_availabilities'
      get 'load_availabilities'
      get 'user_requests'
    end
    resources :availabilities, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    resources :reviews, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    resources :clientes, only: [:index]
  end

  resources :bookings, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    resources :messages, only: [:create]
  end
  resources :services, only: [:new, :create, :edit, :update] do
    member do
      patch :publish
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
