# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'tags', type: :request do
  before { FactoryBot.create(:client) }

  describe 'GET /show' do
    it 'is successful' do
      get tag_path(id: 1, slug: 'test')
      expect(response).to have_http_status(:ok)
    end
  end
end
