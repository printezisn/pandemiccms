# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/').to route_to('pages#index')
    end

    it 'routes to #show' do
      expect(get: '/pg/1/test').to route_to('pages#show', id: '1', slug: 'test')
    end
  end
end
