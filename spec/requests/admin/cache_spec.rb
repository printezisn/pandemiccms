# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/admin/shared/access'

RSpec.describe '/admin/cache', type: :request do
  let(:admin_user) { create(:admin_user) }
  let!(:supervisor) { create(:admin_user, :supervisor) }

  let(:signed_in_user) { supervisor }

  before do
    sign_in signed_in_user if signed_in_user
  end

  describe 'POST /clear' do
    let(:request) { post admin_cache_clear_path }

    it_behaves_like 'supervisor page'

    it 'redirects to the dashboard page' do
      request

      expect(response).to redirect_to(admin_root_path)
    end

    it 'bumps cache version' do
      expect { request }.to(change { CacheVersionBumper.call(supervisor.client_id) })
    end
  end
end
