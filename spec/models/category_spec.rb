# frozen_string_literal: true

require 'rails_helper'
require './spec/models/concerns/simple_text_searchable'
require './spec/models/concerns/bound_sortable'
require './spec/models/concerns/sluggable'
require './spec/models/concerns/translatable'
require './spec/models/concerns/imageable'
require './spec/models/concerns/parentable'

RSpec.describe Category do
  subject(:model) { build(:category) }

  it { is_expected.to belong_to(:client) }
  it { is_expected.to belong_to(:parent).class_name('Category').optional(true) }
  it { is_expected.to have_many(:children).class_name('Category').with_foreign_key(:parent_id).dependent(:destroy) }
  it { is_expected.to have_many(:category_categorizables).dependent(:destroy) }
  it { is_expected.to have_many(:menu_items).dependent(:destroy) }

  it { is_expected.to define_enum_for(:visibility).with_values(public: 0, private: 1).with_suffix(:visibility) }

  it { is_expected.to validate_presence_of(:name).with_message('The name is required.') }
  it { is_expected.to validate_length_of(:name).is_at_most(255).with_message('The name may contain up to 255 characters.') }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to([:client_id]).with_message('The name is already used.') }
  it { is_expected.to validate_length_of(:slug).is_at_most(255).with_message('The slug may contain up to 255 characters.') }
  it { is_expected.to validate_length_of(:image_description).is_at_most(255).with_message('The image description may contain up to 255 characters.') }
  it { is_expected.to validate_length_of(:meta_title).is_at_most(60).with_message('The title (meta) may contain up to 60 characters.') }
  it { is_expected.to validate_length_of(:meta_description).is_at_most(160).with_message('The description (meta) may contain up to 160 characters.') }

  describe '#index_associations' do
    subject(:model) { create(:category) }

    before { create(:post, categories: [model]) }

    context 'when the category is updated' do
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
    subject(:model) { create(:category, :with_parent, :with_children) }

    let(:translation) { build(:category) }

    it_behaves_like 'SimpleTextSearchable'
    it_behaves_like 'BoundSortable'
    it_behaves_like 'Sluggable'
    it_behaves_like 'Translatable'
    it_behaves_like 'Imageable'
    it_behaves_like 'Parentable'
  end
end
