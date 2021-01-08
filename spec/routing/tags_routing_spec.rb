# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/t/1/test').to route_to('tags#show', id: '1', slug: 'test')
    end
  end
end
