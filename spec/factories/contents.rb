# frozen_string_literal: true

FactoryBot.define do
  factory :content do
    sequence(:name) { |n| "Content#{n}" }
    order { 1 }
    sequence(:simple_text) { |n| "Content simple text #{n}" }
    sequence(:rich_text) { |n| "Content rich text #{n}" }

    client
  end
end
