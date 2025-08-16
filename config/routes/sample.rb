# frozen_string_literal: true

get 'pg/:id/:slug', to: 'pages#show', as: :page
get 'p/:id/:slug', to: 'posts#show', as: :post
get 't/:id/:slug', to: 'tags#show', as: :tag
get 'c/:id/:slug', to: 'categories#show', as: :category
