# frozen_string_literal: true

require 'rails_helper'
require './spec/models/concerns/simple_text_searchable'
require './spec/models/concerns/bound_sortable'
require './spec/models/concerns/sluggable'
require './spec/models/concerns/translatable'
require './spec/models/concerns/imageable'
require './spec/models/concerns/parentable'
require './spec/models/concerns/taggable'
require './spec/models/concerns/draftable'

RSpec.describe Page, type: :model do
  subject(:model) { FactoryBot.build(:page, author: author) }

  let(:author) { FactoryBot.create(:admin_user) }

  it { is_expected.to belong_to(:client) }
  it { is_expected.to belong_to(:author).class_name('AdminUser').optional(true) }
  it { is_expected.to belong_to(:parent).class_name('Page').optional(true) }
  it { is_expected.to have_many(:children).class_name('Page').with_foreign_key(:parent_id).dependent(:destroy) }
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

    context 'when the page does not have public visibility' do
      let(:visibility) { :private }

      it { is_expected.to be_falsey }
    end

    context 'when the page is not published' do
      let(:status) { :draft }

      it { is_expected.to be_falsey }
    end

    context 'when the page has public visibility and is published' do
      it { is_expected.to be_truthy }
    end
  end

  describe '#translated_tags' do
    subject(:model) { FactoryBot.create(:page, author: author, tags: tags) }

    let(:tags) { FactoryBot.create_list(:tag, 2) }

    before do
      tags.each.with_index(1) do |tag, index|
        tag.name = "Translated Tag #{index}"
        tag.save_translation(:en)
      end
    end

    it 'returns the translated tags' do
      expect(model.translated_tags(:en).map(&:name)).to contain_exactly('Translated Tag 1', 'Translated Tag 2')
    end
  end

  describe 'concerns' do
    subject(:model) { FactoryBot.create(:page, :with_parent, :with_children) }

    let(:translation) { FactoryBot.build(:page) }

    it_behaves_like 'SimpleTextSearchable'
    it_behaves_like 'BoundSortable'
    it_behaves_like 'Sluggable'
    it_behaves_like 'Translatable'
    it_behaves_like 'Imageable'
    it_behaves_like 'Parentable'
    it_behaves_like 'Taggable'
    it_behaves_like 'Draftable'
  end
end
