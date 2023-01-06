# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ProfileController do
  describe 'routing' do
    it 'routes to #edit' do
      expect(get: '/admin/password/edit').to route_to('admin/password#edit')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/password/edit').to route_to('admin/password#update')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/password/edit').to route_to('admin/password#update')
    end
  end
end
