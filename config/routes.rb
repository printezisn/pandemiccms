# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)' do
    devise_for :admin_users

    namespace :admin do
      resources :media, only: %i[index create destroy]
      resources :tags do
        resources :posts, only: :index
        resources :pages, only: :index

        collection do
          get :search
        end

        member do
          get :translate
          post :translate, to: 'tags#save_translation'
        end
      end
      resources :categories do
        resources :posts, only: :index

        collection do
          get :tree
          get :search
        end

        member do
          get :translate
          post :translate, to: 'categories#save_translation'
        end
      end
      resources :pages do
        collection do
          get :tree
          get :search
        end

        member do
          post :publish
          get :translate
          post :translate, to: 'pages#save_translation'
        end
      end
      resources :posts do
        collection do
          get :search
        end

        member do
          post :publish
          get :translate
          post :translate, to: 'posts#save_translation'
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

      get 'profile', to: 'profile#index'
      get 'profile/edit', to: 'profile#edit', as: :profile_edit
      put 'profile/edit', to: 'profile#update'
      patch 'profile/edit', to: 'profile#update'
      get 'profile/translate', to: 'profile#translate'
      post 'profile/translate', to: 'profile#save_translation'

      get 'password/edit', to: 'password#edit', as: :password_edit
      put 'password/edit', to: 'password#update'
      patch 'password/edit', to: 'password#update'

      root 'dashboard#index'
    end

    get 'pg/:id/:slug', to: 'pages#show', as: :page
    get 'p/:id/:slug', to: 'posts#show', as: :post
    get 't/:id/:slug', to: 'tags#show', as: :tag
    get 'c/:id/:slug', to: 'categories#show', as: :category

    root 'pages#index'
  end
end
