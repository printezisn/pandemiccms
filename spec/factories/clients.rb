# frozen_string_literal: true

FactoryBot.define do
  factory :client do
    name { 'test_client' }
    email { 'test_client@email.com' }
    time_zone { 'UTC' }
    template { 'sample' }
    initialize_with { Client.find_or_create_by(name:, time_zone:, template:) }

    after(:build) do |client, _|
      client.client_domains << FactoryBot.build(:client_domain) if client.client_domains.empty?
    end
  end
end
