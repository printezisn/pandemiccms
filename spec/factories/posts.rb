# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    sequence(:name) { |n| "Post#{n}" }
    sequence(:description) { |n| "Post description #{n}" }
    sequence(:body) { |n| "Post body #{n}" }

    association :client
    association :author, factory: :admin_user
  end
end
