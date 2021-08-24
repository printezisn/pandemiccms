# frozen_string_literal: true

FactoryBot.define do
  factory :redirect do
    sequence(:from) { |n| "/en-GB/from/#{n}" }
    sequence(:to) { |n| "/en-GB/to/#{n}" }

    association :client
  end
end
