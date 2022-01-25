# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CacheFetcher do
  subject(:service_call) { described_class.call(client, cache_version, key) { result } }

  let(:cache_enabled) { true }
  let(:cache_duration) { 180 }
  let(:cache_version) { '1' }
  let(:key) { 'key' }
  let(:result) { 'result' }

  let(:client) { build(:client, cache_enabled: cache_enabled, cache_duration: cache_duration) }

  context 'when the cache is enabled' do
    it { is_expected.to eq(result) }

    it 'caches the result' do
      allow(Rails.cache).to receive(:fetch)

      service_call

      expect(Rails.cache).to have_received(:fetch)
    end
  end

  context 'when the cache is not enabled' do
    let(:cache_enabled) { false }

    it { is_expected.to eq(result) }

    it 'does not cache the result' do
      allow(Rails.cache).to receive(:fetch)

      service_call

      expect(Rails.cache).not_to have_received(:fetch)
    end
  end
end
