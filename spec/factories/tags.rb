# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "Tag#{n}" }
    sequence(:description) { |n| "Tag description #{n}" }

    association :client
    association :creator, factory: :admin_user
    association :updater, factory: :admin_user
  end
end
