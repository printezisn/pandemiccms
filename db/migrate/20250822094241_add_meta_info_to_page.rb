# frozen_string_literal: true

class AddMetaInfoToPage < ActiveRecord::Migration[8.0]
  def change
    add_column :pages, :meta_title, :string
    add_column :pages, :meta_description, :string
  end
end
