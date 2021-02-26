# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    sequence(:name) { |n| "Category#{n}" }
    sequence(:description) { |n| "Category description #{n}" }

    association :client

    trait :with_parent do
      after(:create) do |instance, _|
        instance.parent = FactoryBot.create(:category)
        instance.save!
      end
    end

    trait :with_children do
      after(:create) do |instance, _|
        instance.children = FactoryBot.create_list(:category, 2)
      end
    end
  end
end
