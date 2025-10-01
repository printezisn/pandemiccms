# frozen_string_literal: true

class AddMetaInfoToPost < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :meta_title, :string
    add_column :posts, :meta_description, :string
  end
end
