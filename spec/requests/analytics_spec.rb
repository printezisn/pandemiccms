# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'analytics' do
  before { create(:client) }

  describe 'POST /analytics/track_visit' do
    let(:request) { post analytics_track_visit_path, params: { path: '/' } }

    it 'returns a successful response' do
      request
      expect(response).to be_successful
    end

    it 'creates a page visit event' do
      expect { request }.to change { Ahoy::Event.where(name: 'Page Visit').count }.by(1)
    end
  end
end
