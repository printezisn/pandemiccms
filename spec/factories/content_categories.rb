# frozen_string_literal: true

FactoryBot.define do
  factory :content_category do
    sequence(:name) { |n| "Content Category #{n}" }
    sequence(:description) { |n| "Description for content category #{n}" }

    client
  end
end
