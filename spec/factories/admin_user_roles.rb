# frozen_string_literal: true

FactoryBot.define do
  factory :admin_user_role do
    role { :supervisor }

    admin_user
  end
end
