# frozen_string_literal: true

require 'rails_helper'
require './spec/models/concerns/simple_text_searchable'
require './spec/models/concerns/bound_sortable'
require './spec/models/concerns/translatable'
require './spec/models/concerns/imageable'
require './spec/models/concerns/categorizable'

RSpec.describe Content do
  subject(:model) { build(:content) }

  it { is_expected.to belong_to(:client) }

  it { is_expected.to validate_presence_of(:name).with_message('The name is required.') }
  it { is_expected.to validate_length_of(:name).is_at_most(255).with_message('The name may contain up to 255 characters.') }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to([:client_id]).with_message('The name is already used.') }
  it { is_expected.to validate_presence_of(:order).with_message('The order is required.') }

  describe 'concerns' do
    subject(:model) { create(:content) }

    let(:translation) { build(:content) }

    it_behaves_like 'SimpleTextSearchable'
    it_behaves_like 'BoundSortable'
    it_behaves_like 'Translatable'
    it_behaves_like 'Imageable'
    it_behaves_like 'Categorizable'
  end
end
