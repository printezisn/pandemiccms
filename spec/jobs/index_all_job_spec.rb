# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IndexAllJob do
  let(:only_unindexed_entities) { false }

  before do
    create_list(:post, 2)
    Post.first.update!(indexed_at: Time.now.utc)

    described_class.perform_now(client_id, only_unindexed_entities)
  end

  context 'when indexing by client id' do
    let(:client_id) { Post.first.client_id }

    context 'when no entities match' do
      let(:client_id) { -1 }

      it 'does not index any entities' do
        expect(IndexJob).to have_been_enqueued.exactly(:twice)
      end
    end

    context 'when indexing only unindexed entities' do
      let(:only_unindexed_entities) { true }

      it 'indexes only entities which match' do
        expect(IndexJob).to have_been_enqueued.exactly(3).times
      end
    end

    context 'when indexing all entities' do
      it 'indexes all entities' do
        expect(IndexJob).to have_been_enqueued.exactly(4).times
      end
    end
  end

  context 'when not indexing by client id' do
    let(:client_id) { nil }

    context 'when indexing only unindexed entities' do
      let(:only_unindexed_entities) { true }

      it 'indexes only entities which match' do
        expect(IndexJob).to have_been_enqueued.exactly(3).times
      end
    end

    context 'when indexing all entities' do
      it 'indexes all entities' do
        expect(IndexJob).to have_been_enqueued.exactly(4).times
      end
    end
  end
end
