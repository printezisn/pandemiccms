# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::MediaController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/media').to route_to('admin/media#index')
    end

    it 'routes to #create' do
      expect(post: '/admin/media').to route_to('admin/media#create')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/media/1').to route_to('admin/media#destroy', id: '1')
    end
  end
end
