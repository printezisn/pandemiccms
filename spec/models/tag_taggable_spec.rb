# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagTaggable, type: :model do
  subject(:model) { build(:tag_taggable) }

  it { is_expected.to belong_to(:tag) }
  it { is_expected.to belong_to(:taggable) }

  describe '#increment_posts_count' do
    subject { tag.posts_count }

    let(:visibility) { :public }
    let(:tag) { create(:tag) }

    before do
      create(:post, tags: [tag], status: :published, visibility:)
      create(:page, tags: [tag])
    end

    context 'when the post is visible' do
      it { is_expected.to eq(1) }
    end

    context 'when the post is not visible' do
      let(:visibility) { :private }

      it { is_expected.to be_zero }
    end
  end

  describe '#decrement_posts_count' do
    let(:visibility) { :public }
    let(:tag) { create(:tag) }

    before do
      create(:post, tags: [tag], status: :published, visibility:)
      create(:page, tags: [tag])
    end

    context 'when the post is visible' do
      it { expect { tag.tag_taggables.destroy_all }.to change(tag, :posts_count).from(1).to(0) }
    end

    context 'when the post is not visible' do
      let(:visibility) { :private }

      it { expect { tag.tag_taggables.destroy_all }.not_to change(tag, :posts_count) }
    end
  end

  describe 'scopes' do
    let(:tag) { create(:tag) }
    let!(:post) { create(:post, tags: [tag]) }
    let!(:page) { create(:page, tags: [tag]) }

    it { expect(described_class.post.map(&:taggable)).to contain_exactly(post) }
    it { expect(described_class.page.map(&:taggable)).to contain_exactly(page) }
  end
end
