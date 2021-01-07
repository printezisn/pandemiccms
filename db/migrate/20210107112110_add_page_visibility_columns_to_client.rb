# frozen_string_literal: true

# Migration to add page visibility columns to client
class AddPageVisibilityColumnsToClient < ActiveRecord::Migration[6.1]
  def change
    change_table :clients, bulk: true do |t|
      t.boolean :show_search_page, null: false, default: true
      t.boolean :show_tag_page, null: false, default: true
      t.boolean :show_category_page, null: false, default: true
    end
  end
end
