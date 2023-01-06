# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ProfileController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/profile').to route_to('admin/profile#index')
    end

    it 'routes to #edit' do
      expect(get: '/admin/profile/edit').to route_to('admin/profile#edit')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/profile/edit').to route_to('admin/profile#update')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/profile/edit').to route_to('admin/profile#update')
    end

    it 'routes to #translate' do
      expect(get: '/admin/profile/translate').to route_to('admin/profile#translate')
    end

    it 'routes to #save_translation' do
      expect(post: '/admin/profile/translate').to route_to('admin/profile#save_translation')
    end
  end
end
