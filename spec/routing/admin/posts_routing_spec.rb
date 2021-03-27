# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::PostsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/posts').to route_to('admin/posts#index')
    end

    it 'routes to #new' do
      expect(get: '/admin/posts/new').to route_to('admin/posts#new')
    end

    it 'routes to #show' do
      expect(get: '/admin/posts/1').to route_to('admin/posts#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/admin/posts/1/edit').to route_to('admin/posts#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/admin/posts').to route_to('admin/posts#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/posts/1').to route_to('admin/posts#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/posts/1').to route_to('admin/posts#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/posts/1').to route_to('admin/posts#destroy', id: '1')
    end

    it 'routes to #translate' do
      expect(get: '/admin/posts/1/translate').to route_to('admin/posts#translate', id: '1')
    end

    it 'routes to #save_translation' do
      expect(post: '/admin/posts/1/translate').to route_to('admin/posts#save_translation', id: '1')
    end

    it 'routes to #search' do
      expect(get: '/admin/posts/search').to route_to('admin/posts#search')
    end

    it 'routes to #publish' do
      expect(post: '/admin/posts/1/publish').to route_to('admin/posts#publish', id: '1')
    end
  end
end
