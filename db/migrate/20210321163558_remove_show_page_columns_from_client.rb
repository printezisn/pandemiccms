# frozen_string_literal: true

# Migration to remove show_search_page, show_category_page and show_tag_pages from clients table
class RemoveShowPageColumnsFromClient < ActiveRecord::Migration[6.1]
  def up
    change_table :clients, bulk: true do |t|
      t.remove :show_search_page
      t.remove :show_category_page
      t.remove :show_tag_page
    end
  end

  def down
    change_table :clients, bulk: true do |t|
      t.boolean :show_search_page, null: false, default: true
      t.boolean :show_tag_page, null: false, default: true
      t.boolean :show_category_page, null: false, default: true
    end
  end
end
