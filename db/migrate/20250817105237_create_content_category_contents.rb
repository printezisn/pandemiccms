# frozen_string_literal: true

# Migration to add content category contents
class CreateContentCategoryContents < ActiveRecord::Migration[8.0]
  def change
    create_table :content_category_contents do |t|
      t.references :content_category, null: false, foreign_key: true
      t.references :content, null: false, foreign_key: true

      t.timestamps

      t.index %i[content_category_id content_id], unique: true, name: 'index_content_category_contents_on_category_and_content'
    end
  end
end
