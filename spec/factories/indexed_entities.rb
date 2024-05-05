# frozen_string_literal: true

FactoryBot.define do
  factory :indexed_entity do
    indexable { nil }
    locale { 'en-GB' }

    client
  end
end
