# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/admin/shared/access_spec'

RSpec.describe '/admin/profile', type: :request do
  let!(:admin_user) { FactoryBot.create(:admin_user) }
  let(:signed_in_user) { admin_user }

  before do
    sign_in signed_in_user if signed_in_user
  end

  describe 'GET /edit' do
    let(:request) { get admin_password_edit_path }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'PATCH /update' do
    let(:user_params) do
      {
        current_password: admin_user.password,
        password: 'T34tPa$$2',
        password_confirmation: 'T34tPa$$2'
      }
    end

    let(:request) { patch admin_password_edit_path, params: { admin_user: user_params } }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'updates the password' do
        request

        expect(admin_user.reload).to be_valid_password(user_params[:password])
      end

      it 'redirects to the sign in page' do
        request

        expect(response).to redirect_to(admin_root_path(locale: 'en'))
      end
    end

    context 'with invalid parameters' do
      let(:user_params) do
        {
          current_password: 'pass',
          password: 'T34tPa$$2',
          password_confirmation: 'T34tPa$$2'
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end
end
