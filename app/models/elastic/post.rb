# frozen_string_literal: true

module Elastic
  # Elasticsearch document model for post
  class Post
    attr_reader :attributes

    def initialize(attributes = {})
      @attributes = attributes
    end

    def to_hash
      attributes
    end

    def self.from_entity(locale, post)
      translated_post = post.translate(locale, use_defaults: true)

      new(
        id: post.id,
        name: translated_post.name,
        description: translated_post.description,
        body: HTMLEntities.new.decode(translated_post.body),
        categories: post.categories.public_visibility.includes(:translations).map do |category|
          { id: category.id, name: category.translate(locale, use_defaults: true).name }
        end,
        tags: post.tags.public_visibility.includes(:translations).map do |tag|
          { id: tag.id, name: tag.translate(locale, use_defaults: true).name }
        end,
        visibility: post.visibility.to_i,
        status: post.status.to_i
      )
    end
  end
end
