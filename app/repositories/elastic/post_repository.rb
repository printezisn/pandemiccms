# frozen_string_literal: true

module Elastic
  # Repository for storing posts in elasticsearch
  class PostRepository
    include Elasticsearch::Persistence::Repository

    attr_reader :client_id, :locale

    def index_name
      "posts_#{client_id}_#{locale}_#{Rails.env}".downcase
    end

    def klass
      ::Elastic::Post
    end

    def client
      Elasticsearch::Client.new(
        url: Rails.application.credentials.elasticsearch[:url],
        log: Rails.env.development?,
        user: Rails.application.credentials.elasticsearch[:username],
        password: Rails.application.credentials.elasticsearch[:password]
      )
    end

    def initialize(client_id, locale)
      super({})

      @client_id = client_id
      @locale = locale

      settings number_of_shards: 1 do
        mapping dynamic: 'strict' do
          indexes :id, type: 'integer'
          indexes :name, type: 'text'
          indexes :description, type: 'text'
          indexes :body, type: 'text'
          indexes :categories do
            indexes :id, type: 'integer'
            indexes :name, type: 'text'
          end
          indexes :tags do
            indexes :id, type: 'integer'
            indexes :name, type: 'text'
          end
          indexes :visibility, type: 'integer'
          indexes :status, type: 'integer'
        end
      end
    end
  end
end
