# frozen_string_literal: true

# Migration to create tag_taggables table
class CreateTagTaggables < ActiveRecord::Migration[6.1]
  def change
    create_table :tag_taggables do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :taggable, null: false, polymorphic: true

      t.timestamps null: false

      t.index %i[tag_id taggable_id taggable_type], unique: true
    end
  end
end
