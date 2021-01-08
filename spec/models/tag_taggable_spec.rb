# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagTaggable, type: :model do
  subject { FactoryBot.build(:tag_taggable) }

  it { is_expected.to belong_to(:tag) }
  it { is_expected.to belong_to(:taggable) }

  describe 'scopes' do
    let(:tag) { FactoryBot.create(:tag) }
    let!(:post) { FactoryBot.create(:post, tags: [tag]) }
    let!(:page) { FactoryBot.create(:page, tags: [tag]) }

    it { expect(described_class.post.map(&:taggable)).to contain_exactly(post) }
    it { expect(described_class.page.map(&:taggable)).to contain_exactly(page) }
  end

  describe '#update_tag_counters' do
    let(:tag) { FactoryBot.create(:tag) }

    context 'when post taggable is saved' do
      it 'updates the posts_count counter' do
        expect { FactoryBot.create(:post, tags: [tag]) }.to change(tag, :posts_count).by(1)
      end
    end

    context 'when page taggable is saved' do
      it 'updates the pages_count counter' do
        expect { FactoryBot.create(:page, tags: [tag]) }.to change(tag, :pages_count).by(1)
      end
    end

    context 'when post taggable is destroyed' do
      let!(:post) { FactoryBot.create(:post, tags: [tag]) }

      it 'updates the posts_count counter' do
        expect { post.destroy }.to change(tag, :posts_count).by(-1)
      end
    end

    context 'when page taggable is destroyed' do
      let!(:page) { FactoryBot.create(:page, tags: [tag]) }

      it 'updates the pages_count counter' do
        expect { page.destroy }.to change(tag, :pages_count).by(-1)
      end
    end
  end
end
