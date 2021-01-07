# frozen_string_literal: true

class TagTaggable < ApplicationRecord
  belongs_to :tag, inverse_of: :tag_taggables
  belongs_to :taggable, polymorphic: true
end
