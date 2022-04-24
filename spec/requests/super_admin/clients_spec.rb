# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/admin/shared/access'

RSpec.describe '/super_admin/clients' do
  let(:headers) do
    {
      HTTP_AUTHORIZATION: ActionController::HttpAuthentication::Basic.encode_credentials(
        Rails.application.credentials.super_admin[:username].to_s,
        Rails.application.credentials.super_admin[:password].to_s
      )
    }
  end

  let(:model) { build(:client) }

  describe 'GET /index' do
    let(:request) { get super_admin_clients_path, headers: }

    before { model.save! }

    it_behaves_like 'super admin page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    let(:request) { get new_super_admin_client_path, headers: }

    it_behaves_like 'super admin page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    let(:request) { post super_admin_clients_path, params:, headers: }
    let(:languages) { create_list(:language, 2) }
    let(:params) do
      {
        form_client: {
          client_name: 'Test Client',
          client_template: 'sample',
          language_ids: languages.map { |l| l.id.to_s },
          default_language_id: languages.second.id.to_s,
          domains: %w[localhost],
          ports: %w[3000],
          admin_email: 'test@test.com',
          admin_username: 'testuser',
          admin_password: 'T3$tPa$$',
          admin_password_confirmation: 'T3$tPa$$'
        }
      }
    end

    it_behaves_like 'super admin page'

    context 'with valid parameters' do
      it 'creates a new client' do
        expect { request }.to change(::Client, :count).by(1)
      end

      it 'creates a new supervisor user' do
        expect { request }.to change { AdminUserRole.supervisor.count }.by(1)
      end

      it 'redirects to the created client' do
        request

        expect(response).to redirect_to(super_admin_client_path(::Client.last))
      end
    end

    context 'with invalid parameters' do
      before { params[:form_client][:client_name] = '' }

      it 'does not create a new client' do
        expect { request }.not_to change(::Client, :count)
      end

      it 'does not create a new supervisor user' do
        expect { request }.not_to change(AdminUser, :count)
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    let(:request) { get super_admin_client_path(model), headers: }

    before { model.save! }

    it_behaves_like 'super admin page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end
end
