# frozen_string_literal: true

require 'rails_helper'
require './spec/models/concerns/simple_text_searchable'
require './spec/models/concerns/bound_sortable'

RSpec.describe Page, type: :model do
  subject(:model) { FactoryBot.build(:page) }

  it { is_expected.to belong_to(:client) }
  it { is_expected.to have_many(:tag_taggables).dependent(:destroy) }
  it { is_expected.to have_many(:tags).through(:tag_taggables) }

  describe 'concerns' do
    before { model.save! }

    it_behaves_like 'SimpleTextSearchable'
    it_behaves_like 'BoundSortable'
  end
end
