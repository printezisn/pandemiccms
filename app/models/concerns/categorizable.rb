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
    new_categories = category_names.select(&:present?).map do |category_name|
      Category.find_or_initialize_by(name: category_name, client_id: client_id)
    end
    category_categorizables.each do |category_categorizable|
      category_categorizable.destroy unless new_categories.any? { |category| category.id == category_categorizable.category_id }
    end

    self.categories = new_categories
  end
end
