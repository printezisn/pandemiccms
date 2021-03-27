# frozen_string_literal: true

require 'rails_helper'
require './spec/models/concerns/simple_text_searchable'
require './spec/models/concerns/bound_sortable'
require './spec/models/concerns/sluggable'
require './spec/models/concerns/translatable'
require './spec/models/concerns/imageable'
require './spec/models/concerns/taggable'
require './spec/models/concerns/draftable'

RSpec.describe Post, type: :model do
  subject(:model) { FactoryBot.build(:post, author: author) }

  let(:author) { FactoryBot.create(:admin_user) }

  it { is_expected.to belong_to(:client) }
  it { is_expected.to belong_to(:author).class_name('AdminUser').optional(true) }

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

    context 'when the post does not have public visibility' do
      let(:visibility) { :private }

      it { is_expected.to be_falsey }
    end

    context 'when the post is not published' do
      let(:status) { :draft }

      it { is_expected.to be_falsey }
    end

    context 'when the post has public visibility and is published' do
      it { is_expected.to be_truthy }
    end
  end

  describe 'concerns' do
    subject(:model) { FactoryBot.create(:post) }

    let(:translation) { FactoryBot.build(:post) }

    it_behaves_like 'SimpleTextSearchable'
    it_behaves_like 'BoundSortable'
    it_behaves_like 'Sluggable'
    it_behaves_like 'Translatable'
    it_behaves_like 'Imageable'
    it_behaves_like 'Taggable'
    it_behaves_like 'Draftable'
  end
end
