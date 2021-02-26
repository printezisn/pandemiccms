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
end
