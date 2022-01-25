# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientCreator do
  subject(:service_call) { described_class.call(name, template, domains_and_ports, locales, supervisor_email) }

  let(:name) { 'TestClient' }
  let(:template) { 'sample' }
  let(:domains_and_ports) { ['localhost:3000'] }
  let(:locales) { %w[en-GB] }
  let(:supervisor_email) { 'admin@pandemiccms.com' }

  let(:client) { Client.find_by(name:) }
  let(:client_domains) do
    client.client_domains.map { |client_domain| "#{client_domain.domain}:#{client_domain.port}" }
  end
  let(:client_locales) { client.languages.map(&:locale) }
  let(:admin_user) { AdminUser.find_by(email: supervisor_email) }

  shared_examples 'creating the client and the supervisor user' do
    it { is_expected.to be_empty }

    it 'creates the client' do
      service_call

      expect(client).not_to be_nil
      expect(client.template).to eq(template)
      expect(client_domains).to match_array(domains_and_ports)
      expect(client_locales).to match_array(expected_locales)
      expect(admin_user).not_to be_nil
      expect(admin_user).to be_supervisor
      expect(admin_user).not_to be_confirmed
    end
  end

  context 'when specific locales are passed' do
    let(:expected_locales) { locales }

    it_behaves_like 'creating the client and the supervisor user'
  end

  context 'when no specific locales are passed' do
    let(:locales) { [] }

    let(:expected_locales) { %w[en-GB el-GR] }

    it_behaves_like 'creating the client and the supervisor user'
  end

  context 'when there are client errors' do
    let(:name) { '' }

    it { is_expected.to be_present }

    it 'does not create the client and supervisor user' do
      expect(client).to be_nil
      expect(admin_user).to be_nil
    end
  end

  context 'when there are user errors' do
    let(:supervisor_email) { nil }

    it { is_expected.to be_present }

    it 'does not create the client and supervisor user' do
      expect(client).to be_nil
      expect(admin_user).to be_nil
    end
  end
end
