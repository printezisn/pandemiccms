# frozen_string_literal: true

# Migration to remove transliterations from languages
class RemoveTransliterationsFromLanguage < ActiveRecord::Migration[8.0]
  def change
    remove_column :languages, :transliterations, :string
  end
end
