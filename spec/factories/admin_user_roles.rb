# frozen_string_literal: true

FactoryBot.define do
  factory :admin_user_role do
    role { :supervisor }

    association :admin_user
  end
end
