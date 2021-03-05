# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/admin/shared/access'

RSpec.describe '/admin/users', type: :request do
  let!(:admin_user) { FactoryBot.create(:admin_user) }
  let!(:supervisor) { FactoryBot.create(:admin_user, :supervisor) }

  let(:signed_in_user) { supervisor }

  before do
    sign_in signed_in_user if signed_in_user
  end

  describe 'GET /index' do
    let(:request) { get admin_users_path }

    it_behaves_like 'supervisor page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    let(:request) { get admin_user_path(admin_user) }

    it_behaves_like 'supervisor page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    let(:request) { get new_admin_user_path }

    it_behaves_like 'supervisor page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    let(:request) { get edit_admin_user_path(admin_user) }

    it_behaves_like 'supervisor page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    let(:user_params) do
      {
        image: Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/test.png'))),
        username: 'newuser',
        email: 'newuser@test.com',
        first_name: admin_user.first_name,
        middle_name: admin_user.middle_name,
        last_name: admin_user.last_name,
        password: admin_user.password,
        password_confirmation: admin_user.password,
        description: admin_user.description
      }
    end

    let(:request) { post admin_users_path, params: { admin_user: user_params } }

    it_behaves_like 'supervisor page'

    context 'with valid parameters' do
      it 'creates a new user' do
        expect { request }.to change(AdminUser, :count).by(1)
      end

      it 'redirects to the created user' do
        request

        expect(response).to redirect_to(admin_user_path(id: AdminUser.last.id, locale: 'en'))
      end
    end

    context 'with invalid parameters' do
      let(:user_params) do
        {
          image: Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/test.png'))),
          username: '',
          email: 'newuser@test.com',
          first_name: admin_user.first_name,
          middle_name: admin_user.middle_name,
          last_name: admin_user.last_name,
          password: admin_user.password,
          password_confirmation: admin_user.password,
          description: admin_user.description
        }
      end

      it 'does not create a new user' do
        expect { request }.not_to change(AdminUser, :count)
      end

      it 'returns a successful response' do
        request

        expect(response).to be_successful
      end
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

    let(:request) { patch admin_user_path(admin_user), params: { admin_user: user_params } }

    before { admin_user }

    it_behaves_like 'supervisor page'

    context 'with valid parameters' do
      it 'updates the requested user' do
        request

        expect(admin_user.reload.first_name).to eq(user_params[:first_name])
      end

      it 'redirects to the user' do
        request

        expect(response).to redirect_to(admin_user_path(id: admin_user.id, locale: 'en'))
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

  describe 'POST /activate' do
    let(:inactive_user) { FactoryBot.create(:admin_user, status: :inactive) }

    let(:request) { post activate_admin_user_path(inactive_user) }

    it_behaves_like 'supervisor page'

    it 'activates the user' do
      expect { request }.to change { inactive_user.reload.status }.from('inactive').to('active')
    end

    it 'redirects to the user' do
      request

      expect(response).to redirect_to(admin_user_path(inactive_user, locale: 'en'))
    end
  end

  describe 'POST /deactivate' do
    let(:request) { post deactivate_admin_user_path(admin_user) }

    it_behaves_like 'supervisor page'

    it 'deactivates the user' do
      expect { request }.to change { admin_user.reload.status }.from('active').to('inactive')
    end

    it 'redirects to the user' do
      request

      expect(response).to redirect_to(admin_user_path(admin_user, locale: 'en'))
    end
  end

  describe 'GET /translate' do
    let(:request) { get translate_admin_user_path(admin_user) }

    it_behaves_like 'supervisor page'

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
      post translate_admin_user_path(admin_user), params: { translation_locale: 'en', admin_user: translation_params }
    end

    it_behaves_like 'supervisor page'

    context 'with valid parameters' do
      it 'translates the requested user' do
        request

        expect(admin_user.reload.translate(:en).attributes.slice(*translation_params.keys)).to eq(translation_params)
      end

      it 'redirects to the user translation' do
        request

        expect(response).to redirect_to(translate_admin_user_path(id: admin_user.id, locale: 'en', translation_locale: 'en'))
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
