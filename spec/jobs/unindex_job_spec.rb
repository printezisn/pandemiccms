# frozen_string_literal: true

require 'rails_helper'
require './spec/utils/retry'

RSpec.describe UnindexJob, type: :job do
  before do
    create_list(:language, 3)
  end

  def expect_records_found(entity, repo_klass, expected_value)
    Language.pluck(:locale).each do |locale|
      records_found = retry_operation(expected_value: expected_value) do
        repo = repo_klass.new(entity.client_id, locale)
        repo.search(query: { match_all: {} }).response[:hits][:total][:value]
      end

      expect(records_found).to eq(expected_value)
    end
  end

  shared_examples 'unindexing job' do
    it 'unindexes the entity' do
      IndexJob.perform_now(entity.class, entity.id)
      expect_records_found(entity, repo_klass, 1)

      described_class.perform_now(entity.class, entity.client_id, entity.id)
      expect_records_found(entity, repo_klass, 0)
    end
  end

  describe 'Post' do
    let(:entity) { create(:post) }
    let(:repo_klass) { Elastic::PostRepository }

    it_behaves_like 'unindexing job'
  end
end
