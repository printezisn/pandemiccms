# frozen_string_literal: true

require 'rails_helper'

require './spec/models/concerns/simple_text_searchable'
require './spec/models/concerns/bound_sortable'
require './spec/models/concerns/imageable'

RSpec.describe Client do
  subject(:model) { build(:client) }

  it { is_expected.to have_many(:client_domains).dependent(:destroy) }
  it { is_expected.to have_many(:client_languages).dependent(:destroy) }
  it { is_expected.to have_many(:languages).through(:client_languages) }
  it { is_expected.to have_many(:admin_users).dependent(:destroy) }
  it { is_expected.to have_many(:media).dependent(:destroy) }
  it { is_expected.to have_many(:tags).dependent(:destroy) }
  it { is_expected.to have_many(:posts).dependent(:destroy) }
  it { is_expected.to have_many(:pages).dependent(:destroy) }
  it { is_expected.to have_many(:email_templates).dependent(:destroy) }
  it { is_expected.to have_many(:menus).dependent(:destroy) }
  it { is_expected.to have_many(:redirects).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name).with_message('The name is required.') }

  it { is_expected.to validate_length_of(:email).is_at_most(255).with_message('The email may contain up to 255 characters.') }
  it { is_expected.to allow_value('test@test.com').for(:email) }
  it { is_expected.not_to allow_value('test').for(:email).with_message('The email format is invalid.') }

  context 'when :cache_enabled? is false' do
    it { is_expected.not_to validate_presence_of(:cache_duration) }
  end

  context 'when :cache_enabled? is true' do
    before { model.cache_enabled = true }

    it { is_expected.to validate_presence_of(:cache_duration).with_message('The cache duration is required.') }
  end

  describe '#valid_time_zone' do
    context 'when invalid time zone' do
      before { model.time_zone = 'invalid' }

      it { is_expected.to be_invalid }
    end

    context 'when valid time zone' do
      before { model.time_zone = 'UTC' }

      it { is_expected.to be_valid }
    end
  end

  describe '#default_url_options' do
    let(:client_domain) { model.client_domains.first }

    context 'when the port is not 443' do
      it { expect(model.default_url_options).to eq({ host: client_domain.domain, port: client_domain.port, protocol: 'http' }) }
    end

    context 'when the port is 443' do
      before { client_domain.update!(port: 443) }

      it { expect(model.default_url_options).to eq({ host: client_domain.domain, port: client_domain.port, protocol: 'https' }) }
    end
  end

  describe '#enabled_client_languages' do
    let!(:enabled_client_language) { create(:client_language, client_id: model.id, enabled: true) }

    before { create(:client_language, client_id: model.id) }

    it 'returns only the enabled client languages' do
      expect(model.enabled_client_languages).to contain_exactly(enabled_client_language)
    end
  end

  describe '#enabled_languages' do
    let!(:enabled_client_language) { create(:client_language, client_id: model.id, enabled: true) }

    before { create(:client_language, client_id: model.id) }

    it 'returns only the enabled languages' do
      expect(model.enabled_languages).to contain_exactly(enabled_client_language.language)
    end
  end

  describe '#default_language' do
    let!(:non_default_client_language) { create(:client_language, client_id: model.id, enabled: true) }
    let!(:default_client_language) { create(:client_language, client_id: model.id, enabled: enabled_default_language, default: true) }
    let(:enabled_default_language) { true }

    context 'when there is a default language' do
      it 'returns the default language' do
        expect(model.default_language).to eq(default_client_language.language)
      end
    end

    context 'when there is no default language' do
      let(:enabled_default_language) { false }

      it 'returns the first available language' do
        expect(model.default_language).to eq(non_default_client_language.language)
      end
    end

    context 'when there is no enabled language' do
      let(:enabled_default_language) { false }

      before { non_default_client_language.destroy }

      it 'returns nil' do
        expect(model.default_language).to be_nil
      end
    end
  end

  describe 'concerns' do
    subject(:model) { create(:client) }

    it_behaves_like 'SimpleTextSearchable'
    it_behaves_like 'BoundSortable'
    it_behaves_like 'Imageable'
  end
end
