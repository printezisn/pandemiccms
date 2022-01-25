# frozen_string_literal: true

require 'rails_helper'
require './spec/models/concerns/simple_text_searchable'
require './spec/models/concerns/bound_sortable'
require './spec/models/concerns/translatable'

RSpec.describe Menu, type: :model do
  subject(:model) { build(:menu) }

  it { is_expected.to belong_to(:client) }
  it { is_expected.to have_many(:menu_items).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name).with_message('The name is required.') }
  it { is_expected.to validate_length_of(:name).is_at_most(255).with_message('The name may contain up to 255 characters.') }

  describe 'concerns' do
    let(:translation) { build(:tag) }

    before { model.save! }

    it_behaves_like 'SimpleTextSearchable'
    it_behaves_like 'BoundSortable'
    it_behaves_like 'Translatable'
  end
end
