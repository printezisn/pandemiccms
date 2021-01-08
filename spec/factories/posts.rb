# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    sequence(:name) { |n| "Post#{n}" }

    association :client
  end
end
