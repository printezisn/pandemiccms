# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/admin/shared/access'

RSpec.describe '/admin/profile' do
  let!(:admin_user) { create(:admin_user) }
  let(:signed_in_user) { admin_user }

  before do
    sign_in signed_in_user if signed_in_user
  end

  describe 'GET /index' do
    let(:request) { get admin_profile_path }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    let(:request) { get admin_profile_edit_path }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'PATCH /update' do
    let(:user_params) do
      {
        image: Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/test.png'))),
        email: admin_user.email,
        first_name: 'New First Name',
        middle_name: admin_user.middle_name,
        last_name: admin_user.last_name,
        description: admin_user.description
      }
    end

    let(:request) { patch admin_profile_edit_path, params: { admin_user: user_params } }

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'updates the current user' do
        request

        expect(admin_user.reload.first_name).to eq(user_params[:first_name])
      end

      it 'redirects to the profile' do
        request

        expect(response).to redirect_to(admin_profile_path)
      end

      it 'bumps cache version' do
        expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
      end
    end

    context 'with invalid parameters' do
      let(:user_params) do
        {
          image: Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/test.png'))),
          email: admin_user.email,
          first_name: Array.new(256) { 'a' }.join,
          middle_name: admin_user.middle_name,
          last_name: admin_user.last_name,
          description: admin_user.description
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /translate' do
    let(:request) { get admin_profile_translate_path }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'POST /translate' do
    let(:translation_params) do
      {
        'first_name' => 'Translated First Name',
        'middle_name' => 'Translated Middle Name',
        'last_name' => 'Translated Last Name',
        'description' => 'Translated description'
      }
    end

    let(:request) do
      post admin_profile_translate_path, params: { translation_locale: 'en-GB', admin_user: translation_params }
    end

    it_behaves_like 'admin user page'

    context 'with valid parameters' do
      it 'translates the profile' do
        request

        expect(admin_user.reload.translate('en-GB').attributes.slice(*translation_params.keys)).to eq(translation_params)
      end

      it 'redirects to the profile translation' do
        request

        expect(response).to redirect_to(admin_profile_translate_path(translation_locale: 'en-GB'))
      end

      it 'bumps cache version' do
        expect { request }.to(change { CacheVersionGetter.call(admin_user.client_id) })
      end
    end

    context 'with invalid parameters' do
      let(:translation_params) do
        {
          'first_name' => Array.new(256) { 'a' }.join,
          'middle_name' => 'Translated Middle Name',
          'last_name' => 'Translated Last Name',
          'description' => 'Translated description'
        }
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
    end
  end
end
