# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/admin/shared/access'

RSpec.describe '/admin/clients', type: :request do
  let(:admin_user) { FactoryBot.create(:admin_user) }
  let(:supervisor) { FactoryBot.create(:admin_user, :supervisor) }

  let(:signed_in_user) { supervisor }

  let(:client) { supervisor.client }
  let!(:client_languages) { FactoryBot.create_list(:client_language, 2, client: client) }

  before do
    sign_in signed_in_user if signed_in_user
  end

  describe 'GET /edit' do
    let(:request) { get admin_client_edit_path }

    it_behaves_like 'supervisor page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'PATCH /update' do
    let(:params) do
      {
        client: {
          image: Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/test.png'))),
          name: 'Test Client Name',
          time_zone: 'Athens',
          email: 'testnew@email.com',
          cache_enabled: true,
          cache_duration: 10
        },
        language_ids: [client_languages.first.id.to_s],
        default_language_id: client_languages.first.id.to_s
      }
    end

    let(:request) { patch admin_client_edit_path, params: params }

    it_behaves_like 'supervisor page'

    context 'when the params are valid' do
      it 'redirects to the edit page' do
        request

        expect(response).to redirect_to(admin_client_edit_path(locale: 'en'))
      end

      it 'updates the client' do
        request

        client.reload

        expect(client.image).to be_attached
        expect(client.name).to eq(params[:client][:name])
        expect(client.enabled_client_languages.map(&:id)).to contain_exactly(client_languages.first.id)
        expect(client.default_language.id).to eq(client_languages.first.language_id)
      end
    end

    context 'when the params are invalid' do
      let(:params) do
        {
          client: {
            image: Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/test.png'))),
            name: '',
            time_zone: 'Athens',
            email: 'testnew@email.com',
            cache_enabled: true,
            cache_duration: 10
          },
          language_ids: [client_languages.first.id.to_s],
          default_language_id: client_languages.first.id.to_s
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end
end
