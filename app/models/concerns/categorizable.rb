# frozen_string_literal: true

# Concern for adding categorizing functionality to models
module Categorizable
  extend ActiveSupport::Concern

  included do
    attribute :category_names, default: []
    attribute :should_save_categories, :boolean

    has_many :category_categorizables, as: :categorizable, dependent: :destroy
    has_many :categories, through: :category_categorizables

    after_save :save_categories, if: :should_save_categories
  end

  private

  def save_categories
    self.categories = category_names.select(&:present?).map do |category_name|
      Category.find_or_initialize_by(name: category_name, client_id: client_id)
    end
  end
end
