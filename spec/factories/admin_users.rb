# frozen_string_literal: true

FactoryBot.define do
  factory :admin_user do
    sequence(:username) { |n| "username-#{n}" }
    sequence(:email) { |n| "user#{n}@test.com" }
    client_id { 'local' }
    password { 'T3stPa$$' }

    after(:create) { |admin_user, _| admin_user.confirm }

    trait :supervisor do
      roles { [AdminUser::SUPERVISOR_ROLE] }
    end
  end
end
