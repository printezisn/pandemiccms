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
end
