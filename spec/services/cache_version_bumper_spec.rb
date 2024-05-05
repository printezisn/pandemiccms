# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CacheVersionBumper do
  subject(:service) { described_class.new(client_id) }

  let(:client_id) { 1 }
  let(:key) { 'cache_version_1_test' }
  let(:expected_value) { 5 }

  before { Rails.cache.write(key, expected_value - 1, raw: true) }

  it { expect(service.call).to eq(expected_value) }
end
