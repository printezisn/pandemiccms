# frozen_string_literal: true

require 'rails_helper'
require './spec/requests/admin/shared/access'

RSpec.describe '/admin/media', type: :request do
  let(:file_attributes) do
    { io: File.open(Rails.root.join('spec/fixtures/test.png')), filename: 'test.png' }
  end

  let!(:admin_user) { FactoryBot.create(:admin_user) }
  let(:signed_in_user) { admin_user }

  let(:model) { FactoryBot.build(:medium, file: file_attributes) }

  before do
    sign_in signed_in_user if signed_in_user
  end

  describe 'GET /index' do
    let(:request) { get admin_media_path }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'returns a successful response' do
      request

      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    let(:params) do
      {
        medium: {
          file: [
            Rack::Test::UploadedFile.new(file_attributes[:io]),
            Rack::Test::UploadedFile.new(file_attributes[:io])
          ]
        }
      }
    end

    let(:request) { post admin_media_path, params: params }

    it_behaves_like 'admin user page'

    it 'redirects to the index page' do
      request

      expect(response).to redirect_to(admin_media_path)
    end

    it 'creates the media' do
      expect { request }.to change(Medium, :count).by(2)
    end
  end

  describe 'DELETE /destroy' do
    let(:request) { delete admin_medium_path(model) }

    before { model.save! }

    it_behaves_like 'admin user page'

    it 'redirects to the index page' do
      request

      expect(response).to redirect_to(admin_media_path)
    end

    it 'destroys the medium' do
      expect { request }.to change(Medium, :count).by(-1)
    end
  end
end
