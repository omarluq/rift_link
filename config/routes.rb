# frozen_string_literal: true

Rails.application.routes.draw do
  # Authentication routes
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

  # Primary routes
  root 'home#index'

  # UI components routes
  get 'sidenav', to: 'home#sidenav'

  # Settings routes
  get 'settings', to: 'settings#index'
  get 'settings/profile', to: 'settings#profile'
  get 'settings/account', to: 'settings#account'
  get 'settings/sessions', to: 'settings#sessions'
  get 'settings/danger', to: 'settings#danger'

  patch 'settings/update_profile', to: 'settings#update_profile', as: 'update_profile'
  patch 'settings/update_account', to: 'settings#update_account', as: 'update_account'
  patch 'settings/update_privacy', to: 'settings#update_privacy', as: 'update_privacy'
  patch 'settings/update_notifications', to: 'settings#update_notifications', as: 'update_notifications'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', :as => :rails_health_check

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

  mount SolidQueueDashboard::Engine, at: '/solid-queue'
end
