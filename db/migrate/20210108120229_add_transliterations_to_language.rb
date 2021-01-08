# frozen_string_literal: true

# Migration to add transliterations to languages
class AddTransliterationsToLanguage < ActiveRecord::Migration[6.1]
  def change
    add_column :languages, :transliterations, :string
  end
end
