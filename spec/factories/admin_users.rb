# frozen_string_literal: true

FactoryBot.define do
  factory :admin_user do
    sequence(:username) { |n| "username-#{n}" }
    sequence(:email) { |n| "user#{n}@test.com" }
    sequence(:first_name) { |n| "Firstname#{n}" }
    sequence(:middle_name) { |n| "Middlename#{n}" }
    sequence(:last_name) { |n| "Lastname#{n}" }
    password { 'T3stPa$$' }

    association :client

    after(:create) { |admin_user, _| admin_user.confirm }

    trait :supervisor do
      after(:create) { |admin_user, _| admin_user.supervisor! }
    end
  end
end
