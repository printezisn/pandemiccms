# frozen_string_literal: true

# Migration to add cache settings to clients table
class AddCacheSettingsToClient < ActiveRecord::Migration[6.1]
  def change
    change_table :clients, bulk: true do |t|
      t.boolean :cache_enabled, null: false, default: false
      t.integer :cache_duration
    end
  end
end
