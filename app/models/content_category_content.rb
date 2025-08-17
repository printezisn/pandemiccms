# frozen_string_literal: true

# Content category content model
class ContentCategoryContent < ApplicationRecord
  belongs_to :content_category, inverse_of: :content_category_contents
  belongs_to :content, inverse_of: :content_category_contents
end
