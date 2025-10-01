# frozen_string_literal: true

# Migration to add image description to posts
class AddImageDescriptionToPost < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :image_description, :string
  end
end
