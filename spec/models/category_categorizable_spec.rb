# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoryCategorizable, type: :model do
  subject(:model) { FactoryBot.build(:category_categorizable) }

  it { is_expected.to belong_to(:category) }
  it { is_expected.to belong_to(:categorizable) }

  describe '#increment_posts_count' do
    subject { category.posts_count }

    let(:visibility) { :public }
    let(:category) { FactoryBot.create(:category) }

    before do
      FactoryBot.create(:post, categories: [category], status: :published, visibility: visibility)
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
    let(:category) { FactoryBot.create(:category) }
    let!(:post) { FactoryBot.create(:post, categories: [category]) }

    it { expect(described_class.post.map(&:categorizable)).to contain_exactly(post) }
  end
end
