# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "Tag#{n}" }
    sequence(:description) { |n| "Tag description #{n}" }
    sequence(:body) { |n| "Tag body #{n}" }

    association :client
  end
end
