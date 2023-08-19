# frozen_string_literal: true

FactoryBot.define do
  factory :menu_item do
    sequence(:name) { |n| "Menu Item #{n}" }
    sequence(:external_url) { |n| "https://mytest#{n}.com" }

    menu

    trait :with_parent do
      after(:create) do |instance, _|
        instance.parent = FactoryBot.create(:menu_item, menu_id: instance.menu_id)
        instance.save!
      end
    end

    trait :with_children do
      after(:create) do |instance, _|
        FactoryBot.create_list(:menu_item, 2, parent_id: instance.id, menu_id: instance.menu_id)
        instance.reload
      end
    end
  end
end
