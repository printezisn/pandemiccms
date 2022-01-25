# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/admin/shared/access'

RSpec.describe '/admin/index', type: :request do
  let(:admin_user) { create(:admin_user) }
  let!(:supervisor) { create(:admin_user, :supervisor) }

  let(:signed_in_user) { supervisor }

  before do
    sign_in signed_in_user if signed_in_user
  end

  describe 'POST /start' do
    let(:request) { post admin_index_start_path }

    it_behaves_like 'supervisor page'

    it 'redirects to the dashboard page' do
      request

      expect(response).to redirect_to(admin_root_path)
    end

    it 'enqueues a job to index all entities' do
      request

      expect(IndexAllJob).to have_been_enqueued.exactly(:once)
    end
  end
end
