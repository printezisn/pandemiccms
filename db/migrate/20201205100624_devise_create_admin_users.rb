# frozen_string_literal: true

# Migration to create admin users table
class DeviseCreateAdminUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_users do |t|
      ## Database authenticatable
      t.string :email, null: false, default: ''
      t.string :username, null: false, default: ''
      t.references :client, null: false, foreign_key: true
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      ## Trackable
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      ## Confirmable
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.datetime :locked_at

      ## Password expirable
      t.datetime :password_changed_at

      ## Session limitable
      t.string :unique_session_id

      t.timestamps null: false
    end

    change_table :admin_users, bulk: true do |t|
      t.index %i[client_id email]
      t.index %i[client_id username], unique: true
      t.index :reset_password_token, unique: true
      t.index :confirmation_token, unique: true
      t.index :password_changed_at
    end
  end
end
