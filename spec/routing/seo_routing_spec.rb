# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SeoController, type: :routing do
  describe 'routing' do
    it 'routes to #sitemap' do
      expect(get: '/sitemap.xml').to route_to('seo#sitemap', format: 'xml')
    end
  end
end
