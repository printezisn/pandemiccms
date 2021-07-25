# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoryDecorator, type: :decorator do
  subject(:model) { FactoryBot.create(:category, slug: 'test-slug').decorate }

  describe '#path' do
    subject { model.path(language) }

    context 'when a language is passed' do
      let(:language) { FactoryBot.create(:language, locale: 'el') }

      it { is_expected.to eq("/el/c/#{model.id}/#{model.slug}") }
    end

    context 'when no language is passed' do
      let(:language) { nil }

      it { is_expected.to eq("/en/c/#{model.id}/#{model.slug}") }
    end
  end
end
