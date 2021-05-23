# frozen_string_literal: true

require 'rails_helper'
require './spec/models/concerns/simple_text_searchable'
require './spec/models/concerns/bound_sortable'

RSpec.describe Redirect, type: :model do
  subject(:model) { FactoryBot.build(:redirect) }

  it { is_expected.to belong_to(:client) }

  it { is_expected.to validate_presence_of(:from).with_message('The origin (from) is required.') }
  it { is_expected.to validate_presence_of(:to).with_message('The destination (to) is required.') }

  describe 'concerns' do
    before { model.save! }

    it_behaves_like 'SimpleTextSearchable'
    it_behaves_like 'BoundSortable'
  end
end
