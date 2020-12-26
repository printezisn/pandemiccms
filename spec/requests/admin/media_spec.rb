# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/admin/media', type: :request do
  let(:file_attributes) do
    { io: File.open(Rails.root.join('spec/fixtures/test.png')), filename: 'test.png' }
  end

  let(:admin_user) { FactoryBot.create(:admin_user) }

  let(:model) { FactoryBot.build(:medium, file: file_attributes) }

  describe 'GET /index' do
    before { model.save! }

    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        get admin_media_path

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is signed in' do
      before { sign_in admin_user }

      it 'returns a successful response' do
        get admin_media_path

        expect(response).to be_successful
      end
    end
  end

  describe 'POST /create' do
    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        post admin_media_path

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is signed in' do
      let(:params) do
        {
          medium: {
            file: Rack::Test::UploadedFile.new(file_attributes[:io])
          }
        }
      end

      before { sign_in admin_user }

      it 'redirects to the index page' do
        post admin_media_path, params: params

        expect(response).to redirect_to(admin_media_path(locale: 'en'))
      end

      it 'creates the medium' do
        expect { post admin_media_path, params: params }.to change(Medium, :count).by(1)
      end
    end
  end

  describe 'DELETE /destroy' do
    before { model.save! }

    context 'when the admin user is not signed in' do
      it 'redirects to the sign in page' do
        delete admin_medium_path(model)

        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'when the admin user is signed in' do
      before { sign_in admin_user }

      it 'redirects to the index page' do
        delete admin_medium_path(model)

        expect(response).to redirect_to(admin_media_path(locale: 'en'))
      end

      it 'destroys the medium' do
        expect { delete admin_medium_path(model) }.to change(Medium, :count).by(-1)
      end
    end
  end
end
