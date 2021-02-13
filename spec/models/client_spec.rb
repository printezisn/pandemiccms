# frozen_string_literal: true

require 'rails_helper'

require './spec/models/concerns/imageable_spec'

RSpec.describe Client, type: :model do
  subject(:model) { FactoryBot.build(:client) }

  it { is_expected.to have_many(:client_domains).dependent(:destroy) }
  it { is_expected.to have_many(:client_languages).dependent(:destroy) }
  it { is_expected.to have_many(:languages).through(:client_languages) }
  it { is_expected.to have_many(:admin_users).dependent(:destroy) }
  it { is_expected.to have_many(:media).dependent(:destroy) }
  it { is_expected.to have_many(:tags).dependent(:destroy) }
  it { is_expected.to have_many(:posts).dependent(:destroy) }
  it { is_expected.to have_many(:pages).dependent(:destroy) }
  it { is_expected.to have_many(:email_templates).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:name).with_message('The name is required.') }

  it { is_expected.to validate_length_of(:email).is_at_most(255).with_message('The email may contain up to 255 characters.') }
  it { is_expected.to allow_value('test@test.com').for(:email) }
  it { is_expected.not_to allow_value('test').for(:email).with_message('The email format is invalid.') }

  describe '#default_url_options' do
    let(:client_domain) { model.client_domains.first }

    it { expect(model.default_url_options).to eq({ host: client_domain.domain, port: client_domain.port }) }
  end

  describe '#enabled_client_languages' do
    let!(:enabled_client_language) { FactoryBot.create(:client_language, client_id: model.id, enabled: true) }

    before { FactoryBot.create(:client_language, client_id: model.id) }

    it 'returns only the enabled client languages' do
      expect(model.enabled_client_languages).to contain_exactly(enabled_client_language)
    end
  end

  describe '#enabled_languages' do
    let!(:enabled_client_language) { FactoryBot.create(:client_language, client_id: model.id, enabled: true) }

    before { FactoryBot.create(:client_language, client_id: model.id) }

    it 'returns only the enabled languages' do
      expect(model.enabled_languages).to contain_exactly(enabled_client_language.language)
    end
  end

  describe '#default_language' do
    let!(:non_default_client_language) { FactoryBot.create(:client_language, client_id: model.id, enabled: true) }
    let!(:default_client_language) { FactoryBot.create(:client_language, client_id: model.id, enabled: enabled_default_language, default: true) }
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

  it_behaves_like 'Imageable'
end
