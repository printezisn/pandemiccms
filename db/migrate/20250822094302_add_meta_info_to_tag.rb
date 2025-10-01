# frozen_string_literal: true

class AddMetaInfoToTag < ActiveRecord::Migration[8.0]
  def change
    add_column :tags, :meta_title, :string
    add_column :tags, :meta_description, :string
  end
end
