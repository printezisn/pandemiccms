# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::EmailTemplatesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/admin/email_templates').to route_to('admin/email_templates#index')
    end

    it 'routes to #show' do
      expect(get: '/admin/email_templates/1').to route_to('admin/email_templates#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/admin/email_templates/1/edit').to route_to('admin/email_templates#edit', id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/admin/email_templates/1').to route_to('admin/email_templates#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/admin/email_templates/1').to route_to('admin/email_templates#update', id: '1')
    end

    it 'routes to #translate' do
      expect(get: '/admin/email_templates/1/translate').to route_to('admin/email_templates#translate', id: '1')
    end

    it 'routes to #save_translation' do
      expect(post: '/admin/email_templates/1/translate').to route_to('admin/email_templates#save_translation', id: '1')
    end

    it 'routes to #test' do
      expect(post: '/admin/email_templates/1/test').to route_to('admin/email_templates#test', id: '1')
    end
  end
end
