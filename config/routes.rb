Rails.application.routes.draw do
  devise_for :users

  root to: "pages#home"

  resources :users, only: [:index, :show, :edit, :update, :destroy]
  resources :psychologists do
    resources :availabilities, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    resources :reviews, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end

  resources :bookings, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :users, only: [:index]
  resources :bookings
  get "up" => "rails/health#show", as: :rails_health_check
end
