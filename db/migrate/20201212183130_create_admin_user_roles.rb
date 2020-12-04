# frozen_string_literal: true

# Migration to create the admin user roles table
class CreateAdminUserRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_user_roles do |t|
      t.references :admin_user, null: false, foreign_key: true
      t.integer :role, limit: 1, null: false

      t.timestamps null: false
    end
  end
end
