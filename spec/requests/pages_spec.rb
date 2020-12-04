# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  before { FactoryBot.create(:client) }

  describe 'GET /' do
    it 'is successful' do
      get root_path
      expect(response).to have_http_status(:ok)
    end
  end
end
