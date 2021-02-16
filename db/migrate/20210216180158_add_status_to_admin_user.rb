# frozen_string_literal: true

# Migration to add status to admin users table
class AddStatusToAdminUser < ActiveRecord::Migration[6.1]
  def change
    add_column :admin_users, :status, :integer, limit: 1, default: 0
  end
end
