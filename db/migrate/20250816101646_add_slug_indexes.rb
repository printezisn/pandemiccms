# frozen_string_literal: true

# Migration to make slug required in posts, pages, categories and tags
class AddSlugIndexes < ActiveRecord::Migration[8.0]
  def change
    change_table :posts, bulk: true do |t|
      t.index %i[client_id slug], name: 'index_posts_on_client_id_and_slug'
    end

    change_table :pages, bulk: true do |t|
      t.index %i[client_id slug], name: 'index_pages_on_client_id_and_slug'
    end

    change_table :categories, bulk: true do |t|
      t.index %i[client_id slug], name: 'index_categories_on_client_id_and_slug'
    end

    change_table :tags, bulk: true do |t|
      t.index %i[client_id slug], name: 'index_tags_on_client_id_and_slug'
    end
  end
end
