# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    sequence(:name) { |n| "Post#{n}" }
    sequence(:description) { |n| "Post description #{n}" }
    sequence(:body) { |n| "Post body #{n}" }

    client
    author factory: %i[admin_user]
  end
end
