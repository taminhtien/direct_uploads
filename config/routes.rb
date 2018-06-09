# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  resources :posts
  namespace :admin do
    resources :users
    resources :announcements
    resources :notifications
    resources :services

    root to: 'users#index'
  end
  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'
  resources :notifications, only: [:index]
  resources :announcements, only: [:index]
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'posts#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
