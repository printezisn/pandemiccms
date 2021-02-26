# frozen_string_literal: true

# CategoryCategorizable model
class CategoryCategorizable < ApplicationRecord
  belongs_to :category, inverse_of: :category_categorizables
  belongs_to :categorizable, polymorphic: true
end
