# frozen_string_literal: true

# Migration to add first name, middle name, last name and description to admin users
class AddNamesAndDescriptionToAdminUser < ActiveRecord::Migration[6.1]
  def change
    change_table :admin_users, bulk: true do |t|
      t.column :first_name, :string
      t.column :middle_name, :string
      t.column :last_name, :string
      t.column :description, :text
    end
  end
end
