# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Dashboard', type: :request do
  let(:admin_user) { FactoryBot.create(:admin_user) }

  describe 'GET /admin' do
    context 'when the admin user is not authenticated' do
      it 'redirects to the sign in page' do
        get admin_root_path
        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is authenticated' do
      before { sign_in admin_user }

      it 'is successful' do
        get admin_root_path
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
