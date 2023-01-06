# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SuperAdmin::ClientsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/super_admin/clients').to route_to('super_admin/clients#index')
    end

    it 'routes to #new' do
      expect(get: '/super_admin/clients/new').to route_to('super_admin/clients#new')
    end

    it 'routes to #show' do
      expect(get: '/super_admin/clients/1').to route_to('super_admin/clients#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/super_admin/clients/1/edit').to route_to('super_admin/clients#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/super_admin/clients').to route_to('super_admin/clients#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/super_admin/clients/1').to route_to('super_admin/clients#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/super_admin/clients/1').to route_to('super_admin/clients#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/super_admin/clients/1').to route_to('super_admin/clients#destroy', id: '1')
    end
  end
end
