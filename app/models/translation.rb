# frozen_string_literal: true

# Translation model
class Translation < ApplicationRecord
  belongs_to :translatable, polymorphic: true, touch: true

  serialize :fields
end
