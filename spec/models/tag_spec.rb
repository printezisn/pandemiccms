# frozen_string_literal: true

require 'rails_helper'
require './spec/models/concerns/simple_text_searchable'
require './spec/models/concerns/bound_sortable'
require './spec/models/concerns/sluggable'
require './spec/models/concerns/translatable'

RSpec.describe Tag do
  subject(:model) { build(:tag) }

  it { is_expected.to belong_to(:client) }
  it { is_expected.to have_many(:tag_taggables).dependent(:destroy) }
  it { is_expected.to have_many(:menu_items).dependent(:destroy) }

  it { is_expected.to define_enum_for(:visibility).with_values(public: 0, private: 1).with_suffix(:visibility) }

  it { is_expected.to validate_presence_of(:name).with_message('The name is required.') }
  it { is_expected.to validate_length_of(:name).is_at_most(255).with_message('The name may contain up to 255 characters.') }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to([:client_id]).with_message('The name is already used.') }
  it { is_expected.to validate_length_of(:slug).is_at_most(255).with_message('The slug may contain up to 255 characters.') }

  describe '#index_associations' do
    subject(:model) { create(:tag) }

    before { create(:post, indexed_at: Time.now.utc, tags: [model]) }

    context 'when the tag is updated' do
      before { model.update!(name: 'New Name') }

      it 'reindexes the associations' do
        expect(IndexJob).to have_been_enqueued.exactly(:twice)
      end
    end

    context 'when the category is destroyed' do
      before { model.destroy }

      it 'reindexes the associations' do
        expect(IndexJob).to have_been_enqueued.exactly(:twice)
      end
    end
  end

  describe 'concerns' do
    let(:translation) { build(:tag) }

    before { model.save! }

    it_behaves_like 'SimpleTextSearchable'
    it_behaves_like 'BoundSortable'
    it_behaves_like 'Sluggable'
    it_behaves_like 'Translatable'
  end
end
