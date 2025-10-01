# frozen_string_literal: true

# Migration to add image description to categories
class AddImageDescriptionToCategory < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :image_description, :string
  end
end
