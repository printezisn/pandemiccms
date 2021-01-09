# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)' do
    devise_for :admin_users

    namespace :admin do
      resources :media, only: %i[index create destroy]
      resources :tags

      get 'tags/:id/posts', to: 'tags#posts', as: :tag_posts
      get 'tags/:id/pages', to: 'tags#pages', as: :tag_pages

      root 'dashboard#index'
    end

    get 't/:id/:slug', to: 'tags#show', as: 'tag'

    root 'pages#index'
  end
end
