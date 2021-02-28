# frozen_string_literal: true

require 'rails_helper'
require './spec/models/concerns/simple_text_searchable_spec'
require './spec/models/concerns/bound_sortable_spec'
require './spec/models/concerns/sluggable_spec'
require './spec/models/concerns/translatable_spec'
require './spec/models/concerns/imageable_spec'
require './spec/models/concerns/parentable_spec'

RSpec.describe Category, type: :model do
  subject(:model) { FactoryBot.build(:category) }

  it { is_expected.to belong_to(:client) }
  it { is_expected.to belong_to(:parent).class_name('Category').optional(true) }
  it { is_expected.to have_many(:children).class_name('Category').with_foreign_key(:parent_id).dependent(:destroy) }
  it { is_expected.to have_many(:category_categorizables).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name).with_message('The name is required.') }
  it { is_expected.to validate_length_of(:name).is_at_most(255).with_message('The name may contain up to 255 characters.') }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to([:client_id]).with_message('The name is already used.') }
  it { is_expected.to validate_length_of(:slug).is_at_most(255).with_message('The slug may contain up to 255 characters.') }

  describe 'concerns' do
    subject(:model) { FactoryBot.create(:category, :with_parent, :with_children) }

    let(:translation) { FactoryBot.build(:category) }

    it_behaves_like 'SimpleTextSearchable'
    it_behaves_like 'BoundSortable'
    it_behaves_like 'Sluggable'
    it_behaves_like 'Translatable'
    it_behaves_like 'Imageable'
    it_behaves_like 'Parentable'
  end
end