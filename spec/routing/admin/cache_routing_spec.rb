# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::CacheController do
  describe 'routing' do
    it 'routes to #clear' do
      expect(post: '/admin/cache/clear').to route_to('admin/cache#clear')
    end
  end
end
