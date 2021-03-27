# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/p/1/test').to route_to('posts#show', id: '1', slug: 'test')
    end
  end
end
