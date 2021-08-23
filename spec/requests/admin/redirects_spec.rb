# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/admin/shared/access'

RSpec.describe '/admin/redirects', type: :request do
  let!(:admin_user) { FactoryBot.create(:admin_user) }
  let(:signed_in_user) { admin_user }

  let(:model) { FactoryBot.build(:redirect) }

  before do
    sign_in signed_in_user if signed_in_user
  end

  describe 'GET /index' do
    let(:request) { get admin_redirects_path }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    let(:request) { get admin_redirect_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    let(:request) { get new_admin_redirect_path }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    let(:request) { get edit_admin_redirect_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    let(:redirect_params) do
      {
        from: model.from,
        to: model.to
      }
    end

    let(:request) { post admin_redirects_path, params: { redirect: redirect_params } }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'creates a new redirect' do
        expect { request }.to change(Redirect, :count).by(1)
      end

      it 'redirects to the created redirect' do
        request

        expect(response).to redirect_to(admin_redirect_path(id: Redirect.last.id))
      end
    end

    context 'with invalid parameters' do
      let(:redirect_params) do
        {
          from: '',
          to: model.to
        }
      end

      it 'does not create a new redirect' do
        expect { request }.not_to change(Redirect, :count)
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    let(:redirect_params) do
      {
        from: '/en/updated_from',
        to: model.to
      }
    end

    let(:request) { patch admin_redirect_path(model), params: { redirect: redirect_params } }

    before { model.save! }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'updates the requested redirect' do
        request

        expect(model.reload.from).to eq(redirect_params[:from])
      end

      it 'redirects to the redirect' do
        request

        expect(response).to redirect_to(admin_redirect_path(id: model.id))
      end
    end

    context 'with invalid parameters' do
      let(:redirect_params) do
        {
          from: '',
          to: model.to
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    let(:request) { delete admin_redirect_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'destroys the requested redirect' do
      expect { request }.to change(Redirect, :count).by(-1)
    end

    it 'redirects to the redirects list' do
      request

      expect(response).to redirect_to(admin_redirects_path)
    end
  end
end
