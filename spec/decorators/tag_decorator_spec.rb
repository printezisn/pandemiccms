# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagDecorator, type: :decorator do
  subject(:model) { FactoryBot.create(:tag, slug: 'test-slug').decorate }

  describe '#path' do
    subject { model.path(language) }

    context 'when a language is passed' do
      let(:language) { FactoryBot.create(:language, locale: 'el-GR') }

      it { is_expected.to eq("/el-GR/t/#{model.id}/#{model.slug}") }
    end

    context 'when no language is passed' do
      let(:language) { nil }

      it { is_expected.to eq("/en-GB/t/#{model.id}/#{model.slug}") }
    end
  end
end
