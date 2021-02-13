# frozen_string_literal: true

# Migration to add email column to clients table
class AddEmailToClient < ActiveRecord::Migration[6.1]
  def change
    add_column :clients, :email, :string
  end
end
