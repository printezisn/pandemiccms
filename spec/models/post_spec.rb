# frozen_string_literal: true

require 'rails_helper'
require './spec/models/concerns/simple_text_searchable'
require './spec/models/concerns/bound_sortable'
require './spec/models/concerns/sluggable'
require './spec/models/concerns/translatable'
require './spec/models/concerns/imageable'
require './spec/models/concerns/categorizable'
require './spec/models/concerns/taggable'
require './spec/models/concerns/draftable'
require './spec/utils/retry'

RSpec.describe Post do
  subject(:model) { build(:post, author:) }

  let(:author) { create(:admin_user) }

  it { is_expected.to belong_to(:client) }
  it { is_expected.to belong_to(:author).class_name('AdminUser').optional(true) }
  it { is_expected.to have_many(:menu_items).dependent(:destroy) }

  it { is_expected.to define_enum_for(:visibility).with_values(public: 0, private: 1).with_suffix(:visibility) }

  it { is_expected.to validate_presence_of(:name).with_message('The name is required.') }
  it { is_expected.to validate_length_of(:name).is_at_most(255).with_message('The name may contain up to 255 characters.') }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to([:client_id]).with_message('The name is already used.') }
  it { is_expected.to validate_length_of(:slug).is_at_most(255).with_message('The slug may contain up to 255 characters.') }

  describe '#visible?' do
    subject { model.visible? }

    let(:visibility) { :public }
    let(:status) { :published }

    before do
      model.visibility = visibility
      model.status = status
    end

    context 'when the post does not have public visibility' do
      let(:visibility) { :private }

      it { is_expected.to be_falsey }
    end

    context 'when the post is not published' do
      let(:status) { :draft }

      it { is_expected.to be_falsey }
    end

    context 'when the post has public visibility and is published' do
      it { is_expected.to be_truthy }
    end
  end

  describe '#update_counters' do
    subject(:model) do
      create(:post, visibility: :private, status: :draft, tags: [tag], categories: [category])
    end

    let(:category) { create(:category) }
    let(:tag) { create(:tag) }

    context 'when visibility is changed, but the post is still not visible' do
      it 'does not update the counters' do
        expect { model.public_visibility! }.not_to(
          change { [category.reload.posts_count, tag.reload.posts_count] }
        )
      end
    end

    context 'when status is changed, but the post is still not visible' do
      it 'does not update the counters' do
        expect { model.published! }.not_to(
          change { [category.reload.posts_count, tag.reload.posts_count] }
        )
      end
    end

    context 'when the post becomes visible' do
      it 'updates the counters' do
        expect { model.update!(status: :published, visibility: :public) }.to(
          change { [category.reload.posts_count, tag.reload.posts_count] }.from([0, 0]).to([1, 1])
        )
      end
    end

    context 'when the post becomes not visible after an update' do
      it 'updates the counters' do
        model.update!(status: :published, visibility: :public)

        expect { model.private_visibility! }.to(
          change { [category.reload.posts_count, tag.reload.posts_count] }.from([1, 1]).to([0, 0])
        )
      end
    end
  end

  describe '#index' do
    before { model.save! }

    context 'when the post is created' do
      it 'indexes it' do
        expect(IndexJob).to have_been_enqueued.exactly(:once)
      end
    end

    context 'when the post is updated' do
      before { model.update!(name: 'New Name') }

      it 'reindexes it' do
        expect(IndexJob).to have_been_enqueued.exactly(:twice)
      end
    end
  end

  describe '#unindex' do
    before { model.save! }

    context 'when the post is destroyed' do
      before { model.destroy }

      it 'unindexes it' do
        expect(UnindexJob).to have_been_enqueued.exactly(:once)
      end
    end
  end

  describe 'concerns' do
    subject(:model) { create(:post) }

    let(:translation) { build(:post) }

    it_behaves_like 'SimpleTextSearchable'
    it_behaves_like 'BoundSortable'
    it_behaves_like 'Sluggable'
    it_behaves_like 'Translatable'
    it_behaves_like 'Imageable'
    it_behaves_like 'Categorizable'
    it_behaves_like 'Taggable'
    it_behaves_like 'Draftable'
  end
end
