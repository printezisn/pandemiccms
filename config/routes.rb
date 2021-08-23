# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  Sidekiq::Web.use Rack::Auth::Basic, 'Protected Area' do |username, password|
    Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(username),
                               ::Digest::SHA256.hexdigest(Rails.application.credentials.sidekiq_ui[:username])) &
      Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(password),
                                 ::Digest::SHA256.hexdigest(Rails.application.credentials.sidekiq_ui[:password]))
  end
  mount Sidekiq::Web => '/sidekiq'

  scope '(:locale)', constraints: { locale: Regexp.new(FastGettext.available_locales.map { |l| "(#{l.tr('_', '-')})" }.join('|')) } do
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
      resources :menus do
        member do
          get :translate
          post :translate, to: 'menus#save_translation'
        end

        resources :menu_items, except: :index do
          member do
            get :translate
            post :translate, to: 'menu_items#save_translation'
          end
        end
      end
      resources :email_templates, only: %i[index show edit update] do
        member do
          get :translate
          post :translate, to: 'email_templates#save_translation'
          post :test
        end
      end
      resources :users do
        resources :posts, only: :index
        resources :pages, only: :index

        member do
          post :activate
          post :deactivate
          get :translate
          post :translate, to: 'users#save_translation'
        end
      end
      resources :redirects

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

      post 'cache/clear', to: 'cache#clear', as: :cache_clear
      post 'index/start', to: 'index#start', as: :index_start

      root 'dashboard#index'
    end

    get 'pg/:id/:slug', to: 'pages#show', as: :page
    get 'p/:id/:slug', to: 'posts#show', as: :post
    get 't/:id/:slug', to: 'tags#show', as: :tag
    get 'c/:id/:slug', to: 'categories#show', as: :category

    match '/404', to: 'errors#not_found', via: :all
    match '/500', to: 'errors#internal_server_error', via: :all

    root 'pages#index'
  end
end
