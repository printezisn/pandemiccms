# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client, type: :model do
  subject(:model) { FactoryBot.build(:client) }

  it { is_expected.to have_many(:client_domains).dependent(:destroy) }
  it { is_expected.to have_many(:client_languages).dependent(:destroy) }
  it { is_expected.to have_many(:languages).through(:client_languages) }
  it { is_expected.to have_many(:admin_users).dependent(:destroy) }
  it { is_expected.to have_many(:media).dependent(:destroy) }
  it { is_expected.to have_many(:tags).dependent(:destroy) }
  it { is_expected.to have_many(:posts).dependent(:destroy) }

  describe '#default_url_options' do
    let(:client_domain) { model.client_domains.first }

    it { expect(model.default_url_options).to eq({ host: client_domain.domain, port: client_domain.port }) }
  end
end
