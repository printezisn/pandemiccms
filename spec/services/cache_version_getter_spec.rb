# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CacheVersionGetter do
  subject(:service) { described_class.new(client_id) }

  let(:client_id) { 1 }
  let(:key) { 'cache_version_1_test' }
  let(:expected_value) { '5' }

  before { service.redis.set(key, expected_value) }

  it { expect(service.call).to eq(expected_value) }
end
