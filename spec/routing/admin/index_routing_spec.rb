# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::IndexController do
  describe 'routing' do
    it 'routes to #start' do
      expect(post: '/admin/index/start').to route_to('admin/index#start')
    end
  end
end
