# frozen_string_literal: true

FactoryBot.define do
  factory :translation do
    translatable { nil }
    locale { 'en' }
  end
end
