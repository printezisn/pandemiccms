# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admin_users

  namespace :admin do
    root 'dashboard#index'
  end

  root 'pages#index'
end
