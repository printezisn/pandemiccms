# frozen_string_literal: true

FactoryBot.define do
  factory :email_template do
    sequence(:subject) { |n| "Subject #{n}" }
    sequence(:body) { |n| "Body #{n}" }

    client
  end
end
