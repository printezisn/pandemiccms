# frozen_string_literal: true

FactoryBot.define do
  factory :category_categorizable do
    category { nil }
    categorizable { nil }
  end
end
