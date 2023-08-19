# frozen_string_literal: true

# Migration add 'css_class' and 'open_in_new_window' columns to menu items table
class AddCssClassAndOpenInNewWindowToMenuItem < ActiveRecord::Migration[6.1]
  def change
    change_table :menu_items, bulk: true do |t|
      t.string :css_class
      t.boolean :open_in_new_window, default: false, null: false
    end
  end
end
