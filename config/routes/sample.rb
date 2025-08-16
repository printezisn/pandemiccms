# frozen_string_literal: true

get 'pg/:id/:slug', to: 'pages#show', as: :sample_page
get 'p/:id/:slug', to: 'posts#show', as: :sample_post
get 't/:id/:slug', to: 'tags#show', as: :sample_tag
get 'c/:id/:slug', to: 'categories#show', as: :sample_category
