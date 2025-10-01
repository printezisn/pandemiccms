# frozen_string_literal: true

# Migration to add title to content
class AddTitleToContent < ActiveRecord::Migration[8.0]
  def change
    add_column :contents, :title, :string
  end
end
