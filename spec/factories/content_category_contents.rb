# frozen_string_literal: true

FactoryBot.define do
  factory :content_category_content do
    content_category
    content
  end
end
