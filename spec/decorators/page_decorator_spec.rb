# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageDecorator, type: :decorator do
  subject(:model) { FactoryBot.create(:page, slug: 'test-slug', template: template).decorate }

  let(:template) { 'default' }

  describe '#path' do
    subject { model.path(language) }

    context 'when the template is index' do
      let(:template) { 'index' }

      context 'when a language is passed' do
        let(:language) { FactoryBot.create(:language, locale: 'el') }

        it { is_expected.to eq('/el') }
      end

      context 'when no language is passed' do
        let(:language) { nil }

        it { is_expected.to eq('/en') }
      end
    end

    context 'when the template is not index' do
      context 'when a language is passed' do
        let(:language) { FactoryBot.create(:language, locale: 'el') }

        it { is_expected.to eq("/el/pg/#{model.id}/#{model.slug}") }
      end

      context 'when no language is passed' do
        let(:language) { nil }

        it { is_expected.to eq("/en/pg/#{model.id}/#{model.slug}") }
      end
    end
  end
end
