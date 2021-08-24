# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostDecorator, type: :decorator do
  subject(:model) { FactoryBot.create(:post, slug: 'test-slug').decorate }

  describe '#path' do
    subject { model.path(language) }

    context 'when a language is passed' do
      let(:language) { FactoryBot.create(:language, locale: 'el-GR') }

      it { is_expected.to eq("/el-GR/p/#{model.id}/#{model.slug}") }
    end

    context 'when no language is passed' do
      let(:language) { nil }

      it { is_expected.to eq("/en-GB/p/#{model.id}/#{model.slug}") }
    end
  end
end
