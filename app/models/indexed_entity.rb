# frozen_string_literal: true

# Indexed entity model
class IndexedEntity < ApplicationRecord
  belongs_to :indexable, polymorphic: true
  belongs_to :client, inverse_of: :indexed_entities
end
