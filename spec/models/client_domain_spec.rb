# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientDomain, type: :model do
  subject(:model) { build(:client_domain) }

  it { is_expected.to belong_to(:client) }

  describe '#url_options' do
    subject { model.url_options }

    context 'when the port is not 443' do
      it { is_expected.to eq({ host: model.domain, port: model.port, protocol: 'http' }) }
    end

    context 'when the port is 443' do
      before { model.port = 443 }

      it { is_expected.to eq({ host: model.domain, port: model.port, protocol: 'https' }) }
    end
  end
end
