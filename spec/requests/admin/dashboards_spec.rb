# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/admin/shared/access'

RSpec.describe 'Admin::Dashboard' do
  let!(:admin_user) { create(:admin_user) }
  let(:signed_in_user) { admin_user }

  before do
    sign_in signed_in_user if signed_in_user
  end

  describe 'GET /admin' do
    let(:request) { get admin_root_path }

    it_behaves_like 'admin user page'

    it 'is successful' do
      request

      expect(response).to be_successful
    end
  end
end
