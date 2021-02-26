# frozen_string_literal: true

# Migration to create category_categorizables table
class CreateCategoryCategorizables < ActiveRecord::Migration[6.1]
  def change
    create_table :category_categorizables do |t|
      t.references :category, null: false, foreign_key: true
      t.references :categorizable, polymorphic: true, null: false

      t.timestamps null: false

      t.index %i[category_id categorizable_id categorizable_type],
              unique: true,
              name: 'index_category_categorizable_on_category_and_categorizable'
    end
  end
end
