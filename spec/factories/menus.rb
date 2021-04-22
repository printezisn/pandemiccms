# frozen_string_literal: true

FactoryBot.define do
  factory :menu do
    sequence(:name) { |n| "Menu#{n}" }
    sequence(:description) { |n| "Menu description #{n}" }

    association :client
  end
end
