# frozen_string_literal: true

FactoryBot.define do
  factory :redirect do
    sequence(:from) { |n| "/en/from/#{n}" }
    sequence(:to) { |n| "/en/to/#{n}" }

    association :client
  end
end
