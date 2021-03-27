# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagTaggable, type: :model do
  subject(:model) { FactoryBot.build(:tag_taggable) }

  it { is_expected.to belong_to(:tag) }
  it { is_expected.to belong_to(:taggable) }

  describe '#increment_posts_count' do
    subject { tag.posts_count }

    let(:visibility) { :public }
    let(:tag) { FactoryBot.create(:tag) }

    before do
      FactoryBot.create(:post, tags: [tag], status: :published, visibility: visibility)
      FactoryBot.create(:page, tags: [tag])
    end

    context 'when the post is visible' do
      it { is_expected.to eq(1) }
    end

    context 'when the post is not visible' do
      let(:visibility) { :private }

      it { is_expected.to be_zero }
    end
  end

  describe 'scopes' do
    let(:tag) { FactoryBot.create(:tag) }
    let!(:post) { FactoryBot.create(:post, tags: [tag]) }
    let!(:page) { FactoryBot.create(:page, tags: [tag]) }

    it { expect(described_class.post.map(&:taggable)).to contain_exactly(post) }
    it { expect(described_class.page.map(&:taggable)).to contain_exactly(page) }
  end
end
