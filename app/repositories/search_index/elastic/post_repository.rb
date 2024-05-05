# frozen_string_literal: true

module SearchIndex
  module Elastic
    # Repository for storing posts in elasticsearch
    class PostRepository < BaseRepository
      def model_type
        'posts'
      end

      def klass
        ::SearchIndex::Post
      end

      def initialize(client_id, locale)
        super(client_id, locale)

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
end
