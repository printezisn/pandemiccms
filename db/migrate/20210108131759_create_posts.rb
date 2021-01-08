# Migration to create posts table
class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :client, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
