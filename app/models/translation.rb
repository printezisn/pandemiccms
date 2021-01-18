# frozen_string_literal: true

# Translation model
class Translation < ApplicationRecord
  belongs_to :translatable, polymorphic: true

  serialize :fields
end
