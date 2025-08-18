# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::DashboardController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin').to route_to('admin/dashboard#index')
    end

    it 'routes to #page_visits' do
      expect(get: '/admin/dashboard/page_visits').to route_to('admin/dashboard#page_visits')
    end
  end
end
