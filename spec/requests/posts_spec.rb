# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'posts', type: :request do
  before { FactoryBot.create(:client) }

  describe 'GET /show' do
    it 'is successful' do
      get post_path(id: 1, slug: 'test')
      expect(response).to be_successful
    end
  end
end
