# frozen_string_literal: true

require 'rails_helper'
require './spec/models/concerns/translatable'
require './spec/models/concerns/parentable'

RSpec.describe MenuItem, type: :model do
  subject(:model) { build(:menu_item) }

  it { is_expected.to belong_to(:menu) }
  it { is_expected.to belong_to(:linkable).optional(true) }
  it { is_expected.to belong_to(:parent).class_name('MenuItem').optional(true) }
  it { is_expected.to have_many(:children).class_name('MenuItem').with_foreign_key(:parent_id).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name).with_message('The name is required.') }
  it { is_expected.to validate_length_of(:name).is_at_most(255).with_message('The name may contain up to 255 characters.') }

  context 'when there is no linkable' do
    it { is_expected.to validate_presence_of(:external_url).with_message('The external URL is required.') }
  end

  context 'when there is a linkable' do
    let(:linkable) { create(:page) }

    before { model.linkable = linkable }

    it { is_expected.not_to validate_presence_of(:external_url).with_message('The external URL is required.') }
  end

  describe '#valid_linkable' do
    subject(:model) { create(:menu_item) }

    let(:linkable) { create(:page) }

    before { model.linkable = linkable }

    context 'when the linkable belongs to the same client' do
      it { is_expected.to be_valid }
    end

    context 'when the linkable does not belong to the same client' do
      before { model.menu.client_id = 0 }

      it { is_expected.to be_invalid }
    end
  end

  describe '#update_sibling_ordering' do
    subject do
      [menu_item1, menu_item2, menu_item3, *menu_item3.children, menu_item4].map do |menu_item|
        menu_item.reload.sort_order
      end
    end

    let!(:menu_item1) { create(:menu_item) }
    let!(:menu_item2) { create(:menu_item, menu_id: menu_item1.menu_id, sort_order: 2) }
    let!(:menu_item3) { create(:menu_item, :with_children, menu_id: menu_item1.menu_id, sort_order: 2) }
    let!(:menu_item4) { create(:menu_item, menu_id: menu_item1.menu_id, sort_order: 4) }

    before do
      menu_item1.update!(sort_order: 3)
      menu_item3.children[0].update!(parent_id: nil, sort_order: 3)
    end

    it { is_expected.to eq([4, 2, 1, 3, 1, 5]) }
  end

  describe 'concerns' do
    subject(:model) { create(:menu_item, :with_parent, :with_children) }

    let(:translation) { build(:menu_item) }

    it_behaves_like 'Translatable'
    it_behaves_like 'Parentable'
  end
end
