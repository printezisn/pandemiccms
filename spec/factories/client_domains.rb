# frozen_string_literal: true

FactoryBot.define do
  factory :client_domain do
    domain { 'www.example.com' }
    port { 80 }
  end
end
