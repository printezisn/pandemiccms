# frozen_string_literal: true

# Migration to remove creator_id and updater_id from tags table
class RemoveCreatorAndUpdaterFromTag < ActiveRecord::Migration[6.1]
  def up
    change_table :tags, bulk: true do |t|
      t.remove_references :creator
      t.remove_references :updater
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
