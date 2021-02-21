# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)' do
    devise_for :admin_users

    namespace :admin do
      resources :media, only: %i[index create destroy]
      resources :tags do
        resources :posts, only: :index
        resources :pages, only: :index

        member do
          get :translate
          post :translate, to: 'tags#save_translation'
        end
      end
      resources :email_templates, only: %i[index show edit update] do
        member do
          get :translate
          post :translate, to: 'email_templates#save_translation'
          post :test
        end
      end
      resources :users, except: :destroy do
        resources :posts, only: :index
        resources :pages, only: :index

        member do
          post :activate
          post :deactivate
          get :translate
          post :translate, to: 'users#save_translation'
        end
      end

      get 'client/edit', to: 'clients#edit', as: :client_edit
      put 'client/edit', to: 'clients#update'
      patch 'client/edit', to: 'clients#update'

      root 'dashboard#index'
    end

    get 't/:id/:slug', to: 'tags#show', as: 'tag'

    root 'pages#index'
  end
end
