# frozen_string_literal: true

# Migration to add image description to contents
class AddImageDescriptionToContent < ActiveRecord::Migration[8.0]
  def change
    add_column :contents, :image_description, :string
  end
end
