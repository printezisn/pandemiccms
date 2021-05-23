# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::RedirectsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/redirects').to route_to('admin/redirects#index')
    end

    it 'routes to #new' do
      expect(get: '/admin/redirects/new').to route_to('admin/redirects#new')
    end

    it 'routes to #show' do
      expect(get: '/admin/redirects/1').to route_to('admin/redirects#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/admin/redirects/1/edit').to route_to('admin/redirects#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/admin/redirects').to route_to('admin/redirects#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/redirects/1').to route_to('admin/redirects#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/redirects/1').to route_to('admin/redirects#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/redirects/1').to route_to('admin/redirects#destroy', id: '1')
    end
  end
end
