# frozen_string_literal: true

require_relative 'template_constraint'

Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: '/jobs'

  scope '(:locale)', constraints: { locale: Regexp.new(Rails.application.config.available_languages.pluck(:locale).join('|')) } do
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
        resources :contents, only: :index

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
      resources :contents do
        member do
          get :translate
          post :translate, to: 'contents#save_translation'
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

      post 'cache/clear', to: 'cache#clear', as: :cache_clear
      post 'index/start', to: 'index#start', as: :index_start

      get 'dashboard/page_visits', to: 'dashboard#page_visits', as: :dashboard_page_visits

      root 'dashboard#index'
    end

    namespace :super_admin do
      resources :clients
    end

    match '/404', to: 'errors#not_found', via: :all
    match '/500', to: 'errors#internal_server_error', via: :all

    post '/analytics/track_visit', to: 'analytics#track_visit'

    constraints(TemplateConstraint.new('sample')) do
      get 'pg/:id/:slug', to: 'pages#show', as: :sample_page
      get 'p/:id/:slug', to: 'posts#show', as: :sample_post
      get 't/:id/:slug', to: 'tags#show', as: :sample_tag
      get 'c/:id/:slug', to: 'categories#show', as: :sample_category
      get '/sitemap.xml', to: 'seo#sitemap', format: 'xml', as: :sample_sitemap
      get '/robots.txt', to: 'seo#robots', format: 'text', as: :sample_robots
      get '/manifest.webmanifest', to: 'seo#manifest', format: 'json', as: :sample_manifest
    end

    root 'pages#index'
  end
end
