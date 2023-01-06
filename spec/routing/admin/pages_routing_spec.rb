# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::PagesController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/pages').to route_to('admin/pages#index')
    end

    it 'routes to #tree' do
      expect(get: '/admin/pages/tree').to route_to('admin/pages#tree')
    end

    it 'routes to #new' do
      expect(get: '/admin/pages/new').to route_to('admin/pages#new')
    end

    it 'routes to #show' do
      expect(get: '/admin/pages/1').to route_to('admin/pages#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/admin/pages/1/edit').to route_to('admin/pages#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/admin/pages').to route_to('admin/pages#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/pages/1').to route_to('admin/pages#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/pages/1').to route_to('admin/pages#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/pages/1').to route_to('admin/pages#destroy', id: '1')
    end

    it 'routes to #translate' do
      expect(get: '/admin/pages/1/translate').to route_to('admin/pages#translate', id: '1')
    end

    it 'routes to #save_translation' do
      expect(post: '/admin/pages/1/translate').to route_to('admin/pages#save_translation', id: '1')
    end

    it 'routes to #search' do
      expect(get: '/admin/pages/search').to route_to('admin/pages#search')
    end

    it 'routes to #publish' do
      expect(post: '/admin/pages/1/publish').to route_to('admin/pages#publish', id: '1')
    end
  end
end
