# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::MenuItemsController do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/admin/menus/1/menu_items/new').to route_to('admin/menu_items#new', menu_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/admin/menus/1/menu_items/2').to route_to('admin/menu_items#show', menu_id: '1', id: '2')
    end

    it 'routes to #edit' do
      expect(get: '/admin/menus/1/menu_items/2/edit').to route_to('admin/menu_items#edit', menu_id: '1', id: '2')
    end

    it 'routes to #create' do
      expect(post: '/admin/menus/1/menu_items').to route_to('admin/menu_items#create', menu_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/menus/1/menu_items/2').to route_to('admin/menu_items#update', menu_id: '1', id: '2')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/menus/1/menu_items/2').to route_to('admin/menu_items#update', menu_id: '1', id: '2')
    end

    it 'routes to #destroy' do
      expect(delete: '/admin/menus/1/menu_items/2').to route_to('admin/menu_items#destroy', menu_id: '1', id: '2')
    end

    it 'routes to #translate' do
      expect(get: '/admin/menus/1/menu_items/2/translate').to route_to('admin/menu_items#translate', menu_id: '1', id: '2')
    end

    it 'routes to #save_translation' do
      expect(post: '/admin/menus/1/menu_items/2/translate').to route_to('admin/menu_items#save_translation', menu_id: '1', id: '2')
    end
  end
end
