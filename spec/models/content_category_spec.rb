# frozen_string_literal: true

require 'rails_helper'
require './spec/models/concerns/simple_text_searchable'
require './spec/models/concerns/bound_sortable'

RSpec.describe ContentCategory do
  subject(:model) { build(:content_category) }

  it { is_expected.to belong_to(:client) }
  it { is_expected.to have_many(:content_category_contents).dependent(:destroy) }
  it { is_expected.to have_many(:contents).through(:content_category_contents) }

  it { is_expected.to validate_presence_of(:name).with_message('The name is required.') }
  it { is_expected.to validate_length_of(:name).is_at_most(255).with_message('The name may contain up to 255 characters.') }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to([:client_id]).with_message('The name is already used.') }
  it { is_expected.to validate_length_of(:description).is_at_most(255).with_message('The description may contain up to 255 characters.') }

  describe 'concerns' do
    subject(:model) { create(:content_category) }

    it_behaves_like 'SimpleTextSearchable'
    it_behaves_like 'BoundSortable'
  end
end
