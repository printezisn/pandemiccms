# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "Tag#{n}" }
    sequence(:description) { |n| "Tag description #{n}" }

    association :client
  end
end
