# frozen_string_literal: true

FactoryBot.define do
  factory :client_language do
    association :client
    association :language
  end
end
