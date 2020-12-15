# frozen_string_literal: true

# Migration to add roles to admin users
class AddRolesToAdminUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :admin_users, :roles, :string
  end
end
