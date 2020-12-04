# frozen_string_literal: true

FactoryBot.define do
  factory :language do
    locale { 'en' }
    name { 'English' }
    flag { '🇬🇧' }
  end
end
