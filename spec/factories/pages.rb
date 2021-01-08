# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    sequence(:name) { |n| "Page#{n}" }

    association :client
  end
end
