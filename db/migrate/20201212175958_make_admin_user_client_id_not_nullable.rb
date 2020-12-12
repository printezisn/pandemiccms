# frozen_string_literal: true

# Migration to make the client_id field in admin_users not nullable
class MakeAdminUserClientIdNotNullable < ActiveRecord::Migration[6.0]
  def up
    change_table :admin_users, bulk: true do |t|
      t.change :client_id, :string, null: false

      t.index :client_id
    end
  end

  def down
    change_table :admin_users, bulk: true do |t|
      t.remove_index :client_id

      t.change :client_id, :string, null: true
    end
  end
end
