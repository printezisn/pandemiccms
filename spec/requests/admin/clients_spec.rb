# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/admin/clients', type: :request do
  let(:admin_user) { FactoryBot.create(:admin_user) }
  let(:supervisor) { FactoryBot.create(:admin_user, :supervisor) }

  let(:client) { supervisor.client }
  let!(:client_languages) { FactoryBot.create_list(:client_language, 2, client: client) }

  describe 'GET /edit' do
    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        get admin_client_edit_path

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is not a supervisor' do
      before { sign_in admin_user }

      it 'redirects to the sign in page' do
        get admin_client_edit_path

        expect(response).to redirect_to(admin_root_path(locale: 'en'))
      end
    end

    context 'when the admin user is a supervisor' do
      before { sign_in supervisor }

      it 'returns a successful response' do
        get admin_client_edit_path

        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    let(:params) do
      {
        client: {
          name: 'Test Client Name',
          show_search_page: true,
          show_category_page: true,
          show_tag_page: true
        },
        language_ids: [client_languages.first.id.to_s],
        default_language_id: client_languages.first.id.to_s
      }
    end

    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        patch admin_client_edit_path, params: params

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is not a supervisor' do
      before { sign_in admin_user }

      it 'redirects to the sign in page' do
        patch admin_client_edit_path, params: params

        expect(response).to redirect_to(admin_root_path(locale: 'en'))
      end
    end

    context 'when the admin user is a supervisor' do
      before { sign_in supervisor }

      context 'when the params are valid' do
        it 'redirects to the edit page' do
          patch admin_client_edit_path, params: params

          expect(response).to redirect_to(admin_client_edit_path(locale: 'en'))
        end

        it 'updates the client' do
          patch admin_client_edit_path, params: params

          client.reload

          expect(client.name).to eq(params[:client][:name])
          expect(client.show_search_page).to eq(params[:client][:show_search_page])
          expect(client.show_category_page).to eq(params[:client][:show_category_page])
          expect(client.show_tag_page).to eq(params[:client][:show_tag_page])
          expect(client.enabled_client_languages.map(&:id)).to contain_exactly(client_languages.first.id)
          expect(client.default_language.id).to eq(client_languages.first.language_id)
        end
      end

      context 'when the params are invalid' do
        it 'returns a successful response' do
          patch admin_client_edit_path, params: { client: { name: '' } }

          expect(response).to be_successful
        end
      end
    end
  end
end
