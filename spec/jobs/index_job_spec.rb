# frozen_string_literal: true

require 'rails_helper'
require './spec/utils/retry'

RSpec.describe IndexJob do
  before do
    create_list(:language, 3)
  end

  shared_examples 'indexing job' do
    it 'indexes the entity' do
      described_class.perform_now(entity.class, entity.id)

      Language.pluck(:locale).each do |locale|
        records_found = retry_operation(expected_value: 1) do
          repo = repo_klass.new(entity.client_id, locale)
          repo.search(query: { match_all: {} }).response[:hits][:total][:value]
        end

        expect(records_found).to eq(1)
      end
    end

    it 'updates the entity index information' do
      expect { described_class.perform_now(entity.class, entity.id) }.to(
        change { [entity.reload.index_version, entity.reload.indexed_at] }
      )
    end

    context 'when the index version is different' do
      before do
        allow_any_instance_of(entity.class).to receive(:index_version).and_return('1')
      end

      it 'fails to update the entity index information' do
        described_class.perform_now(entity.class, entity.id)

        expect(described_class).to have_been_enqueued.exactly(:twice)
      end
    end
  end

  describe 'Post' do
    let(:entity) { create(:post) }
    let(:repo_klass) { SearchIndex::RepositoryFactory.get(Post) }

    it_behaves_like 'indexing job'
  end
end
