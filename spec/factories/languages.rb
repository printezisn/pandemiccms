# frozen_string_literal: true

FactoryBot.define do
  factory :language do
    sequence(:locale) { |n| "l#{n}" }
    sequence(:name) { |n| "Lang#{n}" }
    sequence(:flag) { |n| "fl#{n}" }
  end
end
