# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/users').to route_to('admin/users#index')
    end

    it 'routes to #new' do
      expect(get: '/admin/users/new').to route_to('admin/users#new')
    end

    it 'routes to #show' do
      expect(get: '/admin/users/1').to route_to('admin/users#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/admin/users/1/edit').to route_to('admin/users#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/admin/users').to route_to('admin/users#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/users/1').to route_to('admin/users#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/users/1').to route_to('admin/users#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/users/1').to route_to('admin/users#destroy', id: '1')
    end

    it 'routes to #activate' do
      expect(post: '/admin/users/1/activate').to route_to('admin/users#activate', id: '1')
    end

    it 'routes to #deactivate' do
      expect(post: '/admin/users/1/deactivate').to route_to('admin/users#deactivate', id: '1')
    end

    it 'routes to #translate' do
      expect(get: '/admin/users/1/translate').to route_to('admin/users#translate', id: '1')
    end

    it 'routes to #save_translation' do
      expect(post: '/admin/users/1/translate').to route_to('admin/users#save_translation', id: '1')
    end

    it 'routes to posts #index' do
      expect(get: '/admin/users/1/posts').to route_to('admin/posts#index', user_id: '1')
    end

    it 'routes to pages #index' do
      expect(get: '/admin/users/1/pages').to route_to('admin/pages#index', user_id: '1')
    end
  end
end
