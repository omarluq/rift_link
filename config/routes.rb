# frozen_string_literal: true

Rails.application.routes.draw do
  get  'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get  'sign_up', to: 'registrations#new'
  post 'sign_up', to: 'registrations#create'
  resources :sessions, only: [:index, :show, :destroy]
  resource  :password, only: [:edit, :update]
  namespace :identity do
    resource :email,              only: [:edit, :update]
    resource :email_verification, only: [:show, :create]
    resource :password_reset,     only: [:new, :edit, :create, :update]
  end
  root 'home#index'
  # config/routes.rb - add to the existing routes
  get 'settings', to: 'home#settings', as: 'settings'
  get 'sidenav', to: 'home#sidenav'
  patch 'update_profile', to: 'home#update_profile', as: 'update_profile'
  patch 'update_account', to: 'home#update_account', as: 'update_account'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  resources :realms do
    resources :channels do
      resources :messages, only: [:index, :create, :update, :destroy]
    end
    resources :events
    resources :memberships, only: [:index, :create, :update, :destroy]
  end

  # Direct messages
  resources :direct_message_threads, path: 'messages' do
    resources :messages, only: [:index, :create, :update, :destroy]
  end

  # Explore
  get 'explore/realms', to: 'explore#realms'
  get 'explore/users', to: 'explore#users', as: 'users'
  get 'explore/games', to: 'explore#games', as: 'games'

  # User related
  get 'settings', to: 'users#edit'
  patch 'settings', to: 'users#update'
  get 'profile', to: 'users#show'

  # Friends
  resources :friends, only: [:index, :create, :destroy] do
    collection do
      get 'requests'
      post 'accept/:id', to: 'friends#accept', as: 'accept'
      post 'reject/:id', to: 'friends#reject', as: 'reject'
    end
  end

  # Notifications
  resources :notifications, only: [:index, :update, :destroy] do
    collection do
      post 'mark_all_read'
    end
  end
  # Defines the root path route ("/")
  # root 'home#show'
end
