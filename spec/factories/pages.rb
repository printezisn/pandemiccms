# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    sequence(:name) { |n| "Page#{n}" }
    sequence(:description) { |n| "Page description #{n}" }
    sequence(:body) { |n| "Page body #{n}" }

    client
    author factory: %i[admin_user]

    trait :with_parent do
      after(:create) do |instance, _|
        instance.parent = FactoryBot.create(:page)
        instance.save!
      end
    end

    trait :with_children do
      after(:create) do |instance, _|
        instance.children = FactoryBot.create_list(:page, 2)
      end
    end
  end
end
