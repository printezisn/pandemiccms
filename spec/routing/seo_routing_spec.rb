# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SeoController do
  describe 'routing' do
    it 'routes to #sitemap' do
      expect(get: '/sitemap.xml').to route_to('seo#sitemap', format: 'xml')
    end

    it 'routes to #robots' do
      expect(get: '/robots.txt').to route_to('seo#robots', format: 'text')
    end
  end
end
