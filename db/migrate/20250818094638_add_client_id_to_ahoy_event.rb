# frozen_string_literal: true

# Migration to add client id to ahoy events
class AddClientIdToAhoyEvent < ActiveRecord::Migration[8.0]
  def change
    change_table :ahoy_events, bulk: true do |t|
      t.references :client, null: false, foreign_key: true
      t.index %i[client_id name time], name: 'index_ahoy_events_on_client_id_name_and_time'
    end
  end
end
