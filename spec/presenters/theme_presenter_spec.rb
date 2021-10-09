# frozen_string_literal: true

require 'rails_helper'
require './spec/utils/retry'

describe ThemePresenter, type: :presenter do
  let(:client) { FactoryBot.create(:client) }
  let(:locale) { 'en-GB' }
  let(:admin_user) { FactoryBot.create(:admin_user, client: client) }

  let(:presenter) { described_class.new(client.id, locale, admin_user) }

  describe '#menu' do
    subject { presenter.menu(menu.name) }

    let(:menu) { FactoryBot.create(:menu, client: client) }

    let!(:parent1) { FactoryBot.create(:menu_item, menu: menu) }
    let!(:parent2) { FactoryBot.create(:menu_item, menu: menu, sort_order: 2) }
    let!(:child11) { FactoryBot.create(:menu_item, menu: menu, parent: parent1) }
    let!(:child12) { FactoryBot.create(:menu_item, menu: menu, parent: parent1) }
    let!(:child21) { FactoryBot.create(:menu_item, menu: menu, parent: parent2) }

    let(:expected_result) do
      [
        [parent1.reload.decorate, [
          [child12.reload.decorate, []],
          [child11.reload.decorate, []]
        ]],
        [parent2.reload.decorate, [
          [child21.reload.decorate, []]
        ]]
      ]
    end

    it { is_expected.to eq(expected_result) }
  end

  describe '#posts' do
    subject { presenter.posts(only_visible: only_visible).to_a }

    let!(:public_post) { FactoryBot.create(:post, client: client, status: :published) }
    let!(:private_post) { FactoryBot.create(:post, client: client, visibility: :private, status: :published) }
    let!(:draft_post) { FactoryBot.create(:post, status: :draft) }

    let(:only_visible) { true }

    context 'when an admin user is provided' do
      it { is_expected.to contain_exactly(public_post, private_post, draft_post) }
    end

    context 'when an admin user is not provided' do
      let(:admin_user) { nil }

      it { is_expected.to contain_exactly(public_post) }

      context 'when only_visible is false' do
        let(:only_visible) { false }

        it { is_expected.to contain_exactly(public_post, private_post, draft_post) }
      end
    end
  end

  describe '#pages' do
    subject { presenter.pages(only_visible: only_visible).to_a }

    let!(:public_page) { FactoryBot.create(:page, client: client, status: :published) }
    let!(:private_page) { FactoryBot.create(:page, client: client, visibility: :private, status: :published) }
    let!(:draft_page) { FactoryBot.create(:page, status: :draft) }

    let(:only_visible) { true }

    context 'when an admin user is provided' do
      it { is_expected.to contain_exactly(public_page, private_page, draft_page) }
    end

    context 'when an admin user is not provided' do
      let(:admin_user) { nil }

      it { is_expected.to contain_exactly(public_page) }

      context 'when only_visible is false' do
        let(:only_visible) { false }

        it { is_expected.to contain_exactly(public_page, private_page, draft_page) }
      end
    end
  end

  describe '#categories' do
    subject { presenter.categories(only_visible: only_visible, post_id: post&.id).to_a }

    let!(:public_category) { FactoryBot.create(:category, client: client) }
    let!(:private_category) { FactoryBot.create(:category, client: client, visibility: :private) }

    let(:only_visible) { true }
    let(:post) { nil }

    context 'when an admin user is provided' do
      it { is_expected.to contain_exactly(public_category, private_category) }
    end

    context 'when an admin user is not provided' do
      let(:admin_user) { nil }

      it { is_expected.to contain_exactly(public_category) }

      context 'when only_visible is false' do
        let(:only_visible) { false }

        it { is_expected.to contain_exactly(public_category, private_category) }
      end
    end

    context 'when a post id is provided' do
      let(:post_category) { FactoryBot.create(:category, client: client) }
      let(:post) { FactoryBot.create(:post, client: client, categories: [post_category]) }

      it { is_expected.to contain_exactly(post_category) }
    end
  end

  describe '#tags' do
    subject { presenter.tags(only_visible: only_visible, post_id: post&.id).to_a }

    let!(:public_tag) { FactoryBot.create(:tag, client: client) }
    let!(:private_tag) { FactoryBot.create(:tag, client: client, visibility: :private) }

    let(:only_visible) { true }
    let(:post) { nil }

    context 'when an admin user is provided' do
      it { is_expected.to contain_exactly(public_tag, private_tag) }
    end

    context 'when an admin user is not provided' do
      let(:admin_user) { nil }

      it { is_expected.to contain_exactly(public_tag) }

      context 'when only_visible is false' do
        let(:only_visible) { false }

        it { is_expected.to contain_exactly(public_tag, private_tag) }
      end
    end

    context 'when a post id is provided' do
      let(:post_tag) { FactoryBot.create(:tag, client: client) }
      let(:post) { FactoryBot.create(:post, client: client, tags: [post_tag]) }

      it { is_expected.to contain_exactly(post_tag) }
    end
  end

  describe '#t' do
    subject { presenter.t(post).attributes.slice('name', 'description') }

    let(:post) { FactoryBot.create(:post, client: client) }
    let(:translated_description) { 'translated description' }

    before do
      post.description = translated_description
      post.save_translation(locale)
    end

    it { is_expected.to eq({ 'name' => post.name, 'description' => translated_description }) }
  end

  describe '#search' do
    let(:locale) { 'en' }
    let(:post) { FactoryBot.create(:post, status: :published) }
    let(:repo) { Elastic::PostRepository.new(post.client.id, locale) }

    before { repo.save(Elastic::Post.from_entity(locale, post)) }

    it 'returns the matched posts' do
      matched_post_ids = retry_operation(expected_value: [post.id]) do
        presenter.search_posts(post.name).map(&:id)
      end

      expect(matched_post_ids).to contain_exactly(post.id)
    end
  end
end
