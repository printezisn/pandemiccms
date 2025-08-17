# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ContentsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/contents').to route_to('admin/contents#index')
    end

    it 'routes to #new' do
      expect(get: '/admin/contents/new').to route_to('admin/contents#new')
    end

    it 'routes to #show' do
      expect(get: '/admin/contents/1').to route_to('admin/contents#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/admin/contents/1/edit').to route_to('admin/contents#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/admin/contents').to route_to('admin/contents#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/contents/1').to route_to('admin/contents#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/contents/1').to route_to('admin/contents#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/contents/1').to route_to('admin/contents#destroy', id: '1')
    end

    it 'routes to #translate' do
      expect(get: '/admin/contents/1/translate').to route_to('admin/contents#translate', id: '1')
    end

    it 'routes to #save_translation' do
      expect(post: '/admin/contents/1/translate').to route_to('admin/contents#save_translation', id: '1')
    end
  end
end
