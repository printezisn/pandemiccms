# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)' do
    devise_for :admin_users

    namespace :admin do
      resources :media, only: %i[index create destroy]
      resources :tags

      root 'dashboard#index'
    end

    root 'pages#index'
  end
end
