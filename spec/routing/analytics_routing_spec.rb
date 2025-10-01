# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnalyticsController do
  describe 'routing' do
    it 'routes to #track_visit' do
      expect(post: '/analytics/track_visit').to route_to('analytics#track_visit')
    end
  end
end
