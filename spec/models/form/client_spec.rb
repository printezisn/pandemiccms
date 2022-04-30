# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Form::Client, type: :model do
  let(:model) { described_class.new }

  it { is_expected.to validate_presence_of(:client_name).with_message('The name is required.') }
  it { is_expected.to validate_length_of(:client_name).is_at_most(255).with_message('The name may contain up to 255 characters.') }
  it { is_expected.to allow_value('sample').for(:client_template) }
  it { is_expected.not_to allow_value('invalid_template').for(:client_template).with_message('The template is required.') }
  it { is_expected.to validate_presence_of(:admin_email).with_message('The email is required.') }
  it { is_expected.to validate_length_of(:admin_email).is_at_most(255).with_message('The email may contain up to 255 characters.') }
  it { is_expected.to allow_value('test@test.com').for(:admin_email) }
  it { is_expected.not_to allow_value('testuser').for(:admin_email).with_message('The email format is invalid.') }
  it { is_expected.to validate_presence_of(:admin_username).with_message('The username is required.') }
  it { is_expected.to validate_length_of(:admin_username).is_at_most(50).with_message('The username may contain up to 50 characters.') }
  it { is_expected.to allow_value('test.-usER0').for(:admin_username) }

  it do
    expect(model).not_to allow_value('test@test.com')
      .for(:admin_username)
      .with_message('The username must contain only letters, digits, dashes and dots.')
  end

  it { is_expected.to validate_presence_of(:admin_password).with_message('The password is required.') }
  it { is_expected.to validate_length_of(:admin_password).is_at_most(128).with_message('The password may contain up to 128 characters.') }
  it { is_expected.to allow_value('T3$tPa$$').for(:admin_password) }

  it do
    expect(model).not_to allow_value('test1234')
      .for(:admin_password)
      .with_message('The password must contain at least 1 upper case character, 1 lower case, 1 digit and 1 symbol (@#$!%*?&^).')
  end

  describe 'domains' do
    subject { model.errors.messages[:domains] }

    let(:model) { described_class.new(domains:, ports:) }

    let(:domains) { [] }
    let(:ports) { [] }

    before { model.validate }

    context 'when there are no domains' do
      it { is_expected.to include('The domains are required and cannot be empty.') }
    end

    context 'when some domains are empty' do
      let(:domains) { %w[localhost] }
      let(:ports) { %w[3000 8000] }

      it { is_expected.to include('The domains are required and cannot be empty.') }
    end

    context 'when some domains are already in use' do
      let(:domains) { %w[localhost] }
      let(:ports) { %w[3000] }

      let(:existing_client) { create(:client) }

      before do
        existing_client.client_domains.create!(domain: domains[0], port: ports[0])
        model.validate
      end

      it { is_expected.to include('Some domains are already in use.') }
    end

    context 'when no domain is in use' do
      let(:domains) { %w[localhost] }
      let(:ports) { %w[3000] }

      let(:existing_client) { create(:client) }

      before do
        existing_client.client_domains.create!(domain: domains[0], port: 8000)
        model.validate
      end

      it { is_expected.to be_blank }
    end
  end

  describe 'ports' do
    subject { model.errors.messages[:ports] }

    let(:model) { described_class.new(domains:, ports:) }

    let(:domains) { [] }
    let(:ports) { [] }

    before { model.validate }

    context 'when there are no ports' do
      it { is_expected.to include('The ports are required and cannot be empty.') }
    end

    context 'when some ports are empty' do
      let(:domains) { %w[localhost other_domain] }
      let(:ports) { %w[3000] }

      it { is_expected.to include('The ports are required and cannot be empty.') }
    end

    context 'when some ports are invalid' do
      let(:domains) { %w[localhost other_domain] }
      let(:ports) { %w[3000 3000a] }

      it { is_expected.to include('The ports must be valid numbers.') }
    end

    context 'when all ports are valid' do
      let(:domains) { %w[localhost other_domain] }
      let(:ports) { %w[3000 8000] }

      it { is_expected.to be_blank }
    end
  end

  describe '#save' do
    subject(:action) { model.save }

    let(:languages) { create_list(:language, 2) }
    let(:model) { described_class.new(attributes) }

    context 'when it is a new client' do
      let(:attributes) do
        {
          client_name: 'Test Client',
          client_template: 'sample',
          domains: %w[localhost],
          ports: %w[3000],
          language_ids: languages.map { |l| l.id.to_s },
          admin_email: 'test@test.com',
          admin_username: 'testuser',
          admin_password: 'T3$tPa$$',
          admin_password_confirmation: 'T3$tPa$$'
        }
      end

      context 'when the model is invalid' do
        before { attributes[:client_name] = '' }

        it { is_expected.to be_falsey }
      end

      context 'when the model is valid' do
        it { is_expected.to be_truthy }
      end

      it 'creates a new client' do
        expect { action }.to change(::Client, :count).by(1)
      end

      it 'creates a new supervisor user' do
        expect { action }.to change { AdminUserRole.supervisor.count }.by(1)
      end

      it 'sets the client domains and ports' do
        action

        expect(Client.last.client_domains.pluck(:domain, :port)).to contain_exactly(['localhost', 3000])
      end

      it 'sets the client languages' do
        action

        expect(Client.last.client_languages.map(&:language_id)).to match_array(languages.map(&:id))
      end
    end

    context 'when it is an existing client' do
      let(:client) { create(:client) }

      let(:attributes) do
        {
          client_id: client.id,
          client_name: 'Test Client',
          domains: %w[localhost],
          ports: %w[3000],
          language_ids: languages.map { |l| l.id.to_s }
        }
      end

      context 'when the model is invalid' do
        before { attributes[:client_name] = '' }

        it { is_expected.to be_falsey }
      end

      context 'when the model is valid' do
        it { is_expected.to be_truthy }
      end

      it 'updates the client' do
        expect { action }.to change { client.reload.name }.to('Test Client')
      end

      it 'does not create any user' do
        expect { action }.not_to(change { AdminUserRole.supervisor.count })
      end

      it 'sets the client domains and ports' do
        action

        expect(Client.last.client_domains.pluck(:domain, :port)).to contain_exactly(['localhost', 3000])
      end

      it 'sets the client languages' do
        action

        expect(client.reload.client_languages.map(&:language_id)).to match_array(languages.map(&:id))
      end
    end
  end
end
