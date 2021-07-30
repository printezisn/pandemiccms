# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MenuItemDecorator do
  subject(:model) { FactoryBot.create(:menu_item, external_url: external_url, linkable: linkable).decorate }

  let(:linkable) { nil }
  let(:external_url) { nil }

  describe '#path' do
    subject { model.path(language) }

    let(:language) { FactoryBot.create(:language) }

    context 'when the linkable is a page' do
      let(:linkable) { FactoryBot.create(:page, slug: 'test-slug') }

      it { is_expected.to eq(Rails.application.routes.url_helpers.page_path(id: linkable.id, slug: linkable.slug, locale: language.locale)) }
    end

    context 'when the linkable is a post' do
      let(:linkable) { FactoryBot.create(:post, slug: 'test-slug') }

      it { is_expected.to eq(Rails.application.routes.url_helpers.post_path(id: linkable.id, slug: linkable.slug, locale: language.locale)) }
    end

    context 'when the linkable is a category' do
      let(:linkable) { FactoryBot.create(:category, slug: 'test-slug') }

      it { is_expected.to eq(Rails.application.routes.url_helpers.category_path(id: linkable.id, slug: linkable.slug, locale: language.locale)) }
    end

    context 'when the linkable is a tag' do
      let(:linkable) { FactoryBot.create(:tag, slug: 'test-slug') }

      it { is_expected.to eq(Rails.application.routes.url_helpers.tag_path(id: linkable.id, slug: linkable.slug, locale: language.locale)) }
    end

    context 'when there is an external url' do
      let(:external_url) { 'external url' }

      it { is_expected.to eq(external_url) }
    end
  end
end
