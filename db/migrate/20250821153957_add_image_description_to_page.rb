# frozen_string_literal: true

# Migration to add image description to pages
class AddImageDescriptionToPage < ActiveRecord::Migration[8.0]
  def change
    add_column :pages, :image_description, :string
  end
end
