# frozen_string_literal: true

FactoryBot.define do
  factory :admin_user do
    sequence(:username) { |n| "username-#{n}" }
    sequence(:email) { |n| "user#{n}@test.com" }
    sequence(:client_id) { |n| "client-#{n}" }
    password { 'T3stPa$$' }

    after(:create) { |admin_user, _| admin_user.confirm }
  end
end
