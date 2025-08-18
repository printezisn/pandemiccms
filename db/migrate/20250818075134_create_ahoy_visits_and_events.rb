# frozen_string_literal: true

# Migration to create Ahoy visits and events tables
class CreateAhoyVisitsAndEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :ahoy_visits do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.string :visit_token
      t.string :visitor_token

      # the rest are recommended but optional
      # simply remove any you don't want

      # user
      t.references :user

      # standard
      t.string :ip
      t.text :user_agent
      t.text :referrer
      t.string :referring_domain
      t.text :landing_page

      # technology
      t.string :browser
      t.string :os
      t.string :device_type

      # location
      t.string :country
      t.string :region
      t.string :city
      t.float :latitude
      t.float :longitude

      # utm parameters
      t.string :utm_source
      t.string :utm_medium
      t.string :utm_term
      t.string :utm_content
      t.string :utm_campaign

      # native apps
      t.string :app_version
      t.string :os_version
      t.string :platform

      t.datetime :started_at
    end

    add_index :ahoy_visits, :visit_token, unique: true
    add_index :ahoy_visits, %i[visitor_token started_at]

    create_table :ahoy_events do |t| # rubocop:disable Rails/CreateTableWithTimestamps
      t.references :visit
      t.references :user

      t.string :name
      t.text :properties
      t.datetime :time
    end

    add_index :ahoy_events, %i[name time]
  end
end
