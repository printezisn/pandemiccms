# frozen_string_literal: true

# Indexed entity model
class IndexedEntity < ApplicationRecord
  belongs_to :indexable, polymorphic: true
end
