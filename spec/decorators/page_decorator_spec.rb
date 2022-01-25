# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageDecorator, type: :decorator do
  subject(:model) { create(:page, slug: 'test-slug', template: template).decorate }

  let(:template) { 'default' }

  describe '#path' do
    subject { model.path(language) }

    context 'when the template is index' do
      let(:template) { 'index' }

      context 'when a language is passed' do
        let(:language) { create(:language, locale: 'el-GR') }

        it { is_expected.to eq('/el-GR') }
      end

      context 'when no language is passed' do
        let(:language) { nil }

        it { is_expected.to eq('/en-GB') }
      end
    end

    context 'when the template is not index' do
      context 'when a language is passed' do
        let(:language) { create(:language, locale: 'el-GR') }

        it { is_expected.to eq("/el-GR/pg/#{model.id}/#{model.slug}") }
      end

      context 'when no language is passed' do
        let(:language) { nil }

        it { is_expected.to eq("/en-GB/pg/#{model.id}/#{model.slug}") }
      end
    end
  end
end
